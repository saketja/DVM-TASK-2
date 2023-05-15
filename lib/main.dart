import 'package:database/services/remoteservice.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:database/utils.dart';
import 'package:database/models/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late List<UserData> data;
  var isLoaded = false;
  List<Map<String, dynamic>> userDataList = [];
  List<bool> isTappedList=[];


  @override
  void initState() {
    super.initState();
    //fetch data from api
    getData();
  }

  getData() async {
    data = await RemoteService().getUserData();

    if (data != null) {
      setState(() {
        isLoaded = true;
      });
    }

    if (isLoaded) {
      for (int i = 0; i < data.length; i++) {
        Map<String, dynamic> userDataMap = {
          'id': data[i].id,
          'name': data[i].name,
          'username': data[i].username,
          'email': data[i].email,
          'address': data[i].address.toJson(),
          'phone': data[i].phone,
          'website': data[i].website,
          'company': data[i].company.toJson(),
        };
        userDataList.add(userDataMap);
      }
      isTappedList = List.generate(
        userDataList.length,
            (i) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FLUTTER',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: SingleChildScrollView(
          child: Visibility(
            visible: isLoaded,
            child: Scene(
              userDataList: userDataList,
              isTappedList:isTappedList,
            ),
          ),
        ),
      ),
    );
  }
}

class Scene extends StatefulWidget {
  final List<Map<String, dynamic>> userDataList;
  final List<bool> isTappedList;

  const Scene({
    Key? key,
    required this.userDataList,
    required this.isTappedList,
  }) : super(key: key);

  @override
  State<Scene> createState() => _SceneState();
}

class _SceneState extends State<Scene> {
  List<bool> _isTappedList=[];
  late FirebaseFirestore _firestore;
  double minValue = -200;
  double maxValue = 200;
  late List<double> longitudeList;

  @override
  void initState() {
    super.initState();
    longitudeList = createLongitudeList();
    _firestore = FirebaseFirestore.instance;
    loadSavedData();
  }
  List<double> createLongitudeList() {
    List<double> result = [];
    for (var userData in widget.userDataList) {
      String longitude = userData['address']['geo']['lng'];
      double parsedLongitude = double.parse(longitude);
      result.add(parsedLongitude);
    }
    return result;
  }


