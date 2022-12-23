import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'jobtitle.dart';
import 'skill_model.dart';

class DataManager {
  String? accessToken;
  List<JobTitle>? jobs;

  Future<String> getAccessToken() async {
    var url = 'https://auth.emsicloud.com/connect/token';
    var clientId = dotenv.env['CLIENT_ID'];
    var clientSecret = dotenv.env['CLIENT_SECRET'];
    var body =
        "client_id=$clientId&client_secret=$clientSecret&grant_type=client_credentials&scope=emsi_open";

    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body);

    var res = jsonDecode(response.body);

    var accessToken = res['access_token'];

    return accessToken;
  }

  Future<List<JobTitle>>? searchTitles(String query, String accessToken) async {
    var url =
        'https://emsiservices.com/titles/versions/latest/titles?q=$query&limit=5';

    http.Response response = await http.get(Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'});

    if (response.statusCode == 200) {
      var jobTitles = jsonDecode(response.body);
      List<JobTitle> jobs = [];

      var jobTitleData = jobTitles['data'];

      for (var job in jobTitleData) {
        JobTitle jobTitle = JobTitle(id: job['id'], name: job['name']);
        jobs.add(jobTitle);
      }
      return jobs;
    } else {
      print(response.statusCode);
      // throw Exception('Failed to load jobs');
    }
    return [];
  }

  Future<List<Skill>>? searchSkills(String query, String accessToken) async {
    var url =
        'https://emsiservices.com/skills/versions/latest/skills?q=$query&limit=5';

    http.Response response = await http.get(Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'});

    if (response.statusCode == 200) {
      var skillTypes = jsonDecode(response.body);
      List<Skill> skills = [];

      var skillTypesData = skillTypes['data'];
      // print('skillTypes $skillTypesData');

      for (var skill in skillTypesData) {
        Skill skillType = Skill(id: skill['id'], name: skill['name']);
        skills.add(skillType);
      }
      return skills;
    } else {
      print(response.statusCode);
      // throw Exception('Failed to load jobs');
    }
    return [];
  }
}
