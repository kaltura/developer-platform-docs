# Downloading a Video File

It is important to note that Kaltura entries can be set for private or protected modes, where access is only allowed when providing a valid admin [Kaltura Session](/api-docs/VPaaS-API-Getting-Started/how-to-create-kaltura-session.html). 

For best practice, to retrieve a **download** URL (instead of streaming manifest) for a video entry, use the following steps:

1.  Locate the ID of the desired video flavor (see below Video Flavor Id).
2.  Call the `flavorAsset.geturl` API action.

Below is a PHP code sample for retrieving the download URL of a web-playable flavor for a desired entry ID:

```php
<?php
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

