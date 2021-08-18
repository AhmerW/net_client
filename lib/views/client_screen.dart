import 'package:flutter/material.dart';
import 'package:net_client/controllers/logvc.dart';
import 'package:net_client/controllers/webl.dart';
import 'package:net_client/data/netreq.dart';
import 'package:net_client/widgets/lvconsumer.dart';
import 'package:provider/provider.dart';

void modalText(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

class ClientScreen extends StatefulWidget {
  final int log = 1;
  const ClientScreen({Key? key}) : super(key: key);

  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  TextEditingController _controller = TextEditingController();

  bool has_text = false;
  String? pingaddr;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Consumer<WebsiteListController>(builder: (context, wlc, _) {
            if (wlc.pingaddr != null) {
              pingaddr = wlc.pingaddr!;
              wlc.pingaddr = null;
              _controller.text = pingaddr!;
            }
            return Container(
              padding: EdgeInsets.only(left: 30, right: 30, top: 30),
              child: TextFormField(
                controller: _controller,
                onChanged: (content) {
                  setState(() {
                    has_text = _controller.text.isNotEmpty;
                  });
                },
                decoration: InputDecoration(hintText: 'Website Address'),
              ),
            );
          }),
          has_text
              ? TextButton(
                  onPressed: () {
                    WebsiteListController controller =
                        Provider.of<WebsiteListController>(
                      context,
                      listen: false,
                    );
                    controller.add(Website(_controller.text)).then(
                          (index) => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(index == -1
                                  ? 'Website already saved'
                                  : 'Website saved'),
                              action: index == -1
                                  ? null
                                  : SnackBarAction(
                                      label: 'Undo',
                                      onPressed: () => controller.remove(index),
                                    ),
                            ),
                          ),
                        );
                  },
                  child: Text('Save website'),
                )
              : SizedBox.shrink(),
          Container(
            margin: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width * 0.5,
            child: ElevatedButton(
              onPressed: () {
                LogViewController lvc = Provider.of<LogViewController>(
                  context,
                  listen: false,
                );

                if (pingaddr != _controller.text) {
                  lvc.clear(widget.log);
                }

                pingaddr = _controller.text;
                processPing(
                  context,
                  pingaddr as String,
                  widget.log,
                  lvc,
                );
              },
              child: Text('Ping!'),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    Provider.of<LogViewController>(context, listen: false)
                        .clear(widget.log);
                  });
                  modalText(context, 'Cleared log');
                },
                icon: Icon(Icons.clear),
              ),
              IconButton(
                onPressed: () {
                  if (_controller.text.isNotEmpty &&
                      _controller.text.contains('.')) {
                    if (!_controller.text.startsWith('http')) {
                      String text = 'https://${_controller.text}/';
                      _controller.text = text;
                    } else if (!_controller.text.endsWith('/')) {
                      _controller.text = '${_controller.text}/';
                    }
                    modalText(context, 'Fixed url');
                  }
                },
                icon: Icon(Icons.construction),
              )
            ],
          ),
          Divider(),
          LogViewConsumer(widget.log)
        ],
      ),
    );
  }
}
