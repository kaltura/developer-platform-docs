# Playlist

Kaltura Player provides several APIs that are used for loading, configuring, and manipulating playlists.

## Table of Contents

- [Load Playlist](#load-playlist)
  - [By Playlist ID](#by-playlist-id-ovp-only)
  - [By Entry List](#by-entry-list)
  - [By Configuration](#by-configuration)
- [Configure the Playlist](#configure-the-playlist)
- [PlaylistController Interface](#playlistcontroller-interface)
- [Playlist Navigation](#playlist-navigation)
- [Change Playlist](#change-playlist)
- [Playlist Events](#playlist-events)

### Load A Playlist
Before loading a playlist, you'll need to set up a Kaltura Player instance:

```java
 val playerInitOptions = PlayerInitOptions(PARTNER_ID)
 playerInitOptions.setAutoPlay(true)
 player = KalturaOvpPlayer.create(this@MainActivity, playerInitOptions)
```

To learn how to set up a Kaltura Player, please go over this document: [getting-started-android](https://developer.kaltura.com/player/android/getting-started-android).
<br>Once you have a Kaltura Player instance, you can load a playlist using one of the following methods:

#### By Playlist ID (OVP Only)

To load a playlist by ID, use OVPPlaylistIdOptions when calling `loadPlaylistById` method.

```java
val ovpPlaylistIdOptions = OVPPlaylistIdOptions()
ovpPlaylistIdOptions.playlistId = "0_w0hpzdni"
ovpPlaylistIdOptions.loopEnabled = true

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
var ovpMediaOptions1 = buildOvpMediaOptions()
var ovpMediaOptions2 = buildOvpMediaOptions()
var ovpMediaOptions3 = buildOvpMediaOptions()

var mediaList = listOf(ovpMediaOptions1, ovpMediaOptions2, ovpMediaOptions3)

val ovpPlaylistOptions = OVPPlaylistOptions()
ovpPlaylistOptions.playlistMetadata = PlaylistMetadata().setName("TestOVPPlayList").setId("2")
ovpPlaylistOptions.ovpMediaOptionsList = mediaList
ovpPlaylistOptions.playlistCountDownOptions = CountDownOptions()

player?.loadPlaylist(ovpPlaylistOptions, 
	KalturaPlayer.OnPlaylistControllerListener() { playlistController, error ->
    if (error != null) {
        Snackbar.make(findViewById(android.R.id.content), error.message, Snackbar.LENGTH_LONG).show()
    } else {
        log.d("OVPPlaylist Loaded  entry = ${playlistController.playlist.id}")
    }
})

private fun buildOvpMediaOptions(): OVPMediaOptions {
      var ovpMediaAsset = OVPMediaAsset()
      ovpMediaAsset.entryId = ENTRY_ID
      ovpMediaAsset.ks = null
      val ovpMediaOptions = OVPMediaOptions(ovpMediaAsset)
      ovpMediaOptions.startPosition = START_POSITION
      ovpMediaOptions.playlistCountDownOptions = CountDownOptions();

     return ovpMediaOptions
}
```

##### OTT

To load a playlist by entryId list, use `OVPMediaOptions` & `OTTPlaylistOptions` when calling `loadPlaylist` method.
<br>This method creates a playlist according to the given entries.

```java
var ottMediaOptions1 = buildOttMediaOptions("111111", "XXX_Main")
val ottMediaOptions2 = buildOttMediaOptions("222222", "YYY_Main")
var ottMediaOptions3 = buildOttMediaOptions("333333", "ZZZ_Main")

var mediaList = listOf(ottMediaOptions1, ottMediaOptions2, ottMediaOptions3)

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
	val ottMediaAsset = OTTMediaAsset()
    ottMediaAsset.assetId = assetId
    ottMediaAsset.assetType = APIDefines.KalturaAssetType.Media
    ottMediaAsset.contextType = APIDefines.PlaybackContextType.Playback
    ottMediaAsset.assetReferenceType = APIDefines.AssetReferenceType.Media
    ottMediaAsset.protocol = PhoenixMediaProvider.HttpProtocol.Https
    ottMediaOptions.ks = null
    ottMediaOptions.referrer = "app://MyTestApp";
    ottMediaOptions.formats = listOf(format)
    
    val ottMediaOptions = OTTMediaOptions(ottMediaAsset)
    ottMediaOptions.startPosition = START_POSITION
    return ottMediaOptions
}
```

#### By Configuration

#### Basic

You can load a Manual Basic playlist by configuring the playlist data and items explicitly using the [`configure`](./api.md#configure-3) method.

```java
var basicMediaOptions0 = createBasicMediaOptions("1_w9zx2eti1", SOURCE_URL, CountDownOptions(50000, 10000, true))
val basicMediaOptions1 = createBasicMediaOptions("0_uka1msg4", SOURCE_URL2, CountDownOptions(10000, true))
var basicMediaOptions2 = createBasicMediaOptions("1_w9zx2eti2", SOURCE_URL, CountDownOptions())

var basicMediaOptionsList = listOf(basicMediaOptions0, basicMediaOptions1, basicMediaOptions2)
        
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

private fun createBasicMediaOptions(id: String, url : String, countdownOptions: CountDownOptions): BasicMediaOptions {

  val mediaEntry = PKMediaEntry()
  mediaEntry.id = id

  mediaEntry.mediaType = PKMediaEntry.MediaEntryType.Vod
  val mediaSources = createMediaSources(id, url)
  mediaEntry.sources = mediaSources
  return BasicMediaOptions(mediaEntry, countdownOptions)
}
```

## Configure the Playlist

### Playlist Options
-----------------------
#### Playlist Metadata - `playlistMetadata`
Should be used for all Playlists except the OVP by id configuration where this data is retrieved from the BE.
#### Start Index - `startIndex`
The index that the playlist playback should start from (default index = 0)
#### Loop - `loopEnabled`
The playlist will play the first media in the playlist once the last media in the playlist has ended (default false)
#### Auto Continue -`autoContinue`
The next media in the playlist will be played automatically once the previous media ended (default true)
#### Recover On Error - `recoverOnError`
The playlist manager is able to recover from errors once that flag is enabled, so it will continue to the next media whether the current media is incorrect or it's URL is broken. If auto continue is enabled it will auto play without user intervention.
#### Count Down Options - `playlistCountDownOptions`
The logic by which count down start event will be fired (default is 10 last sec for 10 sec).
if `autoContinue` feature is enabled  at the end of the count down the `PlaylistController` will trigger auto continue feature to play next media. If auto continue == false countdown will events will not be fired.
If `loop` is disabled the events will not be fired for last media.
#### Use API Captions - `useApiCaptions`
used only for OVP configuration this can be configured on the playlist level or media level


<br>To change this behavior, configure the playlist options using one of the following methods:
<br>Via the API:

#### Example:

```java

       // OVPPlaylistIdOptions
       
       val ovpPlaylistIdOptions = OVPPlaylistIdOptions()
        ovpPlaylistIdOptions.playlistId = "zzzzzzz"
        ovpPlaylistIdOptions.startIndex = 0
        ovpPlaylistIdOptions.ks = ""
        ovpPlaylistIdOptions.playlistCountDownOptions = CountDownOptions()
        ovpPlaylistIdOptions.useApiCaptions = false
        ovpPlaylistIdOptions.loopEnabled = false
        ovpPlaylistIdOptions.autoContinue =  true
        ovpPlaylistIdOptions.recoverOnError = false
        
       // OVPPlaylistOptions
       
       val ovpPlaylistOptions = OVPPlaylistOptions()
        ovpPlaylistOptions.startIndex = 0
        ovpPlaylistOptions.ks =  ""
        ovpPlaylistOptions.playlistCountDownOptions = CountDownOptions()
        ovpPlaylistOptions.playlistMetadata = PlaylistMetadata().setName("TestOTTPlayList").setId("1")
        ovpPlaylistOptions.ovpMediaOptionsList = ovpMediaOptionsList //(useApiCaptions is configured for each media separetly)
        ovpPlaylistOptions.loopEnabled = false
        ovpPlaylistOptions.autoContinue = true
        ovpPlaylistOptions.recoverOnError = false
        
       // OVPPlaylistOptions 
       val ottPlaylistIdOptions = OTTPlaylistOptions()
        ottPlaylistIdOptions.startIndex = 0
        ottPlaylistIdOptions.playlistCountDownOptions = CountDownOptions()
        ottPlaylistIdOptions.playlistMetadata = PlaylistMetadata().setName("TestOTTPlayList").setId("1")
        ottPlaylistIdOptions.ottMediaOptionsList = ottMediaOptionsList
        ottPlaylistIdOptions.loopEnabled = false
        ottPlaylistIdOptions.autoContinue = true
        ottPlaylistIdOptions.recoverOnError = false
        
       // BasicPlaylistOptions  
       val basicPlaylistIdOptions = BasicPlaylistOptions()
        basicPlaylistIdOptions.startIndex =  0
        basicPlaylistIdOptions.playlistMetadata = PlaylistMetadata().setName("TestBasicPlayList").setId("1")
        basicPlaylistIdOptions.playlistCountDownOptions = CountDownOptions()
        basicPlaylistIdOptions.basicMediaOptionsList = basicMediaOptionsList
        basicPlaylistIdOptions.loopEnabled = false
        basicPlaylistIdOptions.autoContinue = true
        basicPlaylistIdOptions.recoverOnError = false
        
```

> Note: The `autoContinue` property is relevant only for the second item onwards.
> <br>To control the first entry playback, set the `autoPlay` property to the desired value (default = true).


### Playlist Count Countdown Options

When the current item is about to end and the playlist is set to continue automatically  by setting `autoContinue	 = true`, the application will get countdown start event. Then the application can display up next or watch credits pop up.
Once countdown is over, countdown ended event will be fired.
Using the `disableCountDown` API, application can cancel the current countdown configuration, so it will not be executed and the `PlaylistController` will not trigger the `playNext` API. 


##### Example:

```java
player?.playlistController?.disableCountDown()
```

By default, the countdown is fired at the last 10 media seconds for the last 10 seconds of the media.
The `CountDownOptions` `timeToShow` and `duration` values are presented in milliseconds.

<br>To change this behavior, configure the `CountDownOptions`
<br> For example, to show the countdown for 20 seconds until the end, configure:
<br>Via the API:

OVP by id - exists only for the playlist level.

```java
ovpPlaylistIdOptions.playlistCountDownOptions = CountDownOptions(20000, true)
```

 OVP/OTT by entries list - exists both on playlist level or media level.

```java
ovpPlaylistOptions.playlistCountDownOptions = CountDownOptions(10000, true)
```

```java
ovpMediaOptions.playlistCountDownOptions = CountDownOptions(90000, 10000, true);
```

By configuration:

Available for playlist level or media level

```java
basicPlaylistIdOptions.countDownOptions = CountDownOptions(5000, true)
```

```java
createBasicMediaOptions(0,"1_w9zx2eti1", SOURCE_URL, CountDownOptions(60000, 10000, true))
```

Note:
Once the `playlistCountDownEnd` event is fired, the next media entry in the playlist a will be played.


## PlaylistController Interface

Once playlist is loaded the callback will return a controller object the can be used to control the playlist life cycle from the application perspective.

Another option to get a reference to the controller, is to 
call `player?.playlistController` with the required API from the interface after the playlist is loaded. 

```java
public interface PlaylistController {

    /**
     * getPlaylist - get current playlist data
     *
     * @return - PKPlaylist
     */
    PKPlaylist getPlaylist();

    /**
     * getPlaylistType - get current playlist type OVP_ID,OVP_LIST,OTT_LIST,BASIC_LIST
     *
     * @return - PKPlaylistType
     */
    PKPlaylistType getPlaylistType();

    /**
     * getCurrentPlaylistMedia - get current playlist media data.
     *
     * @return - PKPlaylistMedia
     */
    PKPlaylistMedia getCurrentPlaylistMedia();

    /**
     * getCurrentMediaIndex for current playing media.
     *
     * @return - int
     */
    int getCurrentMediaIndex();

    /**
     * GetCurrentCountDownOptions for current media.
     *
     * @return - CountDownOptions
     */
    CountDownOptions getCurrentCountDownOptions();

    /**
     * DisableCountDown for current media.
     *
     */
    void disableCountDown();

    /**
     * Preload next item - will do the provider request for specific media to save network calls not relevant for basic player.
     *
     */
    void preloadNext();

    /**
     * PreloadItem by index - will do the provider request for specific media to save network calls not relevant for basic player.
     *
     * @param index - media index in playlist.
     */
    void preloadItem(int index);

    /**
     * PlayItem by index.
     *
     * @param index - media index in playlist.
     */
    void playItem(int index);

    /**
     * PlayItem by index and auto play configuration.
     *
     * @param index - media index in playlist.
     * @param isAutoPlay - isAutoPlay.
     */
    void playItem(int index, boolean isAutoPlay);

    /**
     * playNext - play the next media in the playlist.
     *
     */
    void playNext();

    /**
     * playPrev - play the previous media in the playlist.
     *
     */
    void playPrev();

    /**
     * replay - play the playlist from the first index.
     *
     */
    void replay();

    /**
     * isMediaLoaded - validation if media was fetched/played at least one time so the playback information is available.
     *
     * @param mediaId - media id in playlist.
     * @return - boolean
     */
    boolean isMediaLoaded(String mediaId);

    /**
     * setLoop - configure the controller to play the playlist again
     * when last playlist media is ended
     *
     * @param mode - enabled/disabled.
     */
    void setLoop(boolean mode);

    /**
     * isLoopEnabled - validation if playlist controller is configured to support setLoop mode.
     *
     * @return - boolean
     */
    boolean isLoopEnabled();

    /**
     * setAutoContinue - configure the controller to play the playlist in setAutoContinue mode
     *
     * @param mode - enabled/disabled.
     */
    void setAutoContinue(boolean mode);

    /**
     * isAutoContinueEnabled - validation if playlist controller is configured to support setAutoContinue mode.
     *
     * @return - boolean
     */
    boolean isAutoContinueEnabled();

    /**
     * setRecoverOnError - ignore media playback errors and continue
     *
     * @param mode - enabled/disabled.
     */
    void setRecoverOnError(boolean mode);

    /**
     * isRecoverOnError - validation if playlist controller should recover on error.
     *
     * @return - boolean
     */
    boolean isRecoverOnError();

    /**
     * release - should e called if we want to reuse the player for single media or for loading new play list.
     */
    void release();

    /**
     * setPlaylistOptions - configure the controller with the initial playlist options
     *
     * @param playlistOptions - playlist initial configuration.
     */
    void setPlaylistOptions(PlaylistOptions playlistOptions);

    /**
     * setPlaylistCountDownOptions - update the current playlist countdown configuration
     *
     * @param playlistCountDownOptions - playlist countdown.
     */
    void setPlaylistCountDownOptions(@Nullable CountDownOptions playlistCountDownOptions);
}
```

##Playlist Navigation

Using the `PlaylistController` API, you can get the playlist data and then switch between the items.

```java
// switch to the next item
player?.playlistController?.playNext()

// switch to the previous item
player?.playlistController?.playPrev()

// switch to a specific item by index
player?.playlistController?.playItem(2)
```

## Change Playlist

To clean the playlist data, you'll need to call the playlist controller `release()` API
<br>Here is an example for how it is possible to change the playlist using the `release` method when previous playlist ended.

```java
player?.addListener(this, PlaylistEvent.playListEnded) { event ->
      log.d("PLAYLIST playListEnded")
       ovpPlaylistIdOptions.playlistId = "0_jco198ds"
       player?.loadPlaylistById(ovpPlaylistIdOptions) { playlistController, error ->
       if (error != null) {
            Snackbar.make(findViewById(android.R.id.content), error.message, Snackbar.LENGTH_LONG).show()
        } else {
              playbackControlsManager?.addChangeMediaImgButtonsListener(playlistController.playlist.mediaListSize)
        }
     }
  }
}
```
## Playlist Events

Application can add listeners to the following events
using these events application can react to UI changes for example.

These events are defined in `PlaylistEvent` class.
Please check the class for the event payload.

```
    public enum Type {
        PLAYLIST_LOADED,
        PLAYLIST_STARTED,
        PLAYLIST_ENDED,
        PLAYLIST_COUNT_DOWN_START,
        PLAYLIST_COUNT_DOWN_END,
        PLAYLIST_LOOP_STATE_CHANGED,
        PLAYLIST_SUFFLE_STATE_CHANGED,
        PLAYLIST_AUTO_CONTINUE_STATE_CHANGED,
        PLAYLIST_ERROR,
        PLAYLIST_LOAD_MEDIA_ERROR
    }    
        player?.addListener(this, PlaylistEvent.playListLoaded) { event ->
            log.d("playListLoaded " + event.playlist.name)
        }

        player?.addListener(this, PlaylistEvent.playListStarted) { event ->
            log.d("playListStarted " + event.playlist.name)
        }


        player?.addListener(this, PlaylistEvent.playListEnded) { event ->
            log.d("PlaylistEnded " +  event.playlist.name)
        }

        player?.addListener(this, PlaylistEvent.playlistCountDownStart) { event ->
            log.d("playlistCountDownStart currentPlayingIndex = " + event.currentPlayingIndex + " durationMS = " + event.playlistCountDownOptions.durationMS);
        }

        player?.addListener(this, PlaylistEvent.playlistCountDownEnd) { event ->
            log.d("playlistCountDownEnd currentPlayingIndex = " + event.currentPlayingIndex + " durationMS = " + event.playlistCountDownOptions.durationMS);
        }

        player?.addListener(this, PlaylistEvent.playlistLoopStateChanged) { event ->
            log.d("playlistLoopStateChanged " + event.mode);
        }

        player?.addListener(this, PlaylistEvent.playlistAutoContinueStateChanged) { event ->
            log.d("PLAYLIST playlistAutoContinueStateChanged " + event.mode)
        }
        
        player?.addListener(this, PlaylistEvent.playListError) { event ->
            log.d("playListError = " + event.error.message);
        }
                player?.addListener(this, PlaylistEvent.playlistLoadMediaError) { event ->
            log.d("playListMediaError = " + event.error.message);
        }
```        
    


