import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Woolha.com Flutter Tutorial',
      home: DataTableExample(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Item {
  Item({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.isSelected,
  });

  int id;
  String name;
  double price;
  String description;
  bool isSelected;
}

class DataTableExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DataTableExampleState();
  }
}

class DataTableExampleState extends State<DataTableExample> {
  List<Item> _items = [];
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      _items = _generateItems();
    });
  }

  List<Item> _generateItems() {
    return List.generate(15, (int index) {
      return Item(
        id: index + 1,
        name: 'Item ${index + 1}',
        price: (index + 1) * 1000.00,
        description: 'Details of item ${index + 1}',
        isSelected: (index + 1) % 2 == 0 ? false : true,
      );
    });
  }

  void updateSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(
        label: const Text('No'),
        numeric: false, // Deliberately set to false to avoid right alignment.
      ),
      DataColumn(
        label: const Text('Name'),
        numeric: false,
        tooltip: 'Name of the item',
        onSort: (int columnIndex, bool ascending) {
          if (ascending) {
            _items.sort((item1, item2) => item1.name.compareTo(item2.name));
          } else {
            _items.sort((item1, item2) => item2.name.compareTo(item1.name));
          }

          setState(() {
            _sortColumnIndex = columnIndex;
            _sortAscending = ascending;
          });
        },
      ),
      DataColumn(
        label: const Text('Price'),
        numeric: false, // Deliberately set to false to avoid right alignment.
        tooltip: 'Price of the item',
        onSort: (int columnIndex, bool ascending) {
          if (ascending) {
            _items.sort((item1, item2) => item1.price.compareTo(item2.price));
          } else {
            _items.sort((item1, item2) => item2.price.compareTo(item1.price));
          }

          setState(() {
            _sortColumnIndex = columnIndex;
            _sortAscending = ascending;
          });
        },
      ),
      DataColumn(
        label: const Text('Description'),
        numeric: false,
        tooltip: 'Description of the item',
      ),
    ];
  }

  DataRow _createRow(Item item) {
    return DataRow(
      // index: item.id, // for DataRow.byIndex
      key: ValueKey(item.id),
      selected: item.isSelected,
      onSelectChanged: (bool? isSelected) {
        if (isSelected != null) {
          item.isSelected = isSelected;

          setState(() {});
        }
      },
      color: MaterialStateColor.resolveWith((Set<MaterialState> states) =>
          states.contains(MaterialState.selected)
              ? Colors.pink.shade100
              : Color.fromARGB(100, 215, 217, 219)),
      cells: [
        DataCell(
          Text(item.id.toString()),
        ),
        DataCell(
          Text(item.name),
          placeholder: false,
          showEditIcon: true,
          onTap: () {
            print('onTap');
          },
        ),
        DataCell(Text(item.price.toString())),
        DataCell(
          Text(item.description),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Woolha.com Flutter Tutorial'),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: DataTable(
              sortColumnIndex: _sortColumnIndex,
              sortAscending: _sortAscending,
              columnSpacing: 0,
              dividerThickness: 5,
              onSelectAll: (bool? isSelected) {
                if (isSelected != null) {
                  _items.forEach((item) {
                    item.isSelected = isSelected;
                  });

                  setState(() {});
                }
              },
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.amberAccent, width: 1)),
              dataRowColor: MaterialStateColor.resolveWith(
                  (Set<MaterialState> states) =>
                      states.contains(MaterialState.selected)
                          ? Colors.blue
                          : Color.fromARGB(100, 215, 217, 219)),
              dataRowHeight: 80,
              dataTextStyle: const TextStyle(
                  fontStyle: FontStyle.italic, color: Colors.black),
              headingRowColor: MaterialStateColor.resolveWith(
                  (states) => Colors.lightBlue.shade100),
              headingRowHeight: 80,
              headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
              horizontalMargin: 10,
              showBottomBorder: true,
              showCheckboxColumn: false,
              columns: _createColumns(),
              rows: _items.map((item) => _createRow(item)).toList(),
            ),
          ),
        ));
  }
}
