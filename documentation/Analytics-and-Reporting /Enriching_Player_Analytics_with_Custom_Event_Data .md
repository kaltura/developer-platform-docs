---
layout: page
title: Enriching Player Analytics with Custom Event Data
weight: 110
---

# Enriching Player Analytics with Custom Event Data

While Kaltura [collects](https://developer.kaltura.com/api-docs/Video-Analytics-and-Insights/media-analytics.html) most of the highly requested and common [analytics](https://developer.kaltura.com/api-docs/Video-Analytics-and-Insights/media-analytics.html) data points, sometimes you may require information that is not already collected. Kaltura provides a convenient way for you to collect any kind of data you want with the `customVar` feature. 

## Configuring the player

Kaltura players accept a `customVar` argument through the [KAVA](https://github.com/kaltura/playkit-js-kava) analytics framework. These are named `customVar1`, `customVar2` and `customVar3`. 

### Configuring Javascript Player

First check in the [KMC](https://kmc.kaltura.com/index.php/kmcng/studio/v3) to make sure the KAVA plugin is enabled on your [player](https://developer.kaltura.com/player/web/getting-started-web): it is enabled by default. 

<img src="img/kmc_kava.png" alt="kmc_kava" style="zoom:65%;" />

Next configure the player to accept customVar1 via KAVA:

```javascript
     var player = KalturaPlayer.setup({
                targetId: "kaltura-player",
                provider: {
                    partnerId: 12345,
                    uiConfId: 678910
                },
                plugins: {
                    kava: {
                        customVar1: "hello"
                    }
                }
            });
```

### Configuring iOS Player

If you refer to the [iOS analytics](https://developer.kaltura.com/player/ios/analytics-plugins-ios) documentation, you will notice the `createKavaConfig` method below accepts `customVar[123]`

```swift
func createKavaConfig() -> KavaPluginConfig {
    return KavaPluginConfig(partnerId: PARTNER_ID, entryId: entryId, ks: ks, playbackContext: nil, referrer: nil, applicationVersion: nil, playlistId: nil, customVar1: nil, customVar2: nil, customVar3: nil)
}
```



### Configuring Android Player

Refer to the [android player setup page](https://developer.kaltura.com/player/android/getting-started-android) which also links to the [Android KAVA demo](https://github.com/kaltura/playkit-android-kava) 

```
            //Set your configurations.
            KavaAnalyticsConfig kavaConfig = new KavaAnalyticsConfig()
                    .setPartnerId(123456) //Your partnerId. Mandatory field!
                    .setBaseUrl("yourBaseUrl")
                    .setUiConfId(123456)
                    .setKs("your_ks")
                    .setCustomVar1("customVar1")
                    .setCustomVar2("customVar2")
                    .setCustomVar3("customVar3");
```



## Querying Analytics for customVar

Now that you have supplied `customVar` to your player, and users are interacting with your players, you will want to see how your `customVar` data is performing. 

Using the [Kaltura analytics API](https://developer.kaltura.com/api-docs/Video-Analytics-and-Insights/media-analytics.html) you will be able to create different kinds of reports for your customVar. 

### TOP_CONTENT report

Using the [report.getTable](https://developer.kaltura.com/console/service/report/action/getTable) API call, as shown below, a `reportType` of `TOP_CONTENT` is produced and it allows you to filter by string via the `customVar1In` field of `reportInputFilter` 

<img src="img/customVar_topContent.png" alt="customVar_topContent" style="zoom:40%;" />

Which will return a tab-delimited report like:

```json
{
  "header": "object_id,entry_name,count_plays,sum_time_viewed,avg_time_viewed,count_loads,load_play_ratio,avg_view_drop_off,unique_known_users",
  "data": "1_z81cf9,TAKE2_EDIT,6,1,1,9,1,1,1;
           1_em9nua,inside    ,1,0,0,1,1,0,1;",
  "totalCount": 2,
  "objectType": "KalturaReportTable"
}
```

As you can see, a `;` delimited list of all the entryIds that matched "hello" were returned in the `data` object.



### CUSTOM_VAR report

If you wanted to query all of the customVar data for your account, this is also possible using a `reportType` of `TOP_CUSTOM_VAR1`, `TOP_CUSTOM_VAR2`, or `TOP_CUSTOM_VAR3` 

<img src="img/TOP_CUSTOMVAR_REPORT.png" alt="TOP_CUSTOMVAR_REPORT" style="zoom:40%;" />

Which returns the following result:

```json
{
  "header": "custom_var1,count_plays,sum_time_viewed,avg_time_viewed,count_loads,load_play_ratio,avg_view_drop_off",
  "data": "hello,6,0.533,0.088888,9,1,0.6;                				
  	       world,1,0.066,0.066666,1,1,0.5;",
  "totalCount": 2,
  "objectType": "KalturaReportTable"
}
```

As you see the **"hello"** and **"world"** are the two `customVar1` that have been used with this account during the specified time period. 
