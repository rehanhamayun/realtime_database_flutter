import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class ReadData extends StatefulWidget {
  const ReadData({Key? key}) : super(key: key);

  @override
  State<ReadData> createState() => _ReadDataState();
}

class _ReadDataState extends State<ReadData> {
  @override
  final readDatabase = FirebaseDatabase.instance.ref('Post');
  final searchFilter = TextEditingController();
  final editController = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Filter"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextFormField(
              controller: searchFilter,
              decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                hintStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(
                      0.4,
                    )),
                hintText: "Search",
              ),
              //TEXT FORM FIELD ON CHANGED
              onChanged: (String value) {
                setState(() {});
              },
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          Expanded(
            child: FirebaseAnimatedList(
              query: readDatabase,
              itemBuilder: (context, snapshot, animation, index) {
                final title = snapshot.child('title').value.toString();
                //final id = snapshot.child("id").value.toString();

                if (searchFilter.text.isEmpty) {
                  return ListTile(
                    title: Text(title),
                    subtitle: Text(snapshot.child("id").value.toString()),
                    trailing: PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            leading: const Icon(Icons.edit),
                            title: const Text("Edit"),
                            onTap: () {
                              Navigator.pop(context);
                              showMyDialog(
                                  title, snapshot.child("id").value.toString());
                            },
                          ),
                        ),
                        // 2
                        PopupMenuItem(
                          value: 2,
                          child: ListTile(
                            leading: Icon(Icons.delete),
                            title: Text("Delete"),
                          ),
                          onTap: () {
                            readDatabase
                                .child(snapshot.child('id').value.toString())
                                .remove();
                          },
                        ),
                      ],
                    ),
                  );
                } else if (title
                    .toLowerCase()
                    .contains(searchFilter.text.toLowerCase())) {
                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Update"),
            content: Container(
              child: TextField(
                controller: editController,
                decoration: const InputDecoration(
                  hintText: "Edit",
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      readDatabase
                          .child(id)
                          .update({'title': editController.text.toLowerCase()});
                    },
                    child: const Text(
                      "Update",
                      style: TextStyle(
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                  ),
                  //
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }
}
