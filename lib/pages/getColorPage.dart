// Importing the Flutter material package, which contains widgets for Material Design.
import 'package:flutter/material.dart';

// Importing another Dart file named 'getNamePage.dart'.
import 'getNamePage.dart';

class ColorPage extends StatefulWidget {
  const ColorPage(
      {super.key
        , this.choice,
        this.myRed, this.myGreen,
        this.myBlue
      });

  final Choice? choice;
  final String? myRed;
  final String? myGreen;
  final String? myBlue;

  @override
  State<ColorPage> createState() => _ColorPageState(
      choice: choice, myRed: myRed, myGreen: myGreen, myBlue: myBlue);
}

// Defining a list of hexadecimal color values.
const List<String> list = <String>[
  'ff', '11', '22', '33', '44', '55', '66', '77',
  '88', '99', 'aa', 'bb', 'cc', 'dd', 'ee', '00'
];

// Defining the state for the ColorPage widget.
class _ColorPageState extends State<ColorPage> {
  Color? myColor; // Store the current color based on RGB values.
  Choice? choice; // Store a Choice object received from the previous screen.
  final String? myRed; // Store the Red component of the color.
  final String? myGreen; // Store the Green component of the color.
  final String? myBlue; // Store the Blue component of the color.
  String typeText = 'Color'; // Store the type of color (default: 'Color').
  String dropdownValueRed = list.first; // Store the selected Red component (default: first element in the list).
  String dropdownValueGreen = list.first; // Store the selected Green component (default: first element in the list).
  String dropdownValueBlue = list.first; // Store the selected Blue component (default: first element in the list).

  // Constructor for the state class.
  _ColorPageState({this.choice, this.myRed, this.myGreen, this.myBlue}) {
    if (choice != null) {
      typeText = "${choice.toString().split('.').last}'s Color:";
    }
    if (myRed != null) {
      dropdownValueRed = myRed ?? '';
    }
    if (myGreen != null) {
      dropdownValueGreen = myGreen ?? '';
    }
    if (myBlue != null) {
      dropdownValueBlue = myBlue ?? '';
    }
    myColor = Color(int.parse(
        'ff$dropdownValueRed$dropdownValueGreen$dropdownValueBlue',
        radix: 16));
  }

  // Build method for constructing the UI.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Page', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              typeText, //Passed from name page
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20.0,
            ),
            // Displaying a colored container with the chosen color.
            Container(
              decoration: BoxDecoration(
                color: myColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              width: 300,
              height: 50,
              alignment: Alignment.center,
              child: const Text(
                'Preview',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            // Row containing dropdowns for Red, Green, and Blue colors.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDropdown('Red', dropdownValueRed, (String? value) {
                  setState(() {
                    dropdownValueRed = value!;
                    _updateColor();
                  });
                }),
                _buildDropdown('Green', dropdownValueGreen, (String? value) {
                  setState(() {
                    dropdownValueGreen = value!;
                    _updateColor();
                  });
                }),
                _buildDropdown('Blue', dropdownValueBlue, (String? value) {
                  setState(() {
                    dropdownValueBlue = value!;
                    _updateColor();
                  });
                }),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            // Button to send the selected color back to the previous screen.
            ElevatedButton(
              onPressed: () {
                _sendColorBack(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                minimumSize: const Size(150, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text('Send', style: TextStyle(fontSize: 16.0)),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for building a dropdown with a label.
  Widget _buildDropdown(String label, String value, Function(String?) onChanged) {
    return Padding( //padding horizontally
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column( //Column
        children: [
          Text( //Text label
            label,
            style: const TextStyle(fontSize: 16.0), //Font size
          ),
          SizedBox( // Sized box with a width of 50
            width: 50,
            child: DropdownButton(  //Dropdown list
              value: value,
              icon: const Icon(Icons.arrow_downward),  //Icon arrow down
              onChanged: onChanged,
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value), // text on dropdown set to value from list
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Method to update the color based on the selected RGB values.
  void _updateColor() {
    myColor = Color(int.parse('ff$dropdownValueRed$dropdownValueGreen$dropdownValueBlue',
        radix: 16));
  }

  // Method to send the selected color back to the previous screen.
  void _sendColorBack(BuildContext context) {
    Navigator.pop(context, [dropdownValueRed, dropdownValueGreen, dropdownValueBlue]);
  }
}
