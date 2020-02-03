# Playlist

The Kaltura Player exposes several APIs that are used for loading, configuring, and manipulating playlists.

## Table of Contents

- [Load A Playlist](#load-a-playlist)
  - [By Playlist ID](#by-playlist-id-ovp-only)
  - [By Entry List](#by-entry-list)
  - [By Configuration](#by-configuration)
- [Configure the Playlist](#configure-the-playlist)
- [Switching Items](#switching-items)
- [Change Playlist](#change-playlist)

### Load A Playlist

Before loading a playlist, you'll need to set up a Kaltura Player instance as follows.

```java
 val playerInitOptions = PlayerInitOptions(PARTNER_ID)
 playerInitOptions.setAutoPlay(true)
 player = KalturaOvpPlayer.create(this@MainActivity, playerInitOptions)
```

To learn how to set up a Kaltura Player, see [getting-started-android](https://developer.kaltura.com/player/android/getting-started-android).
<br>Once you have a Kaltura Player instance, you can load a playlist using one of the following methods:

#### By Playlist ID (OVP Only)

To load a playlist by ID, use OVPPlaylistIdOptions when calling `loadPlaylistById` method.

```java
val ovpPlaylistIdOptions = OVPPlaylistIdOptions()
ovpPlaylistIdOptions.playlistId = "0_w0hpzdni"
ovpPlaylistIdOptions.loopEnabled = true
ovpPlaylistIdOptions.shuffleEnabled = false

player?.loadPlaylistById(ovpPlaylistIdOptions,
KalturaPlayer.OnPlaylistControllerListener() { playlistController, error ->
       if (error != null) {
          Snackbar.make(findViewById(android.R.id.content), error.message, Snackbar.LENGTH_LONG).show()
       } else {
          log.d("OVPPlaylist Loaded  entry = ${playlistController.playlist.id}")
       }
})
```

#### By Entry List


##### OVP

To load a playlist by entryId list, use OVPMediaOptions & OVPPlaylistOptions when calling loadPlaylist method.
<br>This method creates a playlist according to the given entries.

```java
var OVPMediaOptions1 = buildOvpMediaOptions()
var OVPMediaOptions2 = buildOvpMediaOptions()
var OVPMediaOptions3 = buildOvpMediaOptions()

var mediaList = listOf(OVPMediaOptions1, OVPMediaOptions2, OVPMediaOptions3)

val ovpPlaylistOptions = OVPPlaylistOptions()
ovpPlaylistOptions.playlistMetadata = PlaylistMetadata().setName("TestOVPPlayList").setId("2")
ovpPlaylistOptions.ovpMediaOptionsList = mediaList
ovpPlaylistOptions.countDownOptions = CountDownOptions()

player?.loadPlaylist(ovpPlaylistOptions, 
	KalturaPlayer.OnPlaylistControllerListener() { playlistController, error ->
    if (error != null) {
        Snackbar.make(findViewById(android.R.id.content), error.message, Snackbar.LENGTH_LONG).show()
    } else {
        log.d("OVPPlaylist Loaded  entry = ${playlistController.playlist.id}")
    }
})


private fun buildOvpMediaOptions(): OVPMediaOptions {
     val ovpMediaOptions = OVPMediaOptions()
     ovpMediaOptions.entryId = ENTRY_ID
     ovpMediaOptions.ks = null
     ovpMediaOptions.startPosition = START_POSITION
     ovpMediaOptions.countDownOptions = CountDownOptions();
     return ovpMediaOptions
}
```

##### OTT

To load a playlist by entryId list, use OVPMediaOptions & OTTPlaylistOptions when calling loadPlaylist method.
<br>This method creates a playlist according to the given entries.

```java
var OTTMediaOptions1 = buildOttMediaOptions("548576", "Mobile_Main")
val OTTMediaOptions2 = buildOttMediaOptions("548577", "STB_Main")
var OTTMediaOptions3 = buildOttMediaOptions("548576","Mobile_Main")

var mediaList = listOf(OTTMediaOptions1, OTTMediaOptions2, OTTMediaOptions3)

val ottPlaylistIdOptions = OTTPlaylistOptions()
ottPlaylistIdOptions.playlistMetadata = PlaylistMetadata().setName("TestOTTPlayList").setId("1")
ottPlaylistIdOptions.ottMediaOptionsList = mediaList

player?.loadPlaylist(ottPlaylistIdOptions,
	 KalturaPlayer.OnPlaylistControllerListener() { playlistController, error ->
    if (error != null) {
        Snackbar.make(findViewById(android.R.id.content), error.message, Snackbar.LENGTH_LONG).show()
    } else {
        log.d("OTTPlaylist Loaded  entry = ${playlistController.playlist.id}")
   }
})

private fun buildOttMediaOptions(assetId : String, format : String): OTTMediaOptions {
    val ottMediaOptions = OTTMediaOptions()
    ottMediaOptions.assetId = assetId
    ottMediaOptions.assetType = APIDefines.KalturaAssetType.Media
    ottMediaOptions.contextType = APIDefines.PlaybackContextType.Playback
    ottMediaOptions.assetReferenceType = APIDefines.AssetReferenceType.Media
    ottMediaOptions.protocol = PhoenixMediaProvider.HttpProtocol.Http
    ottMediaOptions.ks = null
    ottMediaOptions.referrer = "app://MyTestApp";
    ottMediaOptions.startPosition = START_POSITION
    ottMediaOptions.formats = arrayOf(format)
    return ottMediaOptions
}
```

#### By Configuration

#### Basic

You can load a Manual Basic playlist by configuring the playlist data and items explicitly using the [`configure`](./api.md#configure-3) method.

```java
var BasicMediaOptions0 = createMediaEntry(0,"1_w9zx2eti1", SOURCE_URL)
val BasicMediaOptions1 = createMediaEntry(1,"0_uka1msg4", SOURCE_URL2)
var BasicMediaOptions2 = createMediaEntry(2,"1_w9zx2eti2", SOURCE_URL)

var basicMediaOptionsList = listOf(BasicMediaOptions0, BasicMediaOptions1, BasicMediaOptions2)
        
val basicPlaylistIdOptions = BasicPlaylistOptions()
basicPlaylistIdOptions.playlistMetadata = PlaylistMetadata().setName("TestBasicPlayList").setId("1")
basicPlaylistIdOptions.basicMediaOptionsList = basicMediaOptionsList
        
player?.loadPlaylist(basicPlaylistIdOptions, 
	KalturaPlayer.OnPlaylistControllerListener() { playlistController, error ->
   if (error != null) {
      Snackbar.make(findViewById(android.R.id.content), error.message, Snackbar.LENGTH_LONG).show()
   } else {
      log.d("BasicPlaylist Loaded  entry = ${playlistController.playlist.id}")
   }
})

private fun createMediaEntry(index: Int, id: String, url : String): BasicMediaOptions {

    val mediaEntry = PKMediaEntry()
    mediaEntry.id = id

    mediaEntry.mediaType = PKMediaEntry.MediaEntryType.Vod
    val mediaSources = createMediaSources(id, url)
    mediaEntry.sources = mediaSources
    return BasicMediaOptions(index, mediaEntry, CountDownOptions())
}
```



## Configure the Playlist

### Auto Continue

By default, once the current item is ended, the playlist continues to the next item automatically.
<br>To change this behavior, configure the playlist options using one of the following methods:
<br>Via the API:

```java

       // OVPPlaylistIdOptions
       
       val ovpPlaylistIdOptions = OVPPlaylistIdOptions()
        ovpPlaylistIdOptions.playlistId = "zzzzzzz"
        ovpPlaylistIdOptions.startIndex = 0
        ovpPlaylistIdOptions.ks = ""
        ovpPlaylistIdOptions.countDownOptions = CountDownOptions()
        ovpPlaylistIdOptions.useApiCaptions = false
        ovpPlaylistIdOptions.loopEnabled = false
        ovpPlaylistIdOptions.shuffleEnabled = false
        ovpPlaylistIdOptions.autoContinue =  true
        
       // OVPPlaylistOptions
       
       val ovpPlaylistOptions = OVPPlaylistOptions()
        ovpPlaylistOptions.startIndex = 0
        ovpPlaylistOptions.ks =  ""
        ovpPlaylistOptions.countDownOptions = CountDownOptions()
        ovpPlaylistOptions.playlistMetadata = PlaylistMetadata().setName("TestOTTPlayList").setId("1")
        ovpPlaylistOptions.ovpMediaOptionsList = <ovpMediaOptionsList> //(useApiCaptions is configured for each media separetly)
        ovpPlaylistOptions.loopEnabled = false
        ovpPlaylistOptions.shuffleEnabled = false
        ovpPlaylistOptions.autoContinue = true
        
       // OVPPlaylistOptions 
       val ottPlaylistIdOptions = OTTPlaylistOptions()
        ottPlaylistIdOptions.startIndex = 0
        ottPlaylistIdOptions.countDownOptions = CountDownOptions()
        ottPlaylistIdOptions.playlistMetadata = PlaylistMetadata().setName("TestOTTPlayList").setId("1")
        ottPlaylistIdOptions.ottMediaOptionsList = <ottMediaOptionsList>
        ottPlaylistIdOptions.loopEnabled = false
        ottPlaylistIdOptions.shuffleEnabled = false
        ottPlaylistIdOptions.autoContinue = true
        
       // BasicPlaylistOptions  
       val basicPlaylistIdOptions = BasicPlaylistOptions()
        basicPlaylistIdOptions.startIndex =  0
        basicPlaylistIdOptions.playlistMetadata = PlaylistMetadata().setName("TestBasicPlayList").setId("1")
        basicPlaylistIdOptions.countDownOptions = CountDownOptions()
        basicPlaylistIdOptions.basicMediaOptionsList = basicMediaOptionsList
        basicPlaylistIdOptions.loopEnabled = false
        basicPlaylistIdOptions.shuffleEnabled = false
        basicPlaylistIdOptions.autoContinue = true
        
```

> Note: The `autoContinue` property is relevant only for the second item onwards.
> <br>To play the first entry automatically, use the [`autoplay`](https://github.com/kaltura/playkit-js/blob/master/docs/autoplay.md) configuration.

For full playlist options see [`KPPlaylistOptions`](./api.md#kpplaylistoptions).

### Countdown

When the current item is about to end and the playlist is set to continue automatically, the user will see a countdown displayed. The user can then skip to the next item immediately or cancel the switching.
![playlist-countdown](images/playlist-countdown.png)

By default, the countdown is displayed for 10 seconds until the end.
<br>To change this behavior, configure the [`countdown`](./api.md#kpplaylistcountdownoptions) under [`KPPlaylistConfigObject`](./api.md#kpplaylistconfigobject):
<br> For example, to show the countdown for 20 seconds until the end, configure:
<br>Via the API:

```javascript
kalturaPlayer.loadPlaylist({playlistId: '123456'}, {countdown: {duration: 20}});
```

```javascript
kalturaPlayer.loadPlaylistByEntryList({entries: [{entryId: '01234'}, {entryId: '56789'}]}, {countdown: {duration: 20}});
```

By configuration:

```javascript
kalturaPlayer.configure({
  playlist: {
    countdown: {
      duration: 20
    }
  }
});
```

To show the countdown in a specific moment (usually to enable the user to skip the end subtitles) configure:

```javascript
kalturaPlayer.loadPlaylist({playlistId: '123456'}, {countdown: {timeToShow: 600}});
```

In this case the countdown will display at the 600th second for 10 seconds, and then will skip to the next item.

For full countdown options see [`KPPlaylistCountdownOptions`](./api.md#kpplaylistcountdownoptions).

## Switching Items

Using the [`playlist`](./api.md#playlist) API, you can get the playlist data and then switch between the items.

```javascript
// switch to the next item
kalturaPlayer.playlist.playNext();

// switch to the previous item
kalturaPlayer.playlist.playPrev();

// switch to a specific item by index
const lastItemIndex = kalturaPlayer.playlist.items.length - 1;
kalturaPlayer.playlist.playItem(lastItemIndex);
```

For the complete `playlist` API, see [PlaylistManager](./api.md#playlistmanager).

## Change Playlist

To clean the playlist data, you'll need to call the [`playlist.reset`](./api.md#reset-2) method.
<br>Here is an example how to change the playlist using the [`playlist events`](./api.md#playlisteventtype) and [`playlist.reset`](./api.md#reset-2) method.

```javascript
kalturaPlayer.loadPlaylist({playlistId: '01234'});
kalturaPlayer.addEventListener(KalturaPlayer.playlist.PlaylistEventType.PLAYLIST_ENDED, () => {
  kalturaPlayer.playlist.reset();
  kalturaPlayer.loadPlaylist({playlistId: '56789'});
});
```

> Note: The playlist [config](./api.md#KPPlaylistConfigObject) is not removed on reset.

```javascript
kalturaPlayer.loadPlaylist({playlistId: '01234'}, {options: {autoContinue: false}});
kalturaPlayer.playlist.reset();
kalturaPlayer.loadPlaylist({playlistId: '56789'}).then(() => {
  console.log(kalturaPlayer.playlist.options.autoContinue); // false
});
```

> To change this behavior, you'll need to override the configuration as follows:

```javascript
kalturaPlayer.loadPlaylist({playlistId: '01234'}, {options: {autoContinue: false}});
kalturaPlayer.playlist.reset();
kalturaPlayer.loadPlaylist({playlistId: '56789'}, {options: {autoContinue: true}}).then(() => {
  console.log(kalturaPlayer.playlist.options.autoContinue); // true
});
```
