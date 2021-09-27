# Kaltura Enrichment Services API

Kaltura has a vast selection of [enrichment services](https://corp.kaltura.com/video-content-management-system/reach-automatic-captioning/) available. Please contact your account manager at EMAIL to activate the services for your account. These services are also available via the Kaltura API.

To understand the kinds of services, and user experience flow surround these services you can access them under "Captions & Enrich" in the [KMC](https://kmc.kaltura.com/index.php/kmcng/login)

<img src="img/enrich_meta.png" alt="enrich_meta" style="zoom:20%;" />

Which opens to the enrichment services screen:

<img src="img/enrichment.png" alt="enrichment" style="zoom:67%;" />

This example will show you how to initiate a machine based caption request:

The main API call will be [entryVendorTask.add](https://developer.kaltura.com/console/service/entryVendorTask/action/add) 

You will need to collect some necessary information to submit to the above call. 

First, you will need to get a reachProfileId from [reachProfile.list](https://developer.kaltura.com/api-docs/service/reachProfile/action/list) it will be the `id` field:

```json
{
  "objects": [
    {
      "id": 80801,
      "name": "VPaaS Developer Account Trial Profile",
      "partnerId": 12345,
      "createdAt": 1600381665,
      "updatedAt": 1626968708,
      "status": 2,
```


Next you will need a `catalogItemId` this is supplied from [vendorCatalogItem.list](https://developer.kaltura.com/console/service/vendorCatalogItem/action/list) this will be the `id` field from a request:

```json
  "objects": [
    {
      "enableSpeakerId": false,
      "fixedPriceAddons": 0,
      "id": 852,
      "vendorPartnerId": 2413722,
      "name": "Verbit-ASR-English-unlimited",
      "systemName": "Verbit-ASR-English-unlimited",
      "createdAt": 1531737157,
      "updatedAt": 1624879011,
```

Using the `KalturaCatalogItemAdvancedFilter` in a [vendorCatalogItem.list](https://developer.kaltura.com/console/service/vendorCatalogItem/action/list) query will allow you to programmatically refine the `vendorCatalogItem` by such services as MACHINE vs. HUMAN, `sourceLanguage` `sourceFeature` `turnAroundTime` and more:

```bash
curl -X POST https://www.kaltura.com/api_v3/service/reach_vendorcatalogitem/action/list \
    -d "ks=$KALTURA_SESSION" \
    -d "filter[advancedSearch][objectType]=KalturaCatalogItemAdvancedFilter" \
    -d "filter[advancedSearch][serviceTypeEqual]=2" \
    -d "filter[advancedSearch][serviceFeatureEqual]=1" \
    -d "filter[advancedSearch][sourceLanguageEqual]=English" \
    -d "filter[serviceTypeEqual]=2" \
    -d "filter[objectType]=KalturaVendorCaptionsCatalogItemFilter" \
    -d "filter[sourceLanguageEqual]=English"
```


## Building a query:

Now you have all the requirements to build an enrichment query using [entryVendorTask.add](https://developer.kaltura.com/console/service/entryVendorTask/action/add) the final necessary parameter will be an `entryId` for the piece of content that you want to perform enrichment services on:

```bash
curl -X POST https://www.kaltura.com/api_v3/service/reach_entryvendortask/action/add \
    -d "ks=$KALTURA_SESSION" \
    -d "entryVendorTask[reachProfileId]=80801" \
    -d "entryVendorTask[catalogItemId]=802" \
    -d "entryVendorTask[entryId]=12345" \
    -d "entryVendorTask[objectType]=KalturaEntryVendorTask"
```

While the task is being completed, you may want to see a list of all of your tasks via: [entryVendorTask.list](https://developer.kaltura.com/console/service/entryVendorTask/action/list)

For a full list of API calls related to the creation/modification and user experience flow for entryVendorTask refer to 
https://developer.kaltura.com/console/service/entryVendorTask

## See Also:

https://developer.kaltura.com/console/service/entryVendorTask

https://developer.kaltura.com/api-docs/service/vendorCatalogItem

https://developer.kaltura.com/api-docs/service/reachProfile