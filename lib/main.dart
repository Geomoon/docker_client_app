import 'package:docker_client_app/view/containers/containers_screen.dart';
import 'package:docker_client_app/view/home/home_screen.dart';
import 'package:docker_client_app/view/images/images_screen.dart';
import 'package:flutter/material.dart';

import 'view/shared/themes/color_schemes.g.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Docker Client',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme,
          textTheme: darkTextTheme),
      themeMode: ThemeMode.dark,
      home: const Layout(),
    );
  }
}

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final _views = const <Widget>[
    HomeScreen(),
    ContainersScreen(),
    ImagesScreen(),
    Center(child: Text('Mounts')),
    Center(child: Text('Networks')),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: <Widget>[
            SideBar(navWidget: buildNavigationRail()),
            VerticalDivider(
                thickness: 1,
                width: 1,
                color: Theme.of(context).colorScheme.outline),
            Expanded(
                flex: 8,
                child: Container(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: _views[_selectedIndex])),
          ],
        ),
      ),
    );
  }

  void setIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  NavigationRail buildNavigationRail() {
    const labelType = NavigationRailLabelType.all;

    final textStyle =
        TextStyle(color: fonts['color'], fontFamily: 'Inter', fontSize: 12);

    const destinations = <NavigationRailDestination>[
      NavigationRailDestination(
          icon: Icon(Icons.space_dashboard_outlined),
          selectedIcon: Icon(Icons.space_dashboard),
          label: Text('Home')),
      NavigationRailDestination(
          icon: Icon(Icons.widgets_outlined),
          selectedIcon: Icon(Icons.widgets_rounded),
          label: Text('Containers')),
      NavigationRailDestination(
          icon: Icon(Icons.layers_outlined),
          selectedIcon: Icon(Icons.layers_rounded),
          label: Text('Images')),
      NavigationRailDestination(
          icon: Icon(Icons.dns_outlined),
          selectedIcon: Icon(Icons.dns_rounded),
          label: Text('Mounts')),
      NavigationRailDestination(
          icon: Icon(Icons.stream_outlined),
          selectedIcon: Icon(Icons.stream_rounded),
          label: Text('Networks')),
    ];

    return NavigationRail(
        selectedIndex: _selectedIndex,
        groupAlignment: -1,
        onDestinationSelected: setIndex,
        selectedLabelTextStyle: textStyle,
        unselectedLabelTextStyle: textStyle,
        labelType: labelType,
        destinations: destinations);
  }
}

class SideBar extends StatelessWidget {
  const SideBar({super.key, required this.navWidget});

  final Widget navWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      color: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(flex: 1, child: buildCircleImage()),
          Expanded(flex: 8, child: navWidget)
        ],
      ),
    );
  }

  Center buildCircleImage() {
    return Center(
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(18.0)),
        child:
            Image.asset('assets/images/logo_blue.png', width: 60, height: 60),
      ),
    );
  }
}
