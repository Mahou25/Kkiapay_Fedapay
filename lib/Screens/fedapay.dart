import 'package:flutter/material.dart';

class Fedapay extends StatelessWidget {
  const Fedapay({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fedapay", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,
      ),

      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomRight:Radius.circular(20) )
          ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.ac_unit_rounded, color: Colors.white,),),),
      ),
    );
  }
}
