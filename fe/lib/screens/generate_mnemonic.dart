import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wall_et_ui/providers/wallet_provider.dart';
import 'package:wall_et_ui/screens/verify_mnemonic_page.dart';

class GenerateMnemonicPage extends StatefulWidget {
  const GenerateMnemonicPage({Key? key}) : super(key: key);

  @override
  State<GenerateMnemonicPage> createState() => _GenerateMnemonicPageState();
}

class _GenerateMnemonicPageState extends State<GenerateMnemonicPage> {
  String mnemonic = ''; // To store the mnemonic string
  List<String> mnemonicWords = []; // To store the list of mnemonic words

  void initState() async {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Get the instance of SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Fetch the values from shared preferences
    // Fetch the values from shared preferences
    String? mnemonicString = prefs.getString('mnemonicstring');
    List<String>? mnemonicList = prefs.getStringList('mlist');

    // Assign values or set defaults if they are null
    setState(() {
      mnemonic = mnemonicString ?? ''; // Assign empty string if null
      mnemonicWords = mnemonicList ?? []; // Assign empty list if null
    });

    // You can use these variables as needed
    print('Mnemonic String: $mnemonic');
    print('Mnemonic Words: $mnemonicWords');
  }

  @override
  Widget build(BuildContext context) {
    // final walletProvider = Provider.of<WalletProvider>(context);
    // final mnemonic = walletProvider.generateMnemonic();
    // final mnemonicWords = mnemonic.split(' ');

    // void copyToClipboard() {
    //   Clipboard.setData(ClipboardData(text: mnemonic));
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Mnemonic Copied to Clipboard')),
    //   );

    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => VerifyMnemonicPage(mnemonic: mnemonic),
    //     ),
    //   );
    // }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Generate Mnemonic'),
      ),
      extendBodyBehindAppBar: true,
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color:
                      Colors.white.withOpacity(0.8), // Adjust opacity as needed
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Please store this mnemonic phrase safely:',
                      style: TextStyle(fontSize: 18.0),
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
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton.icon(
                onPressed: () {
                  //copyToClipboard();
                },
                icon: const Icon(Icons.copy),
                label: const Text('Copy to Clipboard'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(25.0),
                  textStyle: const TextStyle(fontSize: 20.0),
                  elevation: 4,
                  shadowColor: Colors.black.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
