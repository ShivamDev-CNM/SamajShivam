import 'dart:convert';
import 'package:get/get.dart';
import 'package:samajapp/APIS/APIS.dart';
import 'package:samajapp/Utils/SharedPrefunc.dart';
import 'package:http/http.dart' as http;
import 'package:samajapp/Views/Tree_dir/TreeScreen.dart';

class Homecontroller extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Loading(true);
    fetchTreeAPI();
    fetchEntireHomeData();
  }

  fetchEntireHomeData() async {
    await fetchHomeAdvertise();
    await fetchDonationList();
    await fetchWishHomeList();
    await fetchadverHomeList();
    Loading(false);
    update();
  }

  RxBool Loading = false.obs;

  RxInt Adver = 0.obs;
  RxInt Donat = 0.obs;
  RxInt Wishh = 0.obs;
  RxInt Ach = 0.obs;

  var AdvertiseHomeList = [].obs;

  Future<void> fetchHomeAdvertise() async {
    try {
      AdvertiseHomeList.clear();

      String accesstoken = await getShared();

      final response = await http.get(
          Uri.parse(myApi.BaseUrl + '/api/home_advertisement'),
          headers: {'x-api-key': accesstoken});
      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        AdvertiseHomeList.assignAll(jsonData['data']);
      } else {
        AdvertiseHomeList.clear();
      }
    } catch (e) {
      AdvertiseHomeList.clear();
    } finally {}
  }

  /////////////////////////////////////////////
  var donationHomeList = [].obs;

  Future<void> fetchDonationList() async {
    try {
      donationHomeList.clear();

      String accesstoken = await getShared();

      final response = await http.get(
          Uri.parse(myApi.BaseUrl + '/api/home_donation'),
          headers: {'x-api-key': accesstoken});
      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        donationHomeList.assignAll(jsonData['data']);
      } else {
        donationHomeList.clear();
      }
    } catch (e) {
      donationHomeList.clear();
    } finally {}
  }

  /////////////////////////////////////////////
  var wishHomeList = [].obs;

  Future<void> fetchWishHomeList() async {
    try {
      wishHomeList.clear();

      String accesstoken = await getShared();

      final response = await http.get(
          Uri.parse(myApi.BaseUrl + '/api/home_wishes'),
          headers: {'x-api-key': accesstoken});
      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        wishHomeList.assignAll(jsonData['data']);
      } else {
        wishHomeList.clear();
      }
    } catch (e) {
      wishHomeList.clear();
    } finally {}
  }

  ////////////////////////////////////////////

  var achievementrHomeList = [].obs;

  Future<void> fetchadverHomeList() async {
    try {
      achievementrHomeList.clear();

      String accesstoken = await getShared();

      final response = await http.get(
          Uri.parse(myApi.BaseUrl + '/api/home_achievement'),
          headers: {'x-api-key': accesstoken});
      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        achievementrHomeList.assignAll(jsonData['data']);
      } else {
        achievementrHomeList.clear();
      }
    } catch (e) {
      achievementrHomeList.clear();
    } finally {}
  }

  ///////////////////////////////////////////////

  dynamic donationData = {}.obs;

  fetchDonationData() async {
    try {
      String accessToken = await getShared();
      final response = await http.get(Uri.parse(myApi.DonataionListAPI),
          headers: {'x-api-key': accessToken});
      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        donationData = jsonData;
      } else if (response.statusCode == 407) {
        await RemoveUser();
      } else {
        donationData.clear();
      }
    } catch (e) {
      print(e.toString());
      donationData.clear();
    } finally {
      update();
    }
  }

  ////////////////////////////////////////////////

  dynamic wishesData = {}.obs;

  fetchWishList() async {
    try {
      String accessToken = await getShared();
      final response = await http.get(Uri.parse(myApi.WishListAPI),
          headers: {'x-api-key': accessToken});
      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        wishesData = jsonData;
      } else if (response.statusCode == 407) {
        await RemoveUser();
      } else {
        wishesData.clear();
      }
    } catch (e) {
      print(e.toString());
      wishesData.clear();
    } finally {
      update();
    }
  }

  ////////////////////////////////////////////////

  dynamic achievementData = {}.obs;

  fetchAchievementList() async {
    try {
      String accessToken = await getShared();
      final response = await http.get(Uri.parse(myApi.AchievementListAPI),
          headers: {'x-api-key': accessToken});
      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        achievementData = jsonData;
        print(response.body);
      } else if (response.statusCode == 407) {
        await RemoveUser();
      } else {
        achievementData.clear();
      }
    } catch (e) {
      print(e.toString());
      achievementData.clear();
    } finally {
      update();
    }
  }

  var treeList = <MyNode>[].obs;

  Future<void> fetchTreeAPI() async {
    try {
      treeList.clear();
      String accessToken = await getShared();
      final response = await http.get(Uri.parse(myApi.TreeManagementAPI),
          headers: {'x-api-key': accessToken});
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        var nodes = parseNodes(jsonData['data']);
        treeList.assignAll(nodes);
      } else if (response.statusCode == 407) {
        await RemoveUser();
      } else {
        treeList.clear();
      }
    } catch (e) {
      // ToastUtils().showCustom('PRoblen');
      print('check');
      print(e.toString());
      treeList.clear();
      // Optionally log the error or show a toast
    } finally {
      update();
    }
  }

  List<MyNode> parseNodes(List<dynamic> json) {
    return json.map((dynamic item) {
      return MyNode(
        title: item['user_name'],
        id: item['id'] ?? 0,
        children: parseNodes(
            item['father_children'] == "" ? [] : item['father_children']),
        parentName: item['message'] ?? '--',
        address: item['address'] ?? '--',
        mobile: item['mobilenumber'],
      );
    }).toList();
  }
}
