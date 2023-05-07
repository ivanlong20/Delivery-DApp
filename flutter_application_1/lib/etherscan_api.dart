import 'package:etherscan_api/etherscan_api.dart';

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
    case 137:
      return 'Polygon Mainnet';
    default:
      return 'Unknown Chain';
  }
}
