///Copyright (c) 2024, HISP Tanzania Developers.
///All rights reserved. Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.

library;

//
///This is the exception handler for the program indicator
//
class ProgramRuleException implements Exception {
  //
  ///This is the source for the exception as description to what went wrong
  //
  final String source;

  //
  ///This is the constructor to the `ProgramRuleException`
  //
  ProgramRuleException(this.source);

  @override
  String toString() {
    return 'PROGRAM RULE EXCEPTION: $source';
  }
}
