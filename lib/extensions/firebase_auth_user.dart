import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

// Map<String, dynamic>
extension MetadataToJson on UserMetadata {
  String toJson() {
    return jsonEncode({
      'creationTime': creationTime.toString(),
      'lastSignInTime': lastSignInTime.toString(),
    });
  }
}

extension UserInfoToJson on UserInfo {
  String toJson() {
    return jsonEncode({
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'providerId': providerId,
      'uid': uid,
    });
  }
}

extension UserToJson on User {
  String toJson() {
    List<String> providerDataJson =
        providerData.map((e) => e.toJson()).toList();

    return jsonEncode({
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'metadata': metadata.toJson(),
      'providerData': providerDataJson,
      'refreshToken': refreshToken,
      'tenantId': tenantId,
      'uid': uid,
    });
  }
}
