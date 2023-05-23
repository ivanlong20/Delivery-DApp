//https://github.com/Anonymousgaurav/flutter_blockchain_payment

import 'package:flutter/material.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

abstract class WalletConnector {
  Future<SessionStatus?> connect(BuildContext context);

  Future<String?> sendAmount({
    required String recipientAddress,
    required double amount,
  });

  

  Future<void> openWalletApp();

  Future<double> getBalance();

  bool validateAddress({required String address});

  String get networkName;

  String get faucetUrl;

  String get address;

  String get coinName;

  void registerListeners(
    OnConnectRequest? onConnect,
    OnSessionUpdate? onSessionUpdate,
    OnDisconnect? onDisconnect,
  );
}
