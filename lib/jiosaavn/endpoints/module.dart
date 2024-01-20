import '../client.dart';
import '../collection/endpoints.dart';
import '../models/module.dart';

class ModuleEndpoint extends BaseClient {
  ModuleEndpoint([super.options]);

  // final jio = JioSaavnClient();

  Future<ModuleResponse> getModules() async {
    final response = await request(call: endpoints.modules);

    // print(response['charts']);
    final module = ModuleResponse.fromJson(response);
    return module;
  }
  Future<List?> getChart() async {
    var module= await getModules();
    var chart= module.charts;
    // print(chart);
    return chart;
  }
  Future<List?> getArtist()async {
    var module =await getModules();
    var artist = module.artist_recos;
    // print(artist);
    return artist;
  }
  Future<Map<String, dynamic>?> getGlobalConfig() async {
    var module= await getModules();
    var global= await module.global_config;
    // print(global);
    return global;
  }
  Future<List?> getTopPlaylist() async {
    var module= await getModules();
    var topPlaylist= module.topPlaylists;
    var ids=topPlaylist?.map((e) =>e['listid'] ).toList();
    return ids;

  }
}