import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'collections/bank_name.dart';
import 'collections/bank_price.dart';
import 'collections/config.dart';
import 'collections/emoney_name.dart';
import 'collections/income.dart';
import 'collections/login_account.dart';
import 'collections/money.dart';
import 'collections/spend_item.dart';
import 'collections/spend_time_place.dart';
import 'page_size_checker.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final int size = getOsPageSize();
  debugPrint('⚙️  OS page size = $size bytes'); // 16384 なら 16 KB

  final Directory dir = await getApplicationSupportDirectory();

  // ignore: always_specify_types
  final Isar isar = await Isar.open([
    BankNameSchema,
    BankPriceSchema,
    EmoneyNameSchema,
    IncomeSchema,
    MoneySchema,
    SpendTimePlaceSchema,
    SpendItemSchema,
    ConfigSchema,
    LoginAccountSchema
  ], directory: dir.path);

  await SystemChrome.setPreferredOrientations(
          <DeviceOrientation>[DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(ProviderScope(child: MyApp(isar: isar))));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key, required this.isar});

  final Isar isar;

  ///
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      // ignore: always_specify_types
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const <Locale>[
        Locale('en'),
        Locale('ja'),
      ],
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.kiwiMaru(textStyle: const TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
        ),
        useMaterial3: false,
        colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark),
        fontFamily: 'KiwiMaru',
      ),
      themeMode: ThemeMode.dark,
      title: 'money note',
      debugShowCheckedModeBanner: false,
      home: GestureDetector(onTap: () => primaryFocus?.unfocus(), child: HomeScreen(isar: isar)),
    );
  }
}
