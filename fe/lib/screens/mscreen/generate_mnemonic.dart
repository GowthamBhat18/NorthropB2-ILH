import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wall_et_ui/screens/providers/wallet_provider.dart';
import 'package:wall_et_ui/screens/mscreen/verify_mnemonic_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GenerateMnemonicPage extends StatelessWidget {
  const GenerateMnemonicPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);
    final mnemonic = walletProvider.generateMnemonic();
    final mnemonicWords = mnemonic.split(' ');

    void copyToClipboard() {
      Clipboard.setData(ClipboardData(text: mnemonic));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mnemonic Copied to Clipboard')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyMnemonicPage(mnemonic: mnemonic),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Keep the background transparent
        title: Text(
          'Generate Mnemonic',
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color:
                      Colors.white.withOpacity(0.9), // Adjust opacity as needed
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Please store this mnemonic phrase safely:',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    const SizedBox(height: 24.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(
                        mnemonicWords.length,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            '${index + 1}. ${mnemonicWords[index]}',
                            style: const TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40.0),
              ElevatedButton.icon(
                onPressed: () {
                  copyToClipboard(); // Your action here
                },
                icon: Icon(
                  Icons.copy,
                  color: Colors.black, // Same icon color as text
                ),
                label: Text(
                  'Copy to Clipboard',
                  style: TextStyle(
                    fontSize: 18.sp, // Same font size as the first button
                    fontWeight: FontWeight.w500, // Same font weight
                    color: /* Theme.of(context).colorScheme.primary, // Text color */
                        Colors.black,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.h, // Same vertical padding as the first button
                    horizontal: 16.w, // Horizontal padding to make it look good
                  ),
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .secondary, // Same background color
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10.w), // Rounded corners
                  ),
                  elevation: 4,
                  shadowColor: Colors.black
                      .withOpacity(0.4), // Optional, for shadow effect
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
