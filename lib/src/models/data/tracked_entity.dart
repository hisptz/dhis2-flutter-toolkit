import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/models/data/base_deletable.dart';
import 'package:dhis2_flutter_toolkit/src/models/data/base_editable.dart';
import 'package:objectbox/objectbox.dart';

import 'base.dart';
import 'upload_base.dart';

@Entity()

/// This class represents a tracked entity within the system.
class D2TrackedEntity extends SyncDataSource
    implements SyncableData, D2BaseEditable, D2BaseDeletable {
  @override
  @override
  int id = 0;

  /// The date and time when the tracked entity was created.
  @override
  DateTime createdAt;

  /// The date and time when the tracked entity was last updated.
  @override
  DateTime updatedAt;

  /// The unique UID for the tracked entity.
  @override
  @Unique()
  String uid;

  /// Indicates whether the tracked entity is marked as a potential duplicate.
  bool potentialDuplicate;

  /// Indicates whether the tracked entity is marked as deleted.
  bool deleted;

  /// Indicates whether the tracked entity is marked as inactive.
  bool inactive;

  /// The geometry associated with the tracked entity.
  String? geometry;

  /// A list of enrollments associated with the tracked entity.
  @Backlink("trackedEntity")
  final enrollments = ToMany<D2Enrollment>();

  /// A list of enrollments used for querying purposes.
  final enrollmentsForQuery = ToMany<D2Enrollment>();

  /// A list of relationships associated with the tracked entity.
  @Backlink("fromTrackedEntity")
  final relationships = ToMany<D2Relationship>();

  /// A list of relationships used for querying purposes.
  final relationshipsForQuery = ToMany<D2Relationship>();

  /// The organizational unit associated with the tracked entity.
  final orgUnit = ToOne<D2OrgUnit>();

  /// A list of attributes associated with the tracked entity.
  @Backlink("trackedEntity")
  final attributes = ToMany<D2TrackedEntityAttributeValue>();

  /// A list of attributes used for querying purposes.
  final attributesForQuery = ToMany<D2TrackedEntityAttributeValue>();

  /// The type of tracked entity.
  final trackedEntityType = ToOne<D2TrackedEntityType>();

  /// A list of events associated with the tracked entity.
  @Backlink("trackedEntity")
  final events = ToMany<D2Event>();

  /// Constructs a [D2TrackedEntity] instance with the specified properties.
  ///
  /// - [uid] The unique identifier of the tracked entity.
  /// - [createdAt] The date and time when the tracked entity was created.
  /// - [updatedAt] The date and time when the tracked entity was last updated.
  /// - [deleted] Indicates whether the tracked entity is marked as deleted.
  /// - [potentialDuplicate] Indicates whether the tracked entity is identified
  ///   as a potential duplicate.
  /// - [inactive] Indicates whether the tracked entity is inactive.
  /// - [synced] Indicates whether the tracked entity data has been synchronized
  ///   with the remote server.
  /// - [geometry] Optional geographical information associated with the tracked entity.
  D2TrackedEntity(this.uid, this.createdAt, this.updatedAt, this.deleted,
      this.potentialDuplicate, this.inactive, this.synced, this.geometry);

  /// Constructs a [D2TrackedEntity] instance from a map.
  ///
  /// - [db] is the database instance.
  /// - [json] is the map containing the data.
  D2TrackedEntity.fromMap(D2ObjectBox db, Map json)
      : uid = json["trackedEntity"],
        createdAt = DateTime.parse(json["createdAt"]),
        updatedAt = DateTime.parse(json["updatedAt"]),
        deleted = json["deleted"],
        synced = true,
        potentialDuplicate = json["potentialDuplicate"],
        geometry =
            json["geometry"] != null ? jsonEncode(json["geometry"]) : null,
        inactive = json["inactive"] {
    id = D2TrackedEntityRepository(db).getIdByUid(json["trackedEntity"]) ?? 0;
    orgUnit.target = D2OrgUnitRepository(db).getByUid(json["orgUnit"]);
    trackedEntityType.target =
        D2TrackedEntityTypeRepository(db).getByUid(json["trackedEntityType"]);
  }

  /// Constructs a [D2TrackedEntity] instance from form values.
  ///
  /// This constructor is used for creating a new tracked entity based on form inputs.
  ///
  /// - [values] A map containing the form values.
  /// - [db] The [D2ObjectBox] instance required for database operations.
  /// - [program] The [D2Program] instance to which the tracked entity belongs.
  /// - [orgUnit] The [D2OrgUnit] instance representing the organizational unit.
  /// - [enroll] A boolean indicating whether to enroll the tracked entity in the program.
  ///   Defaults to `true`.
  ///
  /// Initializes the [createdAt] and [updatedAt] fields to the current date and time,
  /// sets [potentialDuplicate], [deleted], [synced], and [inactive] to default values,
  /// and generates a new UID for the tracked entity.
  ///
  /// Populates the tracked entity's attributes, geometry, and enrollments based on
  /// the provided form values and program configuration.
  D2TrackedEntity.fromFormValues(Map<String, dynamic> values,
      {required D2ObjectBox db,
      required D2Program program,
      required D2OrgUnit orgUnit,
      bool enroll = true})
      : createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        potentialDuplicate = false,
        deleted = false,
        synced = false,
        inactive = false,
        uid = D2UID.generate() {
    this.orgUnit.target = orgUnit;
    trackedEntityType.target = program.trackedEntityType.target;

    List<D2TrackedEntityAttribute> trackedEntityAttributes = program
        .programTrackedEntityAttributes
        .map((pAttribute) => pAttribute.trackedEntityAttribute.target!)
        .toList();

    List<D2TrackedEntityAttributeValue?> attributeValues =
        trackedEntityAttributes.map((teiAttribute) {
      String? value = values[teiAttribute.uid];
      return D2TrackedEntityAttributeValue.fromFormValues(value,
          db: db, trackedEntity: this, trackedEntityAttribute: teiAttribute);
    }).toList();

    List<D2TrackedEntityAttributeValue> attributeWithValues = attributeValues
        .where((element) => element != null)
        .toList()
        .cast<D2TrackedEntityAttributeValue>();
    attributes.addAll([...attributeWithValues]);

    if (values["geometry"] != null) {
      var geometryValue = values["geometry"];

      ///A form has geometry. This should be inserted as a serialized JSON
      if (geometryValue is D2GeometryValue) {
        Map<String, dynamic> geometry = geometryValue.toGeoJson();
        String geometryString = jsonEncode(geometry);
        this.geometry = geometryString;
      }
    }

    if (enroll) {
      D2Enrollment enrollment = D2Enrollment.fromFormValues(values,
          db: db, trackedEntity: this, program: program, orgUnit: orgUnit);
      enrollments.add(enrollment);
    }
  }

  /// Indicates Whether the tracked entity is synced with the server.
  @override
  bool synced;

  /// Converts the [D2TrackedEntity] instance  to a map of JSON values.
  ///
  /// - [db] is the database instance.
  @override
  Future<Map<String, dynamic>> toMap({D2ObjectBox? db}) async {
    if (db == null) {
      throw "ObjectBox instance is required";
    }

    List<Map<String, dynamic>> attributesPayload = await Future.wait(attributes
        .map<Future<Map<String, dynamic>>>((e) => e.toMap(db: db))
        .toList());

    Map<String, dynamic> payload = {
      "orgUnit": orgUnit.target!.uid,
      "trackedEntity": uid,
      "trackedEntityType": trackedEntityType.target!.uid,
      "attributes": attributesPayload,
    };
    if (geometry != null) {
      payload.addAll({"geometry": jsonDecode(geometry!)});
    }

    return payload;
  }

  /// Retrieves a list of tracked entity attributes specific to a given program.
  ///
  /// - [program] The [D2Program] instance whose attributes are to be retrieved.
  ///
  /// This method filters the tracked entity's attributes to include only those
  /// that are associated with the specified [program].
  ///
  /// The method first collects the UIDs of the program's tracked entity attributes,
  /// then filters the tracked entity's attributes to include only those with matching UIDs.
  ///
  /// Returns a list of [D2TrackedEntityAttributeValue] objects that are associated
  /// with the attributes of the given program.
  List<D2TrackedEntityAttributeValue> getAttributesByProgram(
      D2Program program) {
    List<String> programAttributes = program.programTrackedEntityAttributes
        .map((pAttribute) => pAttribute.trackedEntityAttribute.target!.uid)
        .toList();

    return attributes
        .where((element) => programAttributes
            .contains(element.trackedEntityAttribute.target!.uid))
        .toList();
  }

  /// Converts the [D2TrackedEntity] instance to form values.
  ///
  /// This is used for converting the tracked entity data to a format suitable for forms.
  @override
  Map<String, dynamic> toFormValues() {
    Map<String, dynamic> data = {
      "orgUnit": orgUnit.target!.uid,
      "attributes":
          attributes.map((attribute) => attribute.toFormValues()).toList()
    };

    if (geometry != null) {
      Map<String, dynamic> geometryObject = jsonDecode(geometry!);
      data.addAll({"geometry": D2GeometryValue.fromGeoJson(geometryObject)});
    }

    return data;
  }

  /// Updates the tracked entity's attributes based on the provided form values.
  ///
  /// This method updates the tracked entity's attributes to match the values provided
  /// in the [values] map for the specified [program]. If an attribute already exists,
  /// its value is updated. If it does not exist, a new attribute value is created and added.
  ///
  /// - [program] The [D2Program] instance whose attributes are being updated.
  /// - [values] A map containing the new values for the attributes.
  /// - [db] The [D2ObjectBox] instance used to manage the database operations.
  void updateAttributes(
      {required D2Program program,
      required Map<String, dynamic> values,
      required D2ObjectBox db}) {
    for (D2ProgramTrackedEntityAttribute attribute
        in program.programTrackedEntityAttributes) {
      String attributeId = attribute.trackedEntityAttribute.target!.uid;
      D2TrackedEntityAttributeValue? attributeValue =
          attributes.firstWhereOrNull((element) =>
              element.trackedEntityAttribute.target?.uid == attributeId);
      if (attributeValue != null) {
        attributeValue.updateFromFormValues(values, db: db);
        continue;
      }
      D2TrackedEntityAttributeValue newAttributeValue =
          D2TrackedEntityAttributeValue.fromFormValues(values[attributeId],
              db: db,
              trackedEntity: this,
              trackedEntityAttribute: attribute.trackedEntityAttribute.target!);

      attributes.add(newAttributeValue);
    }
  }

  /// Updates the tracked entity's attributes and geometry from the provided form values.
  ///
  /// - [values] A map containing the new values for the tracked entity's attributes and geometry.
  /// - [db] The [D2ObjectBox] instance used to manage the database operations.
  /// - [program] A optional [D2Program] instance whose attributes are being updated.
  /// - [orgUnit] An optional [D2OrgUnit] instance for updating the organizational unit.
  ///
  /// This method updates the tracked entity's attributes and geometry based on the values
  /// provided in the [values] map for the specified [program]. The [orgUnit] parameter is
  /// optional and can be used if needed. The tracked entity is marked as not synced after
  /// the update.
  @override
  void updateFromFormValues(Map<String, dynamic> values,
      {required D2ObjectBox db, D2Program? program, D2OrgUnit? orgUnit}) {
    if (program == null) {
      throw "Program is required to edit a tracked entity";
    }

    updateAttributes(program: program, values: values, db: db);

    if (values["geometry"] != null) {
      var geometryValue = values["geometry"];

      ///A form has geometry. This should be inserted as a serialized JSON
      if (geometryValue is D2GeometryValue) {
        Map<String, dynamic> geometry = geometryValue.toGeoJson();
        String geometryString = jsonEncode(geometry);
        this.geometry = geometryString;
      }
    }

    synced = false;
  }

  /// Saves the tracked entity and its attributes to the database.
  ///
  /// This method persists the tracked entity to the database. If the entity is new (i.e.,
  /// its [id] is 0), it will be saved as a new entity, and its [id] will be updated with
  /// the generated ID. If the entity already exists (i.e., its [id] is not 0), the entity
  /// will be updated in the database, and all its attributes will also be saved.
  ///
  /// - [db] The [D2ObjectBox] instance used to manage the database operations.
  @override
  void save(D2ObjectBox db) {
    if (id == 0) {
      id = D2TrackedEntityRepository(db).saveEntity(this);
    } else {
      D2TrackedEntityRepository(db).saveEntity(this);
      for (D2TrackedEntityAttributeValue attribute in attributes) {
        attribute.save(db);
      }
    }
  }

  /// Retrieves the active enrollment for a specific program.
  ///
  /// - [program] The [D2Program] instance to match against the tracked entity's enrollments.
  ///
  /// Returns the first matching [D2Enrollment] if found, or `null` if no matching
  /// enrollment is found.
  D2Enrollment? getActiveEnrollmentByProgram(D2Program program) {
    return enrollments.firstWhereOrNull(
        (enrollment) => enrollment.program.target?.id == program.id);
  }

  /// Soft deletes the tracked entity and its related entities.
  ///
  /// This method marks the tracked entity as deleted by setting the [deleted]
  /// property to `true`. It then proceeds to soft delete all associated relationships
  /// and enrollments by invoking their `softDelete` methods. Finally, it saves the
  /// updated state of the tracked entity to the database.
  ///
  /// - [db] The [D2ObjectBox] instance used for database operations.
  @override
  void softDelete(db) {
    deleted = true;
    for (D2Relationship relationship in relationships) {
      relationship.softDelete(db);
    }
    //Delete enrollments
    for (D2Enrollment enrollment in enrollments) {
      enrollment.softDelete(db);
    }
    save(db);
  }

  /// This method deletes the tracked entity and its associated entities from the database.
  ///
  /// - [db] The [D2ObjectBox] instance used for database operations.
  ///
  /// Returns [bool] whether the tracked entity was successfully deleted.
  @override
  bool delete(D2ObjectBox db) {
    D2TrackedEntityAttributeValueRepository(db).deleteEntities(attributes);

    for (D2Relationship relationship in relationships) {
      relationship.delete(db);
    }
    //Delete enrollments
    for (D2Enrollment enrollment in enrollments) {
      enrollment.delete(db);
    }

    return D2TrackedEntityRepository(db).deleteEntity(this);
  }
}
