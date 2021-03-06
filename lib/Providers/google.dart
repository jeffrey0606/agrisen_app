import 'package:google_sign_in/google_sign_in.dart';

class Google {
  static Future<GoogleSignInAccount> signin() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['profile', 'email'],
    );

    try {
      final response = await googleSignIn.signIn();

      googleSignIn.signOut();

      return response ?? response;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  static Future<void> signout() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await googleSignIn.signOut();
    } catch (error) {
      throw 'couldn\'t logout please check your internet';
    }
  }
}
