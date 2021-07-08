# flutter_firebase_list

List of items stored in FireStore

Objective: 
Gain experience with the FireStore database cloud storage in a Flutter app.

Details:
Download the Unit 12 Item List flutter template from GitHub into Android Studio.

You can ignore the ask to download plugins
You should run "pub get" when asked
Be patient and all the errors should be cleaned up automatically
This activity is based on the Add and Retrieve Data from Firebase Firestore video with some changes. 

Step 0: Break the code up using Widget Functions
https://www.youtube.com/watch?v=MecaTYVenwo
Define some method or functions which return a Widget.  Use these to break the code up into parts.  A good division is

itemInputWidget()
nameTextFieldWidget()
addButtonWidget()
itemListWidget
itemTileWidget(snapshot, position)

Step 1: Add Firebase to your Flutter app

https://www.youtube.com/watch?v=uqOSFSvZME8

Follow the instructions in Google's Add Firebase to your Flutter app. Make sure you have Android selected instead of iOS. We will not need Google Analytics or a signing certificate SHA-1.
Create a Firestore database: Open your project in Firebase Console, click on the Firestore Database on the left side menu, click the Create Database button.  You must switch the authentication to Test mode and then save the new database.
Change the versions of firebase in the pubspec.yaml file
firebase_core: "^1.0.3"
cloud_firestore: "^1.0.4"

Step 2: Add Firestore code


https://www.youtube.com/watch?v=uhhGGFaWzcs

Make the following changes to the app:

In the main() method initialize Firebase:
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
 Replace the list called itemList with a Firestore collection titled ITEMS:
final CollectionReference itemCollectionDB = FirebaseFirestore.instance.collection('ITEMS');
In the OnPressed method of the ElevatedButton, add the item to Firebase instead of the itemList
itemCollectionDB.add({'item_name': _newItemTextField.text})
_newItemTextField.clear()
Make the above code async using the asynch and await code:
await itemCollectionDB.add({'item_name': _newItemTextField.text});
Surround the ListBuilder with a StreamBuilder to read the data from Firestore
StreamBuilder(stream: itemCollectionDB.snapshots(),
  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
In the ListView widget, use the snapshot to get the number of items:
itemCount: snapshot.data.docs.length
In the ListTile, use the snapshot to get the item name
title: Text(snapshot.data.docs[position]['item_name'])
Delete the item from Firebase in the OnTap method of the ListTile
String itemId = snapshot.data.docs[position].id;
itemCollectionDB.doc(itemId).delete();
Final Version
Here is the final version of main.dart.

Bonus Challenge:
Switch the delete action to a Long Press or, for a bigger challenge, change the delete action to a swipe using the Dismissible widget.
Submit:
Commit and push the project up to GitHub. Turn in the URL of the project on GitHub.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
