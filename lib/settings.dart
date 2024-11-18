import 'package:flutter/material.dart';

class settings extends StatefulWidget {
  const settings({super.key});

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  @override
  bool _iChecked = false;
  bool _task = false;
  bool _repeat = false;
  bool _clipart = false;
  bool _voice = false;
  bool _vibration = false;

  bool _day = false;
  bool _isChecked = false;
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(134, 4, 83, 147),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55), // Set your preferred height here
        child: Padding(
          padding: const EdgeInsets.only(
            top: 35,
          ),
          child: AppBar(
            backgroundColor: Color.fromARGB(135, 33, 149, 243),
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 45,
                  ),
                  child: Text(
                    "Settings",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        "General",
                        style: TextStyle(
                            color: Color.fromARGB(135, 33, 149, 243),
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "Remove Ads",
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "One payment to remove ads forever",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "Status bar",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Checkbox(
                      side: MaterialStateBorderSide.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return BorderSide(
                            color: Color.fromARGB(135, 33, 149, 243),
                          );
                        } else {
                          return BorderSide(
                            color: Colors.white,
                          );
                        }
                      }),
                      fillColor: MaterialStateProperty.resolveWith((states) {
                        if (!states.contains(MaterialState.selected)) {
                          return Colors.transparent;
                        }
                        return null;
                      }),
                      checkColor: Colors.white,
                      activeColor: Color.fromARGB(135, 33, 149, 243),
                      value: _isChecked,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _isChecked = newValue!;
                        });
                      },
                    ),
                    subtitle: Text(
                      _isChecked ? 'Enabled' : 'Disabled',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "Confrim finshing tasks",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Checkbox(
                      side: MaterialStateBorderSide.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return BorderSide(
                            color: Color.fromARGB(135, 33, 149, 243),
                          );
                        } else {
                          return BorderSide(
                            color: Colors.white,
                          );
                        }
                      }),
                      fillColor: MaterialStateProperty.resolveWith((states) {
                        if (!states.contains(MaterialState.selected)) {
                          return Colors.transparent;
                        }
                        return null;
                      }),
                      checkColor: Colors.white,
                      activeColor: Color.fromARGB(135, 33, 149, 243),
                      value: _task,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _task = newValue!;
                        });
                      },
                    ),
                    subtitle: Text(
                      _task ? 'Enabled' : 'Disabled',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "Confrim finishing tasks",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Checkbox(
                      side: MaterialStateBorderSide.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return BorderSide(
                            color: Color.fromARGB(135, 33, 149, 243),
                          );
                        } else {
                          return BorderSide(
                            color: Colors.white,
                          );
                        }
                      }),
                      fillColor: MaterialStateProperty.resolveWith((states) {
                        if (!states.contains(MaterialState.selected)) {
                          return Colors.transparent;
                        }
                        return null;
                      }),
                      checkColor: Colors.white,
                      activeColor: Color.fromARGB(135, 33, 149, 243),
                      value: _repeat,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _repeat = newValue!;
                        });
                      },
                    ),
                    subtitle: Text(
                      _repeat ? 'Enabled' : 'Disabled',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "Found in clipboard",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Checkbox(
                      side: MaterialStateBorderSide.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return BorderSide(
                            color: Color.fromARGB(135, 33, 149, 243),
                          );
                        } else {
                          return BorderSide(
                            color: Colors.white,
                          );
                        }
                      }),
                      fillColor: MaterialStateProperty.resolveWith((states) {
                        if (!states.contains(MaterialState.selected)) {
                          return Colors.transparent;
                        }
                        return null;
                      }),
                      checkColor: Colors.white,
                      activeColor: Color.fromARGB(135, 33, 149, 243),
                      value: _clipart,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _clipart = newValue!;
                        });
                      },
                    ),
                    subtitle: Text(
                      _clipart ? 'Enabled' : 'Disabled',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "List to show at startup",
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "All Lists",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "First day of week",
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "Sunday",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "Tme format",
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "12-hour",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "Sort order",
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "Due date + Alphabetically",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        "Notifications",
                        style: TextStyle(
                            color: Color.fromARGB(135, 33, 149, 243),
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "Sound",
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "Default ringtone(Bubble)",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "Voice",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Checkbox(
                      side: MaterialStateBorderSide.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return BorderSide(
                            color: Color.fromARGB(135, 33, 149, 243),
                          );
                        } else {
                          return BorderSide(
                            color: Colors.white,
                          );
                        }
                      }),
                      fillColor: MaterialStateProperty.resolveWith((states) {
                        if (!states.contains(MaterialState.selected)) {
                          return Colors.transparent;
                        }
                        return null;
                      }),
                      checkColor: Colors.white,
                      activeColor: Color.fromARGB(135, 33, 149, 243),
                      value: _voice,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _voice = newValue!;
                        });
                      },
                    ),
                    subtitle: Text(
                      _voice
                          ? 'Uses system default speech synthesizer(tts)'
                          : 'Uses system default speech synthesizer(tts)',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "Vibration",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Checkbox(
                      side: MaterialStateBorderSide.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return BorderSide(
                            color: Color.fromARGB(135, 33, 149, 243),
                          );
                        } else {
                          return BorderSide(
                            color: Colors.white,
                          );
                        }
                      }),
                      fillColor: MaterialStateProperty.resolveWith((states) {
                        if (!states.contains(MaterialState.selected)) {
                          return Colors.transparent;
                        }
                        return null;
                      }),
                      checkColor: Colors.white,
                      activeColor: Color.fromARGB(135, 33, 149, 243),
                      value: _vibration,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _vibration = newValue!;
                        });
                      },
                    ),
                    subtitle: Text(
                      _vibration ? 'Enabled' : 'Disabled',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "Task notification",
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "On time",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "Day Summary",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Checkbox(
                      side: MaterialStateBorderSide.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return BorderSide(
                            color: Color.fromARGB(135, 33, 149, 243),
                          );
                        } else {
                          return BorderSide(
                            color: Colors.white,
                          );
                        }
                      }),
                      fillColor: MaterialStateProperty.resolveWith((states) {
                        if (!states.contains(MaterialState.selected)) {
                          return Colors.transparent;
                        }
                        return null;
                      }),
                      checkColor: Colors.white,
                      activeColor: Color.fromARGB(135, 33, 149, 243),
                      value: _day,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _day = newValue!;
                        });
                      },
                    ),
                    subtitle: Text(
                      _day ? 'Enabled' : 'Disabled',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "choose time",
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "8:00 AM",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        "Syncing with Google",
                        style: TextStyle(
                            color: Color.fromARGB(135, 33, 149, 243),
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "Google Account",
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "Not set",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "sync mode",
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "sync disabled",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        "Ouick Task",
                        style: TextStyle(
                            color: Color.fromARGB(135, 33, 149, 243),
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "Quick task bar",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Checkbox(
                      side: MaterialStateBorderSide.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return BorderSide(
                            color: Color.fromARGB(135, 33, 149, 243),
                          );
                        } else {
                          return BorderSide(
                            color: Colors.white,
                          );
                        }
                      }),
                      fillColor: MaterialStateProperty.resolveWith((states) {
                        if (!states.contains(MaterialState.selected)) {
                          return Colors.transparent;
                        }
                        return null;
                      }),
                      checkColor: Colors.white,
                      activeColor: Color.fromARGB(135, 33, 149, 243),
                      value: _iChecked,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _iChecked = newValue!;
                        });
                      },
                    ),
                    subtitle: Text(
                      _iChecked ? 'Enabled' : 'Disabled',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "default due date",
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "No date",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        "About",
                        style: TextStyle(
                            color: Color.fromARGB(135, 33, 149, 243),
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "Invite friends to the app",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "More Apps",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "Send Feedback",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "splenDO",
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "Version 4.35",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        "Follow Us",
                        style: TextStyle(
                            color: Color.fromARGB(135, 33, 149, 243),
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "Facebook",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "Instagram",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "Twitter",
                      style: TextStyle(color: Colors.white),
                    ),
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
