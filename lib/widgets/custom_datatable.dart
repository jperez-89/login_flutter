import 'package:flutter/material.dart';

class CustomDatatable extends StatefulWidget {
  final List rows;
  final List header;
  const CustomDatatable({Key? key, required this.rows, required this.header})
      : super(key: key);

  @override
  State<CustomDatatable> createState() => _CustomDatatableState();
}

class _CustomDatatableState extends State<CustomDatatable> {
  int numItems = 0;
  int rowsPerPage = 0;
  late List<bool> selected;
  List<DataColumn> labelHeaders = [];
  List<DataRow> lstDataRow = [];

  @override
  void initState() {
    numItems = widget.rows.length;
    rowsPerPage = 5;
    selected = List<bool>.generate(numItems, (int index) => false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return numItems > 0
        ? SingleChildScrollView(
            padding: const EdgeInsets.only(left: 3, right: 3, top: 10),
            child: PaginatedDataTable(
              columnSpacing: 25,
              rowsPerPage: numItems > 5 ? 5 : 1,
              // onRowsPerPageChanged: (value) {
              //   setState(() {
              //     rowsPerPage = value ?? rowsPerPage;
              //   });
              // },
              // showCheckboxColumn: true,
              // columnSpacing: 35,
              columns: getDataColum(widget.header),
              //   const <DataColumn>[
              // DataColumn(label: Text('Number')),
              // DataColumn(label: Text('Number')),
              // ],
              source: _DataSource(widget.rows, selected, numItems, context),
              // rows: getDataRows(widget.rows),
              // const <DataRow>[
              //   DataRow(
              //     cells: <DataCell>[
              //       DataCell(Text('hola')),
              //       DataCell(Text('hola')),
              //       DataCell(Text('hola')),
              //       DataCell(Text('hola')),
              //       DataCell(Text('hola')),
              //       DataCell(Text('hola')),
              //     ],
              //   )
              // ],
            ),
          )
        : const Text('');
  }

  List<DataColumn> getDataColum(List headers) {
    for (var i = 0; i < headers.length; i++) {
      // print(headers[i]);
      // print(headers[i]['caption']['value']);
      labelHeaders += <DataColumn>[
        DataColumn(
          label: Text(headers[i]['caption']['value']),
        ),
      ];
    }
    return labelHeaders;
  }

  List<DataRow> getDataRows(List rows) {
    for (var i = 0; i < rows.length; i++) {
      print('rows');
      print(rows[i]);
      // print(rows[i]['caption']['value']);
      lstDataRow += <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text(rows[i]['caption']['value'])),
          ],
          color: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            // All rows will have the same selected color.
            if (states.contains(MaterialState.selected)) {
              return Theme.of(context).colorScheme.primary.withOpacity(0.08);
            }
            // Even rows will have a grey color.
            if (i.isEven) {
              return Colors.grey.withOpacity(0.3);
            }
            return null; // Use default value for other states and odd rows.
          }),
          selected: selected[i],
          onSelectChanged: (bool? value) {
            setState(() {
              selected[i] = value!;
            });
          },
        ),
      ];
    }
    return lstDataRow;
  }
}

class _DataSource extends DataTableSource {
  final List workList;
  // final BuildContext context;
  List<DataColumn> labelHeaders = [];
  List<DataRow> lstDataRow = [];
  final int numItems;
  List<bool> selected;
  // final Map<String, String> frmValues = {};
  // int _selectedCount = 0;

  _DataSource(this.workList, this.selected, this.numItems, context) {
    selected = List<bool>.generate(numItems, (int index) => false);
    getDataRows(workList, context);
  }

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    final row = lstDataRow[index];

    return DataRow.byIndex(
      index: index,
      selected: row.selected,
      onSelectChanged: (value) {
        print(value);
        // Navigator.pushNamed(context, 'newAssigment', arguments: {
        //   'option': 'getView',
        //   'name': row.category,
        //   'assignmentId': row.cases,
        //   'pzInsKey': row.pzInsKey,
        // });

        /**** ESTE METODO OCUPA DE LA COLUMNA DE CHECKBOX PARA MARCAR 1 O TODAS LAS FILAS *********/
        // if (row.selected != value) {
        //   _selectedCount += value! ? 1 : -1;
        //   assert(_selectedCount >= 0);
        //   row.selected = value;
        //   notifyListeners();
        // }
      },
      cells: [DataCell(Text(row.toString()))],
    );
  }

  List<DataRow> getDataRows(List rows, context) {
    for (var i = 0; i < rows.length; i++) {
      // print('rows');
      // print(rows[i]);
      // print(rows[i]['caption']['value']);
      lstDataRow += <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text(rows[i]['caption']['value'])),
          ],
          color: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            // All rows will have the same selected color.
            if (states.contains(MaterialState.selected)) {
              return Theme.of(context).colorScheme.primary.withOpacity(0.08);
            }
            // Even rows will have a grey color.
            if (i.isEven) {
              return Colors.grey.withOpacity(0.3);
            }
            return null; // Use default value for other states and odd rows.
          }),
          selected: selected[i],
          // onSelectChanged: (bool? value) {
          //   setState(() {
          //     selected[i] = value!;
          //   });
          // },
        ),
      ];
    }
    return lstDataRow;
  }

  // getRows(List list) {
  //   for (var i = 0; i < list.length; i++) {
  //     // String pxRef = list[i]['pxRefObjectKey'];
  //     // String pzInsKey = list[i]['pzInsKey'];
  //     _rows += <_Row>[
  //       _Row(
  //         list[i]['pzInsKey'],
  //         list[i]['pxTaskLabel'],
  //         list[i]['pxRefObjectInsName'],
  //         list[i]['pxAssignmentStatus'] ?? 'New',
  //         list[i]['pyLabel'],
  //         list[i]['pxUrgencyAssign'],
  //         list[i]['pxCreateDateTime'],
  //       ),
  //     ];
  //   }
  //   return _rows;
  // }

  @override
  int get rowCount => numItems;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0; // _selectedCount;
}


// DataRow(
//         color: MaterialStateProperty.resolveWith<Color?>(
//             (Set<MaterialState> states) {
//           // All rows will have the same selected color.
//           if (states.contains(MaterialState.selected)) {
//             return Theme.of(context).colorScheme.primary.withOpacity(0.08);
//           }
//           // Even rows will have a grey color.
//           if (index.isEven) {
//             return Colors.grey.withOpacity(0.3);
//           }
//           return null; // Use default value for other states and odd rows.
//         }),
//         cells: <DataCell>[DataCell(Text('Row'))],
//         // cells: <DataCell>[DataCell(Text('Row $index'))],
//         selected: selected[index],
//         onSelectChanged: (bool? value) {
//           setState(() {
//             selected[index] = value!;
//           });
//         },
//       ),
