import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/locationServices.dart';
import '../../shared/components/components.dart';
import '../finish_request/finishing_request_screen.dart';

class RequestDetails extends StatelessWidget {
  final String city;
  final String technicalPhone;
  final String id;
  final int currentIndex;

  const RequestDetails({
    super.key,
    required this.id,
    required this.currentIndex,
    required this.city,
    required this.technicalPhone,
  });

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    final Stream<QuerySnapshot> dataStream = FirebaseFirestore.instance
        .collection(city)
        .doc(city)
        .collection('requests')
        .snapshots();

    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: dataStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something Wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final List storeDocs = [];
            snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
              Map users = documentSnapshot.data() as Map<String, dynamic>;
              storeDocs.add(users);
              users['uId'] = documentSnapshot.id;
            }).toList();
            return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                var latitude = storeDocs[currentIndex]['latitude'];
                var longitude = storeDocs[currentIndex]['longitude'];
                return Column(
                  children: [
                    SizedBox(
                      height: height * 0.1,
                    ),
                    Text(
                      'Request From : ',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontSize: 22.0),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: Table(
                        defaultColumnWidth: const FixedColumnWidth(180.0),
                        border: TableBorder.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 2.5,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        children: [
                          TableRow(
                            children: [
                              customTableKeyCell(
                                  text: 'Company Name', context: context),
                              customTableValueCell(
                                text: storeDocs[currentIndex]['companyName'],
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              customTableKeyCell(
                                  text: 'City', context: context),
                              customTableValueCell(
                                text: storeDocs[currentIndex]['city'],
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              customTableKeyCell(
                                  text: 'School', context: context),
                              customTableValueCell(
                                text: storeDocs[currentIndex]['school'],
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              customTableKeyCell(
                                  text: 'Phone', context: context),
                              customTableValueCell(
                                text: storeDocs[currentIndex]['phone'],
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              customTableKeyCell(
                                  text: 'Location', context: context),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 20.0,
                                ),
                                child: Column(
                                  children: [
                                    defaultTextButton(
                                      onPressed: () {
                                        //locationServices.goToLocation(latitude: latitude, longitude: longitude);
                                        MapUtils.openMap(
                                            latitude: latitude,
                                            longitude: longitude);
                                      },
                                      text: 'Tap To Location',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              customTableKeyCell(
                                  text: 'Machine', context: context),
                              customTableValueCell(
                                text: storeDocs[currentIndex]['machine'],
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              customTableKeyCell(
                                  text: 'Consultation', context: context),
                              customTableValueCell(
                                text: storeDocs[currentIndex]['consultation'],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.1,
                    ),
                    customRequestAction(
                      onTap: () {
                        navigateTo(
                          context,
                          FinishingRequestScreen(
                            id: id,
                            companyName: storeDocs[currentIndex]['companyName'],
                            city: storeDocs[currentIndex]['city'],
                            school: storeDocs[currentIndex]['school'],
                            customerPhone: storeDocs[currentIndex]['phone'],
                            machine: storeDocs[currentIndex]['machine'],
                            technicalPhone: technicalPhone,
                          ),
                        );
                        //AppCubit.get(context).updateData(status: 'done', id: doneRequestsData!['id']);
                      },
                      backgroundColor: Colors.green,
                      icon: Icons.done,
                      label: 'Start Finish Request',
                    ),
                  ],
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget customTableKeyCell({
    required String text,
    required context,
  }) =>
      Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20.0,
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 20.0,
                fontWeight: FontWeight.normal,
              ),
        ),
      );

  Widget customTableValueCell({
    required String text,
  }) =>
      Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20.0,
        ),
        child: Column(
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  Widget customRequestAction({
    required VoidCallback onTap,
    required Color backgroundColor,
    required IconData icon,
    required String label,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Chip(
          elevation: 20.0,
          backgroundColor: backgroundColor,
          avatar: Icon(
            icon,
            color: Colors.white,
          ),
          label: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
}
