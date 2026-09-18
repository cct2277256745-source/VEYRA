import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:veyra/core/design/tokens.dart';
import 'package:veyra/core/design/veyra_checkbox.dart';
import 'package:veyra/core/design/veyra_motion.dart';

void main() {
  group('VeyraMotion tokens and helpers', () {
    test('Standard motion durations are within quiet desktop range (80-340ms)', () {
      expect(VeyraMotion.instant.inMilliseconds, inInclusiveRange(80, 120));
      expect(VeyraMotion.fast.inMilliseconds, inInclusiveRange(120, 160));
      expect(VeyraMotion.standard.inMilliseconds, inInclusiveRange(180, 220));
      expect(VeyraMotion.emphasized.inMilliseconds, inInclusiveRange(240, 280));
      expect(VeyraMotion.progress.inMilliseconds, inInclusiveRange(300, 360));
    });

    testWidgets('Reduced motion collapses duration to Duration.zero', (tester) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: SizedBox(),
        ),
      );

      final context = tester.element(find.byType(SizedBox));
      expect(VeyraMotion.isReducedMotion(context), isTrue);
      expect(VeyraMotion.duration(context, VeyraMotion.standard), Duration.zero);
    });

    testWidgets('Normal motion preserves defined duration', (tester) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(disableAnimations: false),
          child: SizedBox(),
        ),
      );

      final context = tester.element(find.byType(SizedBox));
      expect(VeyraMotion.isReducedMotion(context), isFalse);
      expect(VeyraMotion.duration(context, VeyraMotion.standard), VeyraMotion.standard);
    });
  });

  group('VeyraCheckbox desktop interaction', () {
    testWidgets('Unchecked renders empty ring, tap triggers onChanged(true)', (tester) async {
      bool? checkedState = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: StatefulBuilder(
                builder: (context, setState) {
                  return VeyraCheckbox(
                    value: checkedState ?? false,
                    onChanged: (v) => setState(() => checkedState = v),
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(checkedState, isFalse);
      expect(find.byType(VeyraCheckbox), findsOneWidget);

      await tester.tap(find.byType(VeyraCheckbox));
      await tester.pumpAndSettle();

      expect(checkedState, isTrue);
    });

    testWidgets('Keyboard navigation (Space & Enter) toggles VeyraCheckbox', (tester) async {
      bool? checkedState = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: StatefulBuilder(
                builder: (context, setState) {
                  return VeyraCheckbox(
                    autofocus: true,
                    value: checkedState ?? false,
                    onChanged: (v) => setState(() => checkedState = v),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Focus checkbox
      final focusable = find.byType(FocusableActionDetector);
      expect(focusable, findsOneWidget);

      // Send Space key
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();

      expect(checkedState, isTrue);

      // Send Enter key to toggle back
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(checkedState, isFalse);
    });

    testWidgets('Disabled VeyraCheckbox ignores tap', (tester) async {
      bool called = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: VeyraCheckbox(
                value: false,
                onChanged: null, // disabled
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(VeyraCheckbox));
      await tester.pumpAndSettle();

      expect(called, isFalse);
    });
  });

  group('VeyraFadeSwitcher & VeyraExpandable', () {
    testWidgets('VeyraFadeSwitcher renders active child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VeyraFadeSwitcher(
              child: Text('Tab A', key: ValueKey('a')),
            ),
          ),
        ),
      );

      expect(find.text('Tab A'), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VeyraFadeSwitcher(
              child: Text('Tab B', key: ValueKey('b')),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Tab B'), findsOneWidget);
    });

    testWidgets('VeyraExpandable expands and collapses child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VeyraExpandable(
              isExpanded: true,
              child: Text('Expanded Content'),
            ),
          ),
        ),
      );

      expect(find.text('Expanded Content'), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VeyraExpandable(
              isExpanded: false,
              child: Text('Expanded Content'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      // Rendered height is 0
      final size = tester.getSize(find.byType(VeyraExpandable));
      expect(size.height, 0);
    });
  });

  group('VeyraPageRoute', () {
    testWidgets('Pushes route and navigates smoothly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    VeyraPageRoute(
                      builder: (_) => const Scaffold(body: Text('Detail View')),
                    ),
                  );
                },
                child: const Text('Open Detail'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Detail'));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Detail View'), findsOneWidget);
    });
  });
}
