import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wall_et_ui/common/common.model.dart';
import 'package:wall_et_ui/common/http.service.dart';
import 'package:wall_et_ui/common/models.dart';
import 'package:wall_et_ui/common/utility.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DocumentScreen extends StatefulWidget {
  @override
  _DocumentScreenState createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  Future<List<Document>?> getDocuments() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int _retrivedUserId = prefs.getInt('loggedUserID') ?? 1;
    print('******************NEW URL *******************');
    print(_retrivedUserId);
    final httpService = HttpService(baseUrl: Utility.baseUrl);
    HttpRequest request = Utility.urlParams["getDocuments"]!;
    request.body = {"userId": _retrivedUserId};

    try {
      final response = await httpService.request(request);
      if (response != null && response is List<dynamic>) {
        List<Document> documents =
            response.map((doc) => Document.fromJson(doc)).toList();
        return documents;
      } else {
        throw Exception('Failed to load documents');
      }
    } catch (error) {
      print('Error: $error');
      return null;
    }
  }

  Future<void> downloadDocument(String path) async {
    try {
      var dir = await getExternalStorageDirectory();
      var filePath = '${dir?.path}/${basename(path)}';
      var url = '${Utility.baseUrl}$path';
      print('Downloading document from: $url');
      print('Saving to: $filePath');

      var response = await Dio().head(url);
      if (response.statusCode == 200) {
        await Dio().download(url, filePath);
        OpenFile.open(filePath);
      } else {
        print('File not found at URL: $url');
      }
    } catch (e) {
      print('Download failed: $e');
    }
  }

  Future<void> deleteDocument(int documentId) async {
    var uri = Uri.parse('${Utility.baseUrl}document/delete/$documentId');
    var response = await http.delete(uri);
    if (response.statusCode == 200) {
      print('Document Deleted Successfully');
      setState(() {});
    } else {
      print('Failed to delete document');
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> addDocument() async {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      int _retrivedUserIdd = prefs.getInt('loggedUserID') ?? 1;
      print('******************NEW URL *******************');
      print(_retrivedUserIdd);
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.isNotEmpty) {
        File file = File(result.files.single.path!);
        print("File has been picked");

        var uri = Uri.parse('${Utility.baseUrl}document/upload');
        var request = http.MultipartRequest('POST', uri);

        DateTime now = DateTime.now();
        String year = now.year.toString();
        String month = now.month.toString().padLeft(2, '0');
        String day = now.day.toString().padLeft(2, '0');

        try {
          Map<String, dynamic> requestData = {
            "uploadedAt": "$year-$month-$day",
            "userId": _retrivedUserIdd,
          };
          request.fields["data"] = jsonEncode(requestData);
          if (file.path.isNotEmpty) {
            request.files.add(http.MultipartFile(
              'file',
              file.readAsBytes().asStream(),
              file.lengthSync(),
              filename: basename(file.path),
            ));
          }
          var response = await request.send();
          if (response.statusCode == 200) {
            print('Document Uploaded Successfully');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('File Uploaded Successfully')),
            );
          } else {
            print('Failed code is  ${response.statusCode}.');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('No File Selected')),
            );
          }
          print(requestData);
        } catch (err) {
          print(err);
        }
      } else {
        print("No File Selected");
      }
      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Documents'),
        centerTitle: true,
      ),
      body: Container(
        child: FutureBuilder<List<Document>?>(
          future: getDocuments(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No documents found'));
            } else {
              List<Document>? documents = snapshot.data!;
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    key: ValueKey(documents[index].id),
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) =>
                              deleteDocument(documents[index].id as int),
                          // onPressed: (context) {},
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) =>
                              downloadDocument(documents[index].path as String),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          icon: Icons.download,
                          label: 'Download',
                        ),
                      ],
                    ),
                    child: Card(
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        title: Text(
                          '${documents[index].title}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text('File type: ${documents[index].type}'),
                        leading: Icon(Icons.description),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addDocument();
        },
        backgroundColor: Colors.blueGrey,
        child: Icon(Icons.add),
      ),
    );
  }
}
