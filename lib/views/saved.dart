import 'package:flutter/material.dart';
import 'package:net_client/controllers/logvc.dart';
import 'package:net_client/controllers/webl.dart';
import 'package:net_client/data/netreq.dart';
import 'package:net_client/widgets/lvconsumer.dart';
import 'package:provider/provider.dart';

class SavedWebsitesScreen extends StatefulWidget {
  const SavedWebsitesScreen({Key? key}) : super(key: key);

  @override
  _SavedWebsitesState createState() => _SavedWebsitesState();
}

class _SavedWebsitesState extends State<SavedWebsitesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Consumer<WebsiteListController>(
          builder: (context, controller, _) {
            return FutureBuilder(
              future: controller.get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Website> websites = snapshot.data as List<Website>;
                  if (websites.isEmpty) {
                    return Center(
                      child: Text('No saved websites'),
                    );
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemCount: websites.length,
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                          itemBuilder: (context, index) {
                            Website website = websites.elementAt(index);

                            return Container(
                                width: double.infinity,
                                child: ListTile(
                                  title: Text(website.url),
                                  subtitle: Row(
                                    children: [],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Tooltip(
                                        message: 'Ping',
                                        child: IconButton(
                                          onPressed: () {
                                            Provider.of<WebsiteListController>(
                                                    context,
                                                    listen: false)
                                                .setPingaddr(website.url);

                                            var lvc =
                                                Provider.of<LogViewController>(
                                                    context,
                                                    listen: false);

                                            processPing(
                                                context, website.url, 2, lvc);
                                          },
                                          icon: Icon(Icons.restart_alt),
                                        ),
                                      ),
                                      Tooltip(
                                        message: 'Paste',
                                        child: IconButton(
                                          onPressed: () {
                                            controller.setPingaddr(website.url);
                                          },
                                          icon: Icon(Icons.content_paste),
                                        ),
                                      ),
                                      Tooltip(
                                        message: 'Delete',
                                        child: IconButton(
                                          onPressed: () =>
                                              controller.remove(index),
                                          icon: Icon(Icons.delete_forever),
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                          },
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            var lvc = Provider.of<LogViewController>(context,
                                listen: false);

                            setState(() {
                              lvc.clear(2);
                            });
                          },
                          child: Text('Clear')),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ElevatedButton(
                          onPressed: () {
                            var lvc = Provider.of<LogViewController>(context,
                                listen: false);

                            for (Website website in controller.websites) {
                              processPing(context, website.url, 2, lvc);
                            }
                          },
                          child: Text('Ping all'),
                        ),
                      ),
                      Divider(),
                      Text('LOGS'),
                      LogViewConsumer(2),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                        'There was an error while attempting to load the websites..'),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          },
        ));
  }
}
