//------------------------------------------------------------------------------

// STANDARD LIBRARIES
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:loverquest/l10n/app_localization.dart';
import 'package:loverquest/logics/settings_logics/language_switch.dart';

// CUSTOM FILES
import 'package:loverquest/pages/homepage_pages/play_main_page.dart';
import 'package:loverquest/pages/homepage_pages/deck_list_main_page.dart';
import 'package:loverquest/pages/homepage_pages/settings_main_page.dart';


//------------------------------------------------------------------------------



// APP ENTRY POINT
void main() async {

  // FORCING STATUS BAR LIGHT THEME AND NAVBAR DARK THEME
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,                         // STATUS BAR BACKGROUND CLEAR
    statusBarIconBrightness: Brightness.light,                  // STATUS BAR WHITE ICONS
    systemNavigationBarColor: Colors.black,                     // NAVBAR BLACK BACKGROUND
    systemNavigationBarIconBrightness: Brightness.light,        // NAVBAR WHITE ICONS
  ));

  WidgetsFlutterBinding.ensureInitialized();

  //
  final localeProvider = LocaleProvider();
  await localeProvider.loadLocale();


  // APP START
  runApp(
    ChangeNotifierProvider(
      create: (context) => localeProvider,
      child: MyApp(),
    ),
  );

}



//------------------------------------------------------------------------------


// APP DEFINITION
class MyApp extends StatelessWidget {

  // CLASS CONSTRUCTOR
  const MyApp({super.key});

  // APP CONTENT START
  @override
  Widget build(BuildContext context) {

    // INITIALIZATION OF THE LOCALE INFORMATION
    final localeProvider = Provider.of<LocaleProvider>(context);

    // APP MAIN SETTINGS
    return MaterialApp(

      // HIDING DEBUG LABEL
      debugShowCheckedModeBanner: false,

      // DEFINING APP THEME
      theme : ThemeData(

        // APP GENERAL THEME
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,                      // THEME TYPE
          primary: Colors.white10,                          // PRIMARY COLOR
          onPrimary: Colors.white,                          // ELEMENTS ON PRIMARY COLOR
          secondary: Color.fromRGBO(106, 65, 117, 1.0),     // SECONDARY COLOR
          onSecondary: Colors.white,                        // ELEMENTS ON SECONDARY COLOR
          error: Colors.red,                                // ERRORS COLOR
          onError: Colors.white,                            // ELEMENTS ON ERRORS COLOR
          surface: Colors.black,                            // APP MAIN COLOR
          onSurface: Colors.white,                          // ELEMENTS CON MAIN COLOR
        ),

        // POP-UP MENU THEME
        popupMenuTheme: PopupMenuThemeData(

          // BACKGROUND COLOR
          color: Colors.grey[900],

          //BORDER SETTINGS
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),

          // TEXT STYLE
          textStyle: TextStyle(color: Colors.white),

        ),

        // ALERT DIALOG THEME
        dialogTheme: DialogTheme(

          // BACKGROUND COLOR
          backgroundColor: Colors.grey[900],

          //BORDER SETTINGS
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),

          // TEXT STYLE
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),

        ),

        ),

      // LOADING THE LOCALE INFO
      locale: localeProvider.locale,

      // LIST OF THE SUPPORTED LOCALIZATION
      supportedLocales: [
        Locale('en', ''),
        Locale('it', ''),
      ],

      // LOADING THE TRANSLATION
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],


      // CHECKING IF THE USER LANGUAGE IS SUPPORTED, IF NO IT WILL BE REVERTED TO ENGLISH
      localeResolutionCallback: (locale, supportedLocales) {

        // SCROLLING EVERY SUPPORTED LANGUAGE FROM THE SUPPORTED LANG LIST
        for (var supportedLocale in supportedLocales) {

          // CHECKING IF THE USER LANGUAGE IS SUPPORTED
          if (supportedLocale.languageCode == locale?.languageCode) {

            // RETURNING THE USER VALUE
            return supportedLocale;

          }

        }

        // RETURNING THE DEFAULT VALUE
        return supportedLocales.first;

      },


      // DEFINING THE MAIN SCREEN
      home: const MainScreen(),

    );

  }

}



//------------------------------------------------------------------------------



// MAIN SCREEN DEFINITION
class MainScreen extends StatefulWidget {

  // CLASS CONSTRUCTOR
  const MainScreen({super.key});

  @override

  // DEFINING PAGE LINKED STATE
  State<MainScreen> createState() => _MainScreenState();

}



//------------------------------------------------------------------------------



// MAIN SCREEN CONTENT - MAIN SCREEN STATE
class _MainScreenState extends State<MainScreen> {

  // DEFINING NAVBAR PAGES INDEX
  int currentPageIndex = 0;

  // LIST OF NAVBAR MAIN SCREEN PAGES
  final List<Widget> _screens = [
    const PlayMainPage(),
    const DeckSelectionPage(),
    const SettingsMainPage(),
  ];

  @override
  Widget build(BuildContext context) {

    // SCAFFOLD ENTRY POINT
    return Scaffold(

      //------------------------------------------------------------------------------

      // DEFINING NAVBAR
      bottomNavigationBar: NavigationBar(

        // NAVBAR PAGES SWITCH
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },

        // DEFINING NAVBAR THEME
        indicatorColor: Theme.of(context).colorScheme.primary,

        // DEFINING NAVBAR PAGE SELECTION
        selectedIndex: currentPageIndex,

        // DEFINING NAVBAR ITEMS
        destinations: <Widget>[

          // NAVBAR PLAY PAGE SETTINGS
          NavigationDestination(
            selectedIcon: Icon(Icons.gamepad),
            icon: Icon(Icons.gamepad_outlined),
            label: AppLocalizations.of(context)!.navbar_play_button_label,
          ),

          // NAVBAR DECKS PAGE SETTINGS
          NavigationDestination(
            selectedIcon: Icon(Icons.subscriptions),
            icon: Icon(Icons.subscriptions_outlined),
            label: AppLocalizations.of(context)!.navbar_decks_button_label,
          ),

          // NAVBAR SETTINGS PAGE SETTINGS
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: AppLocalizations.of(context)!.navbar_settings_button_label,
          ),

        ],

      ),

      //------------------------------------------------------------------------------

      // DEFINING BODY CONTENT
      body: SafeArea(child: _screens[currentPageIndex],),

      //------------------------------------------------------------------------------

    );

  }

}



//------------------------------------------------------------------------------