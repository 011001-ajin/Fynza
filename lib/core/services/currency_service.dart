import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/models/app_currency.dart';

class CurrencyService {
  static const _keyCode = 'app_currency_code';
  static const _keyCustomSymbol = 'custom_currency_symbol';
  static const _keyCustomCode = 'custom_currency_code';
  static const _keyCustomName = 'custom_currency_name';

  final SharedPreferences _prefs;

  CurrencyService(this._prefs);

  AppCurrency getCurrency() {
    final code = _prefs.getString(_keyCode) ?? 'USD';
    return AppCurrency.fromCode(code);
  }

  Future<void> setCurrency(AppCurrency currency) async {
    await _prefs.setString(_keyCode, currency.code);
  }

  CustomCurrencyDetails? getCustomDetails() {
    final symbol = _prefs.getString(_keyCustomSymbol);
    final code = _prefs.getString(_keyCustomCode);
    final name = _prefs.getString(_keyCustomName);
    if (symbol == null || code == null || name == null) return null;
    return CustomCurrencyDetails(symbol: symbol, code: code, name: name);
  }

  Future<void> setCustomDetails(CustomCurrencyDetails details) async {
    await _prefs.setString(_keyCustomSymbol, details.symbol);
    await _prefs.setString(_keyCustomCode, details.code);
    await _prefs.setString(_keyCustomName, details.name);
  }

  Future<void> clearCustomDetails() async {
    await _prefs.remove(_keyCustomSymbol);
    await _prefs.remove(_keyCustomCode);
    await _prefs.remove(_keyCustomName);
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

final currencyServiceProvider = Provider<CurrencyService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return CurrencyService(prefs);
});
