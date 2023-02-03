import 'dart:async';
import 'package:clubapp/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:flutter/src/material/colors.dart';
import 'clubdb.dart';
import 'pages/members.dart';

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
      title: 'Bronx Science Clubs',
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

  // PostgreSQLConnection? connection;
  // bool _isLoggedIn = false;
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
  }
  // var connection = PostgreSQLConnection(
  //   "10.0.2.2",
  //   5432,
  //   "clubdb",
  //   username: "postgres",
  //   password: "app7post",
  // );

  Future<void> initDb() async {
    // connection = PostgreSQLConnection(
    //   "10.0.2.2",
    //   5432,
    //   "clubdb",
    //   username: "postgres",
    //   password: "app7post",
    // );

    try {
      print('Connecting...');
      await connection!.open();
      print('Database Connected!');
    } catch (e) {
      print("Error: $e");
    }

    // List<Map<String, Map<String, dynamic>>> result =
    //     await connection!.mappedResultsQuery("SELECT * FROM club");
    // if (result.length > 1) {
    //   for (var c in result) {
    //     var x = c.values.toList();
    //     print(x);
    //   }
    // }
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
        child: _isLoggedIn! ? MemberPage() : ClubHomePage(), //_home(),
      )
      // Center(
      //     child: Container(
      //   decoration: BoxDecoration(
      //     image: DecorationImage(image: AssetImage("assets/bxlogo.jpg")),
      //   ),
      // ))

      // ListView(
      //   padding: const EdgeInsets.symmetric(vertical: 8.0),
      //   children:
      //       _memberList.map((ClubMember member) => _toDoList(member)).toList(),
      // )
      ,
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              label: 'Create Account',
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
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
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
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () => _displayDialog(ClubMember()),
      //     tooltip: 'Add Item',
      //     child: Icon(Icons.add)),
    );
  }

  Widget _home() {
    return Center(
        child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/bxlogo.jpg')),
      ),
    ));
  }

  // Widget _member() {
  //   return Center(
  //     child: Text("this is member page"),
  //   );
  // }

  Future<void> _createAccountDialog() async {
    print('this is in main');
    // if (isItemUpdate) {
    //   _osisCtlr.text = member.osis;
    //   _fnameCtlr.text = member.first_name;
    //   _lnameCtlr.text = member.last_name;
    //   _emailCtlr.text = member.email;
    //   _psswdCtlr.text = member.password;
    // }
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
              title: const Text('Logout'),
              // content: Column(
              //   children: [
              //     TextField(
              //       controller: _emailCtlr,
              //       decoration: const InputDecoration(hintText: 'Enter email'),
              //     ),
              //     TextField(
              //       controller: _psswdCtlr,
              //       decoration:
              //           const InputDecoration(hintText: 'Enter password'),
              //     ),
              //   ],
              // ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // isItemUpdate = false;
                    _clearCtrl();
                  },
                ),
                TextButton(
                  child: const Text('LOGOUT?'),
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
                        : print('you got booted'));
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
    //, int itemNum) {
    var cm = ClubMember(osis, fname, lname, email, psswd);
    //itemNum: itemNum);
    print('adding data ***********');
    _addData(cm);
    // setState(() {
    //   if (isItemUpdate) {
    //     _memberList[itemNum].password = psswd;
    //     _memberList[itemNum].first_name = fname;
    //     _memberList[itemNum].last_name = lname;
    //     _memberList[itemNum].email = email;
    //     _memberList[itemNum].osis = osis;
    //     isItemUpdate = false;
    //   } else {
    //     _memberList.add(cm);
    //   }
    // });
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

  void _deleteTodoItem(ClubMember member) {
    setState(() {
      _memberList.removeAt(1); //(member.itemNum);
      // updates the itemNum value matching the index of ToDoItem in the list
      for (int i = 0; i < _memberList.length; i++) {
        //_memberList[i].itemNum = i;
      }
    });
  }

  // create the List of the to-do task in the body
  Widget _toDoList(ClubMember member) {
    return ListTile(
        leading: CircleAvatar(
          child: Text(1.toString()), //(member.itemNum + 1).toString()),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(5, 9, 0, 5),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(member.first_name), Text(member.last_name)],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 5),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(member.osis),
                  Text(member.email),
                ],
              ),
            )
          ],
        ),
        trailing: Column(
          children: [
            GestureDetector(
              onTap: () {
                isItemUpdate = true;
                _createAccountDialog();
              },
              child: Icon(Icons.edit),
            ),
            GestureDetector(
              onTap: () {
                isItemUpdate = false;
                _deleteTodoItem(member);
              },
              child: Icon(Icons.delete),
            )
          ],
        ));
  }
}
