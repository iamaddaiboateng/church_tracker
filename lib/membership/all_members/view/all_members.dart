import 'package:church_ticker/membership/all_members/controller/all_members_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllMembersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final allMembers = Provider.of<AllMemberController>(context, listen: false);
    allMembers.setAllMemberToMembersList();
    return Consumer<AllMemberController>(
      builder: (_, member, __) => Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save_alt),
          onPressed: () {},
        ),
        appBar: AppBar(
          title: Text("All Members"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                member.addMemberDialog();
              },
            ),
            IconButton(
              icon: Icon(Icons.access_time),
              onPressed: () async {
//              Navigator.push(context, MaterialPageRoute(builder: (context) {
//                return NewMembers();
//              }));
              },
            ),
          ],
        ),
        body: member.allMembers.isEmpty
            ? Center(
                child: Text('No Member found'),
              )
            : ListView.builder(
                itemCount: member.allMembers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(member.allMembers[index].name),
                    subtitle: Text(member.allMembers[index].contact),
                  );
                }),
      ),
    );
  }
}
