---
layout: page
title: Player Settings for Android
weight: 110
---

Once you've created a player instance, you can make changes to its settings: 

* In Kaltura Player the same settings API below are integrated inside `PlayerInitOptions` object

##### Example:

{% highlight java %}
 playerInitOptions = PlayerInitOptions(mediaPartnerId)
        playerInitOptions?.setAutoPlay(true)
        playerInitOptions?.setPreload(true)
        playerInitOptions?.setSecureSurface(false)
        playerInitOptions?.setAdAutoPlayOnResume(true)
        playerInitOptions?.setAllowCrossProtocolEnabled(true)
        playerInitOptions?.setReferrer("app://MyApplicationDomain")
 
 player = KalturaOvpPlayer.create(this@MainActivity, playerInitOptions)
{% endhighlight %}

## setContentRequestAdapter

{% highlight java %}
interface Settings {
  /**
    * Set the Player's contentRequestAdapter.
    *
    * @param contentRequestAdapter - request adapter.
    * @return - Player Settings.
    */
  Settings setContentRequestAdapter(PKRequestParams.Adapter contentRequestAdapter);
{% endhighlight %}

## setLicenseRequestAdapter 
{% highlight java %}
  /**
    * Set the Player's licenseRequestAdapter.
    *
    * @param licenseRequestAdapter - request adapter.
    * @return - Player Settings.
    */
  Settings setLicenseRequestAdapter(PKRequestParams.Adapter licenseRequestAdapter);
{% endhighlight %}

## setCea608CaptionsEnabled
{% highlight java %}
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
{% endhighlight %}

## setMpgaAudioFormatEnabled
{% highlight java %}
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
{% endhighlight %}

## useTextureView
{% highlight java %}
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
{% endhighlight %}

## setAllowCrossProtocolRedirect
{% highlight java %}
  /**
    * Decide if player should do cross protocol redirect or not. By default it will be always set
    * to false.
    *
    * @param crossProtocolRedirectEnabled - true if should do cross protocol redirect.
    * @return - Player Settings.
    */
  Settings setAllowCrossProtocolRedirect(boolean crossProtocolRedirectEnabled);
{% endhighlight %}

## allowClearLead
{% highlight java %}
  /**
    * Decide if player should play clear lead content
    *
    * @param allowClearLead - should enable/disable clear lead playback default false
    * @return - Player Settings.
    */
  Settings allowClearLead(boolean allowClearLead);
{% endhighlight %}

## setSecureSurface
{% highlight java %}
  /**
    * Decide if player should use secure rendering on the surface.
    * Known limitation - when useTextureView set to true and isSurfaceSecured set to true -
    * secure rendering will have no effect.
    *
    * @param isSurfaceSecured - should enable/disable secure rendering
    * @return - Player Settings.
    */
  Settings setSecureSurface(boolean isSurfaceSecured);
{% endhighlight %}

## setAdAutoPlayOnResume
{% highlight java %}
  /**
    * Decide the Ad will be auto played when comes to foreground from background
    *
    * @param autoPlayOnResume true if it is autoplayed or else false, default is TRUE
    * @return Player Settings
    */
  Settings setAdAutoPlayOnResume(boolean autoPlayOnResume);
{% endhighlight %}

## setPlayerBuffers
{% highlight java %}
  /**
    * Set the player buffers size
    *
    * @param loadControlBuffers LoadControlBuffers
    * @return Player Settings
    */
  Settings setPlayerBuffers(LoadControlBuffers loadControlBuffers);
{% endhighlight %}

## setVRPlayerEnabled
{% highlight java %}
  /**
    * Set the Player's VR/360 support
    *
    * @param vrPlayerEnabled - If 360 media should be played on VR player or default player - default == true.
    * @return - Player Settings.
    */
  Settings setVRPlayerEnabled(boolean vrPlayerEnabled);
{% endhighlight %}

## setPreferredAudioTrack
{% highlight java %}
  /**
    * Set the Player's preferredAudioTrackConfig.
    *
    * @param preferredAudioTrackConfig - AudioTrackConfig.
    * @return - Player Settings.
    */
  Settings setPreferredAudioTrack(PKTrackConfig preferredAudioTrackConfig);
{% endhighlight %}

## setPreferredTextTrack
{% highlight java %}
  /**
    * Set the Player's preferredTextTrackConfig.
    *
    * @param preferredTextTrackConfig - TextTrackConfig.
    * @return - Player Settings.
    */
  Settings setPreferredTextTrack(PKTrackConfig preferredTextTrackConfig);
{% endhighlight %}

## setPreferredMediaFormat
{% highlight java %}
  /**
    * Set the Player's PreferredMediaFormat.
    *
    * @param preferredMediaFormat - PKMediaFormat.
    * @return - Player Settings.
    */
  Settings setPreferredMediaFormat(PKMediaFormat preferredMediaFormat);
{% endhighlight %}

## setSubtitleStyle
{% highlight java %}
  /**
    * Set the Player's Subtitles
    *
    * @param subtitleStyleSettings - SubtitleStyleSettings
    * @return - Player Settings
    */
  Settings setSubtitleStyle(SubtitleStyleSettings subtitleStyleSettings);
}  
{% endhighlight %}


