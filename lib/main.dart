import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shopping/productsList.dart';
import 'register.dart';
import 'splash.dart';
import 'login.dart';
import 'home.dart';
import 'phone.dart';
import 'editProfile.dart';
import 'forgotPassword.dart';
import 'ShopMainScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Declaring Auth Variables
  AuthLink authLink;
  HttpLink httpLink;
  // Declaring GraphQLClient for connection
  ValueNotifier<GraphQLClient> client;

  @override
  void initState() {
    super.initState();
    // Setting up network with GraphQL Server
    authLink = AuthLink(
        getToken: () async =>
            'Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Ik0wTTNOVVV3UmpVNU0wSkZRalpDUkRsQ05URTNOVFk1T0RnME5EaEJNVGRDTUVORU1EQkNOZyJ9.eyJodHRwczovL2hhc3VyYS5pby9qd3QvY2xhaW1zIjp7IngtaGFzdXJhLWRlZmF1bHQtcm9sZSI6InVzZXIiLCJ4LWhhc3VyYS1hbGxvd2VkLXJvbGVzIjpbInVzZXIiXSwieC1oYXN1cmEtdXNlci1pZCI6Imdvb2dsZS1vYXV0aDJ8MTEyOTQxMTk3Nzk4NzE3OTk4MTIxIn0sImdpdmVuX25hbWUiOiJSaHl0aG0iLCJmYW1pbHlfbmFtZSI6Ikd1cHRhIiwibmlja25hbWUiOiJyaHl0aG1ndXB0YTEyMzQiLCJuYW1lIjoiUmh5dGhtIEd1cHRhIiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS8tQjlLZTV4SE9hVGcvQUFBQUFBQUFBQUkvQUFBQUFBQUFBalUvQU1adXVjbjB4YlllUy1ZWE0tam0zQzUyc1JNTElyZGl2QS9waG90by5qcGciLCJsb2NhbGUiOiJlbiIsInVwZGF0ZWRfYXQiOiIyMDIwLTA3LTAyVDAwOjQ0OjI5LjE0NFoiLCJpc3MiOiJodHRwczovL2dlbmVzaXNwb3J0YWwuYXV0aDAuY29tLyIsInN1YiI6Imdvb2dsZS1vYXV0aDJ8MTEyOTQxMTk3Nzk4NzE3OTk4MTIxIiwiYXVkIjoiQUtsMDZ3NURKT3lraWdXZklWZ1JLdE40NWc3NDIzMUMiLCJpYXQiOjE1OTM2NTA2NjksImV4cCI6MTExOTM2NTA2NjcsImF0X2hhc2giOiJFdFJNTjZrOGcta0N3Qjk2M2RfTWxnIiwibm9uY2UiOiJSOV9hbjlIZzlwdEFKMjQ3Rk5lMUdacDJ6Q19zZERNeSJ9.hf1_X1-hfGGb_cErpbdsXWQQk57WRUd1r9F5ZowZdCCGPp3-_hUBT0xjh_xfnPvxpkxx8Bz6o3TipHNfK_VFqnptMhvimp3hNEFGVe7FoR9JuhAEWMbGaPq_k9fRCeLxDDeUqPinpZcKi_DHv23B611SI7n9SIrhsI5qaiKF1nW5Z9hf2lrjq26u94yVaX4mYAiGPVdGNl4unLClA-TzoNrmLu1lrid47wJxxx1JGF361XhBnPSIY1pE0Go0x3RnzN416SdaLhVx1varzSNiiloO4rZzuMpAdzrzloNkzOUx1ORTrH8WagGzCepjSsrOTyYDq6uJ10mscykySieDpg');
    httpLink =
        HttpLink(uri: 'https://definite-rabbit-51.hasura.app/v1/graphql');
    Link link = authLink.concat(httpLink);
    client = ValueNotifier(GraphQLClient(link: link, cache: InMemoryCache()));
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.green,
            ),
            home: SplashPage(),
            routes: <String, WidgetBuilder>{
              '/home': (BuildContext context) => HomePage(title: 'Home'),
              '/login': (BuildContext context) => LoginPage(),
              '/register': (BuildContext context) => RegisterPage(),
              '/phone': (BuildContext context) => PhonePage(),
              '/editProfile': (BuildContext context) => EditProfilePage(),
              '/forgotPassword': (BuildContext context) => ForgotPasswordPage(),
              '/shopMainScreen': (BuildContext context) => ShopMainScreen(),
              '/productsList': (BuildContext context) => ProductsList(),
            }),
      ),
    );
  }
}
