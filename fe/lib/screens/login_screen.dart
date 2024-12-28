import 'package:flutter/material.dart';
import 'package:wall_et_ui/screens/providers/wallet_provider.dart';
import 'package:provider/provider.dart';
import 'package:wall_et_ui/screens/home_screen.dart';
import 'create_or_import.dart';

class LoginPagee extends StatelessWidget {
  const LoginPagee({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);

    if (walletProvider.privateKey == null) {
      // If private key doesn't exist, load CreateOrImportPage
      return const CreateOrImportPage();
    } else {
      // If private key exists, load WalletPage
      return HomeScreen();
    }
  }
}
