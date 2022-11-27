import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intra_building/api.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:exif/exif.dart';

// import 'API.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Intra-Building Navigator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '\n\nThis app allows you to navigate across buildings on campus',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Text(
              '\n',
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const PhotoPage(title: 'Photo Locator');
                }));
              },
              child: Text('Photo Locator'),
            ),
            const Text(
              '\n',
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const NavigatorPage(title: 'Navigator');
                }));
              },
              child: Text('Navigator'),
            ),

            // Text(
            //   '$_counter',
            //   style: Theme.of(context).textTheme.headline4,
            // ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  String _address = "";
  String _latitude = "";
  String _longitude = "";

  String _filename = "before.png";

  XFile? _image;
  final _picker = ImagePicker();
  Uint8List? _byteImage;

  String _exifData = "";

  void _umidk() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }

  // Future getImage() async {
  //   var image = await picker.getImage(source: ImageSource.gallery);
  //   setState(() {
  //     if (image != null) {
  //       _image = File(image.path);
  //     }
  //   });
  // }

  Future getImage() async {
    // Pick an image
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    //TO convert Xfile into file
    File path = File(image.path);

    Uint8List? img = await image.readAsBytes();
    _byteImage = img;

    setState(() {
      _image = image;
      _byteImage = img;
    });

    String exif = await getExifFromFile();

    setState(() {
      _exifData = exif;
    });

    print('Image picked');
  }

  Future<String> getExifFromFile() async {
    if (_image == null) {
      return "";
    }

    var bytes = await _image!.readAsBytes();
    var tags = await readExifFromBytes(bytes);
    var sb = StringBuffer();

    tags.forEach((k, v) {
      sb.write("$k: $v \n");
    });

    return sb.toString();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '\n\nUpload your photos to see their metadata',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Text(
              '\n',
            ),
            if (_byteImage != null)
              Image(
                image: MemoryImage(_byteImage!),
                height: 300,
              ),
            const Text(
              '\n',
            ),
            OutlinedButton(
              onPressed: () {
                getImage();
              },
              child: Text('Choose File'),
            ),
            const Text(
              '\n',
            ),
            OutlinedButton(
              onPressed: () async {
                Map<String, dynamic> response = await PostPhoto(_byteImage);
                setState(() {
                  _address = response["address"]!;
                  _latitude = response["latitude"]!;
                  _longitude = response["longitude"]!;
                });
                // printExifOf('assets/AI_CLUB_TEST.JPG');
              },
              child: Text('Find Image Location'),
            ),
            const Text(
              '\n',
            ),
            Text(
              'Address: $_address',
            ),
            Text(
              'Latitude: $_latitude',
            ),
            Text(
              'Longitude: $_longitude',
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // Future getImage() async {
  //   var image = await picker.getImage(source: ImageSource.gallery);
  //   setState(() {
  //     if (image != null) {
  //       _image = File(image.path);
  //     }
  //   });
  // }

  // /// Get from gallery
  // _getFromGallery() async {
  //   PickedFile pickedFile = await ImagePicker().getImage(
  //     source: ImageSource.gallery,
  //     maxWidth: 1800,
  //     maxHeight: 1800,
  //   );
  //   if (pickedFile != null) {
  //     setState(() {
  //       imageFile = File(pickedFile.path);
  //     });
  //   }
  // }
}

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  // Initial Selected Value
  String startvalue = 'Room 1100';
  String endvalue = 'Room 1100';

  // List of items in our dropdown menu
  var starts = [
    "Room 1100",
    "Room 1103",
    "Room 1105",
    "Room 1107",
    "Room 1108",
    "Room 1109",
    "Room 1118",
    "Room 1120",
    "Room 1130",
    "Room 1148",
    "Room 1202",
    "Room 1211",
    "Room 1220",
    "Room 1226",
    "Room 1228",
  ];

  var ends = [
    "Room 1100",
    "Room 1103",
    "Room 1105",
    "Room 1107",
    "Room 1108",
    "Room 1109",
    "Room 1118",
    "Room 1120",
    "Room 1130",
    "Room 1148",
    "Room 1202",
    "Room 1211",
    "Room 1220",
    "Room 1226",
    "Room 1228",
  ];

  String _path = "";

  String url = '';
  var Data;
  String QueryText = '';

  void _umidk() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '\n\nFind the optimal path between 2 rooms in the Engineering Building',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Text(
              '\n',
            ),
            const Text(
              'Select a start location: ',
            ),
            DropdownButton(
              // Initial Value
              value: startvalue,

              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),

              // Array list of items
              items: starts.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newValue) {
                setState(() {
                  startvalue = newValue!;
                });
              },
            ),
            const Text(
              '\n',
            ),
            const Text(
              'Choose an end location:',
            ),
            DropdownButton(
              // Initial Value
              value: endvalue,

              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),

              // Array list of items
              items: ends.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newValue) {
                setState(() {
                  endvalue = newValue!;
                });
              },
            ),
            const Text(
              '\n',
            ),
            OutlinedButton(
              onPressed: () async {
                url = 'http://127.0.0.1:8000/getpath';
                Data = await PostData(url, {
                  "start": startvalue.toString(),
                  "end": endvalue.toString()
                });
                setState(() {
                  QueryText = Data;
                });
              },
              child: Text('Find Path'),
            ),
            const Text(
              '\n',
            ),
            Text(
              '$QueryText',
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
