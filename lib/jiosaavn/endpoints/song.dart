import 'package:dio/dio.dart';

import '../client.dart';
import '../collection/endpoints.dart';
import '../models/song.dart';

class SongEndpoint extends BaseClient {
  SongEndpoint([super.options]);

  Future<List<SongResponse>> detailsByIds(List<String> ids) async {
    // api v4 does not contain media_preview_url
    final response = await request(call: endpoints.songs.id, queryParameters: {
      "pids": ids.join(','),
    });

    if (response["songs"] == null || response["songs"]?.isNotEmpty == false) {
      throw DioException(
        requestOptions: RequestOptions(
          baseUrl: options?.baseUrl,
          queryParameters: options?.queryParameters,
        ),
        error: "No songs found",
        type: DioExceptionType.badResponse,
      );
    }

    return (response["songs"] as List)
        .map(
          (song) => SongResponse.fromSongRequest(SongRequest.fromJson(song)),
        )
        .toList()
        .cast<SongResponse>();
  }
  Future<SongResponse> detailsById(String id) async {
    // api v4 does not contain media_preview_url
    final response = await request(call: endpoints.songs.id, queryParameters: {
      "pids": id,
    });

    if (response["songs"] == null || response["songs"]?.isEmpty == true) {
      throw DioException(
        requestOptions: RequestOptions(
          baseUrl: options?.baseUrl,
          queryParameters: options?.queryParameters,
        ),
        error: "No songs found",
        type: DioExceptionType.badResponse,
      );
    }

    // Assuming that response["songs"] is a list, get the first item
    final songData = response["songs"][0];

    // Map the song data to a SongResponse object
    return SongResponse.fromSongRequest(SongRequest.fromJson(songData));
  }



}
