import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:secchat/services/firestore_services.dart';
import 'package:secchat/constants/AppConstants.dart';
import 'package:secchat/xutils/msg_slot.dart';
import 'package:secchat/xutils/showRoundedImage.dart';
import 'package:secchat/xutils/xtextfield.dart';
import '../constants/msg_constants.dart';
import '../models/chat_slot_model.dart';
import '../models/msg_model.dart';
import '../models/variable_class_model/msg_status.dart';
import '../xutils/xalert_dialog.dart';

class ChatScreen extends StatefulWidget {
  final DocumentSnapshot doc;
  const ChatScreen({Key? key, required this.doc}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool doScroll = true;
  bool isMsgReceived = false;
  final ScrollController _scrollController = ScrollController();
  Map<int, String> selection = {};
  int selectionCount = 0;
  TextEditingController msgController = TextEditingController();

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
    // double screenHeight = MediaQuery.of(context).size.height; //752.0
    double screenWidth = MediaQuery.of(context).size.width; //360.0
    ChatSlotModel info = ChatSlotModel.fromJson(widget.doc);
    String userFormattedEmail = AppContent.formatEmail(info.email);
    bool isSelectionOn = selectionCount > 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: isSelectionOn
            ? null
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //Below Container is for Profile Picture
                  ShowRoundedImage(
                    radius: screenWidth / 18, //18 -> 360/20=18
                    imageURL:
                        "${AppContent.firebaseProfileImageFolderName}$userFormattedEmail",
                  ),

                  //Below Container is for showing name and email address
                  Container(
                    width: 230,
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${info.firstName} ${info.lastName}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          info.email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  )
                ],
              ),
        actions: isSelectionOn
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
                          for (String docId in selection.values) {
                            FirestoreServices()
                                .deleteMsg(email: info.email, docId: docId);
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(AppContent.collection)
                    .doc(userFormattedEmail)
                    .collection(MsgVariables.msgsCollectionName)
                    .orderBy("interval")
                    .snapshots(),
                builder: (builder, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (doScroll) {
                    doScroll = false;
                    _scrollToBottom();
                  }
                  return Column(
                    children: List.generate(snapshot.data.docs.length, (index) {
                      bool isThisItemSelected = selection[index] != null;
                      MsgModel msg =
                          MsgModel.fromDocument(snapshot.data.docs[index]);

                      bool isReceived =
                          msg.status == MsgStatus.sent ? false : true;
                      return InkWell(
                        onTap: () {
                          if (isSelectionOn) {
                            if (isThisItemSelected) {
                              _removeSelection(index);
                            } else {
                              _addSelection(index, msg.docId);
                            }
                          }
                        },
                        onLongPress: () {
                          if (isThisItemSelected) {
                            _removeSelection(index);
                          } else {
                            _addSelection(index, msg.docId);
                          }
                        },
                        child: MsgSlot(
                          content: msg.content,
                          makeRight: isReceived,
                          makeHighLighted: isThisItemSelected,
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ),
          //Bottom Section Where we write MSG and send it.
          Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            child: Row(
              children: [
                SizedBox(
                  width: screenWidth / 1.24,
                  child: XTextField(
                    controller: msgController,
                    hint: "Type Your Message",
                    borderRadius: 50,
                    maxLines: 10,
                    prefixIcon: const Icon(
                      Icons.messenger_outlined,
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    String msg = msgController.text.trim();
                    msgController.text = "";
                    await FirestoreServices().sendMsg(info.email, msg);
                    doScroll = true;
                  },
                  icon: const Icon(
                    Icons.send_sharp,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _scrollToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }
}
