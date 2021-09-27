---
layout: page
title: Introduction to Scheduling and Managing Resources  
weight: 110
---

## Introduction to Scheduling and Managing Resources  

The Kaltura Video Scheduling API enables Encoding and Capture devices to leverage the Kaltura platform to schedule events for devices, and to use information from those events to trigger live events, and ingest recorded content back to Kaltura with related metadata. Scheduling of events and retrieving the scheduled events calendar via the API is discussed in this article. 

> The Kaltura Scheduled Events API allows for scheduling conflicting resources and blackout dates. To get and resolve conflicting events and resources, use the [`scheduleEvent.getConflicts`](https://developer.kaltura.com/api-docs/service/scheduleEvent/action/getConflicts) action.

Kaltura MediaSpace and KAF (Kaltura Applications Framework) views also provide UI workflows to create, and manage scheduled events (read more about the UI in the [Scheduled Events User Manual](https://knowledge.kaltura.com/kaltura-recording-scheduling-management), and to get access to the scheduling module in your MediaSpace instance, contact your Kaltura representative).

The Scheduled Events API is also exposed as a standard [iCal format](https://en.wikipedia.org/wiki/ICalendar). This provides backend support for calendar definition, including importing and exporting using the iCal standard. Importing into the Kaltura platform is done either though bulk-upload or drop-folders. 

The Kaltura Scheduled Events API support 3 types of Events (see [`KalturaScheduleEventType`](https://developer.kaltura.com/api-docs/General_Objects/Enums/KalturaScheduleEventType)):

  1. **Recorded Events**  - Schedule the recording of an event that will be uploaded to Kaltura after the event ends.
  2. **Live Events**  - Schedule a Live Event that will be live streamed to Kaltura as it occurs. 
  3. **Blackout Events** - Provides the ability to assign dates as "blackouts" and prevent other events from being scheduled in these dates. 

## Using the Kaltura Video Scheduling API

### On the Kaltura Platform

1. Create an event for a future date (`scheduleEvent.add` API action or via BulkUpload/DropFolder sync).
2. Set recording / encoding device as a resource for the scheduled event 
3. Define a Kaltura Entry as template entry for the event that includes the desired metadata for the recorded or live entry resulting from the scheduled event (including any information on how to publish the entry; co-editors, description/title, etc.).

### On the device

Configure the device to sync its internal calendar with the Kaltura scheduled Events calendar periodically (JSON, XML and iCal formats over REST API or FTP are available).

## Sync Events Schedule to Kaltura

The schedule can be updated using different methods: 

1. Making REST API calls to the `scheduleEvent`, `scheduleResource` and `scheduleEventResource` services. 
2. Via an [iCal file](iCal-API-and-Calendar-Integrations.html) 

## Using the Event Scheduling API

Kaltura Event Scheduling is implemented as 3 API services:

1. [`scheduleEvent`](https://developer.kaltura.com/console/service/scheduleEvent) - Representing the Event being scheduled (either Live, Recorded or Blackout).
2. [`scheduleResource`](https://developer.kaltura.com/console/service/scheduleResource) - Representing the devices to be used during the scheduled event (Camera, Live Entry, or Location). Kaltura will log scheduling conflicts between scheduled events trying to use the same resources (resources are uniquely identified using the `systemName` field). To get conflicting events call the [`scheduleEvent.getConflicts`](https://developer.kaltura.com/api-docs/service/scheduleEvent/action/getConflicts) action.
3. [`scheduleEventResource`](https://developer.kaltura.com/console/service/scheduleEventResource) - Manages the association of particular resources (Camera, Live Entry, or Location) to Scheduled Events. 

The below example shows scheduling  a live event, creating a live stream resource for the event, and associating the resource with the event: 

```php
<?php
// If you're creating a Scheduled Live Event, first create the Live Entry:
$liveEntry = new KalturaLiveStreamEntry();
$liveEntry->name = 'Test Live Entry With Cloud Transcoding';
$liveEntry->description = "Just a test live stream entry";
$liveEntry->dvrStatus = true;
$liveEntry->dvrWindow = 120;
$liveEntry->explicitLive = true;
// LIVE_STREAM_FLASH designates a standard web live entry acquired via an RTMP or RTSP stream
$liveEntry->mediaType = KalturaMediaType::LIVE_STREAM_FLASH;
$liveEntry->recordStatus = KalturaRecordStatus::PER_SESSION;
$liveEntry = $client->liveStream->add($liveEntry, KalturaSourceType::LIVE_STREAM);

// Create the Scheduled Event:
// KalturaRecordScheduleEvent for a recording scheduling
// KalturaLiveStreamScheduleEvent for a live broadcast scheduling
// KalturaBlackoutScheduleEvent for scheduling a blackout date
$scheduleEvent = new KalturaLiveStreamScheduleEvent(); 
$scheduleEvent->summary = $summary; //the description of the event
$scheduleEvent->startDate = $startDate; //unix timestamp
$scheduleEvent->endDate = $endDate; //unix timestamp
$scheduleEvent->recurrenceType = KalturaScheduleEventRecurrenceType::NONE;
// Define a Kaltura Entry as template entry for the event that includes the desired metadata for the recorded or live entry resulting from the scheduled event (including any information on how to publish the entry; co-editors, description/title, etc.).
// Note: if you're scheduling a Live Event, set the Live Stream Entry id as the template of this Scheudled Event
$scheduleEvent->templateEntryId = $liveEntry->id; 
// $client is the preinitilized KalturaClient instance
$schedulePlugin = KalturaScheduleClientPlugin::get($client);
$scheduleEvent = $schedulePlugin->scheduleEvent->add($scheduleEvent);

// Create a resource to use with this event:
// KalturaCameraScheduleResource for a camera resource in a recorded event
// KalturaLiveEntryScheduleResource for a Live Stream Entry in a live broadcast event
// KalturaLocationScheduleResource for designating a room 
// multiple resources can be assigned to a single event (e.g. a room + camera + live entry)
$scheduleResource = new KalturaLiveEntryScheduleResource();
$scheduleResource->name = $resourceName; // a name to call your resource
$scheduleResource->systemName = $systemName; // a unique identified to identify your resource
if ($resourceType == 'KalturaLiveEntryScheduleResource') {
    $scheduleResource->entryId = $liveEntry->id;
}
$schedulePlugin = KalturaScheduleClientPlugin::get($client);
$scheduleResource = $schedulePlugin->scheduleResource->add($scheduleResource);

// Assign the resource to the Event. 
// Kaltura will not error or alert if the resource is already been assigned to an event at the same time. 
// To get the conflicting events call the scheduleEvent.getConflicts action.:
$scheduleEventResource = new KalturaScheduleEventResource();
$scheduleEventResource->eventId = $scheduleEvent->id;
$scheduleEventResource->resourceId = $scheduleResource->id;
$schedulePlugin = KalturaScheduleClientPlugin::get($client);
$scheduleEventResource = $schedulePlugin->scheduleEventResource->add($scheduleEventResource);

// To test for scheduling conflicts before assigning an existing resource to a new event, 
$schedulePlugin = KalturaScheduleClientPlugin::get($client);
$filter->systemNameEqual = $yourResourceSystemName;
$scheduledResource = $schedulePlugin->scheduleResource->listAction($filter)->objects[0];
$resourceIds = $scheduledResource->id;
$scheduleEventConflictType = KalturaScheduleEventConflictType::BOTH;
$testForSchedulingConflicts = $schedulePlugin->scheduleEvent->getConflicts($resourceIds, $scheduledEvent, null, $scheduleEventConflictType);
if ($testForSchedulingConflicts->totalCount == 0) {
	// It is safe to assign the resource to the event, no scheduling conflicts found.
} else {
    // Conflicts detected, this resource is already scheduled at this time. 
    //Please resolve conflicts before assigning it to another event at the same time.
}
```

### Publishing Permissions  

To enable the device to use an entry template that includes publishing to specific categories or channels, the device must use the correct entitlements when uploading the recording file.  The recommended way to securely provide each device the appropriate permissions is to use App Tokens. This requires that the account admin will prepare an App Token, and then share the app token with the device to be used when calling the upload API.

To learn about App Tokens read the [Application Tokens](../Getting-Started-Building-Video-Applications /Application-Tokens.html) guide

To ensure that your device has the appropriate access, pass the following privilege: `setrole:CAPTURE_DEVICE_ROLE` in the `privileges` field.

> Note: While it is possible for the device to use an API admin secret to upload all recordings as an administrator, this will create a security risk and is discouraged. If anyone unauthorized will gain access to that device and to your API admin secret, they will have access to your Kaltura account.  

After you've created an App Token for the device, configure the `id` and the `token` fields of the created app-token on the device.

To generate the upload session from the device, follow these steps:

1. Generate a session using the appToken [Application-Tokens](../Getting-Started-Building-Video-Applications /Application-Tokens.html) 
2. Create a new Video Entry, and upload your video recording.

### Filtering and Pagination of Results  

All Kaltura list actions, including [scheduleEvent.list](https://developer.kaltura.com/api-docs/Integration_Scheduling_and_Hooks/Scheduling_Triggers_using_iCal/scheduleEvent/scheduleEvent_list), accept the [KalturaFilterPager](https://developer.kaltura.com/api-docs/General_Objects/Filters/KalturaFilterPager). 

> By default, the Kaltura pager returns 30 results. Use the `pageIndex` to loop through result pages, or `pageSize` to increase the amount of results returned per call. Note that the maximum is 500 results per call ("page").

The maximum number of returned results is 10,000 total (across all pages in the given filter). To retrieve more than 10,000 results, you will need to use a filter instead of pager. For example using the date filter in a loop: [createdAtGreaterThanOrEqual](https://developer.kaltura.com/api-docs/General_Objects/Filters/KalturaAccessControlBaseFilter). 

The results can be filtered on any of the filter parameters. For the list of available filter parameters see: [KalturaScheduleEventFilter](https://developer.kaltura.com/api-docs/General_Objects/Filters/KalturaScheduleEventFilter).  More than one filter can be applied to each request. 

For example: 

* To retrieve events for a specific resource use the  `filter[resourceIdsLike]` filter parameter (replace RESOURCE-ID with the ID of the resource to get events for):

```
http://www.kaltura.com/api_v3/service/schedule_scheduleevent/action/list/format/ical/filter[objectType]/KalturaScheduleEventFilter/filter[resourceIdsLike]/RESOURCE-ID
```

* To get the next 30 events from now, set `startDateGreaterThanOrEqual` to 0 (now):

```
http://www.kaltura.com/api_v3/service/schedule_scheduleevent/action/list/filter[objectType]/KalturaScheduleEventBaseFilter/filter[startDateGreaterThanOrEqual]/0
```

* To page through the results, and increase the page size to 500 results per page, set the `pager` object's `pageSize` and `pageIndex` parameters:

```
http://www.kaltura.com/api_v3/service/schedule_scheduleevent/action/list/format/ical/filter[objectType]/KalturaScheduleEventFilter/pager[pageSize]/500/pager[pageIndex]/2
```

#### Relative Time Filters

Time attributes support both absolute and relative times. 
The time is measured in seconds since 1970, also known as a UNIX timestamp; however, if you specify a time that is smaller than 1980 (in seconds since 1970), e.g., 0, 60, or -60, Kaltura will calculate the past value as a relative time, for example:

* `0` = now. 
* `60` = now + 60 seconds – which is 60 seconds from now. 
* `-60` = now - 60 seconds – which is 60 seconds ago. 

For example, passing `filter[startDateGreaterThanOrEqual]=0` will return all the events that start now or in the future. 

## Configuring Resources in Kaltura  

Capture devices as well as rooms and Live Stream entries can be mapped to resource objects in Kaltura. This is similar to booking a conference room using a calendar application. 
Multiple resources can be defined for an event. Resources can be added using the API (e.g. automatic creation of a matching resource by the device itself) or bulk uploaded in advance using the CSV format (see [scheduleResource.addFromBulkUpload](https://developer.kaltura.com/api-docs/service/scheduleResource/action/addFromBulkUpload)). 

Kaltura's Bulk Upload CSV format supports mixed orders, and not all fields are required; the fields are defined by the user using an asterisk at the beginning of the line.

### The Scheduled Resources bulk upload CSV 

| Field            	| Description / Default                                                                                                                                                	|
|------------------	|----------------------------------------------------------------------------------------------------------------------------------------------------------------------	|
| action           	| Default to add (`1`).  One of the options defined by [KalturaBulkUploadAction](https://developer.kaltura.com/api-docs/General_Objects/Enums/KalturaBulkUploadAction) 	|
| resourceId       	| Optional.  If updating or deleting an existing resource, provide the id of the resource to update. resourceId can be used instead of systemName.                     	|
| name             	| Required with no default. String.                                                                                                                                    	|
| type             	| Required with no default. Either `location`, `camera` or `live_entry`                                                                                                	|
| systemName       	| Required with no default. Alphanumeric string (no spaces or special chars).                                                                                          	|
| description      	| Optional String.  Default to Null.                                                                                                                                   	|
| tags             	| Comma-separated String.  Default to Null.                                                                                                                            	|
| parentType       	| Optional. Required with no default.  Either `location`, `camera` or `live_entry`                                                                                     	|
| parentSystemName 	| alphanumeric string (no spaces or special chars).  Default to Null.                                                                                                  	|

> Note that resources can have a hierarchy (e.g., a room with cameras), which is defined using the parent type and name.

The possible values for the action column (the first column in the example above) are listed in [KalturaBulkUploadAction](https://developer.kaltura.com/api-docs/General_Objects/Enums/KalturaBulkUploadAction). The common actions are: 

* `1` (Default) - adds a new resource
* `2` - updates an existing resource by the provided `resourceId` or unique `systemName`
* `3` - deletes an existing resource by the provided `resourceId` or unique `systemName`
* `6` - updates an existing resource by the provided `resourceId` or unique `systemName`, if no such resource exists, add as a new resource

For example:

```
*action,resourceId,name,type,systemName,description,tags,parentType,parentSystemName
1,,my resource name,camera,my-camera1,my example camera,"tag1,tag2",location,my-parent1
3,33
2,34,new awesome resource name,live_entry,my-live-stream,my example live stream entry resource,"tag1,tag2"
```

## Notable considerations when scheduling events

* Conflicting events: At present, Kaltura does not prevent conflicting events. The user will need to ensure that there is no resource conflict when scheduling the event. Devices should be able to handle resource conflicts and ensure operations in such case. To retrieve and handle conflicting events call the [`scheduleEvent.getConflicts`](https://developer.kaltura.com/api-docs/service/scheduleEvent/action/getConflicts) action.
* Recurring events: When retrieving a recurring event via the API, both the series and the breakdown of each occurrence will be provided. Devices can filter based on  [KalturaScheduleEventRecurrenceType](https://developer.kaltura.com/api-docs/General_Objects/Enums/KalturaScheduleEventRecurrenceType) to receive only the series (`RECURRING`) or single events (`RECURRENCE`), or to receive single events and breakdown of series. The choice between the options depends on the capability of the device. 
* There’s only one schedule per Kaltura account managed. Multiple scheduling systems will need to be merged into one Kaltura schedule.