import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Importa http para las peticiones
import 'dart:convert';

class HomeState extends ChangeNotifier {
  Future<void> sendPostRequest(String sha, String datasetUrl) async {
    final String url =
        'https://api.github.com/repos/MiguelLaraB/creditcard-api/dispatches';
    final String token = 'token';

    final Map<String, dynamic> body = {
      "event_type": "ml_ci_cd",
      "client_payload": {
        "dataseturl": datasetUrl,
        "sha": sha,
      },
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/vnd.github.v3+json',
        'Content-type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print('Request successful: ${response.body}');
    } else {
      print(
          'Request failed with status: ${response.statusCode}, ${response.body}');
    }
  }
}

class Home extends StatelessWidget {
  final HomeState appState;
  final TextEditingController shaController = TextEditingController();
  final TextEditingController urlController = TextEditingController();

  Home({required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 300,
                  child: TextField(
                    controller: shaController,
                    decoration: InputDecoration(
                      hintText: 'sha(etiqueta de versión)',
                      labelText: 'SHA',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: 300,
                  child: TextField(
                    controller: urlController,
                    decoration: InputDecoration(
                      hintText: 'url',
                      labelText: 'Dataset URL',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String sha = shaController.text;
                    String datasetUrl = urlController.text;

                    String workflowResult =
                        await appState.sendPostRequest(sha, datasetUrl);

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Resultado del Workflow'),
                          content: Text(workflowResult),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
