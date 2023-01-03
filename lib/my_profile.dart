import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyProfile extends StatefulWidget {
  MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final _myHiveBox = Hive.box('my_skills_profile_box');

  String jobTitle = "No job title added";
  List skills = [];

  // Write data to the Hive db
  void readData() {
    jobTitle = _myHiveBox.get('job_title');
    skills = _myHiveBox.get('skills') ?? [];

    // print('skills--- $skills');
  }

  _deleteSkill(index) {
    var currentSkills = _myHiveBox.get('skills');
    currentSkills.removeAt(index);

    var newUpdatedSkills = [...currentSkills];

    _myHiveBox.put('skills', newUpdatedSkills);

    setState(() {
      skills = currentSkills;
    });
  }

  @override
  void initState() {
    readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'My Profile',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Job title:",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(jobTitle),
              ),
              if (skills.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('My Skills',
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: skills.length,
                  itemBuilder: (BuildContext context, int skillIndex) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        trailing: IconButton(
                            onPressed: () {
                              _deleteSkill(skillIndex);
                            },
                            icon: const Icon(Icons.delete)),
                        tileColor: Colors.blue.shade200,
                        title: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            skills[skillIndex],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
