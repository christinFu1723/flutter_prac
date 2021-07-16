import 'package:flutter/material.dart';
import 'package:demo7_pro/config/theme.dart';
import 'package:demo7_pro/services/app.dart';

class VersionTip extends StatelessWidget {
  final String logoTitle;
  final String versionTips;
  final String version;

  VersionTip({Key key, this.logoTitle, this.versionTips, this.version});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
          child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.download_done_outlined,
                  color: AppTheme.primaryColor,
                ),
                Text(logoTitle ?? '默认标题',
                    style: TextStyle(
                        fontSize: AppTheme.fontSizeTitle,
                        color: AppTheme.primaryColor))
              ],
            ),
            Container(
              width: 120,
              child: Wrap(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Text(versionTips ?? '默认子标题',
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeMini,
                          color: Color(0xff8E9B9B),
                        )),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 1,
                  color: Color(0xffCED5D5),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(9, 0, 9, 0),
                  child: Text(version != null ? '版本 $version' : '默认版本',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeSmall,
                        color: Color(0xff8E9B9B),
                      )),
                ),
                Container(
                  width: 44,
                  height: 1,
                  color: Color(0xffCED5D5),
                ),
              ],
            )
          ],
        ),
      )),
      onTap: () {
        AppService.checkClientVersion(context, tipsy: true);
      },
    );
  }
}