# Creating A Player

{% highlight java %} java
 Player player = PlayKitManager.loadPlayer(context, pluginConfigs);
{% endhighlight %}

## Apply Player Settings if required:

### Enable crossProtocolRedirect

##### Example:

{% highlight java %}
 //Configure if to player allow http/https mix.
 player.getSettings().setAllowCrossProtocolRedirect(crossProtocolRedirectEnabled); // default is false
{% endhighlight %}

### Enable DRM Clear Lead Playback

##### Example:

{% highlight java %}
 //Configure if player will start playing clear lead in DRM content 
 player.getSettings(). allowClearLead(true/false); // default is false
{% endhighlight %}

### Enable Secure Surface

In case App wants to block ability to take screen capture

##### Example:

{% highlight java %}
 player.getSettings().setSecureSurface(isSurfaceSecured); // default is false
{% endhighlight %}

### Configure Player's PreferredMediaFormat.

In the case where the Media Entry contains multiple sources, the player will attempt to use formats in this priority order: 
  - DASH (mpd) 
  - HLS 
  - WVM
  - MP4 
  - MP3 
  
In order to force a Media Format that is different than the priority list, use `setPreferredMediaFormat` with the desired type: 

{% highlight java %}
player.getSettings().setPreferredMediaFormat(PKMediaFormat.mp4);
{% endhighlight %}
Making this call, for example, would move MP4 format to the top of the priority list. 


### Configure Player Load Control

Using builder API you can create LoadControl Buffers with the default ExoPlayer values
then it is possible configure any parameter from the LoadControlBuffers Object.

