import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:happy_farm/tools/nonce_generator.dart';

class LineAuthService {
  final LineSDK _lineSDK = LineSDK.instance;
  final OAuthProvider _provider = OAuthProvider("oidc.line");
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final NonceGenerator _nonceGenerator = NonceGenerator();

  Future<User?> signInWithLine() async {
    LoginOption option = LoginOption(false, 'normal')
      ..idTokenNonce = _nonceGenerator.nonce;
    LoginResult result = await _lineSDK.login(
      scopes: ["profile", "openid", "email"],
      option: option,
    );

    if (result.userProfile == null) return null;

    OAuthCredential credential = _provider.credential(
      accessToken: result.accessToken.value,
      idToken: result.accessToken.idTokenRaw,
      rawNonce: _nonceGenerator.rawNonce,
    );

    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser;

    // user id -> result.userProfile?.userId
    // user name -> result.userProfile?.displayName
    // user avatar -> result.userProfile?.pictureUrl
    // userEmail = result.accessToken.email;
  }

  Future<List<void>> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _lineSDK.logout(),
    ]);
  }

  Future<UserProfile> getUser() async {
    return await _lineSDK.getProfile();
  }

  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }
}
