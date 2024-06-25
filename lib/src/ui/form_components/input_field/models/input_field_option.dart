/// This class represents an option for an input field, typically used in select or multi-select inputs.
class D2InputFieldOption {
  /// The code of the option.
  String code;

  /// The name of the option.
  String name;

  /// The sort order of the option, used for ordering options in a list.
  int sortOrder;

  /// Constructs an option with the specified code, name, and optional sort order.
  ///
  /// - [code] The code of the option.
  /// - [name] The name of the option.
  /// - [sortOrder] The sort order of the option (default is 0).
  D2InputFieldOption({
    required this.code,
    required this.name,
    this.sortOrder = 0,
  });

  /// Returns the string representation of the option.
  ///
  ///Returns: The code of the option.
  @override
  String toString() {
    return code;
  }
}
