import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

List listResponse = [];
class _HomeScreenState extends State<HomeScreen> {
  
  bool isLoading = false;
  bool cashedData = false;
  late Box homeBox;

  Future apiCall() async{
    homeBox = Hive.box('Home');
    try{
      final http.Response response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      if(response.statusCode == 200){
        setState(() {
          listResponse = jsonDecode(response.body);
          homeBox.putAll({'data' : listResponse});
          isLoading = false;
          cashedData = false;
        });
      }
    }catch(error){
      setState(() {
        listResponse =  homeBox.get('data');
      });
    }

  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = true;
      cashedData = true;
    });
    apiCall();
    Timer(const Duration(seconds: 5), () {
      setState(() {
        isLoading = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading? const CircularProgressIndicator(color: Colors.brown,strokeWidth: 3):
          ListView.builder(
            itemCount: listResponse.length,
              itemBuilder:(context,index){
                return Container(
                  padding:const EdgeInsets.all(20.0),
                  color: cashedData?Colors.deepOrange.withOpacity(.5):Colors.green.withOpacity(.5),
                  margin: const EdgeInsets.all(20.0),
                  child: Text(listResponse[index]['id'].toString(),
                    style:const TextStyle(
                    color: Colors.white,
                      fontSize: 20
                  ),),
                );
              }
          )
    );
  }
}
