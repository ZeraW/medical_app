import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/navigation_service.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/ui_components/date_picker.dart';
import 'package:medical_app/ui_components/error_widget.dart';
import 'package:medical_app/ui_components/textfield_widget.dart';
import 'package:medical_app/ui_screens/home_widgets/doctor/diagnosis_details.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';

class MedicalHistory extends StatelessWidget {
  MedicalHistory({Key key}) : super(key: key);
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          key: _scaffoldKey,
          actions: [
            IconButton(
                onPressed: () {
                  NavigationService.patientInstance.navigateToWidget(AddFile(FirebaseAuth.instance.currentUser.uid));
                },
                icon: Icon(Icons.add))
          ],
          title: Text(
            'Medical History',
          ),
          bottom: TabBar(
            indicatorColor: Colors.grey,
            indicatorWeight: 3.0,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.w600),
            tabs: <Widget>[
              Tab(
                icon: Text(
                  "Diagnosis",
                ),
              ),
              Tab(
                icon: Text(
                  "Files",
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            DiagnosisTab(
                type: HistoryType.DIAGNOSIS, scaffoldKey: _scaffoldKey),
            FileTab(type: HistoryType.FILES, scaffoldKey: _scaffoldKey)
          ],
        ),
      ),
    );
  }
}

enum HistoryType { DIAGNOSIS, FILES }

class FileTab extends StatefulWidget {
  final HistoryType type;
  final scaffoldKey;

  FileTab({@required this.type, @required this.scaffoldKey});

  @override
  _FileTabState createState() => _FileTabState();
}

class _FileTabState extends State<FileTab> {
  @override
  Widget build(BuildContext context) {
    List<HistoryFilesModel> mList = context.watch<List<HistoryFilesModel>>();

    return mList != null
        ? ListView.builder(
            itemBuilder: (context, index) {
              HistoryFilesModel item = mList[index];
              return ListTile(
                onTap: () {
                  NavigationService.patientInstance
                      .navigateToWidget(ViewFile(item));
                },
                leading: Icon(
                  Icons.file_open,
                ),
                title: Text(
                  '${item.title}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                    '${item.date.day}-${item.date.month}-${item.date.year}',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                trailing: IconButton(
                    onPressed: () async {
                      await DatabaseService().deleteFile(
                          model: item,
                          id: FirebaseAuth.instance.currentUser.uid);
                    },
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                    )),
              );
            },
            itemCount: mList.length)
        : SizedBox();
  }
}

class DiagnosisTab extends StatefulWidget {
  final HistoryType type;
  final scaffoldKey;

  DiagnosisTab({@required this.type, @required this.scaffoldKey});

  @override
  _DiagnosisTabState createState() => _DiagnosisTabState();
}

