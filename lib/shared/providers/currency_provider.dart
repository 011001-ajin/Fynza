import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/database_provider.dart';
import '../domain/repositories/currency_repository.dart';
import '../models/app_currency.dart';

final selectedCurrencyProvider =
    StateNotifierProvider<SelectedCurrencyNotifier, AppCurrency>((ref) {
      return SelectedCurrencyNotifier(ref.watch(currencyRepositoryProvider));
    });

class SelectedCurrencyNotifier extends StateNotifier<AppCurrency> {
  final CurrencyRepository _repository;

  SelectedCurrencyNotifier(this._repository) : super(_repository.getCurrency());

  Future<void> setCurrency(AppCurrency currency) async {
    await _repository.setCurrency(currency);
    state = currency;
  }
}

final customCurrencyProvider =
    StateNotifierProvider<CustomCurrencyNotifier, CustomCurrencyDetails?>((
      ref,
    ) {
      return CustomCurrencyNotifier(ref.watch(currencyRepositoryProvider));
    });

class CustomCurrencyNotifier extends StateNotifier<CustomCurrencyDetails?> {
  final CurrencyRepository _repository;

  CustomCurrencyNotifier(this._repository)
    : super(_repository.getCustomDetails());

  Future<void> setDetails(CustomCurrencyDetails details) async {
    await _repository.setCustomDetails(details);
    state = details;
  }

  Future<void> clearDetails() async {
    await _repository.clearCustomDetails();
    state = null;
  }
}
