---
layout: page
title: The playManifest Service: Streaming API for Videos and Playlists
weight: 601
---

The Kaltura Player abstracts the need to retrieve direct access to the video file, and handles the various aspects of the video playback including multi-bitrate, choosing the correct codec and streaming protocols, DRM, Access Control and more.  
However, on occasion, your applications may need a direct access to stream or download media outside of the Kaltura Player.   
In cases where you need to access the playback stream directly, or just a link to download the video file, you will need to consider the target playback devices, the delivery profiles and security protocols applied to your Kaltura account and video entry, and then call the suitable API methods.  

This guide walks through using the `playManifest` API action to retrieve specific video flavors in various formats and protocols.   

## The playManifest Service  

The playManifest is a redirect action [source code](https://github.com/kaltura/server/blob/master/alpha/apps/kaltura/modules/extwidget/actions/playManifestAction.class.php), whose purpose is to direct video applications to the needed video stream. Combined with Kaltura's [on-the-fly video packager](https://github.com/kaltura/nginx-vod-module), the Kaltura platform only stores your mp4 files, while creating packaged streams such as HLS, or DASH on the fly, and serving them through your configured CDN.  

The playManifest features return the following types:

1. A redirect to video file for [progressive download](http://en.wikipedia.org/wiki/Progressive_download)  
2. An m3u8 stream descriptor for [Apple HTTP Streaming, aka HLS](http://en.wikipedia.org/wiki/HTTP_Live_Streaming)  
3. An XML response in the form of a [MPEG-DASH Media Presentation Description (aka MPD)](https://en.wikipedia.org/wiki/Dynamic_Adaptive_Streaming_over_HTTP)  
4. An XML response in the form of [Flash Media Manifest File](http://osmf.org/dev/osmf/specpdfs/FlashMediaManifestFileFormatSpecification.pdf)  


### Retrieving a URL for your Video Stream  

To use the `playManifest` API action, consider the following steps:  

1.  Make sure you have the Partner ID (You account ID aka pid can be retrieved from the KMC > Settings > Integration Settings panel) and Entry ID (the ID of your video can be retrieved from the KMC > Content tab) on hand, and then call the `playManifest` action using the following URL: 

> `[serviceUrl]/p/[yourPartnerId]/sp/[yourPartnerId]00/playManifest/entryId/[entryId]/format/[format]/protocol/[protocol]/ks/[ks]/[paramN]/[valueN]/desiredFileName.[fileExtension]`

> Note that `/[paramN]/[valueN]/` designates any extra (optional) parameters. See below for a complete list of optional parameters. The structure for including these parameters in the url is similar to the required params, `/paramName/paramValue`. For example: `clipTo/10000` will designate chopping the video to the 10th second (clipTo is in milliseconds).
  
2.  Replace the desired **`serviceUrl`**:


| Protocol + Domain             | Description                         |
|-------------------------------|-------------------------------------|
| https://cdnapisec.kaltura.com | Secure HTTPS Request. **Recommended**. |
| http://cdnapi.kaltura.com        | Standard HTTP Request.              |

3.  Next, replace the following **required parameters**:

|    Parameter           |    Description    |
|------------------------|-------------------|
|    `[serviceUrl]`          |    The base URL to the Kaltura Server    |
|    `[yourPartnerId]`       |     Your Kaltura account publisher ID (this can be retrieved from   the Account Integration Settings page in the KMC).          |
|    `[entryId]`         |     The Id of the video or playlist entry you'd like to retrieve (playlist id is only applicable when format is HLS or DASH manifest, when playlist is requested the response is a stitched playlist as a continuous video stream).                                                                                                                                        |
|    `format`     |     See the list of available formats in the table below. This parameter is optional and defaults to `url`.                                                                      |
|    `Protocol`            |     Whether video is to be delivered over HTTP or HTTPS. See the list of available protocols below for additional options. This parameter is optional and defaults to `http`.    |
|    `ks`                  |     A valid Kaltura Session. This parameter is only required when the media entry has an Access Control or Entitlement rules that limits anonymous access to the media.                                    |
|    `fileExtension`                 |     The file extension of the video you wish to retrieve (for example, mp4 if the video flavor is an MPEG4 file, or flv if the video flavor is an FLV file).                              |

4. And set any **optional parameters**:

|    Parameter           |    Description    |
|------------------------|-------------------|
|    `seekFrom`          |    If a manifest format is used (not available in progressive download), will return a video chopped from a specific time. Specify time in MilliSeconds.    |
|    `clipTo`          |    Will chop the video to a specific duration (available in all streaming formats). Specify time in MilliSeconds.    |
|    `playbackRate`          |   Will modify the playback speed of the stream (only available in Manifest formats). Value is a float number be between 0.5 to 2 (increments of 0.01 minimum)   |
|    `flavorParamIds` / `flavorParamId`          |    The transcoding profile parameters to serve. If the requested entry was transcoded to this profile, the transcoded flavor will be returned. If manifest format is requested (e.g. HLS or DASH), multiple flavors may be included, comma separated.      |
|    `flavorIds` / `flavorId`          |    The Id of specific transcoded video flavor you wish to serve. If manifest format is requested (e.g. HLS or DASH), multiple flavors may be included, comma separated. See section below for more info about flavorId vs. flavorParamId     |
|    `tags`          |  Comma seperated list of tags. If requested, will only return flavors that are tagged with any of the specified tags.  |
|    `minBitrate`          |  Specify the minimum video flavor kbps to return in the result. Will only return flavors with higher bitrate than this value. Value is integer.  |
|    `maxBitrate`          |   Specify the maximum video flavor kbps to return in the result. Will only return flavors with lower bitrate than this value. Value is integer.   |
|    `preferredBitrate`   |  If specified, will place the video flavor that has the closest kbps value to this value at the top of the manifest. Value is integer.  |
|    `referrer`          |  Base64 encoded URL that designates the referrer asking for this video. Used for Analytics and Access Control Domain Restriction. Value must be Base64 encoded.    |
|    `playbackContext`          |  Used for Analytics, this String will be logged with the playback action per the user id (specified in the KS) and requested video entry id.    | 
|    `storageId`          |   The id of the Remote Storage Profile to use. Only available if a Remote Storage profile is configured on this account that permits delivery access.   |
|    `responseFormat`          |   Overrides the default format of the returned manifest file (e.g. if `json` is set for `responseFormat` with `applehttp` in `format`, the response will be a json representation of the HLS manifest). Possible values are: `f4m`, `f4mv2`, `smil`, `m3u8`, `jsonp`, `json`, `redirect` (redirect is default, and will return the standard file format for the chosen manifest format)  |


### Available Playback Formats  


| Format            | Description                                                                                          |
|-------------------|------------------------------------------------------------------------------------------------------|
| `mpegdash`          | **MPEG-DASH** Streaming.                                                                                 |
| `applehttp`         | **HLS** - Apple HTTP Live Streaming.                                                               |
| `url`               | **Progressive Download**.                                                                                |
| `hds`               | Adobe HTTP Dynamic Streaming. Not available for all Kaltura accounts.                                |
| `rtmp`              | Real Time Messaging Protocol (RTMP). Recommended only for Live, or special use cases.                |
| `rtsp`              | Real Time Streaming Protocol (RTSP). For legacy devices, such as older Blackberry and Nokia phones.  |
| `hdnetworkmanifest` | Akamai HDS delivery. Available only for accounts with Akamai delivery.                               |
| `hdnetwork`         | Akamai Proprietary Delivery Protocol. Available only for accounts with Akamai delivery. (deprecated) |
| `sl` / `multicast_silverlight`        | Microsoft Silverlight delivery. Available only for accounts with legacy Silverlight or Multicast profiles. |


### Available Protocol Parameters  

| Protocol                 | Description                                                                                                         |
|-------------------------|---------------------------------------------------------------------------------------------------------------------|
| `http`                    | http Redirect and streaming URLs make use of the HTTP protocol. (Default)                                           |
| `https`                   | https  Redirect and streaming URLs make use of the HTTPS protocol.                                                  |
| `rtmp` | (RTMP based streaming only) Streaming Server Base URL make use of the specified protocol (RTMP, RTMPE, RTMPT, or RTMPTE). |


### Examples  

* An HLS stream clipped from second 1 to second 11: `https://cdnapisec.kaltura.com/p/811441/sp/81144100/playManifest/entryId/0_khge3cfm/format/applehttp/protocol/https/seekFrom/10000/clipTo/11000`
* A Progressive Download mp4 file clipped to 2 seconds: `https://cdnapisec.kaltura.com/p/811441/sp/81144100/playManifest/entryId/0_khge3cfm/format/url/protocol/https/clipTo/2000/name/2SecClip.mp4`


>Note: The playManifest API does not require a KS unless the media entries were specifically setup with Access Control or Entitlements rules to limit anonymous access to the media. If the media entry was assigned with Access Control or Entitlements, a KS (Kaltura Session) must be specified when calling the playManifest URL.


### What is the Distinction between flavorParamId and flavorId?  

* **flavorParamId** represents the transcoding parameters that are used to generate a flavor. For example, all HD flavors in an account will usually have the same flavorParamId (across different entries)
* **flavorId** is the identifier of a specific video file, for example, the HD flavor will have a different flavorId for each entry that has an HD flavor.

#### When to You use each Flavor?  

* If the flavorIds for the specific entry are known (e.g., the application is doing a flavorAsset.list with entryIdEqual), then use flavorId/flavorIds.
* If the flavorIds are not known (e.g., the application would like to build a URL to the HD flavor, but does not want to perform flavorAsset.list) use flavorParamId/flavorParamIds.


### Downloading a Video File

It is important to note that Kaltura entries can be set for private or protected modes, where access is only allowed when providing a valid admin [Kaltura Session](/api-docs/VPaaS-API-Getting-Started/how-to-create-kaltura-session.html). 

For best practice, to retrieve a **download** URL (instead of streaming manifest) for a video entry, use the following steps:

1.  Locate the ID of the desired video flavor (see below Video Flavor Id).
2.  Call the `flavorAsset.geturl` API action.

Below is a PHP code sample for retrieving the download URL of a web-playable flavor for a desired entry ID:

```php
//Client library configuration and instantiation...
 
//when creating the Kaltura Session it is important to specify that this KS should bypass entitlements restrictions:
$ks = $client->session->start($secret, $userId, KalturaSessionType::ADMIN, $partnerId, 86400, 'disableentitlement');
$client->setKs($ks);
 
$client->startMultiRequest();
$entryId = '1_u7aj9kasw'; //replace this with your entry Id
$client->flavorAsset->getwebplayablebyentryid($entryId);
$req1ResultFlavorId = '{1:result:0:id}'; //get the first flavor from the result of getwebplayablebyentryid
$client->flavorAsset->geturl($req1ResultFlavorId); //this action will return a valid download URL
$multiRequestResults = $client->doMultiRequest();
$downloadUrl = $multiRequestResults[1];
echo 'The entry download URL is: '.$downloadUrl;
```

### Video Flavor ID  

The VideoFlavorId parameter determines which video flavor the API will return as download. This parameter has various options, depending on the Kaltura server deployment and publisher account.

The following lists few of the conventional flavor IDs:

>Note: Only flavor id 0 (zero) is static and the same across all Kaltura editions and accounts. The following list are common flavor Ids on the Kaltura VPaaS Cloud edition, but note flavors change and upgraded often (improved quality, new codecs, etc.) - Use this list for example purposes, but make sure to check your KMC > Settings > Transcoding Settings tab for the ids of your transcoding profile flavors.

* The original uploaded video (before transcoding) = 0
* iPhone / Android (mp4) = 301951
* iPad (mp4) = 301971
* Nokia/Blackberry (3gp) = 301991
* Other devices (mp4) = 301961

The correct flavor IDs (per account and Kaltura edition) can be retrieved using one of the following ways:

1. Visiting the KMC Settings > [Transcoding Profiles](http://knowledge.kaltura.com/faq/how-create-transcoding-profile).
2. Making an API call to the [ConversionProfile.list action](https://developer.kaltura.com/api-docs/#/conversionProfile.list).

### Retrieving Streaming URL for Mobile Applications  

To retrieve streaming URL for mobile applications, use the following guidelines:

* For Apple iPad devices – get all the flavors (marked ready) that have the tag 'ipadnew' and build the following URL:

```javascript
serviceUrl + '/p/' + partnerId + '/sp/' + partnerId + '00/playManifest/entryId/' + entryId + '/flavorIds/' + flavorIds.join(',') + '/format/applehttp/protocol/http/a.m3u8?ks=' + ks + '&referrer=' + base64_encode(application_name)
```

* For Apple iPhone devices – get all the flavors (marked ready) that have the tag 'iphonenew' tag and build the following URL:

```javascript
serviceUrl + '/p/' + partnerId + '/sp/' + partnerId + '00/playManifest/entryId/' + entryId + '/flavorIds/' + flavorIds.join(',') + '/format/applehttp/protocol/http/a.m3u8?ks=' + ks + '&referrer=' + base64_encode(application_name)
```

* For Android devices that support HLS – get all the flavors (marked ready) that have the tag 'iphonenew' tag (excluding audio-only flavors where width, height & framerate fields equal to zero) and build the following URL:

```javascript
serviceUrl + '/p/' + partnerId + '/sp/' + partnerId + '00/playManifest/entryId/' + entryId + '/flavorIds/' + flavorIds.join(',') + '/format/applehttp/protocol/http/a.m3u8?ks=' + ks + '&referrer=' + base64_encode(application_name)
```

* For Android devices that do not support HLS – get a single video flavor that has the 'iPhoneNew' tag and build the following URL:

```javascript
serviceUrl + '/p/' + partnerId + '/sp/' + partnerId + '00/playManifest/entryId/' + entryId + '/flavorId/' + flavorId + '/format/url/protocol/http/a.mp4?ks=' + ks + '&referrer=' + base64_encode(application_name)
```

