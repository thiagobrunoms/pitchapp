import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "../networking/http_requests.dart";
import 'package:flutter_rating/flutter_rating.dart';

class IdeiaListPage extends StatefulWidget {
  GlobalKey<ScaffoldState> _scaffoldKey;
  final BuildContext context;
  final List<DocumentSnapshot> snapshot;
  final MyFirebase myFirebase = MyFirebase();

  // List<String> localWishesList = [];
  List<String> localIdeasList = [];

  Map<String, List<ValueKey>> starsDocumentIdUniqueKeyMap = {};

  String userId = "outro@sales"; //thiago@sales

  IdeiaListPage(this._scaffoldKey, this.context, this.snapshot);

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
    print("Initializing list ideias");
    print("Obtendo collections");

    for (var i = 0; i < widget.snapshot.length; i++) {
      print("Verificando se ${widget.snapshot[i].documentID} possui votos!");
      CollectionReference collection =
          widget.snapshot[i].reference.collection("votos");

      Firestore.instance.collection("votos").snapshots();

      print(collection);
      if (collection != null) {
        print("collection não eh nulo...");
        collection.getDocuments().then((QuerySnapshot s) {
          if (s.documents != null && s.documents.length > 0) {
            for (var j = 0; j < s.documents.length; j++) {
              print(s.documents[j].documentID);
              print(s.documents[j].data["nota"]);
              print(s.documents[j].data["userId"]);

              if (s.documents[j].data["userId"] == widget.userId) {
                print(
                    "Setando nota ${s.documents[j].data["nota"]} da ideia ${widget.snapshot[i].documentID}");

                setState(() {
                  this.ideaVote[widget.snapshot[i].documentID] =
                      s.documents[j].data["nota"] + .0;
                });
              }
            }
          }
        });
      } else {
        print("collection null");
      }

      // print("referencia collection");
      // print(collection);
      // if (collection != null) {
      //   StreamBuilder<QuerySnapshot>(
      //       stream: collection.snapshots(),
      //       builder: (context, snapshot) {
      //         print("entrou builder");
      //         print(snapshot.data.documents[0].documentID);
      //       });
      //   print(widget.snapshot[i].reference.collection("votos").snapshots().);
      // }

      //TODO MOSTRAR ISSO NA APRESENTAÇÃO
    }

    // widget.db.getMyWishes().then((List<Map> myWishesFromDb) {
    //   //myWishesFromDB: {id: 1, ideaId: -LTGL-0rVGfT1IBUIyym}
    //   print("getMyWishes back: ");
    //   print(myWishesFromDb);
    //   setState(() {
    //     for (var i = 0; i < myWishesFromDb.length; i++) {
    //       print(myWishesFromDb[i]);
    //       widget.localWishesList.add(myWishesFromDb[i]["ideaId"]);
    //     }
    //   });
    // });
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    print("widget updated: ");
    init();
  }

  // void makeVote(DocumentSnapshot snapshot) {
  //   print("Adicionando voto a ref ${snapshot.documentID}");
  //   print("Adicionando voto a ideaName ${snapshot.data["ideaName"]}");

  //   String ideaId = snapshot.documentID;
  //   if (!widget.localWishesList.contains(ideaId)) {
  //     widget.myFirebase.makeVote(snapshot, 1);

  //     setState(() {
  //       widget.localWishesList.add(ideaId);
  //     });

  //     widget.db.saveAWish(ideaId);
  //     Scaffold.of(context).showSnackBar(SnackBar(
  //       content: Text("Voto realizado com sucesso!"),
  //     ));
  //   } else {
  //     widget.myFirebase.makeVote(snapshot, -1);

  //     setState(() {
  //       widget.localWishesList.remove(ideaId);
  //     });

  //     widget.db.deleteAWish(ideaId);
  //     Scaffold.of(context).showSnackBar(SnackBar(
  //       content: Text("Voto removido com sucesso!"),
  //     ));
  //   }
  // }

  void deleteIdea(DocumentSnapshot snapshot) {
    print("Deletando voto a ref ${snapshot.documentID}");
    print("Deletando voto a ideaName ${snapshot.data["ideaName"]}");
    setState(() {
      // widget.db.deleteIdea(snapshot.documentID);
      widget.myFirebase.deleteIdea(snapshot);
    });
  }

  // List<Widget> _createStars2(String documentId) {
  //   int length = widget.myVotes[documentId];

  //   List<Widget> iconButtons = [];
  //   IconButton b = null;
  //   for (var i = 0; i < 5; i++) {
  //     if (i < length) {
  //       b = IconButton(
  //         icon: Icon(Icons.star),
  //         onPressed: () {
  //           setState(() {
  //             print("Escolhendo coração de ${documentId}");
  //           });
  //         },
  //       );
  //     } else {
  //       b = IconButton(
  //         icon: Icon(Icons.star_border),
  //         onPressed: () {
  //           setState(() {
  //             print("Escolhendo coração sem borda de ${documentId}");
  //           });
  //         },
  //       );
  //     }
  //     iconButtons.add(b);
  //   }

  //   setState(() {
  //     widget.starsWidgetMap[documentId] = iconButtons;
  //   });

  //   return iconButtons;
  // }

  // List<Widget> _createStars(String documentId) {
  //   int length = widget.myVotes[documentId];

  //   List<ValueKey> keys = [];
  //   return new List<Widget>.generate(5, (int index) {
  //     ValueKey newKey = new ValueKey(documentId + "-" + index.toString());
  //     keys.add(newKey);

  //     return length != null &&
  //             length > index //se a quantidade de votos for menor que a lista
  //         ? IconButton(
  //             key: newKey,
  //             icon: Icon(Icons.star),
  //             onPressed: () {
  //               setState(() {
  //                 print("Coração de ${documentId}");
  //                 // print(widget._scaffoldKey.currentState.context.);
  //                 GlobalKey x = new GlobalKey(debugLabel: "a");
  //                 x.currentWidget.key.toString();
  //               });
  //             },
  //           )
  //         : IconButton(
  //             key: ValueKey(index + 1),
  //             icon: Icon(Icons.star_border),
  //             onPressed: () {},
  //           );
  //   });
  // }

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
                    onPressed: widget.localIdeasList.contains(aPitch.documentID)
                        ? () {
                            deleteIdea(aPitch);
                          }
                        : null),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: aPitch.reference.collection("votos").snapshots(),
                builder: (context, snapshot) {
                  double average = 0;
                  double sum = 0;
                  int position;
                  print("testadno null " + snapshot.data.toString());
                  if (snapshot.data != null) {
                    for (var i = 0; i < snapshot.data.documents.length; i++) {
                      var aVote = snapshot.data.documents[i].data["nota"];
                      sum = sum + aVote;

                      var userId = snapshot.data.documents[i].data["userId"];
                      if (userId == widget.userId) {
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
                          rating: (this.ideaVote[aPitch.documentID] != null &&
                                  snapshot.data != null &&
                                  snapshot.data.documents.length > 0)
                              ? this.ideaVote[aPitch.documentID]
                              : 0.0,
                          color: Colors.orange,
                          borderColor: Colors.grey,
                          starCount: 5,
                          onRatingChanged: (rating) {
                            setState(() {
                              // print(
                              //     "Atualizar ${snapshot.data.documents[position].data["nota"]} PARA ${rating}");
                              if (snapshot.data != null)
                                snapshot.data.documents[position].reference
                                    .updateData({"nota": rating});
                              this.ideaVote[aPitch.documentID] = rating;
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
