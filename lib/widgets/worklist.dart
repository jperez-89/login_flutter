import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:login_flutter/models/actions/work_list_actions.dart';
import 'package:login_flutter/widgets/form_builder.dart';

class WorklistWidget extends StatefulWidget {
  const WorklistWidget({Key? key}) : super(key: key);

  @override
  State<WorklistWidget> createState() => _WorklistWidgetState();
}

class _WorklistWidgetState extends State<WorklistWidget> {
  List<dynamic> workList = [];
  int rowsPerPage = 10;
  bool _load = false;
  bool _service = true;

  // Obtiene la lista de assignments
  void getWorkList() async {
    setState(() {
      _load = true;
    });

    await WorkList().getWorkList().then((value) {
      if (value.statusCode == 503) {
        setState(() {
          _load = false;
          _service = false;
        });
      } else {
        Map<String, dynamic> json = jsonDecode(value.body);

        setState(() {
          workList = json['pxResults'];
          _load = false;
        });
      }
    });
  }

//  Refresca la lista de assignment cada 1 minuto
  void refreshWorkList() {
    Timer.periodic(const Duration(minutes: 1), (timer) async {
      await WorkList().getWorkList().then((value) {
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
    refreshWorkList();
    super.initState();
  }

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
                  header: const Row(
                    children: [
                      Text('WorkList'),
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        getWorkList();
                      },
                      child: const Icon(Icons.refresh_rounded),
                    ),
                  ],
                  columns: const [
                    DataColumn(label: Text('Case')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Category')),
                    DataColumn(label: Text('Urgency')),
                    DataColumn(label: Text('Create Date')),
                  ],
                  source: _DataSource(workList, context),
                )
              : const Center(
                  child: Text(
                    'Servicio no disponible',
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
    this.cases,
    this.status,
    this.category,
    this.urgency,
    this.date,
  );

  String pzInsKey;
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
    final row = _rows[index];

    return DataRow.byIndex(
      index: index,
      // selected: row.selected,
      onSelectChanged: (value) {
        showDialog(
            // showAdaptiveDialog(
            // Permite cerrar el modal cuando se hace clikc afuera
            barrierDismissible: true,
            context: context,
            builder: (context) {
              return AlertDialog(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                title: Text(
                  'Case ${row.cases}',
                  textAlign: TextAlign.center,
                ),
                content: SingleChildScrollView(
                  child: FormBuilderWidget(
                    pzInsKey: row.pzInsKey,
                  ),
                ),
                alignment: Alignment.center,

                /** ----------ACCIONES DE ALERT DIALOG ----------- */
                // actions: [
                //   TextButton(
                //       onPressed: () => Navigator.pop(context),
                //       child: const Text('Ok'))
                // ],
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
      // String pxRef = list[i]['pxRefObjectKey'];
      // String pzInsKey = list[i]['pzInsKey'];
      _rows += <_Row>[
        _Row(
          list[i]['pzInsKey'],
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
