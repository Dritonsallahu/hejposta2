import 'package:flutter/material.dart';
import 'package:hejposta/providers/buyer_provider.dart';
import 'package:hejposta/providers/city_provider.dart';
import 'package:hejposta/providers/client_order_provider.dart';
import 'package:hejposta/providers/connection_provider.dart';
import 'package:hejposta/providers/equalization_provider.dart';
import 'package:hejposta/providers/expence_provider.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/providers/offer_provider.dart';
import 'package:hejposta/providers/postman_order_provider.dart';
import 'package:hejposta/providers/product_provider.dart';
import 'package:hejposta/providers/salaries_provider.dart';
import 'package:hejposta/providers/theme_provider.dart';
import 'package:hejposta/providers/unit_provider.dart';
import 'package:hejposta/providers/user_provider.dart'; 
import 'package:hejposta/views/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
       providers: [
         ChangeNotifierProvider(create: (_) => ThemeProvider()),
         ChangeNotifierProvider(create: (_) => GeneralProvider()),
         ChangeNotifierProvider(create: (_) => ConnectionProvider()),
         ChangeNotifierProvider(create: (_) => ClientOrderProvider()),
         ChangeNotifierProvider(create: (_) => PostmanOrderProvider()),
         ChangeNotifierProvider(create: (_) => UserProvider()),
         ChangeNotifierProvider(create: (_) => CityProvier()),
         ChangeNotifierProvider(create: (_) => OfferProvider()),
         ChangeNotifierProvider(create: (_) => UnitProvider()),
         ChangeNotifierProvider(create: (_) => ExpenceProvider()),
         ChangeNotifierProvider(create: (_) => PostmanSalariesProvier()),
         ChangeNotifierProvider(create: (_) => EqualizationProvier()),
         ChangeNotifierProvider(create: (_) => ProductProvider()),
         ChangeNotifierProvider(create: (_) => EqualizedOrdersProvier()),
         ChangeNotifierProvider(create: (_) => BuyerProvider()),
       ],
      child: const MaterialApp(
        title: 'Hejposta',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        home: SplashScreen()
      ),
    );
  }
}


