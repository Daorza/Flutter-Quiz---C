class Contact {
  String? id;
  String name;
  String phone;

  Contact(this.name, this.phone, {this.id});

  factory Contact.fromMap(Map<String, dynamic> map, String documentId) {
    return Contact(
      map['name'],
      map['phone'],
      id: documentId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone' : phone,
    };
  }
}