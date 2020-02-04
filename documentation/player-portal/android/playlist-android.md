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
var ovpMediaOptions1 = buildOvpMediaOptions()
var ovpMediaOptions2 = buildOvpMediaOptions()
var ovpMediaOptions3 = buildOvpMediaOptions()

var mediaList = listOf(ovpMediaOptions1, ovpMediaOptions2, ovpMediaOptions3)

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
var ottMediaOptions1 = buildOttMediaOptions("548576", "Mobile_Main")
val ottMediaOptions2 = buildOttMediaOptions("548577", "STB_Main")
var ottMediaOptions3 = buildOttMediaOptions("548576","Mobile_Main")

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
var basicMediaOptions0 = createBasicMediaOptions(0,"1_w9zx2eti1", SOURCE_URL, CountDownOptions(50000, 10000, true))
val basicMediaOptions1 = createBasicMediaOptions(1,"0_uka1msg4", SOURCE_URL2, CountDownOptions(10000, true))
var basicMediaOptions2 = createBasicMediaOptions(2,"1_w9zx2eti2", SOURCE_URL, CountDownOptions())

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

private fun createBasicMediaOptions(index: Int, id: String, url : String, countdownOptions: CountDownOptions): BasicMediaOptions {

  val mediaEntry = PKMediaEntry()
  mediaEntry.id = id

  mediaEntry.mediaType = PKMediaEntry.MediaEntryType.Vod
  val mediaSources = createMediaSources(id, url)
  mediaEntry.sources = mediaSources
  return BasicMediaOptions(index, mediaEntry, countdownOptions)
}
```

## Configure the Playlist
#### Playlist Metadata - playlistMetadata
Should be used for all Playlists except the OVP by id configuration where this data is retrived from the BE.
#### Start Index - startIndex
The index that the playlist playbach should start from (default index = 0)
#### Loop - loopEnabled
The playlist will play the first media once lat media in the playlist is ended (default false)
#### Shuffle - shuffleEnabled
The playlist will be played randomly each media will be played once (default false)
#### Auto Continue -autoContinue
The next media in the playlist will be played automatically once the previous media ended (default true)
#### Count Down Options - countDownOptions
The logic by which count down start event will be fired (default is 10 last sec for 10 sec after that the auto continue will be activated. if auto continue = false countdown is not activated.
#### Use API Captions - useApiCaptions
used only for OVP configuration can be configured on theplaylist level of media level


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
        ovpPlaylistOptions.ovpMediaOptionsList = ovpMediaOptionsList //(useApiCaptions is configured for each media separetly)
        ovpPlaylistOptions.loopEnabled = false
        ovpPlaylistOptions.shuffleEnabled = false
        ovpPlaylistOptions.autoContinue = true
        
       // OVPPlaylistOptions 
       val ottPlaylistIdOptions = OTTPlaylistOptions()
        ottPlaylistIdOptions.startIndex = 0
        ottPlaylistIdOptions.countDownOptions = CountDownOptions()
        ottPlaylistIdOptions.playlistMetadata = PlaylistMetadata().setName("TestOTTPlayList").setId("1")
        ottPlaylistIdOptions.ottMediaOptionsList = ottMediaOptionsList
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
> <br>To control the first entry playback, set the `autoPlay` property to the desired value (default = true).


### Countdown

When the current item is about to end and the playlist is set to continue automatically `autoContinue	` = true, the app will get countdown start event. Then app can display next or watch credits view.
once countdown is over countdown ended event will be fired app can cancel countdown not to execue the ended event that will trigger the playNext API. using the disableCountDown API.



By default, the countdown is fired for the last 10 seconds of the media.
values are given in miliseconds.
<br>To change this behavior, configure the `CountDownOptions`
<br> For example, to show the countdown for 20 seconds until the end, configure:
<br>Via the API:

for OVP by id exists only for playlist level

```java
ovpPlaylistIdOptions.countDownOptions = CountDownOptions(20000, true)
```

for OVP/OTT by entries list for playlist level or media level

```java
ovpPlaylistOptions.countDownOptions = CountDownOptions(10000, true)
```

```java
ovpMediaOptions.countDownOptions = CountDownOptions(90000, 10000, true);
```

By configuration:

available for playlist level or media level

```java
basicPlaylistIdOptions.countDownOptions = CountDownOptions(5000, true)
```

```java
createBasicMediaOptions(0,"1_w9zx2eti1", SOURCE_URL, CountDownOptions(60000, 10000, true))
```

Note.

Once countdown is over next media will be triggered.


## Playlist Interface

Once playlist is loaded the callback will return a controller object the can be used to control the playlist life cycle from the app prespective.

another option to get the controller after the playlist is loaded is to 
call player?.playlistController + the required API

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
     * getCurrentMediaIndex for current playing madia.
     *
     * @return - int
     */
    int getCurrentMediaIndex();

    /**
     * GetCurrentCountDownOptions for current madia.
     *
     * @return - CountDownOptions
     */
    CountDownOptions getCurrentCountDownOptions();

    /**
     * DisableCountDown for current madia.
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
     * @return - boolean
     */
    boolean isMediaLoaded(int index);

    /**
     * loop - configure the controller to play the playlist again
     * when last playlist media is ended
     *
     * @param mode - enabled/disabled.
     */
    void loop(boolean mode);

    /**
     * isLoopEnabled - validation if playlist controller is configured to support loop mode.
     *
     * @return - boolean
     */
    boolean isLoopEnabled();

    /**
     * shuffle - configure the controller to play the playlist in random mode
     *
     * @param mode - enabled/disabled.
     */
    void shuffle(boolean mode);

    /**
     * isShuffleEnabled - validation if playlist controller is configured to support shuffle mode.
     *
     * @return - boolean
     */
    boolean isShuffleEnabled();

    /**
     * autoContinue - configure the controller to play the playlist in autoContinue mode
     *
     * @param mode - enabled/disabled.
     */
    void autoContinue(boolean mode);

    /**
     * isAutoContinueEnabled - validation if playlist controller is configured to support autoContinue mode.
     *
     * @return - boolean
     */
    boolean isAutoContinueEnabled();

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
}
```

