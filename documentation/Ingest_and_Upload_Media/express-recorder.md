---
layout: page
title: Kaltura Recorder Express Component
weight: 110
---

The Express Recorder is a Kaltura component that can be easily embedded into any webpage. It allows for on-the-fly video recording via webcam, and an automatic upload to your Kaltura account.  

![express](/assets/images/express-recorder-1.png)

The Recorder Express features an iconic big red button. Once clicked, there is a three second countdown before recording begins. When the recording is stopped, the user is faced with three options: Download a Copy, Record Again, or Use This. Much like the Kaltura Player, the express recorder can be customized to fit your needs. 

![express2](/assets/images/express-recorder-2.png)

This guide will show you how to embed the component in your webpage. The complete sample code can be found [here](https://github.com/kaltura-vpaas/express-recorder)

## Setting Up 

In order to use the Recorder, you'll need a Kaltura Partner ID and Admin Secret, which can be found in the [Integration Settings](https://kmc.kaltura.com/index.php/kmcng/settings/integrationSettings) of your KMC. You'll also need a `UI Conf ID`, which is basically the ID of the video player you wish to use, found in the [Player Studio](https://kmc.kaltura.com/index.php/kmcng/studio/v3). 


## Embedding The Recorder 

You'll need three bits of code to embed the express recorder: 

1. The script that loads the recorder: 

```javascript 
<script src="https://www.kaltura.com/apps/expressrecorder/latest/express-recorder.js"></script>
```

2. The div that holds the recorder, where you can edit your preferred size and name the div as you wish: 

```html 
<div id="recorder" style="width: 560px; height: 316px;"></div>
```
3. The script that contains the "props" or values that are being passed to the recorder. Make sure that the ID matches the ID of the div in #2 (i.e. `recorder`). 

<script type="text/javascript">
    var component = Kaltura.ExpressRecorder.create('recorder', {
        "ks": "<KALTURA SESSION>",
        "serviceUrl": "https://www.kaltura.com",
        "playerUrl": "https://cdnapisec.kaltura.com",
        "app": "appName",
        "conversionProfileId": null,
        "partnerId": "<PARTNER ID>",
        "entryName": "<Name of Recording>",
        "uiConfId": "<PLAYER ID>"
    });
</script>

This is the complete list of values that can be used in the recorder properties: 

| name | description | type | required | default | 
| ------ | -------------------- | ------- | ------ | ------- |
| ks | kaltura session key | string | yes | --- | 
| serviceUrl | kaltura service URL | string | yes | --- | 
| app | client tag | string | yes | --- | 
| playerUrl | kaltura player service URL | string | yes |--- |
| partnerId | kaltura partner id | number | yes | --- | 
| uiConfId | kaltura player id (player v3 required) | number | yes | --- | 
| conversionProfileId | the conversion profile id to be used on the created | entry	number | no	| 1 | 
| entryName | name for the created entry | string | no | Video/Audio Recording - [date] | 
| allowVideo | allow video streaming | boolean | no | true | 
| allowAudio | allow audio streaming | boolean | no | true | 
| maxRecordingTime |	maximum time for recording in seconds | number | no | unlimited | 
| showUploadUI | show upload progress and cancel button during upload | boolean | no | true | 

## Events 

The Express Recorder will throw a variety of events so that you can keep track of specific moments and analyze important insights. 

### Event Types 

- **error**: fired when errors occur. event.detail.message holds error text
- **recordingStarted**: fired when countdown to recording starts
- **recordingEnded**: fired when recording ends
- **recordingCancelled**: fired after a recording is cancelled
- **mediaUploadStarted**: fires after entry has been created and media upload start. Returns entryId by event.detail.entryId
- **mediaUploadProgress**: describes upload progress. event.detail.loaded holds the amount of bytes loaded, event.detail.total holds the total amount of bytes to be loaded.
- **mediaUploadEnded**: fires after media upload has been ended. Returns entryId by event.detail.entryId
- **mediaUploadCancelled**: fires when media upload has been canceled by the user. Returns entryId by event.detail.entryId

### Listening to Events

You'll need to create a listener for the specific event type you're interested in: 

```const component = Kaltura.ExpressRecorder.create('parent_div_id', {...}); component.instance.addEventListener(eventType, callback);```

## Methods

These are actions that can be performed on the recorder component: 

- ``startRecording()`` clears existing recording if exists and starts the recording - countdown.
- ``stopRecording()`` stops an ongoing recording.
- ``saveCopy()`` after recording exists, saves a local copy of the recorded media.
- ``upload()`` uploads the latest recording to Kaltura.
- ``cancelUpload()`` cancels an ongoing upload.
- ``addEventListener(type: string, listener: (event: ExpressRecorderEvent) => void)`` allows listening to recorder events.
- ``removeEventListener(type: string, callback: (event: ExpressRecorderEvent) => void)`` stops listening to recorder events.
