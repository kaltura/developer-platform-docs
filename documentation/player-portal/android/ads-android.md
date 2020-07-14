---
layout: page
title: Ads for Android
weight: 110
---
This article describes the steps required for adding support for the IMA Plugin functionality on Android devices. IMA (Interactive Media Ads) was developed by Google to enable you to display ads in your application's video, audio, and game content.

### Add imaplugin dependency in `build.gradle` 

```
implementation 'com.kaltura.playkit:imaplugin:4.x.x'
```
### Configure the Plugin Configuration Object  

To configure the plugin, add the following configuration to your `pluginConfig` file as follows:

```java
private IMAConfig getIMAPluginConfig() {
    String adTagUrl = adUtil.getAdTag(mVideoDetailsModel);
    List<String> videoMimeTypes = new ArrayList<>();
    videoMimeTypes.add(PKMediaFormat.mp4.mimeType);
    videoMimeTypes.add(PKMediaFormat.hls.mimeType);
    IMAConfig adsConfig = new IMAConfig().setAdTagUrl(adTagUrl).enableDebugMode(false).setVideoMimeTypes(videoMimeTypes);
```

for more configuration options check IMAConfig API.

### IMConfig Constructor  

```java
IMAConfig(String language, boolean enableBackgroundPlayback, boolean autoPlayAdBreaks, int videoBitrate, List<String> videoMimeTypes, String adTagUrl, boolean adAttribution, boolean adCountDown)
```

### Set the Plugin Configuration to the IMA Plugin  

For the IMA Plugin to start loading, you'll need to set the plugin configuration you created as follows:

```java

PlayKitManager.registerPlugins(getActivity(), IMAPlugin.factory);

PKPluginConfigs pluginConfig = new PKPluginConfigs();

pluginConfig.setPluginConfig(IMAPlugin.factory.getName(), getIMAPluginConfig());

player = PlayKitManager.loadPlayer(this.getActivity(), pluginConfig);

```

### Change media 
This scenario requires a new adTag url within `IMAPluginConfig`.
The application must update the `IMAPlugin` with this information.
To update, call the `player.updatePluginConfig` API before calling `player.prepare`.

##### Example
 
```java
player.updatePluginConfig(IMAPlugin.factory.getName(), getIMAPluginConfig());

```

### Register to the Ad Started Event  

The Ad Started event includes the `AdInfo` payload. You can fetch this data in the following way:

```java 
player.addListener(this, AdEvent.started, event -> {
      log("AD STARTED adInfo AdPositionType =" + event.adInfo.getAdPositionType());
});
        
```

### AdInfo API  

```java
    String   getAdDescription();
    String   getAdId();
    String   getAdSystem();
    boolean  isAdSkippable();
    String   getAdTitle();
    String   getAdContentType();
    int      getAdWidth();
    int      getAdHeight();
    int      getAdPodCount();
    int      getAdPodPosition();
    long     getAdPodTimeOffset();
    long     getAdDuration();
```

### Ad Events/Error Registration Example  


```java
        player.addListener(this, AdEvent.cuepointsChanged, event -> {
            adCuePoints = event.cuePoints;
            if (adCuePoints != null) {
                log.d("Has Postroll = " + adCuePoints.hasPostRoll());
            }
        });
        
        player.addListener(this, AdEvent.adRequested, event -> {
            AdEvent.AdRequestedEvent adRequestEvent = event;
            log("AD_REQUESTED adtag = " + adRequestEvent.adTagUrl);
        });
        
        player.addListener(this, AdEvent.contentPauseRequested, event -> {
            log("ADS_PLAYBACK_START");
        });

        player.addListener(this, AdEvent.contentResumeRequested, event -> {
            log("ADS_PLAYBACK_ENDE");
        });
        
         player.addListener(this, AdEvent.resumed, event -> {
            log("ADS_PLAYBACK_RESUMED");
        });
        
        player.addListener(this, AdEvent.allAdsCompleted, event -> {
            log("ALL_ADS_COMPLETED");
        });
        
        player.addListener(this, AdEvent.error, event -> {
            AdEvent.Error adError = event;
            Log.d(TAG, "AD_ERROR " + adError.type + " "  + adError.error.message);
            appProgressBar.setVisibility(View.INVISIBLE);
            log("AD_ERROR");
        });
```

#### Please deregister all the events on player destroy phase

```java
player.removeListeners(this);
player.destroy()
```

### Ad Events  

The IMA Plugin supports the following ad events:

```java
        STARTED,
        PAUSED,
        RESUMED,
        COMPLETED,
        FIRST_QUARTILE,
        MIDPOINT,
        THIRD_QUARTILE,
        SKIPPED(),
        CLICKED,
        TAPPED,
        ICON_TAPPED,
        AD_BREAK_READY,
        AD_PROGRESS,
        AD_BREAK_STARTED,
        AD_BREAK_ENDED,
        CUEPOINTS_CHANGED,
        LOADED,
        CONTENT_PAUSE_REQUESTED,
        CONTENT_RESUME_REQUESTED,
        ALL_ADS_COMPLETED
```
        
### Ad Error Events  

The IMA Plugin supports the following ad error events:

```java
        INTERNAL_ERROR(2000),
        VAST_MALFORMED_RESPONSE(2001),
        UNKNOWN_AD_RESPONSE(2002),
        VAST_LOAD_TIMEOUT(2003),
        VAST_TOO_MANY_REDIRECTS(2004),
        VIDEO_PLAY_ERROR(2005),
        VAST_MEDIA_LOAD_TIMEOUT(2006),
        VAST_LINEAR_ASSET_MISMATCH(2007),
        OVERLAY_AD_PLAYING_FAILED(2008),
        OVERLAY_AD_LOADING_FAILED(2009),
        VAST_NONLINEAR_ASSET_MISMATCH(2010),
        COMPANION_AD_LOADING_FAILED(2011),
        UNKNOWN_ERROR(2012),
        VAST_EMPTY_RESPONSE(2013),
        FAILED_TO_REQUEST_ADS(2014),
        VAST_ASSET_NOT_FOUND(2015),
        ADS_REQUEST_NETWORK_ERROR(2016),
        INVALID_ARGUMENTS(2017),
        PLAYLIST_NO_CONTENT_TRACKING(2018);
```

### Samples

[IMA Sample](https://github.com/kaltura/kaltura-player-android-samples/tree/master/AdvancedSamples/IMASample)
[IMA DAI Sample](https://github.com/kaltura/kaltura-player-android-samples/tree/master/AdvancedSamples/IMADAISample)
