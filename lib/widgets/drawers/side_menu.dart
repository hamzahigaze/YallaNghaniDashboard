import 'package:flutter/material.dart';
import 'package:yalla_dashboard/providers/token.dart';
import 'package:yalla_dashboard/screens/accounts/accounts_screen.dart';
import 'package:yalla_dashboard/screens/public/login.dart';
import 'package:yalla_dashboard/screens/offered_courses/offered_courses_screen.dart';
import 'package:yalla_dashboard/screens/parents/parents_screen.dart';
import 'package:yalla_dashboard/screens/teachers/teachers_screen.dart';
import 'package:yalla_dashboard/services/storage_service/storage_service.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key key}) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Center(
              child: Image(
                image: AssetImage('./assets/images/yalla.png'),
              ),
            ),
          ),
          _buildPageNavigator(
            text: 'الحسابات',
            icon: Icons.person,
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => AccountsScreen()));
            },
          ),
          _buildPageNavigator(
            text: 'المستخدمين',
            icon: Icons.person,
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => ParentsScreen()));
            },
          ),
          _buildPageNavigator(
            text: 'المعلمين',
            icon: Icons.person,
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => TeachersScreen()));
            },
          ),
          _buildPageNavigator(
            text: 'الدورات',
            icon: Icons.person,
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => OfferedCoursesScreen()));
            },
          ),
          _buildPageNavigator(
            text: 'تسجيل الخروج',
            icon: Icons.logout,
            onTap: () async {
              await StorageService().remove('yalla_admin_token');
              print('token was deleted');
              TokenProvider().setToken(null);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => LoginScreen()));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPageNavigator({
    String text,
    IconData icon,
    void Function() onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: Colors.blue,
      ),
      title: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
