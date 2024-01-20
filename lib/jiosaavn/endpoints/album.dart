
import '../client.dart';
import '../collection/endpoints.dart';
import '../models/album.dart';

class AlbumEndpoint extends BaseClient {
  AlbumEndpoint([super.options]);

  Future<AlbumResponse> detailsById(String id) async {
    // api v4 does not contain media_preview_url
    final response = await request(call: endpoints.albums.id, queryParameters: {
      'albumid': id,
    });
print(response['more_info']);
    final albumResults =
        AlbumResponse.fromAlbumRequest(AlbumRequest.fromJson(response));

    return albumResults;
  }
}
