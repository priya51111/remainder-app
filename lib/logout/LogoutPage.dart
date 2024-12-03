import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing/login/repository/repository.dart';
import 'bloc/Logout_bloc.dart';
import 'bloc/logout_event.dart';
import 'bloc/logout_state.dart';
import 'repository/Logout_repository.dart';

class LogoutPage extends StatefulWidget {
  @override
  _LogoutPageState createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  late UserRepository userRepository;
  late String userId;
  final String token = 'YOUR_BEARER_TOKEN'; 

  @override
  void initState() {
    super.initState();
    
    userRepository = UserRepository();
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocListener<LogoutBloc, LogoutState>(
          listener: (context, state) {
            if (state is LogoutSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Logout successful')),
              );
                Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (route) => false, 
              );
            } else if (state is LogoutFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Logout failed: ${state.error}')),
              );
            }
          },
          child: BlocBuilder<LogoutBloc, LogoutState>(
            builder: (context, state) {
              if (state is LogoutLoading) {
                return CircularProgressIndicator();
              }

              return ElevatedButton(
                onPressed: () => _showLogoutConfirmationDialog(context),
                child: Text('Logout'),
              );
            },
          ),
        ),
      ),
    );
  }

 
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout Confirmation'),
          content: Text('Do you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
              
                context.read<LogoutBloc>().add(
                  LogoutRequested(userId: userId),
                );
                Navigator.of(context).pop(); 
              },
            ),
          ],
        );
      },
    );
  }
}
