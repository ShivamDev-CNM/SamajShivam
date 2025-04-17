import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:samajapp/APIS/APIS.dart';
import 'package:samajapp/Utils/SharedPrefunc.dart';
import 'package:http/http.dart' as http;
import 'package:samajapp/Utils/Toast.dart';
import 'package:samajapp/Views/Auth/Login.dart';

class ProfileController extends GetxController {
  RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchAPI();
    DateController.text = DateFormat('dd-MMM-yyyy').format(DateTime.now());
  }

  fetchAPI() async {
    await fetchProfileData();
    await fetchCountryList();
    await fetchStateList();
    await fetchCityList();
    await fetchAreaList();
    await fetchRelationList();
    await fetchOccupationList();
    await fetchFatherList();
    await fetchMotherList();
    await fetchAllPayment();
    await fetchUserList();
  }

  var profileData = [].obs;
  dynamic parentData = {}.obs;

  var ContributionData = [].obs;
  var MonthlyPending = [].obs;
  RxBool fatherBool = false.obs;
  RxBool motherBool = false.obs;

  ScrollController profileScroll = ScrollController();
  ScrollController expenseScroll = ScrollController();

  //var isNotification = false.obs; // Badge visibility controller

  Future<void> fetchProfileData() async {
    try {
      // Clear previous data
      showDetail.clear();
      ContributionData.clear();
      MonthlyPending.clear();
      profileData.clear();
      showDetail2.clear();
      parentData.clear();

      String accessToken = await getShared();
      final response = await http.get(
        Uri.parse(myApi.ProfileAPI),
        headers: {'x-api-key': accessToken},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        // Assigning data
        profileData.assignAll(jsonData['data']);
        parentData = jsonData['family_tree'];
        MonthlyPending.assignAll(jsonData['monthly_pending_data']);
        ContributionData.assignAll(jsonData['contribution_data']);

        // Setting the badge visibility
        //isNotification.value = jsonData['is_notification'] == 1;
        print("mihir${jsonData['is_notification']}");
        for (int i = 0; i < parentData['wife_brother_sister'].length; i++) {
          showDetail.add(false);
        }

        for (int i = 0; i < parentData['child'].length; i++) {
          showDetail2.add(false);
        }
      } else if (response.statusCode == 407) {
        await RemoveUser();
      } else {
        // Clear data on failure
        profileData.clear();
        //isNotification.value = false;
      }
    } catch (e) {
      print(e.toString());
      profileData.clear();
      //isNotification.value = false;
    } finally {
      update();
    }
  }

  PageController paypg = PageController();

  PageController pg = PageController();

  ///////////////////////////////////////////////////////
  ///Update Profile

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController famaliesNameController = TextEditingController();
  RxString occupationId = ''.obs;
  TextEditingController addressController = TextEditingController();
  Rx<File?> updateProfileImage = Rx<File?>(null);
  RxString myImage = ''.obs;

  passvalue() {
    firstNameController.text = profileData[0]['first_name'];
    lastNameController.text = profileData[0]['last_name'];
    famaliesNameController.text = profileData[0]['familiar_names'];
    addressController.text = profileData[0]['address'];
    myImage.value = profileData[0]['profile_pic'];
    updateProfileImage.value = null;
    selectCountry.value = profileData[0]['country'].toString() == "" ? '1' : profileData[0]['country'].toString();
    selectState.value = profileData[0]['state'].toString() == "" ? '1' : profileData[0]['state'].toString();
    selectCity.value = profileData[0]['city'].toString() == "" ? '1' : profileData[0]['city'].toString();
    selectArea.value = profileData[0]['area'].toString();
  }

  ///////////////////////////////////////////////
