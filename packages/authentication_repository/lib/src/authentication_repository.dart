import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:authentication_repository/authentication_repository.dart';
import 'package:cache/cache.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:general_repository/general_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  AuthenticationRepository(
    this.generalRepository, {
    CacheClient? cache,
  }) : _cache = cache ?? CacheClient();

  final GeneralRepository generalRepository;
  final CacheClient _cache;

  /// User cache key.
  /// Should only be used for testing purposes.
  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';

  @visibleForTesting
  final StreamController<UserAuthentication> userAuth =
      StreamController<UserAuthentication>();

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<UserAuthentication> get user async* {
    var userJson = _cache.read<String>(key: userCacheKey);
    yield userJson == null
        ? UserAuthentication.empty
        : UserAuthentication.fromJson(jsonDecode(userJson));
    yield* userAuth.stream.map((user) {
      _cache.write<String>(
        key: userCacheKey,
        value: jsonEncode(user.toJson()),
      );
      return user;
    });
  }

  /// Returns the current cached user.
  /// Defaults to [User.empty] if there is no cached user.
  UserAuthentication get currentUser {
    var userJson = _cache.read<String>(key: userCacheKey);
    return userJson == null
        ? UserAuthentication.empty
        : UserAuthentication.fromJson(jsonDecode(userJson));
  }

  /// Starts the Sign In Flow.
  Future<void> login(String email, String password, String fcmToken) async {
    String encodedBody =
        jsonEncode({"email": email, "password": password, "fcm": fcmToken});

    var responseJson = await generalRepository.post(
      handle: AuthenticationEndpoints.login,
      body: encodedBody,
    );

    userAuth.add(UserAuthentication.fromJson(responseJson));
  }

  void updateTokens(String accessToken, String refreshToken) async {
    var updatedUserAuth = currentUser.copyWith(
      token: accessToken,
      refreshToken: refreshToken,
    );

    userAuth.add(updatedUserAuth);
  }

  Future<void> register(
      String photo,
      String name,
      String email,
      String username,
      String dateOfBirth,
      String password,
      String confrimPassword,
      String fcmToken) async {
    Map<String, String> fields = {
      "name": name,
      "email": email,
      "username": username,
      "dateofbirth": dateOfBirth,
      "password": password,
      "password_confirmation": confrimPassword,
      "social_type": "email",
      "type": "user",
      "fcm": fcmToken
    };

    List<Map<String, dynamic>> files = [];
    files.add({
      'fieldName': 'profile_pic',
      'filePath': photo,
      'fileName': photo.split('/').last,
    });

    var responseJson = await generalRepository.multipartPost(
      handle: AuthenticationEndpoints.register,
      fields: fields,
      files: files,
    );

    userAuth.add(UserAuthentication.fromJson(responseJson));
  }

  Future<void> updateProfileInfo(
      String name, String dateOfBirth, String role, String? photo) async {
    Map<String, String> fields = {
      "name": name,
      "dateofbirth": dateOfBirth,
      "role": role
    };

    List<Map<String, dynamic>> files = [];
    if (photo != null) {
      files.add({
        'fieldName': 'profile_pic',
        'filePath': photo,
        'fileName': photo.split('/').last,
      });
    }

    var responseJson = await generalRepository.multipartPost(
      handle: AuthenticationEndpoints.updateProfile,
      fields: fields,
      files: files,
    );

    var updatedUserAuth = currentUser.copyWith(
      user: currentUser.user?.copyWith(
        name: responseJson["name"],
        dateofbirth: responseJson["dateofbirth"],
        profilePic: responseJson["profile_pic"],
      ),
    );

    userAuth.add(UserAuthentication.empty);
    userAuth.add(updatedUserAuth);
  }

  Future<void> updateChildFamilyCode(String familyCode) async {
    String encodedBody = jsonEncode({
      "role": "enterprise",
      "user_role": "child",
      "family_code": familyCode,
    });

    await generalRepository.post(
      handle: AuthenticationEndpoints.updateProfile,
      body: encodedBody,
    );

    updateRole("enterprise", "child");
  }

  void updateRole(String role, String subRole) {
    var updatedUserAuth = currentUser.copyWith(
      user: currentUser.user?.copyWith(
        role: role,
        subRole: subRole,
        profileComplete: true,
      ),
    );

    userAuth.add(updatedUserAuth);
  }

  void resetRole() {
    var updatedUserAuth = currentUser.copyWith(
      user: currentUser.user?.copyWith(
        role: null,
        subRole: null,
        profileComplete: false,
      ),
    );

    userAuth.add(updatedUserAuth);
  }

  Future<void> changePassword(String currentPassword, String newPassword,
      String confirmNewPassword) async {
    String encodedBody = jsonEncode({
      "current_password": currentPassword,
      "new_password": newPassword,
      "new_password_confirmation": confirmNewPassword
    });

    await generalRepository.post(
      handle: AuthenticationEndpoints.changePassword,
      body: encodedBody,
    );
  }

  Future<void> forgotPasswordEmailSent(String email) async {
    String encodedBody = jsonEncode({
      "email": email,
    });

    await generalRepository.post(
      handle: AuthenticationEndpoints.forgotPassword,
      body: encodedBody,
    );
  }

  Future<void> forgotPasswordOtpVerified(String email, int otp) async {
    String encodedBody = jsonEncode({"email": email, "otp": otp});

    await generalRepository.post(
      handle: AuthenticationEndpoints.verifyOtp,
      body: encodedBody,
    );
  }

  Future<void> forgotPassword(
      String email, String password, String confirmPassword) async {
    String encodedBody = jsonEncode({
      "email": email,
      "password": password,
      "password_confirmation": confirmPassword
    });

    await generalRepository.post(
      handle: AuthenticationEndpoints.resetPassword,
      body: encodedBody,
    );
  }

  Future<void> deleteAccount() async {
    await generalRepository
        .delete(
      handle: AuthenticationEndpoints.deleteAccount,
    )
        .then((_) {
      userAuth.add(UserAuthentication.empty);
    });
  }

  /// Signs out the current user which will emit
  /// [User.empty] from the [user] Stream.
  void logout() {
    generalRepository.post(
      handle: AuthenticationEndpoints.logout,
    );

    userAuth.add(UserAuthentication.empty);
  }

  void clearUser() {
    userAuth.add(UserAuthentication.empty);
  }

  String _generateCodeVerifier() {
    final random = math.Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return base64UrlEncode(bytes).replaceAll('=', '');
  }

  String _generateCodeChallenge(String codeVerifier) {
    final bytes = utf8.encode(codeVerifier);
    final digest = sha256.convert(bytes);
    return base64UrlEncode(digest.bytes).replaceAll('=', '');
  }

  Future<DriveAuthentication> connectOneDrive() async {
    const String driveRedirectUri = 'aerial://auth';
    const String oneDriveClientId = '034c8ff3-1836-47f5-9468-0848bc5c1c20';

    try {
      final codeVerifier = _generateCodeVerifier();
      final codeChallenge = _generateCodeChallenge(codeVerifier);

      final result = await FlutterWebAuth2.authenticate(
        url: 'https://login.microsoftonline.com/common/oauth2/v2.0/authorize'
            '?client_id=$oneDriveClientId'
            '&response_type=code'
            '&redirect_uri=$driveRedirectUri'
            '&scope=offline_access Files.ReadWrite User.Read'
            '&code_challenge=$codeChallenge'
            '&code_challenge_method=S256',
        callbackUrlScheme: 'aerial',
      );

      final code = Uri.parse(result).queryParameters['code'];

      final tokenResponse = await http.post(
        Uri.parse('https://login.microsoftonline.com/common/oauth2/v2.0/token'),
        body: {
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': driveRedirectUri,
          'client_id': oneDriveClientId,
          'code_verifier': codeVerifier,
        },
      );

      if (tokenResponse.statusCode != 200) {
        throw 'Failed to fetch access token: ${tokenResponse.body}';
      }

      final tokenData = json.decode(tokenResponse.body);
      String? userName;
      String? accessToken = tokenData['access_token'];
      String? refreshToken = tokenData['refresh_token'];

      if (accessToken == null || refreshToken == null) {
        throw 'OneDrive connectivity canceled or failed.';
      }

      // Fetch user profile
      final userResponse = await http.get(
        Uri.parse('https://graph.microsoft.com/v1.0/me'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (userResponse.statusCode == 200) {
        final userData = json.decode(userResponse.body);
        userName = userData['displayName'];

        if (userName == null) {
          throw 'OneDrive connectivity canceled or failed.';
        }
      } else {
        throw 'Failed to fetch user information: ${userResponse.body}';
      }

      return DriveAuthentication(
        userName: userName,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    } catch (e) {
      throw 'OneDrive connectivity canceled or failed.';
    }
  }

  Future<DriveAuthentication> connectDropbox() async {
    const String dropboxRedirectUri = 'aerial://auth';
    const String dropboxClientId = 't8hr8wep48yaum8';
    const String dropboxClientSecret = 'qmvp482kofz46mk';

    try {
      final codeVerifier = _generateCodeVerifier();
      final codeChallenge = _generateCodeChallenge(codeVerifier);

      final result = await FlutterWebAuth2.authenticate(
        url: 'https://www.dropbox.com/oauth2/authorize'
            '?client_id=$dropboxClientId&response_type=code'
            '&redirect_uri=$dropboxRedirectUri'
            '&code_challenge=$codeChallenge&code_challenge_method=S256'
            '&token_access_type=offline',
        callbackUrlScheme: 'aerial',
      );

      final code = Uri.parse(result).queryParameters['code'];

      final tokenResponse = await http.post(
        Uri.parse('https://api.dropboxapi.com/oauth2/token'),
        body: {
          'code': code,
          'grant_type': 'authorization_code',
          'client_id': dropboxClientId,
          'client_secret': dropboxClientSecret,
          'redirect_uri': dropboxRedirectUri,
          'code_verifier': codeVerifier,
        },
      );

      if (tokenResponse.statusCode != 200) {
        throw 'Failed to fetch Dropbox access token: ${tokenResponse.body}';
      }

      final tokenData = json.decode(tokenResponse.body);
      String? accessToken = tokenData['access_token'];
      String? refreshToken = tokenData['refresh_token'];

      if (accessToken == null || refreshToken == null) {
        throw 'Dropbox connectivity canceled or failed.';
      }

      final userResponse = await http.post(
        Uri.parse('https://api.dropboxapi.com/2/users/get_current_account'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (userResponse.statusCode != 200) {
        throw 'Failed to fetch Dropbox user information: ${userResponse.body}';
      }

      final userData = json.decode(userResponse.body);
      String userName = userData['name']['display_name'];

      return DriveAuthentication(
        userName: userName,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    } catch (e) {
      throw 'Dropbox connectivity canceled or failed.';
    }
  }

  Future<void> signInWithGoogle(String fcmToken) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google Sign-In was canceled by the user.');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;

      if (idToken != null) {
        var responseJson = await generalRepository.post(
          handle: 'social-signup',
          header: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "authToken": idToken,
            "social_type": "google",
            "type": "user",
            "fcm": fcmToken,
          }),
        );

        userAuth.add(UserAuthentication.fromJson(responseJson));
      }
    } catch (e) {
      throw Exception('Error signing in with Google: $e');
    }
  }

  Future<void> signInWithApple(String fcmToken) async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final String? idToken = appleCredential.identityToken;

      if (idToken == null || idToken.isEmpty) {
        throw Exception('Apple Sign-In failed to retrieve identity token.');
      }

      var responseJson = await generalRepository.post(
        handle: 'social-signup',
        header: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "authToken": idToken,
          "social_type": "apple",
          "type": "user",
          "fcm": fcmToken,
        }),
      );

      userAuth.add(UserAuthentication.fromJson(responseJson));
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw Exception('Apple Sign-In was canceled by the user.');
      } else {
        throw Exception('Apple Sign-In authorization error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error signing in with Apple: $e');
    }
  }

  /// disposes the userAuth stream
  void dispose() => userAuth.close();
}
