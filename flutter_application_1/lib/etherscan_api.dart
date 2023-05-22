import 'package:etherscan_api/etherscan_api.dart';
import 'package:coingecko_api/coingecko_api.dart';

getEthereumPrice() async {
  CoinGeckoApi api = CoinGeckoApi();
  double? ethPrice = 0;
  final result =
      await api.simple.listPrices(ids: ['ethereum'], vsCurrencies: ['hkd']);
  ethPrice = result.data[0].getPriceIn('hkd');
  return ethPrice;
}

getBalance(address) async {
  final eth = EtherscanAPI(
      apiKey: 'UQP726MHXYGZXD1AA61YD7PABKI4XXXPJY',
      chain: EthChain.mainnet,
      enableLogs: false);
  final bal = await eth.balance(
    addresses: [address],
  );
  var result = bal.result;
  var balance = '0';
  if (result != null) {
    balance = result[0].balance;
  }
  print(balance);
  return balance;
}

getNetworkName(chainId) {
  switch (chainId) {
    case 1:
      return 'Ethereum Mainnet';
    case 3:
      return 'Ropsten Testnet';
    case 4:
      return 'Rinkeby Testnet';
    case 5:
      return 'Goreli Testnet';
    case 42:
      return 'Kovan Testnet';
    case 11155111:
      return 'Sepolia Testnet';
    case 137:
      return 'Polygon Mainnet';
    default:
      return 'Unknown Chain';
  }
}
