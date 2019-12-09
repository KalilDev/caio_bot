import 'package:flutter/material.dart';
import 'rounded_notched_shape.dart';

import 'navigation_entry.dart';

class BottomBeautifulNavBar extends StatelessWidget {
  BottomBeautifulNavBar(
      {this.backgroundColor,
      this.activeColor,
      this.inactiveColor,
      this.index,
      this.onChanged,
      @required this.entries});
  final Color backgroundColor;
  final Color activeColor;
  final Color inactiveColor;
  final int index;
  final Function(int) onChanged;
  final List<NavigationEntry> entries;

  @override
  Widget build(BuildContext context) {
    final Color activeColor = this.activeColor ?? Theme.of(context).accentColor;
    final Color inactiveColor =
        this.inactiveColor ?? IconTheme.of(context).color;

    Widget renderItem(Widget child, String title, int i) {
      final bool isActive = i == index;
      return Expanded(
          child: Tooltip(
        message: title,
        child: Material(
            borderRadius: BorderRadius.circular(18.0),
            elevation: 0.0,
            type: MaterialType.transparency,
            child: InkWell(
                highlightColor: activeColor.withAlpha(40),
                splashColor: activeColor.withAlpha(70),
                borderRadius: BorderRadius.circular(18.0),
                onTap: () => onChanged(i),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconTheme(
                          data: IconTheme.of(context).copyWith(
                              color: isActive ? activeColor : inactiveColor),
                          child: child),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 400),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) =>
                                SizeTransition(
                          sizeFactor: animation,
                          axis: Axis.horizontal,
                          axisAlignment: 0,
                          child: child,
                        ),
                        child: isActive
                            ? Text(
                                title,
                                style: Theme.of(context)
                                    .textTheme
                                    .overline
                                    .copyWith(
                                        color: isActive
                                            ? activeColor
                                            : inactiveColor),
                              )
                            : SizedBox(),
                      ),
                    ],
                  ),
                ))),
      ));
    }

    int i = 0;

    return BottomAppBar(
      shape: RoundedShape(BorderRadius.vertical(top: Radius.circular(20.0))),
      color: backgroundColor,
      elevation: 16.0,
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 56,
        child: Row(
            children: entries.map((NavigationEntry entry) {
          i++;
          return renderItem(Icon(entry.icon), entry.label(context), i - 1);
        }).toList()),
      ),
    );
  }
}
