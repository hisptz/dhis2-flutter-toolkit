///Copyright (c) 2024, HISP Tanzania Developers.
///All rights reserved. Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.

library;

///
///`ProgramRuleVariables` is a collection of program rule variables supported by the Library
///
class ProgramRuleVariableSourceTypes {
  static const dataElementNewestEventProgram =
      'DATAELEMENT_NEWEST_EVENT_PROGRAM';
  static const teiAttribute = 'TEI_ATTRIBUTE';
  static const dataElementCurrentEvent = 'DATAELEMENT_CURRENT_EVENT';
  static const calculatedValue = 'CALCULATED_VALUE';
  static const dataElementNewestEventProgramStage =
      'DATAELEMENT_NEWEST_EVENT_PROGRAM_STAGE';

  /// List of supported program rule variable source types
  static const supportedTypes = [
    dataElementNewestEventProgram,
    teiAttribute,
    dataElementCurrentEvent,
    dataElementNewestEventProgramStage
  ];
}
