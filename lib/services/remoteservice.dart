import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/database.dart';

class RemoteService {

  List<UserData> userdata = [];
  Future<List<UserData>> getUserData() async {

    var client = http.Client();
    var uri = Uri.parse('https://jsonplaceholder.typicode.com/users');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      for (Map u in json) {
        Address address = Address.fromJson(u["address"]);
        Company company = Company.fromJson(u["company"]);
        UserData userData = UserData(
            id: u["id"],
            name: u["name"],
            username: u["username"],
            email: u["email"],
            address: address,
            phone: u["phone"],
            website: u["website"],
            company: company
        );
        userdata.add(userData);

        // checking the data has come or not
        //
        // print("ID: ${userData.id}");
        // print("Name: ${userData.name}");
        // print("Username: ${userData.username}");
        // print("Email: ${userData.email}");
        // print("Address: ${userData.address}");
        // print("Phone: ${userData.phone}");
        // print("Website: ${userData.website}");
        // print("Company: ${userData.company}");
      }
      // print(userdata.length);
      return userdata;
    }
    else {
      throw Exception('Failed to load user data');
    }
  }

}