Defaults can be found here:
[Defaults](https://github.com/google/ExoPlayer/blob/release-v2/library/core/src/main/java/com/google/android/exoplayer2/DefaultLoadControl.java)
 

##### Example:

{% highlight java %}java
LoadControlBuffers loadControlBuffers = new LoadControlBuffers().
      setMinPlayerBufferMs(2000).
      setMaxPlayerBufferMs(45000).
      setBackBufferDurationMs(2000).
      setMinBufferAfterReBufferMs(2000).
      setMinBufferAfterInteractionMs(2000).
      setRetainBackBufferFromKeyframe(true);
      
player.getSettings().setPlayerBuffers(loadControlBuffers);
{% endhighlight %}


### Configure if to use TextureView instead of surface view

##### Example:

{% highlight java %}java
 player.getSettings().useTextureView(false); // default is false
{% endhighlight %}

### Enable Cea608Captions

##### Example:

{% highlight java %}
//Configure if to consider Cea608Captions which exist stream for text track selection.
player.getSettings().setCea608CaptionsEnabled(false); // default is false
{% endhighlight %}

### Configure KalturaPlaybackRequestAdapter

##### Example:

{% highlight java %}
 //Configure different app name/domain in KalturaPlaybackRequestAdapter 
 //which allows adapting the request parameters before sending network requests
 KalturaPlaybackRequestAdapter.install(player, "yourApplicationName"); // default is app package name
{% endhighlight %}

### Configure KalturaUDRMLicenseRequestAdapter

##### Example:

{% highlight java %}
 //configure different app name/domain in KalturaUDRMLicenseRequestAdapter which allows adapting the request parameters before sending DRM requests
 KalturaUDRMLicenseRequestAdapter.install(player, "yourApplicationName"); // default is app package name
{% endhighlight %}

### Enable - Ad will auto play on resume 

In some cases where app does not expose play pause API on ads this API will do the auto play after resume from background

##### Example:

{% highlight java %}
 player.getSettings().setAdAutoPlayOnResume(autoPlayOnResume);
{% endhighlight %}

### setVRPlayerEnabled(boolean vrPlayerEnabled);

If case 360 media should be played on VR player or default player - default is true

##### Example:

{% highlight java %}
player.getSettings().setVRPlayerEnabled(vrPlayerEnabled);
{% endhighlight %}


### Configure preferred TEXT TRACKS -- Default is no captions displayed.

##### Example:

{% highlight java %}
 //player.getSettings().setPreferredTextTrack(new PKTrackConfig().setPreferredMode(PKTrackConfig.Mode.OFF)); // no text tracks
 //player.getSettings().setPreferredTextTrack(new PKTrackConfig().setPreferredMode(PKTrackConfig.Mode.SELECTION).setTrackLanguage("hi")); // select specific track lang if not exist select manifest default if exist else the first from manifest
 player.getSettings().setPreferredTextTrack(new PKTrackConfig().setPreferredMode(PKTrackConfig.Mode.AUTO)); // select the track by locale if does not exist manifest default
{% endhighlight %}

{% highlight java %}
 /Configure preferred AUDIO TRACKS - Default is Stream's default

 //player.getSettings().setPreferredAudioTrack(new PKTrackConfig().setPreferredMode(PKTrackConfig.Mode.OFF); // default audio track (Done automatically actually)
 //player.getSettings().setPreferredAudioTrack(new PKTrackConfig().setPreferredMode(PKTrackConfig.Mode.SELECTION).setTrackLanguage("ru")); // select specific track lang if not exist select manifest default
 player.getSettings().setPreferredAudioTrack(new PKTrackConfig().setPreferredMode(PKTrackConfig.Mode.AUTO));
{% endhighlight %}


## Set Preferred Audio/Text Track

The player allows you to set the preferred language audio/text by instantiating the `PKTrackConfig`, which is created via the builder method. 

{% highlight java %}
 public PKTrackConfig setTrackLanguage(String trackLanguage)
 public PKTrackConfig setPreferredMode(@NonNull Mode preferredMode)
{% endhighlight %}

Language options are: 
- Explicitly setting the language code 
- Auto, which sets the language based on location, if available. 
- Default, which contains no text and uses the first available audio track. 

{% highlight java %}
 PKTrackConfig trackConfig = new PKTrackConfig().setPreferredMode(PKTrackConfig.Mode.OFF);
 PKTrackConfig trackConfig = new PKTrackConfig().setPreferredMode(PKTrackConfig.Mode.AUTO);
 PKTrackConfig trackConfig = new  PKTrackConfig().setPreferredMode(PKTrackConfig.Mode.SELECTION).setTrackLanguage("ru")
{% endhighlight %}

Once we have the `PKTrackConfig` object we can use it as parameter for the API.

{% highlight java %}
player.getSettings().setPreferredAudioTrack(preferredAudioTrackConfig)
player.getSettings().setPreferredTextTrack(preferredTextTrackConfig)
{% endhighlight %}

### Tracks Configuration possibilities

#### There are 3 modes available:

 - `OFF` - for Text tracks it will cancel text tracks display for audio it will select the default from the manifest
 - `AUTO` - SDK will check if the stream has audio/text track that matches the device locale and will select it else it will take stream default
 - `SELECTION` - this mode requires to set the language explicitly (2 or 3 letters)  if this language does not exist SDK will take the streams
default Audio/Text track

#### NOTE!!!
The languages that are expected by the player to match the SO 639-X codes definition

## Subtitle Sideloading for Player

> Since Playkit version 3.9.0

To load Subtitle from external source for the player, need to create a `List` of `PKExternalSubtitle` and then pass it to `PKMediaEntry` object.

{% highlight java %}
PKExternalSubtitle pkExternalSubtitle = new PKExternalSubtitle()
                .setUrl("http://URL_OF_EXTERNAL_SUBTITLE.vtt")
                .setMimeType(PKSubtitleFormat.vtt)
                .setLabel("de")
                .setLanguage("deu");
mList.add(pkExternalSubtitle);

{% endhighlight %}

{% highlight java %}
mediaEntry.setExternalSubtitleList(mList);
{% endhighlight %}

Use `setDefault()` while creating `PKExternalSubtitle` to make it default subtitle.
`TEXT_VTT` and `APPLICATION_SUBRIP` mime-types are supported for subtitles.

## Subtitle Styles for Player

To configure Subtitles to the player, first need to set the Subtitles using `settings` from `player`object.
While creating `SubtitleStyleSettings` object, need to pass `subtitleStyleName` param in constructor.

{% highlight java %}
SubtitleStyleSettings subtitleStyleSettings = new SubtitleStyleSettings("MyCustomSubtitleStyle");
player.getSettings().setSubtitleStyle(subtitleStyleSettings);
{% endhighlight %}

To update the Subtitles call `updateSubtitleStyle()` using only `player` object. Use updated `subtitleStyleSettings` object.


{% highlight java %}
player.updateSubtitleStyle(subtitleStyleSettings);
{% endhighlight %}

Using builder pattern for setters in `subtitleStyleSettings`, Following Styles can be applied,

- `setTextColor` - Change subtitle text color
- `setBackgroundColor` - Change subtitle background color
- `setEdgeColor` - Change subtitle text edge color
- `setWindowColor` - Change subtitle window color

- `setEdgeType` - Change subtitle Edge types using `enum SubtitleStyleEdgeType` with the values {% highlight java %} EDGE_TYPE_NONE, EDGE_TYPE_OUTLINE, EDGE_TYPE_DROP_SHADOW, EDGE_TYPE_RAISED, EDGE_TYPE_DEPRESSED; {% endhighlight %}

- `setTextSizeFraction` - Change subtitle text size fraction using `enum SubtitleTextSizeFraction` with the values {% highlight java %}SUBTITLE_FRACTION_50, SUBTITLE_FRACTION_75, SUBTITLE_FRACTION_100, SUBTITLE_FRACTION_125, SUBTITLE_FRACTION_150, SUBTITLE_FRACTION_200{% endhighlight %}

- `setTypeface` - Change subtitle typeface using `enum SubtitleStyleTypeface` with the values {% highlight java %}DEFAULT, DEFAULT_BOLD, MONOSPACE, SERIF, SANS_SERIF {% endhighlight %}

##### Example:

To set the Subtitles,

{% highlight java %}
SubtitleStyleSettings subtitleStyleSettings = new SubtitleStyleSettings("MyCustomSubtitleStyle")
                    .setBackgroundColor(Color.BLUE)
                    .setTextColor(Color.WHITE)
                    .setTextSizeFraction(SubtitleStyleSettings.SubtitleTextSizeFraction.SUBTITLE_FRACTION_50)
                    .setWindowColor(Color.YELLOW)
                    .setEdgeColor(Color.BLUE)
                    .setTypeface(SubtitleStyleSettings.SubtitleStyleTypeface.MONOSPACE)
                    .setEdgeType(SubtitleStyleSettings.SubtitleStyleEdgeType.EDGE_TYPE_DROP_SHADOW);

player.getSettings().setSubtitleStyle(subtitleStyleSettings);
{% endhighlight %}

To update the existing Subtitles:

{% highlight java %}
SubtitleStyleSettings subtitleStyleSettings = new SubtitleStyleSettings("MyNewCustomSubtitleStyle")
                        .setBackgroundColor(Color.WHITE)
                        .setTextColor(Color.RED)
                        .setTextSizeFraction(SubtitleStyleSettings.SubtitleTextSizeFraction.SUBTITLE_FRACTION_100)
                        .setWindowColor(Color.BLUE)
                        .setEdgeColor(Color.BLUE)
                        .setTypeface(SubtitleStyleSettings.SubtitleStyleTypeface.SANS_SERIF)
                        .setEdgeType(SubtitleStyleSettings.SubtitleStyleEdgeType.EDGE_TYPE_DROP_SHADOW);

player.updateSubtitleStyle(subtitleStyleSettings);

{% endhighlight %}

### Subtitle View Postioning Configuration
> Since Playkit version 4.8.0

* {% highlight java %}PKSubtitlePosition pkSubtitlePosition = PKSubtitlePosition(boolean overrideInlineCueConfig){% endhighlight %}

	If `overrideInlineCueConfig` is set to `true` then player will use the given Cue Settings to override the values coming in Cue Settings.

* {% highlight java %}setVerticalPosition(int verticalPositionPercentage){% endhighlight %}  

	Set the subtitle position only in Vertical direction (Up or Down) on the video frame. This method only allows to move in Y - coordinate.

* {% highlight java %}setPosition(int horizontalPositionPercentage, int verticalPositionPercentage, Layout.Alignment horizontalAlignment){% endhighlight %}

	Set the subtitle position any where on the video frame. This method allows to move in X-Y coordinates.

* {% highlight java %}setToDefaultPosition(boolean overrideInlineCueConfig){% endhighlight %}

	If `overrideInlineCueConfig` is `false` that means; app does not want to override the inline Cue configuration. App wants to go with Cue configuration.

	Note! if `setOverrideInlineCueConfig(boolean)` is called with `false` value means after that in next call, app needs to `setOverrideInlineCueConfig(boolean)` with the required value.

	Otherwise

	If `overrideInlineCueConfig` is `true` then it will move subtitle to Bottom-Center which is a standard position for it.

* {% highlight java %}setOverrideInlineCueConfig(boolean overrideInlineCueConfig){% endhighlight %} 

	If `overrideInlineCueConfig` is set to true then player will use the given Cue Settings to override the values coming in Cue Settings.

##### Note: Horizontal / Vertical position percentage limit is between 10% to 100%.

##### Vertical   - 10% Top to 100% Bottom
##### Horizontal - 10% Center to 100% Screen Edge - usually (ALIGN_NORMAL - LEFT, ALIGN_OPPOSITE - RIGHT)
     
#### Example

To set the subtitle position, it is part of `SubtitleStyleSettings`

{% highlight java %}
SubtitleStyleSettings subtitleStyleSettings = new SubtitleStyleSettings("MyCustomSubtitleStyle");
PKSubtitlePosition pkSubtitlePosition = new PKSubtitlePosition(true);
pkSubtitlePosition.setPosition(70, 30, Layout.Alignment.ALIGN_NORMAL);
 subtitleStyleSettings.setSubtitlePosition(pkSubtitlePosition);
 player.getSettings().setSubtitleStyle(subtitleStyleSettings);
{% endhighlight %} 

To update the subtitle position, use the new configuration or call setToDefault

{% highlight java %}
pkSubtitlePosition.setToDefaultPosition(true);
subtitleStyleSettings.setSubtitlePosition(pkSubtitlePosition);
player.updateSubtitleStyle(subtitleStyleSettings);
{% endhighlight %}

{% highlight java %}
SubtitleStyleSettings subtitleStyleSettings = new SubtitleStyleSettings("MyCustomSubtitleStyle");
PKSubtitlePosition pkSubtitlePosition = new PKSubtitlePosition(true);
pkSubtitlePosition.setVerticalPosition(80);
subtitleStyleSettings.setSubtitlePosition(pkSubtitlePosition);
player.getSettings().setSubtitleStyle(subtitleStyleSettings);
{% endhighlight %}

### Set ABR Settings

To enable track selection to select subset of tracks that participate in the ABR values are expected in bits

##### Example:

{% highlight java %}
player.getSettings().setABRSettings(new ABRSettings().
setMinVideoBitrate(500000).
setMaxVideoBitrate(1500000).
setInitialBitrateEstimate(400000));
{% endhighlight %}

In order to reset these values in Change Media if needed:

{% highlight java %}
player.getSettings().setABRSettings(new ABRSettings());
{% endhighlight %}

### Set Surface Aspect Ratio Resize Mode
 
 To configure Full screen Fit/Fill/Zoom support for devices with special resolution like 18:9 in order to prevent letter-boxing of video playback

##### New enum added to support this functionality

{% highlight java %}
enum PKAspectRatioResizeMode {
    fit, // common aspect ratio 
    fixedWidth,
    fixedHeight,
    fill, // 18:9 aspect ratio
    zoom
}
{% endhighlight %}

##### Example for updating the ratio resize mode for playback start time: 

{% highlight java %}
player.getSettings().setSurfaceAspectRatioResizeMode(PKAspectRatioResizeMode.fill);
{% endhighlight %}

##### Example for updating the ratio settings during the playback: 

{% highlight java %}
player.updateSurfaceAspectRatioResizeMode(PKAspectRatioResizeMode.zoom)
{% endhighlight %}

### Force Single Player Engine
 
Use forceSinglePlayerEngine for Ads playback to achieve preperContentAfterAd behaviour 

To can tell the player not to prepare the content player when Ad starts(if exists); 
instead content player will be prepared when content_resume_requested is called.
so low end devices with lack of enough decoders will be able to play ads + content separately.
Default value for this configuration is set to 'false'.

##### Example:
        
{% highlight java %}
player.getSettings().useSinglePlayerInstance(true);
{% endhighlight %}

### Set Hide Video Views

Used to enable video thumbnail to be displayed for Audio Entries
This config enable apps to hide the video surface to for audio only medias it will be able to put behind the player thumbnail and still captions will be available.

Note:  `player.getSettings().setHideVideoViews(true)` should be called before calling player prepare.

In case there is change media between audio and video, app should call `player.getSettings().setHideVideoViews(false)` in order to make the video surface visible again.

Default value for this API is false and `player.getSettings().setHideVideoViews(false)` should be called again if changing media between audio only and video.

##### Example:

{% highlight java %}
player.getSettings().setHideVideoViews(true);
player.prepare(config);
{% endhighlight %}

AudioOnlyBasicSetupSample Sample can be found in the samples repository


Note: It is application's responsibility for hiding/showing the artwork by its own logic.

### Set VR Settings

For VR and 360 medias, `PKMediaEntry` has now new member `isVRMediaType` that signs media as VR media

In case media provider is used, `PKMediaEntry` will be populated automatically on the MediaEntry which is returned from the callback.

if `VRsettings` is not configured, default values will be used (only touch will be available) 
take in account that not all devices support motion so make sure you verify that motion is supported using hte API `VRUtil.isModeSupported`

##### Example:

{% highlight java %}
player.getSettings().setVRSettings(new VRSettings().setInteractionMode(VRInteractionMode.MotionWithTouch).setFlingEnabled(true));
{% endhighlight %}

##### Example

{% highlight java %}
    if (mediaEntry.isVRMediaType()) {
                VRSettings vrSettings = new VRSettings();
                vrSettings.setFlingEnabled(true);
                vrSettings.setVrModeEnabled(false);
                vrSettings.setZoomWithPinchEnabled(true);
                VRInteractionMode interactionMode = vrSettings.getInteractionMode();
                if (VRUtil.isModeSupported(MainActivity.this, VRInteractionMode.MotionWithTouch)) {
                    vrSettings.setInteractionMode(VRInteractionMode.MotionWithTouch); // DEFAULT is Touch only!
                }
                player.getSettings().setVRSettings(vrSettings);
            }
{% endhighlight %}

For more VR settings and it defaults explore `VRSettings` APIs

### Set Custom Load Control Strategy

To change the LoadControl and the Bandwidth Meter that is being used by ExoPlayer 
    `ExoPlayerWrapper.LoadControlStrategy` interface has to be implemented and to be passed to the `setCustomLoadControlStrategy` API 

##### Example:

{% highlight java %}
player.getSettings().setCustomLoadControlStrategy(new PlaykitLoadControlStrategy(this));
{% endhighlight %}

##### The class code


```
package com.kaltura.playkitdemo;

import android.content.Context;
import android.os.Handler;

import com.kaltura.android.exoplayer2.DefaultLoadControl;
import com.kaltura.android.exoplayer2.LoadControl;
import com.kaltura.android.exoplayer2.upstream.BandwidthMeter;
import com.kaltura.android.exoplayer2.upstream.DataSource;
import com.kaltura.android.exoplayer2.upstream.DataSpec;
import com.kaltura.android.exoplayer2.upstream.DefaultBandwidthMeter;
import com.kaltura.android.exoplayer2.upstream.TransferListener;
import com.kaltura.playkit.player.ExoPlayerWrapper;

import androidx.annotation.Nullable;

public class PlaykitLoadControlStrategy implements ExoPlayerWrapper.LoadControlStrategy {

    private Context context;

    public PlaykitLoadControlStrategy(Context context) {
        this.context = context;
    }

    @Override
    public LoadControl getCustomLoadControl() {
        return new DefaultLoadControl();
    }

    @Override
    public BandwidthMeter getCustomBandwidthMeter() {
        //return new DefaultBandwidthMeter.Builder(context).build();

        TransferListener tl = new TransferListener() {
            @Override
            public void onTransferInitializing(DataSource source, DataSpec dataSpec, boolean isNetwork) {

            }

            @Override
            public void onTransferStart(DataSource source, DataSpec dataSpec, boolean isNetwork) {

            }

            @Override
            public void onBytesTransferred(DataSource source, DataSpec dataSpec, boolean isNetwork, int bytesTransferred) {

            }

            @Override
            public void onTransferEnd(DataSource source, DataSpec dataSpec, boolean isNetwork) {

            }
        };

        return new BandwidthMeter() {
            private EventListener listener;

            @Override
            public long getBitrateEstimate() {
                return 1500000;
            }

            @Nullable
            @Override
            public TransferListener getTransferListener() {
                return tl;
            }

            @Override
            public void addEventListener(Handler eventHandler, EventListener eventListener) {
                this.listener = eventListener;

                eventHandler.post(new Runnable() {
                    @Override
                    public void run() {
                        eventListener.onBandwidthSample(1000, 1000000/8, 1500000);
                        eventHandler.postDelayed(this, 1000);

                    }
                });
            }

            @Override
            public void removeEventListener(EventListener eventListener) {
                this.listener = null;
            }
        };
    }
}
```

### Set Tunneled Audio Playback

Used to enable/disable audio tunneling.

##### Example:

{% highlight java %}
player.getSettings().setTunneledAudioPlayback(true);
{% endhighlight %}


### Handle Audio Becoming Noisy

Sets whether the player should pause automatically
when audio is rerouted from a headset to device speakers.
default=false

##### Example:

{% highlight java %}
player.getSettings().handleAudioBecomingNoisyEnabled(true);
{% endhighlight %}

### Set Max Video Size

Sets the maximum allowed video width and height.
to set the maximum allowed video bitrate to sd resolution call: 
`setMaxVideoSize(new PKMaxVideoSize().setMaxVideoWidth(1279).setMaxVideoHeight(719)`
to reset call:
`setMaxVideoSize(new PKMaxVideoSize().setMaxVideoWidth(Integer.MAX_VALUE).setMaxVideoHeight(Integer.MAX_VALUE)`


##### Example:

{% highlight java %}
player.getSettings().setMaxVideoSize(new PKMaxVideoSize().setMaxVideoWidth(640).setMaxVideoHeight(360));
{% endhighlight %}

### Set Max Audio Bitrate

Sets the maximum allowed Audio bitrate 

##### Example:

{% highlight java %}
player.getSettings().setMaxAudioBitrate(65000); // input in bps
{% endhighlight %}

### Set Max Audio Channel Count

Sets maximum allowed audio channel count. default max = Integer.MAX_VALUE

##### Example:

{% highlight java %}
player.getSettings().setMaxAudioChannelCount(6); // channels allowed
{% endhighlight %}

