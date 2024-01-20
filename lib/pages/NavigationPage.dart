import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../playerWidgets/FloatingPlayer.dart';
import '../utils/dimension.dart';
import '../widgets/FabPositon.dart';
import 'HomePage.dart';
import 'Podcast.dart';
import 'SearchMusic.dart';
import 'Online.dart';


class NavigationPage extends StatefulWidget {

  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  TextEditingController controllerr = TextEditingController();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> pages =[
    HomePage(),
    Online(),
    SearchMusic(),
    Podcasts(artistId: '568565',)

  ];
  int selectedPage = 0;

  @override
  void initState() {
    // controller.checkPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      appBar:AppBar(
        leading: IconButton(
          icon: Icon(CupertinoIcons.slider_horizontal_3),
          onPressed: (){
            if(scaffoldKey.currentState!.isDrawerOpen){
              scaffoldKey.currentState!.closeDrawer();
            }else{
              scaffoldKey.currentState!.openDrawer();
            }
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
        title: Text("SignumBeat",),
        // backgroundColor: AppColor.mainColor,
      ),
      drawer: Drawer(),
      body: pages[selectedPage],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            selectedPage = index;
          });
        },
        // backgroundColor: ,
        selectedIndex: selectedPage,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.music_note),
            label: 'My music',
          ),
          NavigationDestination(
            icon: Icon(Icons.music_note_outlined),
            label: 'Online',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.podcasts),
            label: 'Podcasts',
          ),
        ],
      ),
      floatingActionButton:PositionedFloatingActionButton(
          top: Dimension.height(15),
          left: Dimension.width(5),
          floatingActionButton:  Builder(
              builder: (context) {
                return FloatingPlayer();
              }
          ),
      ),

    );
    }
}
