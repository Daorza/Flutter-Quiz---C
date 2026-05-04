import 'package:flutter/material.dart';
import 'package:firebase/ui/entryform.dart';
import 'package:firebase/models/contact.dart';
import 'package:firebase/helpers/dbhelper.dart';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<Contact> contactList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Demo Database'),),
      body: createListView(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Tambah Data',
        onPressed: () async {
          var contact = await navigateToEntryForm(context, Contact('', ''));
          if (contact != null && contact.name != '' && contact.phone != '') {
            addContact(contact);
          }
        },
      ),
    );
  }

  Future<Contact> navigateToEntryForm(BuildContext context, Contact contact) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
          return EntryForm(contact);
        }));
    return result;
  }

  ListView createListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.people),
            ),
            title: Text(contactList[index].name),
            subtitle: Text(contactList[index].phone),

            // DELETE
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () {
                deleteContact(contactList[index]);
              },
            ),

            // EDIT
            onTap: () async {
              var contact = await navigateToEntryForm(
                context,
                this.contactList[index],
              );

              if (contact.name != '' && contact.phone != '')
                editContact(contact);
            },
          ),
        );
      },
    );
  }

  void addContact(Contact object) async {
    await dbHelper.insert(object);
    updateListView();
  }

  void editContact(Contact object) async {
    await dbHelper.insert(object);
    updateListView();
  }

  void deleteContact(Contact object) async {
    await dbHelper.delete(object.id!);
    updateListView();
  }

  void updateListView() async {
    List<Contact> list = await dbHelper.getContactList();

    setState(() {
      contactList = list;
      count = list.length;
    });
  }

  @override
  void initState() {
    super.initState();
    updateListView();
  }
}