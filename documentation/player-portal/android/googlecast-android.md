---
layout: page
title: Google Cast Android
weight: 110
---

# CAST with V3 CAF Receiver

The guide below walks you through casting with the [Cast Applications Framework V3](https://developers.google.com/cast/docs/caf_receiver/). You need to first configure the receiver before continuing with the steps below. 

## Setting up the Cast Builder: 

{% highlight java %}
// note that not all parameters are required. 
CAFCastBuilder ovpV3CastBuilder =  new KalturaCastBuilder()
.setMediaEntryId(converterOvpV3Cast.getEntryId())
.setKs(converterOvpV3Cast.getKs())
.setStreamType(converterOvpV3Cast.isLive() ? CAFCastBuilder.StreamType.LIVE :  CAFCastBuilder.StreamType.VOD)
.setDefaultTextLangaugeCode(converterOvpV3Cast.getTextLanguage())
.setDefaultAudioLangaugeCode(converterOvpV3Cast.getAudioLanguage());

if (!TextUtils.isEmpty(converterOvpV3Cast.getVastAdTagUrl()))   
    {
        ovpV3CastBuilder.setAdsConfig(createAdsConfigVast(converterOvpV3Cast.getVastAdTagUrl()));
    } 
else if (!TextUtils.isEmpty(converterOvpV3Cast.getVmapAdTagUrl()))
    {
        ovpV3CastBuilder.setAdsConfig(createAdsConfigVmap(converterOvpV3Cast.getVmapAdTagUrl()));
    }
MediaInfo mediaInfo = ovpCastBuilder.build();
{% endhighlight %}

## Adding Ads to the Builder using setAdsConfig:

## VMAP
{% highlight java %}
public AdsConfig createAdsConfigVmap(String adTagUrl) {
    return MediaInfoUtils.createAdsConfigVmap(adTagUrl);
}
{% endhighlight %}

## VAST
{% highlight java %}
public AdsConfig createAdsConfigVast(String adTagUrl) {
    return MediaInfoUtils.createAdsConfigVastInPosition(0, adTagUrl);
}
{% endhighlight %}

Both Builder APIs support setting your own customized metadata as exposed in the Cast SDK using:

```cafCastBuilder.setMetadata(mediaMetadata);```

By default, however, it is not required, since these settings are already configured internally

## Loading the MediaInfo

Once the app has a MediaInfo Object, it can call the Cast API to load this mediaInfo: 

{% highlight java %}
PendingResult<RemoteMediaClient.MediaChannelResult> pendingResult = null;
MediaLoadOptions loadOptions = new MediaLoadOptions.Builder().setAutoplay(true).setPlayPosition(mPlaybackStartPosition).build();
pendingResult = remoteMediaClient.load(mediaInfo,loadOptions);
pendingResult.setResultCallback(new ResultCallback<RemoteMediaClient.MediaChannelResult>() {

@Override
public void onResult(@NonNull RemoteMediaClient.MediaChannelResult mediaChannelResult) {

    JSONObject customData = mediaChannelResult.getCustomData();
    if (customData != null) {
        log.v("loadMediaInfo. customData = " + customData.toString());
    } else {
        log.v("loadMediaInfo. customData == null");
    }
}
});
}

PendingResult<RemoteMediaClient.MediaChannelResult> pendingResult = null;
MediaLoadOptions loadOptions = new MediaLoadOptions.Builder().setAutoplay(true).setPlayPosition(mPlaybackStartPosition).build();
pendingResult = remoteMediaClient.load(mediaInfo,loadOptions);
pendingResult.setResultCallback(new ResultCallback<RemoteMediaClient.MediaChannelResult>() {

@Override
public void onResult(@NonNull RemoteMediaClient.MediaChannelResult mediaChannelResult) {

    JSONObject customData = mediaChannelResult.getCustomData();
    if (customData != null) {
        log.v("loadMediaInfo. customData = " + customData.toString());
    } else {
        log.v("loadMediaInfo. customData == null");
    }
}
});
}   
{% endhighlight %}

### Start Position 

- The start position value should be given in milliseconds
- For VOD and LIVE_DVR you can pass in any value that a is valid position in the stream
- For LIVE, the given start position must be -1 so that the Cast player will know to begin the media from Live Edge

## How to Register/Unregister to Custom Events

{% highlight java %}
try {
    getCastSession().setMessageReceivedCallbacks(
            adsChannel.getNamespace(),
            adsChannel);
} catch (IOException e) {
        Log.d(TAG,  "Exception while creating channel");
    return;
}

try {
    getCastSession().removeMessageReceivedCallbacks(adsChannel.getNamespace());
} catch (IOException e) {
    e.printStackTrace();
}
{% endhighlight %}

## Receiving Ad Events 

