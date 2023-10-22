import 'package:eventapp/API/insert_event.dart';
import 'package:eventapp/Widgets/Widget.dart';
import 'package:eventapp/feed.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  String filename = "";
  final subjectController = TextEditingController();
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  FilePickerResult? filePickerResult;
  double _progress = 0;
  File? pickedFile;
  late Uint8List fileBytes;

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2023,10),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
  TimeOfDay selectedTime = TimeOfDay.now();


  Future<void> _openFileExplorer() async {
    try {
      filePickerResult = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (filePickerResult?.files != null &&
          filePickerResult!.files.isNotEmpty) {
        setState(
              () {
            if (kIsWeb) {
              fileBytes = filePickerResult!.files.first.bytes!;
            } else {
              pickedFile = File(filePickerResult!.files.single.path!);
            }
            filename = File(filePickerResult!.files.single.name).toString();
          },
        );
      } else {
        print('No files picked or result is empty.');
      }
    } catch (e) {
      print('Error picking files: $e');
    }
  }
  _uploadDataToStorage() {
    if (filename == "") {
      _addDataToSQL();
    } else {
      final metadata = SettableMetadata(contentType: "image/jpeg");
      final storageRef = FirebaseStorage.instance.ref();
      if (kIsWeb) {
        final uploadTask =
        storageRef.child("Event/$filename").putData(fileBytes, metadata);
        uploadTask.snapshotEvents.listen(
              (TaskSnapshot taskSnapshot) async {
            switch (taskSnapshot.state) {
              case TaskState.running:
                final progress = 100.0 *
                    (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
                setState(() {
                  _progress = progress;
                  print(_progress);
                });
                break;
              case TaskState.paused:
                showSnackBar("Paused", context, Icons.error, Colors.red);
                break;
              case TaskState.canceled:
                showSnackBar(
                    "Upload Was Cancelled", context, Icons.error, Colors.red);
                break;
              case TaskState.error:
                showSnackBar(
                    "Something Gone Wrong!", context, Icons.error, Colors.red);
                break;
              case TaskState.success:
                _addDataToSQL();
                showSnackBar("Uploaded", context, Icons.done, Colors.green);
                break;
            }
          },
        );
      } else {
        final uploadTask = storageRef
            .child("Event/$filename")
            .putFile(pickedFile!, metadata);
        uploadTask.snapshotEvents.listen(
              (TaskSnapshot taskSnapshot) async {
            switch (taskSnapshot.state) {
              case TaskState.running:
                final progress = 100.0 *
                    (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
                setState(() {
                  _progress = progress;
                  print(_progress);
                });
                break;
              case TaskState.paused:
                showSnackBar("Paused", context, Icons.error, Colors.red);
                break;
              case TaskState.canceled:
                showSnackBar(
                    "Upload Was Cancelled", context, Icons.error, Colors.red);
                break;
              case TaskState.error:
                showSnackBar(
                    "Something Gone Wrong!", context, Icons.error, Colors.red);
                break;
              case TaskState.success:
                _addDataToSQL();
                showSnackBar("Uploaded", context, Icons.done, Colors.green);
                break;
            }
          },
        );
      }
    }
  }
  _addDataToSQL() async {
   // FirebaseFirestore firestore = FirebaseFirestore.instance;
    //FirebaseAuth auth = FirebaseAuth.instance;
    if (filename != "") {
      final storageRef = FirebaseStorage.instance.ref();
      final imageUrl =
      await storageRef.child("Event/$filename").getDownloadURL();
     // print(imageUrl);
      // firestore.collection("Event Upload").doc(DateTime.now().toString()).set(
      //   {
      //     "name": auth.currentUser!.uid,
      //     "title": titleController.text,
      //     "message": subjectController.text,
      //     "file location": imageUrl,
      //     "timestamp": DateTime.now().toString(),
      //   },
      // );
      print( titleController.text);
      print(subjectController.text);
      print(userModel.user!.userId);
      print(imageUrl);
      print(selectedDate.toString());
      print(selectedTime.toString());
      final date=selectedDate.toString().trim().substring(0, 10);
      final time="${selectedTime.hour}:${selectedTime.minute}";
      print(date);
      print(time);
      insertEvent(
          titleController.text,
          subjectController.text,
          userModel.user!.userId,
          imageUrl,
          date,
          time
      );
    } else {
      // firestore.collection("Event Upload").doc(DateTime.now().toString()).set(
      //   {
      //     "name": auth.currentUser!.uid,
      //     "title": titleController.text,
      //     "message": subjectController.text,
      //     "file location": "",
      //     "timestamp": DateTime.now().toString(),
      //   },
      // );
      insertEvent(
          titleController.text,
          subjectController.text,
          userModel.user!.userId,
          " ",
          selectedDate.toString().trim().substring(0, 10),
          selectedTime.toString()
      );
    }

    if (context.mounted) {
      // Navigator.pop(context);
      showSnackBar("Done", context, Icons.done,Colors.green);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Create Event",style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold),),
      // ),
      body:Container(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Upload ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          fontFamily: 'Rubik'),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            _openFileExplorer();
                          },
                          icon: const Icon(
                            Icons.attach_file_outlined,
                            color: Colors.deepOrangeAccent,
                            size: 40,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _uploadDataToStorage();
                          },
                          icon: const Icon(
                            Icons.arrow_circle_up_rounded,
                            color: Colors.deepOrangeAccent,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              BorderedTextField(
                  maxContentLines: 1,
                  hintText: "Title",
                  labelText: "Title",
                  fieldController: titleController),
              BorderedTextField(
                  maxContentLines: 5,
                  hintText: "Details",
                  labelText: "Description",
                  fieldController: subjectController),
              BorderedTextField(
                  maxContentLines: 1,
                  hintText: "Location",
                  labelText: "Location",
                  fieldController: locationController),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                          _selectDate(context);
                      },
                      child: Container(
                        //decoration: BoxDecoration(color: Colors.deepOrangeAccent),
                        decoration: BoxDecoration(borderRadius:BorderRadius.circular(5)),
                        child: const Row(
                          children: [
                            Icon(Icons.calendar_month_sharp),
                            Text("Pick Date")
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                              decoration: BoxDecoration(borderRadius:BorderRadius.circular(5)),
                              child: Text(selectedDate.toString().trim().substring(0, 10))),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: ()async{
                              final TimeOfDay? timeOfDay= await showTimePicker(
                                  context: context,
                                  initialTime: selectedTime,
                                  initialEntryMode: TimePickerEntryMode.dial
                              );
                              if(timeOfDay!=null){
                                setState(() {
                                  selectedTime=timeOfDay;
                                });
                              }
                      },
                      child: Container(
                        //decoration: BoxDecoration(color: Colors.deepOrangeAccent),
                        decoration: BoxDecoration(borderRadius:BorderRadius.circular(5)),
                        child: const Row(
                          children: [
                            Icon(Icons.access_time),
                            Text("Pick Time")
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                              decoration: BoxDecoration(borderRadius:BorderRadius.circular(5)),
                              child: Text("${selectedTime.hour}:${selectedTime.minute}")),
                    )
                  ],
                ),
              ),


              const SizedBox(height: 16.0),
              if (_progress > 0)
                LinearProgressIndicator(
                  value: _progress,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
