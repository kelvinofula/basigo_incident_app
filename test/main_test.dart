import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:basigo_incident_app/app/my_app.dart';
import 'package:basigo_incident_app/views/driver_home_page.dart';
import 'package:basigo_incident_app/views/dispatcher_home_page.dart';
import 'package:basigo_incident_app/models/incident_model.dart';

/// Unit Tests
void main() {
  test('Incident model serialization', () {
    final incident = Incident(
      id: '1',
      title: 'Test',
      severity: 'High',
      notes: 'Example',
      status: 'Pending',
    );
    final map = incident.toMap();
    expect(map['id'], '1');
    expect(map['title'], 'Test');
    expect(map['severity'], 'High');
    expect(map['notes'], 'Example');
    expect(map['status'], 'Pending');
  });

  testWidgets('Login screen contains buttons', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    expect(find.text('Login as Driver'), findsOneWidget);
    expect(find.text('Login as Dispatcher'), findsOneWidget);
  });

  testWidgets('Driver dashboard loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: DriverHomePage())),
    );
    expect(find.text('Report an Incident'), findsOneWidget);
    expect(find.text('Report New Incident'), findsOneWidget);
  });

  testWidgets('Dispatcher dashboard loads correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: DispatcherHomePage())),
    );
    expect(find.text('Incident Reports'), findsOneWidget);
  });
}
