import 'package:flutter/material.dart';
import 'package:firebase/models/contact.dart';

class EntryForm extends StatefulWidget {
  final Contact? contact;

  const EntryForm(this.contact, {super.key});

  @override
  EntryFormState createState() => EntryFormState();
}

class EntryFormState extends State<EntryForm> {
  Contact? contact;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    contact = widget.contact;

// isi form jika mode edit
    if (contact != null) {
      nameController.text = contact!.name;
      phoneController.text = contact!.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contact == null ? 'Tambah Data' : 'Ubah Data'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
// INPUT NAMA
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                controller: nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),

// INPUT PHONE
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Nomor HP',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),

// BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: <Widget>[
// SIMPAN
                  Expanded(
                    child: ElevatedButton(
                      child: const Text('Simpan', textScaleFactor: 1.2),
                      onPressed: () {
                        if (nameController.text.isNotEmpty &&
                            phoneController.text.isNotEmpty) {

                          if (contact == null) {
// tambah data
                            contact = Contact(
                              nameController.text,
                              phoneController.text,
                            );
                          } else {
// update data
                            contact!.name = nameController.text;
                            contact!.phone = phoneController.text;
                          }

                          Navigator.pop(context, contact);
                        }
                      },
                    ),
                  ),

                  const SizedBox(width: 10),

// BATAL
                  Expanded(
                    child: ElevatedButton(
                      child: const Text('Batal', textScaleFactor: 1.2),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
