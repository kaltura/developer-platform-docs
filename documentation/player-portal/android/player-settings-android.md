---
layout: page
title: Player Settings for Android
weight: 110
---


```
    interface Settings {
        /**
         * Set the Player's contentRequestAdapter.
         *
         * @param contentRequestAdapter - request adapter.
         * @return - Player Settings.
         */
        Settings setContentRequestAdapter(PKRequestParams.Adapter contentRequestAdapter);

        /**
         * Set the Player's licenseRequestAdapter.
         *
         * @param licenseRequestAdapter - request adapter.
         * @return - Player Settings.
         */
        Settings setLicenseRequestAdapter(PKRequestParams.Adapter licenseRequestAdapter);

        /**
         * Enable/disable cea-608 text tracks.
         * By default they are disabled.
         * Note! Once set, this value will be applied to all mediaSources for that instance of Player.
         * In order to disable/enable it again, you should update that value once again.
         * Otherwise it will stay in the previous state.
         *
         * @param cea608CaptionsEnabled - should cea-608 track should be enabled.
         * @return - Player Settings.
         */
        Settings setCea608CaptionsEnabled(boolean cea608CaptionsEnabled);

        /**
         * Enable/disable MPGA audio tracks.
         * By default they are disabled.
         * Note! Once set, this value will be applied to all mediaSources for that instance of Player.
         * In order to disable/enable it again, you should update that value once again.
         * Otherwise it will stay in the previous state.
         *
         * @param mpgaAudioFormatEnabled - should Enable MPGA Audio track.
         * @return - Player Settings.
         */
        Settings setMpgaAudioFormatEnabled(boolean mpgaAudioFormatEnabled);

        /**
         * Decide if player should use {@link android.view.TextureView} as primary surface
         * to render the video content. If set to false, will use the {@link android.view.SurfaceView} instead.
         * Note!!! Use this carefully, because {@link android.view.TextureView} is more expensive and not DRM
         * protected. But it allows dynamic animations/scaling e.t.c on the player. By default it will be always set
         * to false.
         *
         * @param useTextureView - true if should use {@link android.view.TextureView}.
         * @return - Player Settings.
         */
        Settings useTextureView(boolean useTextureView);

        /**
         * Decide if player should do cross protocol redirect or not. By default it will be always set
         * to false.
         *
         * @param crossProtocolRedirectEnabled - true if should do cross protocol redirect.
         * @return - Player Settings.
         */
        Settings setAllowCrossProtocolRedirect(boolean crossProtocolRedirectEnabled);

        /**
         * Decide if player should play clear lead content
         *
         * @param allowClearLead - should enable/disable clear lead playback default false
         * @return - Player Settings.
         */
        Settings allowClearLead(boolean allowClearLead);

        /**
         * Decide if player should use secure rendering on the surface.
         * Known limitation - when useTextureView set to true and isSurfaceSecured set to true -
         * secure rendering will have no effect.
         *
         * @param isSurfaceSecured - should enable/disable secure rendering
         * @return - Player Settings.
         */
        Settings setSecureSurface(boolean isSurfaceSecured);

        /**
         * Decide the Ad will be auto played when comes to foreground from background
         *
         * @param autoPlayOnResume true if it is autoplayed or else false, default is TRUE
         * @return Player Settings
         */
        Settings setAdAutoPlayOnResume(boolean autoPlayOnResume);

        /**
         * Set the player buffers size
         *
         * @param loadControlBuffers LoadControlBuffers
         * @return Player Settings
         */
        Settings setPlayerBuffers(LoadControlBuffers loadControlBuffers);

        /**
         * Set the Player's VR/360 support
         *
         * @param vrPlayerEnabled - If 360 media should be played on VR player or default player - default == true.
         * @return - Player Settings.
         */
        Settings setVRPlayerEnabled(boolean vrPlayerEnabled);

        /**
         * Set the Player's preferredAudioTrackConfig.
         *
         * @param preferredAudioTrackConfig - AudioTrackConfig.
         * @return - Player Settings.
         */
        Settings setPreferredAudioTrack(PKTrackConfig preferredAudioTrackConfig);

        /**
         * Set the Player's preferredTextTrackConfig.
         *
         * @param preferredTextTrackConfig - TextTrackConfig.
         * @return - Player Settings.
         */
        Settings setPreferredTextTrack(PKTrackConfig preferredTextTrackConfig);

        /**
         * Set the Player's PreferredMediaFormat.
         *
         * @param preferredMediaFormat - PKMediaFormat.
         * @return - Player Settings.
         */
        Settings setPreferredMediaFormat(PKMediaFormat preferredMediaFormat);

        /**
         * Set the Player's Subtitles
         *
         * @param subtitleStyleSettings - SubtitleStyleSettings
         * @return - Player Settings
         */
        Settings setSubtitleStyle(SubtitleStyleSettings subtitleStyleSettings);
    }  
```

