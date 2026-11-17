import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fynza/shared/widgets/fading_scroll_boundary.dart';

void main() {
  testWidgets('applies edge mask without preventing vertical scrolling', (
    tester,
  ) async {
    final controller = ScrollController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FadingScrollBoundary(
            child: ListView.builder(
              controller: controller,
              itemCount: 30,
              itemBuilder: (_, index) => SizedBox(
                height: 48,
                child: Text('Row $index'),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(ShaderMask), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -180));
    await tester.pump();

    expect(controller.offset, greaterThan(0));
  });
}
