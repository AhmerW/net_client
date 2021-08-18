import 'package:flutter/material.dart';
import 'package:net_client/controllers/logvc.dart';
import 'package:provider/provider.dart';

class LogViewConsumer extends StatefulWidget {
  final int log;
  const LogViewConsumer(this.log, {Key? key}) : super(key: key);

  @override
  _LogViewConsumerState createState() => _LogViewConsumerState();
}

class _LogViewConsumerState extends State<LogViewConsumer> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<LogViewController>(
        builder: (context, controller, _) {
          List<Log> logs = controller.get(widget.log);
          return Container(
            child: ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                Log log = logs.elementAt(index);

                return ListTile(
                  title: Text(log.text),
                  trailing: log.trailing,
                  subtitle: Text(
                      DateTime.fromMillisecondsSinceEpoch(log.timestamp)
                          .toString()),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
