import 'dart:async';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

import 'clubdb.dart';

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
  final TextEditingController _fnameCtlr = TextEditingController();
  final TextEditingController _lnameCtlr = TextEditingController();
  final TextEditingController _emailCtlr = TextEditingController();
  final TextEditingController _osisCtlr = TextEditingController();

  bool isItemUpdate = false;
  bool _isLoggedin = false;
  int _selectedIndex = 0;

  void _onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  var connection = PostgreSQLConnection(
    "10.0.2.2",
    5432,
    "clubdb",
    username: "postgres",
    password: "app7post",
  );

  Future<void> initDb() async {
    try {
      print('**connecting***');
      await connection.open();
      print('**connectedt***');
      debugPrint("Database Connected!");
    } catch (e) {
      debugPrint("Error: $e");
    }

    List<Map<String, Map<String, dynamic>>> result =
        await connection.mappedResultsQuery("SELECT * FROM club");
    if (result.length > 1) {
      for (var c in result) {
        var x = c.values.toList();
        print(x);
      }
    }
  }

  String pp() {
    var s = (4 > 3) ? 'hello' : 'bye';
    return (s);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('bxlogo.jpg')),
        ),
        child: Center(
            child: Text(
          '\n\nJoin\nClub',
          style: TextStyle(
              fontSize: 70,
              color: Color.fromARGB(255, 194, 218, 60),
              fontWeight: FontWeight.bold),
        )),
      ))

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
            _isLoggedin
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
                _createAccountDialog(ClubMember());
                break;
              case 1:
                _isLoggedin ? " " : _login(ClubMember());
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

  Future<void> _createAccountDialog(ClubMember member) async {
    if (isItemUpdate) {
      _fnameCtlr.text = member.first_name;
      _lnameCtlr.text = member.last_name;
      _emailCtlr.text = member.email;
      _osisCtlr.text = member.osis;
    }
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
                    controller: _osisCtlr,
                    decoration:
                        const InputDecoration(hintText: 'Enter osis number'),
                  ),
                  // TextField(
                  //   controller: _dateCtlr,
                  //   decoration: const InputDecoration(
                  //       icon: Icon(Icons.calendar_today),
                  //       labelText: "Pick a Date"),
                  //   readOnly: true,
                  //   onTap: () async {
                  //     DateTime? pickedDate = await showDatePicker(
                  //         context: context,
                  //         initialDate: DateTime.now(),
                  //         firstDate: DateTime(1950),
                  //         lastDate: DateTime(2300));
                  //     if (pickedDate != null) {
                  //       String strDate =
                  //           DateFormat('yyyy-MM-dd').format(pickedDate);
                  //       setState(() {
                  //         _dateCtlr.text = strDate;
                  //       });
                  //     }
                  //   },
                  // ),
                  // TextField(
                  //   controller: _timeCtlr,
                  //   decoration: const InputDecoration(
                  //       icon: Icon(Icons.calendar_today),
                  //       labelText: "Pick a Time"),
                  //   readOnly: true,
                  //   onTap: () async {
                  //     TimeOfDay? pickedTime = await showTimePicker(
                  //         context: context, initialTime: TimeOfDay.now());

                  //     if (pickedTime != null) {
                  //       setState(() {
                  //         _timeCtlr.text =
                  //             "${pickedTime.hour}:${pickedTime.minute}";
                  //       });
                  //     }
                  //   },
                  // ),
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
                    int index =
                        isItemUpdate ? member.itemNum : _memberList.length;

                    _createAccount(_fnameCtlr.text, _lnameCtlr.text,
                        _emailCtlr.text, _osisCtlr.text, index);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _login(ClubMember member) async {
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
                    controller: _fnameCtlr,
                    decoration: const InputDecoration(hintText: 'Enter email'),
                  ),
                  TextField(
                    controller: _lnameCtlr,
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
                    int index =
                        isItemUpdate ? member.itemNum : _memberList.length;
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _createAccount(
      String fname, String lname, String email, String osis, int itemNum) {
    setState(() {
      if (isItemUpdate) {
        _memberList[itemNum].first_name = fname;
        _memberList[itemNum].last_name = lname;
        _memberList[itemNum].email = email;
        _memberList[itemNum].osis = osis;
        isItemUpdate = false;
      } else {
        _memberList.add(ClubMember(
            first_name: fname,
            last_name: lname,
            osis: osis,
            email: email,
            itemNum: itemNum));
      }
    });
    _clearCtrl();
  }

  // clears the TextField text values
  void _clearCtrl() {
    _fnameCtlr.clear();
    _lnameCtlr.clear();
    _osisCtlr.clear();
    _emailCtlr.clear();
  }

  void _deleteTodoItem(ClubMember member) {
    setState(() {
      _memberList.removeAt(member.itemNum);
      // updates the itemNum value matching the index of ToDoItem in the list
      for (int i = 0; i < _memberList.length; i++) {
        _memberList[i].itemNum = i;
      }
    });
  }

  // create the List of the to-do task in the body
  Widget _toDoList(ClubMember member) {
    return ListTile(
        leading: CircleAvatar(
          child: Text((member.itemNum + 1).toString()),
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
                _createAccountDialog(member);
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
