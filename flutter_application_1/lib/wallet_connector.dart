//Reference: https://github.com/Anonymousgaurav/flutter_blockchain_payment

import 'package:flutter/material.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

abstract class WalletConnector {
  Future<SessionStatus?> connect(BuildContext context);

  Future<String?> sendAmount({
    required String recipientAddress,
    required double amount,
  });

  Future<dynamic> callCreateDeliveryOrder(
      {required String receiverWalletAddress,
      required String senderAddress,
      required String senderDistrict,
      required String receiverAddress,
      required String receiverDistrict,
      required String packageDiscription,
      required BigInt packageHeight,
      required BigInt packageWidth,
      required BigInt packageDepth,
      required BigInt packageWeight,
      required bool payBySender,
      required BigInt deliveryFee,
      required BigInt productAmount});

  Future<dynamic> payBySender(
      {required BigInt orderID, required BigInt deliveryFee});

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
