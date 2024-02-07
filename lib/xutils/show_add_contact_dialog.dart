import 'package:flutter/material.dart';
import 'package:secchat/xutils/xsnackbar.dart';
import 'package:secchat/xutils/xtextfield.dart';

import '../services/firestore_services.dart';

class ShowAddContactDialog {
  final BuildContext _context;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  ShowAddContactDialog(this._context);

  AlertDialog showAddDialog() {
    return AlertDialog(
      title: const Text("Add Contact"),
      content: Container(
        height: 200,
        child: Column(
          children: [
            XTextField(
              controller: firstNameController,
              hint: "First Name",
            ),
            const SizedBox(height: 10),
            XTextField(
              controller: lastNameController,
              hint: "Last Name",
            ),
            const SizedBox(height: 10),
            XTextField(
              controller: emailController,
              hint: "Enter Email",
            ),
          ],
        ),
      ),
      actions: [
        //Cancel Button
        ElevatedButton(
            onPressed: () => Navigator.pop(_context),
            child: const Text("Cancel")),

        //Add Contact Button.
        ElevatedButton(
          onPressed: () {
            try {
              //Creating local variables
              String? firstName = firstNameController.text != ""
                  ? firstNameController.text.trim()
                  : null;
              String? lastName = lastNameController.text != ""
                  ? lastNameController.text.trim()
                  : null;
              String email = emailController.text.trim();

              //Check If Email is empty.
              if (email == "") {
                throw Exception("Enter email, It's Mandatory");
              }

              //Adding data to the Firebase
              Future msg = FirestoreServices()
                  .addContact(email, firstName: firstName, lastName: lastName);
              msg.then((value) => value != true ? Exception(value) : null);

              //Showing Success Msg.
              XSnackBar(_context, "Contact Added Successfully");
            } catch (e) {
              XSnackBar(_context, e.toString(), color: Colors.red);
            }
            Navigator.pop(_context);
          },
          child: const Text("ADD"),
        ),
      ],
    );
  }
}
