//Reference: https://github.com/Anonymousgaurav/flutter_blockchain_payment

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'screen_home.dart';
import '../screen_user_selection.dart';
import '../wallet_connector.dart';
import '../ethereum_connector.dart';

late WalletConnector connector;
ConnectionState _state = ConnectionState.disconnected;
var provider;

enum ConnectionState {
  disconnected,
  connecting,
  connected,
  connectionFailed,
  connectionCancelled,
}

class ConnectMetamaskPage extends StatefulWidget {
  const ConnectMetamaskPage({super.key, required this.title});
  final String title;
  @override
  State<ConnectMetamaskPage> createState() => _ConnectMetamaskState();
}

class _ConnectMetamaskState extends State<ConnectMetamaskPage> {
  @override
  void initState() {
    initializeInstance();
    super.initState();
  }

  Future<void> initializeInstance() async {
    connector = EthereumConnector();
    await connector.initWalletConnect();
    provider = connector.getProvider();
    provider.onSessionConnect.subscribe((session) {
      if (session == null) {
        _state = ConnectionState.disconnected;
      } else {
        _state = ConnectionState.connected;
      }
      setState(() {});
    });
    print("done");
  }

  @override
  Widget build(BuildContext context) {
    final String assetName = 'assets/icon/metamask-fox.svg';
    final Widget svg = SvgPicture.asset(assetName);

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: (_state != ConnectionState.connected)
                ? FilledButton(
                    style: FilledButton.styleFrom(
                        minimumSize: const Size(100, 75),
                        maximumSize: const Size(350, 75),
                        backgroundColor: const Color.fromARGB(255, 0, 0, 0)),
                    onPressed: () {},
                    child: FloatingActionButton.extended(
                      label: const Text(
                          style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontSize: 22,
                              fontWeight: FontWeight.w600),
                          'Login with Metamask'), // <-- Text
                      backgroundColor: Colors.black,
                      icon: Container(child: svg, width: 50, height: 50),
                      onPressed: () => connector.connect(context),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Account',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 24),
                              ),
                              Text(
                                '${connector.address}',
                                style: TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 25),
                              Row(
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Chain',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 24),
                                        ),
                                        Text(
                                          connector.networkName,
                                          style: const TextStyle(fontSize: 18),
                                        )
                                      ]),
                                ],
                              ),
                              const SizedBox(height: 100),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(children: [
                                    TextButton(
                                      style: FilledButton.styleFrom(
                                        minimumSize: const Size(200, 50),
                                        maximumSize: const Size(250, 75),
                                        backgroundColor:
                                            const Color.fromARGB(255, 0, 0, 0),
                                      ),
                                      onPressed: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return HomePage(
                                              title: 'View Available Orders',
                                              connector: connector,
                                            );
                                          }),
                                        );
                                      },
                                      child: const Text(
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1),
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600),
                                          'Login'),
                                    ),
                                    const SizedBox(height: 30),
                                    OutlinedButton(
                                      style: FilledButton.styleFrom(
                                        minimumSize: const Size(200, 50),
                                        maximumSize: const Size(250, 75),
                                      ),
                                      onPressed: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return const UserSelectionPage(
                                                title: 'Landing Page');
                                          }),
                                        );
                                      },
                                      child: const Text(
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(70, 70, 70, 1),
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600),
                                          'Back'),
                                    )
                                  ])
                                ],
                              )
                            ],
                          )
                        ]))));
  }

  void _openWalletPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            HomePage(title: 'Available Orders', connector: connector),
      ),
    );
  }
}
