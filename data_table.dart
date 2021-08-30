import 'package:booking_app/utils/app_date_utils.dart';
import 'package:flutter/material.dart';

class MyDataTable extends StatefulWidget {
  MyDataTable({Key? key}) : super(key: key);

  @override
  _MyDataTableState createState() => _MyDataTableState();
}

class _MyDataTableState extends State<MyDataTable> {
  List<Item> itemList = [];
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    itemList.addAll(generateItems());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(8.0),
        child: DataTable(
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
          columns: buildColumns(),
          rows: buildRows(),
        ),
      ),
    );
  }

  generateItems() {
    return List.generate(
      15,
      (index) => Item(
        no: index + 1,
        date: DateTime.now().add(Duration(days: index)),
        bookType: 'Book type ${index + 1}',
      ),
    );
  }

  buildRows() {
    return itemList
        .map(
          (item) => DataRow(
            selected: false,
            cells: [
              DataCell(Text('${item.no}')),
              DataCell(Text(AppDateUtils.dateTimeToString(item.date!))),
              DataCell(Text('${item.bookType}')),
            ],
          ),
        )
        .toList();
  }

  buildColumns() {
    return [
      DataColumn(
        label: Text('No'),
        numeric: true,
      ),
      DataColumn(
        label: Text('Date'),
        numeric: false,
        onSort: (index, ascending) => {
          if (ascending)
            {
              itemList
                  .sort((item1, item2) => item1.date!.compareTo(item2.date!))
            }
          else
            {
              itemList
                  .sort((item1, item2) => item2.date!.compareTo(item1.date!))
            },
          setState(
            () {
              _sortColumnIndex = index;
              _sortAscending = ascending;
            },
          )
        },
      ),
      DataColumn(label: Text('Book type'), numeric: true),
    ];
  }
}

class Item {
  Item({required this.no, this.date, this.bookType});

  int no;
  DateTime? date;
  String? bookType;
}
