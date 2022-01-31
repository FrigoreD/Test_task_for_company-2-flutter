import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task2/application/app/app_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          TextButton(
            key: const Key('homePage_logout_TextButton'),
            child: Text(
              'Logout',
              style: textTheme.headline3,
            ),
            onPressed: () => context.read<AppBloc>().add(AppLogoutRequested()),
          ),
        ],
      ),
      body: Align(
        alignment: const Alignment(0, -2 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Welcome',
              style: textTheme.headline1,
            ),
            const SizedBox(height: 100),
            Text('email: ${user.email}', style: textTheme.headline5),
            const PasswordWidget()
          ],
        ),
      ),
    );
  }
}

class PasswordWidget extends StatelessWidget {
  const PasswordWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text(
              'Something went wrong',
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          DocumentSnapshot doc = snapshot.data!.docs[0];
          return Text('password:  ${doc['password']}', style: textTheme.headline5,);
        });
  }
}