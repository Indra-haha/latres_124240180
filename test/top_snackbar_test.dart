import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latres_124240180/widgets/top_snackbar.dart';
import 'package:latres_124240180/views/main_navigation_view.dart';

void main() {
  group('Top SnackBar Tests', () {
    testWidgets('showTopSnackBar displays snackbar near the top', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Top Bar')),
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showTopSnackBar(
                    context,
                    content: const Text('Top SnackBar Notification'),
                    backgroundColor: Colors.green,
                  );
                },
                child: const Text('Trigger SnackBar'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Trigger SnackBar'));
      await tester.pumpAndSettle();

      final snackBarFinder = find.text('Top SnackBar Notification');
      expect(snackBarFinder, findsOneWidget);

      final topLeft = tester.getTopLeft(snackBarFinder);
      expect(topLeft.dy, lessThan(200.0));
      expect(topLeft.dy, greaterThanOrEqualTo(50.0));
    });

    testWidgets('topSnackBarMargin handles bottom navigation bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Star'),
              ],
            ),
            body: Builder(
              builder: (context) {
                final margin = topSnackBarMargin(context);
                expect(margin.bottom, greaterThan(0));
                expect(margin.left, 16);
                expect(margin.right, 16);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('MainNavigationView displays welcome message exactly once', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MainNavigationView(
            welcomeMessage: 'Login berhasil! Selamat datang, admin',
          ),
        ),
      );

      await tester.pumpAndSettle();

      final snackBarFinder = find.text('Login berhasil! Selamat datang, admin');
      expect(snackBarFinder, findsOneWidget);

      final snackBarWidget = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBarWidget.backgroundColor, Colors.green.shade700);
    });

    testWidgets('Adding spell uses green color and removing uses red color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showTopSnackBar(
                          context,
                          content: const Text('Spell ditambahkan'),
                          backgroundColor: Colors.green.shade700,
                        );
                      },
                      child: const Text('Add Spell'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        showTopSnackBar(
                          context,
                          content: const Text('Spell dihapus'),
                          backgroundColor: Colors.red.shade700,
                        );
                      },
                      child: const Text('Remove Spell'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      // Tap Add Spell
      await tester.tap(find.text('Add Spell'));
      await tester.pumpAndSettle();

      var snackBarWidget = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBarWidget.backgroundColor, Colors.green.shade700);
      expect(find.text('Spell ditambahkan'), findsOneWidget);

      // Clear first snackbar so it doesn't block tapping
      ScaffoldMessenger.of(tester.element(find.byType(Scaffold))).clearSnackBars();
      await tester.pumpAndSettle();

      // Tap Remove Spell
      await tester.tap(find.text('Remove Spell'));
      await tester.pumpAndSettle();

      snackBarWidget = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBarWidget.backgroundColor, Colors.red.shade700);
      expect(find.text('Spell dihapus'), findsOneWidget);
    });
  });
}
