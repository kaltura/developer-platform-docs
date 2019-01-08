---
layout: page
title: How To Create a Video Thumbnail Rotator in JavaScript
weight: 502
---

# Using the Kaltura Video Thumbnails Animator

Get the JS script and documentation from the [**Kaltura Video Thumbnails Animator github repo**](https://github.com/kaltura/VideoThumbnailAnimator).

This script provides a simple way to dynamically create video thumbnails using Kaltura's Image Transformation API with a tiny, single JS file. The script also including a low-rest blurred loading while the animation stripe loads in the backgroud.

To achieve responsive behavior and adpat to any dimensions, the script uses percentages based CSS logic to create the animated video thumbnails while using CSS stripes of the video animation frames created by the [Kaltura Thumbnail API](https://developer.kaltura.com/api-docs/Engage_and_Publish/kaltura-thumbnail-api.html/).  

### The percentages based backgroud image size/position logic

* Thumbnail Stripe Width in Percentage: total slices multiplied by 100. 
* Thumbnail Stripe X Position in Percentage: the total slices minus 1 (0-index) described as percent (100 divided by total slices minus 1), multiplied by the current slice nunmber (0-index). 

# Setting up
View-source on [`index.html`](https://kaltura.github.io/VideoThumbnailAnimator/) for a quick referecne example.
Include the ThumbAnimator script:
```html
<head>
  <script src="./KalturaThumbAnimator.js"></script>
</head>
<body>
   <div class="videothumbnail" kfps="4.5" kslices="30" kwidth="600" kpid="2421271" kentryid="1_fjqtp7ki" kquality="75" kcrop="2"></div>
  <script>
    var thumbAnimator = new KalturaThumbAnimator();
    thumbAnimator.setup("videothumbnail", "https://cfvod.kaltura.com", 1, true); //use blurred deffered loading
    thumbAnimator.setup("videothumbnail"); //regular load
  </script>
</body>
```
