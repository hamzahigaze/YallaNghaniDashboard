import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:yalla_dashboard/cubits/accounts/accounts_cubit_cubit.dart';
import 'package:yalla_dashboard/cubits/offered_courses/offered_courses_cubit.dart';
import 'package:yalla_dashboard/cubits/parents/parents_cubit.dart';
import 'package:yalla_dashboard/cubits/teachers/teachers_cubit.dart';
import 'package:yalla_dashboard/providers/accounts_provider.dart';
import 'package:yalla_dashboard/providers/offered_courses_provider.dart';
import 'package:yalla_dashboard/providers/parents_provider.dart';
import 'package:yalla_dashboard/providers/teachers_provider.dart';
import 'package:yalla_dashboard/providers/token.dart';
import 'package:yalla_dashboard/screens/accounts/accounts_screen.dart';
import 'package:yalla_dashboard/screens/parents/parents_screen.dart';
import 'package:yalla_dashboard/screens/public/login.dart';
import 'package:yalla_dashboard/screens/teachers/teachers_screen.dart';
import 'package:yalla_dashboard/services/storage_service/storage_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AccountsProvider()),
        ChangeNotifierProvider(create: (_) => ParentsProvider()),
        ChangeNotifierProvider(create: (_) => OfferedCoursesProvider()),
        ChangeNotifierProvider(create: (_) => TeachersProvider())
      ],
      child: Builder(builder: (context) {
        return MultiBlocProvider(
          providers: [
            // BlocProvider(create: (_) => IdentityCubit()..checkForIdentity()),
            BlocProvider(
              create: (context) => AccountsCubit(
                Provider.of<AccountsProvider>(context, listen: false),
              ),
            ),
            BlocProvider(
              create: (context) => ParentsCubit(
                Provider.of<ParentsProvider>(context, listen: false),
              ),
            ),
            BlocProvider(
              create: (context) => OfferedCoursesCubit(
                Provider.of<OfferedCoursesProvider>(context, listen: false),
              ),
            ),
            BlocProvider(
              create: (context) => TeachersCubit(
                Provider.of<TeachersProvider>(context, listen: false),
              ),
            )
          ],
          child: MyApp(),
        );
      }),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'يلا نغني - إدارة',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: FutureBuilder(
          future: () async {
            print('Start searching for token');
            String token = await StorageService().read('yalla_admin_token');
            if (token != null) {
              print('Found a token');
              TokenProvider().setToken(token);
              return true;
            }
            print('No token was found');
            return false;
          }(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == true) return AccountsScreen();
              return LoginScreen();
            }

            if (snapshot.connectionState == ConnectionState.waiting)
              return CircularProgressIndicator();

            return Center(
              child: Text('فشل التحميل. الرجاء إعادة تحميل الصفحة'),
            );
          },
        ),
      ),
    );
  }
}
