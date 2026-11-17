import '../../models/app_currency.dart';

abstract interface class CurrencyRepository {
  AppCurrency getCurrency();
  Future<void> setCurrency(AppCurrency currency);
  CustomCurrencyDetails? getCustomDetails();
  Future<void> setCustomDetails(CustomCurrencyDetails details);
  Future<void> clearCustomDetails();
}
