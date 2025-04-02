/// Archivo para hacer diferentes pruebas con widgets o metodos

import 'package:flutter/material.dart';
import 'package:login_flutter/theme/app_theme.dart';

const itemSize = 130.0;
double scale = 0.0;
double opacity = 0.0;

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  //QuillController _controller = QuillController.basic();

  Map<String, String> globalGroupValue = {};
  List<Map<String, String>> opcionesAutoComplete = [
    {"H": "Honda"},
    {"HY": "Hyundai"},
    {"NS": "Nissan"},
    {"SZ": "Suzuki"},
    {"TY": "Toyota"}
  ];

  Widget currencyInput(String titulo, String valor) {
    /*return TextField(
      inputFormatters: [CurrencyTextInputFormatter(decimalDigits: 5)],
      keyboardType: TextInputType.number,
      textAlign: TextAlign.right,
      onSubmitted: (value) {
        print(value);
      },
    );*/
    /*return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: 5,
    );*/
    return ConstrainedBox(
      constraints: const BoxConstraints(),
      child: Column(
        children: [
          Text(
            titulo,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            valor,
          )
        ],
      ),
    );
  }

  cards(index) {
    final itemPositionOffset = index * itemSize;
    final diference = scrollController.offset - itemPositionOffset;
    final percent = 1 - (diference / itemSize);
    opacity = percent;
    scale = percent;
    if (opacity > 1.0) opacity = 1.0;
    if (opacity < 0.0) opacity = 0.0;
    if (percent > 1.0) scale = 1.0;

    return Align(
      heightFactor: 0.8,
      child: Opacity(
        opacity: opacity,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()..scale(scale, 1.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {},
              child: SizedBox(
                height: itemSize,
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ListTile(
                      title: Text(
                        'I-3005',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryColor),
                      ),
                      subtitle: const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                            'Ipsum mollit nostrud id id fugiat sunt voluptate amet sint eu ullamco.'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // List<Widget> arrCards = [];

    // for (var i = 1; i <= 60; i++) {
    /* arrCards.add(ListTile(
        title: RichText(
            text: TextSpan(style: TextStyle(color: Colors.black), children: [
          const TextSpan(text: "\nNOMBRE: "),
          const TextSpan(
              text:
                  "Est et quis mollit duis aliqua consequat pariatur excepteur aute amet cillum voluptate ipsum."),
          const TextSpan(text: "\n"),
          const TextSpan(text: "ID: "),
          TextSpan(text: "$i"),
        ])),
      ));*/

    // arrCards.add(
    //   TextButton(
    //     onPressed: () {},
    //     child: const Card(
    //       elevation: 5,
    //       child: Padding(
    //         padding: EdgeInsets.all(15),
    //         child: ListTile(
    //           hoverColor: Colors.blueAccent,
    //           leading: Icon(
    //             size: 30,
    //             Icons.wysiwyg_rounded,
    //             // color: AppTheme.primaryColor,
    //           ),
    //           title: Text('I-3005',
    //               style: TextStyle(fontWeight: FontWeight.w700)
    //               // color: AppTheme.primaryColor)
    //               ),
    //           subtitle: Text(
    //               'Ipsum mollit nostrud id id fugiat sunt voluptate amet sint eu ullamco.'),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    // }
    // return arrCards;
  }

  bool pressed = false;

  final scrollController = ScrollController();

  onListen() {
    setState(() {});
  }

  @override
  void initState() {
    scrollController.addListener((onListen));
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener((onListen));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /* return const SingleChildScrollView(
      child: FormBuilderWidget(
          pzInsKey:
              "ASSIGN-WORKLIST CF-FW-INTERPRE-WORK R-4017!TERMSCONDITIONS"),
    );*/

    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: AppTheme.primaryColor,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
            ]),
        appBar: AppBar(title: const Text('Dashboard')),
        body: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverAppBar(
              centerTitle: true,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'WorkList',
                style: TextStyle(color: AppTheme.primaryColor, fontSize: 25),
              ),
            ),
            const SliverAppBar(
              flexibleSpace: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search case',
                    prefixIcon: Icon(Icons.search),
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              pinned: true,
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 15,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                // final itemPositionOffset = index * itemSize;
                // final diference = scrollController.offset - itemPositionOffset;
                // final percent = 1 - (diference / itemSize);
                // opacity = percent;
                // scale = percent;
                // if (opacity > 1.0) opacity = 1.0;
                // if (opacity < 0.0) opacity = 0.0;
                // if (percent > 1.0) scale = 1.0;

                return cards(index);
                // Align(
                //   heightFactor: 0.9,
                //   child: Opacity(
                //     opacity: opacity,
                //     child: Transform(
                //       alignment: Alignment.center,
                //       transform: Matrix4.identity()..scale(scale, 1.0),
                //       child: Padding(
                //         padding: const EdgeInsets.only(left: 8, right: 8),
                //         child: Card(
                //           shape: const RoundedRectangleBorder(
                //             borderRadius:
                //                 // BorderRadius.all(Radius.circular(20))
                //                 BorderRadius.only(
                //               topLeft: Radius.circular(20),
                //               topRight: Radius.circular(20),
                //             ),
                //           ),
                //           elevation: 10,
                //           child: SizedBox(
                //             height: itemSize,
                //             child: Row(
                //               children: [
                //                 Expanded(
                //                   child: Padding(
                //                     padding: const EdgeInsets.all(15.0),
                //                     child: Text('I-3005',
                //                         style: TextStyle(
                //                             color: AppTheme.primaryColor,
                //                             fontSize: 20,
                //                             fontWeight: FontWeight.w700)
                //                         // color: AppTheme.primaryColor)
                //                         ),
                //                   ),
                //                 ),
                //                 const Padding(
                //                   padding: EdgeInsets.all(8.0),
                //                   child: Text('Ipsum mollit nostrud id '),
                //                 ),
                //                 Row(
                //                   children: [
                //                     TextButton(
                //                         onPressed: () {}, child: Text('Open')),
                //                   ],
                //                 )
                //               ],
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // );
              }, childCount: 20),
            )
          ],
        )

        // SingleChildScrollView(
        //   child: Column(
        //     children: [
        //       const Padding(
        //         padding: EdgeInsets.only(top: 15, right: 10, left: 10),
        //         child: InputsWidget(
        //           property: 'search',
        //           labelText: 'Search',
        //           frmValues: {},
        //         ),
        //       ),
        //       Column(
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         mainAxisSize: MainAxisSize.max,
        //         children: cards(),
        //       ),
        //     ],
        //   ),
        // ),
        );
  }
}
