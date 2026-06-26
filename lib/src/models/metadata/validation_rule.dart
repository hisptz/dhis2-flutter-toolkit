import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/metadata/validation_rule.dart';
import './base.dart';
import 'data_set.dart';

@Entity()
class D2ValidationRule extends D2MetaResource {
  @override
  int id = 0;

  @Unique()
  @override
  String uid;

  DateTime created;
  DateTime lastUpdated;

  String name;
  String? description;
  String? instruction;

  String importance;
  String operator;
  String? periodType;
  bool skipFormValidation;

  String leftSideExpression;
  String? leftSideDescription;
  String leftSideMissingValueStrategy;
  bool leftSideSlidingWindow;

  String rightSideExpression;
  String? rightSideDescription;
  String rightSideMissingValueStrategy;
  bool rightSideSlidingWindow;

  final dataSets = ToMany<D2DataSet>();

  D2ValidationRule(
    this.id,
    this.uid,
    this.created,
    this.lastUpdated,
    this.name,
    this.description,
    this.instruction,
    this.importance,
    this.operator,
    this.periodType,
    this.skipFormValidation,
    this.leftSideExpression,
    this.leftSideDescription,
    this.leftSideMissingValueStrategy,
    this.leftSideSlidingWindow,
    this.rightSideExpression,
    this.rightSideDescription,
    this.rightSideMissingValueStrategy,
    this.rightSideSlidingWindow,
  );

  D2ValidationRule.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(
            json['created'] ?? json['createdAt'] ?? DateTime.now().toIso8601String()),
        lastUpdated = DateTime.parse(
            json['lastUpdated'] ?? json['updatedAt'] ?? DateTime.now().toIso8601String()),
        uid = json['id'],
        name = json['name'],
        description = json['description'],
        instruction = json['instruction'],
        importance = json['importance'] ?? 'MEDIUM',
        operator = json['operator'] ?? 'equal_to',
        periodType = json['periodType'],
        skipFormValidation = json['skipFormValidation'] ?? false,
        leftSideExpression = json['leftSide']?['expression'] ?? '',
        leftSideDescription = json['leftSide']?['description'],
        leftSideMissingValueStrategy =
            json['leftSide']?['missingValueStrategy'] ?? 'SKIP_IF_ALL_VALUES_MISSING',
        leftSideSlidingWindow = json['leftSide']?['slidingWindow'] ?? false,
        rightSideExpression = json['rightSide']?['expression'] ?? '',
        rightSideDescription = json['rightSide']?['description'],
        rightSideMissingValueStrategy =
            json['rightSide']?['missingValueStrategy'] ?? 'SKIP_IF_ALL_VALUES_MISSING',
        rightSideSlidingWindow = json['rightSide']?['slidingWindow'] ?? false {
    id = D2ValidationRuleRepository(db).getIdByUid(json['id']) ?? 0;
  }
}
