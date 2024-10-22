import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AllUsers());
}

class AllUsers extends StatelessWidget {
  const AllUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'All users',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'All users'),
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
  FirebaseFirestore db = FirebaseFirestore.instance;
 void updateUser (String i ,String n,String e){
try {
  db.collection('Users').doc(i).update({
    'name':n,
    'email':e
  });
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("data update successfully")));  
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
}
 }

  void updateDialogBox(BuildContext con, String id , String name, String email){
  print(db.collection("Users"));
  TextEditingController name_con = TextEditingController(text: name);
  TextEditingController email_con = TextEditingController(text: email);

  showDialog(context: con, 
  builder: (builder)=>AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: 200),
          margin: EdgeInsets.all(10),
          child: TextField(
            controller: name_con,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: name,
              suffixIcon: Icon(Icons.person)
            ),
          ),
        ),
         Container(
          constraints: BoxConstraints(maxWidth: 200),
          margin: EdgeInsets.all(10),
          child: TextField(
            controller: email_con,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: email,
              suffixIcon: Icon(Icons.email)
            ),
          ),
        ),

       
      ],
    ),


    actions: [
      IconButton(onPressed: (){
          updateUser(id, name_con.text, email_con.text);
          Navigator.of(con,rootNavigator: true).pop();

      }, icon: Icon(Icons.edit)),
      IconButton(onPressed: (){
        Navigator.of(con,rootNavigator: true).pop();
      }, icon: Icon(Icons.close)),

    ],
  ));

}
void db_delete(String i)
{
  try {
    db.collection("Users").doc(i).delete();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Record Deleted")));

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    
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
       body:StreamBuilder<QuerySnapshot>(
        stream: db.collection("Users").snapshots(), 
        builder: (context, snapshot){
          var fetchdata= snapshot.data!.docs;
          if (snapshot.data!.docs.isEmpty || !snapshot.hasData) {
            return Center(child:Text("No Data Found"));
          }
          if (snapshot.connectionState ==  ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: fetchdata.length,
            itemBuilder: (context,index){
              String u_id = fetchdata[index].id;
              var person_data = fetchdata[index].data() as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text(person_data["name"]?? "Not Found"),
                  subtitle: Text(person_data["email"] ?? "Not Found"),
                  trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: (){
                        showDialog(context: context, 
                        builder: (builder)=>AlertDialog(
                          title: Text("Delete"),
                          content: Text("Are you Sure you want to delete?"),
                          actions: [
                            IconButton(onPressed: (){
                                db_delete(u_id);
                                Navigator.of(context,rootNavigator: true).pop();

                            }, icon:Icon(Icons.delete) ),
                             IconButton(onPressed: (){
                                Navigator.of(context,rootNavigator: true).pop();
                            }, icon:Icon(Icons.close) )
                          ],
                        ));

                      }, icon: Icon(Icons.delete, color:Colors.red, size: 12,)),
                      IconButton(onPressed: (){
                        updateDialogBox(context, u_id, person_data["name"], person_data["email"]);
                      }, icon: Icon(Icons.edit, size:12)),

                    ],
                  ),
                ),
              );
            });
        }),
      floatingActionButton: FloatingActionButton
      (onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (builder)=>MyApp()));
      },
      child: Icon(Icons.add),), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}