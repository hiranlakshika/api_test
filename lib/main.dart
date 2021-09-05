import 'package:api_test/model/product.dart';
import 'package:api_test/service/product_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ProductService _service = ProductService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: futureBuilderWidget(),
    );
  }

  Future<Widget> getData() async {
    setState(() {
      _isLoading = true;
    });
    Product? product = await _service.getProducts();
    if (product != null) {
      setState(() {
        _isLoading = false;
      });
      return ListView.builder(
          itemCount: product.data!.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 2.0,
              child: Column(
                children: [
                  Text(product.data![index].name ?? ''),
                  Text(product.data![index].color ?? ''),
                ],
              ),
            );
          });
    } else {
      setState(() {
        _isLoading = false;
      });
      return Center(child: Text('No data'));
    }
  }

  Widget futureBuilderWidget(){
    return FutureBuilder<Product?>(
      future: _service.getProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2.0,
                    child: Column(
                      children: [
                        Text(snapshot.data!.data![index].name ?? ''),
                        Text(snapshot.data!.data![index].color ?? ''),
                      ],
                    ),
                  );
                });
          } else {
            return Center(child: Text('No data'));
          }
        }
      },
    );
  }
}
