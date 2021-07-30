import 'package:flutter/material.dart';
import 'package:demo7_pro/config/theme.dart' show AppTheme;
import 'package:logger/logger.dart';

class CheckBoxGroup extends StatefulWidget {
  final List<Map<String, dynamic>> group;
  final Widget Function(
          Map<String, dynamic> item,
          List<Map<String, dynamic>> group,
          int index,
          Function(List<Map<String, dynamic>> group) handleGroupChange)
      childCreateFn;
  final Function(List<Map<String, dynamic>> group) handleGroupChange;

  CheckBoxGroup(
      {Key key, this.group, this.childCreateFn, this.handleGroupChange})
      : super(key: key);

  @override
  _CheckBoxGroupState createState() => _CheckBoxGroupState();
}

class _CheckBoxGroupState extends State<CheckBoxGroup> {
  @override
  void initState() {
    for (var item in widget.group) {
      item['controller'] = TextEditingController();
    }
    super.initState();
  }

  @override
  void dispose() {
    for (var item in widget.group) {
      if (item['controller'] != null) {
        try {
          item['controller'].dispose();
        } catch (e) {
          Logger().e(e);
        }
      }
    }
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: widget.group != null
          ? widget.group
              .asMap()
              .entries
              .map((entriesItem) => _singleCheckbox(
                  index: entriesItem.key, item: entriesItem.value))
              .toList()
          : [],
    ));
  }

  Widget _singleCheckbox({int index, Map<String, dynamic> item}) {
    return GestureDetector(
      child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(bottom: 15, right: 10, left: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                    color: item['selected'] == 'true'
                        ? AppTheme.secondColor
                        : AppTheme.lightTextColor.withOpacity(0.6),
                    blurRadius: 1.5)
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.check_circle,
                size: 16,
                color: item['selected'] == 'true'
                    ? AppTheme.secondColor
                    : AppTheme.lightTextColor.withOpacity(0.6),
              ),
              Padding(padding: EdgeInsets.only(right: 11)),
              Expanded(
                child: Text(
                  item['title'] ?? '',
                  style: TextStyle(color: AppTheme.titleColor, fontSize: 14),
                ),
              ),
              Container(
                  child: widget.childCreateFn(item, widget.group, index,
                          widget.handleGroupChange) ??
                      Container())
            ],
          )),
      onTap: () {
        setState(() {
          if (widget.group[index]['selected'] != 'true') {
            widget.group[index]['selected'] = 'true';
          } else {
            widget.group[index]['selected'] = 'false';
          }
          widget.handleGroupChange(widget.group);
        });
      },
    );
  }
}
