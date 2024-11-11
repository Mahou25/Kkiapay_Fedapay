import 'package:flutter/material.dart';
import 'package:kkiapay_fedapay/app_routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kkiapay Fedapay',
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Payment API Demo'),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      endDrawer: Drawer(child: ListView(
        children: [
          const DrawerHeader(decoration: BoxDecoration(
            color: Colors.deepPurple
          ),child: Text("Kkiapay and Fedapay", style: TextStyle(color: Colors.white),)),
          ListTile(
            leading: Icon(Icons.payment_sharp, size: 25,),
            title: Text("Kkiapay"),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.kkiapay);
            },
          ),
          ListTile(
            leading: Icon(Icons.payments_outlined, size: 25,),
            title: Text("Fedapay"),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.fedapay);
            },
          )
        ],
      ),),
      body: Center(
        child: Builder(builder: (context)=>ElevatedButton(
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
            child: Text("Open Drawer"))),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
