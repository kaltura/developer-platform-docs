---
layout: page
title: Track Selection iOS
weight: 110
---

# Track Selection

This document describes the steps required for adding support for the multi-audio and captions functionality in your application on iOS devices.
>Note: Track selection modes are available for audio and text tracks only

### Get Available Tracks

To get the available captions and audio tracks, register to the 'PlayerEvents.tracksAvailable' event on the player as follows:

```swift
func handleTracks() {
    self.addObserver(self, events: [PlayerEvent.tracksAvailable]) { [weak self] event in
        if type(of: event) == PlayerEvent.tracksAvailable {
            guard let tracks = event.tracks else {
                print("No Tracks Available")
                return
            }
            
            if let audioTracks = tracks.audioTracks {
                self.audioTracks = audioTracks
            }
            
            if let textTracks = tracks.textTracks {
                self.textTracks = textTracks
            }
        }
    }
}
```

### Select Track

To switch between tracks, use the following code:

```swift
// Select Track
func selectTrack(track: Track) {
    self.player.selectTrack(trackId: track.id)
}
```

### Get Current Tracks

```swift
// Get Current Audio/Text Track
let currentAudioTrack = self.player.currentAudioTrack
let currentTextTrack = self.player.currentTextTrack
```

### Get Current Bitrate

```swift
// Get Current Bitrate
func currentBitrateHandler() {
    self.addObserver(self, events: [PlayerEvent.playbackParamsUpdated]) { [weak self] event in
        if type(of: event) == PlayerEvent.tracksAvailable {
            // Get Current Bitrate Value
            if let currentBitrate = event.currentBitrate {
                print("currentBitrate: ", currentBitrate)
            }
        }
    }
}
```

### Available Modes and Behavior

There are three available track selection modes:

* Off - Off, which is the default mode, means different things for text selection and audio selection: for audio selection, Off means the player will use the default value from the media. For text, the player will simply turn text selection off.
* Auto - In this mode, the player selects the language by the device locale if available; if not, it takes the default selection from the stream instead (if there is one).
* Selection - This mode uses a specific selection, where you'll need to provide the specific selection you'd like to use.

#### Text Track Selection  

```swift
player.settings.trackSelection.textSelectionMode = // .off/.auto/.selection
// use text selection language when using '.selection' mode.
player.settings.trackSelection.textSelectionLanguage = // en/fr...
```

#### Audio Track Selection


```swift
player.settings.trackSelection.audioSelectionMode = // .off/.auto/.selection
// use text selection language when using '.selection' mode.
player.settings.trackSelection.audioSelectionLanguage = // en/fr...
```

## Code Samples

Go to [PlayKit iOS Samples](https://github.com/kaltura/playkit-ios-samples/tree/master) for code samples.

## Have Questions or Need Help?

Check out the [Kaltura Player SDK Forum](https://forum.kaltura.org/c/playkit) page for different ways of getting in touch.
