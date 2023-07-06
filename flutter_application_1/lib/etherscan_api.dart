import 'package:coingecko_api/coingecko_api.dart';

getEthereumPrice() async {
  CoinGeckoApi api = CoinGeckoApi();
  double? ethPrice = 0;
  final result =
      await api.simple.listPrices(ids: ['ethereum'], vsCurrencies: ['hkd']);
  ethPrice = result.data[0].getPriceIn('hkd');
  return ethPrice;
}
