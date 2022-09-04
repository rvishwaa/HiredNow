import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:image_picker/image_picker.dart';

class UserLocker extends StatefulWidget {
  late final String userId;

  UserLocker(this.userId);

  @override
  State<UserLocker> createState() => _UserLockerState();
}

class _UserLockerState extends State<UserLocker> {
  late String _image = "";
  late final TextEditingController _name;

  @override
  initState() {
    _name = TextEditingController();
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      Uint8List imagebytes = await imageFile.readAsBytes(); //convert to bytes
      String base64string =
          base64.encode(imagebytes); //convert bytes to base64 string
      setState(() {
        _image = "data:image/" +
            p.extension(imageFile.path).substring(1) +
            ";base64," +
            base64string;
        print("Haha");
      });
      print(_image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
            document: gql("""query getStorage(\$user_id: uuid!) {
  storage(where: {user_id: {_eq: \$user_id}}) {
    id
    name
    type
    value
  }
}"""),
            variables: {
              "user_id": widget.userId,
            },
            fetchPolicy: FetchPolicy.networkOnly),
        builder: (result, {refetch, fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return const Text('Loading');
          }

          List? files = result.data?['storage'];
          print(files);
          print(result);

          if (files == null) {
            return const Text('No files');
          }
          return Mutation(
              options: MutationOptions(
                document: gql(
                    """mutation addStorage(\$image: String!, \$name: String!, \$user_id: uuid!) {
  add_storage(image: \$image, name: \$name, user_id: \$user_id) {
    url
  }
}"""),
                onCompleted: (dynamic resultData1) {
                  print(resultData1);
                },
              ),
              builder: (
                addStorage,
                result1,
              ) {
                return Mutation(
                    options: MutationOptions(
                      document:
                          gql("""mutation deleteStorage(\$storage_id: uuid!) {
  delete_storage(where: {id: {_eq: \$storage_id}}) {
    affected_rows
  }
}"""),
                      onCompleted: (dynamic resultData2) {
                        print(resultData2);
                        refetch!();
                      },
                    ),
                    builder: (
                      deleteStorage,
                      result2,
                    ) {
                      final _formKey = GlobalKey<FormState>();
                      return Scaffold(
                          floatingActionButton: FloatingActionButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Stack(
                                        overflow: Overflow.visible,
                                        children: <Widget>[
                                          Positioned(
                                            right: -40.0,
                                            top: -40.0,
                                            child: InkResponse(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const CircleAvatar(
                                                child: Icon(Icons.close),
                                                backgroundColor: Colors.red,
                                              ),
                                            ),
                                          ),
                                          Form(
                                            key: _formKey,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: TextFormField(
                                                    controller: _name,
                                                    autocorrect: false,
                                                    enableSuggestions: false,
                                                    decoration:
                                                        const InputDecoration(
                                                            hintText: 'Name'),
                                                    cursorHeight: 25,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      getFromGallery();
                                                    },
                                                    child: _image == ""
                                                        ? const Text(
                                                            'Upload from gallery',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontFamily:
                                                                  'Roboto',
                                                            ),
                                                          )
                                                        : Image.memory(
                                                            base64Decode(_image
                                                                .split(',')[1]),
                                                            height: 200,
                                                            width: 150,
                                                            fit: BoxFit.fill,
                                                          ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Colors.black38,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                12), // <-- Radius
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: RaisedButton(
                                                      child: Text("Submit"),
                                                      onPressed: () {
                                                        addStorage({
                                                          "user_id":
                                                              widget.userId,
                                                          "name": _name.text,
                                                          "image": _image,
                                                        });
                                                      }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            backgroundColor: Colors.green,
                            child: const Icon(Icons.add),
                          ),
                          body: ListView.builder(
                            itemCount: files.length,
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FittedBox(
                                      child: Center(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            child: InkWell(
                                              onTap: () => showDialog(
                                                  builder: (BuildContext
                                                          context) =>
                                                      AlertDialog(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        insetPadding:
                                                            EdgeInsets.all(2),
                                                        title: Container(
                                                          decoration:
                                                              BoxDecoration(),
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: Expanded(
                                                            child:
                                                                Image.network(
                                                              files[index]
                                                                  ['value'],
                                                              fit: BoxFit
                                                                  .fitWidth,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                  context: context),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: (files[index]
                                                              ['value'] !=
                                                          null)
                                                      ? Image.network(
                                                          files[index]['value'],
                                                          height: 200,
                                                          width: 150,
                                                          fit: BoxFit.fill,
                                                        )
                                                      : FittedBox(
                                                          child: Text(
                                                          files[index]['name'],
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 30),
                                                        ))),
                                            ),
                                          ),

                                          // child: (files[index]['value'] !=
                                          //         null)
                                          //     ? Image.network(
                                          //     files[index]['value'],
                                          //     height: 200,
                                          //     width: 150,
                                          //     fit: BoxFit.fill,
                                          //       )
                                          //     : FittedBox(
                                          //         child: Text(
                                          //         files[index]['name'],
                                          //         style: const TextStyle(
                                          //             fontSize: 30),
                                          //       )),

                                          Text(files[index]['name']),
                                        ]),
                                  )),
                                  // Column(
                                  //   children: [
                                  //     Image.network(files[index]['value']),
                                  //     Text(files[index]['name']),
                                  //   ],
                                  // ),
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    tooltip: 'Remove this file',
                                    color: Colors.blue,
                                    onPressed: () {
                                      deleteStorage(
                                          {"storage_id": files[index]['id']});
                                    },
                                  ),
                                ],
                              );
                            },
                          ));
                    });
              });
        });
  }
}
