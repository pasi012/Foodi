import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../global/global.dart';
import '../../../../mainScreens/home_screen.dart';
import '../../../../widgets/error_Dialog.dart';
import '../../../../widgets/loading_dialog.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Signup/signup_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final user = (await _auth.signInWithCredential(credential)).user;

      if (user != null) {
        saveDataToFireStore(user).then((value) {
          readDataAndSetDataLocally(user);
        });
      }
    } catch (e) {
      SnackBar snackBar = SnackBar(
        content: Text(
          "Error $e",
          style: const TextStyle(fontSize: 36, color: Colors.black),
        ),
        backgroundColor: Colors.pinkAccent,
        duration: const Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future saveDataToFireStore(User currentUser) async {
    FirebaseFirestore.instance.collection('users').doc(currentUser.uid).set({
      "uid": currentUser.uid,
      "email": currentUser.email,
      "name": currentUser.displayName,
      "photo": currentUser.photoURL,
      "status": "Approved",
      "userCart": ['garbageValue'],
    });

    // save data locally
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid.toString());
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!
        .setString("name", currentUser.displayName.toString());
    await sharedPreferences!
        .setString("photo", currentUser.photoURL.toString());

    await sharedPreferences!.setStringList("userCart", ['garbageValue']);
  }

  Future<void> _signInWithFacebook() async {
    final LoginResult result =
        await FacebookAuth.instance.login(permissions: ['public_profile']);

    if (result.status == LoginStatus.success) {
      User? currentUser;
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential)
          .then((fAuth) {
        currentUser = fAuth.user;
      }).catchError((onError) {
        //display error message
        final snackBar = SnackBar(
          content: Text(
            "Error Occured: $onError",
            style: const TextStyle(fontSize: 36, color: Colors.black),
          ),
          backgroundColor: Colors.pinkAccent,
          duration: const Duration(seconds: 5),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });

      if (currentUser != null) {
        saveDataToFireStore(currentUser!).then((value) {
          readDataAndSetDataLocally(currentUser!);
        });
      }
    } else {
      throw Exception('Failed to sign in with Facebook: ${result.status}');
    }
  }

  formValidation() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      loginNow();
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return const ErrorDialog(
              message: "Please Enter Email or Password",
            );
          });
    }
  }

  loginNow() async {
    showDialog(
        context: context,
        builder: (c) {
          return const LoadingDialog(
            message: 'Checking Creadential',
          );
        });
    User? currentUser;
    await firebaseAuth
        .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user!;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(
              message: error.message.toString(),
            );
          });
    });
    if (currentUser != null) {
      readDataAndSetDataLocally(currentUser!);
    }
  }

  Future readDataAndSetDataLocally(User currentUser) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        if (snapshot.data()!["status"] == "Approved") {
          await sharedPreferences!.setString("uid", currentUser.uid);
          await sharedPreferences!
              .setString("email", snapshot.data()!["email"]);
          await sharedPreferences!.setString("name", snapshot.data()!["name"]);
          await sharedPreferences!
              .setString("photo", snapshot.data()!["photo"]);

          List<String> userCartList =
              snapshot.data()!["userCart"].cast<String>();
          await sharedPreferences!.setStringList("userCart", userCartList);

          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          // ignore: use_build_context_synchronously
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        } else {
          firebaseAuth.signOut();
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg:
                  "Admin has Blocked your account \n\n Mail to:admin@gmail.com");
        }
      } else {
        firebaseAuth.signOut();
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return const ErrorDialog(
                message: "no record found",
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onChanged: (value) {
              emailController.text = value;
            },
            decoration: const InputDecoration(
              filled: true,
              fillColor: kPrimaryLightColor,
              iconColor: kPrimaryColor,
              prefixIconColor: kPrimaryColor,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide.none,
              ),
              hintText: "Your email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          const SizedBox(
            height: defaultPadding / 2,
          ),
          TextFormField(
            onChanged: (value) {
              passwordController.text = value;
            },
            controller: passwordController,
            textInputAction: TextInputAction.done,
            obscureText: true,
            cursorColor: kPrimaryColor,
            decoration: const InputDecoration(
              filled: true,
              fillColor: kPrimaryLightColor,
              iconColor: kPrimaryColor,
              prefixIconColor: kPrimaryColor,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide.none,
              ),
              hintText: "Your password",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.lock),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              foregroundColor: Colors.white,
              backgroundColor: kPrimaryColor,
              shape: const StadiumBorder(),
              minimumSize: const Size(double.infinity, 56),
            ),
            onPressed: () {
              formValidation();
            },
            child: Text(
              "Login".toUpperCase(),
            ),
          ),
          const SizedBox(height: defaultPadding * 2),
          Text(
            "Or, Sign In with",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp
            ),
          ),
          const SizedBox(height: defaultPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  _signInWithGoogle();
                },
                child: Image.asset(
                  "assets/images/google.png",
                  width: 30.w,
                  height: 30.h,
                ),
              ),
              const SizedBox(width: 20,),
              GestureDetector(
                onTap: () {
                  _signInWithFacebook();
                },
                child: Image.asset(
                  "assets/images/facebook.png",
                  width: 30.w,
                  height: 30.h,
                ),
              ),
            ],
          ),
          const SizedBox(height: defaultPadding * 2),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
