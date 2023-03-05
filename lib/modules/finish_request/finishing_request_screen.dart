// ignore_for_file: unnecessary_null_comparison, deprecated_member_use

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

import '../../home_layout/home_layout.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/cubit/cubit.dart';
import 'requests_cubit/requests_cubit.dart';
import 'requests_cubit/requests_states.dart';

// ignore: must_be_immutable
class FinishingRequestScreen extends StatefulWidget {
  final String id;
  final String companyName;
  final String city;
  final String school;
  final String customerPhone;
  final String technicalPhone;
  final String machine;

  const FinishingRequestScreen({
    super.key,
    required this.companyName,
    required this.city,
    required this.school,
    required this.machine,
    required this.id,
    required this.customerPhone,
    required this.technicalPhone,
  });

  @override
  State<FinishingRequestScreen> createState() => _FinishingRequestScreenState();
}

class _FinishingRequestScreenState extends State<FinishingRequestScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var consultationController = TextEditingController();

  ImagePicker imagePicker = ImagePicker();
  String uniqueImageName = DateTime.now().millisecondsSinceEpoch.toString();

  String machineImageUrl = '';

  String damageImageUrl = '';
  String fixedImageUrl = '';

  var locationMessage = '';

  bool locationIcon = false;

  double latitude = 0.0;

  double longitude = 0.0;

  void getCurrentLocation() async {
    //LocationPermission permission = await Geolocator.requestPermission();

    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      locationMessage = '${position.altitude}, ${position.longitude}';
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (BuildContext context) => RequestCubit(),
      child: BlocConsumer<RequestCubit, RequestStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final Stream<QuerySnapshot> dataStream = FirebaseFirestore.instance
              .collection(city!)
              .doc(city)
              .collection('technicals')
              .snapshots();
          return Scaffold(
            appBar: AppBar(),
            body: StreamBuilder<QuerySnapshot>(
              stream: dataStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              SizedBox(
                                height: height * 0.01,
                              ),
                              // City ListTile with DropdownButton
                              customRequestDetailsRow(
                                title: 'Company Name :',
                                requestTitle: widget.companyName,
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              // City ListTile with DropdownButton
                              customRequestDetailsRow(
                                title: 'City :',
                                requestTitle: widget.city,
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),

                              // School ListTile with DropdownButton
                              customRequestDetailsRow(
                                title: 'School :',
                                requestTitle: widget.school,
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),

                              // Machine ListTile with DropdownButton
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      color: Colors.white,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            height: 100,
                                            width: 100,
                                            margin: const EdgeInsets.all(15),
                                            padding: const EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                              border: Border.all(
                                                  color: Colors.white),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  offset: Offset(2, 2),
                                                  spreadRadius: 2,
                                                  blurRadius: 1,
                                                ),
                                              ],
                                            ),
                                            child: (machineImageUrl.isNotEmpty)
                                                ? Image.network(machineImageUrl)
                                                : Image.asset(
                                                    'assets/images/empty.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          MaterialButton(
                                            onPressed: () {
                                              uploadMachineImage();
                                            },
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                side: const BorderSide(
                                                    color: Colors.blue)),
                                            elevation: 5.0,
                                            color: Colors.blue,
                                            textColor: Colors.white,
                                            //padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                            splashColor: Colors.grey,
                                            child: const Text("Machine",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      color: Colors.white,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            height: 100,
                                            width: 100,
                                            margin: const EdgeInsets.all(15),
                                            padding: const EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                              border: Border.all(
                                                  color: Colors.white),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  offset: Offset(2, 2),
                                                  spreadRadius: 2,
                                                  blurRadius: 1,
                                                ),
                                              ],
                                            ),
                                            child: (damageImageUrl.isNotEmpty)
                                                ? Image.network(damageImageUrl)
                                                : Image.asset(
                                                    'assets/images/empty.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          MaterialButton(
                                            onPressed: () {
                                              uploadDamageImage();
                                            },
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                side: const BorderSide(
                                                    color: Colors.blue)),
                                            elevation: 5.0,
                                            color: Colors.blue,
                                            textColor: Colors.white,
                                            //padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                            splashColor: Colors.grey,
                                            child: const Text("Damage",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      color: Colors.white,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            height: 100,
                                            width: 100,
                                            margin: const EdgeInsets.all(15),
                                            padding: const EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                              border: Border.all(
                                                  color: Colors.white),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  offset: Offset(2, 2),
                                                  spreadRadius: 2,
                                                  blurRadius: 1,
                                                ),
                                              ],
                                            ),
                                            child: (fixedImageUrl.isNotEmpty)
                                                ? Image.network(fixedImageUrl)
                                                : Image.asset(
                                                    'assets/images/empty.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          MaterialButton(
                                            onPressed: () {
                                              uploadFixedImage();
                                            },
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                side: const BorderSide(
                                                    color: Colors.blue)),
                                            elevation: 5.0,
                                            color: Colors.blue,
                                            textColor: Colors.white,
                                            //padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                            splashColor: Colors.grey,
                                            child: const Text("Fixed",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),

                              // Location ListTile with DropdownButton
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.grey[300],
                                ),
                                child: ListTile(
                                  title: const Text(
                                    'Press to send Your Current Location --->',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      getCurrentLocation();
                                      RequestCubit.get(context)
                                          .changeLocationIcon();
                                    },
                                    icon: Icon(
                                      RequestCubit.get(context).locationIcon,
                                      color:
                                          RequestCubit.get(context).isLocation
                                              ? Colors.blue
                                              : Colors.green,
                                      size: 30.0,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: height * 0.02,
                              ),

                              // Consultation TextField
                              SizedBox(
                                width: width * 0.8, //height: 350,
                                child: TextFormField(
                                  controller: consultationController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Must not be Empty';
                                    }
                                    return null;
                                  },
                                  textDirection: TextDirection.rtl,
                                  maxLines: 5,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: AppCubit.get(context).isDark
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                  textAlign: TextAlign.end,
                                  decoration: const InputDecoration(
                                    hintText: ' !اكتب استفسارك',
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 20,
                                      horizontal: 15,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: height * 0.03,
                              ),

                              ConditionalBuilder(
                                condition: state is! RequestLoadingState,
                                builder: (context) => defaultButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      final companyName =
                                          widget.companyName.toString();
                                      final city = widget.city.toString();
                                      final customerPhone =
                                          widget.customerPhone.toString();
                                      //final technicalPhoneNumber = widget.technicalPhone.toString();
                                      final school = widget.school.toString();
                                      final consultation =
                                          consultationController.text;
                                      if (kDebugMode) {
                                        print(latitude);
                                        print(longitude);
                                        print(widget.companyName);
                                        print(
                                            'Machine Image : $machineImageUrl');
                                        print(
                                            'Machine Type Image : $fixedImageUrl');
                                        print(
                                            'Machine Type Image : $damageImageUrl');
                                      }

                                      if (machineImageUrl.isEmpty &&
                                          fixedImageUrl.isEmpty &&
                                          damageImageUrl.isEmpty &&
                                          latitude == 0.0 &&
                                          longitude == 0.0) {
                                        return showToast(
                                          message:
                                              'All Field must not be Empty',
                                          state: ToastStates.ERROR,
                                        );
                                      } else {
                                        _showDoneAndArchivedDialog(
                                            context: context,
                                            doneOnPressed: () {
                                              RequestCubit.get(context)
                                                  .technicalDoneRequest(
                                                city: city.toString(),
                                                companyName:
                                                    companyName.toString(),
                                                school: school.toString(),
                                                technicalPhone:
                                                    technicalPhone.toString(),
                                                customerPhone:
                                                    customerPhone.toString(),
                                                machineImage: machineImageUrl,
                                                machineTypeImage: fixedImageUrl,
                                                damageImage: damageImageUrl,
                                                consultation:
                                                    consultation.toString(),
                                                longitude: longitude,
                                                latitude: latitude,
                                              );
                                              RequestCubit.get(context)
                                                  .technicalDoneHistoryRequest(
                                                city: city.toString(),
                                                companyName:
                                                    companyName.toString(),
                                                school: school.toString(),
                                                technicalPhone:
                                                    technicalPhone.toString(),
                                                customerPhone:
                                                    customerPhone.toString(),
                                                machineImage: machineImageUrl,
                                                machineTypeImage: fixedImageUrl,
                                                damageImage: damageImageUrl,
                                                consultation:
                                                    consultation.toString(),
                                                longitude: longitude,
                                                latitude: latitude,
                                              );
                                              FirebaseFirestore.instance
                                                  .collection(city)
                                                  .doc(city)
                                                  .collection('requests')
                                                  .doc(widget.id)
                                                  .delete();

                                              showToast(
                                                message:
                                                    'Request Done Successfully',
                                                state: ToastStates.SUCCESS,
                                              );
                                              navigateAndFinish(
                                                  context, const HomeLayout());
                                            },
                                            archivedOnPressed: () {
                                              RequestCubit.get(context)
                                                  .technicalArchivedRequest(
                                                city: city.toString(),
                                                companyName:
                                                    companyName.toString(),
                                                school: school.toString(),
                                                technicalPhone:
                                                    technicalPhone.toString(),
                                                customerPhone:
                                                    customerPhone.toString(),
                                                machineImage: machineImageUrl,
                                                machineTypeImage: fixedImageUrl,
                                                damageImage: damageImageUrl,
                                                consultation:
                                                    consultation.toString(),
                                                longitude: longitude,
                                                latitude: latitude,
                                              );

                                              RequestCubit.get(context)
                                                  .technicalArchivedHistoryRequest(
                                                city: city.toString(),
                                                companyName:
                                                    companyName.toString(),
                                                school: school.toString(),
                                                technicalPhone:
                                                    technicalPhone.toString(),
                                                customerPhone:
                                                    customerPhone.toString(),
                                                machineImage: machineImageUrl,
                                                machineTypeImage: fixedImageUrl,
                                                damageImage: damageImageUrl,
                                                consultation:
                                                    consultation.toString(),
                                                longitude: longitude,
                                                latitude: latitude,
                                              );

                                              FirebaseFirestore.instance
                                                  .collection(city)
                                                  .doc(city)
                                                  .collection('requests')
                                                  .doc(widget.id)
                                                  .delete();

                                              showToast(
                                                message:
                                                    'Request still Archived',
                                                state: ToastStates.WARNING,
                                              );
                                              navigateAndFinish(
                                                  context, const HomeLayout());
                                            });
                                      }
                                    }
                                  },
                                  text: 'Finish',
                                  backgroundColor: AppCubit.get(context).isDark
                                      ? Colors.blue
                                      : Colors.deepOrange,
                                ),
                                fallback: (context) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ],
                          ),
                        ),
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
        },
      ),
    );
  }

  uploadMachineImage() async {
    final firebaseStorage = FirebaseStorage.instance;
    final imagePicker = ImagePicker();
    PickedFile? image;
    image = await imagePicker.getImage(source: ImageSource.camera);
    var file = File(image!.path);

    if (image != null) {
      final fileName = getRandomString(15) + extension(image.path);
      //Upload to Firebase
      var snapshot = await firebaseStorage
          .ref()
          .child('images/imageName')
          .child(fileName)
          .putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        machineImageUrl = downloadUrl;
      });
    } else {
      if (kDebugMode) {
        print('No Image Path Received');
      }
    }
  }

  uploadDamageImage() async {
    final firebaseStorage = FirebaseStorage.instance;
    final imagePicker = ImagePicker();
    PickedFile? image;
    image = await imagePicker.getImage(source: ImageSource.camera);
    var file = File(image!.path);

    if (image != null) {
      final fileName = getRandomString(15) + extension(image.path);
      //Upload to Firebase
      var snapshot = await firebaseStorage
          .ref()
          .child('images/imageName')
          .child(fileName)
          .putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        damageImageUrl = downloadUrl;
      });
    } else {
      if (kDebugMode) {
        print('No Image Path Received');
      }
    }
  }

  uploadFixedImage() async {
    final firebaseStorage = FirebaseStorage.instance;
    final imagePicker = ImagePicker();
    PickedFile? image;
    image = await imagePicker.getImage(source: ImageSource.camera);
    var file = File(image!.path);

    if (image != null) {
      final fileName = getRandomString(15) + extension(image.path);
      //Upload to Firebase
      var snapshot = await firebaseStorage
          .ref()
          .child('images/imageName')
          .child(fileName)
          .putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        fixedImageUrl = downloadUrl;
      });
    } else {
      if (kDebugMode) {
        print('No Image Path Received');
      }
    }
  }

  Widget customRequestDetailsRow({
    required String title,
    required String requestTitle,
    Widget? trailingWidget,
  }) =>
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[300],
        ),
        child: ListTile(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    requestTitle,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          trailing: trailingWidget,
        ),
      );

  Widget defaultOutlineAddButton({
    required VoidCallback onPressed,
    required Widget child,
  }) =>
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                width: 2.5,
                color: Colors.grey.withOpacity(0.5),
              ),
            ),
            onPressed: onPressed,
            child: child,
          ),
        ),
      );

  Future<bool> _showDoneAndArchivedDialog({
    context,
    required VoidCallback doneOnPressed,
    required VoidCallback archivedOnPressed,
  }) async {
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Finishing Request'),
              content: const Text(
                  'If Request is Done!, Enter the Done Button, if not Enter the Archive Button.'),
              actions: [
                defaultButton(
                  onPressed: doneOnPressed,
                  text: 'Done',
                  backgroundColor: Colors.green,
                ),
                defaultButton(
                  onPressed: archivedOnPressed,
                  text: 'Archive',
                  backgroundColor: Colors.red,
                ),
              ],
            ));
  }
}
