///Copyright (c) 2024, HISP Tanzania Developers.
///All rights reserved. Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.

library;

//
///`Dhis2Variables` is a collection of DHIS2 supported variables
//

class Dhis2Variables {
  //
  ///`Dhis2Variables.getStandardVariables()` is the function that returns the list of standard variables supported by DHIS2
  //
  static List<String> getStandardVariables() {
    return [
      currentDate,
      eventDate,
      dueDate,
      enrollmentDate,
      incidentDate,
      completedDate,
      eventStatus,
      eventCount,
      enrollmentId,
      eventId,
      orgUnitCode,
      programStageId,
      programStageName
    ];
  }

  static String currentDate = 'current_date';
  static String eventDate = 'event_date';
  static String eventStatus = 'event_status';
  static String dueDate = 'due_date';
  static String eventCount = 'event_count';
  static String enrollmentDate = 'enrollment_date';
  static String incidentDate = 'incident_date';
  static String enrollmentId = 'enrollment_id';
  static String eventId = 'event_id';
  static String orgUnitCode = 'orgunit_code';
  static String programStageId = 'program_stage_id';
  static String programStageName = 'program_stage_name';
  static String completedDate = 'completed_date';
}
