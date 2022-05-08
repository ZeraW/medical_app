import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/provider/admin_manage.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:provider/provider.dart';

import 'all_patient_report.dart';

class AllDoctorsReport extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    List<DoctorModel> mList = Provider.of<List<DoctorModel>>(context);
    List<SpecialityModel> mSp = Provider.of<List<SpecialityModel>>(context);
    ReportModel report = context.watch<ReportModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: mList != null && mSp != null && report!=null
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    InkWell(onTap: (){
                      Navigator.of(context).pop();
                      context.read<AdminManage>().changeAppBarTitle(title: 'Reports');

                    },splashColor: Colors.transparent,hoverColor: Colors.transparent,child: Text('Reports',style: TextStyle(color: xColors.mainColor),)),Text('  /  ',),Text('All Doctors Report'),
                  ],
                ),
              ),
              TotalCard(title: 'Doctors', description: '${mList.length}'),

              Expanded(child: SortablePage(mList, mSp,report)),
            ],
          )
          : SizedBox(),
    );
  }
}

class SortablePage extends StatefulWidget {
  List<DoctorModel> users;
  List<SpecialityModel> spList;
  ReportModel report;

  SortablePage(this.users,this.spList,this.report);

  @override
  _SortablePageState createState() => _SortablePageState();
}

class _SortablePageState extends State<SortablePage> {
  int sortColumnIndex;
  bool isAscending = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: ScrollableWidget(child: buildDataTable()),
  );

  Widget buildDataTable() {

   print( widget.report.doctorVisitation);


    final columns = ['Name', 'Email','Phone', 'Specialty','Gender','Patients\nCount','Visitation\nCount'];

    return DataTable(
      sortAscending: isAscending,
      sortColumnIndex: sortColumnIndex,
      columns: getColumns(columns),
      rows: getRows(widget.users),
      headingRowColor: MaterialStateProperty.all(Colors.black54),
      columnSpacing: 30,
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
    label: Text(column,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: Colors.white),),
    onSort: onSort,
  ))
      .toList();

  List<DataRow> getRows(List<DoctorModel> users) => users.map((DoctorModel user) {
    final cells = [user.name,user.email, user.phone, sp(user.specialty),user.gender,'${user.patients.length}',bookingCount(user.id)];

    return DataRow(cells: getCells(cells));
  }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(rowText(data))).toList();


  int bookingCount(String id){
    return widget.report.doctorVisitation!=null && widget.report.doctorVisitation.containsKey(id)? widget.report.doctorVisitation[id]:0;
  }

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      widget.users.sort((user1, user2) =>
          compareString(ascending, user1.name, user2.name));
    } else if (columnIndex == 3) {
      widget.users.sort((user1, user2) =>
          compareString(ascending, user1.gender, user2.gender));
    } else if (columnIndex == 2) {
      widget.users.sort((user1, user2) =>
          compareString(ascending, '${user1.specialty}', '${user2.specialty}'));
    }else if (columnIndex == 6) {
      widget.users.sort((user1, user2) =>
          compareString(ascending, bookingCount(user1.id).toString(), bookingCount(user2.id).toString()));
    }else if (columnIndex == 5) {
      widget.users.sort((user1, user2) =>
          compareString(ascending, '${user1.patients.length}', '${user2.patients.length}'));
    }else if (columnIndex == 4) {
      widget.users.sort((user1, user2) =>
          compareString(ascending, '${user1.gender}', '${user2.gender}'));
    }

    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);



  Widget rowText(data){
    return ConstrainedBox(
        constraints: new BoxConstraints(
          minHeight: 5.0,
          minWidth: 5.0,
          maxHeight: 100.0,
          maxWidth: 130.0,
        ),
        child: Text('$data',maxLines: 2,overflow: TextOverflow.ellipsis,));
  }


  String sp(String id){
    return widget.spList.firstWhere((element) => element.id==id,orElse: ()=>SpecialityModel(id: 'null',name: 'null')).name;
  }

}

class ScrollableWidget extends StatelessWidget {
  final Widget child;

  const ScrollableWidget({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    physics: BouncingScrollPhysics(),
    scrollDirection: Axis.horizontal,
    child: SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: child,
    ),
  );
}