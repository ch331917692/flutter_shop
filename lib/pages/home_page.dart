import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  String homePageContent = "正在获取数据";
  int page = 1;
  List<Map> hotGoodsList = new List();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();

  @override
  void initState() {
    super.initState();
//    _getHotGoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('百姓生活+'),
      ),
      body:  FutureBuilder(
                future: getHomePageContent(),
                builder: (context, snapshost) {
                  if (snapshost.hasData) {
                    var data = json.decode(snapshost.data.toString());
                    List<Map> swiperDataList =
                        (data['data']['slides'] as List).cast();
                    List<Map> navigatorList =
                        (data['data']['category'] as List).cast();
                    String adPicture = data['data']['advertesPicture']['PICTURE_ADDRESS'];
                    String leaderImage = data['data']['shopInfo']['leaderImage'];
                    String leaderPhone = data['data']['shopInfo']['leaderPhone'];
                    List<Map> recommendDataList =
                    (data['data']['recommend'] as List).cast();
                    List<Map> floorGoodsList1 =
                    (data['data']['floor1'] as List).cast();
                    List<Map> floorGoodsList2 =
                    (data['data']['floor2'] as List).cast();
                    List<Map> floorGoodsList3 =
                    (data['data']['floor3'] as List).cast();

                    String floorPicture1 = data['data']['floor1Pic']['PICTURE_ADDRESS'];
                    String floorPicture2 = data['data']['floor2Pic']['PICTURE_ADDRESS'];
                    String floorPicture3 = data['data']['floor3Pic']['PICTURE_ADDRESS'];
                    return  EasyRefresh(
                      child: ListView(
                        children:<Widget>[
                          SwiperDiy(swiperDataList: swiperDataList),
                          TopNavigator(navigatorList),
                          AdBanner(adPicture),
                          LeaderPhone(leaderImage, leaderPhone),
                          Recommend(recommendDataList),
                          FloorTitle(floorPicture1),
                          FloorContent(floorGoodsList1),
                          FloorTitle(floorPicture2),
                          FloorContent(floorGoodsList2),
                          FloorTitle(floorPicture3),
                          FloorContent(floorGoodsList3),
                          _hotGoods(),
                        ],
                      ),
                      loadMore: _getHotGoods,
                      refreshFooter: ClassicsFooter(
                        key: _footerKey,
                        bgColor: Colors.white,
                        textColor: Colors.pink,
                        moreInfoColor: Colors.pink,
                        showMore: true,
                        noMoreText: '',
                        moreInfo: '加载中',
                        loadReadyText: '上拉加载....',

                      ),
                    );
                  } else {
                    return Center(
                      child: Text('no data'),
                    );
                  }
                })
    );
  }

  Future<void> _getHotGoods() async {
    var formPage = {'page':page};
      request('homePageBelowConten', formData: formPage).then((value){
      var data = json.decode(value.toString());
      List<Map> newGoodsList = (data['data'] as List).cast();
      setState(() {
        hotGoodsList.addAll(newGoodsList);
        page ++;
      });
    });
  }


  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10),
    alignment: Alignment.center,
    color: Colors.transparent,
    padding: EdgeInsets.all(5),
    child: Text('火爆专区'),
  );

 Widget _wrapList(){
   if(hotGoodsList.length != 0){
     List<Widget> listWidget = hotGoodsList.map((value){
       return InkWell(
         onTap: (){},
         child: Container(
           width: ScreenUtil.instance.setWidth(372),
           color: Colors.white,
           padding: EdgeInsets.all(5),
           margin: EdgeInsets.only(bottom: 3),
           child: Column(
             children: <Widget>[
               Image.network(value['image'], width: ScreenUtil.instance.setWidth(370),),
               Text(
                 value['name'],
                 maxLines: 1,
                 overflow: TextOverflow.ellipsis,
                 style: TextStyle(color: Colors.pink, fontSize: ScreenUtil.instance.setSp(26)),
               ),
               Row(
                 children: <Widget>[
                   Text('￥${value['mallPrice']}'),
                   Text('￥${value['price']}',style: TextStyle(color: Colors.black26, decoration: TextDecoration.lineThrough),)
                 ],
               ),
             ],
           ),
         ),
       );
     }).toList();

     return Wrap(
       spacing: 2,
       children: listWidget,
     );
   }else{
     return Text('');
   }
 }

 Widget _hotGoods(){
   return Container(
     child: Column(
       children: <Widget>[
         hotTitle,
         _wrapList()
       ],
     ),
   );
 }

  @override
  bool get wantKeepAlive => true;
}

