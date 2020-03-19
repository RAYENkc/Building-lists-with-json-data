import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme:new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Users'),
    );
  }}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  
  final String title;

  @override
  _MyHomePageState createState() => new  _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

   Future<List<User>> _getUsers() async {
     var Data = await  http.get("http://www.json-generator.com/api/json/get/cfEiIwtiWa?indent=2");

     var jsonData = json.decode(Data.body);

     List<User> users = [];
     for(var u in jsonData){
       User user = User(u["index"], u["name"], u["email"], u["about"], u["picture"] );

       users.add(user);


     }
      
      print(users.length);
      return users;

   }

  

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Container(
            child: FutureBuilder(
              future: _getUsers(),
              builder: (BuildContext context, AsyncSnapshot snapshot){

                if(snapshot.data == null){
                  return Container(
                     child: Center(
                       child: Text("Loding.."),
                     ),
                  );
                } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index){
                        
                        return ListTile(
                           leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                snapshot.data[index].picture,
                            ),
                           ),
                           title: Text(
                             snapshot.data[index].name,
                           ),
                           subtitle: Text(
                             snapshot.data[index].email,
                           ),
                           onTap: (){
                              Navigator.push(context,
                              new MaterialPageRoute(builder: (context)=>DetailPage(snapshot.data[index]) 
                              )
                              );
                           },
                        );
                    },
                );
                }

              }
              
              ),

      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final User user;
  DetailPage(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: Text(user.name),

       ),
    );
  }
}


class User{
  
  final int index;
  final String name;
  final String email;
  final String about;
  final String picture;

  User(this.index, this.name, this.email, this.about, this.picture);


}