import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:matger_pro_core_logic/core/auth/repos/test_repo.dart';
import 'package:matger_pro_core_logic/core/auth/source/test_page_source.dart';
import 'package:matger_pro_core_logic/models/app_settings.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/result/result.dart';

class MockTestPageSource extends Mock implements TestPageSource {}

void main() {
  late TestRepo testRepo;
  late MockTestPageSource mockTestPageSource;

  setUp(() {
    mockTestPageSource = MockTestPageSource();
    testRepo = TestRepo(landingPageSource: mockTestPageSource);
  });

  group('TestRepo Unit Tests', () {
    test('getLandingData returns AppSettings on success', () async {
      // Arrange
      final mockJson = {
        'success': true,
        'message': 'Loaded successfully',
        'timestamp': '2023-10-27T10:00:00Z',
        'environment': 'Production',
        'version': '1.0.0',
      };

      when(
        () => mockTestPageSource.getTestPages(
          mockResponse: any(named: 'mockResponse'),
        ),
      ).thenAnswer((_) async => Result.data(mockJson));

      // Act
      final result = await testRepo.getLandingData();

      // Assert
      expect(result.status, StatusModel.success);
      expect(result.data, isA<AppSettings>());
      expect(result.data?.environment, 'Production');
      verify(
        () => mockTestPageSource.getTestPages(
          mockResponse: any(named: 'mockResponse'),
        ),
      ).called(1);
    });

    test('getLandingData returns error when source fails', () async {
      // Arrange
      final errorMessage = 'API Error';
      final remoteError = RemoteBaseModel(
        message: errorMessage,
        status: StatusModel.error,
      );

      when(
        () => mockTestPageSource.getTestPages(
          mockResponse: any(named: 'mockResponse'),
        ),
      ).thenAnswer((_) async => Result.error(remoteError));

      // Act
      final result = await testRepo.getLandingData();

      // Assert
      expect(result.status, StatusModel.error);
      expect(result.message, errorMessage);
    });

    test('getLandingData returns error on parsing failure', () async {
      // Arrange
      final invalidJson = {
        'success': 'not_a_bool',
      }; // AppSettings.fromJson expects bool

      when(
        () => mockTestPageSource.getTestPages(
          mockResponse: any(named: 'mockResponse'),
        ),
      ).thenAnswer((_) async => Result.data(invalidJson));

      // Act
      final result = await testRepo.getLandingData();

      // Assert
      expect(result.status, StatusModel.error);
      expect(result.message, contains('Data Parsing Error'));
    });
  });
}
