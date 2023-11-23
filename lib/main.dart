// Import necessary packages and files
import 'package:flutter/material.dart';
import 'pages/getColorPage.dart';
import 'pages/getNamePage.dart';

// Entry point for the app
void main() {
  runApp(const MyApp());
}

// Main app widget
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Build the app's UI
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App title and theme configuration
      title: 'SlutOpgaveHentNavnOgFarve',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Main page widget
      home: const MyHomePage(title: 'SlutOpgaveHentNavnOgFarve'),
    );
  }
}

// Main page widget
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// State class for the main page
class _MyHomePageState extends State<MyHomePage> {
  //region Initializations for various variables

  // Text to display selected name
  String textFromNamePage = 'Here comes the name';

  // Enum representing choices (e.g., Mother, Father)
  Choice? choice;

  // Selected name
  String? name;

  // RGB components for color
  String myRed = 'ff';
  String myGreen = 'ff';
  String myBlue = 'ff';

  // Color object based on RGB components
  Color? color = const Color(0xffffffff);
  //endregion

  //region Build the UI for the main page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with title
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Title
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Get Ones Name and Color',
                style: TextStyle(color: Colors.black, fontSize: 26.0),
              ),
            ),
            const SizedBox(height: 50),
            // Button to get name
            ElevatedButton(
              onPressed: () {
                _awaitReturnValueFromNamePage(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                minimumSize: const Size(150, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                  'Get ones name - API', style: TextStyle(fontSize: 16.0)),
            ),
            const SizedBox(height: 20),
            // Display selected name
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: 50,
              color: color,
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    textFromNamePage,
                    style: const TextStyle(color: Colors.black, fontSize: 22.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Button to get color
            ElevatedButton(
              onPressed: () {
                _awaitReturnValueFromColorPage(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                minimumSize: const Size(150, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                  'Get ones color', style: TextStyle(fontSize: 16.0)),
            ),
          ],
        ),
      ),
    );
  }
  //endregion

  //region Method to get name from NamePage
  void _awaitReturnValueFromNamePage(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NamePage(choice: choice, name: name)));
    setState(() {
      choice = result[0];
      name = result[1];
      textFromNamePage =
      "${result[0]
          .toString()
          .split('.')
          .last}'s name: ${result[1]}";
    });
  }
  //endregion

  //region Method to get color from ColorPage
  void _awaitReturnValueFromColorPage(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ColorPage(
                    choice: choice,
                    myRed: myRed,
                    myGreen: myGreen,
                    myBlue: myBlue)));
    setState(() {
      myRed = result[0];
      myGreen = result[1];
      myBlue = result[2];
      color = Color(int.parse('ff$myRed$myGreen$myBlue', radix: 16));
    });
  }
  //endregion

}
