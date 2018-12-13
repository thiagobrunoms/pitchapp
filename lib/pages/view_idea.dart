import 'package:flutter/material.dart';

class ViewIdea extends StatelessWidget {
  String name;
  String ideaName;
  String description;

  ViewIdea(this.name, this.ideaName, this.description);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aracomp - Uma Ideia!"),
      ),
      body: Card(
        child: Column(
          children: <Widget>[
            Text("Por: ${name}"),
            Text("Nome da Ideia: ${ideaName}"),
            Text("Descrição: ${description}"),
          ],
        ),
      ),
    );
  }
}
