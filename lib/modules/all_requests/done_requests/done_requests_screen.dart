import 'package:flutter/material.dart';

import '../../../home_layout/home_layout.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/cubit/cubit.dart';
import '../get_done_archived_data.dart';
import 'done_details_screen.dart';

class DoneRequestsScreen extends StatelessWidget {
  const DoneRequestsScreen({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Done Requests'),
      ),
      body: FutureBuilder(
        future: cubit.getDoneDocId(city: city!),
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
                    DoneDetailsScreen(
                      id: cubit.doneDocIDs[index],
                      city: city!,
                      currentIndex: index,
                    ));
              },
              title: GetDoneArchivedData(
                city: city!,
                collection: 'doneRequests',
                documentId: cubit.doneDocIDs[index],
                documentDataKey: 'companyName',
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
            itemCount: cubit.doneDocIDs.length,
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
