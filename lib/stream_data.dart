import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class StreamData extends StatefulWidget {
  const StreamData({Key? key}) : super(key: key);

  @override
  State<StreamData> createState() => _StreamDataState();
}

class _StreamDataState extends State<StreamData> {
  final refDatabase = FirebaseDatabase.instance.ref('Post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stream Fetch"),
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
                  stream: refDatabase.onValue,
                  builder: (BuildContext context,
                      AsyncSnapshot<DatabaseEvent> snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    } else {
                      Map<dynamic, dynamic> map =
                          snapshot.data!.snapshot.value as dynamic;
                      List<dynamic> list = [];
                      list.clear();
                      list = map.values.toList();
                      return ListView.builder(
                          itemCount: snapshot.data?.snapshot.children.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(list[index].toString()),
                            );
                          });
                    }
                  })),
        ],
      ),
    );
  }
}