  Future<void> loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isTappedList = List.generate(
        (widget.userDataList.length),
        (i) => prefs.getBool('$i') ?? false,
      );
    });
  }

  Future<void> saveData(int i, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('$i', value);
  }
  Future<void> saveDataToFirebase(Map<String, dynamic> userData) async {
    try {
      await _firestore.collection('userData').add(userData);
      print('Data saved to Firebase: $userData');
    } catch (error) {
      print('Error saving data to Firebase: $error');
    }
  }

  Future<void> removeDataFromFirebase(Map<String, dynamic> userData) async {
    try {
      final snapshot = await _firestore
          .collection('userData')
          .where('name', isEqualTo: userData['name'])
          .get();
      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }
      print('Data removed from Firebase: $userData');
    } catch (error) {
      print('Error removing data from Firebase: $error');
    }
  }




  @override
  Widget build(BuildContext context) {
    double baseWidth = 428;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 19 * fem),
          width: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment(-1, -0.053),
            end: Alignment(1, -0.053),
            colors: <Color>[Color(0xff050505), Color(0xff00020c)],
            stops: <double>[0, 1],
          )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(bottom: 26 * fem),
                  width: double.infinity,
                  height: 980 * fem,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0 * fem,
                        top: 0 * fem,
                        child: Align(
                            child: SizedBox(
                          width: 1518.87 * fem,
                          height: 461.4 * fem,
                          child: Image.asset(
                            'assets/group-48096070.png',
                            width: 1518.87 * fem,
                            height: 461.4 * fem,
                          ),
                        )),
                      ),
                      Positioned(
// userstke (0:300)
                        left: 28 * fem,
                        top: 72 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 77 * fem,
                            height: 39 * fem,
                            child: Text(
                              'Users',
                              style: SafeGoogleFont(
                                'Open Sans',
                                fontSize: 26 * ffem,
                                fontWeight: FontWeight.w600,
                                height: 1.3625 * ffem / fem,
                                color: const Color(0xffffffff),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
// vector77Y4W (0:304)
                        left: 0 * fem,
                        top: 0 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 663.27 * fem,
                            height: 174.88 * fem,
                            child: Image.asset(
                              'assets/vector-77.png',
                              width: 663.27 * fem,
                              height: 174.88 * fem,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
// vector78SQn (0:305)
                        left: 0 * fem,
                        top: 0 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 569.96 * fem,
                            height: 144.16 * fem,
                            child: Image.asset(
                              'assets/vector-78.png',
                              width: 569.96 * fem,
                              height: 144.16 * fem,
                            ),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 24 * fem,
                              top: 180 * fem,
                              bottom: 100 * fem),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Positioned(
// group48096139nL6 (0:320)
                                left: 36 * fem,
                                top: 108 * fem,
                                child: ClipRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 10 * fem,
                                      sigmaY: 10 * fem,
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(
                                          15 * fem, 8 * fem, 15 * fem, 8 * fem),
                                      width: 368 * fem,
                                      height: 42 * fem,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0x72f8d848)),
                                        borderRadius:
                                            BorderRadius.circular(10 * fem),
                                        gradient: const LinearGradient(
                                          begin: Alignment(-1, -2.3),
                                          end: Alignment(0.961, 2.3),
                                          colors: <Color>[
                                            Color(0x26a36c00),
                                            Color(0x26d19907)
                                          ],
                                          stops: <double>[0, 1],
                                        ),
                                      ),
                                      child: Container(
// group48096080zBG (0:322)
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: GestureDetector(
                                          onTap: () {
                                          },
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
// vectorw6W (0:324)
                                                margin: EdgeInsets.fromLTRB(
                                                    0 * fem,
                                                    0.96 * fem,
                                                    20.56 * fem,
                                                    0 * fem),
                                                width: 13.44 * fem,
                                                height: 13.96 * fem,
                                                child: Image.asset(
                                                  'assets/vector.png',
                                                  width: 13.44 * fem,
                                                  height: 13.96 * fem,
                                                ),
                                              ),
                                              Container(
// searchfornameErJ (0:323)
                                                margin: EdgeInsets.fromLTRB(
                                                    0 * fem,
                                                    0 * fem,
                                                    144 * fem,
                                                    0 * fem),
                                                child: Text(
                                                  'Search for name...',
                                                  style: SafeGoogleFont(
                                                    'Open Sans',
                                                    fontSize: 16 * ffem,
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.5 * ffem / fem,
                                                    color:
                                                        const Color(0xffc0c0c0),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
//add code for cross
                                                  print('Nothing to do');
                                                },
                                                child: Container(
// vectorZ7t (0:325)
                                                  margin: EdgeInsets.fromLTRB(
                                                      0 * fem,
                                                      0.99 * fem,
                                                      0 * fem,
                                                      0 * fem),
                                                  width: 10 * fem,
                                                  height: 15.99 * fem,
                                                  child: Image.asset(
                                                    'assets/vector-STp.png',
                                                    width: 10 * fem,
                                                    height: 12.99 * fem,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left:24*fem,
                                top:260*fem,
                                child: RangeSlider(
                                  min: -200,
                                  max: 200,
                                  divisions: 20,
                                  values: RangeValues(minValue, maxValue),
                                  onChanged: (RangeValues values) {
                                    setState(() {
                                      minValue = values.start;
                                      maxValue = values.end;
                                    });
                                  },
                                ),
                              ),
                              for (int i = 0,j=0;
                                  i < widget.userDataList.length;
                                  i++,j++)
                                if(maxValue>=longitudeList[i]&&longitudeList[i]>=minValue)
                                  Positioned(
                                    left: 24 * fem,
                                    top: (271 + 230 * j) * fem,
                                    bottom: 10 * fem,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          bottom: 10 * fem, top: 40 * fem),
                                      child: ClipRect(
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX: 25 * fem,
                                            sigmaY: 25 * fem,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(21 * fem,
                                                26 * fem, 21 * fem, 27 * fem),
                                            width: 388 * fem,
                                            height: 198 * fem,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: const Color(0xff7b7b7b)),
                                              borderRadius:
                                              BorderRadius.circular(20 * fem),
                                              gradient: const RadialGradient(
                                                center: Alignment(0.804, 1.311),
                                                radius: 1.62,
                                                colors: <Color>[
                                                  Color(0x38ffd000),
                                                  Color(0x38353535)
                                                ],
                                                stops: <double>[0, 1],
                                              ),
                                            ),
                                            child: Container(
                                              width: 278.88 * fem,
                                              height: double.infinity,
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        0 * fem,
                                                        0 * fem,
                                                        0 * fem,
                                                        19 * fem),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Container(
                                                          margin:
                                                          EdgeInsets.fromLTRB(
                                                              0 * fem,
                                                              0 * fem,
                                                              0 * fem,
                                                              4 * fem),
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                _isTappedList[i] = !_isTappedList[i];
                                                                saveData(i, _isTappedList[i]);
                                                                if (_isTappedList[i]) {
                                                                  saveDataToFirebase(widget.userDataList[i]);
                                                                } else {
                                                                  removeDataFromFirebase(widget.userDataList[i]);
                                                                }
                                                              });

                                                            },
                                                            child: Text(
                                                              widget.userDataList[
                                                              i]['name'],
                                                              style:
                                                              SafeGoogleFont(
                                                                'Open Sans',
                                                                fontSize:
                                                                20 * ffem,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w700,
                                                                height: 1.5 *
                                                                    ffem /
                                                                    fem,
                                                                color: _isTappedList[i] ? Colors.amber : Colors.white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                          EdgeInsets.fromLTRB(
                                                              0 * fem,
                                                              0 * fem,
                                                              0 * fem,
                                                              13 * fem),
                                                          child: Text(
                                                            widget.userDataList[i]
                                                            ['email'],
                                                            style: SafeGoogleFont(
                                                              'Open Sans',
                                                              fontSize: 14 * ffem,
                                                              height: 1.5 *
                                                                  ffem /
                                                                  fem,
                                                              color: const Color(
                                                                  0xfff8d848),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          constraints:
                                                          BoxConstraints(
                                                            maxWidth: 150 * fem,
                                                          ),
                                                          child: Text(
                                                            '${widget.userDataList[i]['address']['street']}\t\-${widget.userDataList[i]['address']['suite']}\n${widget.userDataList[i]['address']['city']}\t\-${widget.userDataList[i]['address']['zipcode']}',
                                                            style: SafeGoogleFont(
                                                              'Open Sans',
                                                              fontSize: 10 * ffem,
                                                              fontWeight:
                                                              FontWeight.w300,
                                                              height: 1.0625 *
                                                                  ffem /
                                                                  fem,
                                                              color: const Color(
                                                                  0xffffffff),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    height: 15 * fem,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        Container(
                                                          margin:
                                                          EdgeInsets.fromLTRB(
                                                              0 * fem,
                                                              0 * fem,
                                                              184.43 * fem,
                                                              0 * fem),
                                                          height: double.infinity,
                                                          child: Row(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                    0 * fem,
                                                                    1 * fem,
                                                                    8.22 *
                                                                        fem,
                                                                    0 * fem),
                                                                width: 12 * fem,
                                                                height: 16 * fem,
                                                                child:
                                                                Image.asset(
                                                                  'assets/vector-Wop.png',
                                                                  width: 12 * fem,
                                                                  height:
                                                                  15 * fem,
                                                                ),
                                                              ),
                                                              Text(
                                                                widget.userDataList[
                                                                i][
                                                                'address']
                                                                [
                                                                'geo']['lng'],
                                                                style:
                                                                SafeGoogleFont(
                                                                  'Open Sans',
                                                                  fontSize:
                                                                  12 * ffem,
                                                                  height: 1.5 *
                                                                      ffem /
                                                                      fem,
                                                                  color: const Color(
                                                                      0xffffffff),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          height: double.infinity,
                                                          child: Row(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                    0 * fem,
                                                                    2 * fem,
                                                                    8.22 *
                                                                        fem,
                                                                    0 * fem),
                                                                width: 14 * fem,
                                                                height: 14 * fem,
                                                                child:
                                                                Image.asset(
                                                                  'assets/vector-Vin.png',
                                                                  width: 14 * fem,
                                                                  height:
                                                                  14 * fem,
                                                                ),
                                                              ),
                                                              Text(
                                                                widget.userDataList[
                                                                i][
                                                                'address']
                                                                [
                                                                'geo']['lat'],
                                                                style:
                                                                SafeGoogleFont(
                                                                  'Open Sans',
                                                                  fontSize:
                                                                  12 * ffem,
                                                                  height: 1.5 *
                                                                      ffem /
                                                                      fem,
                                                                  color: const Color(
                                                                      0xffffffff),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

