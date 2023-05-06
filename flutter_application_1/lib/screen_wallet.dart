import 'package:flutter/material.dart';
import 'package:etherscan_api/etherscan_api.dart';
import 'screen_home.dart';

class WalletPage extends StatefulWidget {
  final String title;
  final session, connector;
  WalletPage(
      {Key? key,
      required this.title,
      required this.session,
      required this.connector})
      : super(key: key);
  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  Widget build(BuildContext context) {
    final address = widget.session.accounts[0].toString();
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
                child: Column(children: [
              Row(children: [
                Text(
                  'Balance',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
                )
              ]),
              Row(children: [
                FutureBuilder<dynamic>(
                    future: getBalance(address),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        var balance = int.parse(snapshot.data) *
                            (1 / 1000000000000000000);
                        return Text(
                          balance.toStringAsFixed(5),
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 36,
                          ),
                        );
                      } else {
                        return Text(
                          '0',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 36,
                          ),
                        );
                      }
                    }),
                Text(' ETH',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ))
              ]),
              Row(
                children: [
                  Text(
                      widget.connector.connected
                          ? getNetworkName(widget.session.chainId)
                          : 'Not Connected',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16,
                      ))
                ],
              )
            ])),
            ListTile(
              leading: Icon(Icons.local_shipping_rounded),
              title: Text('Ship'),
              onTap: openHomePage,
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Order Tracking & History'),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Message'),
            ),
            ListTile(
                leading: Icon(Icons.wallet),
                title: Text('Wallet'),
                onTap: openWalletPage),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: getBalance(widget.session.accounts[0].toString()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text('Balance: ${snapshot.data}');
                } else {
                  return Text('Loading...');
                }
              },
            ),
          ],
        ),
      ),
    );
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

  openWalletPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WalletPage(
              title: 'Wallet',
              session: widget.session,
              connector: widget.connector)),
    );
  }

  openHomePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HomePage(
              title: 'Ship',
              session: widget.session,
              connector: widget.connector)),
    );
  }
}
