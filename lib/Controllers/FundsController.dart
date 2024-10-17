import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:samajapp/APIS/APIS.dart';
import 'package:samajapp/Utils/SharedPrefunc.dart';
import 'package:samajapp/Utils/Toast.dart';

class FundsController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    callAPi();
  }

  RxBool isCalled = false.obs;

  callAPi() async {
    isCalled(true);
    fetchTotalCommunity();
    fetchMonthlyCommunityList();
    fetchDonationList();
    fetchMonthlyContributionList();
    fetchExpensesList();
    fetchNormalExpenseList();
    fetchSponSorshipList();
    fetchAdverList();
    isCalled(false);
  }

  ScrollController sc = ScrollController();
  RxInt currentIndex = 0.obs;
  PageController pg = PageController();

  var TotalComData = [].obs;

  fetchTotalCommunity() async {
    try {
      TotalComData.clear();

      String accessToken = await getShared();

      final response = await http.get(Uri.parse(myApi.TotalCommunityAPI),
          headers: {'x-api-key': accessToken});
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        TotalComData.assignAll(jsonData['data']);
      } else if (response.statusCode == 407) {
        await RemoveUser();
      } else {
        TotalComData.clear();
      }
    } catch (e) {
      TotalComData.clear();
      print(e.toString());
    } finally {
      update();
    }
  }

