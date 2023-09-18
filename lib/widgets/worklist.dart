import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:login_flutter/models/actions/work_list_actions.dart';

class WorklistWidget extends StatefulWidget {
  const WorklistWidget({Key? key}) : super(key: key);

  @override
  State<WorklistWidget> createState() => _WorklistWidgetState();
}

class _WorklistWidgetState extends State<WorklistWidget> {
  List<dynamic> workList = [];
  int rowsPerPage = 10;
  bool _load = false;

  void getWorkList() async {
    setState(() {
      _load = true;
    });

    await WorkList().getWorkList().then((value) {
      Map<String, dynamic> json = jsonDecode(value);

      setState(() {
        workList = json['pxResults'];
      });
    });

    setState(() {
      _load = false;
    });
  }

  @override
  void initState() {
    getWorkList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
      child: _load
          ? Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 300),
              child: const CircularProgressIndicator.adaptive(),
            )
          : PaginatedDataTable(
              columnSpacing: 25,
              header: Row(
                children: [
                  const Text('WorkList'),
                  const SizedBox(
                    width: 200,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      getWorkList();
                    },
                    child: const Icon(Icons.refresh_rounded),
                  ),
                ],
              ),
              rowsPerPage: rowsPerPage,
              showFirstLastButtons: true,
              showCheckboxColumn: false,
              columns: const [
                DataColumn(label: Text('Case')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Category')),
                DataColumn(label: Text('Urgency')),
                DataColumn(label: Text('Create Date')),
              ],
              source: _DataSource(workList, context),
            ),
    );
  }
}

class _Row {
  _Row(
    this.cases,
    this.status,
    this.category,
    this.urgency,
    this.date,
  );

  final String cases;
  final String status;
  final String category;
  final String urgency;
  final String date;
  bool selected = false;
}

class _DataSource extends DataTableSource {
  final List workList;
  final BuildContext context;
  List<_Row> _rows = [];
  // int _selectedCount = 0;

  _DataSource(this.workList, this.context) {
    getRows(workList);
  }

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    // if (index >= _rows.length) return null;
    final row = _rows[index];
    return DataRow.byIndex(
      index: index,
      selected: row.selected,
      onSelectChanged: (value) {
        showDialog(
            barrierDismissible:
                false, // Permite cerrar el modal cuando se hace clikc afuera
            context: context,
            builder: (context) {
              return AlertDialog(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                title: const Text(
                  'Case',
                  textAlign: TextAlign.center,
                ), // Titulo de la card
                content: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Ajusta la card al texto mas pequenho
                  children: [
                    Text(row.cases),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Ok'))
                ],
              );
            });

        /**** ESTE METODO OCUPA DE LA COLUMNA DE CHECKBOX PARA MARCAR 1 O TODAS LAS FILAS *********/
        // if (row.selected != value) {
        //   _selectedCount += value! ? 1 : -1;
        //   assert(_selectedCount >= 0);
        //   row.selected = value;
        //   notifyListeners();
        // }
      },
      cells: [
        DataCell(Text(row.cases)),
        DataCell(Text(row.status)),
        DataCell(Text(row.category)),
        DataCell(Text(row.urgency.toString())),
        DataCell(Text(row.date)),
      ],
    );
  }

  getRows(List list) {
    for (var i = 0; i < list.length; i++) {
      _rows += <_Row>[
        _Row(
          list[i]['pxRefObjectInsName'],
          list[i]['pxAssignmentStatus'] ?? 'New',
          list[i]['pyLabel'],
          list[i]['pxUrgencyAssign'],
          list[i]['pxCreateDateTime'],
        ),
      ];
    }
    return _rows;
  }

  @override
  int get rowCount => _rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0; // _selectedCount;
}
