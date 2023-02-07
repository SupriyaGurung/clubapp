import 'dart:async';
import 'package:clubapp/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

import 'clubdb.dart';
import 'pages/members.dart';

List<Club> _clubList = [];
PostgreSQLConnection? connection;
bool? _isLoggedIn;

void main() {
  runApp(const ClubApp());
}

class ClubApp extends StatelessWidget {
  const ClubApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BX Clubs',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const ClubPage(title: 'Bronx Science Clubs'),
    );
  }
}

class ClubPage extends StatefulWidget {
  const ClubPage({super.key, required this.title});

  final String title;

  @override
  State<ClubPage> createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {
  final List<ClubMember> _memberList = <ClubMember>[];
  final TextEditingController _osisCtlr = TextEditingController();
  final TextEditingController _fnameCtlr = TextEditingController();
  final TextEditingController _lnameCtlr = TextEditingController();
  final TextEditingController _emailCtlr = TextEditingController();
  final TextEditingController _psswdCtlr = TextEditingController();

  bool isItemUpdate = false;

  int _selectedIndex = 0;

  void _onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    _isLoggedIn = false;
    connection = PostgreSQLConnection(
      "10.0.2.2",
      5432,
      "clubdb",
      username: "postgres",
      password: "1Mero3Postgres7",
    );

    initDb();
    _getData('club').then((value) {
      _extractClubData(value);
    });
  }

  Future waitForMe() async {
    return Future.delayed(Duration(seconds: 3), () {});
  }

  void initDb() async {
    try {
      await connection!.open();
      print("db connected ******");
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<List> _getData(String tbl_name) async {
    await waitForMe();
    List<Map<String, Map<String, dynamic>>> result =
        await connection!.mappedResultsQuery("SELECT * FROM $tbl_name");
    return result;
  }

  void _extractClubData(List maplst) {
    for (var m in maplst) {
      Club c = Club(
          m['club']['name'],
          m['club']['meeting_day'],
          m['club']['room'],
          m['club']['advisor'],
          m['club']['ad_email'],
          m['club']['president'],
          m['club']['pr_osis'],
          m['club']['pr_email'],
          m['club']['vp'],
          m['club']['vp_osis'],
          m['club']['vp_email'],
          m['club']['secretary'],
          m['club']['se_osis'],
          m['club']['se_email']);

      _clubList.add(c);
    }
  }

  Future<void> _addData(ClubMember cm) async {
    var sql_query =
        "insert into members (osis, first_name, last_name, email, password) " +
            "values('${cm.osis}', '${cm.first_name}', '${cm.last_name}', '${cm.email}', '${cm.password}')";

    await connection!.query(sql_query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: _isLoggedIn! ? MemberPage() : ClubHomePage(),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              label: 'Signup',
            ),
            _isLoggedIn!
                ? BottomNavigationBarItem(
                    icon: Icon(Icons.logout),
                    label: 'Logout',
                  )
                : BottomNavigationBarItem(
                    icon: Icon(Icons.login),
                    label: 'Login',
                  ),
          ],
          iconSize: 50.0,
          currentIndex: _selectedIndex,
          selectedItemColor: Color.fromARGB(255, 14, 118, 104),
          onTap: (int index) {
            switch (index) {
              case 0:
                _createAccountDialog();
                break;
              case 1:
                _isLoggedIn! ? _logout() : _login();
                break;
            }
            setState(() {
              _selectedIndex = index;
            });
          }),
    );
  }

  Future<void> _createAccountDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Column(
          children: [
            AlertDialog(
              title: const Text('Create an Account'),
              content: Column(
                children: [
                  TextField(
                    controller: _osisCtlr,
                    decoration:
                        const InputDecoration(hintText: 'Enter osis number'),
                  ),
                  TextField(
                    controller: _fnameCtlr,
                    decoration:
                        const InputDecoration(hintText: 'Enter first name'),
                  ),
                  TextField(
                    controller: _lnameCtlr,
                    decoration:
                        const InputDecoration(hintText: 'Enter last name'),
                  ),
                  TextField(
                    controller: _emailCtlr,
                    decoration: const InputDecoration(
                        hintText: 'Enter bronx science email'),
                  ),
                  TextField(
                    controller: _psswdCtlr,
                    decoration:
                        const InputDecoration(hintText: 'Enter password'),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    isItemUpdate = false;
                    _clearCtrl();
                  },
                ),
                TextButton(
                  child: const Text('Create'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // int index =
                    //     isItemUpdate ? member.itemNum : _memberList.length;

                    _createAccount(_osisCtlr.text, _fnameCtlr.text,
                        _lnameCtlr.text, _emailCtlr.text, _psswdCtlr.text);
                    //index);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() {
    // setState(() {
    //   _isLoggedIn = false;
    // });

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Column(
          children: [
            AlertDialog(
              title: const Text('Do you want to logout?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // isItemUpdate = false;
                    _clearCtrl();
                  },
                ),
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _isLoggedIn = false;
                    });
                    _clearCtrl();
                    // int index =
                    //     isItemUpdate ? member.itemNum : _memberList.length;
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _login() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Column(
          children: [
            AlertDialog(
              title: const Text('Login'),
              content: Column(
                children: [
                  TextField(
                    controller: _emailCtlr,
                    decoration: const InputDecoration(hintText: 'Enter email'),
                  ),
                  TextField(
                    controller: _psswdCtlr,
                    decoration:
                        const InputDecoration(hintText: 'Enter password'),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    isItemUpdate = false;
                    _clearCtrl();
                  },
                ),
                TextButton(
                  child: const Text('Login'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _authenticate().then((value) => value
                        ? setState(() {
                            _isLoggedIn = true;
                          })
                        : print(''));
                    _clearCtrl();
                    // int index =
                    //     isItemUpdate ? member.itemNum : _memberList.length;
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<bool> _authenticate() async {
    List<
        Map<
            String,
            Map<String,
                dynamic>>> result = await connection!.mappedResultsQuery(
        "SELECT * FROM members where password='${_psswdCtlr.text}' and email='${_emailCtlr.text}'");
    if (result.length == 1) {
      print('autheticated ******');
      return true;
    } else {
      print('not autheticated ******');
      return false;
    }
  }

  void _createAccount(
      String osis, String fname, String lname, String email, String psswd) {
    var cm = ClubMember(osis, fname, lname, email, psswd);
    _addData(cm);

    _clearCtrl();
  }

  // clears the TextField text values
  void _clearCtrl() {
    _fnameCtlr.clear();
    _lnameCtlr.clear();
    _osisCtlr.clear();
    _emailCtlr.clear();
    _psswdCtlr.clear();
  }
}

class ClubData {
  List<Club> getClubData() {
    return _clubList;
  }
}
