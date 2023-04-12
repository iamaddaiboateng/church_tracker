import 'package:church_ticker/data/members_dao.dart';
import 'package:church_ticker/membership/all_members/controller/all_members_controller.dart';
import 'package:church_ticker/services/all_services/controller/all_services_controller.dart';
import 'package:church_ticker/services/all_services/view/all_services_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'membership/model/members_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AllServiceController>(
          create: (context) => AllServiceController(),
        ),
        ChangeNotifierProvider<AllMemberController>(
          create: (context) => AllMemberController(),
        )
      ],
      child: GetMaterialApp(
        title: 'Church Ticker',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.deepOrange,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AllServicesPage(),
      ),
    );
  }
}

class ChurchTicker extends StatefulWidget {
  @override
  _ChurchTickerState createState() => _ChurchTickerState();
}

class _ChurchTickerState extends State<ChurchTicker> {
  List<MemberModel> members = List();
  MembersDAO membersDAO = MembersDAO();

  getList() async {
    members = await membersDAO.sort();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: RaisedButton(
        onPressed: () {
          MemberModel model = MemberModel(
              name: 'Ben', contact: '0543882100', location: 'Nowhere');
          membersDAO.insertDate(model);
          getList();
          setState(() {});
        },
        child: Text('Add'),
      ),
      body: ListView.builder(
        itemCount: members.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(members[index].id.toString()),
          );
        },
      ),
    );
  }
}
