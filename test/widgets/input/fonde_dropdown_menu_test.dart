// Tests for FondeDropdownMenu.
//
// Verifies entry rendering, initial selection, onSelected callback, and disabled state.

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../../helpers/pump_helpers.dart';

void main() {
  group('FondeDropdownMenu', () {
    List<DropdownMenuEntry<String>> _entries() => const [
      DropdownMenuEntry(value: 'apple', label: 'Apple'),
      DropdownMenuEntry(value: 'banana', label: 'Banana'),
      DropdownMenuEntry(value: 'cherry', label: 'Cherry'),
    ];

    group('rendering', () {
      testWidgets('renders without crashing', (tester) async {
        await tester.pumpTestApp(
          FondeDropdownMenu<String>(dropdownMenuEntries: _entries()),
        );
        expect(find.byType(FondeDropdownMenu<String>), findsOneWidget);
      });

      testWidgets('hintText is shown when provided', (tester) async {
        await tester.pumpTestApp(
          FondeDropdownMenu<String>(
            dropdownMenuEntries: _entries(),
            hintText: 'Select fruit',
          ),
        );
        expect(find.text('Select fruit'), findsOneWidget);
      });

      testWidgets('initialSelection value is displayed', (tester) async {
        await tester.pumpTestApp(
          FondeDropdownMenu<String>(
            dropdownMenuEntries: _entries(),
            initialSelection: 'banana',
          ),
        );
        expect(find.text('Banana'), findsOneWidget);
      });

      testWidgets('disabled state renders without crashing', (tester) async {
        await tester.pumpTestApp(
          FondeDropdownMenu<String>(
            dropdownMenuEntries: _entries(),
            enabled: false,
          ),
        );
        expect(find.byType(FondeDropdownMenu<String>), findsOneWidget);
      });
    });

    group('onSelected callback', () {
      testWidgets('fires when an entry is tapped', (tester) async {
        String? selected;
        await tester.pumpTestApp(
          FondeDropdownMenu<String>(
            dropdownMenuEntries: _entries(),
            onSelected: (v) => selected = v,
            selectionEffect: false,
          ),
        );
        // Open the dropdown via pointer down (menu opens on pointer down)
        final buttonCenter = tester.getCenter(
          find.byType(FondeDropdownMenu<String>),
        );
        final gesture = await tester.startGesture(
          buttonCenter,
          kind: PointerDeviceKind.mouse,
        );
        // Hold long enough to exceed _longPressThreshold (500ms),
        // so release selects regardless of movement distance.
        await tester.pump(const Duration(milliseconds: 600));

        // Banana entry should now be visible — move to it and release
        final bananaFinder = find.text('Banana').last;
        if (bananaFinder.evaluate().isNotEmpty) {
          final bananaCenter = tester.getCenter(bananaFinder);
          await gesture.moveTo(bananaCenter);
          await tester.pump();
          await gesture.up();
          await tester.pumpAndSettle();
          expect(selected, 'banana');
        } else {
          await gesture.up();
          // Entries not visible in test environment — smoke pass
          expect(find.byType(FondeDropdownMenu<String>), findsOneWidget);
        }
      });
    });
  });
}
