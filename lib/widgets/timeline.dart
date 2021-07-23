import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter/material.dart';
import 'package:demo7_pro/config/stepTimelineConfig.dart';

class StepTimeline extends StatelessWidget {
  final List<String> data;
  final int nowStep;

  StepTimeline({Key key, this.data, this.nowStep});

  List<Widget> _getTimeline(BuildContext context) {
    var timelineArr = this
        .data
        .asMap()
        .entries
        .map((entry) => TimelineTile(
              isFirst: entry.key == 0,
              isLast: entry.key == this.data.length - 1,
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.center,
              endChild: Container(
                  alignment: Alignment.center,
                  constraints: const BoxConstraints(
                    minWidth: 110,
                  ),
                  color: Colors.transparent,
                  child: Wrap(
                    children: [
                      Text(
                        entry.value,
                        style: TextStyle(
                            color: _indicatorColor(entry), fontSize: 12),
                      )
                    ],
                  )),
              indicatorStyle:
                  IndicatorStyle(indicator: _indicatorCustom(context, entry)),
              beforeLineStyle: LineStyle(
                color: entry.key <= this.nowStep
                    ? StepTimelineConfig.doneIndicatorColor
                    : StepTimelineConfig.defaultIndicatorColor.withOpacity(0.2),
              ),
              afterLineStyle: LineStyle(
                color: entry.key < this.nowStep
                    ? StepTimelineConfig.doneIndicatorColor
                    : StepTimelineConfig.defaultIndicatorColor.withOpacity(0.2),
              ),
            ))
        .toList();
    return timelineArr;
  }

  Widget _indicatorCustom(BuildContext context, entry) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: entry.key > this.nowStep
                ? StepTimelineConfig.defaultIndicatorColor
                : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: _indicatorColor(entry, shadow: true),
                spreadRadius: 8,
                // blurRadius: 10
              ),
              BoxShadow(
                color: _indicatorColor(entry),
                spreadRadius: 4,
                // blurRadius: 10
              ),
              // BoxShadow(color: _indicatorColor(entry,shadow: true), blurRadius: 0.5)
            ],
          ),
        )
      ],
    );
  }

  Color _indicatorColor(entry, {shadow = false}) {
    var color;
    if (!shadow) {
      color = entry.key == this.nowStep
          ? StepTimelineConfig.nowIndicatorColor
          : entry.key < this.nowStep
              ? StepTimelineConfig.doneIndicatorColor
              : StepTimelineConfig.defaultIndicatorColor;
    } else {
      color = entry.key == this.nowStep
          ? StepTimelineConfig.nowIndicatorColor.withOpacity(0.2)
          : entry.key < this.nowStep
              ? StepTimelineConfig.doneIndicatorColor.withOpacity(0.2)
              : StepTimelineConfig.defaultIndicatorColor.withOpacity(0.2);
    }

    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 79,
      color: Colors.white,
      child: Row(
        children: _getTimeline(context),
      ),
    );
  }
}
