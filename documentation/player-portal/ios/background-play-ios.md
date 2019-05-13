---
layout: page
title: Playing Video in the Background for iOS
weight: 110
---

The following section describes the way to play a video while the application is minimized, for example in the case of listening to a podcast in the background. The framework observes application state changes internally to provide handling for this scenario. 

#### Playing Media While in Background  

* **Enabling your application to play audible content while in the background**. To enable your application to play audible content while in the background, enable this option in the application background modes section or info.plist.
* **Setting the audio session category**. To continue playing media while in the background, you must set an audio session category with background playback (for example: AVAudioSessionCategoryPlayback).

{% highlight swift %}
import AVFoundation
import AudioToolbox

let audioSession = AVAudioSession.sharedInstance()

do {
    try audioSession.setCategory(AVAudioSessionCategoryPlayback)
} catch let error as NSError {
    // handle the error condition
}

do {
    try audioSession.setActive(true)
} catch let error as NSError {
    // handle the error condition
}
{% endhighlight %}

**Special considerations for video media**. If the current item is displaying video, playback of the player is automatically paused when the application is sent to the background. To prevent this pause from occurring, you'll need to set the player of an AVPlayerLayer to *nil*.

{% highlight swift %}
// Remove the AVPlayerLayer from its associated AVPlayer once the app is in the background.
func applicationDidEnterBackground(_ application: UIApplication) {
    let playerView = <#Get your player view#>
    playerView.playerLayer.player = nil
}

// Restore the AVPlayer when the app is active again.
func applicationDidBecomeActive(_ application: UIApplication) {
    let playerView = <#Get your player view#>
    playerView.playerLayer.player = player
}
{% endhighlight %}

> Note: For more information about playing media while the application runs in the background see the [Apple Developer Site](https://developer.apple.com/library/content/qa/qa1668/_index.html).
 
### Connectivity

Connectivity changes are observed internally to provide better handling when no network connection is available.
Whenever network reachability changes, an error event will be sent with an NSError inside.
The player begins listening to changes when starting to load the asset, and stops when the player is deinitialized.
If more than one player is used, the network reachability notifications will stop only after all of the players are deinitialized.


To observe errors (not just reachability), add an observer for error type and use the error accessor on the event.

{% highlight swift %}
player.addObserver(self, events: [PlayerEvent.error]) { event in
    let error: NSError = event.error // on unreachable event receive NSError with relevant data
}
{% endhighlight %}

## Have Questions or Need Help?

Check out the [Kaltura Player SDK Forum](https://forum.kaltura.org/c/playkit) page for different ways of getting in touch.
