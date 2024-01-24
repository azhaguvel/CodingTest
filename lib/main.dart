import 'package:flutter/material.dart';
import 'group_screen.dart';
import 'menu_items.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Menu App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                navigateToGroupScreen(context, 'Group1');
              },
              child: Text('Group 1'),
            ),
            ElevatedButton(
              onPressed: () {
                navigateToGroupScreen(context, 'Group2');
              },
              child: Text('Group 2'),
            ),
            ElevatedButton(
              onPressed: () {
                navigateToGroupScreen(context, 'Group3');
              },
              child: Text('Group 3'),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToGroupScreen(BuildContext context, String groupName) {
    List<MenuItem> selectedMenu;

    // Determine the menu based on the selected group
    switch (groupName) {
      case 'Group1':
        selectedMenu = [
          MenuItem(name: 'Big Brekkie', price: 16,quantity: 1),
          MenuItem(name: 'Coffee', price: 5,quantity: 2),
          MenuItem(name: 'Tea', price: 3,quantity: 3),
          MenuItem(name: 'Soda', price: 4,quantity: 3),
          MenuItem(name: 'Bruchetta', price: 8,quantity: 2),
          MenuItem(name: 'Garden Salad', price: 10,quantity: 1),
          MenuItem(name: 'Poached Eggs', price: 12,quantity: 3),
        ];
        break;
      case 'Group2':
        selectedMenu = [
          MenuItem(name: 'Tea', price: 3,quantity: 1),
          MenuItem(name: 'Coffee', price: 3,quantity: 3),
          MenuItem(name: 'Soda', price: 4,quantity: 1),
          MenuItem(name: 'Big Brekkie', price: 16,quantity: 3),
          MenuItem(name: 'Poached Eggs', price: 12,quantity: 1),
          MenuItem(name: 'Garden Salad', price: 10,quantity: 1),
        ];
        break;
      case 'Group3':
        selectedMenu = [
          MenuItem(name: 'Tea', price: 3,quantity: 2),
          MenuItem(name: 'Coffee', price: 3,quantity: 3),
          MenuItem(name: 'Soda', price: 4,quantity: 2),
          MenuItem(name: 'Bruchetta', price: 8,quantity: 5),
          MenuItem(name: 'Big Brekkie', price: 16,quantity: 5),
          MenuItem(name: 'Poached Eggs', price: 12,quantity: 2),
          MenuItem(name: 'Garden Salad', price: 10,quantity: 3),
        ];
        break;
      default:
        selectedMenu = []; // Handle any other case or default menu
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupScreen(groupName: groupName, menuList: selectedMenu),
      ),
    );
  }
}
