// import 'package:flutter/material.dart';
// import 'package:jammies_app/models/user.dart';
// import 'package:jammies_app/widgets/layout/app_layout.dart';

// class TabbedLayout extends StatelessWidget {
//   final int currentIndex;
//   final ValueChanged<int> onTabChange;
//   final List<Widget> pages;
//   final GlobalKey<ScaffoldState> scaffoldKey;
//   final User user;

//   const TabbedLayout({
//     super.key,
//     required this.currentIndex,
//     required this.onTabChange,
//     required this.pages,
//     required this.scaffoldKey,
//     required this.user,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AppLayout(
//       user: user,
//       scaffoldKey: scaffoldKey,
//       onDrawerTap: () => scaffoldKey.currentState?.openDrawer(),
//       child: pages[currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: currentIndex,
//         onTap: onTabChange,
//         backgroundColor: Colors.black,
//         selectedItemColor: Colors.white,
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
//           BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.library_music),
//             label: 'Biblioteca',
//           ),
//         ],
//       ),
//     );
//   }
// }
