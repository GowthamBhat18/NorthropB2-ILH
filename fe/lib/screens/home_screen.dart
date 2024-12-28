import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wall_et_ui/screens/send_money_screen.dart';
import 'package:wall_et_ui/widgets/horizontal_spacer.dart';
import 'package:wall_et_ui/widgets/vertical_spacer.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../base_url.dart';
import '../providers/wallet_provider.dart';
import '../widgets/primary_button.dart';

enum TransactionType { send, request }

class Transation {
  String userImage;
  String userName;
  String dateTime;
  double amount;
  TransactionType transactionType;

  Transation(
      {required this.userImage,
      required this.userName,
      required this.dateTime,
      required this.amount,
      required this.transactionType});
}

class Card {
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;

  Card({
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
  });
}

final List<Card> cards = [
  Card(
    cardNumber: "1234  5678  9123  4567",
    cardHolderName: "John",
    expiryDate: "02/23",
  ),
  Card(
    cardNumber: "1234  5678  9123  4567",
    cardHolderName: "Rob",
    expiryDate: "02/23",
  ),
  Card(
    cardNumber: "1234  5678  9123  4567",
    cardHolderName: "Tanya Robinson",
    expiryDate: "02/23",
  ),
];

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double balanceBc = 0;
  String nameUser = '';
  int? retrivedUserId;
  int senderUserId = 2;
  final walletProvider = WalletProvider();

  // Future<void> fetchBalance() async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     retrivedUserId = prefs.getInt('loggedUserID') ?? 1;
  //     print('******************NEW URL *******************');
  //     print(retrivedUserId);
  //     print(getBalanceUrl + retrivedUserId.toString());
  //     // SharedPreferences prefs = await SharedPreferences.getInstance();
  //     // retrivedUserId = prefs.getInt('loggedUserID') ?? 1;
  //     // String newUserId = getBalance2Url+retrivedUserId.toString();
  //     // print(newUserId);
  //     final response = await http
  //         .get(Uri.parse(getBalanceUrl + '/' + retrivedUserId.toString()));
  //
  //     if (response.statusCode == 200) {
  //       dynamic data = json.decode(response.body)['balanceAmount'];
  //
  //       print(data);
  //       setState(() {
  //         balance = data;
  //       });
  //     } else {
  //       // If the server did not return a 200 OK response, throw an exception.
  //       throw Exception('Failed to load Balance');
  //     }
  //   } catch (error) {
  //     print('Error: $error');
  //   }
  // }
  Future<List<Transaction>> fetchTransactions() async {
    const url =
        'http://192.168.36.199:3000/ethereum/getTransactions/0xC4B6eeF041db4F5864f06D536569aa6BB3D4ed05';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List<dynamic>;
        return data.map((tx) => Transaction.fromJson(tx)).toList();
      } else {
        throw Exception(
            'Failed to fetch transactions. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching transactions: $error');
      return [];
    }
  }

  List<Transaction> transations = [];

  Future<void> _loadTransactions() async {
    final fetchedTransactions = await fetchTransactions();
    setState(() {
      transations = fetchedTransactions;
    });
  }

  String? standardGasPrice;
  Future<void> getGasPrice() async {
    try {
      // Define the API URL
      final url = 'http://192.168.36.199:3000/ethereum/getGasPrice';

      // Make the GET request
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Parse the JSON response
        final data = json.decode(response.body);
        print('*******GAS CALL*(******)');
        // Extract the 'standard' gas price
        standardGasPrice = data['data']['standard'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('standardGasPrice', standardGasPrice!);
        print('Standard Gas Price: $standardGasPrice');
        // Use the gas price as needed in your application
      } else {
        throw Exception(
            'Failed to fetch gas price. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> getBalance() async {
    try {
      // Load private key from shared preferences or wallet provider
      await walletProvider.loadPrivateKey();

      if (walletProvider.privateKey == null) {
        throw Exception('Private key not found');
      }

      // Get the public key (Ethereum address) using the private key
      final publicKey =
          await walletProvider.getPublicKey(walletProvider.privateKey!);

      print('Public KEY ******* $publicKey');
      // Call the GET API with the public key
      final url =
          'http://192.168.36.199:3000/ethereum/getBalance/0xC4B6eeF041db4F5864f06D536569aa6BB3D4ed05';
      final response = await http.get(Uri.parse(url));
      print('PRE IF ******** Balance: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the balance as a float
        balanceBc = double.parse(response.body);

        print('Balance: $balanceBc');
        // Use the balance in your app (e.g., update the state or notify listeners)
      } else {
        throw Exception(
            'Failed to fetch balance. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> fetchUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      retrivedUserId = prefs.getInt('loggedUserID') ?? 1;
      print('******************NEW URL *******************');
      print(retrivedUserId);
      print(getNameUrl + retrivedUserId.toString());

      final response = await http
          .get(Uri.parse(getNameUrl + '/' + retrivedUserId.toString()));

      if (response.statusCode == 200) {
        dynamic data = json.decode(response.body)['name'];

        print(data);
        setState(() {
          nameUser = data;
        });
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load Balance');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    //fetchBalance();
    fetchUser();
    getBalance();
    getGasPrice();
    _loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Sliver for the header section (Stack with background)
          SliverToBoxAdapter(
            child: Stack(
              children: [
                // Container with reduced height and rounded bottom left corner
                Container(
                  height: 240.h, // Reduced height
                  width: 375.w,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.only(
                      bottomLeft:
                          Radius.circular(20.w), // Rounded bottom left corner
                    ),
                  ),
                ),
                CustomPaint(
                  size: Size(375.w,
                      240.h), // Adjusted CustomPaint size to match the container height
                  painter: DrawTriangleShape(),
                ),
                Positioned(
                  top: 48.h,
                  width: 375.w,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 24.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                            children: const [
                              TextSpan(
                                  text: "NorthropB2",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize
                              .min, // Ensures that Column only takes the space it needs
                          crossAxisAlignment: CrossAxisAlignment
                              .center, // Centers the children horizontally
                          children: [
                            SizedBox(
                              width: 40.h, // Size of the CircleAvatar
                              height: 40.h, // Size of the CircleAvatar
                              child: FittedBox(
                                child: CircleAvatar(
                                  backgroundColor:
                                      Colors.amber, // Amber background
                                  radius: 30
                                      .h, // Half of the width/height to make it circular
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.copy, // Use the built-in copy icon
                                      color: Colors.black, // Icon color black
                                      size: 30
                                          .h, // Icon size (adjust to fit inside the CircleAvatar)
                                    ),
                                    onPressed: () {
                                      // Handle the copy action here
                                      Clipboard.setData(ClipboardData(
                                          text: "Your text to copy"));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('Copied to clipboard')),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                                height: 8.h), // Space between icon and text
                            Text(
                              "Address",
                              style: TextStyle(
                                fontSize:
                                    12.sp, // Adjust the font size as needed
                                color: Colors.white, // Text color
                                fontWeight: FontWeight
                                    .w500, // Light weight for the text
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  top: 142.h,
                  child: Padding(
                    padding: EdgeInsets.only(left: 30.w, right: 130.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left side: Total Balance
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total Balance (ETH)",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                                height: 8.h), // Space between label and value
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                children: [
                                  TextSpan(
                                    text: balanceBc
                                        .toString(), // The balance number
                                    style: TextStyle(
                                      fontWeight: FontWeight
                                          .bold, // Make the balance bold
                                      fontSize: 32
                                          .sp, // Keeping the same size for the balance
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        // Right side: Gas Price
                        Padding(
                          padding: EdgeInsets.only(left: 30.w, right: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Gas Price",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  InkWell(
                                    onTap: () {
                                      print("Dynamic icon tapped");
                                    },
                                    child: Icon(
                                      Icons.autorenew,
                                      color: Colors.white,
                                      size: 18.sp,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                  height: 8.h), // Space between label and value
                              Padding(
                                  padding: EdgeInsets.only(right: 20.w),
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: double.tryParse(
                                                      standardGasPrice!)
                                                  ?.toStringAsFixed(2) ??
                                              standardGasPrice, // Format to 2 decimals
                                          style: TextStyle(
                                            fontWeight: FontWeight
                                                .bold, // Make the balance bold
                                            fontSize: 20
                                                .sp, // Keeping the same size for the balance
                                          ),
                                        ),
                                        TextSpan(
                                          text: " gwei", // The ETH part
                                          style: TextStyle(
                                            fontWeight:
                                                FontWeight.w400, // Less bold
                                            fontSize: 20
                                                .sp, // Smaller font size for ETH
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
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

          SliverList(
            delegate: SliverChildListDelegate([
              const VerticalSpacer(height: 24),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Pay through NFC",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20.sp,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        SizedBox(
                          width: 41.w,
                          height: 24.h,
                          child: FittedBox(
                            child: SvgPicture.asset(
                              "assets/images/nfc_icon_b.svg",
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SendMoneyScreen(),
                              ),
                            );
                          },
                          child: Container(
                            height: 49.h,
                            width: 165.w,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(10.w),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 21.w,
                                  height: 21.h,
                                  child: FittedBox(
                                    child: SvgPicture.asset(
                                      "assets/images/send_icon.svg",
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                const HorizontalSpacer(width: 4),
                                Text(
                                  "Send Money",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => _showConfimrationDialog(context),
                          child: Container(
                            height: 49.h,
                            width: 165.w,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(10.w),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 21.w,
                                  height: 21.h,
                                  child: FittedBox(
                                    child: SvgPicture.asset(
                                      "assets/images/request_icon.svg",
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                const HorizontalSpacer(width: 4),
                                Text(
                                  "Request Money",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),

              // "My Cards" section (currently commented out)
              // const HorizontalSpacer(width: 22),
              // Text(
              //   "My Cards",
              //   style: TextStyle(
              //     fontWeight: FontWeight.w700,
              //     fontSize: 16.sp,
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(22.0),
              //   child: SizedBox(
              //     height: 170.h,
              //     child: ListView.separated(
              //       scrollDirection: Axis.horizontal,
              //       itemBuilder: (context, index) => PaymentCard(
              //         card: cards[index],
              //       ),
              //       separatorBuilder: (context, index) =>
              //           const HorizontalSpacer(width: 15),
              //       itemCount: cards.length,
              //     ),
              //   ),
              // ),

              const VerticalSpacer(height: 24),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Last Transactions",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                    ),
                    /* InkWell(
                      onTap: () {},
                      child: Text(
                        "View All",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ) */
                  ],
                ),
              ),
              ..._buildTransactionsList(),
            ]),
          ),
        ],
      ),
    );
  }

  _showConfimrationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.w),
        ),
        child: SizedBox(
          height: 390.h,
          width: 327.w,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
            ),
            child: Column(
              children: [
                const VerticalSpacer(height: 40),
                SizedBox(
                  width: 240.w,
                  height: 180.h,
                  child: FittedBox(
                    child:
                        SvgPicture.asset('assets/images/sent_illustration.svg'),
                    fit: BoxFit.fill,
                  ),
                ),
                const VerticalSpacer(height: 35),
                Text(
                  "Place the device near NFC.",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                const VerticalSpacer(height: 20),
                InkWell(
                  onTap: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Container(
                    height: 49.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(10.w),
                    ),
                    child: Center(
                      child: Text(
                        "Close",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTransactionsList() {
    if (transations.isNotEmpty) {
      return [
        const VerticalSpacer(height: 16),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: transations.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) => const VerticalSpacer(
                  height: 16,
                ),
                itemBuilder: (context, index) => TransactionCard(
                  transaction: transations[index],
                ),
              ),
            ),
          ),
        )
      ];
    } else {
      return [
        const VerticalSpacer(height: 89),
        SvgPicture.asset("assets/images/empty_illustration.svg"),
        const VerticalSpacer(height: 16),
        Text(
          "There’s no transactions till now!",
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black.withOpacity(0.5),
          ),
        )
      ];
    }
  }
}

class NavigationButton extends StatelessWidget {
  const NavigationButton({
    Key? key,
    required this.isActive,
    required this.title,
    required this.icon,
  }) : super(key: key);

  final bool isActive;
  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.h,
      width: 82.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 20.w,
            height: 20.h,
            child: FittedBox(
              child: SvgPicture.asset(
                "assets/images/$icon.svg",
                color: isActive ? Colors.black : Colors.black.withOpacity(0.3),
              ),
              fit: BoxFit.fill,
            ),
          ),
          const VerticalSpacer(height: 6),
          Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.black : Colors.black.withOpacity(0.3),
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  final Transaction transaction;

  String formatCurrency(double amount) {
    double ethAmount = amount / 1e18; // Convert Wei to ETH
    return '${ethAmount.toStringAsFixed(6)}'; // Format to 2 decimals
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 49.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // User details (from and to)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // "To" text
                Container(
                  width: MediaQuery.of(context).size.width *
                      0.4, // Adjust width as needed
                  child: Text(
                    'To: ${transaction.to}',
                    style: TextStyle(
                        fontSize: 14.sp, color: const Color(0xFF1A1A1A)),
                    overflow: TextOverflow.ellipsis, // Prevent overflow
                  ),
                ),
                // "From" text
                Container(
                  width: MediaQuery.of(context).size.width *
                      0.4, // Adjust width as needed
                  child: Text(
                    'From: ${transaction.from}',
                    style: TextStyle(
                        fontSize: 14.sp, color: const Color(0xFF1A1A1A)),
                    overflow: TextOverflow.ellipsis, // Prevent overflow
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Transaction details (value and gas)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    formatCurrency(transaction.value) +
                        ' ETH', // Add 'ETH' as unit
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      overflow:
                          TextOverflow.ellipsis, // Prevent overflow for value
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    'Gas: ${transaction.gas.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF1A1A1A).withOpacity(0.6),
                      overflow:
                          TextOverflow.ellipsis, // Prevent overflow for gas
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

class Transaction {
  final String from;
  final String to;
  final double gas;
  final double value;

  Transaction({
    required this.from,
    required this.to,
    required this.gas,
    required this.value,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
        from: json['from'],
        to: json['to'],
        gas: double.parse(json['gas']),
        value: double.parse(json['value']));
  }
}

class DrawTriangleShape extends CustomPainter {
  Paint painter = Paint()
    ..color = const Color(0xFF3491DB)
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();

    double radius = 35.h;

    // Start from the top-left corner
    path.moveTo(0, 0); // Start at the top-left corner

    // Draw the top edge to the top-right corner
    path.lineTo(size.width, 0); // Draw a line to the top-right corner

    // Bottom-right rounded corner
    path.lineTo(
        size.width,
        size.height -
            radius); // Move to the point before the rounded bottom-right corner
    path.arcToPoint(
      Offset(
          size.width - radius, size.height), // Arc to the bottom-right corner
      radius: Radius.circular(radius), // Radius of the rounded corner
      clockwise:
          false, // Draw the arc counterclockwise to create the rounded corner
    );

    // Bottom-left rounded corner
    path.lineTo(radius,
        size.height); // Move to the point before the rounded bottom-left corner
    path.arcToPoint(
      Offset(0, size.height - radius), // Arc to the bottom-left corner
      radius: Radius.circular(radius), // Radius of the rounded corner
      clockwise:
          false, // Draw the arc counterclockwise to create the rounded corner
    );

    // Close the path by connecting back to the top-left corner
    path.close();

    // Draw the path on the canvas using the painter
    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class PaymentCard extends StatelessWidget {
  const PaymentCard({Key? key, required this.card}) : super(key: key);

  final Card card;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 285.w,
          height: 170.h,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Positioned(
          left: 5.w,
          top: 51.h,
          child: SizedBox(
            width: 396.w,
            height: 128.h,
            child: FittedBox(
              child: SvgPicture.asset(
                'assets/images/visa_logo.svg',
              ),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        SizedBox(
          width: 285.w,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 32.13.w,
                    height: 10.38.h,
                    child: FittedBox(
                      child: SvgPicture.asset(
                        'assets/images/visa_logo_small.svg',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                //const VerticalSpacer(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 35.w,
                    height: 26.h,
                    child: FittedBox(
                      child: SvgPicture.asset(
                        'assets/images/visa_card_icon.svg',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const VerticalSpacer(height: 8),
                Text(
                  card.cardNumber,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
                const VerticalSpacer(height: 21),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Cardholder",
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                          ),
                        ),
                        const VerticalSpacer(height: 4),
                        Text(
                          card.cardHolderName,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const HorizontalSpacer(width: 50),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Exp. Date",
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                          ),
                        ),
                        const VerticalSpacer(height: 4),
                        Text(
                          card.expiryDate,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