Once you created a player instance you can set the above settings on it.

## Example

### Create a player:

``` java
 Player player = PlayKitManager.loadPlayer(context, pluginConfigs);
```

## Apply Player Settings if required:

### Enable crossProtocolRedirect

##### Example:

```
 //Configure if to player allow http/https mix.
 player.getSettings().setAllowCrossProtocolRedirect(crossProtocolRedirectEnabled); // default is false
```

### Enable DRM Clear Lead Playback

##### Example:

```
 //Configure if player will start playing clear lead in DRM content 
 player.getSettings(). allowClearLead(true/false); // default is false
```

### Enable Secure Surface

In case App wants to block ability to take screen capture

##### Example:

```
 player.getSettings().setSecureSurface(isSurfaceSecured); // default is false
```

### Configure Player's PreferredMediaFormat.

In the case where the Media Entry contains multiple sources, the player will attempt to use formats in this priority order: 
  - DASH (mpd) 
  - HLS 
  - WVM
  - MP4 
  - MP3 
  
In order to force a Media Format that is different than the priority list, use `setPreferredMediaFormat` with the desired type: 

```
player.getSettings().setPreferredMediaFormat(PKMediaFormat.mp4);
```
Making this call, for example, would move MP4 format to the top of the priority list. 


### Configure Player Load Control

Using builder API you can create LoadControl Buffers with the default ExoPlayer values
then it is possible configure any parameter from the LoadControlBuffers Object.

