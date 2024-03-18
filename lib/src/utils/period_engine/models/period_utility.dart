///Copyright (c) 2024, HISP Tanzania Developers.
///All rights reserved. Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.

library;

import '../constants/fixed_period_types.dart';
import 'period_type.dart';

///This is data modal for period utility, that exposes methods for period utility
class D2PeriodUtility {
  ///This method allow getting period type from period ID
  ///The method takes period id as parameter and returns a `D2PeriodType`
  ///Example
  ///```dart
  ///var dailyPeriod = D2PeriodUtility.getPeriodTypeById('DAILY')  ///This returns the D2Period type object for 'DAILY'
  ///```
  static getPeriodTypeById(String id) {
    List<Map<String, dynamic>> d2PeriodTypes = [...d2FixedD2PeriodTypes];
    Map<String, dynamic>? periodType = d2PeriodTypes
        .firstWhere((element) => element['id'] == id, orElse: () => {});
    return D2PeriodType(periodType);
  }
}