class _DiagnosisTabState extends State<DiagnosisTab> {
  @override
  Widget build(BuildContext context) {
    List<DiagnosisModel> mList = context.watch<List<DiagnosisModel>>();

    return mList != null
        ? ListView.builder(
            itemBuilder: (context, index) {
              DiagnosisModel item = mList[index];
              return ListTile(
                onTap: (){
                  NavigationService.patientInstance.navigateToWidget(DiagnosisDetailsScreen(item));

                },
                leading: Icon(
                  Icons.medical_services,
                ),
                title: Text(
                  '${item.doctorName}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                    '${item.timestamp.day}-${item.timestamp.month}-${item.timestamp.year}',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              );
            },
            itemCount: mList.length)
        : SizedBox();
  }
}

class AddFile extends StatefulWidget {
  String userId;
  AddFile(this.userId,{Key key}) : super(key: key);

  @override
  State<AddFile> createState() => _AddFileState();
}

class _AddFileState extends State<AddFile> {
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _detailsController = new TextEditingController();
  File file;
  String _titleError = '';
  String _detailsError = '';
  String _dateError = '';
  String _fileError = '';

  DateTime pickedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        actions: [
          IconButton(
              onPressed: () {
                _apiRequest(context);
              },
              icon: Icon(Icons.check))
        ],
        title: Text(
          'Add File',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormBuilder(
              hint: "Title",
              keyType: TextInputType.text,
              controller: _titleController,
              errorText: _titleError,
              activeBorderColor: xColors.mainColor,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormBuilder(
              hint: "Details",
              keyType: TextInputType.text,
              controller: _detailsController,
              errorText: _detailsError,
              maxLines: 3,
              activeBorderColor: xColors.mainColor,
            ),
            SizedBox(
              height: 20,
            ),
            DateTimePickerBuilder(
              hint: 'Pick Date',
              onChange: (value) {
                pickedDate = value;
                setState(() {});
              },
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
                height: Responsive.height(5.0, context),
                width: 200,
                child: RaisedButton(
                  onPressed: () async {
                    FilePickerResult result =
                        await FilePicker.platform.pickFiles();

                    if (result != null) {
                      file = File(result.files.single.path);

                      setState(() {});
                    } else {
                      // User canceled the picker
                    }
                  },
                  color: xColors.mainColor,
                  child: Center(
                    child: Text(
                      "add File",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: Responsive.width(5.0, context)),
                    ),
                  ),
                )),
            GetErrorWidget(isValid: _fileError != "", errorText: _fileError)
          ],
        ),
      ),
    );
  }

  void _apiRequest(BuildContext context) async {
    String _title = _titleController.text;
    String _details = _detailsController.text;

    if (_title == null || _title.isEmpty) {
      clear();
      setState(() {
        _titleError = "add title";
      });
    } else if (_details == null || _details.isEmpty) {
      clear();
      setState(() {
        _detailsError = 'add Details';
      });
    } else if (file == null) {
      clear();
      setState(() {
        _fileError = "Please add File";
      });
    } else {
      clear();
      //do request

      BotToast.showLoading();
      await DatabaseService().addFile(
          file: file,
          add: HistoryFilesModel(
              title: _title, date: pickedDate, details: _details),
          id: widget.userId);
      BotToast.closeAllLoading();
     Navigator.pop(context);
    }
  }

  void clear() {
    setState(() {
      _titleError = '';
      _detailsError = '';
      _dateError = '';
      _fileError = '';
    });
  }
}

class ViewFile extends StatefulWidget {
  HistoryFilesModel model;

  ViewFile(this.model, {Key key}) : super(key: key);

  @override
  State<ViewFile> createState() => _ViewFileState();
}

class _ViewFileState extends State<ViewFile> {
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _detailsController = new TextEditingController();
  TextEditingController _dateController = new TextEditingController();

  String file;
  String _titleError = '';
  String _detailsError = '';

  DateTime pickedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.model.title;
    _detailsController.text = widget.model.details;
    file = widget.model.fileUrl;
    _dateController.text =
        '${widget.model.date.month}/${widget.model.date.day}/${widget.model.date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          'File Details',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormBuilder(
              hint: "Title",
              keyType: TextInputType.text,
              controller: _titleController,
              errorText: _titleError,
              enabled: false,
              activeBorderColor: xColors.mainColor,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormBuilder(
              hint: "Details",
              keyType: TextInputType.text,
              controller: _detailsController,
              errorText: _detailsError,
              maxLines: 3,
              enabled: false,
              activeBorderColor: xColors.mainColor,
            ),
            SizedBox(
              height: 20,
            ),
            DateTimePickerBuilder(
              hint: 'Date',
              controller: _dateController,
              enabled: false,
              onChange: (value) {},
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
                height: Responsive.height(5.0, context),
                width: 200,
                child: RaisedButton(
                  onPressed: () async {
                    launch(widget.model.fileUrl);
                  },
                  color: xColors.mainColor,
                  child: Center(
                    child: Text(
                      "Download File",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 18),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
