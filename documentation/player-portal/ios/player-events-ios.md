---
layout: page
title: Player Events for iOS
weight: 110
---

The player and some of the plugins fire events that tell the application (and other plugins) about events that occur before/during/after playback. 

### Listening to events from application code

The code below will add an observer to a list of various events. 

>Reminder to use `weak self` when needed in order to prevent retain cycles

```swift
player.addObserver(self, events: [PlayerEvent.playing, PlayerEvent.durationChanged, PlayerEvent.stateChanged]) { [weak self] event in
     if type(of: event) == PlayerEvent.playing {
        // handle playing event
     } else if type(of: event) == PlayerEvent.durationChanged {
        let duration = event.duration
     } else if type(of: event) == PlayerEvent.stateChanged {
        let newState = event.newState
        let oldState = event.oldState
     }
}
```

### Listening to events from plugin code

Plugins can't call `addObserver` on the player; instead, an identical function exists on the `MessageBus` object that is passed to the plugin.

## Core Player Events

The Player events are defined in the PlayerEvent class.

### Normal Flow
- **sourceSelected:** Sent when a playback source is selected
- **loadedMetadata:** The media's metadata has finished loading; all attributes now contain as much useful information as they're going to.
- **durationChanged:** The metadata has loaded or changed, indicating a change in duration of the media. This is sent, for example, when the media has loaded enough that the duration is known.
- **tracksAvailable:** Sent when track info is available.
- **playbackInfo:** Sent event that notify about changes in the playback parameters. When bitrate of the video or audio track changes or new media loaded. Holds the PlaybackInfo.java object with relevant data.
- **canPlay:** Sent when enough data is available that the media can be played, at least for a couple of frames. This corresponds to the HAVE_ENOUGH_DATA readyState.
- **play:** Sent when playback of the media starts after having been paused; that is, when playback is resumed after a prior pause event.
- **playing:** Sent when the media begins to play (either for the first time, after having been paused, or after ending and then restarting).
- **ended:** Sent when playback completes.

### Additional User actions
- **pause:** Sent when playback is paused.
- **seeked:** Sent when a seek operation completes.
- **seeking:** Sent when a seek operation begins.
- **stopped:** sent when stop player API is called

### Track change
- **videoTrackChanged:** A video track was selected
- **audioTrackChanged:** An audio track was selected
- **textTrackChanged:** A text track was selected

### Metadata (ID3 tags and related)
- **timedMetadata:** Sent when there is metadata available for this entry.

### Errors
- **error:** Sent when an error occurs. The element's error attribute contains more information. See Error handling for details.

### State Change
The Player can be in one of 4 playback states:

  `idle`, `buffering`, `ready`, `ended`
  
The `stateChanged` event is fired when the player transitions between states.

## Ad Events

Defined in AdEvent class.

- adBreakReady
- allAdsCompleted
- adComplete
- adClicked
- adFirstQuartile
- adLoaded
- adLog
- adMidpoint
- adPaused
- adResumed
- adSkipped
- adStarted
- adTapped
- adThirdQuartile
- adDidProgressToTime
- adDidRequestContentPause
- adDidRequestContentResume
- adCuePointsUpdate
- adStartedBuffering
- adPlaybackReady
- requestTimedOut
- adsRequested

## Code Samples
- [Events Registration](https://github.com/kaltura/playkit-ios-samples/tree/master/EventsRegistration)
- [App Analytics](https://github.com/kaltura/playkit-ios-samples/tree/master/AppAnalyticsSample)
