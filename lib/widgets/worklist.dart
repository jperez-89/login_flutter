import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:login_flutter/theme/app_theme.dart';
import 'package:login_flutter/models/actions/datapage_actions.dart';

class WorklistWidget extends StatefulWidget {
  const WorklistWidget({Key? key}) : super(key: key);

  @override
  State<WorklistWidget> createState() => _WorklistWidgetState();
}

class _WorklistWidgetState extends State<WorklistWidget> {
  List<dynamic> workList = [], workListBackUp = [];
  int rowsPerPage = 10;
  bool _load = false;
  bool _service = true;
  String msg = '';

  // Obtiene la lista de assignments
  void getWorkList() async {
    setState(() {
      _load = true;
    });

    await DataPageActions().getDataPage('D_Worklist').then((value) {
      if (value.statusCode == 503) {
        setState(() {
          _load = false;
          _service = false;
          msg = 'Servicio no disponible';
        });
      }
      if (value.statusCode == 404) {
        setState(() {
          _load = false;
          _service = false;
          msg = value.body;
        });
      } else if (value.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(value.body);

        setState(() {
          workList = json['pxResults'];
          workListBackUp = json['pxResults'];
          _load = false;
        });
      }
    });
  }

//  Refresca la lista de assignment cada 1 minuto
  void refreshWorkList() {
    Timer.periodic(const Duration(minutes: 10), (timer) async {
      await DataPageActions().getDataPage('D_Worklist').then((value) {
        if (value.statusCode == 503) {
          _load = false;
          _service = false;
          setState(() {});
        } else {
          Map<String, dynamic> json = jsonDecode(value.body);

          workList = json['pxResults'];
          _load = false;
          setState(() {});
        }
      });
    });
  }

  @override
  void initState() {
    getWorkList();
    // refreshWorkList();
    super.initState();
  }

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 3, right: 3, top: 10),
      child: _load
          ? Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 300),
              child: const CircularProgressIndicator.adaptive(),
            )
          : _service
              ? PaginatedDataTable(
                  columnSpacing: 25,
                  rowsPerPage: rowsPerPage,
                  availableRowsPerPage: const [6, 8, 10, 15, 20, 25],
                  onRowsPerPageChanged: (value) {
                    setState(() {
                      rowsPerPage = value ?? rowsPerPage;
                    });
                  },
                  showFirstLastButtons: true,
                  showCheckboxColumn: false,
                  header: Container(
                    padding: EdgeInsets.zero,
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'Search case',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      onChanged: (value) {
                        if (value != '') {
                          workList = workListBackUp
                              .where((element) =>
                                  element['pxRefObjectInsName'].contains(value))
                              .toList();
                          setState(() {});
                        }
                      },
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      style: const ButtonStyle(
                          foregroundColor:
                              MaterialStatePropertyAll(AppTheme.white),
                          backgroundColor:
                              MaterialStatePropertyAll(AppTheme.primaryColor)),
                      onPressed: () {
                        getWorkList();
                      },
                      child: const Icon(Icons.refresh_rounded),
                    ),
                  ],
                  columns: const [
                    DataColumn(label: Text('Case')),
                    DataColumn(label: Text('Stage')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Category')),
                    DataColumn(label: Text('Urgency')),
                    DataColumn(label: Text('Create Date')),
                  ],
                  source: _DataSource(workList, context),
                )
              : Center(
                  child: Text(
                    'Server Response: $msg',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
    );
  }
}

class _Row {
  _Row(
    this.pzInsKey,
    this.stage,
    this.cases,
    this.status,
    this.category,
    this.urgency,
    this.date,
  );

  final String cases;
  final String stage;
  final String status;
  final String category;
  final String urgency;
  final String date;
  String pzInsKey;
  // bool selected = false;
}

class _DataSource extends DataTableSource {
  final List workList;
  final BuildContext context;
  List<_Row> _rows = [];
  final Map<String, String> frmValues = {};
  // int _selectedCount = 0;

  _DataSource(this.workList, this.context) {
    getRows(workList);
  }

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    final row = _rows[index];

    return DataRow.byIndex(
      index: index,
      // selected: row.selected,
      onSelectChanged: (value) {
        Navigator.pushNamed(context, 'newAssigment', arguments: {
          'option': 'getView',
          'name': row.category,
          'assignmentId': row.cases,
          'pzInsKey': row.pzInsKey,
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
        DataCell(Text(row.stage)),
        DataCell(Text(row.status)),
        DataCell(Text(row.category)),
        DataCell(Text(row.urgency.toString())),
        DataCell(Text(row.date)),
      ],
    );
  }

  getRows(List list) {
    for (var i = 0; i < list.length; i++) {
      // String pxRef = list[i]['pxRefObjectKey'];
      // String pzInsKey = list[i]['pzInsKey'];
      _rows += <_Row>[
        _Row(
          list[i]['pzInsKey'],
          list[i]['pxTaskLabel'],
          list[i]['pxRefObjectInsName'],
          list[i]['pyAssignmentStatus'],
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
