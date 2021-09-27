---
layout: page
title: Creating and Managing Playlists
weight: 110
---

Kaltura supports a rich variety of playlists for your content. Read the Kaltura [playlist guide](https://knowledge.kaltura.com/help/creating-and-configuring-playlists) for a step-by-step overview of the concepts covered here. 

Manual playlists allow you to select a static list of items, while Rule-based playlists are dynamic and automatically updated based on what's currently available in your media library and what rules define the playlist. 

The [playlist API](https://developer.kaltura.com/api-docs/service/playlist) has actions to add,delete, update and retrieve playlists.

## Playing playlists

For a detailed overview of how to playback playlists refer to [web player playlist guide](https://developer.kaltura.com/player/web/playlist-web) or the [android playlist guide](https://developer.kaltura.com/player/android/playlist-android)

## Using API to create playlists

Start with [playlist.add](https://developer.kaltura.com/api-docs/service/playlist/action/add)

### Creating Manual Playlists

For a manual playlist, choose STATIC_LIST as playlistType and supply a comma separated list of entryIds for playlistContent. 

<img src="/Users/hunterp/Documents/GitHub/developer-platform/assets/images/playlistadd.png" alt="playlistadd" style="zoom:33%;" />

### Creating Rule Based Playlists

For a DYNAMIC list, you will need to supply xml for your playlistContent. For example, the XML for the  "most popular videos" dynamic playlist that comes by default with all new [KMC](https://kmc.kaltura.com/index.php/kmcng/content/entries/list) accounts is:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<playlist>
   <total_results>50</total_results>
   <filters>
      <filter>
         <in_media_type>1,</in_media_type>
         <eq_partner_id>632</eq_partner_id>
         <order_by>-plays</order_by>
         <limit>30</limit>
      </filter>
   </filters>
</playlist>
  
```

This was obtained from the `playlistContent` field returned by calling [playlist.get](https://developer.kaltura.com/api-docs/service/playlist/action/get) using the playlist entryId obtained from the KMC or via [playlist.list](https://developer.kaltura.com/api-docs/service/playlist/action/list)

### Creating MRSS Playlists

Select EXTERNAL for `playlistType` and supply a URL to a [valid mrss file]( https://gist.github.com/hunterpp/5ce83229864065620c9145bbb8e3ce3b)



## Stitched Playlist Playback

Refer to [Play-Manifests,-HLS-and-DASH-Streaming](../Streaming-and-Publishing/Play-Manifests,-HLS-and-DASH-Streaming.html) for stitched playback of playlists.



## Playlist Analytics

A playlist is child of [BaseEntry](https://developer.kaltura.com/api-docs/General_Objects/Objects/KalturaPlaylist) and its `entryId` can be used to retrieve analytics, see  [Intro-to-Kaltura-Video-Analytics-and-Best-Practices](../Analytics-and-Reporting /Intro-to-Kaltura-Video-Analytics-and-Best-Practices.html) 

You can also refer to this [guide](https://knowledge.kaltura.com/help/playlist-analytics) for accessing playlist analytics from the KMC.

Finally, you can use a playlist's `entryId` to call [Embedded-Analytics-Reports](../Analytics-and-Reporting /Embedded-Analytics-Reports.md) to mimic the experience from the guide above.

