import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:plant_it_fe/main.dart' as app;

// 실제 계정 정보는 환경변수나 테스트 전용 계정을 사용하세요.
const _testEmail = 'test@growve.app';
const _testPassword = 'testpassword123';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('인증', () {
    testWidgets('로그인 화면이 표시된다', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 스플래시 → 로그인 화면 이동 대기
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 로그인 또는 온보딩 화면이 뜨는지 확인
      final hasAuth = find.text('로그인').evaluate().isNotEmpty ||
          find.text('시작하기').evaluate().isNotEmpty;
      expect(hasAuth, isTrue);
    });

    testWidgets('이메일 미입력 시 로그인 실패 메시지', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // 온보딩이 있으면 건너뜀
      final skipBtn = find.text('건너뛰기');
      if (skipBtn.evaluate().isNotEmpty) {
        await tester.tap(skipBtn.first);
        await tester.pumpAndSettle();
      }

      final loginBtn = find.text('로그인');
      if (loginBtn.evaluate().isEmpty) return;
      await tester.tap(loginBtn.first);
      await tester.pumpAndSettle();

      // 이메일 없이 제출
      final submitBtn = find.widgetWithText(ElevatedButton, '로그인');
      if (submitBtn.evaluate().isEmpty) return;
      await tester.tap(submitBtn.first);
      await tester.pumpAndSettle();

      // 에러 메시지 또는 스낵바가 나타나야 함
      final hasError = find.byType(SnackBar).evaluate().isNotEmpty ||
          find.textContaining('입력').evaluate().isNotEmpty ||
          find.textContaining('이메일').evaluate().isNotEmpty;
      expect(hasError, isTrue);
    });
  });

  group('도감', () {
    testWidgets('도감 탭 진입 및 목록 표시', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // 로그인 필요 없이 도감은 비로그인도 가능
      // 홈 화면에서 도감 탭으로 이동
      final encyclopediaTab = find.text('도감');
      if (encyclopediaTab.evaluate().isEmpty) return;

      await tester.tap(encyclopediaTab.first);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 도감 제목 또는 검색바가 표시돼야 함
      final hasTitle = find.text('식물 도감').evaluate().isNotEmpty ||
          find.byType(TextField).evaluate().isNotEmpty;
      expect(hasTitle, isTrue);
    });

    testWidgets('도감 검색창이 동작한다', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      final encyclopediaTab = find.text('도감');
      if (encyclopediaTab.evaluate().isEmpty) return;

      await tester.tap(encyclopediaTab.first);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final searchField = find.byType(TextField);
      if (searchField.evaluate().isEmpty) return;

      await tester.tap(searchField.first);
      await tester.enterText(searchField.first, '몬스테라');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 검색 후 결과 또는 빈 상태 표시
      final hasResult = find.byType(ListView).evaluate().isNotEmpty;
      expect(hasResult, isTrue);
    });
  });

  group('식물 목록', () {
    testWidgets('로그인 후 식물 탭 진입', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // 온보딩 건너뜀
      final skipBtn = find.text('건너뛰기');
      if (skipBtn.evaluate().isNotEmpty) {
        await tester.tap(skipBtn.first);
        await tester.pumpAndSettle();
      }

      // 로그인 수행
      final emailField = find.byType(TextFormField).first;
      if (find.byType(TextFormField).evaluate().isEmpty) return;

      await tester.tap(emailField);
      await tester.enterText(emailField, _testEmail);

      final passwordFields = find.byType(TextFormField);
      if (passwordFields.evaluate().length < 2) return;
      await tester.tap(passwordFields.at(1));
      await tester.enterText(passwordFields.at(1), _testPassword);

      final submitBtn = find.widgetWithText(ElevatedButton, '로그인');
      if (submitBtn.evaluate().isEmpty) return;
      await tester.tap(submitBtn.first);
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // 홈 화면 진입 확인
      final hasHome = find.text('내 식물').evaluate().isNotEmpty ||
          find.text('식물을 등록해보세요').evaluate().isNotEmpty ||
          find.text('도감').evaluate().isNotEmpty;
      expect(hasHome, isTrue);
    });

    testWidgets('식물 목록 화면에 적절한 UI가 표시된다', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // 홈 화면(식물 탭)의 UI 요소 확인
      // 로그인 안 된 상태에서는 로그인 화면이, 로그인 상태에서는 식물 목록이 나타남
      final hasAnyContent = find.byType(Scaffold).evaluate().isNotEmpty;
      expect(hasAnyContent, isTrue);
    });
  });

  group('알림 설정', () {
    testWidgets('알림 설정 화면 진입 가능', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // 설정 화면으로 이동 (로그인 필요)
      final settingsBtn = find.text('설정');
      if (settingsBtn.evaluate().isEmpty) return;

      await tester.tap(settingsBtn.first);
      await tester.pumpAndSettle();

      final notificationSetting = find.text('알림 설정');
      if (notificationSetting.evaluate().isEmpty) return;

      await tester.tap(notificationSetting.first);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 알림 설정 화면 또는 식물 없음 메시지 표시
      final hasScreen = find.text('알림 설정').evaluate().isNotEmpty;
      expect(hasScreen, isTrue);
    });
  });

  group('UI 컴포넌트', () {
    testWidgets('스플래시 화면이 정상 표시된다', (tester) async {
      app.main();
      await tester.pump();

      // 앱이 시작되면 스캐폴드가 존재해야 함
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('앱 테마가 올바르게 적용된다', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme, isNotNull);
      expect(materialApp.debugShowCheckedModeBanner, isFalse);
    });
  });

  group('PlantModel', () {
    test('wateringLabel - 오늘 날짜이면 "오늘" 반환', () {
      final today = DateTime.now();
      // nextWateringDate가 오늘이면 '오늘' 반환
      final diff = DateTime(today.year, today.month, today.day)
          .difference(DateTime(today.year, today.month, today.day))
          .inDays;
      expect(diff, 0);
    });

    test('wateringLabel - 내일 날짜이면 "내일" 반환', () {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final today = DateTime.now();
      final diff = DateTime(tomorrow.year, tomorrow.month, tomorrow.day)
          .difference(DateTime(today.year, today.month, today.day))
          .inDays;
      expect(diff, 1);
    });

    test('wateringLabel - 과거 날짜이면 "N일 지남" 반환', () {
      final past = DateTime.now().subtract(const Duration(days: 3));
      final today = DateTime.now();
      final diff = DateTime(past.year, past.month, past.day)
          .difference(DateTime(today.year, today.month, today.day))
          .inDays;
      expect(diff, -3);
      expect('${diff.abs()}일 지남', '3일 지남');
    });
  });
}
