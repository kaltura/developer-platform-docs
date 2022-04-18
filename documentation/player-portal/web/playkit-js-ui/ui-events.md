---
layout: page
title: Player UI Events 
weight: 110
---

## UI_CLICKED

Fires on any user interaction with the UI.

## UI_VISIBILITY_CHANGED

Fires when the UI visibility state changes from visible to hidden or from hidden to visible.
### Payload Parameters

| Name      | Type      | Description                                            |
| --------- | --------- | ------------------------------------------------------ |
| `visible` | `boolean` | True when the UI is shown, false when the UI is hidden |


## USER_CLICKED_PLAY

Fires when the user initiated play by the UI.
Will fire when clicking the play button or the video area.

## USER_CLICKED_PAUSE

Fires when the user initiated pause by the UI.
Will fire when clicking the pause button or the video area.

## USER_CLICKED_REWIND

Fires when the rewind button has been clicked by the user.
### Payload Parameters

| Name   | Type     | Description                        |
| ------ | -------- | ---------------------------------- |
| `from` | `number` | The playback time before the click |
| `to`   | `number` | The playback time after the click  |

## USER_CLICKED_LIVE_TAG

Fires when the live tag button has been clicked by the user.<br>

## USER_CLICKED_MUTE

Fires when the user clicked the volume button and changed his state to mute.

## USER_CLICKED_UNMUTE

Fires when the user clicked the volume button and changed his state to unmute.

## USER_CHANGED_VOLUME

Fires when the user dragged the volume bar and changed its value.
### Payload Parameters

| Name     | Type     | Description    |
| -------- | -------- | -------------- |
| `volume` | `number` | The new volume |

## USER_SELECTED_CAPTION_TRACK

Fires when the user selected a caption from the Captions dropdown.
### Payload Parameters

| Name           | Type     | Description                |
| -------------- | -------- | -------------------------- |
| `captionTrack` | `Object` | The selected caption track |

## USER_SELECTED_AUDIO_TRACK

Fires when the user selected an audio track from the Audio dropdown.
### Payload Parameters

| Name         | Type     | Description              |
| ------------ | -------- | ------------------------ |
| `audioTrack` | `Object` | The selected audio track |

## USER_SELECTED_QUALITY_TRACK

Fires when the user selected quality from the Quality dropdown.
### Payload Parameters

| Name           | Type     | Description                |
| -------------- | -------- | -------------------------- |
| `qualityTrack` | `Object` | The selected quality track |

## USER_ENTERED_FULL_SCREEN

Fires when the UI is entered to full screen mode due to user gesture.<br>
This can be done by clicking the full screen button or double clicking the video area.

## USER_EXITED_FULL_SCREEN

Fires when the UI is exited from full screen mode due to user gesture.<br>
This can be done by clicking the full screen button or double clicking the video area.

## USER_SELECTED_CAPTIONS_STYLE

Fires when the user selected a captions style from the Advanced Captions Settings menu.
### Payload Parameters

| Name            | Type     | Description                 |
| --------------- | -------- | --------------------------- |
| `captionsStyle` | `Object` | The selected captions style |

## USER_SELECTED_SPEED

Fires when the user selected a certain speed from the Speed dropdown.
### Payload Parameters

| Name    | Type     | Description        |
| ------- | -------- | ------------------ |
| `speed` | `number` | The selected speed |

## USER_SEEKED

Fires when the user initiated seek by dragging the seek bar.
### Payload Parameters

| Name   | Type     | Description                       |
| ------ | -------- | --------------------------------- |
| `from` | `number` | The playback time before the seek |
| `to`   | `number` | The playback time after the seek  |
