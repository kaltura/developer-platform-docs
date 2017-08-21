---
layout: page
title: Create a New Kaltura Entry and Upload Video File using the Kaltura API
weight: 306
---
 

This article takes the user through the basic flow of uploading media using Kaltura's upload API.

To upload a video file using the C# API Client Library, follow the steps below.


Handshake to create a Kaltura Session:

{% highlight csharp %}
KalturaConfiguration config = new KalturaConfiguration(PARTNER_ID);
config.ServiceUrl = SERVICE_URL;
KalturaClient client = new KalturaClient(config);
client.KS = client.GenerateSession(ADMIN_SECRET, USER_ID, KalturaSessionType.ADMIN, PARTNER_ID, 86400, "");
{% endhighlight %}


Create a new Media Entry to which we'll attach the uploaded file:

{% highlight csharp %}
KalturaMediaEntry mediaEntry = new KalturaMediaEntry();
mediaEntry.Name = "Media Entry Using C#";
mediaEntry.MediaType = KalturaMediaType.VIDEO;
mediaEntry = client.MediaService.Add(mediaEntry);
{% endhighlight %}

Upload the media file:

{% highlight csharp %}
FileStream fileStream = new FileStream("DemoVideo.flv", FileMode.Open, FileAccess.Read);
KalturaUploadToken uploadToken = client.UploadTokenService.Add();
client.UploadTokenService.Upload(uploadToken.Id, fileStream);
{% endhighlight %}

Attach the Media Entry to the file:

{% highlight csharp %}
KalturaUploadedFileTokenResource mediaResource = new KalturaUploadedFileTokenResource();
mediaResource.Token = uploadToken.Id;
mediaEntry = client.MediaService.AddContent(mediaEntry.Id, mediaResource); 
{% endhighlight %}

## Chunked Video Upload or Upload Pause and Resume Flow

The Kaltura API supports an upload pause and resume via chunked upload workflow. Additionally, Kaltura also provide a [jQuery plugin](https://github.com/kaltura/jQuery-File-Upload) that simplifies the process.

An example showing how to use the jquery plugin can be seen in this [recipe](https://developer.kaltura.org/recipes/upload).

However, if you are unable to use the jQuery plugin above, you can implement it yourself by chunking the file and calling the uploadToken service. 

To use the uploadToken service for chunked upload, set the following parameters in the upload action:

* Resume - should be set to true.
* resumeAt – the byte offset to add current chunk to.</span>
* finalChunk - should be set to 0 for all chunks, and set to 1 for the last chunk.

As a reference, see [this implementation of a chunked upload operation with the Kaltura Java client](https://github.com/kaltura/kaltura-chunked-upload-test/blob/master/chunkedupload/ChunkedUpload.java#L114).
