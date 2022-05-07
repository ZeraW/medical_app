import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:provider/provider.dart';

class AllPatientsReport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<PatientModel> mList = Provider.of<List<PatientModel>>(context);
    List<CityModel> mCity = Provider.of<List<CityModel>>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: mList != null && mCity != null
          ? SortablePage(mList, mCity)
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
    final columns = ['Name', 'Email', 'Phone', 'City', 'Gender'];

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
          user.gender];

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
    }

    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  Widget rowText(data) {
    return SizedBox(
        width: 100,
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
