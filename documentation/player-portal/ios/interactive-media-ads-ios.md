---
layout: page
title: Interactive Media Ads for iOS
weight: 110
---

This document describes the steps required for adding support for the IMA Plugin functionality on iOS devices. IMA (or Interactive Media Ads) was developed by Google to enable you to display ads in your application's video, audio, and game content. To learn more about Google's IMA, see [Google's IMA developer's site](https://developers.google.com/interactive-media-ads/).

> Supported IMA SDK Version is: 3.5.2

## Common Issues

1. There is currently an open issue with IMA SDK where removing the player view before destroying the ads manager will cause an error on the next ad playback. To fix the issue all you have to do is call the `player.destroy()` before `player.removeFromSuperview()`

If you get below error:

{% highlight swift %}
Error Domain=com.kaltura.playkit.error.ima Code=1005 "Ads cannot be requested because the ad container is not attached to the view hierarchy." UserInfo={errorType=1, NSLocalizedDescription=Ads cannot be requested because the ad container is not attached to the view hierarchy.}
{% endhighlight %}

Please make sure that the order of removing player on your side is:

{% highlight swift %}
player.destroy()
player.removeFromSuperview()
{% endhighlight %}

2. When not including ads, the PlayerEvent observed events start occurring after calling prepare().
When including ads, none of the PlayerAd events occur after calling prepare().  

To resolve this issue and get `autoPlay` with ads please make sure to call play() before those events start occurring.

{% highlight swift %}
// Firstly call prepare
player.prepare()
// Then immediately 
player.play()
{% endhighlight %}

## Enable IMA Plugins for the Kaltura Video Player  

To enable the IMA Plugin on iOS devices for the Kaltura Video Player, add the following line to your Podfile: 

{% highlight swift %}
pod "PlayKit_IMA"
{% endhighlight %}

## Control Ad Play

To control ad play during runtime, implement the following Video Player delegate method:

{% highlight swift %}
func playerShouldPlayAd(_ player: Player) -> Bool {
    return true
}
{% endhighlight %}  

## Register the IMA Plugin  

Next, register the IMA Plugin inside your application as follows:

{% highlight swift %}
PlayKitManager.shared.registerPlugin(IMAPlugin.self)
{% endhighlight %}

## Configure the Kaltura Video Player to Use the IMA Plugin  

To configure the player to use IMA Plugin, add the following configuration to your `PlayerConfig` file as follows:

{% highlight swift %}
let adsConfig = IMAConfig()
adsConfig.set(adTagUrl: "your ad tag url")
let pluginConfig = PluginConfig(config: [IMAPlugin.pluginName: adsConfig])
{% endhighlight %}

## Configure Clickthroughs 

The IMA Plugin offers two options for opening ad landing pages:

* Via an in-app browser
* Via Safari 

By default, the plugin will open pages using Safari. To update the plugin to use an in-app browser, you’ll need to set the `webOpenerPresentingController` value in the AdsConfig object as follows:

{% highlight swift %}
adsConfig.set(webOpenerPresentingController: webOpenerPresentingController)
{% endhighlight %}

## Add Companion Ads

To see companion ads in the device, you'll need to implement the following steps: 

1. Configure an ad tag to return a companion ad (prepare this in advance).
2. Supply a companion ad container to the plugin using the following format (make sure the size of the companion being returned is the same size as the UIView in which you’re trying to display it):

{% highlight swift %}
adsConfig.set(companionView: companionView)
{% endhighlight %}

## Specify the Desired Bitrate and Video Formats

The IMA Plugin enables you to specify the video formats and bitrate using the following configuration:

{% highlight swift %}
adsConfig.set(videoMimeTypes: ["video/mp4", "application/x-mpegURL"])
adsConfig.set(videoBitrate: 1024)
{% endhighlight %}

## Specify the Localized Ad Language

The IMA Plugin enables you to specify the language to be used to localize ads and the Video Player UI controls. 

To do so, set the language parameter of the AdsConfig to the appropriate language code using [this reference](https://developers.google.com/interactive-media-ads/docs/sdks/ios/ads#languagecodes).

{% highlight swift %}
adsConfig.set(language: "en")
{% endhighlight %}

## Listen to Ad Events  

Use the following code to listen to ad events:

{% highlight swift %}
let events: [PKEvent.Type] = [AdEvent.adDidRequestPause, AdEvent.adDidRequestResume]

player.addObserver(self, events: events) { event in
    if type(of: event) == AdEvent.adDidRequestResume {
        // handle adDidRequestResume
    } else if type(of: event) == AdEvent.adDidRequestPause {
        // handle adDidRequestPause
    }
})
{% endhighlight %}

### Ad Info Event

To observe ad info when an ad is starting use the following:

{% highlight swift %}
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
{% endhighlight %}

### Ad Cue Points Event

To observe ad cue points update use the following:

{% highlight swift %}
player.addObserver(self, events: [AdEvent.adCuePointsUpdate]) { event in
    if let adCuePoints = event.adCuePoints {
        // use ad cue points
        if adCuePoints.hasPreRoll || adCuePoints.hasMidRoll || adCuePoints.hasPostRoll {
            // do your stuff
    }
})
{% endhighlight %}

## Have Questions or Need Help?

Check out the [Kaltura Player SDK Forum](https://forum.kaltura.org/c/playkit) page for different ways of getting in touch.
