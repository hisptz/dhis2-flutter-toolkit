import 'package:dhis2_flutter_toolkit/src/models/metadata/sharing.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/metadata/option_group.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/metadata/option_group_set.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/metadata/sharing.dart';
import 'package:flutter/foundation.dart';

import '../../../models/app/entry.dart';
import '../../../models/metadata/program.dart';
import '../../../services/client/client.dart';
import '../../../utils/sync_status.dart';
import '../../app/entry.dart';
import '../data_element.dart';
import '../legend.dart';
import '../legend_set.dart';
import '../option.dart';
import '../option_set.dart';
import '../program.dart';
import '../program_rule.dart';
import '../program_rule_action.dart';
import '../program_rule_variable.dart';
import '../program_section.dart';
import '../program_stage.dart';
import '../program_stage_data_element.dart';
import '../program_stage_section.dart';
import '../program_tracked_entity_attribute.dart';
import '../tracked_entity_attribute.dart';
import '../tracked_entity_type.dart';
import 'base_meta_download_mixin.dart';

mixin D2ProgramDownloadServiceMixin on BaseMetaDownloadServiceMixin<D2Program> {
  late List<String> programIds;

  @override
  String label = "Programs";

  @override
  String resource = "programs";

  D2ProgramDownloadServiceMixin setupDownload(
    D2ClientService client,
    List<String> programIds,
  ) {
    this.programIds = programIds;
    setClient(client);
    setFilters(["id:in:[${programIds.join(",")}]"]);
    return this;
  }

  syncMeta(key, value, {required String programId}) async {
    try {
      switch (key) {
        case "dataElements":
          return D2DataElementRepository(db).saveOffline(value);
        case "options":
          return D2OptionRepository(db).saveOffline(value);
        case "optionSets":
          return D2OptionSetRepository(db).saveOffline(value);
        case "optionGroups":
          return D2OptionGroupRepository(db).saveOffline(value);
        case "programRuleVariables":
          return D2ProgramRuleVariableRepository(db).saveOffline(value);
        case "programTrackedEntityAttributes":
          await D2ProgramTrackedEntityAttributeRepository(
            db,
          ).deleteByProgram(programId);
          return D2ProgramTrackedEntityAttributeRepository(
            db,
          ).saveOffline(value);
        case "programStageDataElements":
          await D2ProgramStageDataElementRepository(
            db,
          ).deleteProgramStageDataElementsByProgram(programId);
          return D2ProgramStageDataElementRepository(db).saveOffline(value);
        case "programStages":
          return D2ProgramStageRepository(db).saveOffline(value);
        case "programRuleActions":
          return D2ProgramRuleActionRepository(db).saveOffline(value);
        case "trackedEntityAttributes":
          return D2TrackedEntityAttributeRepository(db).saveOffline(value);
        case "trackedEntityTypes":
          return D2TrackedEntityTypeRepository(db).saveOffline(value);
        case "programs":
          return D2ProgramRepository(db).saveOffline(value);
        case "programRules":
          return await D2ProgramRuleRepository(db).saveOffline(value);
        case "legends":
          return D2LegendRepository(db).saveOffline(value);
        case "legendSets":
          return D2LegendSetRepository(db).saveOffline(value);
        case "programSections":
          await D2ProgramSectionRepository(
            db,
          ).deleteProgramSectionsByProgram(programId);
          return await D2ProgramSectionRepository(db).saveOffline(value);
        case "programStageSections":
          await D2ProgramStageSectionRepository(
            db,
          ).deleteProgramStageSectionsByProgram(programId);
          return await D2ProgramStageSectionRepository(db).saveOffline(value);
      }
    } catch (e, stackTrace) {
      D2AppLog errorLog = D2AppLog.log(
        code: 400,
        message: '$e',
        process: 'METADATA_DOWNLOAD_ERROR - $key',
        stackTrace: stackTrace.toString(),
      );
      D2AppLogRepository(db).box.put(errorLog);
      rethrow;
    }
  }

  List<String> sortOrder = [
    "optionSets",
    "options",
    "legendSets",
    "legends",
    "optionGroups",
    "dataElements",
    "trackedEntityAttributes",
    "trackedEntityTypes",
    "programs",
    "programRuleVariables",
    "programTrackedEntityAttributes",
    "programSections",
    "programStages",
    "programStageDataElements",
    "programStageSections",
    "programRules",
    "programRuleActions",
  ];

  Future<List<D2Sharing>> saveSharingSettings(
    List<Map<String, dynamic>> objects,
  ) async {
    try {
      return D2SharingRepository(db).saveOffline(objects);
    } catch (e, stackTrace) {
      D2AppLog errorLog = D2AppLog.log(
        code: 400,
        message: '$e',
        process: 'METADATA_DOWNLOAD_ERROR',
        stackTrace: stackTrace.toString(),
      );
      D2AppLogRepository(db).box.put(errorLog);
      if (kDebugMode) {
        print(e);
        print(stackTrace.toString());
      }
      return [];
    }
  }

  Future<void> syncProgram(String programId) async {
    Map<String, dynamic>? programMetadata = await client!
        .httpGet<Map<String, dynamic>>("programs/$programId/metadata");

    if (programMetadata == null) {
      throw "Error getting program $programId";
    }

    List<MapEntry<String, dynamic>> metadataEntries = programMetadata.entries
        .where((element) => sortOrder.contains(element.key))
        .toList();
    metadataEntries.sort(
      (a, b) => sortOrder.indexOf(a.key).compareTo(sortOrder.indexOf(b.key)),
    );

    await Future.forEach(metadataEntries, (
      MapEntry<String, dynamic> element,
    ) async {
      if (element.value == null) {
        return;
      }
      if (element.key == "system") {
        return;
      }

      List<Map<String, dynamic>> value = element.value
          .cast<Map<String, dynamic>>();

      await getLegendSets(value);
      await syncMeta(element.key, value, programId: programId);

      if (["programs", "programStages"].contains(element.key)) {
        await saveSharingSettings(value);
      }
    });
    if (programMetadata['programTrackedEntityAttributes'] == null) {
      List<Map<String, dynamic>>? programTrackedEntityAttributes =
          programMetadata['programs'][0]['programTrackedEntityAttributes']
              .cast<Map<String, dynamic>>();
      if (programTrackedEntityAttributes != null) {
        //We need to check if the payload is valid
        Map<String, dynamic>? testAttribute =
            programTrackedEntityAttributes.firstOrNull;
        if (testAttribute != null) {
          if (testAttribute.keys.length > 1) {
            await syncMeta(
              'programTrackedEntityAttributes',
              programTrackedEntityAttributes,
              programId: programId,
            );
          }
        }
      }
    }
    if (programMetadata["optionSets"] != null) {
      await getOptionGroup(
        programMetadata['optionSets'].cast<Map<String, dynamic>>(),
      );

      await getOptionGroupSets(
        programMetadata['optionSets'].cast<Map<String, dynamic>>(),
      );
    }
  }

  @override
  Future initializeDownload() async {
    try {
      D2SyncStatus status = D2SyncStatus(
        synced: 0,
        total: programIds.length,
        status: D2SyncStatusEnum.syncing,
        label: label,
      );
      downloadController.add(status);
      for (final programId in programIds) {
        try {
          await syncProgram(programId);
          downloadController.add(status.increment());
        } catch (e, stackTrace) {
          //TODO: Add a way to be notified when a program download fails
          D2AppLog errorLog = D2AppLog.log(
            code: 400,
            message: '$e',
            process: 'METADATA_DOWNLOAD_ERROR',
            stackTrace: stackTrace.toString(),
          );
          D2AppLogRepository(db).box.put(errorLog);
          if (kDebugMode) {
            print(e);
            print(stackTrace.toString());
            print(
              "Error downloading program: $programId. There is a TODO above this line. Work on it",
            );
          }
          downloadController.add(status.increment());
        }
      }
      downloadController.add(status.complete());
      await downloadController.close();
    } catch (e) {
      downloadController.addError(e);
      rethrow;
    }
  }

  getLegendSets(List<Map<String, dynamic>> value) async {
    List<String> legendSetIds = [];
    for (Map<String, dynamic> entry in value) {
      if (entry['legendSets'] != null) {
        legendSetIds.addAll(
          entry['legendSets'].map<String>(
            (legendSet) => legendSet['id'] as String,
          ),
        );
      }
    }
    if (legendSetIds.isNotEmpty) {
      Map<String, dynamic>? legendSets = await client!
          .httpGet<Map<String, dynamic>>(
            "legendSets",
            queryParameters: {
              'filter': 'id:in:[${legendSetIds.join(",")}]',
              'fields': '*,legends[*]',
            },
          );
      if (legendSets != null) {
        await D2LegendSetRepository(
          db,
        ).saveOffline(legendSets['legendSets'].cast<Map<String, dynamic>>());
      }
    }
  }

  getOptionGroupSets(List<Map<String, dynamic>> optionSets) async {
    try {
      List<String> optionSetIds = optionSets
          .map<String>((optionSet) => optionSet['id'])
          .toList();
      if (optionSetIds.isNotEmpty) {
        Map<String, dynamic>? optionGroupSets = await client!
            .httpGet<Map<String, dynamic>>(
              "optionGroupSets",
              queryParameters: {
                'filter': 'optionSet.id:in:[${optionSetIds.join(",")}]',
                'fields': '*',
                'paging': 'false',
              },
            );

        if (optionGroupSets != null) {
          await D2OptionGroupSetRepository(db).saveOffline(
            optionGroupSets['optionGroupSets'].cast<Map<String, dynamic>>(),
          );
        }
      }
    } catch (e, stackTrace) {
      D2AppLog errorLog = D2AppLog.log(
        code: 400,
        message: '$e',
        process: 'METADATA_DOWNLOAD_ERROR',
        stackTrace: stackTrace.toString(),
      );
      D2AppLogRepository(db).box.put(errorLog);
      if (kDebugMode) {
        print(e);
        print(stackTrace.toString());
      }
    }
  }

  getOptionGroup(List<Map<String, dynamic>> optionSets) async {
    try {
      List<String> optionSetIds = optionSets
          .map<String>((optionSet) => optionSet['id'])
          .toList();
      if (optionSetIds.isNotEmpty) {
        Map<String, dynamic>? optionGroups = await client!
            .httpGet<Map<String, dynamic>>(
              "optionGroups",
              queryParameters: {
                'filter': 'optionSet.id:in:[${optionSetIds.join(",")}]',
                'fields': '*',
                'paging': 'false',
              },
            );
        if (optionGroups != null) {
          await D2OptionGroupRepository(db).saveOffline(
            optionGroups['optionGroups'].cast<Map<String, dynamic>>(),
          );
        }
      }
    } catch (e, stackTrace) {
      D2AppLog errorLog = D2AppLog.log(
        code: 400,
        message: '$e',
        process: 'METADATA_DOWNLOAD_ERROR',
        stackTrace: stackTrace.toString(),
      );
      D2AppLogRepository(db).box.put(errorLog);
      if (kDebugMode) {
        print(e);
        print(stackTrace.toString());
      }
    }
  }
}
