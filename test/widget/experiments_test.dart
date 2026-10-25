import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_lab/providers/theme_provider.dart';
import 'package:flutter_lab/providers/api_feed_provider.dart';
import 'package:flutter_lab/widgets/pulse_heart.dart';
import 'package:flutter_lab/widgets/responsive_layout.dart';
import 'package:flutter_lab/screens/experiments_hub_screen.dart';

void main() {
  group('Experiment 10 - Widget Tests: Widgets & Screens', () {
    testWidgets('PulseHeartButton displays label, count, and triggers callback on tap', (WidgetTester tester) async {
      int tapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PulseHeartButton(
              count: 15,
              label: 'Fan Cheers',
              onTap: () {
                tapCount++;
              },
            ),
          ),
        ),
      );

      expect(find.text('Fan Cheers (15)'), findsOneWidget);
      expect(find.byType(PulseHeartButton), findsOneWidget);

      await tester.tap(find.byType(PulseHeartButton));
      // PulseHeartButton has a repeating animation, so pump frame rather than pumpAndSettle
      await tester.pump(const Duration(milliseconds: 100));

      expect(tapCount, 1);
    });

    testWidgets('ResponsiveLayout adapts correctly to different screen widths', (WidgetTester tester) async {
      Widget buildTestWidget() {
        return const MaterialApp(
          home: Scaffold(
            body: ResponsiveLayout(
              mobile: Text('Mobile View'),
              tablet: Text('Tablet View'),
              desktop: Text('Desktop View'),
            ),
          ),
        );
      }

      // Test mobile size (< 650)
      tester.view.physicalSize = const Size(500, 800);
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(buildTestWidget());
      expect(find.text('Mobile View'), findsOneWidget);

      // Test tablet size (650 to 1000)
      tester.view.physicalSize = const Size(800, 900);
      await tester.pumpWidget(buildTestWidget());
      expect(find.text('Tablet View'), findsOneWidget);

      // Test desktop size (>= 1000)
      tester.view.physicalSize = const Size(1200, 900);
      await tester.pumpWidget(buildTestWidget());
      expect(find.text('Desktop View'), findsOneWidget);

      // Reset test window
      addTearDown(() => tester.view.resetPhysicalSize());
    });

    testWidgets('ExperimentsHubScreen renders all 9 experiment cards', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => ApiFeedProvider()),
          ],
          child: const MaterialApp(
            home: ExperimentsHubScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Flutter Lab Experiments Hub'), findsOneWidget);
      expect(find.text('Exp 2'), findsOneWidget);
      expect(find.text('Exp 3'), findsOneWidget);
      expect(find.text('Exp 4'), findsOneWidget);
      expect(find.text('Exp 5'), findsOneWidget);
      expect(find.text('Exp 6'), findsOneWidget);
      expect(find.text('Exp 7'), findsOneWidget);
      expect(find.text('Exp 8'), findsOneWidget);
      expect(find.text('Exp 9'), findsOneWidget);
      expect(find.text('Exp 10'), findsOneWidget);
    });
  });
}
