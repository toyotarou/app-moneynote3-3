// test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('GreetingText が正しく表示される', (WidgetTester tester) async {
    // テスト対象ウィジェットを定義
    const MaterialApp testApp = MaterialApp(home: Scaffold(body: Center(child: Text('Hello, Money Note!'))));

    // ウィジェットをビルド
    await tester.pumpWidget(testApp);

    // 期待どおりにテキストが１つだけ見つかるかチェック
    expect(find.text('Hello, Money Note!'), findsOneWidget);
  });
}
