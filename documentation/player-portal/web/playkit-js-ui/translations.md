---
layout: page
title: Player Translations and Language
weight: 110
---

The UI locale can be customized by adding translations to the dictionary object.  
Dictionaries can be added via the config object and the UI language, and can be set via the locale config.

## Defining a new language

The language dictionary is a key-value definition, where key is the **UI placeholder name** and value is the **translated string** that will appear.

A value in the key-value may be a string or an object containing a list of key-value pairs.

A sample English dictionary looks like this:

```json
{
  "controls": {
    "play": "Play",
    "pause": "Pause",
    "share": "Share",
    "language": "Language",
    "settings": "Settings",
    "fullscreen": "Fullscreen",
    "rewind": "Rewind",
    "vrStereo": "vrStereo",
    "live": "Live",
    "unmute": "Unmute",
    "next": "Next",
    "prev": "Prev",
    "startOver": "Start over",
    "pictureInPicture": "Picture in picture"
  },
  "unmute": {
    "unmute": "Unmute"
  },
  "copy": {
    "button": "Copy"
  },
  "settings": {
    "title": "Settings",
    "quality": "Quality",
    "speed": "Speed"
  },
  "language": {
    "title": "Language",
    "audio": "Audio",
    "captions": "Captions",
    "advanced_captions_settings": "Advanced captions settings"
  },
  "share": {
    "title": "Share",
    "embed_options": "Embed Options",
    "start_video_at": "Start video at",
    "email": "Share on Email",
    "embed": "Get embed code"
  },
  "overlay": {
    "close": "Close"
  },
  "error": {
    "default_error": "Something went wrong",
    "default_session_text": "Session ID",
    "retry": "Retry"
  },
  "ads": {
    "ad_notice": "Advertisement",
    "learn_more": "Learn more",
    "skip_ad": "Skip ad",
    "skip_in": "Skip in"
  },
  "cvaa": {
    "title": "Advanced captions settings",
    "sample_caption_tag": "Sample",
    "set_custom_caption": "Set custom caption",
    "edit_caption": "Edit caption",
    "size_label": "Size",
    "font_color_label": "Font color",
    "font_family_label": "Font family",
    "font_style_label": "Font style",
    "font_opacity_label": "Font opacity",
    "background_color_label": "Background color",
    "background_opacity_label": "Background opacity",
    "apply": "Apply",
    "caption_preview": "This is your caption preview"
  },
  "cast": {
    "play_on_tv": "Play on TV",
    "disconnect_from_tv": "Disconnect from TV",
    "status": {
      "connecting_to": "Connecting to",
      "connected_to": "Connected to",
      "playing_on": "Playing on"
    }
  },
  "playlist": {
    "prev": "Previous",
    "next": "Next",
    "up_next": "Up Next",
    "cancel": "Cancel"
  },
  "pictureInPicture": {
    "overlay_text": "Playing in Picture In Picture mode",
    "overlay_button": "Play Here"
  }
}
```

The default locale is English.

A translation file may contain all the keys in the English translation; any key not found in the new translation will fallback to using the English one.  

## Choosing the display language 

Setting the display language is done by defining the locale config option, where English is the default one.

Only a locale that exist in the translations dictionary may be set, and setting a locale that doesn't exist will result in keeping the default one set.
