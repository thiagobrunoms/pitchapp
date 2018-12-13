import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "../networking/http_requests.dart";
import 'package:flutter_rating/flutter_rating.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "view_idea.dart";

class IdeiaListPage extends StatefulWidget {
  final BuildContext context;
  final List<DocumentSnapshot> snapshot;
  final MyFirebase myFirebase = MyFirebase();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String _userId;
  List<String> localIdeasList = [];

  IdeiaListPage(this.context, this.snapshot);

  @override
  State<StatefulWidget> createState() {
    return IdeiaListPageState();
  }
}

class IdeiaListPageState extends State<IdeiaListPage> {
  Map<String, double> ideaVote = {};

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    widget._prefs.then((SharedPreferences prefs) {
      setState(() {
        widget._userId = prefs.getString("userId");
      });
    });

    for (var i = 0; i < widget.snapshot.length; i++) {
      CollectionReference collection =
          widget.snapshot[i].reference.collection("votos");

      collection.getDocuments().then((QuerySnapshot s) {
        if (s.documents.length > 0) {
          //mesmo que não exista, a lista eh nao-nula vazia
          for (var j = 0; j < s.documents.length; j++) {
            if (s.documents[j].data["userId"] == widget._userId) {
              print(
                  "Setando nota ${s.documents[j].data["nota"]} da ideia ${widget.snapshot[i].documentID}");

              // setState(() {
              //   this.ideaVote[widget.snapshot[i].documentID] =
              //       s.documents[j].data["nota"] + .0;
              // });
            }
          }
        }
      });
    }
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    print("widget updated: ");
    init();
  }

  void deleteIdea(DocumentSnapshot snapshot) {
    print("Deletando voto a ref ${snapshot.documentID}");
    print("Deletando voto a ideaName ${snapshot.data["ideaName"]}");
    setState(() {
      // widget.db.deleteIdea(snapshot.documentID);
      widget.myFirebase.deleteIdea(snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.snapshot.length,
      itemBuilder: (BuildContext context, int index) {
        DocumentSnapshot aPitch = widget.snapshot[index];

        return Card(
          child: Column(
            children: <Widget>[
              ListTile(
                key: Key(aPitch.documentID),
                title: Text(aPitch.data["ideaName"]),
                subtitle: Text(aPitch.data["description"] +
                    "\nPor: " +
                    aPitch.data["name"] +
                    "\nVotos: "), //aPitch["votes"].toString()),
                leading: Icon(Icons.lightbulb_outline),
                trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: aPitch.data["userId"] == widget._userId
                        ? () {
                            deleteIdea(aPitch);
                          }
                        : null),
                onTap: () {
                  print("Ideia selecionada: ${aPitch.data["ideaName"]}");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewIdea(
                              aPitch.data["name"],
                              aPitch.data["ideaName"],
                              aPitch.data["description"])));
                },
              ),
              StreamBuilder<QuerySnapshot>(
                stream: aPitch.reference.collection("votos").snapshots(),
                builder: (context, snapshot) {
                  double average = 0;
                  double sum = 0;
                  int position = -1;

                  if (snapshot.data != null) {
                    for (var i = 0; i < snapshot.data.documents.length; i++) {
                      var aVote = snapshot.data.documents[i].data["nota"];
                      sum = sum + aVote;

                      var userId = snapshot.data.documents[i].data["userId"];
                      if (userId == widget._userId) {
                        position = i;
                      }
                    }

                    average = sum / snapshot.data.documents.length;

                    if (average.isNaN) average = 0;

                    return Column(children: <Widget>[
                      Text("Média: ${average.toString()}"),
                      ButtonTheme.bar(
                        child: new StarRating(
                          size: 20,
                          rating: snapshot.data.documents.length > 0 &&
                                  position !=
                                      -1 //doc tem votos, mas nao desse usuario
                              ? snapshot.data.documents[position].data["nota"] +
                                  .0
                              : 0.0,
                          color: Colors.orange,
                          borderColor: Colors.grey,
                          starCount: 5,
                          onRatingChanged: (rating) {
                            setState(() {
                              if (snapshot.data.documents.length > 0 &&
                                  position != -1) {
                                //ideia tem voto e ja tem desse usuario
                                snapshot.data.documents[position].reference
                                    .updateData({"nota": rating});
                              } else {
                                //ideia ou não tem voto ou, se tem, não tem desse usuario
                                aPitch.reference.collection("votos").add(
                                    {"nota": rating, "userId": widget._userId});
                              }
                              // this.ideaVote[aPitch.documentID] = rating;
                            });
                          },
                        ),
                      )
                    ]);
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
