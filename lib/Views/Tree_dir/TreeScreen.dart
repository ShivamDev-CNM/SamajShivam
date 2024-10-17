import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:samajapp/Controllers/HomeController.dart';
import 'package:samajapp/Utils/Toast.dart';
import 'package:samajapp/Utils/UI%20Resuse%20Fields.dart';
import 'package:samajapp/Utils/colors.dart';
import 'package:samajapp/Utils/myAppBar.dart';
import 'package:samajapp/Utils/mytxt.dart';

class MyNode {
  MyNode({
    required this.id,
    required this.parentName,
    required this.title,
    required this.mobile,
    required this.address,
    List<MyNode>? children,
  }) : children = children ?? <MyNode>[];

  final String title;
  final int id;
  final String address;
  final String mobile;
  final String parentName;
  final List<MyNode> children;
}

class MyTreeView extends StatelessWidget {
  const MyTreeView({super.key});

  @override
  Widget build(BuildContext context) {
    final Homecontroller treeController = Get.put(Homecontroller());

    return Scaffold(
        backgroundColor: Color(0xffDDf2d1),
        appBar: CustomAppBar(title: 'Family tree'),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GetBuilder<Homecontroller>(builder: (treeController) {
              if (treeController.treeList.isEmpty) {
                return Center(
                    child: DataText(text: 'No Data Found', fontSize: 15));
              } else {
                final fancyTreeController = TreeController<MyNode>(
                  defaultExpansionState: true,
                  roots: treeController.treeList,
                  childrenProvider: (MyNode node) => node.children,
                );

                return RefreshIndicator.adaptive(
                  color: Green,
                  backgroundColor: Colors.white,
                  onRefresh: () async {
                    await treeController.fetchTreeAPI();
                    ToastUtils().showCustom('Refreshed');
                  },
                  child: TreeView<MyNode>(
                    physics: AlwaysScrollableScrollPhysics(),
                    treeController: fancyTreeController,
                    nodeBuilder:
                        (BuildContext context, TreeEntry<MyNode> entry) {
                      return MyTreeTile(
                        key: ValueKey(entry.node),
                        entry: entry,
                        onTap: () {
                          print(entry.node.parentName.toString());
                          Get.bottomSheet(PersonDetail(
                              name: entry.node.title,
                              mobileno: entry.node.mobile,
                              Address: entry.node.address,
                              parent: entry.node.parentName));

                          // fancyTreeController.toggleExpansion(entry.node);
                        },
                      );
                    },
                  ),
                );
              }
            })));
  }
}

class MyTreeTile extends StatelessWidget {
  const MyTreeTile({
    super.key,
    required this.entry,
    required this.onTap,
  });

  final TreeEntry<MyNode> entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: TreeIndentation(
        entry: entry,
        guide: const IndentGuide.connectingLines(
          indent: 20,
          color: Green,
          thickness: 2,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 10, 8, 8),
          child: Row(
            children: [
              GestureDetector(
                onTap: entry.hasChildren ? onTap : null,
                child: Icon(
                  Icons.account_circle,
                  size: 30,
                  color: Green,
                ),
              ),
              Card(
                color: Colors.green.shade200,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  child: Text(
                    entry.node.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PersonDetail extends StatelessWidget {
  const PersonDetail({super.key,
    required this.name,
    required this.mobileno,
    required this.Address,
    required this.parent
  });

  final String name;
  final String mobileno;
  final String Address;
  final String parent;

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      width: mySize.width,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FundsRow(title: 'Name', data: name),
            FundsRow(title: 'Mobile No.', data: mobileno),
            FundsRow(title: 'Address', data: Address),
            FundsRow(title: 'Relation', data: parent),

          ],
        ),
      ),
    );
  }
}