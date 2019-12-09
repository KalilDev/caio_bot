import 'package:flutter/material.dart';

typedef LocaleCallback = String Function(BuildContext);

class NavigationEntry {
  const NavigationEntry({@required this.icon, @required this.label});
  final IconData icon;
  final LocaleCallback label;
}

final List<NavigationEntry> kAppEntries = [
  NavigationEntry(
      icon: Icons.calendar_view_day,
      label: (BuildContext context) => 'Feed'),
  NavigationEntry(
      icon: Icons.settings,
      label: (BuildContext context) => 'Configurações'),
];
