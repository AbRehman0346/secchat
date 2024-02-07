import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:secchat/models/chat_slot_model.dart';
import 'package:secchat/xutils/show_add_contact_dialog.dart';
import 'package:secchat/constants/AppConstants.dart';
import 'package:secchat/xutils/route_generator.dart';
import 'package:secchat/xutils/xsnackbar.dart';
import '../models/content_model.dart';
import '../models/user_data_model.dart';
import '../services/firebase_auth_services.dart';
import '../services/firestore_services.dart';
import '../test.dart';
import '../xutils/chat_row.dart';
import '../xutils/showRoundedImage.dart';
import '../xutils/xtextfield.dart';
import '../xutils/xalert_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Drawer Variables.
  TextStyle drawerTextStyle = const TextStyle(fontSize: 20);
  Map<int, String> selection = {}; //Used for Selecting items.
  int selectionCount = 0;

  void _addSelection(int key, String value) {
    setState(() {
      selection.addAll({key: value});
      selectionCount++;
    });
  }

  void _removeSelection(int key) {
    setState(() {
      selection.remove(key);
      selectionCount--;
    });
  }

  void _resetSelection() {
    setState(() {
      selection = {};
      selectionCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    bool isThereSelection = selectionCount > 0;
    return Scaffold(
      endDrawer: isThereSelection
          ? null
          : Drawer(
              child: ListView(
                children: [
                  //Drawer Header contains name, email, and user profile picture.
                  DrawerHeader(
                    child: Column(
                      children: [
                        ShowRoundedImage(
                          radius: 45,
                          imageURL: AppContent.userProfilePicture,
                        ),
                        FutureBuilder(
                          future: FirestoreServices().getUserData(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              UserDataModel model = snapshot.data;
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${model.firstName} ${model.lastName}",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Text(model.email),
                                ],
                              );
                            } else {
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text("Loading",
                                      style: TextStyle(fontSize: 18)),
                                  Text("Loading"),
                                ],
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  //Below Column Contains the List of other options in this Drawer.
                  SizedBox(
                    height: screenHeight / 1.39, //752 / 540 = 1.39
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.add),
                              title: Text(
                                "Add Contact",
                                style: drawerTextStyle,
                              ),
                              onTap: () {
                                //Add Contact Dialog.
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return ShowAddContactDialog(context)
                                          .showAddDialog();
                                    });
                              },
                            ),
                            //Test Tile
                            ListTile(
                              leading: const Icon(Icons.telegram_outlined),
                              title: Text(
                                "Testing Screen",
                                style: drawerTextStyle,
                              ),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return Test();
                                }));
                              },
                            ),
                          ],
                        ),
                        ListTile(
                          focusColor: Colors.blue,
                          leading: const Icon(Icons.logout),
                          title: Text("Logout", style: drawerTextStyle),
                          onTap: () {
                            FirebaseAuthServices().signOut();
                            Navigator.pushAndRemoveUntil(
                                context,
                                RouteGenerator.generateRoute(
                                    const RouteSettings(name: "/login")),
                                (route) => false);
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
      appBar: AppBar(
        title: const Text("Chats"),
        actions: isThereSelection
            ? [
                Center(
                  child: Text(
                    "Selected: $selectionCount",
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    XAlertDialog().showYesNoAlertDialog(
                        context: context,
                        content: "Are you sure! You want to Delete.",
                        onYes: () {
                          for (String email in selection.values) {
                            FirestoreServices().deleteContact(email: email);
                          }
                          _resetSelection();
                          Navigator.pop(context);
                        },
                        onNo: () {
                          Navigator.pop(context);
                        });
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ]
            : null,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(AppContent.collection)
              .where(FieldPath.documentId,
                  isNotEqualTo: AppContent.userProfileDataDoc)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            //I was getting data from snapshot and displaying it on screen
            if (snapshot.hasData && snapshot.data.docs.length > 0) {
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    bool isThisItemSelected = selection[index] != null;
                    DocumentSnapshot doc = snapshot.data.docs[index];
                    ChatSlotModel data = ChatSlotModel.fromJson(doc);
                    return ChatRow(
                      name: "${data.firstName} ${data.lastName}",
                      email: data.email,
                      setSelected: isThisItemSelected,
                      onTap: () {
                        if (selectionCount > 0) {
                          if (isThisItemSelected) {
                            _removeSelection(index);
                          } else {
                            _addSelection(index, data.email);
                          }
                          return;
                        }
                        Navigator.push(
                          context,
                          RouteGenerator.generateRoute(
                            RouteSettings(name: "/chat", arguments: doc),
                          ),
                        );
                      },
                      onLongPress: () {
                        if (isThisItemSelected) {
                          _removeSelection(index);
                        } else {
                          _addSelection(index, data.email);
                        }
                      },
                    );
                  });
            } else {
              return const Center(child: Text("No Data Found"));
            }
          }),
    );
  }
}
