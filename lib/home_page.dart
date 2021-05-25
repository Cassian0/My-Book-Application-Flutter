import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:My_Book/book_page.dart';
import 'package:My_Book/utils/book.dart';
import 'package:My_Book/utils/utils.dart';
import 'dart:io';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  BookUtils utils = BookUtils();
  List<Book> _books = [];

  void iniState() {
    super.initState();
    setState(() {
      _getAllBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Meus Livros"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBook();
        },
        backgroundColor: Colors.amber,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: _books.length,
        itemBuilder: (context, index) {
          return _bookCard(context, index);
        },
      ),
    );
  }

  void _getAllBooks() {
    utils.getAllBooks().then((value) => {
          setState(() {
            _books = value;
          })
        });
  }

  Widget _bookCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        _showOptions(context, index);
      },
      child: Card(
        child: Row(
          children: [
            Container(
              height: 60,
              width: 80,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    image: _books[index].img != null
                        ? FileImage(File(_books[index].img))
                        : AssetImage("images/book.jpg"),
                  )),
            ),
            Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextDefault(_books[index].title),
                    TextDefault(_books[index].description),
                    TextDefault(_books[index].pageNumber),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  void _showBook({Book book}) async {
    final recBook = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => BookPage(book: book)));
    if (recBook != null) {
      if (book != null) {
        await utils.updateBook(recBook);
      } else {
        await utils.saveBook(recBook);
      }
    }
    _getAllBooks();
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showBook(book: _books[index]);
                        },
                        child: Text(
                          "Editar",
                          style: TextStyle(color: Colors.amber, fontSize: 20),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        onPressed: () {
                          utils.deleteBook(_books[index].id);
                          setState(() {
                            _getAllBooks();
                          });
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Deletar",
                          style: TextStyle(color: Colors.amber, fontSize: 20),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
  }
}
