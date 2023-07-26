import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modernlogintute/components/my_button.dart';
import 'package:modernlogintute/components/my_textfield.dart';
import 'package:modernlogintute/components/square_tile.dart';
import 'package:modernlogintute/services/AuthService.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign user in method
  void signUserUp() async {

    //show loading circle 
    showDialog(context: context, builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
    );
    //try creating an account  
    try {
      //check if password and confirm password is the same 
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text,
        );
      }else{
        //show error message 
        wrongPasswordMessage();
      }
      } on FirebaseAuthException catch (e) {
         //pop the loading circle
         Navigator.pop(context);
        if(e.code == 'user-not-found'){
          print("No user found");
          //show error to user 
          wrongEmailMessage();
          }
        else if (e.code == 'wrong-password'){
          print("Wrong Password");
          //show error to user 
          wrongPasswordMessage();

        }  

    }
   
  }

    // wrong email message pop up
    void wrongEmailMessage(){
     showDialog(context: context, builder: (context) {
      return const AlertDialog(
        title: Text('Incorrect Email'),
      );
     },
     );
    }


        // wrong Password message pop up
    void wrongPasswordMessage(){
     showDialog(context: context, builder: (context) {
      return const AlertDialog(
        title: Text('Incorrect Password'),
      );
     },
     );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
          
                // logo
                const Icon(
                  Icons.lock,
                  size: 50,
                ),
          
                const SizedBox(height: 50),
          
                // welcome back, you've been missed!
                Text(
                  'Let\'s create an account for you!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
          
                const SizedBox(height: 25),
          
                // email textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
          
                const SizedBox(height: 10),
          
                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                // confirm password textfield
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
          
                const SizedBox(height: 10),

          
                // sign in button
                MyButton(
                  text: 'Sign Up',
                  onTap: signUserUp,
                ),
          
                const SizedBox(height: 50),
          
                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  SquareTile(
                    onTap: () => AuthService().signInWithGoogle(),
                    imagePath: 'lib/images/google.png',  ),

                  SizedBox(width: 25,),
                  
                  SquareTile(
                    onTap: () {
                      
                    },
                    imagePath: 'lib/images/apple.png',),
                ],
                  ),
                
                const SizedBox(height: 50,),

          
                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
