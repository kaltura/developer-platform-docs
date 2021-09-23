---
layout: page
title: Transcoding
weight: 202
---

* Kaltura's cloud transcoding micro-services and tools are designed to manage encoding workflows at any scale and quality requirements - for the web, broadcast, studio, or secure internal applications with sensitive content. 
* Architected to handle any file size over large volumes - converting any input format of uploaded video, audio, image and even documents into a variety of flavors (transcoded output renditions).
* Built to be deployed on any infrastructure - on premises or public cloud. 
* Kaltura's transcoding decision layer engine supports more than 60 video and image formats as well as 140 video and audio codecs.
* New devices, cameras and input sources are introduced to the market frequently - Kaltura Media Transcoding Services provide always up-to-date transcoding services that are optimized for the latest formats, codecs and standards.

## Conversion Profiles and Flavor Assets  

To make your video accessible and play on any device, Kaltura provides robust API for media transcoding. When transcoding your video, you can control a wide range of parameters, including; output file type, bit-rate, GOP size (keyframe-frequency), frame-rate, frame dimensions, and much more. You can use Kaltura's transcoding services to prepare transcoded videos for optimized playback, download, editing, broadcasting, archive and more.

Flavors are versions of an uploaded source video that was transcoded by Kaltura. You can generate multiple flavors per uploaded file. There is no limit to the number of flavors you can define and use in Kaltura. Each flavor is a single output video file on its own. Flavors are represented in Kaltura by the [flavorAsset service](https://developer.kaltura.com/api-docs/#/flavorAsset).  
For a list of all the available parameters and options you can set for your transcoded flavors see: [KalturaFlavorParams](https://developer.kaltura.com/api-docs/#/KalturaFlavorParams).

Your Kaltura account comes with a default set of flavors preconfigured to seamlessly support any device or browser your users are likely to use. You can choose to enable or disable any of them at any time. To add and configure new flavors to your account use the [flavorParams](http://developer.kaltura.com/api-docs/#/flavorParams) service.

The "source flavor", is the original file that was uploaded to Kaltura. The source flavor represents the highest quality available for that specific video entry. Normally, you would store your source file in Kaltura to continue to generate new flavors from it, cut thumbnails and more. It is also possible to delete the source flavor and mark any of the transcoded flavors as the new source by calling the [flavorAsset.setAsSource action](https://developer.kaltura.com/api-docs/#/flavorAsset.setAsSource).

When a video is uploaded to Kaltura, the video is associated with a [conversionProfile](https://developer.kaltura.com/api-docs/#/conversionProfile), also known as a Transcoding Profile. A Conversion Profile may be comprised of a single or multiple flavors. For each upload session, you can select the Conversion Profile you'd like apply with the uploaded videos. You can also set a default Conversion Profile to be executed automatically when videos are uploaded to your account.  



## Add a New Conversion Profile

To add a conversion profile, call the [conversionProfile.add](https://developer.kaltura.com/api-docs/#/conversionProfile.add) API action:

```php
<?php 
require_once('lib/KalturaClient.php'); 
$config = new KalturaConfiguration($partnerId); 
$config->serviceUrl = 'https://www.kaltura.com/'; 
$client = new KalturaClient($config); 
$client->setKs('AddYourKS'); 
$conversionProfile = new KalturaConversionProfile(); 
$conversionProfile->status = KalturaConversionProfileStatus::ENABLED; 
$conversionProfile->name = 'YourConversionProfileName'; 
$conversionProfile->isDefault = KalturaNullableBoolean::TRUE_VALUE; 
$results = $client-> conversionProfile ->add($conversionProfile);
```

## Add New Flavor Params

> Note: Kaltura.com SaaS users - Please contact your Kaltura Account Manager to add new flavor params to your account. Configuration of the transcoding layer requires specialized encoding expertise.
>  

To add flavor params, call the [flavorParams.add](https://developer.kaltura.com/api-docs/#/flavorParams.add) API action:

```php
<?php
require_once('lib/KalturaClient.php');
$config = new KalturaConfiguration($partnerId);
$config->serviceUrl = 'https://www.kaltura.com/';
$client = new KalturaClient($config);
$client->setKs('AddYourKS');
$flavorParams = new KalturaFlavorParams();
$flavorParams->name = 'YourflavorParamsName';
$flavorParams->systemName = 'YourflavorParamssystemName';
$flavorParams->description = 'YourflavorParamsDescription';
$flavorParams->tags = 'YourflavorParamsTag1, YourflavorParamsTag2';
$flavorParams->videoCodec = KalturaVideoCodec::FLV;
$results = $client->flavorParams->add($flavorParams);
```

## Create a New Flavor Asset for an Existing Entry

To create a new flavor asset for an existing entry, call the [flavorAsset.convert](https://developer.kaltura.com/api-docs/#/flavorAsset.convert) API action.

```php
<?php require_once('lib/KalturaClient.php'); 
$config = new KalturaConfiguration($partnerId); 
$config->serviceUrl = 'https://www.kaltura.com/'; 
$client = new KalturaClient($config); 
$client->setKs('AddYourKS'); 
$entryId = '1_entryIdString'; 
$flavorParamsId = 11111; 
$results = $client->flavorAsset->convert($entryId, $flavorParamsId); 
```

## Default Account Conversion Profiles   

There are three transcoding profiles that are automatically created for new accounts:
* Default - The flavors included in the default transcoding profile of the account. 
* Source Only - Does not execute transcoding for the uploaded file. 
* All Flavors - Transcodes uploaded files into all of the flavors defined in the account by default.

## Default Account Flavors   

There are nine flavors that are defined automatically for every new account. These flavors are optimized for the delivery of video across all devices and browsers to ensure that you can reach your users on any device they use without having to manually configure the flavors yourself.  

The default flavors include:

| ID     	| Name                             	| Description                                 	|
|:-------	|:---------------------------------	|:--------------------------------------------	|
| 0      	| Source                           	| The original file that was uploaded         	|
| 301991 	| Mobile (3GP)                     	| Support Nokia and Blackberry legacy devices 	|
| 487041 	| Basic/Small - WEB/MBL (H264/400) 	| Optimized mp4 - modern devices - lowres     	|
| 487051 	| Basic/Small - WEB/MBL (H264/600) 	| Optimized mp4 - modern devices - lowres     	|
| 487061 	| SD/Small - WEB/MBL (H264/900)    	| Optimized mp4 - modern devices - standard   	|
| 487071 	| SD/Large - WEB/MBL (H264/1500)   	| Optimized mp4 - modern devices - 720p       	|
| 487081 	| HD/720 - WEB (H264/2500)         	| Optimized mp4 - modern devices - 720p       	|
| 487091 	| HD/1080 - WEB (H264/4000)        	| Optimized mp4 - modern devices - 1080p      	|
| 487111 	| WebM                             	| For devices not supporting h264             	|


> Read more in the article [Kaltura Media Transcoding Services and Technology](http://knowledge.kaltura.com/kaltura-media-transcoding-services-and-technology#transcoding).

## How is Transcoding Usage Measured?

Transcoding usage is defined as the volume in MB of transcoded assets, which are the output of transcoding. Transcoding usage is measured and billed one time per transcode. 

Kaltura measures and bills only for output transcoding usage; the input file is not counted as transcoding usage.  
Failed transcoding jobs are not counted or billed. 

You can track your transcoding usage on the [Usage Dashboard](https://kmc.kaltura.com/index.php/kmc/kmc4#usageDashboard) in the Kaltura Management Console.

## See Also

[flavorAsset](https://developer.kaltura.com/api-docs/service/flavorAsset)

[flavorParams](https://developer.kaltura.com/api-docs/service/flavorParams)

[flavorParamsOutput](https://developer.kaltura.com/api-docs/service/flavorParamsOutput)

[conversionProfile](https://developer.kaltura.com/api-docs/service/conversionProfile)

[conversionProfileAssetParams](https://developer.kaltura.com/api-docs/service/conversionProfileAssetParams)

[mediaInfo](https://developer.kaltura.com/api-docs/service/mediaInfo)

