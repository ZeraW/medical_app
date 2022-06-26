import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/provider/admin_manage.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:provider/provider.dart';

class AllPatientsReport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<PatientModel> mList = Provider.of<List<PatientModel>>(context);
    List<CityModel> mCity = Provider.of<List<CityModel>>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: mList != null && mCity != null
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

                    },splashColor: Colors.transparent,hoverColor: Colors.transparent,child: Text('Reports',style: TextStyle(color: xColors.mainColor),)),Text('  /  ',),Text('All Patients Report'),
                  ],
                ),
              ),

              TotalCard(title: 'Patients', description: '${mList.length}'),
              Expanded(child: SortablePage(mList, mCity)),
            ],
          )
          : SizedBox(),
    );
  }
}

class SortablePage extends StatefulWidget {
  List<PatientModel> users;
  List<CityModel> mCity;

  SortablePage(this.users, this.mCity);

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
    final columns = ['Name', 'Email', 'Phone', 'City', 'Gender', 'Finished\nAppointment'];

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
            label: Text(
              column,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.white),
            ),
            onSort: onSort,
          ))
      .toList();

  List<DataRow> getRows(List<PatientModel> users) =>
      users.map((PatientModel user) {
        final cells = [
          user.name,
          user.email,
          user.phone,
          city(user.city),
          user.gender,user.count??0,];

        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) => cells
      .map((data) => DataCell(rowText(data))).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      widget.users.sort(
          (user1, user2) => compareString(ascending, user1.name, user2.name));
    } else if (columnIndex == 3) {
      widget.users.sort((user1, user2) =>
          compareString(ascending, user1.gender, user2.gender));
    } else if (columnIndex == 2) {
      widget.users.sort((user1, user2) =>
          compareString(ascending, '${user1.city}', '${user2.city}'));
    }else if (columnIndex == 5) {
      widget.users.sort((user1, user2) =>
          compareString(ascending, '${user1.count}', '${user2.count}'));
    }

    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  Widget rowText(data) {
    return ConstrainedBox(
        constraints: new BoxConstraints(
          minHeight: 5.0,
          minWidth: 5.0,
          maxHeight: 100.0,
          maxWidth: 130.0,
        ),
        child: Text(
          '$data',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ));
  }

  String city(String id) {
    return widget.mCity
        .firstWhere((element) => element.id == id,
            orElse: () => CityModel(id: 'null', name: 'null'))
        .name;
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


class TotalCard extends StatelessWidget {
  String title, description;

  TotalCard({
    this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: 70,
        width: 200,
        decoration: BoxDecoration(
            color: xColors.offWhite,
            border: Border.all(color: xColors.mainColor),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SelectableText(
              '$title',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            Spacer(),
            SelectableText(
              '$description',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}