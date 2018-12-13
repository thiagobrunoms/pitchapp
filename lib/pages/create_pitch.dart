import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:shared_preferences/shared_preferences.dart";

class CreatePitchPage extends StatefulWidget {
  final firestore = Firestore.instance.collection('pitch');
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  State<StatefulWidget> createState() {
    return CreatePitchPageState();
  }
}

class CreatePitchPageState extends State<CreatePitchPage> {
  String name;
  String ideiaName;
  String ideiaDescription;
  String _userId;

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ideiaNameController = TextEditingController();
  final TextEditingController _ideiaDescriptionController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    widget._prefs.then((SharedPreferences prefs) {
      print("uuid do usuario: ${prefs.getString("userId")}");
      setState(() {
        _userId = prefs.getString("userId");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10.0),
        child: Form(
            key: _keyForm,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: "Nome Completo",
                      hintText: "Nome e Sobrenome",
                      icon: Icon(Icons.account_circle)),
                  validator: (String value) {
                    if (value.isEmpty)
                      return "Nome completo deve ser preenchido!";
                  },
                  onSaved: (String value) {
                    name = value;
                  },
                ),
                TextFormField(
                  controller: _ideiaNameController,
                  decoration: InputDecoration(
                      labelText: "Nome do Ideia",
                      icon: Icon(Icons.lightbulb_outline)),
                  validator: (String value) {
                    if (value.isEmpty) return "A ideia deve ter um nome";
                  },
                  onSaved: (String value) {
                    ideiaName = value;
                  },
                ),
                TextFormField(
                  controller: _ideiaDescriptionController,
                  decoration: InputDecoration(
                    labelText: "Descrição da Ideia",
                    icon: Icon(Icons.description),
                  ),
                  validator: (String value) {
                    if (value.isEmpty) return "A ideia deve ter uma descrição";
                  },
                  onSaved: (String value) {
                    ideiaDescription = value;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    child: Text("Enviar Ideia"),
                    onPressed: () {
                      if (!_keyForm.currentState.validate()) return;
                      _keyForm.currentState.save();

                      print(
                          "Enviando projeto: ${name}, nome da ideia: ${ideiaName}, descrição: ${ideiaDescription}, com userId ${_userId} usando firestore");

                      Map<String, dynamic> newPitch = {
                        "name": name,
                        "ideaName": ideiaName,
                        "description": ideiaDescription,
                        "userId": _userId
                      };

                      Future<DocumentReference> reference =
                          widget.firestore.add(newPitch);
                      reference.then((DocumentReference reference) {
                        print("Retornou de nova firesotore");
                        print(reference.documentID);

                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Ideia para pitch cadastrado com sucesso!")));
                      });

                      _nameController.clear();
                      _ideiaNameController.clear();
                      _ideiaDescriptionController.clear();
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)))
              ],
            )));
  }
}
