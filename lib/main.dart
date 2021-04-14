import 'package:flutter/material.dart';
//Imports added for firebase functionality
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Sample code from https://github.com/pythonhubpy/YouTube/blob/Firebae-CRUD-Part-1/lib/main.dart#L19
// video https://www.youtube.com/watch?v=SmmCMDSj8ZU&list=PLtr8DfMFkiJu0lr1OKTDaoj44g-GGnFsn&index=10&t=291s

//Create a Firestore Database to store the items in the list

//This function is going to do something, then it will return in the future
Future<void> main() async{
  //Initialize the firebase DB in the main method
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FireStore Demo List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirebaseDemo(),
    );
  }
}

class FirebaseDemo extends StatefulWidget {
  @override
  _FirebaseDemoState createState() => _FirebaseDemoState();
}

class _FirebaseDemoState extends State<FirebaseDemo> {
  final TextEditingController _newItemTextField = TextEditingController();

  //Class level variables
  //List<String> itemList = [];
  //Replace the list of items with a Firebase collection of items
  final CollectionReference itemCollectionDB = FirebaseFirestore.instance.collection('ITEMS');

  //Widget for the name input, was separated from the input item widget
  Widget nameInputWidget(){
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.7,
      child: TextField(
        controller: _newItemTextField,
        style: TextStyle(fontSize: 22, color: Colors.black),
        decoration: InputDecoration(
          hintText: "Name",
          hintStyle: TextStyle(fontSize: 22, color: Colors.black),
        ),
      ),
    );
  }

  //Widget for the add item button, was separated from the input item widget
  Widget addButtonWidget() {
    return SizedBox(
      child: ElevatedButton(
        //Make the button asynchronous so it will wait for the item
          onPressed: () async {
            //setState(() {
            //itemList.add(_newItemTextField.text);
            //_newItemTextField.clear();
            await itemCollectionDB.add({'item_name': _newItemTextField.text}).then((value) => _newItemTextField.clear());
            //});
          },
          child: Text(
            'Add Data',
            style: TextStyle(fontSize: 20),
          )),
    );
  }

  //Create a separate widget function(non-void method)
  //Widget for inputting items on the list, 2 child widgets separated out for better organization
  Widget inputItemWidget(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        nameInputWidget(),
        SizedBox(width: 10,),
        addButtonWidget(),
      ],
    );
  }

  //Widget for the each item tile, was separated from the item list widget
  Widget itemTileWidget(snapshot,position){
    return ListTile(
      leading: Icon(Icons.check_box),
      //Use the snapshot feature to capture the name of the item being added
      title: Text(snapshot.data.docs[position]['item_name']),
      onTap: () {
        setState(() {
          print("You tapped on items $position");
          //itemList.removeAt(position);
          //Remove items from the firebase db in the tap method of the item list tile
          String itemId = snapshot.data.docs[position].id;
          itemCollectionDB.doc(itemId).delete();
        });
      },
    );
  }

  //Create a separate list widget function
  //One child widget separated for better organization
  Widget itemListWidget(){
    return Expanded(
    //Use the stream builder around the list builder in order to read data from firestore
        child:
        StreamBuilder(stream: itemCollectionDB.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return ListView.builder(
    //Takes a snapshot of the current data in the db to get the number of items
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int position) {
                  return Card(
                    child: itemTileWidget(snapshot, position),
                  );
                }
              );
        })
    );
  }

  //Original widget scaffold, has been separated in multiple, separate widget classes for better organization
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              inputItemWidget(),
              SizedBox(height: 40,),
              itemListWidget(),
            ],
          ),
        ),
      );
  }
}

