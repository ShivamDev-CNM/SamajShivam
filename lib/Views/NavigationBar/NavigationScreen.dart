import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samajapp/Controllers/NavigationController.dart';
import 'package:samajapp/Views/Dashboard_dir/DashboardScreen.dart';
import 'package:samajapp/Views/Events_dir/EventsScreen.dart';
import 'package:samajapp/Views/Funds_dir/FundsScreen.dart';
import 'package:samajapp/Views/Tree_dir/TreeScreen.dart';

class NavigationScreen extends StatelessWidget {
  final Navigationcontroller nc = Get.put(Navigationcontroller());

  NavigationScreen({super.key});

  final List<Widget> tabs = [
    DashboardScreen(),
    MyTreeView(),
    EventsScreen(),
    FundsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: tabs[nc.currentIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.grey.shade100,
          showSelectedLabels: false,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          unselectedItemColor: Colors.black,
          currentIndex: nc.currentIndex.value,
          onTap: (index) {
            nc.currentIndex.value = index;
          },
          selectedItemColor: Colors.green,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_tree_outlined),
              label: 'Family Tree',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label: 'Events',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_graph_sharp),
              label: 'Funds',
            ),
          ],
        ),
      );
    });
  }
}
