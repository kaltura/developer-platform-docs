---
layout: page
title: Player Configuration for Android 
weight: 110
---

The player configuration is the main data object of the SDK; this object is used for configuring all plugins and for creating and obtaining the media provider media entries that will play on the device.

## Media Entry - PKMediaEntry  

The PKMediaEntry contains information regarding the media that will be played. With this information, the Kaltura Mobile Video Player
prepares the source that will play the media, decides which type of player is required to play the media, and more.

### Methods for Creating the PKMediaEntry  

The PKMediaEntry can be created using one of the following methods:

1. **Manually** - Instantiate a new PKMediaEntry instance and fill the fields. 

   #### Example:

   [Basic Setup without provider](https://github.com/kaltura/kaltura-player-android-samples/tree/release/v4.4.0/BasicSamples/BasicSetup)

2. **Using a MockMediaProvider** - Create a PKMediaEntry from a JSON input file or JsonObject.
   
3. **Using a remote media provider** - Use one of the provided MediaEntryProvider implementations:
    
    For OVP environments, use "KalturaOvpMediaProvider".
    
    #### Example:

   [OVP media provider]( https://github.com/kaltura/kaltura-player-android-samples/tree/release/v4.4.0/OVPSamples/BasicSetupp)
   
    
    For OTT environments, use "PhoenixMediaProvider".
    
    #### Example:

   [Phoenix media provider](https://github.com/kaltura/kaltura-player-android-samples/tree/release/v4.4.0/OTTSamples/BasicSetup)

    To use this method, you'll need to do the following:
   
   a) Create an instance of one of the above mentioned providers.
   
   b) Set the mandatory parameters needed for fetching data, such as media id, SessionProvider, etc.
   
   c) Once your provider object is ready, activate its "load" method and pass a completion callback. If successful, the PKMediaEntry object will be provided in the response.
   
Once you have a PKMediaEntry ready, you can build the player configuration and plugins, and continue to prepare the Kaltura Mobile Video Player for play.

### About the PKMediaEntry  

The PkMediaEntry holds information gathered from the media details and needed for the player, such as the URL to play, the DRM data, and duration.

This object usually will be created using one of the media providers in case Kaltura's BE is used for hosting your media files.

Additional information includes:

* String id - correlates to the media/entry id
* long duration - the media duration in seconds
* MediaEntryType mediaType - indicates the type to be played (VOD, Live or Unknown)
* List<PKMediaSource> sources - list of source objects

The PKMediaEntry can be created with builder style instantiation, chain setters as follows:

```java
PKMediaEntry mediaEntry = new PKMediaEntry().setId(entry.getId())
                                            .setSources(sourcesList)
                                            .setDuration(entry.getDuration())
                                            .setMediaType(MediaTypeConverter.toMediaEntryType(entry.getType()));
```

