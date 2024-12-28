// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wall_et_ui/screens/providers/wallet_provider.dart';
import 'package:wall_et_ui/screens/mscreen/wallet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../home_screen.dart';

class ImportWallet extends StatefulWidget {
  const ImportWallet({Key? key}) : super(key: key);

  @override
  _ImportWalletState createState() => _ImportWalletState();
}

class _ImportWalletState extends State<ImportWallet> {
  bool isVerified = false;

  String verificationText = '';

  void navigateToWalletPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    void verifyMnemonic() async {
      final walletProvider =
          Provider.of<WalletProvider>(context, listen: false);

      // Call the getPrivateKey function from the WalletProvider
      final privateKey = await walletProvider.getPrivateKey(verificationText);

      // Navigate to the WalletPage
      navigateToWalletPage();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Keep the background transparent
        title: const Text(
          'Import From Seed',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Makes the text bold
            fontSize: 26, // Optional: Adjust the font size if needed
            color: Colors.white, // Set the text color to blue
          ),
        ),
        centerTitle: true, // Centers the title text
        automaticallyImplyLeading:
            false, // Disables the leading back button (optional)
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
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
                      Colors.white.withOpacity(0.9), // Adjust opacity as needed
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Please Enter your mnemonic phrase:',
                      style: TextStyle(fontSize: 20.0),
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
              Positioned(
                top: 686
                    .h, // Positioning the button at a specific height (responsive)
                width: 375.w, // Set the width based on screen size
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 30.w), // Padding around the button
                  child: ElevatedButton(
                    onPressed: () {
                      verifyMnemonic(); // Call the verification function
                    },
                    style: ElevatedButton.styleFrom(
                      // primary: Theme.of(context).colorScheme.secondary, // Button background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10.w), // Rounded corners
                      ),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      padding: EdgeInsets.symmetric(
                          vertical: 12.h), // Vertical padding to make it taller
                    ),
                    child: Center(
                      child: Text(
                        'Import',
                        style: TextStyle(
                          fontSize: 18.sp, // Responsive font size
                          fontWeight: FontWeight.w500, // Medium weight
                          color: Theme.of(context)
                              .colorScheme
                              .tertiary, // Text color
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
