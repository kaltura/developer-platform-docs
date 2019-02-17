---
layout: page
title: Recorded and Live Stream Events Scheduling and iCal API
weight: 303
---

The Kaltura's Video Scheduling API enables Encoding and Capture devices to leverage the Kaltura platform to schedule events for devices, and to use information from those events to trigger live events, and ingest recorded content back to Kaltura with related metadata. Scheduling of events and retrieving the scheduled events calendar via the API is discussed in this article. 

> The Kaltura Scheduled Events API allows for scheduling conflicting resources and blackout dates. To get and resolve conflicting events and resources, use the [`scheduleEvent.getConflicts`](https://developer.kaltura.com/api-docs/service/scheduleEvent/action/getConflicts) action.

Kaltura MediaSpace and KAF (Kaltura Applications Framework) views also provide UI workflows to create, and manage scheduled events (read more about the UI in the [Scheduled Events User Manual](https://knowledge.kaltura.com/kaltura-recording-scheduling-management), and to get access to the scheduling module in your MediaSpace instance, contact your Kaltura representative).

The Scheduled Events API is also exposed as a standard [iCal format](https://en.wikipedia.org/wiki/ICalendar). This provides backend support for calendar definition, including importing and exporting using the iCal standard. Importing into the Kaltura platform is done either though bulk-upload or drop-folders. 

The Kaltura Scheduled Events API support 3 types of Events (see [`KalturaScheduleEventType`](https://developer.kaltura.com/api-docs/General_Objects/Enums/KalturaScheduleEventType)):

 1. Recorded Events ([`KalturaRecordScheduleEvent`](https://developer.kaltura.com/api-docs/General_Objects/Objects/KalturaRecordScheduleEvent)) - Schedule the recording of an event that will be uploaded to Kaltura after the event ends.
 2. Live Events ([`KalturaLiveStreamScheduleEvent`](https://developer.kaltura.com/api-docs/General_Objects/Objects/KalturaLiveStreamScheduleEvent)) - Schedule a Live Event that will be live streamed to Kaltura as it occurs. 
 3. Blackout Events ([`KalturaBlackoutScheduleEvent`](https://developer.kaltura.com/api-docs/General_Objects/Objects/KalturaBlackoutScheduleEvent)) - Provides the ability to assign dates as "blackouts" and prevent other events from being scheduled in these dates. 

## Using the Kaltura Video Scheduling API

### On the Kaltura Platform:

1. Create an event for a future date (`scheduleEvent.add` API action or via BulkUpload/DropFolder sync).
2. Set recording / encoding device as a resource for the scheduled event (`scheduleResource.add` and `scheduleEventResource.add`).
3. Define a Kaltura Entry as template entry for the event that includes the desired metadata for the recorded or live entry resulting from the scheduled event (including any information on how to publish the entry; co-editors, description/title, etc.).

### On the device

Configure the device to sync its internal calendar with the Kaltura scheduled Events calendar periodically (JSON, XML and iCal formats over REST API or FTP are available).

#### For Live Entries

1. The device will start live streaming at the pre-set time to the RTMP/RTSP/WebRTC endpoint provided in the Scheduled Event details (`x-kaltura-primary-rtmp-endpoint, x-kaltura-secondary-rtmp-endpoint, x-kaltura-primary-rtsp-endpoint, x-kaltura-secondary-rtsp-endpoint, x-kaltura-live-stream-name, x-kaltura-live-stream-username, x-kaltura-live-stream-password`).
2. Viewers should now be able to watch the live stream in Kaltura.

#### For Recorded Entries

1. The device will start recording at the pre-set time. The recording should be stored locally.
3. The device will upload the recording to Kaltura, setting the relevant parameters on the newly created entry, from the entry template and any other additional metadata. 
4. The user will be able to view the created recording in Kaltura. 

> If you have access to Kaltura MediaSpace or KAF Applications: The Scheduling Module in KMS or KAF can be used to view and create events. If the recording was published to a course or category, it will appear there for all users with permissions to access it. 

## Sync Events Schedule to Kaltura

The schedule can be updated using different methods: 

1. Making REST API calls to the `scheduleEvent`, `scheduleResource` and `scheduleEventResource` services. 
2. As an iCal file synced over a Kaltura hosted Drop-Dolders (FTP, SFTP or Aspera). 
3. As an iCal file synced form a third-party hosted Drop-Folders over FTP, SFTP or S3. 
4. The iCal file format may also be ingested using the [`scheduleEvent.addFromBulkUpload`](https://developer.kaltura.com/api-docs/service/scheduleEvent/action/addFromBulkUpload) API action.

## Using the Event Scheduling API

Kaltura Event Scheduling is implemented as 3 API services:

1. [`scheduleEvent`](https://developer.kaltura.com/console/service/scheduleEvent) - Representing the Event being scheduled (either Live, Recorded or Blackout).
2. [`scheduleResource`](https://developer.kaltura.com/console/service/scheduleResource) - Representing the devices to be used during the scheduled event (Camera, Live Entry, or Location). Kaltura will log scheduling conflicts between scheduled events trying to use the same resources (resources are uniquely identified using the `systemName` field). To get conflicting events call the [`scheduleEvent.getConflicts`](https://developer.kaltura.com/api-docs/service/scheduleEvent/action/getConflicts) action.
3. [`scheduleEventResource`](https://developer.kaltura.com/console/service/scheduleEventResource) - Manages the association of particular resources (Camera, Live Entry, or Location) to Scheduled Events. 

The below example shows scheduling  a live event, creating a live stream resource for the event, and associating the resource with the event: 

```php
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

## The Kaltura iCal Format  

The Kaltura iCal Format follows the standard iCal format definitions, and adds Kaltura specific parameters. The additional parameters are described in the table below:

| Name                              	| Description                                                                                                                                                                	| Format                                                                                                                      	|
|-----------------------------------	|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------	|-----------------------------------------------------------------------------------------------------------------------------	|
| X-KALTURA-ID                      	| The ID of the Scheduled Event in Kaltura                                                                                                                                   	| int                                                                                                                         	|
| X-KALTURA-PARTNER-ID              	| The Kaltura Account ID ([Partner ID](https://kmc.kaltura.com/index.php/kmcng/settings/integrationSettings))                                                                	| int                                                                                                                         	|
| X-KALTURA-PARENT-ID               	| If a single occurrence as part of a series (recurring event), the parent ID will be the ID of the recurring event.                                                         	| int                                                                                                                         	|
| X-KALTURA-STATUS                  	| Status of the event in Kaltura                                                                                                                                             	| int ([KalturaScheduleEventStatus](https://developer.kaltura.com/api-docs/General_Objects/Enums/KalturaScheduleEventStatus)) 	|
| X-KALTURA-CATEGORY-IDS            	| The list of categories to which the event belongs                                                                                                                          	| Unlimited, comma-separated IDs (Integers)                                                                                   	|
| X-KALTURA-ENTRY-IDS               	| The Entry IDs related to this event                                                                                                                                        	| Unlimited, comma separated String IDs; each string is exactly 10 ASCII characters (0-1, a-z and underscore).                	|
| X-KALTURA-RESOURCE-IDS            	| The Kaltura resource ID for the resources used in the event                                                                                                                	| Unlimited, comma-separated integers                                                                                         	|
| X-KALTURA-TAGS                    	| Metadata tags for the event                                                                                                                                                	| Unlimited, comma-separated Strings; all tags combined, including the commas, should be less than 65k.                       	|
| X-KALTURA-TEMPLATE-ENTRY-ID       	| Template entry to be used for entries created based on this event. The template entry will define the recording owner, categories for the recorded entry, co-editors, etc. 	| Exactly 10 ASCII characters (0-1, a-z and underscore)                                                                       	|
| X-KALTURA-TYPE                    	| Defines the type of entry required by this event: live or VOD.                                                                                                             	| 1 – recording; 2 – live-stream                                                                                              	|
| X-KALTURA-PRIMARY-RTMP-ENDPOINT   	| The Primary RTMP endpoint to send the live stream to                                                                                                                       	| String; RTMP Url                                                                                                            	|
| X-KALTURA-SECONDARY-RTMP-ENDPOINT 	| The Secondary (backup) RTMP endpoint to send the live stream to                                                                                                            	| String; RTMP Url                                                                                                            	|
| X-KALTURA-PRIMARY-RTSP-ENDPOINT   	| The Primary RTSP endpoint to send the live stream to                                                                                                                       	| String; RTSP Url                                                                                                            	|
| X-KALTURA-SECONDARY-RTSP-ENDPOINT 	| The Secondary (backup) RTSP endpoint to send the live stream to                                                                                                            	| String; RTSP Url                                                                                                            	|
| X-KALTURA-LIVE-STREAM-NAME        	| The name of the live stream                                                                                                                                                	| String                                                                                                                      	|
| X-KALTURA-LIVE-STREAM-USERNAME    	| The user-name of the live stream (if authentication is required)                                                                                                           	| String                                                                                                                      	|
| X-KALTURA-LIVE-STREAM-PASSWORD    	| The password of the live stream (if authentication is required)                                                                                                            	| String                                                                                                                      	|

## Uploading a Recording to Kaltura  

To upload the recording file, you can either submit a bulk upload or upload the file via the REST API:

* To submit an import job (where Kaltura will download the file from your HTTP/s/FTP accessible URL), follow the [Bulk Content Ingestion Guide](https://developer.kaltura.com/api-docs/Ingest_and_Upload_Media/Bulk-Content-Ingestion.html).
* To upload the recording files using the REST API, follow [the upload workflow](https://developer.kaltura.com/workflows/Ingest_and_Upload_Media).

> Remember to submit the templateEntryId accordingly and to set any other important metadata on the newly created Entry.

### Publishing Permissions  

To enable the device to use an entry template that includes publishing to specific categories or channels, the device must use the correct entitlements when uploading the recording file.  The recommended way to securely provide each device the appropriate permissions is to use App Tokens. This requires that the account admin will prepare an App Token, and then share the app token with the device to be used when calling the upload API.

To learn about App Tokens read the [Creating Kaltura Session with AppTokens Guide](https://developer.kaltura.com/api-docs/VPaaS-API-Getting-Started/Generating-KS-with-App-Tokens.html).

To ensure that your device has the appropriate access, pass the following privilege: `setrole:CAPTURE_DEVICE_ROLE` in the `privileges` field.

> Note: While it is possible for the device to use an API admin secret to upload all recordings as an administrator, this will create a security risk and is discouraged. If anyone unauthorized will gain access to that device and to your API admin secret, they will have access to your Kaltura account.  

After you've created an App Token for the device, configure the `id` and the `token` fields of the created app-token on the device.

To generate the upload session from the device, follow these steps:

1. Generate a session using the appToken ([follow this API workflow](https://developer.kaltura.com/workflows/Generate_API_Sessions/App_Token_Authentication) as reference).
2. Create a new Video Entry, and upload your video recording ([follow this guide](https://developer.kaltura.com/api-docs/Ingest_and_Upload_Media/create-new-kaltura-entry-and-upload-video-file-using-kaltura-api.html) as reference).

## Download / Sync the iCal Schedule from Kaltura 

iCal provides a standardized method for syncing calendar events from Kaltura. 
To retrieving an iCal file format, add `format/ical` to the `scheduleEvent.list` API action.

### Filtering and Pagination of Results  

All Kaltura list actions, including [scheduleEvent.list](https://developer.kaltura.com/api-docs/Integration_Scheduling_and_Hooks/Scheduling_Triggers_using_iCal/scheduleEvent/scheduleEvent_list), accept the [KalturaFilterPager](https://developer.kaltura.com/api-docs/General_Objects/Filters/KalturaFilterPager). 

> By default, the Kaltura pager returns 30 results. Use the pageIndex to loop through result pages, or pageSize to increase the amount of results returned per call. Note that the maximum is 500 results per call ("page").

The maximum number of returned results is 10,000 total (across all pages in the given filter). To retrieve more than 10,000 results, you will need to use a filter instead of pager. For example using the date filter in a loop: [createdAtGreaterThanOrEqual](https://developer.kaltura.com/api-docs/General_Objects/Filters/KalturaAccessControlBaseFilter). 

The results can be filtered on any of the filter parameters. For the list of available filter parameters see: [KalturaScheduleEventFilter](https://developer.kaltura.com/api-docs/General_Objects/Filters/KalturaScheduleEventFilter).  More than one filter can be applied to each request. 

For example: 

* To retrieve events for a specific resource use the  `filter[resourceIdsLike]` filter parameter (replace RESOURCE-ID with the ID of the resource to get events for):
```
http://www.kaltura.com/api_v3/service/schedule_scheduleevent/action/list/format/ical/filter[objectType]/KalturaScheduleEventFilter/filter[resourceIdsLike]/RESOURCE-ID
```
* To get the next 30 events from now, set `startDateGreaterThanOrEqual` to 0 (now):
```
http://www.kaltura.com/api_v3/service/schedule_scheduleevent/action/list/format/ical/filter[objectType]/KalturaScheduleEventBaseFilter/filter[startDateGreaterThanOrEqual]/0
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
Multiple resources can be defined for an event. Resources can be added using the API (e.g. automatic creation of a matching resource by the device itself) or bulk uploaded in advance using .csv format (see [scheduleResource.addFromBulkUpload](https://developer.kaltura.com/api-docs/service/scheduleResource/action/addFromBulkUpload)). 

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
* `2` - updates an existing resource by the provided resourceId or unique systemName
* `3` - deletes an existing resource by the provided resourceId or unique systemName
* `6` - updates an existing resource by the provided resourceId or unique systemName, if no such resource exists, add as a new resource

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
* To avoid returning multiple live stream endpoints in the iCal - For Live Stream Events, the iCal format will return the RTMP/RTSP endpoints and credentials as defined in the `templateEntryId`. To avoid confusion, always set the template entry id to be the same as the Live Stream Entry resource assigned to the event. 
*  There’s only one schedule per Kaltura account managed. Multiple scheduling systems will need to be merged into one Kaltura schedule.
