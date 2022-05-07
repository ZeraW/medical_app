import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/navigation_service.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.all(5.0),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: [
                  ReportCard(title: 'All Patients',description: 'A report showing all the patients registered in the system.',onTap: (){
                    NavigationService2.instance.navigateTo('All_Patients_Report');
                  },),
                  ReportCard(title: 'All Doctors',description: 'A report showing all the doctors registered in the system.',onTap: (){
                    NavigationService2.instance.navigateTo('All_Doctors_Report');
                  },),
                  ReportCard(title: 'Finance & Profits',description: 'A report showing all the doctors profits',onTap: (){
                    NavigationService2.instance.navigateTo('finance_profit_Report');
                  },),
                  ReportCard(title: 'Appointments',description: 'A report showing all the doctors Appointments',onTap: (){
                    NavigationService2.instance.navigateTo('Appointments_Report');
                  },),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  String title,description;
  Function onTap;
  ReportCard({
    this.title,
    this.description,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: 150,
        width: 300,
        decoration: BoxDecoration(
            color: xColors.offWhite,
            border: Border.all(color: xColors.mainColor),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SelectableText('$title',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
            SizedBox(height: 4,),
            SelectableText('$description',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 13),),
            Spacer(),
            SizedBox(height: 40,child: ElevatedButton(onPressed:onTap, child: Text('Show Report',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 17),),style: ButtonStyle(backgroundColor: xColors.materialColor(xColors.mainColor)),))

          ],
        ),
      ),
    );
  }


}

class SortablePage extends StatefulWidget {
  @override
  _SortablePageState createState() => _SortablePageState();
}

class _SortablePageState extends State<SortablePage> {
  List<DoctorModel> users;
  int sortColumnIndex;
  bool isAscending = false;

  @override
  void initState() {
    super.initState();

    //todo add the date in this.users
    //this.users = List.of(allUsers);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ScrollableWidget(child: buildDataTable()),
      );

  Widget buildDataTable() {
    final columns = ['name', 'phone', 'specialty'];

    return DataTable(
      sortAscending: isAscending,
      sortColumnIndex: sortColumnIndex,
      columns: getColumns(columns),
      rows: getRows(users),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
            onSort: onSort,
          ))
      .toList();

  List<DataRow> getRows(List<DoctorModel> users) =>
      users.map((DoctorModel user) {
        final cells = [user.name, user.phone, user.specialty];

        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      users.sort(
          (user1, user2) => compareString(ascending, user1.name, user2.name));
    } else if (columnIndex == 1) {
      users.sort(
          (user1, user2) => compareString(ascending, user1.phone, user2.phone));
    } else if (columnIndex == 2) {
      users.sort((user1, user2) =>
          compareString(ascending, '${user1.specialty}', '${user2.specialty}'));
    }

    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
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
