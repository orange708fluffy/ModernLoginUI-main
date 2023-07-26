import 'package:flutter/material.dart';
import 'package:modernlogintute/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget{
   final void Function()? onProfileTap;
   final void Function()? onSignOut;
   const MyDrawer({super.key, required this.onProfileTap, required this.onSignOut,});


   @override
   Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Column(children: [
           DrawerHeader(
            child: Icon(
              Icons.person,
              color: Colors.black,
              size: 64,
              ),
              ),

          //home
          MyListTile(
            icon: 
            Icons.home, 
            text: 'H O M E',
            onTap: () => Navigator.pop(context),
            ),
          //profile
          MyListTile(
            icon: 
            Icons.person, 
            text: 'P R O F I L E',
            onTap: onProfileTap,
          ),
         ],
         ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: MyListTile(
              icon: 
              Icons.door_back_door, 
              text: 'L O G O U T',
              onTap:onSignOut,
              ),
            )
          //log out 
      ]),
    );
   }
  } // TODO: implement createState
