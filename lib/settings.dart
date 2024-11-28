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
      backgroundColor: const Color.fromARGB(134, 4, 83, 147),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55), // Set your preferred height here
        child: AppBar(
          backgroundColor: const Color.fromARGB(135, 33, 149, 243),
          title: const Text(
            "Settings",
            style: TextStyle(
              color: Colors.white,
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
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20),
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
                const Padding(
                  padding: EdgeInsets.only(left: 20),
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
                    title: const Text(
                      "Status bar",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Checkbox(
                      side: MaterialStateBorderSide.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return const BorderSide(
                            color: Color.fromARGB(135, 33, 149, 243),
                          );
                        } else {
                          return const BorderSide(
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
                      activeColor: const Color.fromARGB(135, 33, 149, 243),
                      value: _isChecked,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _isChecked = newValue!;
                        });
                      },
                    ),
                    subtitle: Text(
                      _isChecked ? 'Enabled' : 'Disabled',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: const Text(
                      "Confrim finshing tasks",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Checkbox(
                      side: MaterialStateBorderSide.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return const BorderSide(
                            color: Color.fromARGB(135, 33, 149, 243),
                          );
                        } else {
                          return const BorderSide(
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
                      activeColor: const Color.fromARGB(135, 33, 149, 243),
                      value: _task,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _task = newValue!;
                        });
                      },
                    ),
                    subtitle: Text(
                      _task ? 'Enabled' : 'Disabled',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: const Text(
                      "Confrim finishing tasks",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Checkbox(
                      side: MaterialStateBorderSide.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return const BorderSide(
                            color: Color.fromARGB(135, 33, 149, 243),
                          );
                        } else {
                          return const BorderSide(
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
                      activeColor: const Color.fromARGB(135, 33, 149, 243),
                      value: _repeat,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _repeat = newValue!;
                        });
                      },
                    ),
                    subtitle: Text(
                      _repeat ? 'Enabled' : 'Disabled',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: const Text(
                      "Found in clipboard",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Checkbox(
                      side: MaterialStateBorderSide.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return const BorderSide(
                            color: Color.fromARGB(135, 33, 149, 243),
                          );
                        } else {
                          return const BorderSide(
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
                      activeColor: const Color.fromARGB(135, 33, 149, 243),
                      value: _clipart,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _clipart = newValue!;
                        });
                      },
                    ),
                    subtitle: Text(
                      _clipart ? 'Enabled' : 'Disabled',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
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
                const Padding(
                  padding: EdgeInsets.only(left: 20),
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
                const Padding(
                  padding: EdgeInsets.only(left: 20),
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
                const Padding(
                  padding: EdgeInsets.only(left: 20),
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
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20),
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
                const Padding(
                  padding: EdgeInsets.only(left: 20),
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
                    title: const Text(
                      "Voice",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Checkbox(
                      side: MaterialStateBorderSide.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return const BorderSide(
                            color: Color.fromARGB(135, 33, 149, 243),
                          );
                        } else {
                          return const BorderSide(
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
                      activeColor: const Color.fromARGB(135, 33, 149, 243),
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
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: const Text(
                      "Vibration",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Checkbox(
                      side: MaterialStateBorderSide.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return const BorderSide(
                            color: Color.fromARGB(135, 33, 149, 243),
                          );
                        } else {
                          return const BorderSide(
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
                      activeColor: const Color.fromARGB(135, 33, 149, 243),
                      value: _vibration,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _vibration = newValue!;
                        });
                      },
                    ),
                    subtitle: Text(
                      _vibration ? 'Enabled' : 'Disabled',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
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
                    title: const Text(
                      "Day Summary",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Checkbox(
                      side: MaterialStateBorderSide.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return const BorderSide(
                            color: Color.fromARGB(135, 33, 149, 243),
                          );
                        } else {
                          return const BorderSide(
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
                      activeColor: const Color.fromARGB(135, 33, 149, 243),
                      value: _day,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _day = newValue!;
                        });
                      },
                    ),
                    subtitle: Text(
                      _day ? 'Enabled' : 'Disabled',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
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
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20),
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
                const Padding(
                  padding: EdgeInsets.only(left: 20),
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
                const Padding(
                  padding: EdgeInsets.only(left: 20),
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
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20),
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
                    title: const Text(
                      "Quick task bar",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Checkbox(
                      side: MaterialStateBorderSide.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return const BorderSide(
                            color: Color.fromARGB(135, 33, 149, 243),
                          );
                        } else {
                          return const BorderSide(
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
                      activeColor: const Color.fromARGB(135, 33, 149, 243),
                      value: _iChecked,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _iChecked = newValue!;
                        });
                      },
                    ),
                    subtitle: Text(
                      _iChecked ? 'Enabled' : 'Disabled',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
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
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20),
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
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "Invite friends to the app",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "More Apps",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "Send Feedback",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
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
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20),
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
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "Facebook",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text(
                      "Instagram",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
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