class SwiperDiy extends StatelessWidget {
  final List swiperDataList;

  SwiperDiy({this.swiperDataList});

  @override
  Widget build(BuildContext context) {

    return Container(
      height: ScreenUtil.instance.setHeight(333),
      width: ScreenUtil.instance.width,
      child: Swiper(
        itemCount: swiperDataList.length,
        itemBuilder: (context, index) {
          return Image.network(
            "${swiperDataList[index]['image']}",
            fit: BoxFit.fill,
          );
        },
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

class TopNavigator extends StatelessWidget {

  final List navigatorList;

  TopNavigator(this.navigatorList);

  Widget _gridViewItemUI(BuildContext context, item){
    return InkWell(
      onTap: (){ print("${item['mallCategoryName']}");},
      child: Column(
        children: <Widget>[
          Image.network(item['image'], width: ScreenUtil.instance.setWidth(95)),
          Text(item['mallCategoryName']),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(navigatorList.length > 10){
      navigatorList.removeRange(10, navigatorList.length);
    }
    return Container(
      height: ScreenUtil.instance.setHeight(320),
        padding: EdgeInsets.all(3),
        child: GridView.count(
          crossAxisCount: 5,
          padding: EdgeInsets.all(5),
          children: navigatorList.map((item){
            return _gridViewItemUI(context, item);
          }).toList(),
        ),
    );
  }

}

class AdBanner extends StatelessWidget {
  final String adPicture;

  AdBanner(this.adPicture);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Image.network(adPicture),
    );
  }
}

class LeaderPhone extends StatelessWidget {
  final String leaderImage;
  final String leaderPhone;

  LeaderPhone(this.leaderImage, this.leaderPhone);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchUrl,
        child: Image.network(leaderImage),
      ),
    );
  }


  void _launchUrl() async{
    String url = 'tel:'+leaderPhone;
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw 'url call exception';
    }
  }
}


class Recommend extends StatelessWidget {
  final List recommendList;

  Recommend(this.recommendList);

  @override
  Widget build(BuildContext context) {
    return Container(
//      height: ScreenUtil.instance.setHeight(380),
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommendList()
        ],
      ),
    );
  }

  Widget _titleWidget(){
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10, 2, 0, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.black12)
        )
      ),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }


  Widget _item(index){
    return InkWell(
      onTap: (){},
      child: Container(
//        height: ScreenUtil.instance.setHeight(330),
        width: ScreenUtil.instance.setWidth(250),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              left: BorderSide(width: 0.5, color: Colors.black12),
          )
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
                '￥${recommendList[index]['price']}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recommendList(){
    return Container(
      height: ScreenUtil.instance.setHeight(350),
//      width: ScreenUtil.instance.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
          itemBuilder: (context, index){
            return _item(index);
          },
        itemCount: recommendList.length,
      ),

    );
  }
}

class FloorTitle extends StatelessWidget {
  final String pictureAddress;

  FloorTitle(this.pictureAddress);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Image.network(pictureAddress),
    );
  }
}

class FloorContent extends StatelessWidget {
  final List floorGoodsList;


  FloorContent(this.floorGoodsList);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _firstRow(),
        _otherRow()
        ],
      ),
    );
  }

  Widget _firstRow(){
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(floorGoodsList[1]),
            _goodsItem(floorGoodsList[2]),
          ],
        ),
      ],
    );
  }

  Widget _otherRow(){
    return
        Row(
          children: <Widget>[
            _goodsItem(floorGoodsList[3]),
            _goodsItem(floorGoodsList[4]),
          ],
        );
  }

  Widget _goodsItem(Map goods){
    return Container(
      width: ScreenUtil.instance.setWidth(375),
      child: InkWell(
        onTap: (){},
        child: Image.network(goods['image']),
      ),
    );
  }
}



