---
layout: page
title: iCal API and Calendar Integrations 
weight: 110
---

The Scheduled Events API is also exposed as a standard [iCal format](https://en.wikipedia.org/wiki/ICalendar). This provides backend support for calendar definition, including importing and exporting using the iCal standard. Importing into the Kaltura platform is done either though bulk-upload or drop-folders. 

# iCal API ingestion

1. As an iCal file synced over a Kaltura hosted [Drop-folders](https://knowledge.kaltura.com/help/kaltura-drop-folders-service-for-content-ingestion) (FTP, SFTP or Aspera). 

2. As an iCal file synced form a third-party hosted Drop-Folders over FTP, SFTP or S3. 

3. The iCal file format may also be ingested using the [`scheduleEvent.addFromBulkUpload`](https://developer.kaltura.com/api-docs/service/scheduleEvent/action/addFromBulkUpload) API action.

   

## Download / Sync the iCal Schedule from Kaltura 

iCal provides a standardized method for syncing calendar events from Kaltura. 
To retrieving an iCal file format, add `format/ical` to the [scheduleEvent.list](https://developer.kaltura.com/api-docs/service/scheduleEvent/action/list) API action.

For example:

```
http://www.kaltura.com/api_v3/service/schedule_scheduleevent/action/list/format/ical/filter[objectType]/KalturaScheduleEventFilter/filter[resourceIdsLike]/RESOURCE-ID
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



## Notable considerations when scheduling events

> To avoid returning multiple live stream endpoints in the iCal - For Live Stream Events, the iCal format will return the RTMP/RTSP endpoints and credentials as defined in the `templateEntryId`. To avoid confusion, always set the template entry id to be the same as the Live Stream Entry resource assigned to the event. 