///////////////////////////////////////////////////////////

  var selectMonthCom = DateTime.now().obs;
  var MonthlyCommunityList = [].obs;

  Future<void> fetchMonthlyCommunityList() async {
    try {
      MonthlyCommunityList.clear();

      String accessToken = await getShared();

      final response = await http.get(
          Uri.parse(myApi.MonthlyCommunityAPI +
              '?month=${DateFormat('MM').format(selectMonthCom.value)}&year=${selectMonthCom.value.year}'),
          headers: {'x-api-key': accessToken});
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        MonthlyCommunityList.assignAll(jsonData['data']);
      } else if (response.statusCode == 407) {
        await RemoveUser();
      } else {
        MonthlyCommunityList.clear();
      }
    } catch (e) {
      MonthlyCommunityList.clear();
      print(e.toString());
    } finally {
      update();
    }
  }

  ///////////////////////////////////////////////////////////

  var selectDonation = DateTime.now().obs;
  var DonationList = [].obs;
  RxString NormalDonationCondition = '1'.obs;

  RxList<bool> myDonationBools = <bool>[].obs;
  RxString DonationuserNames = "".obs;

  Future<void> fetchDonationList() async {
    try {
      DonationList.clear();

      String accessToken = await getShared();

      final response = await http.get(
          Uri.parse(myApi.DonationFundsAPI +
              '?month=${DateFormat('MM').format(selectDonation.value)}&year=${selectDonation.value.year}'),
          headers: {'x-api-key': accessToken});
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        DonationList.assignAll(jsonData['data']);
        for (int i = 0; i < DonationList.length; i++) {
          myDonationBools.add(false);
        }
      } else if (response.statusCode == 407) {
        await RemoveUser();
      } else {
        DonationList.clear();
      }
    } catch (e) {
      DonationList.clear();
      print(e.toString());
    } finally {
      update();
    }
  }

  var NormalDonationList = [].obs;

  Future<void> fetchNormalDonationList() async {
    try {
      NormalDonationList.clear();

      String accessToken = await getShared();

      final response = await http.get(
          Uri.parse(myApi.NormalDonationFundsAPI +
              '?month=${DateFormat('MM').format(selectDonation.value)}&year=${selectDonation.value.year}'),
          headers: {'x-api-key': accessToken});
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        NormalDonationList.assignAll(jsonData['data']);
      } else if (response.statusCode == 407) {
        await RemoveUser();
      } else {
        NormalDonationList.clear();
      }
    } catch (e) {
      NormalDonationList.clear();
      print(e.toString());
    } finally {
      update();
    }
  }

  var selectSponsership = DateTime.now().obs;
  var SponsorShipList = [].obs;

  Future<void> fetchSponSorshipList() async {
    try {
      SponsorShipList.clear();

      String accessToken = await getShared();

      final response = await http.get(
          Uri.parse(myApi.SponserShipAPI +
              '?month=${DateFormat('MM').format(selectSponsership.value)}&year=${selectSponsership.value.year}'),
          headers: {'x-api-key': accessToken});
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('spon');
        print(jsonData);

        SponsorShipList.assignAll(jsonData['data']);
      } else if (response.statusCode == 407) {
        await RemoveUser();
      } else {
        SponsorShipList.clear();
      }
    } catch (e) {
      SponsorShipList.clear();
      print(e.toString());
    } finally {
      update();
    }
  }

  var selectAdverTime = DateTime.now().obs;

  var AdverList = [].obs;
  RxList<bool> myBools = <bool>[].obs;
  RxString userNames = "".obs;

  Future<void> fetchAdverList() async {
    try {
      myBools.clear();
      AdverList.clear();

      String accessToken = await getShared();

      final response = await http.get(
          Uri.parse(myApi.advertiseListAPI +
              '?month=${DateFormat('MM').format(selectAdverTime.value)}&year=${selectAdverTime.value.year}'),
          headers: {'x-api-key': accessToken});
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        AdverList.assignAll(jsonData['data']);

        for (int i = 0; i < AdverList.length; i++) {
          myBools.add(false);
        }
      } else if (response.statusCode == 407) {
        await RemoveUser();
      } else {
        AdverList.clear();
      }
    } catch (e) {
      AdverList.clear();
      print(e.toString());
    } finally {
      update();
    }
  }

  CommaSeprate() {}

  ///////////////////////////////////////////////////////////

  var selectMonthlyContributionDate = DateTime.now().obs;
  var MonthlyContributionList = [].obs;

  Future<void> fetchMonthlyContributionList() async {
    try {
      MonthlyContributionList.clear();

      String accessToken = await getShared();

      final response = await http.get(
          Uri.parse(myApi.MonthlyContributionAPI +
              '?month=${DateFormat('MM').format(selectMonthlyContributionDate.value)}&year=${selectMonthlyContributionDate.value.year}'),
          headers: {'x-api-key': accessToken});
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        MonthlyContributionList.assignAll(jsonData['data']);
      } else if (response.statusCode == 407) {
        await RemoveUser();
      } else {
        MonthlyContributionList.clear();
      }
    } catch (e) {
      MonthlyContributionList.clear();
      print(e.toString());
    } finally {
      update();
    }
  }

  ///////////////////////////////////////////////////////////

  var selectExpensesMonth = DateTime.now().obs;
  var ExpensesMonthList = [].obs;
  RxString ConditionExpense = '1'.obs;

  Future<void> fetchExpensesList() async {
    try {
      ExpensesMonthList.clear();

      String accessToken = await getShared();

      final response = await http.get(
          Uri.parse(myApi.ExpensesAPI +
              '?month=${DateFormat('MM').format(selectExpensesMonth.value)}&year=${selectExpensesMonth.value.year}'),
          headers: {'x-api-key': accessToken});
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        ExpensesMonthList.assignAll(jsonData['data']);
      } else if (response.statusCode == 407) {
        await RemoveUser();
      } else {
        ExpensesMonthList.clear();
      }
    } catch (e) {
      ExpensesMonthList.clear();
      print(e.toString());
    } finally {
      update();
    }
  }

  var NormalExpenseList = [].obs;

  Future<void> fetchNormalExpenseList() async {
    try {
      NormalExpenseList.clear();

      String accessToken = await getShared();

      final response = await http.get(
          Uri.parse(myApi.normalExpenseList +
              '?month=${DateFormat('MM').format(selectExpensesMonth.value)}&year=${selectExpensesMonth.value.year}'),
          headers: {'x-api-key': accessToken});
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        NormalExpenseList.assignAll(jsonData['data']);
      } else if (response.statusCode == 407) {
        await RemoveUser();
      } else {
        NormalExpenseList.clear();
      }
    } catch (e) {
      NormalExpenseList.clear();
      print(e.toString());
    } finally {
      update();
    }
  }

///////////////////////////////////////////////////
  CommonMonthPicker(
      Rx<DateTime> selectedDate, Future<void> Function() myFunc) async {
    showMonthPicker(
      context: Get.context!,
      initialDate: selectedDate.value,
      firstDate: DateTime(1970),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month),
    ).then((value) async {
      if (value != null) {
        selectedDate.value = value;
        await myFunc(); // Call the function to fetch data
      }
    });
  }

  CommonYearPicker(
      Rx<DateTime> selectedDate, Future<void> Function() myFunc) async {
    showDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            title: Text('Select Year'),
            content: SizedBox(
              height: 300,
              width: 300,
              child: YearPicker(
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2050),
                  selectedDate: selectedDate.value,
                  onChanged: (val) async {
                    selectedDate.value = val;
                    Get.back();
                    await myFunc();
                  }),
            ),
          );
        });
  }
}
