import 'package:flutter/material.dart';
import '../features/dashboard/pages/dashboard_page.dart';
import '../features/kb/pages/kb_page.dart';
import '../features/auth/pages/login_page.dart';
import '../features/sla/pages/sla_list_page.dart';
import '../core/storage/token_storage.dart';

import '../features/categories/pages/category_list_page.dart';
import '../features/departments/pages/department_list_page.dart';
import '../features/tickets/pages/ticket_list_page.dart';

class MainLayoutPage extends StatefulWidget {
  const MainLayoutPage({super.key});

  @override
  State<MainLayoutPage> createState() => _MainLayoutPageState();
}

class _MainLayoutPageState extends State<MainLayoutPage> {
  int selectedIndex = 0;
  int bottomIndex = 0;

  void updateBottomIndex() {
    switch (selectedIndex) {
      case 5:
        bottomIndex = 0;
        break;
      case 2:
        bottomIndex = 1;
        break;
      case 10:
        bottomIndex = 2;
        break;
      case 9:
        bottomIndex = 3;
        break;
      case 11:
        bottomIndex = 4;
        break;
      default:
        bottomIndex = 0;
    }
  }

  final List<String> pageTitles = [
    "Dashboard",
    "All Tickets",
    "SLA Breaches",
    "My Queue",
    "Agents",
    "Tickets",
    "Departments",
    "SLA Policies",
    "Categories",
    "Knowledge Base",
    "Reports",
    "Settings",
    "Profile",
  ];

  Widget getCurrentPage() {
    switch (selectedIndex) {
      case 0:
        return const DashboardPage();
      case 5:
        return const TicketListPage();
      case 6:
        return const DepartmentPage();
      case 7:
        return const SlaListPage();
      case 8:
        return const CategoryPage();
      case 9:
        return const KbPage();
      case 10:
        return const Center(child: Text("Reports"));
      case 11:
        return const Center(child: Text("Settings"));
      case 12:
        return const Center(child: Text("Profile"));
      default:
        return Center(
          child: Text(
            pageTitles[selectedIndex],
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        );
    }
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, top: 18, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget drawerItem({
    required int index,
    required IconData icon,
    required String title,
    String? badge,
  }) {
    final selected = selectedIndex == index;

    return ListTile(
      selected: selected,
      selectedTileColor: const Color(0xff2563EB),
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: badge != null
          ? CircleAvatar(
              radius: 10,
              backgroundColor: Colors.red,
              child: Text(
                badge,
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            )
          : null,
      onTap: () {
        setState(() {
          selectedIndex = index;
          updateBottomIndex();
        });
        Navigator.pop(context);
      },
    );
  }

  void onBottomTap(int index) {
    setState(() {
      bottomIndex = index;
      switch (index) {
        case 0:
          selectedIndex = 5;
          break;
        case 1:
          selectedIndex = 2;
          break;
        case 2:
          selectedIndex = 10;
          break;
        case 3:
          selectedIndex = 9;
          break;
        case 4:
          selectedIndex = 11;
          break;
      }
    });
  }

  void logout() async {
    await TokenStorage.clearToken();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xffF8FAFC),

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
          title: Text(pageTitles[selectedIndex]),
        ),

        drawer: Drawer(
          backgroundColor: const Color(0xff0B1E36),

          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.support_agent, color: Colors.white, size: 34),
                    SizedBox(width: 10),
                    Text(
                      "HelpDesk Pro",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        sectionTitle("MAIN"),

                        drawerItem(
                          index: 0,
                          icon: Icons.dashboard,
                          title: "Dashboard",
                        ),

                        drawerItem(
                          index: 1,
                          icon: Icons.confirmation_num,
                          title: "All Tickets",
                        ),

                        drawerItem(
                          index: 2,
                          icon: Icons.warning,
                          title: "SLA Breaches",
                          badge: "3",
                        ),

                        drawerItem(index: 3, icon: Icons.list, title: "My Queue"),

                        sectionTitle("MANAGE"),

                        drawerItem(index: 4, icon: Icons.people, title: "Agents"),

                        drawerItem(index: 5, icon: Icons.support, title: "Tickets"),

                        drawerItem(index: 6, icon: Icons.apartment, title: "Departments"),

                        drawerItem(index: 7, icon: Icons.timer, title: "SLA Policies"),

                        drawerItem(index: 8, icon: Icons.category, title: "Categories"),

                        drawerItem(index: 9, icon: Icons.menu_book, title: "Knowledge Base"),

                        drawerItem(index: 10, icon: Icons.bar_chart, title: "Reports"),

                        sectionTitle("SYSTEM"),

                        drawerItem(index: 11, icon: Icons.settings, title: "Settings"),

                        // ← PROFILE — Settings thazhey
                        drawerItem(index: 12, icon: Icons.person, title: "Profile"),

                        // ← LOGOUT
                        ListTile(
                          leading: const Icon(Icons.logout, color: Colors.redAccent),
                          title: const Text(
                            "Logout",
                            style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            Navigator.pop(context); // drawer close
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Logout"),
                                content: const Text("Logout cheyyaano?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: logout,
                                    child: const Text(
                                      "Logout",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        body: getCurrentPage(),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: bottomIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          onTap: onBottomTap,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_num),
              label: "Tickets",
            ),
            BottomNavigationBarItem(
              icon: Badge(label: Text("3"), child: Icon(Icons.notifications)),
              label: "Alerts",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: "Reports",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "KB"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}