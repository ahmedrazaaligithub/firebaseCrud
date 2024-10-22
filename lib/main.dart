import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_connect/allUsers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main ()async {

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
String get_name='';
String get_password='';
String get_email='';
String get_age='';

  void saveCredentials() {
try {
          FirebaseFirestore db =  FirebaseFirestore.instance;
        db.collection('Users').add({
          'name': get_name,
          'email': get_email,
          'Password': get_password,
          'age':get_age
        }).whenComplete(() {
          print("Data Save Successfully");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data saved Succesfully')));
        });
      } catch (e) {
        print(e);
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   // TRY THIS: Try changing the color here to a specific color (to
        //   // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        //   // change color while the other colors stay the same.
        //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        //   // Here we take the value from the MyHomePage object that was created by
        //   // the App.build method, and use it to set our appbar title.
        //   title: Text(widget.title),
        // ),
        body: Center(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'your name',
                label:Text( 'your name'),
                border: OutlineInputBorder(),
                // suffixIcon: Icons.person,
                
              ),
              onChanged: (text)=> get_name= text,
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'your email',
                label:Text( 'your email'),
                border: OutlineInputBorder(),
                // suffixIcon: Icons.mail,
              ),
              onChanged: (text)=> get_email= text,

            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'your age',
                label: Text('your age'),
                border: OutlineInputBorder(),
                // suffixIcon: Icons.cake,
              ),
              onChanged: (text)=> get_age= text,
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'your password',
                label: Text('your password'),
                border: OutlineInputBorder(),
                // suffixIcon: Icons.remove_red_eye,
              ),
              onChanged: (text)=> get_password= text,
            ),
          ),
          Container(
            child: OutlinedButton(onPressed: saveCredentials, child: Text("Submit")),
          )
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    ),
    floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (builder) => AllUsers()));
      },
      child: Icon(Icons.chevron_right_outlined),      
      ),
    );
  }
}
