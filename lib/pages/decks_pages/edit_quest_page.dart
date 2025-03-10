//------------------------------------------------------------------------------

// STANDARD LIBRARIES
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loverquest/l10n/app_localization.dart';

// CUSTOM FILES
import 'package:loverquest/logics/decks_logics/quests_reader.dart';
import 'package:loverquest/logics/settings_logics/utility.dart';
import 'package:loverquest/logics/decks_logics/save_deck.dart';

//------------------------------------------------------------------------------



// DECK SELECTION PAGE DEFINITION
class QuestEditPage extends StatefulWidget {

  // CLASS ATTRIBUTES
  final DeckReader selected_deck;
  final Quest? selected_quest;


  // CLASS CONSTRUCTOR
  const QuestEditPage({
    required this.selected_deck,
    this.selected_quest,
    super.key,
  });

  // LINK TO CLASS STATE / WIDGET CONTENT
  @override
  State<QuestEditPage> createState() {
    return _QuestEditPageState();
  }

}



//------------------------------------------------------------------------------



// CLASS STATE / WIDGET CONTENT
class _QuestEditPageState extends State<QuestEditPage> {

  //------------------------------------------------------------------------------

  // DEFINING PLAYERS NAMES TEXT FIELD TEXT CONTROLLER
  TextEditingController _quest_tool_controller = TextEditingController();
  TextEditingController _quest_timer_controller = TextEditingController();
  TextEditingController _quest_content_controller = TextEditingController();

  //------------------------------------------------------------------------------

  // DEFINING THE TOOL LIST VAR
  List<String> tools_list = [];

  //------------------------------------------------------------------------------

  // DEFINING THE QUEST TIMER VAR
  int quest_timer = 0;

  //------------------------------------------------------------------------------

  // SETTING THE COUPLE TYPE AND GAME TYPE INITIAL VALUE
  String selected_option_quest_type = 'early';

  //------------------------------------------------------------------------------

  // INITIALIZING THE GLOBAL SWITCHES VARIABLES
  bool item_1 = false; bool item_2 = false; bool item_3 = false; bool item_4 = false;
  bool item_5 = false; bool item_6 = false; bool item_7 = false; bool item_8 = false;
  bool item_9 = false; bool item_10 = false; bool item_11 = false; bool item_12 = false;
  bool item_13 = false; bool item_14 = false; bool item_15 = false; bool item_16 = false;
  bool item_17 = false; bool item_18 = false; bool item_19 = false; bool item_20 = false;
  bool item_21 = false; bool item_22 = false; bool item_23 = false; bool item_24 = false;
  bool item_25 = false; bool item_26 = false; bool item_27 = false; bool item_28 = false;
  bool item_29 = false; bool item_30 = false;

  //------------------------------------------------------------------------------

  // SHOWING THE CONFIRMATION OF QUEST DELETION
  Future<void> show_confirmation_dialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(

          // DIALOG TITLE
          title: Text(AppLocalizations.of(context)!.deck_management_delete_dialog_title, style: TextStyle(fontSize: 18.5,), textAlign: TextAlign.center,),

          // DIALOG CONTENT
          content: Text(AppLocalizations.of(context)!.deck_management_delete_dialog_subtitle, style: TextStyle(fontSize: 16,), textAlign: TextAlign.center,),

          // DIALOG BUTTONS
          actions: [

            // BUTTONS ROW
            Row(

              // ALIGNMENT
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              // ROW CONTENT
              children: [

                // YES BUTTON
                TextButton(

                  // BUTTON STYLE PARAMETERS
                  style: ButtonStyle(

                    // NORMAL TEXT COLOR
                    foregroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.onPrimary),

                    // NORMAL BACKGROUND COLOR
                    backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.secondary),

                    // PADDING
                    padding: WidgetStateProperty.all(EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5)),

                    // BORDER RADIUS
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),

                  ),

                  // FUNCTION
                  onPressed: () async {

                    // REMOVING THE QUEST FROM THE LIST
                    widget.selected_deck.quests.remove(widget.selected_quest);

                    // SAVING THE MODIFIED DECK FILE
                    await DeckSaver.save_deck(
                      deck_name: widget.selected_deck.summary.name,
                      deck_description: widget.selected_deck.summary.description,
                      deck_language: widget.selected_deck.summary.language,
                      couple_type: widget.selected_deck.summary.couple_type,
                      play_distance: widget.selected_deck.summary.play_distance,
                      selected_deck: widget.selected_deck,
                    );

                    // CLOSING THE DIALOG
                    Navigator.of(context).pop();

                  },

                  // BUTTON TEXT
                  child: Text(AppLocalizations.of(context)!.deck_management_delete_dialog_yes_button_label),

                ),

                // NO BUTTON
                TextButton(

                  // BUTTON STYLE PARAMETERS
                  style: ButtonStyle(

                    // NORMAL TEXT COLOR
                    foregroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.onPrimary),

                    // NORMAL BACKGROUND COLOR
                    backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.secondary),

