class Mahasiswa {
  String? id;
  String nama;
  String nim;
  String tanggalLahir;
  String hobi;
  String noHp;
  String alamat;
  String foto;

  Mahasiswa({
    this.id,
    required this.nama,
    required this.nim,
    required this.tanggalLahir,
    required this.hobi,
    required this.noHp,
    required this.alamat,
    required this.foto,
  });

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'nim': nim,
      'tanggal_lahir': tanggalLahir,
      'hobi': hobi,
      'no_hp': noHp,
      'alamat': alamat,
      'foto': foto,
    };
  }
}



// ########################################################################
// class Contact {
//   String? id;
//   String name;
//   String phone;
//
//   Contact(this.name, this.phone, {this.id});
//
//   factory Contact.fromMap(Map<String, dynamic> map, String documentId) {
//     return Contact(
//       map['name'],
//       map['phone'],
//       id: documentId,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'phone' : phone,
//     };
//   }
// }