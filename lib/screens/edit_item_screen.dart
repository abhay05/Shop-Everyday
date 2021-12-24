import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../providers/product.dart';
import '../providers/product_provider.dart';
import 'package:provider/provider.dart';

class EditItemScreen extends StatefulWidget {
  static const route = '/edit-product';
  @override
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  var _imageController = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _form = GlobalKey<FormState>(); // global key hook into state of widgets
  bool _init = true;
  bool _isLoading = false;
  Product _editProduct = Product(
      id: null,
      description: '',
      title: '',
      imageUrl: '',
      price: null,
      isFavorite: null);

  var _formValues = {
    'id': '',
    'description': '',
    'title': '',
    'imageUrl': '',
    'price': '',
    'isFavorite': false,
  };

  @override
  void initState() {
    _imageFocusNode.addListener(fetchImage);

    super.initState();
  }

  void didChangeDependencies() {
    if (_init) {
      // run only once during initial build, so that form value dont get undo due to
      //rebuild
      String id = ModalRoute.of(context).settings.arguments as String;
      if (id != null) {
        Product product =
            Provider.of<Products>(context, listen: false).getItemById(id);
        _editProduct = product;
        _formValues['id'] = product.id;
        _formValues['description'] = product.description;
        _formValues['title'] = product.title;
        _formValues['imageUrl'] = product.imageUrl;
        _formValues['price'] = product.price.toString();
        _formValues['isFavorite'] = product.isFavorite;
        _imageController.text = product.imageUrl;
      }
    }
    _init = false;
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageFocusNode.removeListener(fetchImage); // to dispose listener
    _imageFocusNode.dispose();
    _imageController.dispose();

    super.dispose();
  }

  void fetchImage() {
    if (!_imageFocusNode.hasFocus) {
      if (!_imageController.text.isEmpty) {
        String val = _imageController.text;
        var urlPattern =
            r"https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)";
        bool match = RegExp(urlPattern, caseSensitive: false)
            .hasMatch(val); //.firstMatch(val);
        if (!match) return;
        setState(() {});
      }
      // to trigger rebuild and put image on the screen , which
      //otherwise wouldn't happen if focus was shifted from imageUrlBox without pressing submit
    } else {
      print("Have focus");
    }
  }

  Future<void> _saveForm() async {
    //to use await use async
    bool validated = _form.currentState.validate();
    if (!validated) {
      return;
    }
    _form.currentState.save();
    //Product
    if (_editProduct.id == null) {
      _editProduct = Product(
        description: _formValues['description'],
        id: DateTime.now().toString(),
        price: double.parse(_formValues['price']),
        imageUrl: _formValues['imageUrl'],
        title: _formValues['title'],
        isFavorite: _formValues['isFavorite'],
      );

      try {
        setState(() {
          _isLoading = true;
        });
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editProduct);
      } catch (err) {
        // catchError if after "then" block , then it catches error from both
        // "then" block and orignal block
        print(err.toString());
        await showDialog<Null>(
            //return added so that next "then" block waits for user reply before executing
            // showDialog also returns future and next catch or then block can take it as input.
            context: context,
            builder: (BuildContext ctx) {
              return AlertDialog(
                content: Container(child: Text("Something is wrong")),
                actions: [
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  ),
                ],
              );
            });
      }
      // finally {
      //   // if error occurs will run after catch block
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      //}
    } else {
      _editProduct = Product(
        description: _formValues['description'],
        id: _formValues['id'],
        price: double.parse(_formValues['price']),
        imageUrl: _formValues['imageUrl'],
        title: _formValues['title'],
        isFavorite: _formValues['isFavorite'],
      );

      setState(() {
        _isLoading = true;
      });
      print("edit screen title " + _editProduct.title);
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editProduct);
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit the product"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _form,
                child: ListView(
                  // For longer forms use column with scrollable widget instead of ListView
                  // since when you scroll and input widgets go out of screen they will get deleted after
                  //certain threshold and input data will be lost.(ListView dynamically deletes widgets which
                  //are not the screen)
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Title",
                      ),
                      textInputAction: TextInputAction
                          .next, // will show next button in bottom left corner of the keyboard
                      initialValue: _formValues['title'],
                      onFieldSubmitted: (val) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (val) {
                        if (val.isEmpty) {
                          return "The Title is empty";
                        }
                        return null; // no error
                      },
                      onSaved: (val) {
                        _formValues['title'] = val;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Price"),
                      focusNode: _priceFocusNode,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      initialValue: _formValues['price'],
                      onFieldSubmitted: (val) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (val) {
                        _formValues['price'] = val;
                      },
                      validator: (val) {
                        if (val.isEmpty) {
                          return "The price is empty";
                        }
                        if (double.tryParse(val) == null) {
                          return "Enter a number";
                        }
                        if (double.parse(val) <= 0) {
                          return "Price should me more than zero";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Description"),
                      maxLines: 5,
                      focusNode: _descriptionFocusNode,
                      initialValue: _formValues['description'],
                      onSaved: (val) {
                        _formValues['description'] = val;
                      },
                      //keyboardType: TextInputType.multiline,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Please enter a description";
                        }
                        if (val.length < 10) {
                          return "Description should be longer than 10 characters";
                        }
                        return null;
                      },
                    ),
                    Row(children: [
                      Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 10, right: 5),
                          decoration:
                              BoxDecoration(border: Border.all(width: 1)),
                          child: FittedBox(
                            child: _imageController.text.isEmpty
                                ? Text("Upload an image")
                                : Image.network(_imageController.text),
                            //fit: BoxFit.cover,
                            //clipBehavior: Clip.hardEdge,
                            fit: BoxFit.contain,
                          )),
                      Expanded(
                        child: TextFormField(
                          // TextFormField takes as much space as possible
                          // so enclose it in a expanded widget
                          controller: _imageController,
                          decoration: InputDecoration(labelText: "Image url"),
                          textInputAction: TextInputAction.done,
                          focusNode: _imageFocusNode,
                          keyboardType: TextInputType.url,

                          onEditingComplete: () {
                            setState(() {
                              print("editing complete");
                            });
                          },
                          onFieldSubmitted: (val) {
                            _saveForm();
                          },
                          onSaved: (val) {
                            _formValues['imageUrl'] = val;
                          },
                          validator: (val) {
                            if (val.isEmpty) {
                              return "Please enter a url";
                            }
                            var urlPattern =
                                r"https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)";
                            bool match =
                                RegExp(urlPattern, caseSensitive: false)
                                    .hasMatch(val); //.firstMatch(val);
                            if (!match) {
                              return "Enter a valid url";
                            }
                            return null;
                          },
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
    );
  }
}
