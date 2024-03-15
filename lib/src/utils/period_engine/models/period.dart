///Copyright (c) 2024, HISP Tanzania Developers.
///All rights reserved. Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.

library;

import 'package:dart_date/dart_date.dart';

///This is a period data model.
///It is a collection of properties and different methods necessary for period manipulation

class D2Period {
  ///This is the period identifier
  late String id;

  ///This is the period display name as per DHIS2 standards
  late String name;

  ///This is the starting '`DateTime` for the respective period
  late DateTime? start;

  ///This is the ending '`DateTime` for the respective period
  late DateTime? end;

  ///This is the type of the current period. It is a `String` representation of the period type
  late String type;

  ///This is the category of the current period. It is a `String` representation of the period category
  late String category;

  ///`D2Period.fromObject` is a constructor method that creates a D2Period from a `Map` object.
  ///The constructor accepts a `Map<String, dynamic>` object, `String` period type and  `String` period category as required parameters
  D2Period.fromObject(Map<String, dynamic> object,
      {required this.type, required this.category}) {
    id = object['id'];
    name = object['name'];
    start = null;
    end = null;
  }

  ///`D2Period.fromInterval` is a constructor function that generates period based on the passed `interval`, `idGenerator` function, `nameGenerator` function, `String` period type and  `String` period category as required parameters
  D2Period.fromInterval(Interval interval,
      {required Function idGenerator,
      required Function nameGenerator,
      required this.type,
      required this.category}) {
    start = interval.start;
    end = interval.end;
    id = idGenerator(interval);
    name = nameGenerator(interval);
  }

  ///This is the `toString()` method that return the string representation of the `D2Period`
  @override
  String toString() {
    return "$id $name ${start != null ? "(${start?.toHumanString() ?? ''} - ${end?.toHumanString() ?? ''})" : ""}";
  }
}
