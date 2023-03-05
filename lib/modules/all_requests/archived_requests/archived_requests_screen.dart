import 'package:flutter/material.dart';


import '../../../home_layout/home_layout.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/cubit/cubit.dart';
import '../get_done_archived_data.dart';
import 'archived_details_screen.dart';

class ArchivedRequestsScreen extends StatelessWidget {
  const ArchivedRequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archived Requests'),
      ),
      body: FutureBuilder(
        future: cubit.getArchivedDocId(city: city!),
        builder: (context, snapshot) {
          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            itemBuilder: (context, index) => customListTile(
              onTapped: () {
                navigateTo(
                    context,
                    ArchivedDetailsScreen(
                      id: cubit.archivedDocIDs[index],
                      city: city!,
                      currentIndex: index,
                    ),
                );
                //print(cubit.docIDs[index]);
              },
              title: Container(
                alignment: AlignmentDirectional.center,
                child: GetDoneArchivedData(
                  city: city!,
                  collection: 'archivedRequests',
                  documentId: cubit.archivedDocIDs[index],
                  documentDataKey: 'companyName',
                ),
              ),
              leadingWidget: Icon(
                Icons.history_outlined,
                color: AppCubit.get(context).isDark
                    ? Colors.blue
                    : Colors.deepOrange,
              ),
              trailingWidget: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.chevron_right,
                  color: AppCubit.get(context).isDark
                      ? Colors.blue
                      : Colors.deepOrange,
                ),
              ),
            ),
            separatorBuilder: (context, index) => const Divider(
              thickness: 2.0,
            ),
            itemCount: cubit.archivedDocIDs.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateAndFinish(context, const HomeLayout());
        },
        child: const Icon(Icons.home),
      ),
    );
  }
}
