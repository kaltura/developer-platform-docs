---
layout: page
title: Upload and Import Video Files via API
weight: 110
---

### Media Ingestion APIs and Tools  

The Kaltura VPaaS offers many ways for ingesting content; a file upload API, bulk files import using CSV or XML, MRSS ingest services, and various widgets you can integrate into your workflows or sites, to allow user contributions and build custom upload interfaces.
Find the suitable ingestion methodologies for your workflow below:

* [File Upload and Import REST APIs](https://developer.kaltura.com/workflows/Ingest_and_Upload_Media)
  * [Web Upload in JavaScript/jQuery (with chunked parallel pause-resume support)](https://github.com/kaltura/chunked-file-upload-jquery)
  * [Upload in Java](https://github.com/kaltura/Sample-Kaltura-Chunked-Upload-Java)
* [Bulk Upload XML and CSV formats](/api-docs/Ingest_and_Upload_Media/Bulk-Content-Ingestion.html)
* [Live Streaming and Webcam Recording](https://developer.kaltura.com/workflows/Live_Stream_and_Broadcast)
* [Drop Folders and Aspera](https://knowledge.kaltura.com/node/737)

## Upload File Example

You can also refer to this [recipe](https://developer.kaltura.org/recipes/upload) as an alternate walkthrough of file uploading.

**Step 1: Create an Upload Token**

You’ll use [`uploadToken.add`](https://developer.kaltura.com/console/service/uploadToken/action/add) to create an uploadToken for your new video.

{% code_example media1 %}
&nbsp;

An UploadToken is essentially a container that holds any file that will be uploaded to Kaltura. The token has an ID that is attached to the location of the file.  This process allows the upload to happen independently of the entry creation. In the case of large files, for example, the same uploadToken ID is used for each chunk of the same file.

### About Chunked File Uploading

How it works: 
- On the client side of the app, the file is chunked into multiple fragments (of adjustable size)
- The chunks are then uploaded to Kaltura storage (in some cases simultaneously)
- Once all the chunks have arrived, they are assembled to form the original file [on the server side] so that file processing can begin

Kaltura has three widgets that you can use for chunked uploading:
- [JS Library](https://github.com/kaltura/kaltura-parallel-upload-resumablejs) (supports parallel uploading)
- [Java Library](https://github.com/kaltura/Sample-Kaltura-Chunked-Upload-Java) (supports parallel uploading)
- [jQuery Library](https://github.com/kaltura/chunked-file-upload-jquery) (for jQuery based applications)

To upload manually, continue following the steps: 

**Step 2: Upload the File Data**

We’ll call [`uploadToken.upload`](https://developer.kaltura.com/console/service/uploadToken/action/upload) to upload a new video file using the newly created token. If you don't have a video file handy, you can right-click [this link](http://cfvod.kaltura.com/pd/p/811441/sp/81144100/serveFlavor/entryId/1_2bjlk7qb/v/2/flavorId/1_d1ft34uv/fileName/Kaltura_Logo_Animation.flv/name/a.flv) to save a sample video of Kaltura's logo. In the case of large files, `resume` should be set to `true` and `finalChunk` is set to `false` until the final chunk. `resumeAt` determines at which byte to chunk the next fragment. 

{% code_example media2 %}
&nbsp;

**Step 3: Creating the Kaltura Media Entry**

Here’s where you’ll set your video’s name and description use [`media.add`](https://developer.kaltura.com/console/service/media/action/add) to create the entry.

{% code_example media3 %}
&nbsp;

The Kaltura Entry is a logical object that package all of the related assets to the uploaded file. The Media Entry represents Media assets (such as Image, Audio, or Video assets) and references all of the metadata, caption assets, transcoded renditions (flavors), thumbnails, access control rules, entitled users or any other related asset that is a part of that particular media item.


**Step 4: Attach the Video**

Now that you have your entry, you need to associate it with the uploaded video token using [`media.addContent`](https://developer.kaltura.com/console/service/media/action/addContent). 

{% code_example media4 %}
&nbsp;

At this point, Kaltura will start analyzing the uploaded file, prepare for the transcoding and distribution flows and any other predefined workflows or notifications.



## How to Ingest a Media File Bundled with Metadata (CSV, XML, API)

To enable more advanced content ingestion options, the provided CSV/XML samples can be extended to include multiple/custom metadata items, account specific settings, update action and advanced content ingestion options (for example, ingestion of multiple transcoding flavors, multiple thumbnails etc.) Each item element within the XML, and each line in the CSV, represent a single entry created in the publisher account. Each entry will be populated with the metadata listed in its item element and the content referenced from it. When submitted, the bulk upload XML/CSV is validated on the Kaltura server. The validation includes an inspection of the XML structure, and verification of elements' structure and order compliance with Kaltura's bulk upload XSD (XML schema). For more information see <a href="http://knowledge.kaltura.com/faq/what-bulk-upload-and-ftp-content-ingestion" target="_blank" title="What is bulk and FTP upload">Bulk Upload and FTP Upload</a>.

To ingest a media file bundled with Metadata:

1.  Select the Upload tab.
2.  Click **Download CSV/XML Samples**.
3.  Enter the metadata in the relevant fields.
4.  For more information on the XML custom data upload see the following:

* http://www.kaltura.com/api_v3/xsdDoc/?type=bulkUploadXml.bulkUploadXML#element-customDataItems
* http://www.kaltura.com/api_v3/xsdDoc/?type=bulkUploadXml.bulkUploadXML#element-customData


>Note: For any bulk actions that will create more than 5,000 entries (e.g., users), including categories bulk uploads, please contact your Kaltura representative to coordinate the upload.