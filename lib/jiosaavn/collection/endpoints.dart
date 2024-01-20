const endpoints = (
  // history:'webapi.getLaunchData',
  // modules: 'content.getBrowseModules',
  modules: 'webapi.getLaunchData',
  search: (
    all: 'autocomplete.get',
    songs: 'search.getResults',
    albums: 'search.getAlbumResults',
    artists: 'search.getArtistResults',
    playlists: 'search.getPlaylistResults',
  ),
  songs: (
    id: 'song.getDetails',
    link: 'webapi.get'
  ),
  albums: (id: 'content.getAlbumDetails',),
  playlists: (id: 'playlist.getDetails',),
  artists: (
    id: 'artist.getArtistPageDetails',
    songs: 'artist.getArtistMoreSong',
    albums: 'artist.getArtistMoreAlbum',
    topSongs: 'search.artistOtherTopSongs',
  ),
  lyrics: 'lyrics.getLyrics',

module:(
 charts:"content.getCharts",


),
);
