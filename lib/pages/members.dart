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
  List<Club> _clubList = ClubData().getClubData();
  @override
  void initState() {
    super.initState();
  }

  Future<void> _addData(ClubMember cm) async {
    await connection!.query(
        "insert into members (osis, first_name, last_name, email, password)  values('${cm.osis}', '${cm.first_name}', '${cm.last_name}', '${cm.email}', '${cm.password}')");
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      children: _clubList.map((Club c) => _displayClub(c)).toList(),
    );
  }

  Widget _displayClub(Club c) {
    return ListTile(
        leading: CircleAvatar(
          child: Text((c.name[0]).toString()),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(c.name)],
              ),
            ),
          ],
        ),
        trailing: Column(
          children: [],
        ));
  }
}
