import 'dart:convert';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wall_et_ui/base_url.dart';
import 'package:wall_et_ui/widgets/horizontal_spacer.dart';
import 'package:wall_et_ui/widgets/primary_button.dart';
import 'package:wall_et_ui/widgets/vertical_spacer.dart';
import 'package:http/http.dart' as http;

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({Key? key}) : super(key: key);

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  String? _receivedMessage;
  String? receiverPublicKey;
  String? privateKey;
  String? standardGasPrice;

  final TextEditingController _amtController = TextEditingController();

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter Valid Amount.';
    }
    return null;
  }

  // void _startNFCReading() async {
  //   try {
  //     bool isAvailable = await NfcManager.instance.isAvailable();

  //     if (isAvailable) {
  //       NfcManager.instance.startSession(
  //         onDiscovered: (NfcTag tag) async {
  //           setState(() {
  //             _receivedMessage = 'NFC Tag Detected: ${tag.data}';
  //           });
  //           //NdefMessage? message = await ndef.read();
  //           //_showSuccessDialog();
  //           _createTransaction();
  //           NfcManager.instance.stopSession();
  //         },
  //       );
  //     } else {
  //       debugPrint('NFC not available.');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('NFC not available')),
  //       );
  //     }
  //   } catch (e) {
  //     debugPrint('Error reading NFC: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error reading NFC: $e')),
  //     );
  //   }
  // }

  void _startNFCReading() async {
    try {
      bool isAvailable = await NfcManager.instance.isAvailable();

      if (isAvailable) {
        NfcManager.instance.startSession(
          onDiscovered: (NfcTag tag) async {
            // Extract the identifier from the tag data
            var identifier = tag.data['nfca']?['identifier'];

            if (identifier != null && identifier.toString() == '[1, 2, 3, 4]') {
              // If the identifier matches the expected value AMOGHA
              setState(() {
                receiverPublicKey =
                    "0x9dca3dc16185e0c5ab93437a095d3be0ab867bcf";
              });
            } else {
              // If the identifier does not match default AMOGHA
              setState(() {
                receiverPublicKey =
                    "0x9dca3dc16185e0c5ab93437a095d3be0ab867bcf";
              });
            }
            debugPrint('*****Receiver Key Set*****');
            debugPrint('Receiver Public Key: $receiverPublicKey');

            //_createTransaction();
            _createBcTransaction();
            NfcManager.instance.stopSession();
          },
        );
      } else {
        debugPrint('NFC not available.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('NFC not available')),
        );
      }
    } catch (e) {
      debugPrint('Error reading NFC: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error reading NFC: $e')),
      );
    }
  }
  Future<void> getGasPrice() async {
    try {
      // Define the API URL
      final url = 'http://192.168.36.199:3000/ethereum/getGasPrice';

      // Make the GET request
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Parse the JSON response
        final data = json.decode(response.body);

        // Extract the 'standard' gas price
        standardGasPrice = data['data']['standard'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('standardGasPrice', standardGasPrice!);
        print('Standard Gas Price: $standardGasPrice');
        // Use the gas price as needed in your application
      } else {
        throw Exception('Failed to fetch gas price. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _createBcTransaction() async {
    //for testing
    //rookie to panda

    SharedPreferences prefs = await SharedPreferences.getInstance();
    privateKey = prefs.getString('privateKey');
    // SharedPreferences prefss = await SharedPreferences.getInstance();
    // standardGasPrice  = prefss.getString('standardGasPrice');
    print('***PKEY***GAS');
    print(privateKey);
    //print(standardGasPrice);
    Map<String, dynamic> createTransaction = {
      "from": "0xC4B6eeF041db4F5864f06D536569aa6BB3D4ed05",
      "to": receiverPublicKey,
      //"to": "0xe811da588e42ee6e1faaccfb03dc113500890d32 //bhat",
      "amount": double.parse(_amtController.text),
      "gasPrice": standardGasPrice, //integrate the api for gas
    };
    print('*******NEW URL/ID ********');
    print(createTransaction);

    try {
      final response = await http.post(
        Uri.parse('http://192.168.36.199:3000/ethereum/send-transaction'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(createTransaction),
      );

      if (response.statusCode == 201) {
        // Wait for a short duration to ensure the server processes the request
        await Future.delayed(Duration(seconds: 1));
        _showSuccessDialog();
      } else {
        _showFailedDialog();
        throw Exception('Failed to pay!');
      }
    } catch (error) {
      print('Error: $error');
    }
    // Map<String, dynamic> updateBal = {
    //   "balanceAmount": double.parse(_amtController.text),
    // };
    // print(updateBal);
    // try {
    //   final response = await http.post(
    //     Uri.parse(putBalance2Url),
    //     headers: <String, String>{
    //       'Content-Type': 'application/json; charset=UTF-8',
    //     },
    //     body: jsonEncode(updateBal),
    //   );
    // } catch (error) {
    //   print('Error: $error');
    // }
  }

  Future<void> _createTransaction() async {
    //for testing
    //rookie to panda
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int retriveddUserId = prefs.getInt('loggedUserID') ?? 7;
    print('******************NEW URL/ID *******************');
    print(retriveddUserId);
    //print(postTransactionUrl+'/'+retriveddUserId.toString());

    Map<String, dynamic> createTransaction = {
      "senderId": retriveddUserId,
      "receiverId": 7,
      "senderNfcId": retriveddUserId,
      "receiverNfcId": 7,
      "amount": double.parse(_amtController.text),
      "currency": "inr",
      "transactionDate": formattedDate,
      "status": "done"
    };
    print('******************NEW URL/ID *******************');
    print(createTransaction);

    try {
      final response = await http.post(
        Uri.parse(postTransactionUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(createTransaction),
      );

      if (response.statusCode == 201) {
        // Wait for a short duration to ensure the server processes the request
        await Future.delayed(Duration(seconds: 1));
        _showSuccessDialog();
      } else {
        _showFailedDialog();
        throw Exception('Failed to pay!');
      }
    } catch (error) {
      print('Error: $error');
    }
    // Map<String, dynamic> updateBal = {
    //   "balanceAmount": double.parse(_amtController.text),
    // };
    // print(updateBal);
    // try {
    //   final response = await http.post(
    //     Uri.parse(putBalance2Url),
    //     headers: <String, String>{
    //       'Content-Type': 'application/json; charset=UTF-8',
    //     },
    //     body: jsonEncode(updateBal),
    //   );
    // } catch (error) {
    //   print('Error: $error');
    // }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.w),
        ),
        child: Container(
          height: 300.h,
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100.w,
                height: 100.h,
                child: FlareActor(
                  "assets/animations/Success Check.flr",
                  animation: "animate",
                ),
              ),
              const VerticalSpacer(height: 20),
              Text(
                "Payment Successful",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFailedDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.w),
        ),
        child: Container(
          height: 250.h,
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100.w,
                height: 100.h,
                child: FlareActor(
                  "assets/animations/failed.flr",
                  animation: "failed",
                ),
              ),
              Text(
                "Payment Failed",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                    color: Colors.red[400]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Keep the background transparent
        title: Text(
          'Send Money',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Makes the text bold
            fontSize: 24, // Optional: Adjust the font size if needed
            color: Colors.black,
          ),
        ),
        centerTitle: true, // Centers the title text
        automaticallyImplyLeading:
            true, // Disables the leading back button (optional)
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(
                15.w,
              ),
              height: 102.h,
              width: 375.w,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black.withOpacity(0.1),
                    width: 1.h,
                  ),
                ),
              ),
              /* child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  
                  Text(
                    "Send Money",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: 24.w,
                    height: 24.h,
                  ),
                ],
              ), */
            ),
            const VerticalSpacer(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const VerticalSpacer(height: 32),
                  Text(
                    "Payment Amount",
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  const VerticalSpacer(height: 8),
                  TextFormField(
                    validator: _validateField,
                    controller: _amtController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    cursorColor: Theme.of(context).colorScheme.secondary,
                    decoration: InputDecoration(
                      hintText: "Enter amount",
                      hintStyle: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xFF1A1A1A).withOpacity(0.2494),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.w),
                        borderSide: BorderSide(
                          color: const Color(0xFF1A1A1A).withOpacity(0.1),
                          width: 1.sp,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.w),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 1.sp,
                        ),
                      ),
                    ),
                  ),
                  const VerticalSpacer(height: 32),
                  Text(
                    "Payment Note",
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  const VerticalSpacer(height: 8),
                  TextField(
                    //keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 16.sp,
                    ),
                    minLines: 8,
                    maxLines: 8,
                    cursorColor: Theme.of(context).colorScheme.secondary,
                    decoration: InputDecoration(
                      hintText: "Add payment note",
                      hintStyle: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xFF1A1A1A).withOpacity(0.2494),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.w),
                        borderSide: BorderSide(
                          color: const Color(0xFF1A1A1A).withOpacity(0.1),
                          width: 1.sp,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.w),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 1.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 81.h,
        width: 375.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.w),
            topRight: Radius.circular(20.w),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              offset: const Offset(0, -10),
              blurRadius: 10,
            ),
          ],
        ),
        child: Center(
          child: InkWell(
            onTap: () => _showConfimrationDialog(context),
            child: Container(
              height: 49.h,
              width: 345.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.w),
                color: Theme.of(context).colorScheme.secondary,
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
                    "Send Payment",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
                const VerticalSpacer(height: 15),
                Text(
                  "Place the device near the NFC.",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                const VerticalSpacer(height: 20),
                InkWell(
                  onTap: _startNFCReading,
                  child: Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(10.w),
                    ),
                    child: Center(
                      child: Text(
                        "Initiate NFC!",
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
}
