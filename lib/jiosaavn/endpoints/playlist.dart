import '../client.dart';
import '../collection/endpoints.dart';
import '../models/playlist.dart';

class PlaylistEndpont extends BaseClient {
  PlaylistEndpont([super.options]);

  Future<PlaylistResponse> detailsById(String id) async {
    // api v4 does not contain media_preview_url
    final response = await request(call: endpoints.playlists.id, queryParameters: {
      'listid': id,
    });
    // print(response);
    final playlistresult = PlaylistResponse.fromJson(response);


    return playlistresult;
  }
}