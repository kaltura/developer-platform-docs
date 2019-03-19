---
layout: page
title: VR and 360 Video for iOS
weight: 110
---

The Kaltura iOS Mobile Video player supports 360 video and VR on iOS mobile browsers for any kind of motion - touch and device. The **video360** plugin and VR are included in the player by default, but videos can only be viewed when the plugin is enabled.

Immersive videos, also known as 360 videos, 360 degree videos, or spherical videos, are video recordings of a real-world panorama, where the view in every direction is recorded at the same time, shot using an omnidirectional camera or a collection of cameras.
Use cases for 360 / VR are varied, and include university lectures, conferences, sports events and more.

Kaltura provides the following infrastructure to upload and play 360 / VR videos on mobile devices:

## Ingestion  

1. Ingest your asset as usual. 
2. Tag the entry “360”. Tagging the entry is required as the player will only enable 360 navigation on entries that are tagged "360". 

Note that H264 CODEC and up to 4K resolution are supported. 

## Playback  

The Kaltura Mobile Video Player will play inband multi-audio tracks based on the underlying delivery format.
* HLS
* MP4

## Supported iOS Devices  

The 360 video and VR feature is supported on devices with iOS 9 and up.


## Implemented Classes/Interfaces  

```PKVRController``` - Use this class to interact with the library.

For more information refer to the [PlayKit VR for iOS page](https://kaltura.github.io/playkit-ios-vr/).
