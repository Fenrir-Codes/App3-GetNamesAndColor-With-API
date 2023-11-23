import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Enum representing different choices for naming.
enum Choice { Mother, Father, Cat, Dog }

// Defining a stateful widget named NamePage.
class NamePage extends StatefulWidget {
  const NamePage({Key? key, this.choice, this.name}) : super(key: key);

  final Choice? choice; // Store the selected choice (Mother, Father, Cat, Dog).
  final String? name; // Store the entered name.

  @override
  State<NamePage> createState() => _NamePageState(); // Create the state for NamePage.
}

class _NamePageState extends State<NamePage> {
  Choice? choice; // Store the selected choice.
  String? name; // Store the entered name.
  String? selectedName;
  List<String> womanNames = [];
  List<String> manNames = [];
  List<String> catNames = [];
  List<String> dogNames = [];

  //region Widget design
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Setting up the app bar with a title and background color.
      appBar: AppBar(
        title: const Text('Name page', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      // Building the main body of the page.
      body: Container(
        // Adding padding to the container.
        padding: const EdgeInsets.all(16.0),
        // Aligning the content to the top center of the screen.
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: SizedBox(
            width: 300, // Setting maximum width for the content.
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // Centering content vertically.
              crossAxisAlignment: CrossAxisAlignment.center,
              // Centering content horizontally.
              children: <Widget>[
                // Displaying a text widget with instructions.
                const Text(
                  'Write the name of your...',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                // Adding space between text and radio buttons.

                // Radio buttons for selecting the type (mother, father, cat, dog).
                ListTile(
                  dense: true,
                  title: const Text('Mother'),
                  leading: Radio<Choice>(
                    value: Choice.Mother,
                    groupValue: choice,
                    onChanged: (Choice? value) {
                      setState(() {
                        choice = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  dense: true,
                  title: const Text('Father'),
                  leading: Radio<Choice>(
                    value: Choice.Father,
                    groupValue: choice,
                    onChanged: (Choice? value) {
                      setState(() {
                        choice = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  dense: true,
                  title: const Text('Cat'),
                  leading: Radio<Choice>(
                    value: Choice.Cat,
                    groupValue: choice,
                    onChanged: (Choice? value) {
                      setState(() {
                        choice = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  dense: true,
                  title: const Text('Dog'),
                  leading: Radio<Choice>(
                    value: Choice.Dog,
                    groupValue: choice,
                    onChanged: (Choice? value) {
                      setState(() {
                        choice = value;
                      });
                    },
                  ),
                ),
                // Similar ListTile widgets for other choices (Father, Cat, Dog).

                const SizedBox(height: 16.0),
                // Adding space between radio buttons and dropdown.

                // Dropdown button for selecting a name
                DropdownButton<String>(
                  value: selectedName,
                  hint: const Text('Select name: '),
                  onChanged: (String? value) {
                    setState(() {
                      selectedName = value;
                    });
                  },
                  icon: const Icon(Icons.arrow_downward), // Add an arrow icon
                  iconSize: 24, // Set the size of the arrow icon
                  elevation: 16, // Set the elevation of the dropdown
                  style: const TextStyle(color: Colors.blue), // Set the text color of the selected item
                  isExpanded: true, // Make the dropdown button take up the full width
                  items: getNamesByChoice()
                      .map<DropdownMenuItem<String>>(
                        (String name) => DropdownMenuItem<String>(
                      value: name,
                      child: Text(name),
                    ),
                  )
                      .toList(),
                ),
                const SizedBox(height: 16.0),

                // Displaying selected name.
                Text(
                  'Selected name: ${selectedName ?? 'None'}',
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleLarge,
                ),
                const SizedBox(height: 16.0),
                // Adding space between input field and button.

                // Elevated button for sending data back.
                ElevatedButton(
                  onPressed: () {
                    _sendDataBack(context);
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
        ),
      ),
    );
  }
  //endregion

  //region Method to send the selected data (name and type) back to the previous screen.
  void _sendDataBack(BuildContext context) {
    Navigator.pop(context, [choice, selectedName]);
  }
  //endregion

  //region InitState /entry point to fetch data
  @override
  void initState() {
    super.initState();
    // Fetch initial data
    getData();
  }
  //endregion

  //region Method to fetch data from APIs
  Future<void> getData() async {
    await fetchHumanNames();
    await fetchCatNames();
    await fetchDogNames();

    // Set the default choice
    setState(() {
      choice = Choice.Mother;
    });
  }
  //endregion

  //region Method to get names based on the selected choice
  List<String> getNamesByChoice() {
    switch (choice) {
      case Choice.Mother:
        return womanNames;
      case Choice.Father:
        return manNames;
      case Choice.Cat:
        return catNames;
      case Choice.Dog:
        return dogNames;
      default:
        return [];
    }
  }
  //endregion

  //region API calls
  // Method to fetch human names from API
  Future<void> fetchHumanNames() async {
    final humanApiResponse = await http.get(
        Uri.parse('https://randomuser.me/api/?results=5&gender=female'));
    if (humanApiResponse.statusCode == 200) {
      final Map<String, dynamic> userData = json.decode(humanApiResponse.body);
      final List<dynamic> results = userData['results'];
      for (int i = 0; i < 5; i++) {
        womanNames.add(results[i]['name']['first']);
      }
    }

    final manApiResponse = await http.get(
        Uri.parse('https://randomuser.me/api/?results=5&gender=male'));
    if (manApiResponse.statusCode == 200) {
      final Map<String, dynamic> userData = json.decode(manApiResponse.body);
      final List<dynamic> results = userData['results'];
      for (int i = 0; i < 5; i++) {
        manNames.add(results[i]['name']['first']);
      }
    }
  }

  // Method to fetch cat names from API
  Future<void> fetchCatNames() async {
    final catApiResponse = await http.get(
        Uri.parse('https://randomuser.me/api/?results=5&gender=female'));
    if (catApiResponse.statusCode == 200) {
      final Map<String, dynamic> userData = json.decode(catApiResponse.body);
      final List<dynamic> results = userData['results'];
      for (int i = 0; i < 5; i++) {
        catNames.add(results[i]['name']['first']);
      }
    }
  }

  // Method to fetch dog names from API
  Future<void> fetchDogNames() async {
    final dogApiResponse = await http.get(
        Uri.parse('https://randomuser.me/api/?results=5&gender=male'));
    if (dogApiResponse.statusCode == 200) {
      final Map<String, dynamic> userData = json.decode(dogApiResponse.body);
      final List<dynamic> results = userData['results'];
      for (int i = 0; i < 5; i++) {
        dogNames.add(results[i]['name']['first']);
      }
    }
  }
  //endregion

}