Defaults can be found here:
[Defaults](https://github.com/google/ExoPlayer/blob/release-v2/library/core/src/main/java/com/google/android/exoplayer2/DefaultLoadControl.java)
 

##### Example:

```
             LoadControlBuffers loadControlBuffers = new LoadControlBuffers().
                    setMinPlayerBufferMs(2000).
                    setMaxPlayerBufferMs(45000).
                    setBackBufferDurationMs(2000).
                    setMinBufferAfterReBufferMs(2000).
                    setMinBufferAfterInteractionMs(2000).
                    setRetainBackBufferFromKeyframe(true);
                    
            player.getSettings().setPlayerBuffers(loadControlBuffers);
```


### Configure if to use TextureView instead of surface view

##### Example:

```
 player.getSettings().useTextureView(false); // default is false
```

### Enable Cea608Captions

##### Example:

```
 //Configure if to consider Cea608Captions which exist stream for text track selection.
 player.getSettings().setCea608CaptionsEnabled(false); // default is false
```

### Configure KalturaPlaybackRequestAdapter

##### Example:

```
 //Configure different app name/domain in KalturaPlaybackRequestAdapter which allows adapting the request parameters before sending network requests
 KalturaPlaybackRequestAdapter.install(player, "yourApplicationName"); // default is app package name
```

### Configure KalturaUDRMLicenseRequestAdapter

##### Example:

```
 //configure different app name/domain in KalturaUDRMLicenseRequestAdapter which allows adapting the request parameters before sending DRM requests
 KalturaUDRMLicenseRequestAdapter.install(player, "yourApplicationName"); // default is app package name
```

### Enable - Ad will auto play on resume 

In some cases where app does not expose play pause API on ads this API will do the auto play after resume from background

##### Example:

```
 player.getSettings().setAdAutoPlayOnResume(autoPlayOnResume);
```

### setVRPlayerEnabled(boolean vrPlayerEnabled);

If case 360 media should be played on VR player or default player - default is true

##### Example:

```
 player.getSettings().setVRPlayerEnabled(vrPlayerEnabled);
 ```


### Configure preferred TEXT TRACKS -- Default is no captions displayed.

##### Example:

```
 //player.getSettings().setPreferredTextTrack(new PKTrackConfig().setPreferredMode(PKTrackConfig.Mode.OFF)); // no text tracks
 //player.getSettings().setPreferredTextTrack(new PKTrackConfig().setPreferredMode(PKTrackConfig.Mode.SELECTION).setTrackLanguage("hi")); // select specific track lang if not exist select manifest default if exist else the first from manifest
 player.getSettings().setPreferredTextTrack(new PKTrackConfig().setPreferredMode(PKTrackConfig.Mode.AUTO)); // select the track by locale if does not exist manifest default
```

```
 /Configure preferred AUDIO TRACKS - Default is Stream's default

 //player.getSettings().setPreferredAudioTrack(new PKTrackConfig().setPreferredMode(PKTrackConfig.Mode.OFF); // default audio track (Done automatically actually)
 //player.getSettings().setPreferredAudioTrack(new PKTrackConfig().setPreferredMode(PKTrackConfig.Mode.SELECTION).setTrackLanguage("ru")); // select specific track lang if not exist select manifest default
 player.getSettings().setPreferredAudioTrack(new PKTrackConfig().setPreferredMode(PKTrackConfig.Mode.AUTO));
```


## Set Preferred Audio/Text Track

The player allows you to set the preferred language audio/text by instantiating the `PKTrackConfig`, which is created via the builder method. 

```
 public PKTrackConfig setTrackLanguage(String trackLanguage)
 public PKTrackConfig setPreferredMode(@NonNull Mode preferredMode)
```
Language options are: 
- Explicitly setting the language code 
- Auto, which sets the language based on location, if available. 
- Default, which contains no text and uses the first available audio track. 

```
 PKTrackConfig trackConfig = new PKTrackConfig().setPreferredMode(PKTrackConfig.Mode.OFF);
 PKTrackConfig trackConfig = new PKTrackConfig().setPreferredMode(PKTrackConfig.Mode.AUTO);
 PKTrackConfig trackConfig = new  PKTrackConfig().setPreferredMode(PKTrackConfig.Mode.SELECTION).setTrackLanguage("ru")
```

Once we have the `PKTrackConfig` object we can use it as parameter for the API.

```
player.getSettings().setPreferredAudioTrack(preferredAudioTrackConfig)
player.getSettings().setPreferredTextTrack(preferredTextTrackConfig)
```

### Tracks Configuration possibilities

#### There are 3 modes available:

 - `OFF` - for Text tracks it will cancel text tracks display for audio it will select the default from the manifest
 - `AUTO` - SDK will check if the stream has audio/text track that matches the device locale and will select it else it will take stream default
 - `SELECTION` - this mode requires to set the language explicitly (2 or 3 letters)  if this language does not exist SDK will take the streams
default Audio/Text track

#### NOTE!!!
The languages that are expected by player should match the SO 639-X codes definition

## Subtitle Sideloading for Player

> Since Playkit version 3.9.0

To load Subtitle from external source for the player, need to create a `List` of `PKExternalSubtitle` and then pass it to `PKMediaEntry` object.

```
PKExternalSubtitle pkExternalSubtitle = new PKExternalSubtitle()
                .setUrl("http://URL_OF_EXTERNAL_SUBTITLE.vtt")
                .setMimeType(PKSubtitleFormat.vtt)
                .setLabel("de")
                .setLanguage("deu");
mList.add(pkExternalSubtitle);

```

```
mediaEntry.setExternalSubtitleList(mList);
```
Use `setDefault()` while creating `PKExternalSubtitle` to make it default subtitle.
`TEXT_VTT` and `APPLICATION_SUBRIP` mime-types are supported for subtitles.

## Subtitle Styles for Player

To configure Subtitles to the player, first need to set the Subtitles using `settings` from `player`object.
While creating `SubtitleStyleSettings` object, need to pass `subtitleStyleName` param in constructor.

```
SubtitleStyleSettings subtitleStyleSettings = new SubtitleStyleSettings("MyCustomSubtitleStyle");
player.getSettings().setSubtitleStyle(subtitleStyleSettings);
```

To update the Subtitles call `updateSubtitleStyle()` using only `player` object. Use updated `subtitleStyleSettings` object.


```
player.updateSubtitleStyle(subtitleStyleSettings);
```

Using builder pattern for setters in `subtitleStyleSettings`, Following Styles can be applied,

- `setTextColor` - Change subtitle text color
- `setBackgroundColor` - Change subtitle background color
- `setEdgeColor` - Change subtitle text edge color
- `setWindowColor` - Change subtitle window color

- `setEdgeType` - Change subtitle Edge types using `enum SubtitleStyleEdgeType` with the values ``` EDGE_TYPE_NONE, EDGE_TYPE_OUTLINE, EDGE_TYPE_DROP_SHADOW, EDGE_TYPE_RAISED, EDGE_TYPE_DEPRESSED; ```

- `setTextSizeFraction` - Change subtitle text size fraction using `enum SubtitleTextSizeFraction` with the values ```SUBTITLE_FRACTION_50, SUBTITLE_FRACTION_75, SUBTITLE_FRACTION_100, SUBTITLE_FRACTION_125, SUBTITLE_FRACTION_150, SUBTITLE_FRACTION_200```

- `setTypeface` - Change subtitle typeface using `enum SubtitleStyleTypeface` with the values ```DEFAULT, DEFAULT_BOLD, MONOSPACE, SERIF, SANS_SERIF ```

#### Example

To set the Subtitles,

```
SubtitleStyleSettings subtitleStyleSettings = new SubtitleStyleSettings("MyCustomSubtitleStyle")
                    .setBackgroundColor(Color.BLUE)
                    .setTextColor(Color.WHITE)
                    .setTextSizeFraction(SubtitleStyleSettings.SubtitleTextSizeFraction.SUBTITLE_FRACTION_50)
                    .setWindowColor(Color.YELLOW)
                    .setEdgeColor(Color.BLUE)
                    .setTypeface(SubtitleStyleSettings.SubtitleStyleTypeface.MONOSPACE)
                    .setEdgeType(SubtitleStyleSettings.SubtitleStyleEdgeType.EDGE_TYPE_DROP_SHADOW);

player.getSettings().setSubtitleStyle(subtitleStyleSettings);
```

To update the existing Subtitles,

```
SubtitleStyleSettings subtitleStyleSettings = new SubtitleStyleSettings("MyNewCustomSubtitleStyle")
                        .setBackgroundColor(Color.WHITE)
                        .setTextColor(Color.RED)
                        .setTextSizeFraction(SubtitleStyleSettings.SubtitleTextSizeFraction.SUBTITLE_FRACTION_100)
                        .setWindowColor(Color.BLUE)
                        .setEdgeColor(Color.BLUE)
                        .setTypeface(SubtitleStyleSettings.SubtitleStyleTypeface.SANS_SERIF)
                        .setEdgeType(SubtitleStyleSettings.SubtitleStyleEdgeType.EDGE_TYPE_DROP_SHADOW);

player.updateSubtitleStyle(subtitleStyleSettings);

```
