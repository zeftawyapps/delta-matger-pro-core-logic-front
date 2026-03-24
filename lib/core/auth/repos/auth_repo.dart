import 'package:matger_core_logic/core/auth/data/user_model.dart';
import 'package:matger_core_logic/core/auth/source/auth_source.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';

class AuthRepo {
  late final AuthSource _authSource;

  AuthRepo({AuthSource? authSource}) {
    _authSource = authSource ?? AuthSource();
  }
  Future<RemoteBaseModel<UserModel>> login({
    required String username,
    required String password,
  }) async {
    JDRepoConsole.info(
      "Login in repo for: $username",
      context: LogContext(module: "AuthRepo", method: "login"),
    );
    final result = await _authSource.login(
      username: username,
      password: password,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in login: ${result.error?.message}",
        context: LogContext(module: "AuthRepo", method: "login"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
        data: null,
      );
    }

    try {
      // Handle nested data field if present, otherwise use the whole object
      final rawData = result.data as Map<String, dynamic>;
      final data = (rawData.containsKey('data') && rawData['data'] is Map)
          ? rawData['data'] as Map<String, dynamic>
          : rawData;

      final user = UserModel.fromJson(data);
      JDRepoConsole.success(
        "User login successful and parsed",
        context: LogContext(module: "AuthRepo", method: "login"),
      );
      return RemoteBaseModel(data: user, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in login: $e",
        context: LogContext(
          module: "AuthRepo",
          method: "login",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: "Parsing Error: $e",
      );
    }
  }

  Future<RemoteBaseModel<UserModel>> loginOrg({
    required String orgName,
    required String username,
    required String password,
  }) async {
    JDRepoConsole.info(
      "LoginOrg in repo for: $username in $orgName",
      context: LogContext(module: "AuthRepo", method: "loginOrg"),
    );
    final result = await _authSource.loginOrg(
      orgName: orgName,
      username: username,
      password: password,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in loginOrg: ${result.error?.message}",
        context: LogContext(module: "AuthRepo", method: "loginOrg"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
        data: null,
      );
    }

    try {
      final rawData = result.data as Map<String, dynamic>;
      final data = (rawData.containsKey('data') && rawData['data'] is Map)
          ? rawData['data'] as Map<String, dynamic>
          : rawData;

      final user = UserModel.fromJson(data);
      JDRepoConsole.success(
        "User login success and parsed for organization",
        context: LogContext(module: "AuthRepo", method: "loginOrg"),
      );
      return RemoteBaseModel(data: user, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in loginOrg: $e",
        context: LogContext(
          module: "AuthRepo",
          method: "loginOrg",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: "Parsing Error: $e",
      );
    }
  }

  Future<RemoteBaseModel<UserModel>> register({
    required Map<String, dynamic> userData,
  }) async {
    JDRepoConsole.info(
      "Register in repo",
      context: LogContext(module: "AuthRepo", method: "register"),
    );
    final result = await _authSource.register(userData: userData);

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in register: ${result.error?.message}",
        context: LogContext(module: "AuthRepo", method: "register"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final rawData = result.data as Map<String, dynamic>;
      final data = (rawData.containsKey('data') && rawData['data'] is Map)
          ? rawData['data'] as Map<String, dynamic>
          : rawData;
      final user = UserModel.fromJson(data);
      JDRepoConsole.success(
        "User registered and parsed successfully",
        context: LogContext(module: "AuthRepo", method: "register"),
      );
      return RemoteBaseModel(data: user, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in register: $e",
        context: LogContext(
          module: "AuthRepo",
          method: "register",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: "Parsing Error: $e",
      );
    }
  }

  Future<RemoteBaseModel<UserModel>> getProfile() async {
    JDRepoConsole.info(
      "Fetching profile in repo",
      context: LogContext(module: "AuthRepo", method: "getProfile"),
    );
    final result = await _authSource.getProfile();

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in getProfile: ${result.error?.message}",
        context: LogContext(module: "AuthRepo", method: "getProfile"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final rawData = result.data as Map<String, dynamic>;
      final data = (rawData.containsKey('data') && rawData['data'] is Map)
          ? rawData['data'] as Map<String, dynamic>
          : rawData;
      final user = UserModel.fromJson(data);
      JDRepoConsole.success(
        "Profile fetched and parsed successfully",
        context: LogContext(module: "AuthRepo", method: "getProfile"),
      );
      return RemoteBaseModel(data: user, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in getProfile: $e",
        context: LogContext(
          module: "AuthRepo",
          method: "getProfile",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: "Parsing Error: $e",
      );
    }
  }
}