                    // PADDING
                    padding: WidgetStateProperty.all(EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5)),

                    // BORDER RADIUS
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),

                  ),

                  // FUNCTION
                  onPressed: () {

                    // CLOSING THE DIALOG
                    Navigator.of(context).pop();

                  },

                  // BUTTON TEXT
                  child: Text(AppLocalizations.of(context)!.deck_management_delete_dialog_no_button_label),

                ),

              ],

            ),

          ],

        );

      },

    );

  }

  //------------------------------------------------------------------------------

  // RELEASING CONTROLLERS WHEN THE PAGE IS DISMISSED
  @override
  void initState() {
    super.initState();

    // IMPORTING PREVIOUS DATA IF PRESENT
    tools_list = widget.selected_quest?.required_tools ?? [];
    selected_option_quest_type = widget.selected_quest?.moment ?? 'early';

    // SET-UPPING THE TEXT FIELD CONTROLLERS
    _quest_tool_controller = TextEditingController(text: tools_list.join(", "));
    _quest_timer_controller = TextEditingController(text: widget.selected_quest?.timer.toString() ?? "0");
    _quest_content_controller = TextEditingController(text: widget.selected_quest?.content ?? "");

  }

  @override
  void dispose() {
    _quest_tool_controller.dispose();
    _quest_timer_controller.dispose();
    _quest_content_controller.dispose();
    super.dispose();
  }

  //------------------------------------------------------------------------------

  // CHECKING CONTINUE TO NEXT PAGE CONDITION
  Future<void> check_and_save_quest() async {

    // INITIALIZING THE FIELDS VARIABLES
    quest_timer = int.tryParse(_quest_timer_controller.text) ?? 0;
    String quest_content = _quest_content_controller.text.trim();

    // CHECKING THAT ALL MANDATORY FIELDS HAS BEEN COMPILED
    if (quest_content == "") {

      // SHOWING ERROR POPUP
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(

          // POP-UP CONTENT
          content: Row(

            // ALIGNMENT
            mainAxisAlignment: MainAxisAlignment.center,

            // SIZE
            mainAxisSize: MainAxisSize.max,

            // ROW CONTENT
            children: [

              // ERROR TEXT
              Flexible(

                child: Text(
                  // TEXT
                  AppLocalizations.of(context)!.define_players_name_error_label,

                  // TEXT STYLE
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color.fromRGBO(226, 226, 226, 1.0),
                  ),

                  // TEXT GO TO NEXT ROW
                  softWrap: true,

                  // MAX NUMBERS OF TEXT LINE
                  maxLines: 3,

                  // WHAT SHOW IF LONGER
                  overflow: TextOverflow.ellipsis,

                ),

              )

            ],

          ),

          // POP-UP DURATION
          duration: Duration(seconds: 4),

          // POP-UP BACKGROUND COLOR
          backgroundColor: Color.fromRGBO(73, 32, 32, 1.0),

        ),
      );

    } else {

      try {
        
        // CHECKING IF THE QUEST IS AN EDITED ONE
        if (widget.selected_quest != null) {
          
          // DELETING THE QUEST FROM THE LIST
          widget.selected_deck.quests.remove(widget.selected_quest);
          
        }

        // CREATING A NEW QUEST
        Quest new_quest = Quest(
          moment: selected_option_quest_type,
          required_tools: tools_list,
          timer: quest_timer,
          content: quest_content,
        );

        // SAVING THE QUEST AND THE DECK
        await DeckSaver.save_quest(
          selected_deck: widget.selected_deck,
          new_quest: new_quest,
        );

        // GOING BACK TO THE MAIN EDIT PAGE
        Navigator.pop(context);


      } catch (e) {
        // ERROR
      }

    }

  }

  //------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    //------------------------------------------------------------------------------

    // SHOW TOOLS SELECTION DIALOG
    Future<void> show_tools_dialog(BuildContext context) async {
      return showDialog<void>(
        context: context,
        builder: (context) {

          //------------------------------------------------------------------------------

          // USING A STATEFUL BUILDER IN ORDER TO CORRECTLY RENDER THE PAGE CHANGES
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateDialog) {

              // DIALOG
              return Dialog(

                child: SingleChildScrollView(

                  // SCROLLABLE CONTAINER CONTENT
                  child: Container(

                    // PAGE PADDING
                    padding: EdgeInsets.all(10),

                    // PAGE ALIGNMENT
                    alignment: Alignment.topCenter,

                    // CONTAINER CONTENT
                    child: Column(

                      // SIZE
                      mainAxisSize: MainAxisSize.min,

                      // ALIGNMENT
                      crossAxisAlignment: CrossAxisAlignment.center,

                      // COLUMN CONTENT
                      children: [

                        //------------------------------------------------------------------------------

                        // SPACER
                        SizedBox(height: 15),

                        //------------------------------------------------------------------------------

                        // DIALOG TITLE
                        Text(

                          // TEXT
                          AppLocalizations.of(context)!.quest_editor_page_tools_dialog_title,

                          // ALIGNMENT
                          textAlign: TextAlign.center,

                          // STYLE
                          style: TextStyle(

                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,

                          ),

                        ),

                        //------------------------------------------------------------------------------

                        // SPACER
                        SizedBox(height: 15),

                        //------------------------------------------------------------------------------

                        // ITEM 1
                        SwitchListTile(

                          // SWITCH TITLE
                          title: Text(AppLocalizations.of(context)!.quest_tool_female_lingerie.capitalize_first()),

                          // SWITCH VALUE
                          value: item_1,

                          // SWITCH FUNCTION
                          onChanged: (bool value) {
                            setStateDialog(() {
                              item_1 = value;

                              // CHECKING IF THE TOOL IS ALREADY INSIDE THE TOOL LIST
                              if (tools_list.contains(AppLocalizations.of(context)!.quest_tool_female_lingerie)) {

                                // DELETING THE TOOL FROM TO THE TOOL LIST
                                tools_list.remove(AppLocalizations.of(context)!.quest_tool_female_lingerie);

                              } else {

                                // ADDING THE TOOL TO THE TOOL LIST
                                tools_list.add(AppLocalizations.of(context)!.quest_tool_female_lingerie);

                              }

                            });
                          },

                          // SWITCH COLOR
                          activeColor: Theme.of(context).colorScheme.onSecondary,
                          activeTrackColor: Theme.of(context).colorScheme.secondary,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
                          inactiveTrackColor: Colors.black45,

                        ),

                        //------------------------------------------------------------------------------

                        // ITEM 2
                        SwitchListTile(

                          // SWITCH TITLE
                          title: Text(AppLocalizations.of(context)!.quest_tool_male_lingerie.capitalize_first()),

                          // SWITCH VALUE
                          value: item_2,

                          // SWITCH FUNCTION
                          onChanged: (bool value) {
                            setStateDialog(() {
                              item_2 = value;

                              // CHECKING IF THE TOOL IS ALREADY INSIDE THE TOOL LIST
                              if (tools_list.contains(AppLocalizations.of(context)!.quest_tool_male_lingerie)) {

                                // DELETING THE TOOL FROM TO THE TOOL LIST
                                tools_list.remove(AppLocalizations.of(context)!.quest_tool_male_lingerie);

                              } else {

                                // ADDING THE TOOL TO THE TOOL LIST
                                tools_list.add(AppLocalizations.of(context)!.quest_tool_male_lingerie);

                              }

                            });
                          },

                          // SWITCH COLOR
                          activeColor: Theme.of(context).colorScheme.onSecondary,
                          activeTrackColor: Theme.of(context).colorScheme.secondary,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
                          inactiveTrackColor: Colors.black45,

                        ),

                        //------------------------------------------------------------------------------

                        // ITEM 3
                        SwitchListTile(

                          // SWITCH TITLE
                          title: Text(AppLocalizations.of(context)!.quest_tool_blindfold.capitalize_first()),

                          // SWITCH VALUE
                          value: item_3,

                          // SWITCH FUNCTION
                          onChanged: (bool value) {
                            setStateDialog(() {
                              item_3 = value;

                              // CHECKING IF THE TOOL IS ALREADY INSIDE THE TOOL LIST
                              if (tools_list.contains(AppLocalizations.of(context)!.quest_tool_blindfold)) {

                                // DELETING THE TOOL FROM TO THE TOOL LIST
                                tools_list.remove(AppLocalizations.of(context)!.quest_tool_blindfold);

                              } else {

                                // ADDING THE TOOL TO THE TOOL LIST
                                tools_list.add(AppLocalizations.of(context)!.quest_tool_blindfold);

                              }

                            });
                          },

                          // SWITCH COLOR
                          activeColor: Theme.of(context).colorScheme.onSecondary,
                          activeTrackColor: Theme.of(context).colorScheme.secondary,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
                          inactiveTrackColor: Colors.black45,

                        ),

                        //------------------------------------------------------------------------------

                        // ITEM 4
                        SwitchListTile(

                          // SWITCH TITLE
                          title: Text(AppLocalizations.of(context)!.quest_tool_rope.capitalize_first()),

                          // SWITCH VALUE
                          value: item_4,

                          // SWITCH FUNCTION
                          onChanged: (bool value) {
                            setStateDialog(() {
                              item_4 = value;

                              // CHECKING IF THE TOOL IS ALREADY INSIDE THE TOOL LIST
                              if (tools_list.contains(AppLocalizations.of(context)!.quest_tool_rope)) {

                                // DELETING THE TOOL FROM TO THE TOOL LIST
                                tools_list.remove(AppLocalizations.of(context)!.quest_tool_rope);

                              } else {

                                // ADDING THE TOOL TO THE TOOL LIST
                                tools_list.add(AppLocalizations.of(context)!.quest_tool_rope);

                              }

                            });
                          },

                          // SWITCH COLOR
                          activeColor: Theme.of(context).colorScheme.onSecondary,
                          activeTrackColor: Theme.of(context).colorScheme.secondary,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
                          inactiveTrackColor: Colors.black45,

                        ),

                        //------------------------------------------------------------------------------

                        // ITEM 5
                        SwitchListTile(

                          // SWITCH TITLE
                          title: Text(AppLocalizations.of(context)!.quest_tool_handcuffs.capitalize_first()),

                          // SWITCH VALUE
                          value: item_5,

                          // SWITCH FUNCTION
                          onChanged: (bool value) {
                            setStateDialog(() {
                              item_5 = value;

                              // CHECKING IF THE TOOL IS ALREADY INSIDE THE TOOL LIST
                              if (tools_list.contains(AppLocalizations.of(context)!.quest_tool_handcuffs)) {

                                // DELETING THE TOOL FROM TO THE TOOL LIST
                                tools_list.remove(AppLocalizations.of(context)!.quest_tool_handcuffs);

                              } else {

                                // ADDING THE TOOL TO THE TOOL LIST
                                tools_list.add(AppLocalizations.of(context)!.quest_tool_handcuffs);

                              }

                            });
                          },

                          // SWITCH COLOR
                          activeColor: Theme.of(context).colorScheme.onSecondary,
                          activeTrackColor: Theme.of(context).colorScheme.secondary,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
                          inactiveTrackColor: Colors.black45,

                        ),

                        //------------------------------------------------------------------------------

                        // ITEM 6
                        SwitchListTile(

                          // SWITCH TITLE
                          title: Text(AppLocalizations.of(context)!.quest_tool_dice.capitalize_first()),

                          // SWITCH VALUE
                          value: item_6,

                          // SWITCH FUNCTION
                          onChanged: (bool value) {
                            setStateDialog(() {
                              item_6 = value;

                              // CHECKING IF THE TOOL IS ALREADY INSIDE THE TOOL LIST
                              if (tools_list.contains(AppLocalizations.of(context)!.quest_tool_dice)) {

                                // DELETING THE TOOL FROM TO THE TOOL LIST
                                tools_list.remove(AppLocalizations.of(context)!.quest_tool_dice);

                              } else {

                                // ADDING THE TOOL TO THE TOOL LIST
                                tools_list.add(AppLocalizations.of(context)!.quest_tool_dice);

                              }

                            });
                          },

                          // SWITCH COLOR
                          activeColor: Theme.of(context).colorScheme.onSecondary,
                          activeTrackColor: Theme.of(context).colorScheme.secondary,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
                          inactiveTrackColor: Colors.black45,

                        ),

                        //------------------------------------------------------------------------------

                        // ITEM 7
                        SwitchListTile(

                          // SWITCH TITLE
                          title: Text(AppLocalizations.of(context)!.quest_tool_vibrator.capitalize_first()),

                          // SWITCH VALUE
                          value: item_7,

                          // SWITCH FUNCTION
                          onChanged: (bool value) {
                            setStateDialog(() {
                              item_7 = value;

                              // CHECKING IF THE TOOL IS ALREADY INSIDE THE TOOL LIST
                              if (tools_list.contains(AppLocalizations.of(context)!.quest_tool_vibrator)) {

                                // DELETING THE TOOL FROM TO THE TOOL LIST
                                tools_list.remove(AppLocalizations.of(context)!.quest_tool_vibrator);

                              } else {

                                // ADDING THE TOOL TO THE TOOL LIST
                                tools_list.add(AppLocalizations.of(context)!.quest_tool_vibrator);

                              }

                            });
                          },

                          // SWITCH COLOR
                          activeColor: Theme.of(context).colorScheme.onSecondary,
                          activeTrackColor: Theme.of(context).colorScheme.secondary,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
                          inactiveTrackColor: Colors.black45,

                        ),

                        //------------------------------------------------------------------------------

                        // ITEM 8
                        SwitchListTile(

                          // SWITCH TITLE
                          title: Text(AppLocalizations.of(context)!.quest_tool_remote_vibrator.capitalize_first()),

                          // SWITCH VALUE
                          value: item_8,

                          // SWITCH FUNCTION
                          onChanged: (bool value) {
                            setStateDialog(() {
                              item_8 = value;

                              // CHECKING IF THE TOOL IS ALREADY INSIDE THE TOOL LIST
                              if (tools_list.contains(AppLocalizations.of(context)!.quest_tool_remote_vibrator)) {

                                // DELETING THE TOOL FROM TO THE TOOL LIST
                                tools_list.remove(AppLocalizations.of(context)!.quest_tool_remote_vibrator);

                              } else {

                                // ADDING THE TOOL TO THE TOOL LIST
                                tools_list.add(AppLocalizations.of(context)!.quest_tool_remote_vibrator);

                              }

                            });
                          },

                          // SWITCH COLOR
                          activeColor: Theme.of(context).colorScheme.onSecondary,
                          activeTrackColor: Theme.of(context).colorScheme.secondary,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
                          inactiveTrackColor: Colors.black45,

                        ),

                        //------------------------------------------------------------------------------

                        // ITEM 9
                        SwitchListTile(

                          // SWITCH TITLE
                          title: Text(AppLocalizations.of(context)!.quest_tool_anal_beads.capitalize_first()),

                          // SWITCH VALUE
                          value: item_9,

                          // SWITCH FUNCTION
                          onChanged: (bool value) {
                            setStateDialog(() {
                              item_9 = value;

                              // CHECKING IF THE TOOL IS ALREADY INSIDE THE TOOL LIST
                              if (tools_list.contains(AppLocalizations.of(context)!.quest_tool_anal_beads)) {

                                // DELETING THE TOOL FROM TO THE TOOL LIST
                                tools_list.remove(AppLocalizations.of(context)!.quest_tool_anal_beads);

                              } else {

                                // ADDING THE TOOL TO THE TOOL LIST
                                tools_list.add(AppLocalizations.of(context)!.quest_tool_anal_beads);

                              }

                            });
                          },

                          // SWITCH COLOR
                          activeColor: Theme.of(context).colorScheme.onSecondary,
                          activeTrackColor: Theme.of(context).colorScheme.secondary,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
                          inactiveTrackColor: Colors.black45,

                        ),

                        //------------------------------------------------------------------------------

                        // ITEM 10
                        SwitchListTile(

                          // SWITCH TITLE
                          title: Text(AppLocalizations.of(context)!.quest_tool_dildo.capitalize_first()),

                          // SWITCH VALUE
                          value: item_10,

                          // SWITCH FUNCTION
                          onChanged: (bool value) {
                            setStateDialog(() {
                              item_10 = value;

                              // CHECKING IF THE TOOL IS ALREADY INSIDE THE TOOL LIST
                              if (tools_list.contains(AppLocalizations.of(context)!.quest_tool_dildo)) {

                                // DELETING THE TOOL FROM TO THE TOOL LIST
                                tools_list.remove(AppLocalizations.of(context)!.quest_tool_dildo);

                              } else {

                                // ADDING THE TOOL TO THE TOOL LIST
                                tools_list.add(AppLocalizations.of(context)!.quest_tool_dildo);

                              }

                            });
                          },

                          // SWITCH COLOR
                          activeColor: Theme.of(context).colorScheme.onSecondary,
                          activeTrackColor: Theme.of(context).colorScheme.secondary,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
                          inactiveTrackColor: Colors.black45,

                        ),

                        //------------------------------------------------------------------------------

                        // ITEM 11
                        SwitchListTile(

                          // SWITCH TITLE
                          title: Text(AppLocalizations.of(context)!.quest_tool_inflatable_dildo.capitalize_first()),

                          // SWITCH VALUE
                          value: item_11,

                          // SWITCH FUNCTION
                          onChanged: (bool value) {
                            setStateDialog(() {
                              item_11 = value;

                              // CHECKING IF THE TOOL IS ALREADY INSIDE THE TOOL LIST
                              if (tools_list.contains(AppLocalizations.of(context)!.quest_tool_inflatable_dildo)) {

                                // DELETING THE TOOL FROM TO THE TOOL LIST
                                tools_list.remove(AppLocalizations.of(context)!.quest_tool_inflatable_dildo);

                              } else {

                                // ADDING THE TOOL TO THE TOOL LIST
                                tools_list.add(AppLocalizations.of(context)!.quest_tool_inflatable_dildo);

                              }

                            });
                          },

                          // SWITCH COLOR
                          activeColor: Theme.of(context).colorScheme.onSecondary,
                          activeTrackColor: Theme.of(context).colorScheme.secondary,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
                          inactiveTrackColor: Colors.black45,

                        ),

                        //------------------------------------------------------------------------------

                        // ITEM 12
                        SwitchListTile(

                          // SWITCH TITLE
                          title: Text(AppLocalizations.of(context)!.quest_tool_suction_cup_dildo.capitalize_first()),

                          // SWITCH VALUE
                          value: item_12,

                          // SWITCH FUNCTION
                          onChanged: (bool value) {
                            setStateDialog(() {
                              item_12 = value;

                              // CHECKING IF THE TOOL IS ALREADY INSIDE THE TOOL LIST
                              if (tools_list.contains(AppLocalizations.of(context)!.quest_tool_suction_cup_dildo)) {

                                // DELETING THE TOOL FROM TO THE TOOL LIST
                                tools_list.remove(AppLocalizations.of(context)!.quest_tool_suction_cup_dildo);

                              } else {

                                // ADDING THE TOOL TO THE TOOL LIST
                                tools_list.add(AppLocalizations.of(context)!.quest_tool_suction_cup_dildo);

                              }

                            });
                          },

                          // SWITCH COLOR
                          activeColor: Theme.of(context).colorScheme.onSecondary,
                          activeTrackColor: Theme.of(context).colorScheme.secondary,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
                          inactiveTrackColor: Colors.black45,

                        ),

                        //------------------------------------------------------------------------------

                        // ITEM 13
                        SwitchListTile(

                          // SWITCH TITLE
                          title: Text(AppLocalizations.of(context)!.quest_tool_vibrating_dildo.capitalize_first()),

                          // SWITCH VALUE
                          value: item_13,

                          // SWITCH FUNCTION
                          onChanged: (bool value) {
                            setStateDialog(() {
                              item_13 = value;

                              // CHECKING IF THE TOOL IS ALREADY INSIDE THE TOOL LIST
                              if (tools_list.contains(AppLocalizations.of(context)!.quest_tool_vibrating_dildo)) {

                                // DELETING THE TOOL FROM TO THE TOOL LIST
                                tools_list.remove(AppLocalizations.of(context)!.quest_tool_vibrating_dildo);

                              } else {

                                // ADDING THE TOOL TO THE TOOL LIST
                                tools_list.add(AppLocalizations.of(context)!.quest_tool_vibrating_dildo);

                              }

                            });
                          },

                          // SWITCH COLOR
                          activeColor: Theme.of(context).colorScheme.onSecondary,
                          activeTrackColor: Theme.of(context).colorScheme.secondary,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
                          inactiveTrackColor: Colors.black45,

                        ),

                        //------------------------------------------------------------------------------

                        // ITEM 14
                        SwitchListTile(

                          // SWITCH TITLE
                          title: Text(AppLocalizations.of(context)!.quest_tool_gag.capitalize_first()),

                          // SWITCH VALUE
                          value: item_14,

                          // SWITCH FUNCTION
                          onChanged: (bool value) {
                            setStateDialog(() {
                              item_14 = value;

                              // CHECKING IF THE TOOL IS ALREADY INSIDE THE TOOL LIST
                              if (tools_list.contains(AppLocalizations.of(context)!.quest_tool_gag)) {

                                // DELETING THE TOOL FROM TO THE TOOL LIST
                                tools_list.remove(AppLocalizations.of(context)!.quest_tool_gag);

                              } else {

                                // ADDING THE TOOL TO THE TOOL LIST
                                tools_list.add(AppLocalizations.of(context)!.quest_tool_gag);

                              }

                            });
                          },

                          // SWITCH COLOR
                          activeColor: Theme.of(context).colorScheme.onSecondary,
                          activeTrackColor: Theme.of(context).colorScheme.secondary,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
                          inactiveTrackColor: Colors.black45,

                        ),

                        //------------------------------------------------------------------------------

                        // ITEM 15
                        SwitchListTile(

                          // SWITCH TITLE
                          title: Text(AppLocalizations.of(context)!.quest_tool_feather.capitalize_first()),

                          // SWITCH VALUE
                          value: item_15,

                          // SWITCH FUNCTION
                          onChanged: (bool value) {
                            setStateDialog(() {
                              item_15 = value;

                              // CHECKING IF THE TOOL IS ALREADY INSIDE THE TOOL LIST
                              if (tools_list.contains(AppLocalizations.of(context)!.quest_tool_feather)) {

                                // DELETING THE TOOL FROM TO THE TOOL LIST
                                tools_list.remove(AppLocalizations.of(context)!.quest_tool_feather);

                              } else {

                                // ADDING THE TOOL TO THE TOOL LIST
                                tools_list.add(AppLocalizations.of(context)!.quest_tool_feather);

                              }

                            });
                          },

                          // SWITCH COLOR
                          activeColor: Theme.of(context).colorScheme.onSecondary,
                          activeTrackColor: Theme.of(context).colorScheme.secondary,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
                          inactiveTrackColor: Colors.black45,

                        ),

                        //------------------------------------------------------------------------------

                        // ITEM 16
                        SwitchListTile(

                          // SWITCH TITLE
                          title: Text(AppLocalizations.of(context)!.quest_tool_plug.capitalize_first()),

                          // SWITCH VALUE
                          value: item_16,

                          // SWITCH FUNCTION
                          onChanged: (bool value) {
                            setStateDialog(() {
                              item_16 = value;

                              // CHECKING IF THE TOOL IS ALREADY INSIDE THE TOOL LIST
                              if (tools_list.contains(AppLocalizations.of(context)!.quest_tool_plug)) {

                                // DELETING THE TOOL FROM TO THE TOOL LIST
                                tools_list.remove(AppLocalizations.of(context)!.quest_tool_plug);

                              } else {

                                // ADDING THE TOOL TO THE TOOL LIST
                                tools_list.add(AppLocalizations.of(context)!.quest_tool_plug);

                              }

                            });
                          },

                          // SWITCH COLOR
                          activeColor: Theme.of(context).colorScheme.onSecondary,
                          activeTrackColor: Theme.of(context).colorScheme.secondary,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
                          inactiveTrackColor: Colors.black45,

                        ),

                        //------------------------------------------------------------------------------

                        // ITEM 17
                        SwitchListTile(

                          // SWITCH TITLE
                          title: Text(AppLocalizations.of(context)!.quest_tool_inflatable_plug.capitalize_first()),

                          // SWITCH VALUE
                          value: item_17,

                          // SWITCH FUNCTION
                          onChanged: (bool value) {
                            setStateDialog(() {
                              item_17 = value;

                              // CHECKING IF THE TOOL IS ALREADY INSIDE THE TOOL LIST
                              if (tools_list.contains(AppLocalizations.of(context)!.quest_tool_inflatable_plug)) {

                                // DELETING THE TOOL FROM TO THE TOOL LIST
                                tools_list.remove(AppLocalizations.of(context)!.quest_tool_inflatable_plug);

                              } else {

                                // ADDING THE TOOL TO THE TOOL LIST
                                tools_list.add(AppLocalizations.of(context)!.quest_tool_inflatable_plug);

                              }

                            });
                          },

                          // SWITCH COLOR
                          activeColor: Theme.of(context).colorScheme.onSecondary,
                          activeTrackColor: Theme.of(context).colorScheme.secondary,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
                          inactiveTrackColor: Colors.black45,

                        ),

                        //------------------------------------------------------------------------------

                        // ITEM 18
                        SwitchListTile(

                          // SWITCH TITLE
                          title: Text(AppLocalizations.of(context)!.quest_tool_vibrating_plug.capitalize_first()),

                          // SWITCH VALUE
                          value: item_18,

                          // SWITCH FUNCTION
                          onChanged: (bool value) {
                            setStateDialog(() {
                              item_18 = value;

                              // CHECKING IF THE TOOL IS ALREADY INSIDE THE TOOL LIST
                              if (tools_list.contains(AppLocalizations.of(context)!.quest_tool_vibrating_plug)) {

                                // DELETING THE TOOL FROM TO THE TOOL LIST
                                tools_list.remove(AppLocalizations.of(context)!.quest_tool_vibrating_plug);

                              } else {

                                // ADDING THE TOOL TO THE TOOL LIST
                                tools_list.add(AppLocalizations.of(context)!.quest_tool_vibrating_plug);

                              }

                            });
                          },

                          // SWITCH COLOR
                          activeColor: Theme.of(context).colorScheme.onSecondary,
                          activeTrackColor: Theme.of(context).colorScheme.secondary,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
                          inactiveTrackColor: Colors.black45,

                        ),

                        //------------------------------------------------------------------------------

                        // ITEM 19
                        SwitchListTile(

                          // SWITCH TITLE
                          title: Text(AppLocalizations.of(context)!.quest_tool_candle.capitalize_first()),

                          // SWITCH VALUE
                          value: item_19,

                          // SWITCH FUNCTION
                          onChanged: (bool value) {
                            setStateDialog(() {
                              item_19 = value;

                              // CHECKING IF THE TOOL IS ALREADY INSIDE THE TOOL LIST
                              if (tools_list.contains(AppLocalizations.of(context)!.quest_tool_candle)) {

                                // DELETING THE TOOL FROM TO THE TOOL LIST
                                tools_list.remove(AppLocalizations.of(context)!.quest_tool_candle);

                              } else {

                                // ADDING THE TOOL TO THE TOOL LIST
                                tools_list.add(AppLocalizations.of(context)!.quest_tool_candle);

                              }

                            });
                          },

                          // SWITCH COLOR
                          activeColor: Theme.of(context).colorScheme.onSecondary,
                          activeTrackColor: Theme.of(context).colorScheme.secondary,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
                          inactiveTrackColor: Colors.black45,

                        ),

                        //------------------------------------------------------------------------------

                        // ITEM 20
                        SwitchListTile(

                          // SWITCH TITLE
                          title: Text(AppLocalizations.of(context)!.quest_tool_collar_and_leash.capitalize_first()),

                          // SWITCH VALUE
                          value: item_20,

                          // SWITCH FUNCTION
                          onChanged: (bool value) {
                            setStateDialog(() {
                              item_20 = value;

                              // CHECKING IF THE TOOL IS ALREADY INSIDE THE TOOL LIST
                              if (tools_list.contains(AppLocalizations.of(context)!.quest_tool_collar_and_leash)) {

                                // DELETING THE TOOL FROM TO THE TOOL LIST
                                tools_list.remove(AppLocalizations.of(context)!.quest_tool_collar_and_leash);

                              } else {

                                // ADDING THE TOOL TO THE TOOL LIST
                                tools_list.add(AppLocalizations.of(context)!.quest_tool_collar_and_leash);

                              }

                            });
                          },

                          // SWITCH COLOR
                          activeColor: Theme.of(context).colorScheme.onSecondary,
                          activeTrackColor: Theme.of(context).colorScheme.secondary,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
                          inactiveTrackColor: Colors.black45,

                        ),

                        //------------------------------------------------------------------------------

                        // ITEM 21
                        SwitchListTile(

                          // SWITCH TITLE
                          title: Text(AppLocalizations.of(context)!.quest_tool_massage_oil.capitalize_first()),

                          // SWITCH VALUE
                          value: item_21,

                          // SWITCH FUNCTION
                          onChanged: (bool value) {
                            setStateDialog(() {
                              item_21 = value;

                              // CHECKING IF THE TOOL IS ALREADY INSIDE THE TOOL LIST
                              if (tools_list.contains(AppLocalizations.of(context)!.quest_tool_massage_oil)) {

                                // DELETING THE TOOL FROM TO THE TOOL LIST
                                tools_list.remove(AppLocalizations.of(context)!.quest_tool_massage_oil);

                              } else {

                                // ADDING THE TOOL TO THE TOOL LIST
                                tools_list.add(AppLocalizations.of(context)!.quest_tool_massage_oil);

                              }

                            });
                          },

                          // SWITCH COLOR
                          activeColor: Theme.of(context).colorScheme.onSecondary,
                          activeTrackColor: Theme.of(context).colorScheme.secondary,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
                          inactiveTrackColor: Colors.black45,

                        ),

                        //------------------------------------------------------------------------------

                        // ITEM 22
                        SwitchListTile(

                          // SWITCH TITLE
                          title: Text(AppLocalizations.of(context)!.quest_tool_lubricants.capitalize_first()),

                          // SWITCH VALUE
                          value: item_22,

                          // SWITCH FUNCTION
                          onChanged: (bool value) {
                            setStateDialog(() {
                              item_22 = value;

                              // CHECKING IF THE TOOL IS ALREADY INSIDE THE TOOL LIST
                              if (tools_list.contains(AppLocalizations.of(context)!.quest_tool_lubricants)) {

                                // DELETING THE TOOL FROM TO THE TOOL LIST
                                tools_list.remove(AppLocalizations.of(context)!.quest_tool_lubricants);

                              } else {

                                // ADDING THE TOOL TO THE TOOL LIST
                                tools_list.add(AppLocalizations.of(context)!.quest_tool_lubricants);

                              }

                            });
                          },

                          // SWITCH COLOR
                          activeColor: Theme.of(context).colorScheme.onSecondary,
                          activeTrackColor: Theme.of(context).colorScheme.secondary,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
                          inactiveTrackColor: Colors.black45,

                        ),

                        //------------------------------------------------------------------------------

                        // ITEM 23
                        SwitchListTile(

                          // SWITCH TITLE
                          title: Text(AppLocalizations.of(context)!.quest_tool_strap_on.capitalize_first()),

                          // SWITCH VALUE
                          value: item_23,

                          // SWITCH FUNCTION
                          onChanged: (bool value) {
                            setStateDialog(() {
                              item_23 = value;

                              // CHECKING IF THE TOOL IS ALREADY INSIDE THE TOOL LIST
                              if (tools_list.contains(AppLocalizations.of(context)!.quest_tool_strap_on)) {

                                // DELETING THE TOOL FROM TO THE TOOL LIST
                                tools_list.remove(AppLocalizations.of(context)!.quest_tool_strap_on);

                              } else {

                                // ADDING THE TOOL TO THE TOOL LIST
                                tools_list.add(AppLocalizations.of(context)!.quest_tool_strap_on);

                              }

                            });
                          },

                          // SWITCH COLOR
                          activeColor: Theme.of(context).colorScheme.onSecondary,
                          activeTrackColor: Theme.of(context).colorScheme.secondary,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
                          inactiveTrackColor: Colors.black45,

                        ),

                        //------------------------------------------------------------------------------

                        // ITEM 24
                        SwitchListTile(

                          // SWITCH TITLE
                          title: Text(AppLocalizations.of(context)!.quest_tool_nipple_clamps.capitalize_first()),

                          // SWITCH VALUE
                          value: item_24,

                          // SWITCH FUNCTION
                          onChanged: (bool value) {
                            setStateDialog(() {
                              item_24 = value;

                              // CHECKING IF THE TOOL IS ALREADY INSIDE THE TOOL LIST
                              if (tools_list.contains(AppLocalizations.of(context)!.quest_tool_nipple_clamps)) {

                                // DELETING THE TOOL FROM TO THE TOOL LIST
                                tools_list.remove(AppLocalizations.of(context)!.quest_tool_nipple_clamps);

                              } else {

                                // ADDING THE TOOL TO THE TOOL LIST
                                tools_list.add(AppLocalizations.of(context)!.quest_tool_nipple_clamps);

                              }

                            });
                          },

                          // SWITCH COLOR
                          activeColor: Theme.of(context).colorScheme.onSecondary,
                          activeTrackColor: Theme.of(context).colorScheme.secondary,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
                          inactiveTrackColor: Colors.black45,

                        ),

                        //------------------------------------------------------------------------------

                        // ITEM 25
                        SwitchListTile(

                          // SWITCH TITLE
                          title: Text(AppLocalizations.of(context)!.quest_tool_nipple_pump.capitalize_first()),

                          // SWITCH VALUE
                          value: item_25,

                          // SWITCH FUNCTION
                          onChanged: (bool value) {
                            setStateDialog(() {
                              item_25 = value;

                              // CHECKING IF THE TOOL IS ALREADY INSIDE THE TOOL LIST
                              if (tools_list.contains(AppLocalizations.of(context)!.quest_tool_nipple_pump)) {

                                // DELETING THE TOOL FROM TO THE TOOL LIST
                                tools_list.remove(AppLocalizations.of(context)!.quest_tool_nipple_pump);

                              } else {

                                // ADDING THE TOOL TO THE TOOL LIST
                                tools_list.add(AppLocalizations.of(context)!.quest_tool_nipple_pump);

                              }

                            });
                          },

                          // SWITCH COLOR
                          activeColor: Theme.of(context).colorScheme.onSecondary,
                          activeTrackColor: Theme.of(context).colorScheme.secondary,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
                          inactiveTrackColor: Colors.black45,

                        ),

                        //------------------------------------------------------------------------------

                        // ITEM 26
                        SwitchListTile(

                          // SWITCH TITLE
                          title: Text(AppLocalizations.of(context)!.quest_tool_riding_crop.capitalize_first()),

                          // SWITCH VALUE
                          value: item_26,

                          // SWITCH FUNCTION
                          onChanged: (bool value) {
                            setStateDialog(() {
                              item_26 = value;

                              // CHECKING IF THE TOOL IS ALREADY INSIDE THE TOOL LIST
                              if (tools_list.contains(AppLocalizations.of(context)!.quest_tool_riding_crop)) {

                                // DELETING THE TOOL FROM TO THE TOOL LIST
                                tools_list.remove(AppLocalizations.of(context)!.quest_tool_riding_crop);

                              } else {

                                // ADDING THE TOOL TO THE TOOL LIST
                                tools_list.add(AppLocalizations.of(context)!.quest_tool_riding_crop);

                              }

                            });
                          },

                          // SWITCH COLOR
                          activeColor: Theme.of(context).colorScheme.onSecondary,
                          activeTrackColor: Theme.of(context).colorScheme.secondary,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
                          inactiveTrackColor: Colors.black45,

                        ),

                        //------------------------------------------------------------------------------

                        // ITEM 27
                        SwitchListTile(

                          // SWITCH TITLE
                          title: Text(AppLocalizations.of(context)!.quest_tool_flogger.capitalize_first()),

                          // SWITCH VALUE
                          value: item_27,

                          // SWITCH FUNCTION
                          onChanged: (bool value) {
                            setStateDialog(() {
                              item_27 = value;

                              // CHECKING IF THE TOOL IS ALREADY INSIDE THE TOOL LIST
                              if (tools_list.contains(AppLocalizations.of(context)!.quest_tool_flogger)) {

                                // DELETING THE TOOL FROM TO THE TOOL LIST
                                tools_list.remove(AppLocalizations.of(context)!.quest_tool_flogger);

                              } else {

                                // ADDING THE TOOL TO THE TOOL LIST
                                tools_list.add(AppLocalizations.of(context)!.quest_tool_flogger);

                              }

                            });
                          },

                          // SWITCH COLOR
                          activeColor: Theme.of(context).colorScheme.onSecondary,
                          activeTrackColor: Theme.of(context).colorScheme.secondary,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
                          inactiveTrackColor: Colors.black45,

                        ),

                        //------------------------------------------------------------------------------

                        // ITEM 28
                        SwitchListTile(

                          // SWITCH TITLE
                          title: Text(AppLocalizations.of(context)!.quest_tool_spanking_paddle.capitalize_first()),

                          // SWITCH VALUE
                          value: item_28,

                          // SWITCH FUNCTION
                          onChanged: (bool value) {
                            setStateDialog(() {
                              item_28 = value;

                              // CHECKING IF THE TOOL IS ALREADY INSIDE THE TOOL LIST
                              if (tools_list.contains(AppLocalizations.of(context)!.quest_tool_spanking_paddle)) {

                                // DELETING THE TOOL FROM TO THE TOOL LIST
                                tools_list.remove(AppLocalizations.of(context)!.quest_tool_spanking_paddle);

                              } else {

                                // ADDING THE TOOL TO THE TOOL LIST
                                tools_list.add(AppLocalizations.of(context)!.quest_tool_spanking_paddle);

                              }

                            });
                          },

                          // SWITCH COLOR
                          activeColor: Theme.of(context).colorScheme.onSecondary,
                          activeTrackColor: Theme.of(context).colorScheme.secondary,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
                          inactiveTrackColor: Colors.black45,

                        ),

                        //------------------------------------------------------------------------------

                        // ITEM 29
                        SwitchListTile(

                          // SWITCH TITLE
                          title: Text(AppLocalizations.of(context)!.quest_tool_male_chastity_cage.capitalize_first()),

                          // SWITCH VALUE
                          value: item_29,

                          // SWITCH FUNCTION
                          onChanged: (bool value) {
                            setStateDialog(() {
                              item_29 = value;

                              // CHECKING IF THE TOOL IS ALREADY INSIDE THE TOOL LIST
                              if (tools_list.contains(AppLocalizations.of(context)!.quest_tool_male_chastity_cage)) {

                                // DELETING THE TOOL FROM TO THE TOOL LIST
                                tools_list.remove(AppLocalizations.of(context)!.quest_tool_male_chastity_cage);

                              } else {

                                // ADDING THE TOOL TO THE TOOL LIST
                                tools_list.add(AppLocalizations.of(context)!.quest_tool_male_chastity_cage);

                              }

                            });
                          },

                          // SWITCH COLOR
                          activeColor: Theme.of(context).colorScheme.onSecondary,
                          activeTrackColor: Theme.of(context).colorScheme.secondary,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
                          inactiveTrackColor: Colors.black45,

                        ),

                        //------------------------------------------------------------------------------

                        // ITEM 30
                        SwitchListTile(

                          // SWITCH TITLE
                          title: Text(AppLocalizations.of(context)!.quest_tool_female_chastity_cage.capitalize_first()),

                          // SWITCH VALUE
                          value: item_30,

                          // SWITCH FUNCTION
                          onChanged: (bool value) {
                            setStateDialog(() {
                              item_30 = value;

                              // CHECKING IF THE TOOL IS ALREADY INSIDE THE TOOL LIST
                              if (tools_list.contains(AppLocalizations.of(context)!.quest_tool_female_chastity_cage)) {

                                // DELETING THE TOOL FROM TO THE TOOL LIST
                                tools_list.remove(AppLocalizations.of(context)!.quest_tool_female_chastity_cage);

                              } else {

                                // ADDING THE TOOL TO THE TOOL LIST
                                tools_list.add(AppLocalizations.of(context)!.quest_tool_female_chastity_cage);

                              }

                            });
                          },

                          // SWITCH COLOR
                          activeColor: Theme.of(context).colorScheme.onSecondary,
                          activeTrackColor: Theme.of(context).colorScheme.secondary,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
                          inactiveTrackColor: Colors.black45,

                        ),

                        //------------------------------------------------------------------------------

                        // SPACER
                        SizedBox(height: 15),

                        //------------------------------------------------------------------------------

                        // DIALOG EXIT BUTTON
                        TextButton(

                          // BUTTON STYLE PARAMETERS
                          style: ButtonStyle(

                            // NORMAL TEXT COLOR
                            foregroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.onPrimary),

                            // NORMAL BACKGROUND COLOR
                            backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.secondary),

                            // PADDING
                            padding: WidgetStateProperty.all(EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5)),

                            // BORDER RADIUS
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),

                          ),

                          // FUNCTION
                          onPressed: () {

                            // UPDATING THE PAGE STATE
                            setState(() {

                              // UPDATING THE TEXT FIELD
                              _quest_tool_controller.text = tools_list.join(", ");

                            });

                            // CLOSING THE DIALOG
                            Navigator.of(context).pop();
                          },

                          // BUTTON TEXT
                          child: Text(AppLocalizations.of(context)!.quest_editor_page_tools_dialog_save_button_label),

                        ),

                        //------------------------------------------------------------------------------

                      ],

                    ),


                  )

                ),

              );

            },

          );

          //------------------------------------------------------------------------------

        },

      );

    }


    //------------------------------------------------------------------------------

    // PAGE CONTENT
    return Scaffold(

      // APP BAR
      appBar: AppBar(

        // DEFINING THE ACTION BUTTONS
        actions: [

          // DELETE ICON BUTTON
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {

              // SHOWING THE DELETE DIALOG
              await show_confirmation_dialog(context);

              // GOING BACK TO THE PREVIOUS PAGE
              Navigator.of(context).pop();

            },

          ),

        ],

      ),


      // SCAFFOLD CONTENT
      body: SafeArea(

        // SAFE AREA CONTENT
        child: Container(

          // PAGE PADDING
          padding: EdgeInsets.all(15),

          // PAGE ALIGNMENT
          alignment: Alignment.topCenter,

          // CONTAINER CONTENT
          child: SingleChildScrollView(

            // SCROLLABLE CONTAINER CONTENT
            child: Column(

              // COLUMN CONTENT
              children: [

                //------------------------------------------------------------------------------

                // SPACER
                const SizedBox(height: 30),

                //------------------------------------------------------------------------------

                // PAGE LOGO
                Image.asset(
                  'assets/images/deck_editor_icon.png',
                  width: 140,
                  height: 140,
                  fit: BoxFit.contain,
                ),

                //------------------------------------------------------------------------------

                // SPACER
                const SizedBox(height: 30),

                //------------------------------------------------------------------------------

                // PAGE TITLE CONTAINER
                FractionallySizedBox(

                  // DYNAMIC WIDTH
                  widthFactor: 0.8,

                  // TITLE
                  child: Text(
                    // TEXT
                    AppLocalizations.of(context)!.quest_editor_page_title,

                    // TEXT ALIGNMENT
                    textAlign: TextAlign.center,

                    // TEXT STYLE
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,

                    ),
                  ),

                ),

                //------------------------------------------------------------------------------

                // SPACER
                const SizedBox(height: 15),

                //------------------------------------------------------------------------------

                // QUEST MOMENT LABEL AND QUEST MOMENT SEGMENTED BUTTON
                Column(

                  // ALIGNMENT
                  crossAxisAlignment: CrossAxisAlignment.start,

                  // COLUMN CONTENT
                  children: [

                    // CARD TEXT
                    Text(
                      // TEXT
                      AppLocalizations.of(context)!.quest_editor_page_quest_type,

                      // TEXT STYLE
                      style: TextStyle(
                        fontSize: 18.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    //------------------------------------------------------------------------------

                    // SPACER
                    const SizedBox(height: 5),

                    //------------------------------------------------------------------------------

                    // COUPLE TYPE FILTER SELECTOR
                    SizedBox(

                      // WIDTH
                      width: double.infinity,

                      // CONTAINER CONTENT
                      child:  SegmentedButton<String>(

                        // DEFINING THE OPTIONS
                        segments: <ButtonSegment<String>>[
                          ButtonSegment(value: 'early', label: Text(AppLocalizations.of(context)!.quest_editor_page_quest_type_early, style: TextStyle(fontSize: 12))),
                          ButtonSegment(value: 'mid', label: Text(AppLocalizations.of(context)!.quest_editor_page_quest_type_mid, style: TextStyle(fontSize: 12))),
                          ButtonSegment(value: 'late', label: Text(AppLocalizations.of(context)!.quest_editor_page_quest_type_late, style: TextStyle(fontSize: 12))),
                          ButtonSegment(value: 'end', label: Text(AppLocalizations.of(context)!.quest_editor_page_quest_type_end, style: TextStyle(fontSize: 12))),
                        ],

                        // SETTING THE SELECTED OPTION
                        selected: {selected_option_quest_type},

                        // HIDING THE SELECTED ICON
                        showSelectedIcon: false,

                        // GETTING THE USER CHOICE
                        onSelectionChanged: (Set<String> newSelection) {
                          setState(() {
                            selected_option_quest_type = newSelection.first;
                          });
                        },

                      ),

                    ),

                    //------------------------------------------------------------------------------

                  ],

                ),

                //------------------------------------------------------------------------------

                // SPACER
                const SizedBox(height: 15),

                //------------------------------------------------------------------------------

                // QUEST REQUIRED TOOLS LABEL AND QUEST REQUIRED TOOLS TEXTBOX CONTAINER
                Column(

                  // ALIGNMENT
                  crossAxisAlignment: CrossAxisAlignment.start,

                  // COLUMN CONTENT
                  children: [

                    // CARD TEXT
                    Text(
                      // TEXT
                      AppLocalizations.of(context)!.deck_info_information_requested_tools_label,

                      // TEXT STYLE
                      style: TextStyle(
                        fontSize: 18.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    //------------------------------------------------------------------------------

                    // SPACER
                    const SizedBox(height: 5),

                    //------------------------------------------------------------------------------

                    // CARD TEXT
                    TextField(

                      // TEXT CONTROLLER
                      controller: _quest_tool_controller,

                      // SETTING THE TEXT FIELD AD READ-ONLY
                      readOnly: true,

                      // ALLOWING THE TEXT FIELD DO GO MULTILINE
                      keyboardType: TextInputType.multiline,
                      maxLines: null,

                      // ON TAP FUNCTION
                      onTap: () {

                        show_tools_dialog(context).then((_) {

                          setState(() {

                            // UPDATING THE TEXT FIELD
                            _quest_tool_controller.text = tools_list.join(", ");

                          });

                        });

                      },

                      // INPUT TEXT STYLING
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),

                      // TEXT FIELD STYLING
                      decoration: InputDecoration(

                        // HINT TEXT
                        hintText: AppLocalizations.of(context)!.deck_summary_editor_insert_text_hint,

                        // HINT TEXT STYLE
                        hintStyle: TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.normal,
                        ),

                        // BORDER
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none
                        ),

                        // BACKGROUND COLOR
                        filled: true,
                        fillColor: Colors.grey[800],

                        // PADDING
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 20,
                        ),

                      ),

                    ),

                    //------------------------------------------------------------------------------

                  ],

                ),

                //------------------------------------------------------------------------------

                // SPACER
                const SizedBox(height: 15),

                //------------------------------------------------------------------------------

                // QUEST TIMER LABEL AND QUEST TIMER TEXTBOX CONTAINER
                Column(

                  // ALIGNMENT
                  crossAxisAlignment: CrossAxisAlignment.start,

                  // COLUMN CONTENT
                  children: [

                    // CARD TEXT
                    Text(
                      // TEXT
                      AppLocalizations.of(context)!.quest_editor_page_quest_timer_label,

                      // TEXT STYLE
                      style: TextStyle(
                        fontSize: 18.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    //------------------------------------------------------------------------------

                    // SPACER
                    const SizedBox(height: 5),

                    //------------------------------------------------------------------------------

                    // CARD TEXT
                    TextField(

                      // TEXT CONTROLLER
                      controller: _quest_timer_controller,

                      // SETTING THE USE OF THE NUMBER KEYBOARD
                      keyboardType: TextInputType.number,

                      // ALLOWING ONLY THE INPUT OF INT NUMBERS
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],

                      // INPUT TEXT STYLING
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),

                      // TEXT FIELD STYLING
                      decoration: InputDecoration(

                        // HINT TEXT
                        hintText: AppLocalizations.of(context)!.deck_summary_editor_insert_text_hint,

                        // HINT TEXT STYLE
                        hintStyle: TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.normal,
                        ),

                        // BORDER
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none
                        ),

                        // BACKGROUND COLOR
                        filled: true,
                        fillColor: Colors.grey[800],

                        // PADDING
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 20,
                        ),

                      ),

                    ),

                    //------------------------------------------------------------------------------

                  ],

                ),

                //------------------------------------------------------------------------------

                // SPACER
                const SizedBox(height: 15),

                //------------------------------------------------------------------------------

                // DECK DESCRIPTION LABEL AND DECK DESCRIPTION TEXTBOX CONTAINER
                Column(

                  // ALIGNMENT
                  crossAxisAlignment: CrossAxisAlignment.start,

                  // COLUMN CONTENT
                  children: [

                    // CARD TEXT
                    Text(
                      // TEXT
                      AppLocalizations.of(context)!.quest_editor_page_quest_content_label,

                      // TEXT STYLE
                      style: TextStyle(
                        fontSize: 18.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    //------------------------------------------------------------------------------

                    // SPACER
                    const SizedBox(height: 5),

                    //------------------------------------------------------------------------------

                    // CARD TEXT
                    TextField(

                      // TEXT CONTROLLER
                      controller: _quest_content_controller,

                      // ALLOWING THE TEXT FIELD DO GO MULTILINE
                      keyboardType: TextInputType.multiline,
                      maxLines: null,

                      // INPUT TEXT STYLING
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),

                      // TEXT FIELD STYLING
                      decoration: InputDecoration(

                        // HINT TEXT
                        hintText: AppLocalizations.of(context)!.deck_summary_editor_insert_text_hint,

                        // HINT TEXT STYLE
                        hintStyle: TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.normal,
                        ),

                        // BORDER
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none
                        ),

                        // BACKGROUND COLOR
                        filled: true,
                        fillColor: Colors.grey[800],

                        // PADDING
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 20,
                        ),

                      ),

                    ),

                    //------------------------------------------------------------------------------

                  ],

                ),

                //------------------------------------------------------------------------------

                // SPACER
                const SizedBox(height: 30),

                //------------------------------------------------------------------------------

                // BUTTON BOX
                SizedBox(

                  // DYNAMIC SIZE
                  width: 180,

                  // BOX CONTENT
                  child: ElevatedButton(

                    // BUTTON STYLE PARAMETERS
                    style: ButtonStyle(

                      // NORMAL TEXT COLOR
                      foregroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.onPrimary),

                      // NORMAL BACKGROUND COLOR
                      backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.secondary),

                      // MINIMUM SIZE
                      minimumSize: WidgetStateProperty.all(Size(100, 60)),

                      // PADDING
                      padding: WidgetStateProperty.all(EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15)),

                      // BORDER RADIUS
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),

                    ),

                    // ON PRESSED CALL
                    onPressed: () async {

                      // CHECKING ALIAS BEFORE GOING TO THE NEXT PAGE
                      check_and_save_quest();

                    },

                    // BUTTON CONTENT
                    child: Text(

                      // TEXT
                      AppLocalizations.of(context)!.define_players_name_confirm_button,

                      // TEXT ALIGNMENT
                      textAlign: TextAlign.center,

                      // TEXT STYLE
                      style: TextStyle(

                        fontSize: 15,
                        fontWeight: FontWeight.w500,

                      ),

                    ),

                  ),

                ),

                //------------------------------------------------------------------------------

              ],

            ),

          ),

        ),

      ),

    );

    //------------------------------------------------------------------------------

  }

}

//------------------------------------------------------------------------------