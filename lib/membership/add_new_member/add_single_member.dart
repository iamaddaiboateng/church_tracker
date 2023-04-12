import 'package:church_ticker/core/costum_text_field.dart';
import 'package:church_ticker/core/costum_text_form_field.dart';
import 'package:church_ticker/membership/all_members/controller/all_members_controller.dart';
import 'package:church_ticker/membership/model/members_model.dart';
import 'package:church_ticker/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

TextEditingController nameController = TextEditingController();
TextEditingController contactController = TextEditingController();
TextEditingController locationController = TextEditingController();

class AddSingleUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey();

    return Consumer<AllMemberController>(
      builder: (_, service, __) {
        return ModalProgressHUD(
          inAsyncCall: service.inProgress,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Add Single Member'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () {
                    MemberModel model = MemberModel(
                        name: nameController.text,
                        contact: contactController.text,
                        location: locationController.text);
                    if (formKey.currentState.validate())
                      service.addSingleMembers(model, context, nameController,
                          contactController, locationController);
                  },
                )
              ],
            ),
            body: Form(
              key: formKey,
              child: ListView(
                children: <Widget>[
                  CustomTextFormField(
                    textCapitalization: TextCapitalization.words,
                    color: Colors.teal,
                    hintTitle: kName,
                    labelTitle: kName,
                    controller: nameController,
                  ),
                  CustomTextField(
                    textInputType: TextInputType.phone,
                    color: Colors.teal,
                    hintTitle: kContact,
                    labelTitle: kContact,
                    controller: contactController,
                  ),
                  CustomTextField(
                    color: Colors.teal,
                    hintTitle: kLocation,
                    labelTitle: kLocation,
                    controller: locationController,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
