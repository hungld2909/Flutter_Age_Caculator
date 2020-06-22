import 'package:flutter/material.dart';

void main() => runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(primarySwatch: Colors.brown),
      home: new MyHomePage(),
    ));

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  double age = 0.0;
  var selectedYear;
  Animation animation;
  AnimationController animationController;

  @override
  void initState() {
    animationController = new AnimationController(
        vsync: this, duration: new Duration(microseconds: 1000));
    animation = animationController;
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _showPicker() {
    showDatePicker(
            context: context,
            firstDate: new DateTime(1900),
            initialDate: DateTime(2018),
            lastDate: DateTime.now())
        .then((DateTime dt) {
      setState(() {
        selectedYear = dt.year;
        calculateAge();
      });
    });
  }

  void calculateAge() {
    setState(() {
      age = (2018 - selectedYear).toDouble();
      animation = new Tween<double>(begin: animation.value, end: age).animate(
          new CurvedAnimation(
              parent: animationController, curve: Curves.fastOutSlowIn));
      animation.addListener(() {
        setState(() {});
      });
    });

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Age Calculator"),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new OutlineButton(
              child: Text(selectedYear != null
                  ? selectedYear.toString()
                  : "Select your of birth"),
              borderSide: new BorderSide(color: Colors.black, width: 3.0),
              color: Colors.white,
              onPressed: _showPicker,
            ),
            new Padding(
              padding: EdgeInsets.all(20.0),
            ),
            new Text(
              "Your Age is ${animation.value.toStringAsFixed(0)}",
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            )
          ],
        ),
      ),
    );
  }
}
