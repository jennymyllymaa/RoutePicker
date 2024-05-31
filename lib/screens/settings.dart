import 'package:flutter/material.dart';
import 'package:routepicker/blocs/settings/settings_bloc.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsBloc _settingsBloc = SettingsBloc(); 
  TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _settingsBloc.loadPreferences();
    _settingsBloc.getSavedWeight().then((value) {
      if (value != null) {
        print(value);
        setState(() {
          _inputController.text = value.toString(); 
        });
      } else {
        print("No value saved");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text("Save your weight in kg to get estimated calories burned for routes."),
            const SizedBox(height: 20.0,),
            TextField(
              controller: _inputController,
              decoration: InputDecoration(
                labelText: 'Weight',
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20.0,),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                _settingsBloc.saveWeight(_inputController.text); 
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose(); // controller needs to be disposed when screen exited
    super.dispose();
  }
}