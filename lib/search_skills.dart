import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'datamanager.dart';
import 'skill_model.dart';

class SearchSkills extends StatefulWidget {
  const SearchSkills({super.key});

  @override
  State<SearchSkills> createState() => _SearchSkillsState();
}

class _SearchSkillsState extends State<SearchSkills> {
  String? _accessToken = "";
  String? _searchSkillValue = "";
  final DataManager dataManager = DataManager();
  List<Skill>? _searchSkillResults;
  List selectedSkills = [];

  final TextEditingController _controller = TextEditingController();

  final _myHiveBox = Hive.box('my_skills_profile_box');

  // Write data to the Hive db
  void writeData() {
    // print('selectedSkills $selectedSkills');
    var oldSkills = _myHiveBox.get('skills');
    if (oldSkills != null) {
      var newUpdatedSkills = [...oldSkills, ...selectedSkills];
      var distinctSkills = [
        ...{...newUpdatedSkills}
      ];
      _myHiveBox.put('skills', distinctSkills);
    } else {
      _myHiveBox.put('skills', selectedSkills);
    }
    // _myHiveBox.delete('skills');
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
                  decoration: const InputDecoration(labelText: 'Enter a skill'),
                  onChanged: (value) async {
                    setState(() {
                      _searchSkillValue = value;
                    });

                    if (_accessToken!.isEmpty) {
                      final accessToken = await dataManager.getAccessToken();
                      _accessToken = accessToken;
                    }
                    var results = await dataManager.searchSkills(
                        _searchSkillValue!, _accessToken!);

                    setState(() {
                      _searchSkillResults = results;
                    });
                  },
                ),
              ),
              if (_searchSkillResults != null)
                Expanded(
                  child: FutureBuilder(
                      future: dataManager.searchSkills(
                          _searchSkillValue!, _accessToken!),
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
                                    selectedSkills.add(selectedText);
                                    _searchSkillValue = "";
                                    _controller.clear();
                                  });
                                  // print('selectedSkills--- $selectedSkills');
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
              // Container(child: const Text('here'))
              else
                Container(),
              if (selectedSkills.isNotEmpty)
                const Text('Skills to add to my profile',
                    style: TextStyle(fontWeight: FontWeight.w800)),
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: selectedSkills.length,
                itemBuilder: (BuildContext context, int skillIndex) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      tileColor: Colors.blue.shade200,
                      title: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          selectedSkills[skillIndex],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: FloatingActionButton(
                  onPressed: () {
                    writeData();
                    Navigator.pushNamed(context, '/my_profile');
                  },
                  tooltip: 'Increment',
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
