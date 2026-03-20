import '../data/model/auth_tokens_model.dart';
import '../data/model/id_response_model.dart';
import '../data/model/user_model.dart';
import '../data/service/auth_data_service.dart';
import 'storage_service.dart';

class AuthService {
  AuthService({
    AuthDataService? authDataService,
    StorageService? storageService,
  }) : _authDataService = authDataService ?? AuthDataService(),
       _storageService = storageService ?? StorageService();

  final AuthDataService _authDataService;
  final StorageService _storageService;

  UserModel? currentUser;

  Future<IdResponseModel> signUp({
    required String email,
    required String password,
    required String nickname,
  }) async {
    final result = await _authDataService.signUp(
      email: email,
      password: password,
      nickname: nickname,
    );
    await _storageService.setLastLoginEmail(email);
    return result;
  }

  Future<AuthTokensModel> login({
    required String email,
    required String password,
    bool remember = true,
  }) async {
    final tokens = await _authDataService.login(
      email: email,
      password: password,
    );
    await _persistLogin(tokens, email: email, remember: remember);
    return tokens;
  }

  Future<AuthTokensModel> googleLogin({
    required String idToken,
  }) async {
    final tokens = await _authDataService.googleLogin(idToken: idToken);
    await _persistLogin(tokens, remember: true);
    return tokens;
  }

  Future<UserModel?> restoreSession() async {
    final accessToken = await _storageService.readAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      return null;
    }

    currentUser = await _authDataService.fetchMe(accessToken: accessToken);
    return currentUser;
  }

  Future<void> logout() async {
    currentUser = null;
    await _storageService.clearTokens();
    await _storageService.setAutoLoginEnabled(false);
  }

  Future<void> _persistLogin(
    AuthTokensModel tokens, {
    String? email,
    required bool remember,
  }) async {
    await _storageService.saveTokens(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    );
    await _storageService.setAutoLoginEnabled(remember);
    if (email != null) {
      await _storageService.setLastLoginEmail(email);
    }
    currentUser = await _authDataService.fetchMe(accessToken: tokens.accessToken);
  }
}
