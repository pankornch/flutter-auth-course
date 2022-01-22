import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() {
  runApp(MyApp());
}

final url = "http://localhost:5050";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Book {
  late int id;
  late String title;
  late String author_name;

  Book({required this.id, required this.title, required this.author_name});

  Book.fromJSON(Map<String, dynamic> json) {
    this.id = json["id"];
    this.title = json["title"];
    this.author_name = json["author_name"];
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Book> books = [];
  final titleController = TextEditingController();
  final authorNameController = TextEditingController();
  late int editById = 0;

  fetchBooks() async {
    setState(() {
      books.clear();
    });

    final res = await http.get(
      Uri.parse("$url/books"),
      headers: {
        "Accept": "application/json",
        "Access-Control_Allow_Origin": "*"
      },
    );

    final data = convert.jsonDecode(res.body) as List<dynamic>;
    for (var book in data) {
      final _book = Book.fromJSON(book as Map<String, dynamic>);
      setState(() {
        books.add(_book);
      });
    }
  }

  createBook() async {
    await http.post(
      Uri.parse("$url/create_book"),
      headers: {
        'content-type': 'application/json',
      },
      body: convert.jsonEncode({
        "title": titleController.text,
        "author_name": authorNameController.text,
      }),
    );

    titleController.text = "";
    authorNameController.text = "";

    fetchBooks();
  }

  @override
  void initState() {
    fetchBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Management"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Book title",
                      ),
                    ),
                  ),
                  SizedBox(width: 24),
                  Flexible(
                    child: TextField(
                      controller: authorNameController,
                      decoration: InputDecoration(
                        labelText: "Author name",
                      ),
                    ),
                  ),
                  SizedBox(width: 24),
                  IconButton(
                    onPressed: createBook,
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Text(
                "Books",
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              for (var book in books)
                BookCard(
                  title: titleController.text,
                  author_name: authorNameController.text,
                  book: book,
                  refetch: fetchBooks,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookCard extends StatefulWidget {
  BookCard({
    Key? key,
    required this.title,
    required this.author_name,
    required this.book,
    required this.refetch,
  }) : super(key: key);

  late Function refetch;
  late String title;
  late String author_name;
  late Book book;

  @override
  _BookCardState createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  bool isEdit = false;
  final editTitleController = TextEditingController();
  final editAuthorNameController = TextEditingController();

  deleteBook(int id) async {
    await http.delete(Uri.parse("$url/delete_book/$id"));

    widget.refetch();
  }

  updateBook(String title, String author_name) async {
    await http.patch(
      Uri.parse("$url/update_book/${widget.book.id}"),
      headers: {
        'content-type': 'application/json',
      },
      body: convert.jsonEncode({
        "title": title,
        "author_name": author_name,
      }),
    );
    widget.refetch();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        margin: EdgeInsets.symmetric(vertical: 12),
        child: isEdit
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: editTitleController,
                  ),
                  TextField(
                    controller: editAuthorNameController,
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.book.title,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(widget.book.author_name),
                ],
              ),
      ),
      trailing: Wrap(
        children: [
          IconButton(
              onPressed: () {
                setState(() {
                  isEdit = !isEdit;
                  if (isEdit) {
                    editTitleController.text = widget.book.title;
                    editAuthorNameController.text = widget.book.author_name;
                  } else {
                    updateBook(
                      editTitleController.text,
                      editAuthorNameController.text,
                    );
                  }
                });
              },
              icon: Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                deleteBook(widget.book.id);
              },
              icon: Icon(Icons.delete)),
        ],
      ),
    );
  }
}