{% highlight java %}
class AdsChannel implements Cast.MessageReceivedCallback {
    public String getNamespace() {
        return "urn:x-cast:com.kaltura.cast.playkit";
    }
    @Override
    public void onMessageReceived(CastDevice castDevice, String namespace, String message) {
        //{"type":"event","event":"adbreakstart","payload":{"adBreak":{"type":"preroll","position":0,"numAds":1}}}
        //{"type":"event","event":"adloaded","payload":{"ad":{"id":"GENERATED:0","url":"https://redirector.gvt1.com/videoplayback/id/5bad011a1282b323/itag/15/source/gfp_video_ads/requiressl/yes/acao/yes/mime/video%2Fmp4/ctier/L/ip/0.0.0.0/ipbits/0/expire/1540312045/sparams/ip,ipbits,expire,id,itag,source,requiressl,acao,mime,ctier/signature/B0C65CFC421ABB433C55D42BD833444B652AB66F.5305D980B5A87E86030908EBACC4C8E5D39C1050/key/ck2/file/file.mp4","contentType":"video/mp4","title":"External NCA1C1L1 Preroll","position":1,"duration":10,"clickThroughUrl":"https://pubads.g.doubleclick.net/pcs/click?xai=AKAOjsskuczQERjZ_IVOvH_LCehqzMQv_agXXw4iVAF1rOt7NO5EGaZsuA4m8icemkWAHDYvr-sUidNJ7eCA6KPU4aNA1d6VQ8MMQXzoMY07ZADCGNWqujJAlOc0H6SNuyngWMKEgRtEqHmYnY4DuJ47QuU4sqE93DUzr5CVBRXLUTAsjgnKQLJpVVu-oOIhBAuWFyEOjyGGkiX6tNcjwUJq2GaJ_gEg3ci_QPLy4WgVAU7W1-5Ef7NmIPuYanT9JTqtt9TcMZ1yRN4jm6A-Awqilthh6phenFscOG4&sig=Cg0ArKJSzCT6OKUAhcpk&adurl=https://developers.google.com/interactive-media-ads/docs/vastinspector_dual","linear":true,"skippable":false}}}
        //{"type":"event","event":"admanifestloaded","payload":{"adBreaksPosition":[0,15,-1]}}
        //{"type":"event","event":"adpaused"}
        //{"type":"event","event":"adresumed"}
        //{"type":"event","event":"adstarted"}
        //{"type":"event","event":"adprogress","payload":{"adProgress":{"currentTime":0,"duration":10}}}
        //{"type":"event","event":"adprogress","payload":{"adProgress":{"currentTime":6.863323,"duration":10}}}
        //{"type":"event","event":"adfirstquartile"}
        //{"type":"event","event":"admidpoint"}
        //{"type":"event","event":"adthirdquartile"}
        //{"type":"event","event":"adcompleted"}
        //{"type":"event","event":"adbreakend"}
        Log.d(TAG, "onMessageReceived: " + message);
        if (!TextUtils.isEmpty(message)) {
            try {
                JSONObject jsonObj = new JSONObject(message);
                if (jsonObj != null && jsonObj.has("type") && jsonObj.has("event")) {
                    Log.d(TAG, "type = " + jsonObj.getString("type"));
                    Log.d(TAG, "event: " + jsonObj.getString("event"));
                    if ("adcanskip".equals(jsonObj.getString("event")));{
                        // ==>here you can know you can enable skip buttonh that calles -  sendSkipAdMessage();
                    }
                    if(jsonObj.has("payload")) {
                        JSONObject payloadJson = jsonObj.getJSONObject("payload");
                        if (payloadJson.has("adProgress")) {
                            JSONObject adProgressJson = payloadJson.getJSONObject("adProgress");
                            Log.d(TAG, "adProgress currentTime = "    + adProgressJson.getDouble("currentTime"));
                            Log.d(TAG, "XXX adProgress duration: "        + adProgressJson.getDouble("duration"));
                        }
                        if (payloadJson.has("adBreak")) {
                            JSONObject adBreakJson = payloadJson.getJSONObject("adBreak");
                            Log.d(TAG, "adBreak type = "    + adBreakJson.getString("type"));
                            Log.d(TAG, "adBreak position: " + adBreakJson.getDouble("position"));
                            Log.d(TAG, "adBreak numAds: "   + adBreakJson.getInt("numAds"));
                        }
                        if (payloadJson.has("ad")) {
                            JSONObject adJson = payloadJson.getJSONObject("ad");
                            Log.d(TAG, "ad id = "    + adJson.getString("id"));
                            Log.d(TAG, "ad url: "    + adJson.getString("url"));
                            Log.d(TAG, "ad contentType: "   + adJson.getString("contentType"));
                            Log.d(TAG, "ad title: "         + adJson.getString("title"));
                            Log.d(TAG, "ad position: "      + adJson.getDouble("position"));
                            Log.d(TAG, "ad duration: "      + adJson.getDouble("duration"));
                            Log.d(TAG, "ad clickThroughUrl: "   + adJson.getString("clickThroughUrl"));
                            Log.d(TAG, "ad linear: "        + adJson.getBoolean("linear"));
                            Log.d(TAG, "ad skippable: "     + adJson.getBoolean("skippable"));
                        }
                        if (payloadJson.has("adBreaksPosition")) {
                            JSONArray adBreaksPositionArray = payloadJson.getJSONArray("adBreaksPosition");
                            for (int i = 0; i < adBreaksPositionArray.length(); i++) {
                                Log.d(TAG, "adBreaksPosition : " + adBreaksPositionArray.get(i));
                            }
                        }
                    }
                }
            } catch (JSONException e) {
                Log.e(TAG, "Error " +  e.getMessage());
            }
        }
    }
}
{% endhighlight %}

## Sending Skip Ad Command 

{% highlight java %}
    private void sendSkipAdMessage() {

        String skipAdMessage = "{\n" +
                "  \"type\": \"action\",\n" +
                "  \"action\": \"skipAd\"\n" +
                "}";

        if (adsChannel != null) {
            try {
                getCastSession().sendMessage(adsChannel.getNamespace(), skipAdMessage)
                        .setResultCallback(
                                new ResultCallback<Status>() {
                                    @Override
                                    public void onResult(Status result) {
                                        if (!result.isSuccess()) {
                                            Log.e(TAG, "Sending message failed");
                                        }
                                    }
                                });
            } catch (Exception e) {
                Log.e(TAG, "Exception while sending message", e);
            }
        }
    }
{% endhighlight %}

### Sample

[Cast Sample](https://github.com/kaltura/kaltura-player-android-samples/tree/release/v4.4.0/AdvancedSamples/ChromecastCAFSample)

