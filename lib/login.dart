// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:postgres/postgres.dart';

// class login extends StatelessWidget {
//   var connection = PostgreSQLConnection(
//     "10.0.2.2",
//     5432,
//     "clubdb",
//     username: "postgres",
//     password: "1Mero3Postgres7",
//   );

//   Future<void> initDb() async {
//     try {
//       print('**connecting***');
//       await connection.open();
//       print('**connectedt***');
//       debugPrint("Database Connected!");
//     } catch (e) {
//       debugPrint("Error: $e");
//     }

//     List<Map<String, Map<String, dynamic>>> result =
//         await connection.mappedResultsQuery("SELECT * FROM club");
//     if (result.length > 1) {
//       for (var c in result) {
//         var x = c.values.toList();
//         print(x);
//       }
//     }
//   }

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {}
// }
