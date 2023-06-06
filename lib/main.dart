import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_scan_app/constants/routes.dart';
import 'package:skin_scan_app/helpers/loading/loading_screen.dart';
import 'package:skin_scan_app/services/auth/bloc/auth_bloc.dart';
import 'package:skin_scan_app/services/auth/bloc/auth_event.dart';
import 'package:skin_scan_app/services/auth/bloc/auth_state.dart';
import 'package:skin_scan_app/services/auth/firebase_auth_provider.dart';
import 'package:skin_scan_app/views/info_and_support/info_view.dart';
import 'package:skin_scan_app/views/login_logout/forgot_password_view.dart';
import 'package:skin_scan_app/views/home/home_view.dart';
import 'package:skin_scan_app/views/login_logout/login_view.dart';


import 'package:skin_scan_app/views/login_logout/register_view.dart';
import 'package:skin_scan_app/views/login_logout/verify_email_view.dart';
import 'package:camera/camera.dart';
import 'views/camera/camera_view.dart';
import 'views/info_and_support/support_view.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: Colors.blue,
            onPrimary: Colors.white,
            secondary: Colors.yellow.shade300,
            onSecondary: Colors.black,
            error: Colors.blue.shade700,
            onError: Colors.black,
            background: Colors.white,
            onBackground: Colors.black,
            surface: Colors.blueGrey.shade200,
            onSurface: Colors.black),
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        cameraViewRoute: (context) => CameraView(camera: firstCamera),
        infoViewRoute: (context) => const InfoView(),
        supportViewRoute: (context) => const SupportView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state.isLoading) {
        LoadingScreen().show(
          context: context,
          text: state.loadingText ?? 'Please wait a moment',
        );
      } else {
        LoadingScreen().hide();
      }
    }, builder: (context, state) {
      if (state is AuthStateLoggedIn) {
        return const HomeView();
      } else if (state is AuthStateNeedsVerification) {
        return const VerifyEmailView();
      } else if (state is AuthStateLoggedOut) {
        return const LoginView();
      } else if (state is AuthStateForgotPassword) {
        return const ForgotPasswordView();
      } else if (state is AuthStateRegistering) {
        return const RegisterView();
      } else {
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }
    });
  }
}
