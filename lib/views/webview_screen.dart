import 'package:flutter/material.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class WebviewScreen extends StatefulWidget {
  final Widget widget;
  final String body;
  const WebviewScreen(this.body, this.widget, {Key? key}) : super(key: key);

  @override
  _WebviewScreenState createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          widget.widget,
          /* Expanded(
            child: SingleChildScrollView(
              child: HtmlWidget(
                widget.body,
                webView: true,
                onTapUrl: (url) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('url'),
                      content: Text(url),
                    ),
                  );
                },
              ),
            ),
          ) */
        ],
      ),
    );
  }
}
