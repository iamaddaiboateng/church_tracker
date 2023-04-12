import 'package:church_ticker/membership/all_members/view/all_members.dart';
import 'package:church_ticker/services/all_services/controller/all_services_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AllServicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final service = Provider.of<AllServiceController>(context, listen: false);
    service.setDateToList();
    return Consumer<AllServiceController>(
      builder: (_, service, __) => Scaffold(
        appBar: AppBar(
          title: Text('Church Ticker'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.people),
              onPressed: () {
                Get.to(AllMembersPage());
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            service.insert();
          },
        ),
        body: service.services.isEmpty
            ? Center(
                child: Text('No Service Added'),
              )
            : ListView.builder(
                itemCount: service.services.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text(service.services[index].id.toString()),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        service.delete(service.services[index]);
                      },
                    ),
                    title: Text(service.services[index].actualTime),
                    subtitle: Text(service.services[index].decodedTime),
                  );
                },
              ),
      ),
    );
  }
}
