import 'package:flutter/material.dart';
import 'package:My_Book/utils/book.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class BookPage extends StatefulWidget {
  final Book book;

  BookPage({this.book});

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  Book _editedBook;
  BookUtils utils = BookUtils();
  final _textFocus = FocusNode();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _pageNumberController = TextEditingController();
  bool _edited = false;

  @override
  void initState() {
    super.initState();
    if (widget.book == null) {
      _editedBook = Book();
    } else {
      _editedBook = widget.book;
      _titleController.text = _editedBook.title;
      _descriptionController.text = _editedBook.description;
      _pageNumberController.text = _editedBook.pageNumber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text(
              _editedBook.title != null ? _editedBook.title : "Meu Novo Livro"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber,
          child: Icon(Icons.save),
          onPressed: () {
            if (_editedBook.title != null && _editedBook.title.isNotEmpty) {
              Navigator.pop(context, _editedBook);
            } else {
              FocusScope.of(context).requestFocus(_textFocus);
            }
          },
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () {
                  ImagePicker.pickImage(source: ImageSource.gallery)
                      .then((value) {
                    if (value == null) return;
                    setState(() {
                      _editedBook.img = value.path;
                    });
                    _edited = true;
                  });
                },
                child: Container(
                  width: 150,
                  height: 110,
                  decoration: BoxDecoration(
                      color: Colors.white30,
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                          image: _editedBook.img != null
                              ? FileImage(File(_editedBook.img))
                              : AssetImage("images/book.jpg"))),
                ),
              ),
              TextField(
                focusNode: _textFocus,
                controller: _titleController,
                decoration: InputDecoration(labelText: "Título"),
                onChanged: (text) {
                  _edited = true;
                  setState(() {
                    _editedBook.title = text;
                  });
                },
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Descrição"),
                onChanged: (text) {
                  _edited = true;
                  _editedBook.description = text;
                },
                keyboardType: TextInputType.multiline,
              ),
              TextField(
                controller: _pageNumberController,
                decoration: InputDecoration(labelText: "Numero de Páginas"),
                onChanged: (text) {
                  _edited = true;
                  _editedBook.pageNumber = text;
                },
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_edited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.amber,
              buttonPadding: EdgeInsets.all(10),
              title: Text(
                "Descartar Alterações?",
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                "Se sair as alterações serão perdidas",
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                FlatButton(
                  minWidth: 100,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.check_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                FlatButton(
                  minWidth: 100,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.cancel_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            );
          });
    }
    return Future.value(true);
  }
}
