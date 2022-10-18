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
                focusedBorder: OutlineInputBorder(
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
                final title = snapshot.child('1').value.toString();

                if (searchFilter.text.isEmpty) {
                  return ListTile(
                    title: Text(snapshot.child('1').value.toString()),
                  );
                } else if (title
                    .toLowerCase()
                    .contains(searchFilter.text.toLowerCase())) {
                  return ListTile(
                    title: Text(snapshot.child('1').value.toString()),
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
}
