import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ecalculami app(Beta)',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        appBarTheme: AppBarTheme(
            elevation: 0,
            iconTheme: const IconThemeData(color: Color(0xfff4eee0))),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// text fields' controllers
  final TextEditingController _serialController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _consumoController = TextEditingController();
  final TextEditingController _mesController = TextEditingController();
  final TextEditingController _anoController = TextEditingController();

  final CollectionReference _products =
      FirebaseFirestore.instance.collection('things');

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _serialController,
                  decoration: const InputDecoration(
                    labelText: 'Serial de Casa',
                  ),
                ),
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                  ),
                ),
                TextField(
                  controller: _mesController,
                  decoration: const InputDecoration(
                    labelText: 'Mes',
                  ),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _anoController,
                  decoration: const InputDecoration(
                    labelText: 'Año',
                  ),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _consumoController,
                  decoration: const InputDecoration(
                    labelText: 'Consumo',
                  ),
                ),
                const SizedBox(
                  height: 17,
                ),
                ElevatedButton(
                  child: const Text('Añadir'),
                  onPressed: () async {
                    final String serial = _serialController.text;
                    final String ci = _nombreController.text;
                    final String consumo = _consumoController.text;
                    final String mes = _mesController.text;
                    final String ano = _anoController.text;

                    if (ci != "") {
                      await _products.add({
                        "serial": serial,
                        "ci": ci,
                        "consumo": consumo,
                        "mes": mes,
                        "ano": ano,
                      });

                      _serialController.text = '';
                      _nombreController.text = '';
                      _consumoController.text = '';
                      _mesController.text = '';
                      _anoController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _delete(String productId) async {
    await _products.doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Se borro correctamente los datos')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Ecalculami app(Beta)')),
        ),
        body: StreamBuilder(
          stream: _products.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  // ignore: prefer_const_constructors
                  return Card(
                    margin: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Column(
                          children: [
                            Text(
                              "N° de lote:",
                              style: TextStyle(
                                height: 1.5,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Nombre:",
                              style: TextStyle(
                                height: 1.5,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Mes:",
                              style: TextStyle(
                                height: 1.5,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Año:",
                              style: TextStyle(
                                height: 1.5,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Consumo:",
                              style: TextStyle(
                                height: 1.5,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              documentSnapshot['serial'],
                              style: const TextStyle(
                                height: 1.5,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              documentSnapshot['ci'],
                              style: const TextStyle(
                                height: 1.5,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              documentSnapshot['mes'],
                              style: const TextStyle(
                                height: 1.5,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              documentSnapshot['ano'],
                              style: const TextStyle(
                                height: 1.5,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              documentSnapshot['consumo'],
                              style: const TextStyle(
                                height: 1.5,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  size: 30,
                                ),
                                onPressed: () => _delete(documentSnapshot.id)),
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
// Add new product
        floatingActionButton: FloatingActionButton(
          // backgroundColor: Color(0xff393646),
          onPressed: () => _create(),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
