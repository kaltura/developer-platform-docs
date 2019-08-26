---
layout: page
title: Get Started with Kaltura VPaaS
weight: 101
---

# Getting Started 
 
This guide will enable you to quickly and easily get started with building your own video experiences and exploring the platform’s basic capabilities.
 
## Before You Begin
 
You will need your Kaltura account credentials. If you don’t have them yet, start a [free trial](https://vpaas.kaltura.com/register).
If you’ve signed in, you can click on your account info at the top right of this page to view your credentials.
You can also find them at any time in the KMC's (Kaltura Management Console) by clicking the [Integration Settings tab](https://kmc.kaltura.com/index.php/kmcng/settings/integrationSettings).
 
The simplest way to make requests to the Kaltura REST API is by using one of the [Kaltura API Client Libraries](https://developer.kaltura.com/api-docs/Client_Libraries/). We don’t recommend making REST API requests directly, as your URL requests might get really long and tricky. 
 
Once you’ve downloaded the client library, you'll need to import the library and instantiate a KalturaClient object with which you'll make calls to the API. 
Setup looks like this:

{% code_example setup %}
&nbsp;

The steps below will walk you through a few basic Kaltura APIs. If you're looking for languages that are not available here, you can click on any of the actions mentioned to see them in our [interactive console](https://developer.kaltura.com/console). 
 
## Kaltura Session
 
Because the Kaltura API is stateless, every request made to the API requires an authentication session to be passed along with the request. With the client library, it’s easy to set it once using the [`session.start`](https://developer.kaltura.com/console/service/session/action/start) API action, like this:

{% code_example session %}
&nbsp;
*Specifying an `app id` which contains the name and domain of the app allows you to get specific analytics per application, for cases where you’re running your application on various domains.*

Try it interactively [with this workflow](https://developer.kaltura.com/workflows/Generate_API_Sessions/Authentication). 

Generating a KS with [`session.start`](https://developer.kaltura.com/console/service/session/action/start) is simple, and great for applications which you alone have access to. 
Other methods include the [`user.loginByLoginId`](https://developer.kaltura.com/api-docs/service/user/action/loginByLoginId) action, which allows users to log in using their own KMC credentials, and the `appToken` service, which is recommended when providing access to applications in production that are managed by others. 
Learn more [here](https://developer.kaltura.com/api-docs/VPaaS-API-Getting-Started/application-tokens.html) about various ways to create a Kaltura Session.

 
## Uploading Media Files
Kaltura is built to handle files of all types and size. To best handle the upload of large files, Kaltura's upload API provides the ability to upload files in smaller chunks, in parallel (multiple chunks can be uploaded simultaneously to improve network utilization), as well as pause-and-resume and chunk upload retries in case of temporary network failures.
 
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

## Finding Entries 

To retrieve that newly uploaded entry, we'll use [media.list](https://developer.kaltura.com/console/service/media/action/list). If you inspect that API in the console, and expand the filter object, you'll see a whole bunch of options for filtering down to the entries you want. 

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

To conduct a more thorough search, for example, **if you want to search within captions or metadata**, use the [Kaltura Search API](https://developer.kaltura.com/console/service/eSearch/action/searchEntry). Read about it [here](https://developer.kaltura.com/api-docs/Search--Discover-and-Personalize/esearch.html). 

## Embedding Your Video Player 
You have your entry ID, so you’re just about ready to embed the kaltura player, but first you’ll need a `UI Conf ID`, which is basically the ID of the player in which the video is shown. 
For this you’ll need to log into the KMC and click on the [Studio](https://kmc.kaltura.com/index.php/kmcng/studio/v2) tab. 

Notice that there are two studio options: TV and Universal. 
The Universal player (or mwEmbed as we call it) offers legacy support - such as for enterprise customers using the old internet explorer - and also features interactivity options, like the dual player or In-Video Quizzes. 
The TV player (or playkit) is built on modern javascript and focuses more on performance. Both players are totally responsive. 

We will focus on the TV player, for which you can find resources and information [here](https://developer.kaltura.com/player). 

1. Create a new TV player, give it a name, and check out the various player options.
2. Save the player and go back to players list; you should now see it the top of the player list. Notice that player ID - that is your `UI Conf ID`. 
Now you can use it for embedding your player:

### Dynamic Player Embed 

The first script in the code below *loads* the player, and the second script handles the embed. This method of embedding makes it easy to dynamically control the configuration of the player during runtime.  

{% highlight javascript %}
<div id="{TARGET_ID}" style="width: 640px;height: 360px"></div>
<script type="text/javascript" src="https://cdnapisec.kaltura.com/p/{PARTNER_ID}/embedPlaykitJs/uiconf_id/{UICONF_ID}"></script>
  <script type="text/javascript">
    try {
      var kalturaPlayer = KalturaPlayer.setup({
        targetId: "{TARGET_ID}",
        provider: {
          partnerId: {PARTNER_ID},
          uiConfId: {UICONF_ID}
        },
        playback: {
          autoplay: true
          }
      });
      kalturaPlayer.loadMedia({entryId: '{ENTRY_ID}'});
    } catch (e) {
      console.error(e.message)
    }
  </script>
{% endhighlight %}

Learn about other embed types [here.](https://developer.kaltura.com/player/web/embed-types-web/)

## Wrapping Up 

Including a Kaltura Session allows you to keep track of user analytics for each entry and set permissions and privileges. Notice that in this case, the KS is created on the server side of the app. 

**Congrats! You’ve learned how to:**
- Create a kaltura session 
- Upload media to your Kaltura account 
- Search for your media
- Show your media in a Kaltura Player 

**Next steps:** 
- Read the eSearch [blog post](https://corp.kaltura.com/blog/introducing-esearch-the-new-kaltura-search-api/)
- Learn how to create and handle [thumbnails](https://developer.kaltura.com/api-docs/Engage_and_Publish/kaltura-thumbnail-api.html/)
- Analyze Engagement [Analytics](https://developer.kaltura.com/api-docs/Video-Analytics-and-Insights/media-analytics.html)

You can find more API resources in our [docs](https://developer.kaltura.com/api-docs/), play around in the [console](https://developer.kaltura.com/console), or enjoy full interactive experiences with our [workflows](https://developer.kaltura.com/workflows). 

And of course, feel free to reach out at vpaas@kaltura.com if you have any questions.

