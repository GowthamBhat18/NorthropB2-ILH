import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wall_et_ui/screens/providers/wallet_provider.dart';
import 'package:wall_et_ui/screens/mscreen/create_or_import.dart';
import 'package:web3dart/web3dart.dart';
import 'package:wall_et_ui/screens/utils/get_balances.dart';
import 'package:wall_et_ui/screens/components/nft_balances.dart';
import 'package:wall_et_ui/screens/components/send_tokens.dart';
import 'dart:convert';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  String walletAddress = '';
  String balance = '';
  String pvKey = '';

  @override
  void initState() {
    super.initState();
    loadWalletData();
  }

  Future<void> loadWalletData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? privateKey = prefs.getString('privateKey');
    if (privateKey != null) {
      final walletProvider = WalletProvider();
      await walletProvider.loadPrivateKey();
      EthereumAddress address = await walletProvider.getPublicKey(privateKey);
      print(address.hex);
      setState(() {
        walletAddress = address.hex;
        pvKey = privateKey;
      });
      print(pvKey);
      String response = await getBalances(address.hex, 'sepolia');
      dynamic data = json.decode(response);
      String newBalance = data['balance'] ?? '0';

      // Transform balance from wei to ether
      EtherAmount latestBalance =
          EtherAmount.fromBigInt(EtherUnit.wei, BigInt.parse(newBalance));
      String latestBalanceInEther =
          latestBalance.getValueInUnit(EtherUnit.ether).toString();

      setState(() {
        balance = latestBalanceInEther;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Wallet'),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              padding: const EdgeInsets.fromLTRB(16.0, 60.0, 16.0, 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(

                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          'Wallet Address',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          walletAddress,
                          style: const TextStyle(
                            fontSize: 20.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  const Text(
                    'Balance',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    balance,
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    FloatingActionButton(
                      heroTag: 'sendButton', // Unique tag for send button
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SendTokensPage(privateKey: pvKey)),
                        );
                      },
                      child: const Icon(Icons.send),
                    ),
                    const SizedBox(height: 8.0),
                    const Text('Send'),
                  ],
                ),
                Column(
                  children: [
                    FloatingActionButton(
                      heroTag: 'refreshButton', // Unique tag for send button
                      onPressed: () {
                        setState(() {
                          // Update any necessary state variables or perform any actions to refresh the widget
                        });
                      },
                      child: const Icon(Icons.replay_outlined),
                    ),
                    const SizedBox(height: 8.0),
                    const Text('Refresh'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            Expanded(
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: Colors.blue,
                      tabs: [
                        Tab(text: 'Assets'),
                        Tab(text: 'NFTs'),
                        Tab(text: 'Options'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Assets Tab
                          Column(
                            children: [
                              Card(
                                margin: const EdgeInsets.all(16.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Sepolia ETH',
                                        style: TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        balance,
                                        style: const TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          // NFTs Tab
                          SingleChildScrollView(
                              child: NFTListPage(
                                  address: walletAddress, chain: 'sepolia')),
                          // Options Tab
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            margin: const EdgeInsets.all(100.0),
                            padding: const EdgeInsets.all(50.0),
                            child: Center(
                              child: ListTile(
                                leading: const Icon(Icons.logout),
                                title: const Text('Logout'),
                                onTap: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.remove('privateKey');
                                  // ignore: use_build_context_synchronously
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CreateOrImportPage(),
                                    ),
                                    (route) => false,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

