import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "./create_pitch.dart";
import "./list_ideias.dart";

class MyHomePage extends StatelessWidget {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('pitch').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        // return _buildList(context, snapshot.data.documents);
        return TabBarView(children: <Widget>[
          CreatePitchPage(),
          IdeiaListPage(_scaffoldKey, context, snapshot.data.documents)
        ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Aracomp - Pitch de Ideias"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.create),
                text: "Cadastrar",
              ),
              Tab(
                icon: Icon(Icons.list),
                text: "Listar Ideias",
              )
            ],
          ),
        ),
        body: _buildBody(context),
      ),
    );
  }
}
