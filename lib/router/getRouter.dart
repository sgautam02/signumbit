import 'package:SignumBeat/pages/NavigationPage.dart';
import 'package:SignumBeat/pages/Online.dart';
import 'package:SignumBeat/pages/SearchMusic.dart';
import 'package:SignumBeat/pages/tileDetails/OnlinePlaylistDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class GetRouter{
  static String home='/';
  static String online='/online';
  static String onlinePlayListDetails='/onlinePlayListDetails';
  static String search='/search';
  static String podcasts='/podcasts';

  static String getOnlinePlayListDetails()=>onlinePlayListDetails;
  static String getHomeRoute()=>home;
  static String getOnline()=>online;
  static String getPodcasts()=>podcasts;
  static String getSearch()=>search;
  static List<GetPage> routes=[
    GetPage(name: home, page: ()=>NavigationPage()),
    GetPage(name: online, page: ()=>Online()),
    // GetPage(
    //   name: 'onlinePlayListDetails',
    //   binding: DependencyBinding(),
    //   page: () => OnlinePlayListDetails(playlistId: ,),
    //   arguments:{'playlistId'}
    //
    // ),
    GetPage(name: search, page: ()=>SearchMusic()),
    GetPage(name: podcasts, page: ()=>Center(child: Text("Podcasts"),))

  ];

}


class DependencyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnlinePlayListDetails>(() {
      final Map<String, dynamic> args = Get.arguments;
      final String playlistId = args['playlistId']??'';
      return OnlinePlayListDetails(playlistId: playlistId);
    });
  }
}