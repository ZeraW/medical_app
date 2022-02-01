import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/provider/admin_manage.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:provider/provider.dart';

class Body extends StatelessWidget {
  final List<DoctorModel> mList;
  final List<SpecialityModel> mSpList;
  Body(this.mList,this.mSpList);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.all(5.0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Responsive.width(2, context),
                vertical: Responsive.height(1, context)),
            child: Column(
              children: [
                Row(
                  children: [
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        context.read<DoctorManage>().showAddScreen();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(Icons.add),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              xColors.materialColor(xColors.mainColor)),
                    )
                  ],
                ),
                SizedBox(height: 20,),
                mList != null && mSpList!= null
                    ? Expanded(
                        child:SortablePage(mList,mSpList)

                      )
                    : SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class SortablePage extends StatefulWidget {
  List<DoctorModel> users;
  List<SpecialityModel> spList;


  SortablePage(this.users,this.spList);

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
    final columns = ['Name', 'Phone', 'Specialty','Gender','Edit'];

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
    final cells = [user.name, user.phone, sp(user.specialty),user.gender,user];

    return DataRow(cells: getCells(cells));
  }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(data is String ?rowText(data): editBtn(data))).toList();

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
    }

    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);


  Widget editBtn(data){
    return TextButton(onPressed: (){
      context.read<DoctorManage>().hideEditScreen();
      Future.delayed(Duration(milliseconds: 25), () {
        context.read<DoctorManage>().showEditScreen(data);
      });
    },child: Icon(Icons.edit,color: Colors.black54,));
  }

  Widget rowText(data){
    return SizedBox(width: 100,child: Text('$data',maxLines: 2,overflow: TextOverflow.ellipsis,));
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