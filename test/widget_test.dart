import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:xyz_social/main.dart';
import 'package:xyz_social/app_state.dart';

void main() {
  testWidgets('App starts and shows XYZ', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => AppState(),
        child: const MaterialApp(home: MainNavigationScreen()),
      ),
    );

    expect(find.text('XYZ'), findsOneWidget);
    expect(find.byType(Card), findsWidgets);
  });

  testWidgets('Bottom navigation works', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => AppState(),
        child: const MaterialApp(home: MainNavigationScreen()),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);

    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();

    expect(find.text('Search Users'), findsOneWidget);
  });

  testWidgets('Like buttons work', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => AppState(),
        child: const MaterialApp(home: MainNavigationScreen()),
      ),
    );

    final likeButton = find.byIcon(Icons.favorite_border).first;
    await tester.tap(likeButton);
    await tester.pump();

    expect(find.byIcon(Icons.favorite), findsAtLeastNWidgets(1));
  });
}
