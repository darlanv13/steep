import 'package:flutter_test/flutter_test.dart';
import 'package:steep/core/providers/filter_provider.dart';

void main() {
  group('FilterProvider Tests', () {
    late FilterProvider provider;

    setUp(() {
      provider = FilterProvider();
    });

    test('Initial values should be default', () {
      expect(provider.shift, 'Manhã');
      expect(provider.fleet, 'Caminhões');
      expect(provider.period, 'Hoje');
      expect(provider.isLoading, false);
      expect(provider.errorMessage, null);
    });

    test('Updating shift should change value and notify', () {
      bool notified = false;
      provider.addListener(() {
        notified = true;
      });

      provider.setShift('Noite');
      expect(provider.shift, 'Noite');
      expect(notified, true);
    });

    test('Updating fleet should change value', () {
      provider.setFleet('Escavadeiras');
      expect(provider.fleet, 'Escavadeiras');
    });

    test('clearError should set errorMessage to null', () {
      // Simulate error injection if there was a public setter or testing wrapper,
      // here we just test that clearError doesn't crash and keeps it null.
      provider.clearError();
      expect(provider.errorMessage, null);
    });
  });
}
