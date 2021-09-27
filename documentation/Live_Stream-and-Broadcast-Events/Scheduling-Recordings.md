---
layout: page
title: Scheduling Recordings
weight: 110
---

(`scheduleResource.add` and `scheduleEventResource.add`).

#### For Recorded Entries

1. The device will start recording at the pre-set time. The recording should be stored locally.
2. The device will upload the recording to Kaltura, setting the relevant parameters on the newly created entry, from the entry template and any other additional metadata. 
3. The user will be able to view the created recording in Kaltura. 

> If you have access to Kaltura MediaSpace or KAF Applications: The Scheduling Module in KMS or KAF can be used to view and create events. If the recording was published to a course or category, it will appear there for all users with permissions to access it. 

​                                                  

## Uploading a Recording to Kaltura  

To upload the recording file, you can either submit a bulk upload or upload the file via the REST API:

* To submit an import job (where Kaltura will download the file from your HTTP/s/FTP accessible URL), follow the [Bulk-Content-Ingestion Guide](../Video-On-Demand-and-Digital-Assets-Management/Bulk-Content-Ingestion.html) 
* To upload the recording files using the REST API, follow [the upload workflow](https://developer.kaltura.com/workflows/Ingest_and_Upload_Media).

> Remember to submit the `templateEntryId` accordingly and to set any other important metadata on the newly created Entry.

