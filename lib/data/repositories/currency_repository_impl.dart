import '../../core/services/currency_service.dart';
import '../../shared/domain/repositories/currency_repository.dart';
import '../../shared/models/app_currency.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyService _service;

  const CurrencyRepositoryImpl(this._service);

  @override
  AppCurrency getCurrency() => _service.getCurrency();

  @override
  Future<void> setCurrency(AppCurrency currency) =>
      _service.setCurrency(currency);

  @override
  CustomCurrencyDetails? getCustomDetails() => _service.getCustomDetails();

  @override
  Future<void> setCustomDetails(CustomCurrencyDetails details) =>
      _service.setCustomDetails(details);

  @override
  Future<void> clearCustomDetails() => _service.clearCustomDetails();
}
