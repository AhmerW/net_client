import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:net_client/controllers/logvc.dart';
import 'package:net_client/views/webview_screen.dart';

Map<String, HttpClient> _clients = {};
const String urlPattern =
    r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";

HttpClient getClient(String site) {
  if (!_clients.containsKey(site)) {
    _clients[site] = HttpClient();
  }
  return _clients[site] ?? HttpClient();
}

Future<StringBuffer> getBody(HttpClientResponse response) async {
  var result = new StringBuffer();
  await for (var contents in response.transform(Utf8Decoder())) {
    result.write(contents);
  }
  return result;
}

Future<int> processPing(
    BuildContext context, String url, int log, LogViewController lvc) async {
  HttpClient client = getClient(url);

  if (RegExp(urlPattern, caseSensitive: false).firstMatch(url) == null) {
    lvc.add(
      log,
      Log(
        "Request failed. Invalid url",
        trailing: Icon(Icons.link_off),
      ),
    );
    return 0;
  }

  var uri = Uri.parse(url);

  lvc.add(
    log,
    Log(
      "Sending Ping. [HTTP GET Request]",
      trailing: IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Request info'),
              );
            },
          );
        },
        icon: Icon(Icons.send),
      ),
    ),
  );
  try {
    client.getUrl(uri).then((request) => request.close()).then(
      (response) async {
        var body = await getBody(response);

        // print(body);
        lvc.add(
          log,
          Log(
            "Response received. [Status: ${response.statusCode}]",
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebviewScreen(
                              body.toString(),
                              Column(
                                children: [
                                  Text(url),
                                ],
                              )),
                        ),
                      );
                    },
                    icon: Icon(Icons.web))
              ],
            ),
          ),
        );
      },
    );

    return 1;
  } catch (err) {
    print("err: ${err.toString()}");
    lvc.add(
      log,
      Log(
        "Error: '${err.toString()}'",
      ),
    );
    return 0;
  }
}
