import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:skills/search_skills.dart';
import 'datamanager.dart';
import 'jobtitle.dart';

class SearchJobTitles extends StatefulWidget {
  const SearchJobTitles({super.key});

  @override
  State<SearchJobTitles> createState() => _SearchJobTitlesState();
}

class _SearchJobTitlesState extends State<SearchJobTitles> {
  String? _accessToken = "";
  String? _searchTitleValue = "";
  final DataManager dataManager = DataManager();
  List<JobTitle>? _searchTitleResults;

  final TextEditingController _controller = TextEditingController();

  final _myHiveBox = Hive.box('my_skills_profile_box');

  // Write data to the Hive db
  void writeData() {
    // print(_controller.value);
    _myHiveBox.put('job_title', _controller.text);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _controller,
                  decoration:
                      const InputDecoration(labelText: 'Type your job title'),
                  onChanged: (value) async {
                    setState(() {
                      _searchTitleValue = value;
                    });

                    if (_accessToken!.isEmpty) {
                      final accessToken = await dataManager.getAccessToken();
                      _accessToken = accessToken;
                    }
                    var results = await dataManager.searchTitles(
                        _searchTitleValue!, _accessToken!);

                    setState(() {
                      _searchTitleResults = results;
                    });
                  },
                ),
              ),
              if (_searchTitleResults != null)
                Expanded(
                  child: FutureBuilder(
                      future: dataManager.searchTitles(
                          _searchTitleValue!, _accessToken!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(snapshot.data![index].name!),
                                onTap: () {
                                  setState(() {
                                    var selectedText =
                                        snapshot.data![index].name!;
                                    _searchTitleValue = selectedText;
                                    _controller.value =
                                        _controller.value.copyWith(
                                      text: selectedText,
                                      selection: TextSelection.collapsed(
                                          offset: selectedText.length),
                                    );
                                  });
                                },
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        // By default, show a loading spinner.
                      }),
                )
              else
                Container(),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: FloatingActionButton(
                  onPressed: () {
                    writeData();
                    Navigator.pushNamed(context, '/search_skills');
                  },
                  tooltip: 'Add job title',
                  child: const Icon(Icons.add),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
