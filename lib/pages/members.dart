import 'package:flutter/material.dart';
import 'dart:async';
import 'package:clubapp/clubdb.dart';
import 'package:clubapp/main.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({super.key});

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  Future<void> _getData() async {
    List<Map<String, Map<String, dynamic>>> result =
        await connection!.mappedResultsQuery("SELECT * FROM club");
    if (result.length > 1) {
      for (var c in result) {
        var x = c.values.toList();
        print(x);
      }
    }
  }

  Future<void> _addData(ClubMember cm) async {
    await connection!.query(
        "insert into members (osis, first_name, last_name, email, password)  values('${cm.osis}', '${cm.first_name}', '${cm.last_name}', '${cm.email}', '${cm.password}')");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          _getData();
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
