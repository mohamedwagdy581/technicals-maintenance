import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../shared/components/fUser.dart';
import '../../shared/network/cubit/cubit.dart';

class GetDoneArchivedData extends StatelessWidget {
  final String city;
  final String collection;
  final String documentId;
  final String documentDataKey;

  const GetDoneArchivedData({
    super.key,
    required this.documentId,
    required this.documentDataKey,
    required this.city,
    required this.collection,
  });
  @override
  Widget build(BuildContext context) {
    // Get the Collection

    final CollectionReference requests = FirebaseFirestore.instance
        .collection(city)
        .doc(city)
        .collection('technicals')
        .doc(userUID)
        .collection(collection);

    return FutureBuilder<DocumentSnapshot>(
      future: requests.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> requests =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text(
            '${requests[documentDataKey]}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: AppCubit.get(context).isDark
                      ? Colors.black
                      : Colors.white,
                ),
          );
        }
        return const Text('Loading ....');
      },
    );
  }
}
