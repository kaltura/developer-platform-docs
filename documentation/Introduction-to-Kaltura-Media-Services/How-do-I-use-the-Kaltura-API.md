---
layout: page
title: How do I use the Kaltura API? 
weight: 101
---


# How do I use the Kaltura API? 

This guide will enable you to quickly get started building your own media experiences and exploring the platform’s basic capabilities. The following topics are 

1. [The Kaltura API](#The Kaltura API) 
2. [Kaltura API Client Libraries](https://developer.kaltura.com/api-docs/Client_Libraries/)
3. [Mobile Player SDK's](https://developer.kaltura.com/player/)
4. Experience Components

## Before You Begin

You will need your Kaltura account credentials. If you don’t have them yet, start a [free trial](https://vpaas.kaltura.com/register).
If you’ve signed in, you can click on your account info at the top right of this page to view your credentials.
You can also find them at any time in the KMC's (Kaltura Management Console) by clicking the [Integration Settings tab](https://kmc.kaltura.com/index.php/kmcng/settings/integrationSettings).

## The Kaltura API

The Kaltura API structure consists of a list of services, represented by service objects. Each service object consists of different actions, represented by a method in the service object in the following format:

For example the [media](https://developer.kaltura.com/console/service/media) service has many different actions like:

1. [media.get](https://developer.kaltura.com/console/service/media/action/get)
2. [media.list](https://developer.kaltura.com/console/service/media/action/list)
3. [media.add](https://developer.kaltura.com/console/service/media/action/add)

All of these actions read or write to a common [KalturaMediaEntry](https://developer.kaltura.com/api-docs/General_Objects/Objects/KalturaMediaEntry) object.

For any service's action, click the "Learn More" button in the [developer console](https://developer.kaltura.com/console) to see the expected return object type. Try it with [media.get](https://developer.kaltura.com/console/service/media/action/get)

![learnmore](/assets/images/learnmore.png)

The simplest way to make requests to the Kaltura REST API is by using one of the [Kaltura API Client Libraries](https://developer.kaltura.com/api-docs/Client_Libraries/). We don’t recommend making REST API requests directly, as your URL requests might get really long and tricky. 

Once you’ve downloaded the client library, you'll need to import the library and instantiate a KalturaClient object with which you'll make calls to the API. 
Setup looks like this:

{% code_example setup %}

## Kaltura Session

You will need a Kaltura Session before perform almost all API actions, be sure to read about it here. 

## Using the console to generate code

Every API call in the [developer console](https://developer.kaltura.com/console) is able to generate code in all languages that Kaltura supports. See this example for the [media.list](https://developer.kaltura.com/console/service/media/action/list) API call:

![codegen](/assets/images/codegen.png)

### Uploading Media

At this point you could follow the [Uploading Media Files workflow](https://developer.kaltura.com/workflows/Ingest_and_Upload_Media/Uploading_Media_Files) or you can continue to learn about some basic API calls. 

## Finding Entries 

To retrieve your newly uploaded entry, or one of the default entries that comes with your account we'll use [media.list](https://developer.kaltura.com/console/service/media/action/list). If you inspect that API in the console, and expand the filter object, you'll see a whole bunch of options for filtering down to the entries you want. 

### Finding Entries By Name 

In the case of this example, a quick way to find the new entry is by searching for part of its name - in this case, "Logo". We need a filter object called `KalturaMediaEntryFilter` on which to set the values, which we then pass to the endpoint. 

{% code_example list1 %}
&nbsp;

The result will return as a list of  `KalturaMediaEntry` objects. Notice the Pager object. It is useful for large result sets if you want to get a specific amount of results for page. 

### Finding Entries By Date 

Another way to find the entry is by date. Using epoch timestamp, this code lists all entries created in July of 2019:

{% code_example list2 %}
&nbsp;

>Note that Kaltura Sessions with limited privileges might get limited results when making a `media.list` API call. 

To conduct a more thorough search, for example, **if you want to search within captions or metadata**, use the [Kaltura Search API](https://developer.kaltura.com/console/service/eSearch/action/searchEntry). Read about it [here](../Video-On-Demand-and-Digital-Assets-Management/Searching-for-Media-Entries.html) 

Learn about other embed types [here.](https://developer.kaltura.com/player/web/embed-types-web/)

## Wrapping Up 

Including a Kaltura Session allows you to keep track of user analytics for each entry and set permissions and privileges. Notice that in this case, the KS is created on the server side of the app. 

**Next steps:** 

- Learn how to create and handle [thumbnails](../Video-On-Demand-and-Digital-Assets-Management/Image-Transformations-and-On-the-fly-Video-Thumbnails.html) 
- Analyze Engagement [Analytics](../Analytics-and-Reporting /Intro-to-Kaltura-Video-Analytics-and-Best-Practices.html) 

You can find more API resources in our [docs](https://developer.kaltura.com/api-docs/), play around in the [console](https://developer.kaltura.com/console), or enjoy full interactive experiences with our [workflows](https://developer.kaltura.com/workflows). 

And of course, feel free to reach out at vpaas@kaltura.com if you have any questions.