////////////////////////////////////////////////
  ///Country

  RxString selectCountry = '1'.obs;
  RxString selectState = '1'.obs;
  RxString selectCity = '1'.obs;
  RxString selectArea = ''.obs;

  var countryList = [].obs;

  fetchCountryList() async {
    try {
      countryList.clear();
      String accesstoken = await getShared();

      final response = await http.get(Uri.parse(myApi.CountryApI), headers: {'x-api-key': accesstoken.toString()});
      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        countryList.assignAll(jsonData['data']);
      } else if (response.statusCode == 407) {
        await RemoveUser();
      } else {
        countryList.clear();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  var stateList = [].obs;

  fetchStateList() async {
    try {
      String accesstoken = await getShared();

      stateList.clear();

      final response =
          await http.get(Uri.parse(myApi.StateApI + '?country_id=${selectCountry.value.toString()}'), headers: {'x-api-key': accesstoken.toString()});
      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        stateList.assignAll(jsonData['data']);
      } else if (response.statusCode == 407) {
        await RemoveUser();
      } else {
        stateList.clear();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  var cityList = [].obs;

  fetchCityList() async {
    try {
      String accesstoken = await getShared();

      cityList.clear();

      final response =
          await http.get(Uri.parse(myApi.CityApI + '?state_id=${selectState.value.toString()}'), headers: {'x-api-key': accesstoken.toString()});
      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        cityList.assignAll(jsonData['data']);
      } else if (response.statusCode == 407) {
        await RemoveUser();
      } else {
        cityList.clear();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  var areaList = [].obs;

  fetchAreaList() async {
    try {
      String accesstoken = await getShared();

      areaList.clear();

      final response = await http.get(Uri.parse('${myApi.AreaApI}?city_id=${selectCity.value}'), headers: {'x-api-key': accesstoken.toString()});
      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        areaList.assignAll(jsonData['data']);
      } else if (response.statusCode == 407) {
        await RemoveUser();
      } else {
        areaList.clear();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  var relationList = [].obs;

  fetchRelationList() async {
    try {
      String accesstoken = await getShared();

      relationList.clear();

      final response = await http.get(Uri.parse(myApi.relationListAPI), headers: {'x-api-key': accesstoken.toString()});
      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        relationList.assignAll(jsonData['data']);
      } else if (response.statusCode == 407) {
        await RemoveUser();
      } else {
        relationList.clear();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  var occupationList = [].obs;

  fetchOccupationList() async {
    try {
      String accesstoken = await getShared();

      occupationList.clear();

      final response = await http.get(Uri.parse(myApi.occupationListAPI), headers: {'x-api-key': accesstoken.toString()});
      final jsonData = jsonDecode(response.body);
      print(jsonData);
      if (response.statusCode == 200) {
        occupationList.assignAll(jsonData['data']);
      } else if (response.statusCode == 407) {
        await RemoveUser();
      } else {
        occupationList.clear();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  var fatherList = [].obs;

  fetchFatherList() async {
    try {
      String accesstoken = await getShared();

      fatherList.clear();

      final response = await http.get(Uri.parse(myApi.userLists + '?gender=1'), headers: {'x-api-key': accesstoken.toString()});
      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        fatherList.assignAll(jsonData['data']);
      } else if (response.statusCode == 407) {
        await RemoveUser();
      } else {
        fatherList.clear();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  var motherList = [].obs;

  fetchMotherList() async {
    try {
      String accesstoken = await getShared();

      motherList.clear();

      final response = await http.get(Uri.parse(myApi.userLists + '?gender=2'), headers: {'x-api-key': accesstoken.toString()});
      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        motherList.assignAll(jsonData['data']);
      } else if (response.statusCode == 407) {
        await RemoveUser();
      } else {
        motherList.clear();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  ////////////////////////////////////////////////
  RxBool updateBool = false.obs;

  updateProfileFunction() async {
    try {
      updateBool(true);
      String accesstoken = await getShared();
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(myApi.UpdateProfileAPI),
      )
        ..headers['x-api-key'] = accesstoken
        ..fields['first_name'] = firstNameController.text.toString()
        ..fields['last_name'] = lastNameController.text.toString()
        ..fields['occupation'] = occupationId.value.toString()
        ..fields['familiar_names'] = famaliesNameController.text.toString()
        ..fields['address'] = addressController.text.toString()
        ..fields['country'] = selectCountry.value.toString()
        ..fields['state'] = selectState.value.toString()
        ..fields['city'] = selectCity.value.toString()
        ..fields['area'] = selectArea.value.toString();

      if (updateProfileImage.value != null) {
        request.files.add(http.MultipartFile(
            'profile_pic', http.ByteStream.fromBytes(updateProfileImage.value!.readAsBytesSync()), updateProfileImage.value!.lengthSync(),
            filename: 'profile_pic'));
      }

      final response = await http.Response.fromStream(await request.send());
      if (response.statusCode == 200) {
        ToastUtils().showCustom('Profile Updated');
        await fetchProfileData();
        updateProfileImage.value = null;
        Get.back();
      } else if (response.statusCode == 407) {
        await RemoveUser();
      } else {
        ToastUtils().showCustom('Something went wrong');
      }
    } catch (e) {
      ToastUtils().showCustom('Something went wrong');
    } finally {
      updateBool(false);
      update();
    }
  }

  ////////////////////////////////////////////////////////////////////////////////

  RxList<bool> showDetail = <bool>[].obs;
  RxList<bool> showDetail2 = <bool>[].obs;

////////////////////////////////////////////////////////////////////////////////

  logout() async {
    String accesstoken = await getShared();

    final response = await http.post(Uri.parse(myApi.LogoutAPI), headers: {'x-api-key': accesstoken});

    if (response.statusCode == 200) {
      clearShared();
      Get.offAll(() => LoginScreen());
      ToastUtils().showCustom('Logged Out');
    } else {
      ToastUtils().showCustom('Failed to Logged Out');
    }
  }

  /////////////////////////////////////////////////////////////////////////////

//Add USer

  TextEditingController userFirstName = TextEditingController();
  TextEditingController userLastName = TextEditingController();
  TextEditingController userMobileNumber = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  TextEditingController Address = TextEditingController();
  TextEditingController ConfirmPassword = TextEditingController();

  var userDobDate = DateTime.now().obs;
  RxString userRelation = ''.obs;
  RxString userOccupation = ''.obs;
  RxString father_id = ''.obs;
  RxString mother_id = ''.obs;
  RxBool isObscure = true.obs;
  RxBool isObscure2 = true.obs;

  RxString isEarning = ''.obs;
  RxString userCountry = '1'.obs;
  RxString userState = '1'.obs;
  RxString userCity = '1'.obs;
  RxString userArea = ''.obs;

  clearUserAddFields() {
    userFirstName.clear();
    userLastName.clear();
    userMobileNumber.clear();
    signUpImage.value = null;
    userEmail.clear();
    userPassword.clear();
    Address.clear();
    userDobDate.value = DateTime.now();
    userRelation.value = '';
    userOccupation.value = '';
    isObscure.value = false;
    father_id.value = '';
    ConfirmPassword.clear();
    mother_id.value = '';
    isEarning.value = '';
    userCountry.value = '';
    userState.value = '';
    userCity.value = '';
    userArea.value = "";
  }

  TextEditingController DateController = TextEditingController();

  pickDate() async {
    final picker = await showDatePicker(context: Get.context!, firstDate: DateTime(2000), initialDate: userDobDate.value, lastDate: DateTime(2050));
    if (picker != null) {
      userDobDate.value = picker;
      DateController.text = DateFormat('dd-MMM-yyyy').format(userDobDate.value);
    }
  }

  Rx<File?> signUpImage = Rx<File?>(null);
  RxInt gender = 1.obs;

  AddUserFunction() async {
    try {
      updateBool(true);
      String accesstoken = await getShared();

      var uri = Uri.parse(myApi.AddUserAPI);
      var request = http.MultipartRequest('POST', uri);

      request.headers['x-api-key'] = accesstoken;

      request.fields['first_name'] = userFirstName.text.toString();
      request.fields['last_name'] = userLastName.text.toString();
      // request.fields['father_id'] = father_id.value.toString();
      // request.fields['mother_id'] = mother_id.value.toString();
      request.fields['relation'] = userRelation.value.toString();
      request.fields['earning_member'] = isEarning.value.toString();
      request.fields['gender'] = gender.value.toString();
      request.fields['mobilenumber'] = userMobileNumber.text.toString();
      request.fields['email'] = userEmail.text.toString();
      request.fields['password'] = userPassword.text.toString();
      request.fields['dob'] = DateFormat('dd-MM-yyyy').format(userDobDate.value).toString();
      request.fields['occupation'] = userOccupation.value.toString();
      request.fields['country'] = userCountry.value.toString();
      request.fields['state'] = userState.value.toString();
      request.fields['address'] = Address.text.toString();
      request.fields['city'] = userCity.value.toString();
      request.fields['area'] = userArea.value.toString();

      if (signUpImage.value != null) {
        request.files.add(http.MultipartFile(
            'profile_pic', http.ByteStream.fromBytes(signUpImage.value!.readAsBytesSync()), signUpImage.value!.lengthSync(),
            filename: 'profile_pic'));
      }

      var response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        ToastUtils().showCustom('Member Added');

        await fetchProfileData();
        await fetchUserList();
        Get.back();
        clearUserAddFields();
      } else {
        ToastUtils().showCustom('Failed to add member');
      }
    } catch (e) {
      print(e.toString());
      ToastUtils().showCustom('Something went wrong');
    } finally {
      updateBool(false);
    }
  }

  ///////////////////////////////////////////////////////////
  var myPaymentData = [].obs;
  RxString type = '1'.obs;
  var selectedDate = DateTime.now().obs;

  Future<void> fetchAllPayment() async {
    try {
      myPaymentData.clear();

      String accesstoken = await getShared();

      final response = await http.get(
          Uri.parse(myApi.BaseUrl + '/api/all_payment_list?transaction_type=${type.value}&year=${selectedDate.value.year}'),
          headers: {'x-api-key': accesstoken});
      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        myPaymentData.assignAll(jsonData['data']);
      } else {
        myPaymentData.clear();
      }
    } catch (e) {
      myPaymentData.clear();
    } finally {
      update();
    }
  }

  RxInt allPayPage = 0.obs;

  ////////////////////////////////////////////////////
  var userList = [].obs;
  RxList<bool> showDetail3 = <bool>[].obs;

  Future<void> fetchUserList() async {
    try {
      userList.clear();
      showDetail3.clear();
      String accesstoken = await getShared();

      final response = await http.get(Uri.parse(myApi.BaseUrl + '/api/users_lists'), headers: {'x-api-key': accesstoken});
      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        userList.assignAll(jsonData['data']);

        for (int i = 0; i < userList.length; i++) {
          showDetail3.add(false);
        }
      } else {
        userList.clear();
        showDetail3.clear();
      }
    } catch (e) {
      showDetail3.clear();
      userList.clear();
    } finally {
      update();
    }
  }

  deleteAccountFunction() async {
    try {
      String accesstoken = await getShared();
      print(accesstoken);

      final response = await http.post(Uri.parse(myApi.DeleteAccountAPI), headers: {'x-api-key': accesstoken});
      final jsonData = jsonDecode(response.body);
      print(jsonData);
      print('ahasdsad');
      if (response.statusCode == 200) {
        ToastUtils().showCustom(jsonData['message']);
        await clearShared();
        Get.offAll(() => LoginScreen());
      } else {
        ToastUtils().showCustom('Something went wrong');
      }
    } catch (e) {
      print(e.toString());
      ToastUtils().showCustom('Something went wrong');
    }
  }
}
