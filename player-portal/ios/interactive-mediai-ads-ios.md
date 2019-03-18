---
layout: page
title: Interactive Media Ads for iOS
weight: 110
---


# Interactive Media Ads for iOS

This document describes the steps required for adding support for the IMA Plugin functionality on iOS devices. IMA (or Interactive Media Ads) was developed by Google to enable you to display ads in your application's video, audio, and game content. To learn more about Google's IMA, see [Google's IMA developer's site](https://developers.google.com/interactive-media-ads/).

> Supported IMA SDK Version is: 3.5.2

## Common Issues

1. There is currently an open issue with IMA SDK where removing the player view before destorying the ads manager will cause an error on the next ad playback. To fix the issue all you have to do is call the `player.destroy()` before `player.removeFromSuperview()`

If you get below error:

```
Error Domain=com.kaltura.playkit.error.ima Code=1005 "Ads cannot be requested because the ad container is not attached to the view hierarchy." UserInfo={errorType=1, NSLocalizedDescription=Ads cannot be requested because the ad container is not attached to the view hierarchy.}
```

Please make sure that the order of removing player on your side is:

```swift
player.destroy()
player.removeFromSuperview()
```

2. When not including ads, the PlayerEvent observed events start occuring after calling prepare().
When including ads, none of the PlayerAd events occur after calling prepare().  

To resolve this issue and get `autoPlay` with ads please make sure to call play() before those events start occuring.

```swift
// Firstly call prepare
player.prepare()
// Then immediately 
player.play()
```

## Enable IMA Plugins for the Kaltura Video Player  

To enable the IMA Plugin on iOS devices for the Kaltura Video Player, add the following line to your Podfile: 

```ruby
pod "PlayKit_IMA"
```

## Control Ad Play

To control ad play during runtime, implement the following Video Player delegate method:

```swift
func playerShouldPlayAd(_ player: Player) -> Bool {
    return true
}
```  

## Register the IMA Plugin  

Next, register the IMA Plugin inside your application as follows:

```swift
PlayKitManager.shared.registerPlugin(IMAPlugin.self)
```

## Configure the Kaltura Video Player to Use the IMA Plugin  

To configure the player to use IMA Plugin, add the following configuration to your `PlayerConfig` file as follows:

```swift
let adsConfig = IMAConfig()
adsConfig.set(adTagUrl: 'your ad tag url')
let pluginConfig = PluginConfig(config: [IMAPlugin.pluginName: adsConfig])
```

## Configure Clickthroughs 

The IMA Plugin offers two options for opening ad landing pages:

* Via an in-app browser
* Via Safari 

By default, the plugin will open pages using Safari. To update the plugin to use an in-app browser, you’ll need to set the `webOpenerPresentingController` value in the AdsConfig object as follows:

```swift
adsConfig.set(webOpenerPresentingController: webOpenerPresentingController)
```

## Add Companion Ads

To see companion ads in the device, you'll need to implement the following steps: 

1. Configure an ad tag to return a companion ad (prepare this in advance).
2. Supply a companion ad container to the plugin using the following format (make sure the size of the companion being returned is the same size as the UIView in which you’re trying to display it):

```swift
adsConfig.set(companionView: companionView)
```

## Specify the Desired Bitrate and Video Formats

The IMA Plugin enables you to specify the video formats and bitrate using the following configuration:

```swift
adsConfig.set(videoMimeTypes: ["video/mp4", "application/x-mpegURL"])
adsConfig.set(videoBitrate: 1024)
```

## Specify the Localized Ad Language

The IMA Plugin enables you to specify the language to be used to localize ads and the Video Player UI controls. 

To do so, set the language parameter of the AdsConfig to the appropriate language code using [this reference](https://developers.google.com/interactive-media-ads/docs/sdks/ios/ads#languagecodes).

```swift
adsConfig.set(language: "en")
```

## Listen to Ad Events  

Use the following code to listen to ad events:

```swift
let events: [PKEvent.Type] = [AdEvent.adDidRequestPause, AdEvent.adDidRequestResume]

player.addObserver(self, events: events) { event in
    if type(of: event) == AdEvent.adDidRequestResume {
        // handle adDidRequestResume
    } else if type(of: event) == AdEvent.adDidRequestPause {
        // handle adDidRequestPause
    }
})
```

### Ad Info Event

To observe ad info when an ad is starting use the following:

```swift
player.addObserver(self, events: [AdEvent.adStarted]) { event in
    if let info = event.adInfo {
        // use ad info
        switch info.positionType {
        case .preRoll: // handle pre roll
        case .midRoll: // handle mid roll
        case .postRoll: // handle post roll
        }
    }
})
```

### Ad Cue Points Event

To observe ad cue points update use the following:

```swift
player.addObserver(self, events: [AdEvent.adCuePointsUpdate]) { event in
    if let adCuePoints = event.adCuePoints {
        // use ad cue points
        if adCuePoints.hasPreRoll || adCuePoints.hasMidRoll || adCuePoints.hasPostRoll {
            // do your stuff
    }
})
```

## Have Questions or Need Help?

Check out the [Kaltura Player SDK Forum](https://forum.kaltura.org/c/playkit) page for different ways of getting in touch.
