import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:wall_et_ui/common/models.dart';
import 'package:wall_et_ui/common/utility.dart';
import 'package:wall_et_ui/screens/tickets/ticket_details.dart';

class TicketScreen extends StatefulWidget {
  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  final List<Ticket> tickets = [];
  File? _selectedImage;

  Future<List<Ticket>> fetchTickets() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int retrivedUserId = prefs.getInt('loggedUserID') ?? 1;
    print('******************NEW URL *******************');
    print(retrivedUserId);

    final response = await http.post(
      Uri.parse('${Utility.baseUrl}ticket/readById'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"userId": retrivedUserId}),
    );

    if (response.statusCode == 200) {
      List<dynamic> ticketJson = jsonDecode(response.body);
      return ticketJson.map((json) => Ticket.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tickets');
    }
  }

  @override
  Widget build(BuildContext context) {
    void addTicket() {
      showDialog(
        context: context,
        builder: (context) {
          final eventNameController = TextEditingController();
          final eventDateController = TextEditingController();
          final purchaseDateController = TextEditingController();
          final validFromController = TextEditingController();
          final validToController = TextEditingController();

          return AlertDialog(
            title: const Text('Add New Ticket'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: eventNameController,
                    decoration: const InputDecoration(labelText: 'Event Name'),
                  ),
                  TextField(
                    controller: eventDateController,
                    decoration: const InputDecoration(labelText: 'Event Date'),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        eventDateController.text = picked.toIso8601String();
                      }
                    },
                  ),
                  TextField(
                    controller: purchaseDateController,
                    decoration: const InputDecoration(labelText: 'Purchase Date'),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        purchaseDateController.text = picked.toIso8601String();
                      }
                    },
                  ),
                  TextField(
                    controller: validFromController,
                    decoration: const InputDecoration(labelText: 'Valid From'),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        validFromController.text = picked.toIso8601String();
                      }
                    },
                  ),
                  TextField(
                    controller: validToController,
                    decoration: const InputDecoration(labelText: 'Valid To'),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        validToController.text = picked.toIso8601String();
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      var pickedFile =
                          await picker.pickImage(source: ImageSource.gallery);
                      setState(() {
                        if (pickedFile != null) {
                          _selectedImage = File(pickedFile.path);
                        }
                      });
                    },
                    child: const Text('Pick Image'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                 int retrivedUserIdd = prefs.getInt('loggedUserID') ?? 1;
                  print('******************NEW URL *******************');
                  print(retrivedUserIdd);

                  if (_selectedImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No File Selected')),
                    );
                    return;
                  }

                  var uri =
                      Uri.parse('${Utility.baseUrl}ticket/upload');
                  print(uri);
                  var request = http.MultipartRequest('POST', uri);

                  try {
                    Map<String, dynamic> requestData = {
                      "userId": retrivedUserIdd,
                      "eventName": eventNameController.text,
                      "eventDate": eventDateController.text,
                      "purchaseDate": purchaseDateController.text,
                      "validFrom": validFromController.text,
                      "validTo": validToController.text,
                      "status": "valid"
                    };

                    request.fields["data"] = jsonEncode(requestData);
                    if (_selectedImage!.path.isNotEmpty) {
                      request.files.add(http.MultipartFile(
                        'file',
                        _selectedImage!.readAsBytes().asStream(),
                        _selectedImage!.lengthSync(),
                        filename: basename(_selectedImage!.path),
                      ));
                    }

                    var response = await request.send();

                    if (response.statusCode == 200) {
                      print('Ticket Uploaded Successfully');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ticket Uploaded Successfully')),
                      );
                    } else {
                      print('Failed code is  ${response.statusCode}.');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to Upload Ticket')),
                      );
                    }
                  } catch (err) {
                    print(err);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $err')),
                    );
                  }
                  setState(() {});
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tickets'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Ticket>>(
        future: fetchTickets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('No tickets found!')); //'Error: ${snapshot.error}'
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tickets found'));
          } else {
            final tickets = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TicketDetails(ticket: ticket),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Image.network(
                            "${Utility.baseUrl}${ticket.ticketInfo}",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            ticket.eventName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTicket,
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add),
      ),
    );
  }
}