## Switching Items

Using the PlaylistController API, you can get the playlist data and then switch between the items.

```java
// switch to the next item
player?.playlistController?.playNext()

// switch to the previous item
player?.playlistController?.playPrev()

// switch to a specific item by index
player?.playlistController?.playItem(2)
```

## Change Playlist

To clean the playlist data, you'll need to call the playlist controller release() API
<br>Here is an example for how it is possible to change the playlist using the release method when previous playlise ended.

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

Application can add liseners to the follwing events
using this events app can react in UI cahanges for example.

These events are defined in PlaylistEvent class.
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
        	PLAYLIST_ERROR,
        	PLAYLIST_MEDIA_ERROR
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
            log.d("playlistCountDownStart currentPlayingIndex = " + event.currentPlayingIndex + " durationMS = " + event.countDownOptions.durationMS);
        }

        player?.addListener(this, PlaylistEvent.playlistCountDownEnd) { event ->
            log.d("playlistCountDownEnd currentPlayingIndex = " + event.currentPlayingIndex + " durationMS = " + event.countDownOptions.durationMS);
        }

        player?.addListener(this, PlaylistEvent.playlistLoopStateChanged) { event ->
            log.d("playlistLoopStateChanged " + event.mode);
        }

        player?.addListener(this, PlaylistEvent.playlistShuffleStateChanged) { event ->
            log.d("playlistShuffleStateChangedk, " + event.mode);
        }

        player?.addListener(this, PlaylistEvent.playListError) { event ->
            log.d("playListError = " + event.error.message);
        }
                player?.addListener(this, PlaylistEvent.playListMediaError) { event ->
            log.d("playListMediaError = " + event.error.message);
        }
```        
    


