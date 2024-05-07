import '../../../models/metadata/program.dart';
import '../../../services/client/client.dart';
import '../../../utils/sync_status.dart';
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
      D2ClientService client, List<String> programIds) {
    this.programIds = programIds;
    setClient(client);
    setFilters(["id:in:[${programIds.join(",")}]"]);
    return this;
  }

  syncMeta(key, value) {
    switch (key) {
      case "dataElements":
        return D2DataElementRepository(db).saveOffline(value);
      case "options":
        return D2OptionRepository(db).saveOffline(value);
      case "optionSets":
        return D2OptionSetRepository(db).saveOffline(value);
      case "programRuleVariables":
        return D2ProgramRuleVariableRepository(db).saveOffline(value);
      case "programTrackedEntityAttributes":
        return D2ProgramTrackedEntityAttributeRepository(db).saveOffline(value);
      case "programStageDataElements":
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
        return D2ProgramRuleRepository(db).saveOffline(value);
      case "legends":
        return D2LegendRepository(db).saveOffline(value);
      case "legendSets":
        return D2LegendSetRepository(db).saveOffline(value);
      case "programSections":
        return D2ProgramSectionRepository(db).saveOffline(value);
      case "programStageSections":
        return D2ProgramStageSectionRepository(db).saveOffline(value);
    }
  }

  List<String> sortOrder = [
    "optionSets",
    "options",
    "legendSets",
    "legends",
    "dataElements",
    "trackedEntityAttributes",
    "trackedEntityTypes",
    "programs",
    "programRuleVariables",
    "programRules",
    "programRuleActions",
    "programTrackedEntityAttributes",
    "programSections",
    "programStages",
    "programStageDataElements",
    "programStageSections",
  ];

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
        (a, b) => sortOrder.indexOf(a.key).compareTo(sortOrder.indexOf(b.key)));

    await Future.forEach(metadataEntries,
        (MapEntry<String, dynamic> element) async {
      if (element.key == "system") {
        return;
      }

      List<Map<String, dynamic>> value =
          element.value.cast<Map<String, dynamic>>();

      await getLegendSets(value);

      await syncMeta(element.key, value);
    });
  }

  @override
  Future initializeDownload() async {
    try {
      D2SyncStatus status = D2SyncStatus(
          synced: 0,
          total: programIds.length,
          status: D2SyncStatusEnum.syncing,
          label: label);
      downloadController.add(status);
      for (final programId in programIds) {
        await syncProgram(programId);
        downloadController.add(status.increment());
      }
      downloadController.add(status.complete());
      downloadController.close();
    } catch (e) {
      downloadController.addError(e);
      rethrow;
    }
  }

  getLegendSets(List<Map<String, dynamic>> value) async {
    List<String> legendSetIds = [];
    for (Map<String, dynamic> entry in value) {
      if (entry['legendSets'] != null) {
        legendSetIds.addAll(entry['legendSets']
            .map<String>((legendSet) => legendSet['id'] as String));
      }
    }
    if (legendSetIds.isNotEmpty) {
      Map<String, dynamic>? legendSets = await client!
          .httpGet<Map<String, dynamic>>("legendSets", queryParameters: {
        'filter': 'id:in:[${legendSetIds.join(",")}]',
        'fields': '*,legends[*]'
      });
      if (legendSets != null) {
        await D2LegendSetRepository(db)
            .saveOffline(legendSets['legendSets'].cast<Map<String, dynamic>>());
      }
    }
  }
}
