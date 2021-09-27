# Syndication

Kaltura offers a powerful UI to create, customize and edit [syndication](https://knowledge.kaltura.com/help/content-distribution-and-syndication) feeds. However, you may also want to take advantage of the API to programmatically take advantage of the syndication system.

## Getting Feed URL

For example, to get the feed URL of one of your existing syndication feeds, you first need to get the `feedId` either by calling [syndicationFeed.list](https://developer.kaltura.com/console/service/syndicationFeed/action/list) or by manually obtaining it from your [KMC](https://kmc.kaltura.com/index.php/kmcng/login)

Then call [syndicationFeed.get](https://developer.kaltura.com/console/service/syndicationFeed/action/get) with your `feedId` which will return a json object like:

```json
{
  "adultContent": "No",
  "id": "1_jaqeddse",
  "feedUrl": "http://www.kaltura.com/api_v3/getFeed.php?partnerId=12345&feedId=1_jaqeddse",
  "partnerId": 12345,
  "playlistId": "1_nx1irfw8",
  "name": "lkjlkj",
  "status": 1,
  "type": 1,
  "landingPage": "http://www.kaltura.com",
  "createdAt": 1628566723,
  "allowEmbed": true,
  "playerUiconfId": 48261253,
  "flavorParamId": 0,
  "transcodeExistingContent": false,
  "addToDefaultConversionProfile": true,
  "enforceEntitlement": true,
  "updatedAt": 1628566723,
  "useCategoryEntries": false,
  "feedContentTypeHeader": "text/xml; charset=utf-8",
  "objectType": "KalturaGoogleVideoSyndicationFeed"
}
```

From which you can obtain the `feedUrl` from.

## Updating a custom XSLT Feed

Kaltura provides the ability to supply your own custom [XSLT feed](https://knowledge.kaltura.com/help/content-distribution-and-syndication#flexible-feed-format) 

Using the API you could update the XSLT via code whenever needed by calling [syndicationFeed.update](https://developer.kaltura.com/api-docs/service/syndicationFeed/action/update)  selecting the `KalturaGenericXsltSyndicationFeed`  and updating the `xslt` field.

![xslt](img/xslt.png)



### See More

Explore all of the [Syndication Feed API calls](https://developer.kaltura.com/console/service/syndicationFeed)

- [syndicationFeed.add](https://developer.kaltura.com/console/service/syndicationFeed/action/add)
- [syndicationFeed.delete](https://developer.kaltura.com/console/service/syndicationFeed/action/delete)
- [syndicationFeed.get](https://developer.kaltura.com/console/service/syndicationFeed/action/get)
- [syndicationFeed.getEntryCount](https://developer.kaltura.com/console/service/syndicationFeed/action/getEntryCount)
- [syndicationFeed.list](https://developer.kaltura.com/console/service/syndicationFeed/action/list)
- [syndicationFeed.requestConversion](https://developer.kaltura.com/console/service/syndicationFeed/action/requestConversion)
- [syndicationFeed.update](https://developer.kaltura.com/console/service/syndicationFeed/action/update)

