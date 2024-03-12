import 'package:cakeday_reminder/ui/birthdaydays_list/birthday_list.dart';
import 'package:cakeday_reminder/ui/create_birthday/create_birthday.dart';
import 'package:cakeday_reminder/ui/resources/app_colors.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lion,
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            const BirthdayListPage(),
            Container(
              child: const Center(child: Text("Calendar")),
            ),
            Container(
              child: const Center(child: Text("Group")),
            ),
            Container(
              child: const Center(child: Text("Profile")),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: RawMaterialButton(
          fillColor: AppColors.lion,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateBirthdayPage(),
            ),
          ),
          child: const Icon(
            Icons.cake,
            color: AppColors.cornsilk,
            size: 30,
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 70,
          child: Material(
            color: AppColors.lion,
            child: TabBar(
              indicatorColor: Colors.transparent,
              controller: _tabController,
              tabs: const [
                Tab(
                  icon: Icon(
                    Icons.list,
                    color: AppColors.cornsilk,
                    size: 30,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.calendar_month,
                    color: AppColors.cornsilk,
                    size: 30,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.group,
                    color: AppColors.cornsilk,
                    size: 30,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.person,
                    color: AppColors.cornsilk,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
