---
layout: page
title: Player Events for Android 
weight: 110
---

The player and some of the plugins fire events that tell the application (and other plugins) about events that occur before/during/after playback. 

## Listening to events from applications

Call the following Player method, one or more times. `eventTypes` is the list of events that should be sent to the given listener:

{% highlight java %}
  player.addEventListener(PKEvent.Listener listener, Enum... eventTypes)
{% endhighlight %}

#### Example

```
   private fun addPlayerStateListener() {
        player!!.addListener(this, PlayerEvent.stateChanged) { event ->
            Log.d(TAG, "State changed from " + event.oldState + " to " + event.newState)
            playerState = event.newState
        }
    }

    private fun addPlayerEventsListener() {
        player!!.addListener(this, PlayerEvent.tracksAvailable) { event ->
            Log.d(TAG, "TracksAvailable event")
            val trackInfo = event.tracksInfo
            for(videoTrack in trackInfo.videoTracks) {
                Log.d(TAG, "video id = " + videoTrack.uniqueId + " track bitrate = " + videoTrack.bitrate)
            }
        }

        player!!.addListener(this,  PlayerEvent.canPlay) { event ->
            Log.d(TAG, "PlayerEvent " + event.eventType())
        }

        player!!.addListener(this,  PlayerEvent.playing) { event ->
            Log.d(TAG, "PlayerEvent " + event.eventType())
        }

        player!!.addListener(this,  PlayerEvent.error) { event ->
            Log.d(TAG, "Error PlayerEvent " + event.error.message + " isFatal = " + event.error.isFatal)
        }
    }
```
## Removing Event Listeners from application (v3.6.2 and up)

Starting with PlayKit v3.6.2, the addEventListener method returns the listener that was passed to it. This makes it easier to use it with listeners that are defined by anonymous classes, in the case the application wants to remove them later.

There are two methods that allow removing event listeners:

- Remove listener from specific events:
{% highlight java %}
  player.removeEventListener(@NonNull PKEvent.Listener listener, Enum... events); // remove by event
{% endhighlight %}

- Remove listener from all events:
{% highlight java %}
  player.removeListener(@NonNull PKEvent.Listener listener); // remove all registered events
{% endhighlight %}

## Listening to events from plugins

`player.addEventListener()` is only meant to be used by applications. It does not work for plugins. Instead, plugins are given an instance of PlayKit's MessageBus.

{% highlight java %}
  messageBus.listen(PKEvent.Listener listener, Enum... eventTypes)
{% endhighlight %}


## Core Player Events

The Player events are defined in the PlayerEvent class.

### Normal Flow
- SOURCE_SELECTED: Sent when a playback source is selected
- LOADED_METADATA: The media's metadata has finished loading; all attributes now contain as much useful information as they're going to.
- DURATION_CHANGE: The metadata has loaded or changed, indicating a change in duration of the media. This is sent, for example, when the media has loaded enough that the duration is known.
- TRACKS_AVAILABLE: Sent when track info is available.
- PLAYBACK_INFO_UPDATED: Sent event that notify about changes in the playback parameters. When bitrate of the video or audio track changes or new media loaded. Holds the PlaybackInfo.java object with relevant data.
- CAN_PLAY: Sent when enough data is available that the media can be played, at least for a couple of frames. This corresponds to the HAVE_ENOUGH_DATA readyState.
- PLAY: Sent when playback of the media starts after having been paused; that is, when playback is resumed after a prior pause event.
- PLAYING: Sent when the media begins to play (either for the first time, after having been paused, or after ending and then restarting).
- PLAYHEAD_UPDATED: Send player position every 100 ms
- ENDED: Sent when playback completes.

### Additional User actions
- PAUSE: Sent when playback is paused.
- SEEKED: Sent when a seek operation completes.
- SEEKING: Sent when a seek operation begins.
- REPLAY:Sent when replay happened.
- STOPPED: sent when stop player API is called

### Track change
- VIDEO_TRACK_CHANGED: A video track was selected
- AUDIO_TRACK_CHANGED: An audio track was selected
- TEXT_TRACK_CHANGED: A text track was selected

### Rate and Volume change
- PLAYBACK_RATE_CHANGED
- VOLUME_CHANGED: Sent when volume is changed.

### Metadata (ID3 tags and related)
- METADATA_AVAILABLE: Sent when there is metadata available for this entry.

### Errors
- ERROR: Sent when an error occurs. The element's error attribute contains more information. See Error handling for details.

### State Change
The Player can be in one of 4 playback states:
  IDLE, LOADING, READY, BUFFERING
The STATE_CHANGED event is fired when the player transitions between states.

### Subtitle Style update
- SUBTITLE_STYLE_CHANGED: Sent when subtitle style is changed

## Ad Events

Defined in AdEvent class.

- AD_REQUESTED
- STARTED
- AD_DISPLAYED_AFTER_CONTENT_PAUSE
- PAUSED
- RESUMED
- COMPLETED
- FIRST_QUARTILE
- MIDPOINT
- THIRD_QUARTILE
- SKIPPED
- CLICKED
- TAPPED
- ICON_TAPPED
- AD_BREAK_READY
- AD_PROGRESS
- AD_BREAK_STARTED
- AD_BREAK_ENDED
- AD_BREAK_IGNORED
- CUEPOINTS_CHANGED
- PLAY_HEAD_CHANGED
- LOADED
- CONTENT_PAUSE_REQUESTED
- CONTENT_RESUME_REQUESTED
- ALL_ADS_COMPLETED
- AD_LOAD_TIMEOUT_TIMER_STARTED
- ERROR


## Code Samples for v4.x.x

- [Events Registration](https://github.com/kaltura/kaltura-player-android-samples/tree/master/AdvancedSamples/EventsRegistration)
- [Youbora Analytics](https://github.com/kaltura/kaltura-player-android-samples/tree/master/AdvancedSamples/Youbora)

Kava Analytics is turned on automatically in Kaltura player in the following sample it is configured manually

- [Kava Analytics] (https://github.com/kaltura/playkit-android-samples/tree/master/KavaAnalytics)
