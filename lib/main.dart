import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String stringResponse = "";

void getData() async {
  http.Response response = await http.get(Uri.parse("https://reqres.in/api/users?page=2"));
  if (response.statusCode == 200) {
    String data = response.body;
    var decodedData = jsonDecode(data);
    print(decodedData);
  } else {
    print(response.statusCode);
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // getData();
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class User{
  late final int id;
  final String first_name;
  final String last_name;
  final String email;
  final String avatar;

  User({required this.id, required this.first_name, required this.last_name, required this.email, required this.avatar});
  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      email: json['email'],
      avatar: json['avatar']
    );
  }
}

// String stringResponse = "";

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // @override
  // void initState() {
  //   super.initState();
  //   apicalls();
  //   james();
  // }
  late List<User> users;
  Future<void> apicalls() async {
    http.Response response;
    response = await http.get(Uri.parse("https://reqres.in/api/users?page=2"));
    if (response.statusCode == 200) {
      setState(() {
        stringResponse = response.body;
      });
      final jsonData = jsonDecode(response.body);
      final List<dynamic> userJsonList = jsonData['data'];
      setState(() {
        users = userJsonList.map((json) => User.fromJson(json)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    apicalls();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Api calls"),
      ),
      body: users == null
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 0.75,
        ),
        itemCount: users.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image Container (taking half of card height)
                Expanded(
                  flex: 1, // Takes half of the height
                  child: Container(
                    color: Colors.grey, // Placeholder color
                    child: users[index].avatar != null
                        ? Image.network(
                      users[index].avatar!,
                      fit: BoxFit.cover,
                    )
                        : Center(child: Text("No Image")),
                  ),
                ),
                // Text Content
                Expanded(
                  flex: 1, // Takes the other half of the height
                  child: ListTile(
                    title: Text(users[index].first_name + ' ' + users[index].last_name),
                    subtitle: Text(users[index].email),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
