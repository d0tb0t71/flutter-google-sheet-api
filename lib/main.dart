import 'package:flutter/material.dart';
import 'package:flutter_google_sheet_api/model/data_model.dart';

import 'api/student_sheet_api.dart';
import 'model/StudentDataModel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StudentSheetApi.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController id = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController cgpa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Google Sheet API")),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: id,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Student ID ',
                  hintText: 'Enter Student ID',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Student Name',
                  hintText: 'Enter Student Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: cgpa,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'CGPA',
                  hintText: 'Enter CGPA',
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  final student = {
                    DataModel.ID: id.text,
                    DataModel.Name: name.text,
                    DataModel.CGPA: cgpa.text
                  };

                  if(id.text.length>0 && name.text.length > 0 && cgpa.text.length > 0){

                    bool response = await StudentSheetApi.insert([student]);


                    if(response){
                      id.clear();
                      name.clear();
                      cgpa.clear();

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Data Updated'),
                      ));

                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Error Occured !'),
                      ));
                    }
                  }
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Enter Valid Data !'),
                    ));
                  }





                },
                child: Text("SAVE"))
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
