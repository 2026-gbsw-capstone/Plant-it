import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plant_it_fe/services/api_service.dart';
import 'package:plant_it_fe/services/firebase_messaging_service.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  bool _googleInitialized = false;

  Future<void> signInWithGoogle() async {
    await FirebaseMessagingService.instance.initializeFirebase();
    await _ensureGoogleSignInInitialized();

    final GoogleSignInAccount googleUser;
    try {
      googleUser = await GoogleSignIn.instance.authenticate();
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw ApiException('Google 로그인이 취소되었습니다.');
      }
      throw ApiException('Google 로그인에 실패했습니다: ${e.description ?? e.code}');
    }

    final googleIdToken = googleUser.authentication.idToken;
    if (googleIdToken == null || googleIdToken.isEmpty) {
      throw ApiException('Google 인증 토큰을 받지 못했습니다.');
    }

    final credential = GoogleAuthProvider.credential(idToken: googleIdToken);
    final firebaseUser = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    final firebaseIdToken = await firebaseUser.user?.getIdToken();
    if (firebaseIdToken == null || firebaseIdToken.isEmpty) {
      throw ApiException('Firebase 인증 토큰을 받지 못했습니다.');
    }

    await ApiService.instance.googleLogin(idToken: firebaseIdToken);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    try {
      await _ensureGoogleSignInInitialized();
      await GoogleSignIn.instance.signOut();
    } catch (_) {
      // Email/password sessions do not require a Google Sign-In session.
    }
  }

  Future<void> _ensureGoogleSignInInitialized() async {
    if (_googleInitialized) return;
    await GoogleSignIn.instance.initialize();
    _googleInitialized = true;
  }
}
