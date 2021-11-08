import 'package:demo7_pro/widgets/loading_container.dart';
import 'package:flutter/material.dart';
import 'package:demo7_pro/model/travel_model.dart';
import 'package:demo7_pro/dao/travel_dao.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:demo7_pro/route/pages/webview/index.dart'
    show WebviewPageRoutes;
import 'package:demo7_pro/route/route_util.dart' show navTo;

const PAGE_SIZE = 10;
const _TRAVEL_URL = '';

class TravelTabPage extends StatefulWidget {
  final String travelUrl;
  final String groupChannelCode;
  final int nowSltTab; // 控制器选择的key值
  final int tabsIndex; // 遍历的key值

  const TravelTabPage(
      {Key key,
      this.travelUrl,
      this.groupChannelCode,
      this.nowSltTab,
      this.tabsIndex})
      : super(key: key);

  @override
  _TravelTabPageState createState() => _TravelTabPageState();
}

class _TravelTabPageState extends State<TravelTabPage>
    with AutomaticKeepAliveClientMixin {
  List<TravelItem> travelItems;
  int pageIndex = 1;
  bool _loading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // if(widget.nowSltTab==widget.tabsIndex){
    //   _loadData();
    // }
    _loadData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadData(loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _loadData({loadMore = false}) async {
    if (loadMore) {
      pageIndex++;
    } else {
      pageIndex = 1;
    }
    setState(() {
      _loading = true;
    });

    try {
      var res = await TravelDao.fetch(widget.travelUrl ?? _TRAVEL_URL,
          widget.groupChannelCode, pageIndex, PAGE_SIZE);
      TravelItemModel model = res['TravelItemModel'];
      // _loading =false;

      setState(() {
        _loading = false;
        List<TravelItem> items = _filterItems(model.resultList);
        if (travelItems != null) {
          travelItems.addAll(items);
        } else {
          travelItems = items;
        }
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print(e);
    }
  }

  Future handleRefresh() async {
    _loadData();
    return null;
  }

  List<TravelItem> _filterItems(List<TravelItem> model) {
    if (model == null) {
      return [];
    }
    List<TravelItem> filterItems = [];
    model.forEach((element) {
      if (element.article != null) {
        filterItems.add(element);
      }
    });
    return filterItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LoadingContainer(
      isLoading: _loading,
      cover: true,
      child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: RefreshIndicator(
              onRefresh: handleRefresh,
              child: NotificationListener(
                child: StaggeredGridView.countBuilder(
                  controller: _scrollController,
                  crossAxisCount: 4,
                  itemCount: travelItems?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) =>
                      _TravelItem(index: index, item: travelItems[index]),
                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),
              ))),
    ));
  }

  @override
  bool get wantKeepAlive => true;
}

class _TravelItem extends StatelessWidget {
  final TravelItem item;
  final int index;

  const _TravelItem({Key key, this.item, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item.article.urls != null && item.article.urls.length > 0) {
          navTo(context, "${WebviewPageRoutes.webview}", arguments: {
            "url": item.article.urls[0].h5Url,
            "title": '详情',
          });
        }
      },
      child: Card(
        child: PhysicalModel(
            color: Colors.transparent,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _itemImage(),
                Container(
                  padding: EdgeInsets.all(4),
                  child: Text(
                    item.article.articleTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                ),
                _infoText()
              ],
            )),
      ),
    );
  }

  _itemImage() {
    return Stack(
      children: [
        Image.network(item.article.images[0]?.dynamicUrl),
        Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                      padding: EdgeInsets.only(right: 3),
                      child: Icon(Icons.location_on,
                          color: Colors.white, size: 12)),
                  LimitedBox(
                    maxWidth: 130,
                    child: Text(
                      _poiName(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  )
                ],
              ),
            ))
      ],
    );
  }

  _poiName() {
    return item.article.pois == null || item.article.pois.length == 0
        ? '未知'
        : item.article.pois[0]?.poiName ?? '未知';
  }

  _infoText() {
    return Container(
      padding: EdgeInsets.fromLTRB(6, 0, 6, 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        ConstrainedBox(
          constraints: BoxConstraints(
              minWidth: 24.0, maxWidth: 24.0, minHeight: 24.0, maxHeight: 24.0),
          child: PhysicalModel(
            color: Colors.transparent,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.article.author?.coverImage?.dynamicUrl,
              width: 24,
              height: 24,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          width: 90,
          child: Text(
            item.article.author?.nickName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12),
          ),
        ),
        Row(
          children: [
            Icon(
              Icons.thumb_up,
              size: 14,
              color: Colors.grey,
            ),
            Padding(
              padding: EdgeInsets.only(left: 3),
              child: Text(
                item.article.likeCount.toString(),
                style: TextStyle(fontSize: 10),
              ),
            )
          ],
        )
      ]),
    );
  }
}
