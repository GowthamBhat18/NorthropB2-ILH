class Document {
  int? id;
  String? type;
  String? path;
  String? uploadedAt;
  String? title;
  User? user;

  Document({this.id, this.type, this.path, this.uploadedAt, this.user});

  Document.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    path = json['path'];
    uploadedAt = json['uploadedAt'];
    title = json['title'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['type'] = type;
    data['path'] = path;
    data['uploadedAt'] = uploadedAt;
    data['title'] = title;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? password;
  UserType? userType;

  User({this.id, this.name, this.email, this.password, this.userType});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    userType =
        json['userType'] != null ? UserType.fromJson(json['userType']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    if (userType != null) {
      data['userType'] = userType!.toJson();
    }
    return data;
  }
}

class UserType {
  int? id;
  String? code;
  String? type;
  String? description;

  UserType({this.id, this.code, this.type, this.description});

  UserType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    type = json['type'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['code'] = code;
    data['type'] = type;
    data['description'] = description;
    return data;
  }
}

class Ticket {
  final int id;
  final User user;
  final String eventName;
  final DateTime eventDate;
  final String ticketInfo;
  final DateTime purchaseDate;
  final DateTime validFrom;
  final DateTime validTo;
  final String status;

  Ticket({
    required this.id,
    required this.user,
    required this.eventName,
    required this.eventDate,
    required this.ticketInfo,
    required this.purchaseDate,
    required this.validFrom,
    required this.validTo,
    required this.status, 
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      user: User.fromJson(json['user']),
      eventName: json['eventName'],
      eventDate: DateTime.parse(json['eventDate']),
      ticketInfo: json['ticketInfo'],
      purchaseDate: DateTime.parse(json['purchaseDate']),
      validFrom: DateTime.parse(json['validFrom']),
      validTo: DateTime.parse(json['validTo']),
      status: json['status'],
    );
  }
}
