import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/models/metadata/user_sharing.dart';

import '../metadata/user_group_sharing.dart';

class D2UserAccess {
  D2Sharing sharing;
  D2User user;

  late bool canEditMetadata;
  late bool canViewMetadata;

  late bool canCaptureData;
  late bool canViewData;

  //TODO: Document how access is obtained from the access string
  void getAccessFromAccessString(String access) {
    String metaAccess = access.substring(0, 2);
    String dataAccess = access.substring(2, 4);

    canEditMetadata = metaAccess.contains('w');
    canViewMetadata = metaAccess.contains('r');

    canViewData = dataAccess.contains('r');
    canCaptureData = dataAccess.contains('w');
  }

  D2UserAccess(
      {required this.sharing, required this.user, required D2ObjectBox db}) {
    D2SharingRepository repository = D2SharingRepository(db);
    List<D2UserSharing> users = repository.getUsers(sharing);
    D2UserSharing? userSharingSetting = users.firstWhereOrNull(
        (sharingSetting) => sharingSetting.userId == user.uid);

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
      //TODO: Determine the combined string
      String accessString = accessStrings.reduce((value, element) {
        String combinedString = '';
        value.split('').forEachIndexed((index, char) {
          String charAtElement = element[index];
          if (charAtElement == char) {
            //Any
          } else {
            if (char == '-') {
              //assign the charAtElement
            } else {
              if (charAtElement == '-') {
                //assign char
              }
            }
          }
        });
        return combinedString;
      });
      getAccessFromAccessString(accessString);
    } else {
      //Public access
      getAccessFromAccessString(sharing.public);
    }
  }
}
