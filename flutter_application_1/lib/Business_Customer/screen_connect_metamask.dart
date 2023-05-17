//https://github.com/BhaskarDutta2209/FlutterAppWithMetamask
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:web3dart/crypto.dart';
import 'screen_home.dart';
import '../etherscan_api.dart';
import '../screen_user_selection.dart';

// import 'package:web3dart/web3dart.dart';
// import 'package:flutter_web3/flutter_web3.dart';
var _signature, _session, _uri;

getAddress() {
  return _session.accounts[0].toString();
}

getNetwork() {
  return _session.chainId;
}

class ConnectMetamaskPage extends StatefulWidget {
  const ConnectMetamaskPage({super.key, required this.title});
  final String title;
  @override
  State<ConnectMetamaskPage> createState() => _ConnectMetamaskState();
}

class _ConnectMetamaskState extends State<ConnectMetamaskPage> {
  var connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
          name: 'Delivery DApp',
          description: 'A Dapp for Delivery',
          url: 'https://walletconnect.org',
          icons: [
            'https://files.gitbook.com/v0/b/gitbook-legacy-files/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
          ]));

  loginUsingMetamask(BuildContext context) async {
    if (!connector.connected) {
      try {
        var session = await connector.createSession(onDisplayUri: (uri) async {
          _uri = uri;
          await launchUrlString(uri, mode: LaunchMode.externalApplication);
        });
        print(session.accounts[0]);
        print(session.chainId);
        setState(() {
          _session = session;
        });
      } catch (exp) {
        print(exp);
      }
    }
  }

  signMessageWithMetamask(BuildContext context, String message) async {
    if (connector.connected) {
      try {
        print("Message received");
        print(message);

        EthereumWalletConnectProvider provider =
            EthereumWalletConnectProvider(connector);
        launchUrlString(_uri, mode: LaunchMode.externalApplication);
        var signature = await provider.personalSign(
            message: message, address: _session.accounts[0], password: "");
        print(signature);
        setState(() {
          _signature = signature;
        });
      } catch (exp) {
        print("Error while signing transaction");
        print(exp);
      }
    }
  }

  String truncateString(String text, int front, int end) {
    int size = front + end;

    if (text.length > size) {
      String finalString =
          "${text.substring(0, front)}...${text.substring(text.length - end)}";
      return finalString;
    }

    return text;
  }

  String generateSessionMessage(String accountAddress) {
    String message =
        'Hello $accountAddress, welcome to our app. By signing this message you agree to learn and have fun with blockchain';
    print(message);

    var hash = keccakUtf8(message);
    final hashString = '0x${bytesToHex(hash).toString()}';

    return hashString;
  }

  @override
  Widget build(BuildContext context) {
    final String assetName = 'assets/icon/metamask-fox.svg';
    final Widget svg = SvgPicture.asset(assetName);

    connector.on(
        'connect',
        (session) => setState(
              () {
                _session = _session;
              },
            ));
    connector.on(
        'session_update',
        (payload) => setState(() {
              _session = payload;
              print(_session.accounts[0]);
              print(_session.chainId);
            }));
    connector.on(
        'disconnect',
        (payload) => setState(() {
              _session = null;
            }));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: (_session != null)
              ? Container(
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
                              '${_session.accounts[0]}',
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
                                        getNetworkName(_session.chainId),
                                        style: const TextStyle(fontSize: 18),
                                      )
                                    ])
                                // ],
                                // ),
                                // const SizedBox(height: 20),
                                // (_session.chainId != 1)
                                //     ? Row(
                                //         children: const [
                                //           Icon(Icons.warning,
                                //               color: Colors.redAccent, size: 15),
                                //           Text('Network not supported. Switch to '),
                                //           Text(
                                //             'Ethereum Mainnet',
                                //             style: TextStyle(fontWeight: FontWeight.bold),
                                //           )
                                //         ],
                                //       )
                                //     : (_signature == null)
                                //         ? Container(
                                //             alignment: Alignment.center,
                                //             child: ElevatedButton(
                                //                 onPressed: () => signMessageWithMetamask(
                                //                     context,
                                //                     generateSessionMessage(
                                //                         _session.accounts[0])),
                                //                 child: const Text('Sign Message')),
                                //           )
                                //         : Column(
                                //             crossAxisAlignment: CrossAxisAlignment.center,
                                //             children: [
                                //               Row(
                                //                 children: [
                                //                   Text(
                                //                     "Signature: ",
                                //                     style: TextStyle(
                                //                         fontWeight: FontWeight.bold,
                                //                         fontSize: 16),
                                //                   ),
                                //                   Text(
                                //                       truncateString(
                                //                           _signature.toString(), 4, 2),
                                //                       style: TextStyle(fontSize: 16))
                                //                 ],
                                //               ),
                                ,
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
                                            title: 'Send Package',
                                            connector: connector,
                                            session: _session,
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
                      ]))
              : FilledButton(
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
                    onPressed: () => loginUsingMetamask(context),
                  ),
                )),
    );
  }
}