To learn more, see [PKMediaEntry](https://github.com/kaltura/playkit-android/blob/develop/playkit/src/main/java/com/kaltura/playkit/PKMediaEntry.java).

### PKMediaSource  

The PKMediaEntry object contains a list of "PKMediaSources". All sources relate to the same media, but have different formats / qualities / flavors. The player determines which of the sources will actually be played.

To learn more, see [PKMediaSource](https://github.com/kaltura/playkit-android/blob/develop/playkit/src/main/java/com/kaltura/playkit/PKMediaSource.java)

#### Manually a Create Media Source  

PKMediaSource can be created with builder-like coding, by chaining setters:

```java
PKMediaSource pkMediaSource = new PKMediaSource().setId(sourceId)
.setUrl(sourceUrl)
.setDrmData(dramDataList);

```

* **_In OTT environments:_**
Each source represents one MediaFile (Media or AssetInfo contains list of MediaFile items. Each file represents a different format. HD, SD Download...)
Each file can point to a different video, like Trailer MediaFile and HD media file.
When playing on OTT environments, specific "format" (MediaFile), should be configured.


* **_In OVP environments:_**
PKMediaSource items are created according to several criteria:
  * Supported video format: url [.mp4], mpdash [.mpd], applehttp [.m3u8]
  * Flavors: defines the quality of the video.
  * Bit rate

A single "Entry" can have many media sources. The player determines which source to use according to the device's capability, connection quality, and other parameters, such as which of the sources is best for the current play. 

If the media is DRM-restricted, such as Widevine, the DRM information will be needed for playing.

### PKDrmParams

PKDrmParams represents a single DRM license info object. PKDrmParams contains the licenseUri that will be needed for the play. The PKMediaSource contains a list of "PKDrmParams" items. The player will select the source and the relevant DRM data according to device type, connectivity, supported formats, etc.


#### Example for creating MediaEntry with DRM configuration without media provider

```
   private PKMediaEntry createMediaEntry() {
        //Create media entry.
        PKMediaEntry mediaEntry = new PKMediaEntry();

        //Set id for the entry.
        mediaEntry.setId("testEntry");
        mediaEntry.setName("testEntryName");
        mediaEntry.setDuration(881000);
        //Set media entry type. It could be Live,Vod or Unknown.
        //In this sample we use Vod.
        mediaEntry.setMediaType(PKMediaEntry.MediaEntryType.Vod);

        //Create list that contains at least 1 media source.
        //Each media entry can contain a couple of different media sources.
        //All of them represent the same content, the difference is in it format.
        //For example same entry can contain PKMediaSource with dash and another
        // PKMediaSource can be with hls. The player will decide by itself which source is
        // preferred for playback.
        List<PKMediaSource> mediaSources = createMediaSourcesDRM();

        //Set media sources to the entry.
        mediaEntry.setSources(mediaSources);

        return mediaEntry;
    }
    
    private List<PKMediaSource> createMediaSourcesDRM() {

        //Create new PKMediaSource instance.
        PKMediaSource mediaSource = new PKMediaSource();
        mediaSource.setId("1_f93tepsn");
        //Set the id.
        mediaSource.setId("drmTestSource");

        String DRM_SOURCE_URL =  "https://cdnapisec.kaltura.com/p/2222401/sp/222240100/playManifest/entryId/1_f93tepsn/protocol/https/format/mpegdash/flavorIds/1_7cgwjy2a,1_xc3jlgr7,1_cn83nztu,1_pgoeohrs/a.mpd";
        String DRM_LICENSE_URL = "https://udrm.kaltura.com/cenc/widevine/license?custom_data=eyJjYV9zeXN0ZW0iOiJPVlAiLCJ1c2VyX3Rva2VuIjoiZGpKOE1qSXlNalF3TVh5czdLYlZZV0xaZURuWGpOTXR4LVBidWh4aDU4SUF6d3V2LW9MeHo3aUl4cmZGc3k4UUJ6VFR2ek1sS3JNRmFmV2FpQVNJWUFzYWZVWW5xcTNqQkltSXdwbGtSZFJsM1FiUnRmc3NTV0dXNXc9PSIsImFjY291bnRfaWQiOjIyMjI0MDEsImNvbnRlbnRfaWQiOiIxX2Y5M3RlcHNuIiwiZmlsZXMiOiIxXzdjZ3dqeTJhLDFfeGMzamxncjcsMV9jbjgzbnp0dSwxX3Bnb2VvaHJzIn0%3D&signature=nOnF%2FmHC0vO0j9OGKRgex8BlfMg%3D";
        mediaSource.setUrl(DRM_SOURCE_URL);

        // Add DRM data if required
        if (DRM_LICENSE_URL != null) {
            mediaSource.setDrmData(Collections.singletonList(
                    new PKDrmParams(DRM_LICENSE_URL, PKDrmParams.Scheme.WidevineCENC)
            ));
        }

        //Set the format of the source. In our case it will be hls in case of mpd/wvm formats you have to to call mediaSource.setDrmData method as well
        mediaSource.setMediaFormat(PKMediaFormat.dash);

        return Collections.singletonList(mediaSource);
    }
```  

### Sample

[Basic Setup](https://github.com/kaltura/playkit-android-samples/tree/Samples_v4.4.0/BasicSetup)  
    