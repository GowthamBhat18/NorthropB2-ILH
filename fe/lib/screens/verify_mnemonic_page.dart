import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wall_et_ui/providers/wallet_provider.dart';
import 'package:wall_et_ui/screens/home_screen.dart';

class VerifyMnemonicPage extends StatefulWidget {
  final String mnemonic;

  const VerifyMnemonicPage({Key? key, required this.mnemonic})
      : super(key: key);

  @override
  _VerifyMnemonicPageState createState() => _VerifyMnemonicPageState();
}

class _VerifyMnemonicPageState extends State<VerifyMnemonicPage> {
  bool isVerified = false;
  String verificationText = '';

  void verifyMnemonic() {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);

    if (verificationText.trim() == widget.mnemonic.trim()) {
      walletProvider.getPrivateKey(widget.mnemonic).then((privateKey) {
        setState(() {
          isVerified = true;
        });
      });
    }
  }

  void navigateToWalletPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        title: const Text('Verify Mnemonic and Create'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(170, 0, 191, 255), // Blue color
              Color.fromARGB(255, 144, 238, 144), // Lighter sea green color
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        //extendBodyBehindAppBar: true,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color:
                      Colors.white.withOpacity(0.8), // Adjust opacity as needed
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Please verify your mnemonic phrase:',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(height: 24.0),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          verificationText = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Enter mnemonic phrase',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  verifyMnemonic();
                },
                child: const Text('Verify'),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: isVerified ? navigateToWalletPage : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
