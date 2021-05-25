import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String bookTable = "bookTable";
final String idColumn = "idColumn";
final String titleColumn = "titleColumn";
final String descriptionColumn = "descriptionColumn";
final String pageNumberColumn = "pageNumberColumn";
final String imgColumn = "imgColumn";

class BookUtils {
  static final BookUtils _instance = BookUtils.internal();

  factory BookUtils() => _instance;

  BookUtils.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "booksnew.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          'CREATE TABLE $bookTable ($idColumn INTEGER PRIMARY KEY, $titleColumn TEXT,'
          '$pageNumberColumn TEXT, $imgColumn TEXT)');
    });
  }

  Future<Book> saveBook(Book book) async {
    Database _dataBase = await db;
    book.id = await _dataBase.insert(bookTable, book.toMap());
    return book;
  }

  Future<Book> getBook(int id) async {
    Database _dataBase = await db;
    List listBook = await _dataBase.query(bookTable,
        columns: [
          idColumn,
          titleColumn,
          descriptionColumn,
          pageNumberColumn,
          imgColumn
        ],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (listBook.length > 0) {
      return Book.fromMap(listBook.first);
    }
    return null;
  }

  Future<int> deleteBook(int id) async {
    Database _dataBase = await db;
    return await _dataBase
        .delete(bookTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateBook(Book book) async {
    Database _database = await db;
    return await _database.update(bookTable, book.toMap(),
        where: "$idColumn", whereArgs: [book.id]);
  }

  Future<List> getAllBooks() async {
    Database _database = await db;
    List listMap = await _database.rawQuery("SELECT * FROM $bookTable");
    List<Book> listBook = [];
    for (Map map in listMap) {
      listBook.add(Book.fromMap(map));
    }
    return listBook;
  }

  Future<int> getNumber() async {
    Database _database = await db;
    return Sqflite.firstIntValue(
        await _database.rawQuery("SELECT COUNT(*) FROM $bookTable"));
  }
}

class Book {
  int id;
  String title;
  String description;
  String pageNumber;
  String img;

  Book();

  Book.fromMap(Map map) {
    id = map[idColumn];
    title = map[titleColumn];
    description = map[descriptionColumn];
    pageNumber = map[pageNumberColumn];
    img = map[imgColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      titleColumn: title,
      descriptionColumn: description,
      pageNumberColumn: pageNumber,
      imgColumn: img,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }
}
