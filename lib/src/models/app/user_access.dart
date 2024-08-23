import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/models/metadata/user_sharing.dart';

import '../metadata/user_group_sharing.dart';

/// Class representing user access control in DHIS2.
class D2UserAccess {
  /// Sharing settings for the object.
  D2Sharing sharing;

  /// User for whom the access is being determined.
  D2User user;

  /// Whether the user can edit metadata.
  late bool canEditMetadata;

  /// Whether the user can view metadata.
  late bool canViewMetadata;

  /// Whether the user can capture data.
  late bool canCaptureData;

  /// Whether the user can view data.
  late bool canViewData;

  /// Parses the access string to set permissions.
  void getAccessFromAccessString(String access) {
    String metaAccess = access.substring(0, 2);
    String dataAccess = access.substring(2, 4);

    canEditMetadata = metaAccess.contains('w');
    canViewMetadata = metaAccess.contains('r');

    canViewData = dataAccess.contains('r');
    canCaptureData = dataAccess.contains('w');
  }

  /// Constructor to initialize [D2UserAccess] with sharing settings, user, and database.
  D2UserAccess({
    required this.sharing,
    required this.user,
    required D2ObjectBox db,
  }) {
    D2SharingRepository repository = D2SharingRepository(db);

    // Fetch user sharing settings
    List<D2UserSharing> users = repository.getUsers(sharing);
    D2UserSharing? userSharingSetting = users.firstWhereOrNull(
        (sharingSetting) => sharingSetting.userId == user.uid);

    // Fetch user group sharing settings
    List<String> userGroupsFromUser =
        user.userGroups.map((group) => group.uid).toList();
    List<D2UserGroupSharing> userGroupsSharingSetting =
        repository.getUserGroups(sharing);

    List<D2UserGroupSharing> groupsUserIsAPartOf = userGroupsSharingSetting
        .where((userGroupSetting) =>
            userGroupsFromUser.contains(userGroupSetting.userGroupId))
        .toList();

    if (userSharingSetting != null) {
      String accessString = userSharingSetting.access;
      getAccessFromAccessString(accessString);
    } else if (groupsUserIsAPartOf.isNotEmpty) {
      List<String> accessStrings =
          groupsUserIsAPartOf.map((group) => group.access).toList();

      String accessString = accessStrings.reduce((value, element) {
        StringBuffer combinedString = StringBuffer();

        for (int i = 0; i < value.length; i++) {
          String char = value[i];
          String charAtElement = element[i];

          if (char == charAtElement) {
            combinedString.write(char);
          } else {
            if (char == '-' && i % 2 == 0 && charAtElement == 'r') {
              combinedString.write('r');
            } else if (char == '-' && i % 2 != 0 && charAtElement == 'w') {
              combinedString.write('w');
            } else if (charAtElement == '-' && i % 2 == 0 && char == 'r') {
              combinedString.write('r');
            } else if (charAtElement == '-' && i % 2 != 0 && char == 'w') {
              combinedString.write('w');
            } else {
              combinedString.write(char);
            }
          }
        }
        return combinedString.toString();
      });

      getAccessFromAccessString(accessString);
    } else {
      // If no specific sharing settings exist, use public access settings
      getAccessFromAccessString(sharing.public);
    }
  }
}
