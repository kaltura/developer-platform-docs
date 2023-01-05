---
layout: page
title: Kaltura Video Thumbnail and Image Transformation API
weight: 503
---

The Kaltura API provides a special thumbnail service, aimed at simplifying the creation of thumbnails on-the-fly from video and image entries. (To see the static thumbnail assets management API refer to the [thumbAsset](https://developer.kaltura.com/api-docs/#/thumbAsset).

The Thumbnail API provides simple means to dynamically transform (change size, cropping, etc.) image entries, and to generate images out of Kaltura video entries on the fly (while applying image transformations to the generated images).

The images are generated upon request (with caching on disk and via CDN) by calling the following URL format - 

```
https://cdnsecakmi.kaltura.com/p/{partner_id}/thumbnail/entry_id/{entry_id}
```

The result of the thumbnail API is an image with one or more of the following features:

* A re-sized / cropped version of the original thumbnail image.
* A specific frame from a video clip.
* An older version of the entry thumbnail.
* A various compression quality of the thumbnail image.

## Using the Thumbnail API  

The parameters are passed in the following form:

```
https://cdnsecakmi.kaltura.com/p/{partner_id}/thumbnail/entry_id/{entry_id}/paramX_name/paramX_value/...
```

1. Replace `{partner_id}` with your account ID (aka partnerId). 
1. Replace `{entry_id}` with the id of the desired entry thumbnail. 
1. Then append any of the parameters below according to the following format: `/paramX_name/paramX_value/...`.

> Please always ensure that a descriptive Alt text is specified when using thumbnails as image in web apps to ensure compatibility with screen readers and better search indexing.

## Thumbnail API Parameters  

| Parameter name       | Type          | Mandatory | Description                                                                                                                                                                                                                                                                                                                                                   |
|----------------------|---------------|-----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| entry_id             | String        | Yes       | The entry ID                                                                                                                                                                                                                                                                                                                                                  |
| widget_id            | String        | No        | The widget ID                                                                                                                                                                                                                                                                                                                                                 |
| version              | integer       | No        | The thumbnail version                                                                                                                                                                                                                                                                                                                                         |
| width                | integer       | No        | Requested width in pixels                                                                                                                                                                                                                                                                                                                                     |
| height               | integer       | No        | Requested height in pixels                                                                                                                                                                                                                                                                                                                                    |
| type                 | integer       | No        | Type of crop to be used – see remarks below                                                                                                                                                                                                                                                                                                                   |
| nearest_aspect_ratio | boolean (1/0) | No        | If 1, the image will be resized to nearest aspect ratio (based on the original image/video), and only then cropped to the desired dimensions. This will override the type parameter                                                                                                                                                                           |
| bgcolor              | string        | No        | 6 hex digits web color code                                                                                                                                                                                                                                                                                                                                   |
| quality              | string        | No        | JPEG quality for output (0-100). The default is 75                                                                                                                                                                                                                                                                                                            |
| src_x                | integer       | No        | 1st part of a rectangle to take from original picture                                                                                                                                                                                                                                                                                                         |
| src_y                | integer       | No        | 2nd part of a rectangle to take from original picture                                                                                                                                                                                                                                                                                                         |
| src_w                | integer       | No        | 3rd part of a rectangle to take from original picture                                                                                                                                                                                                                                                                                                         |
| src_h                | integer       | No        | 4th part of a rectangle to take from original picture                                                                                                                                                                                                                                                                                                         |
| rel_width            | integer       | No        | Actual width of the image from which the src_* parameters were taken                                                                                                                                                                                                                                                                                          |
| rel_height           | integer       | No        | Actual height of the image from which the src_* parameters were taken                                                                                                                                                                                                                                                                                         |
| vid_sec              | float         | No        | The time to snap a frame from the video (to get a specific frame # use; `second=frame/(durationSec * FPS)`                                                                                                                                                                                                                                                    |
| vid_slice            | integer       | No        | Number of slice out of number of slices                                                                                                                                                                                                                                                                                                                       |
| vid_slices           | integer       | No        | Number of slices                                                                                                                                                                                                                                                                                                                                              |
| start_sec            | float         | No        | The second (or part of second) to begin extracting the slices stripe from (e.g. to avoid black frame in videos that begin with fade to black, set start_sec to the second that is after the black transition). This param defaults to 0 if not set or invalid. If start_sec will be set to a higher number than end_sec, the API will return 404 error.       |
| end_sec              | float         | No        | The second (or part of second) to stop extracting slices at (e.g. to create a stripe animation that is smooth but only contains few frames, use this parameter to only extract a short segment of your video instead of extracting slices across the entire video). This param defaults to the duration of the video if not provided or set to invalid value. |
| upload_token_id      | string        | No        | An ID of an uploadToken object representing a file that was recently uploaded (upload tokens are invalid after 2 weeks) to generate the image from                                                                                                                                                                                                            |
| flavor_id            | integer       | No        | An ID of a specific video flavor to generate the image from                                                                                                                                                                                                                                                                                                   |
| format               | string        | No        | Specify an output file format for the generated image. Supported values are: WEBP, JPG, JPEG, JXR, PNG, PNG8/24/32/48/64, BMP, GIF, TIF, PSD, and PDF.                                                                                                                                                                                                              |
| ks                   | string        | No        | Kaltura Session string. Only mandatory if the account is configured to require session on thumbnails request                                                                                                                                                                                                                                                  |
| referrer             | string        | No        | base64 of a URL, use if entry's thumbnail access control is set to force domain                                                                                                                                                                                                                                                                               |
| file_name            | string        | No        | Used to specify a file name for the generated image. Must be the last parameter on the list to generate a URL that ends with a filename.extension                                                                                                                                                                                                             |


## Image editing parameters explained

To use the parameters, append each parameter name followed by the desired value in the following format: `/paramX_name/paramX_value/...`

For the examples below we will consider this as the original thumbnail we'll play with:

```
https://cdnapisec.kaltura.com/p/811441/thumbnail/entry_id/0_wf3km7rh
```

![Thumbnail without params](https://cdnapisec.kaltura.com/p/811441/thumbnail/entry_id/0_wf3km7rh)

> Note: If neither width nor height were specified, the resulting size will be 120x90 (default thumbnail size).

### Image Dimensions (Width, Height and Aspect Ratio)

* If both width and height were given a zero value the original image will be returned.
* If neither width nor height were specified, the resulting size will be 120x90 (default thumbnail size).
* If only width or height were specified, the given dimension combined with the type parameter will control the resulting size of the image.
* If vid_slices is provided without vid_slice the result will be a horizontal strip with the different slices.

#### The 'type' parameter controls the resize/cropping options:

* `type/1` - Resize maintaining the aspect ratio of the original video/image asset (overrides either width or height).
* `type/2` - Center the image within the given dimensions and fill the remaining space using the given background color.
* `type/3` - Crop the image to the given dimensions using the **center** of the image as gravity point, and fill the remaining space using the given background color.
* `type/4` - Crop the image to the given dimensions using the **top** of the image as gravity point, and fill the remaining space using the given background color.
* `type/5` - Stretch the image to desired dimensions.

#### Nearest Aspect Ratio

Pass `nearest_aspect_ratio/1` to indicate that the resizing engine should attempt resizing the image to the nearest aspect ratio of the original image (or video) before cropping the image to the specified dimensions. This will always result in an image that was scaled (resized) to maintain the aspect ratio of the original image dimensions (regardless of what was specified in the `type` parameter), and only then cropped to the desired dimensions.

For example:

```
// Consider this video thumbnail:
https://cdnapisec.kaltura.com/p/811441/thumbnail/entry_id/0_wf3km7rh/width/200/height/50/
// vs. this video thumbnail:
https://cdnapisec.kaltura.com/p/811441/thumbnail/entry_id/0_wf3km7rh/width/200/height/50/nearest_aspect_ratio/1
```


### Resizing  

The thumbnail with dimensions of 500 x 400 (with maintain aspect-ratio from original) and defined quality: (X is JPEG quality ranging from 0 to 100)

```
https://cdnapisec.kaltura.com/p/811441/thumbnail/entry_id/0_wf3km7rh/width/200/height/100/type/1/quality/X
```

| 10% Quality | 50% Quality | 100% Quality |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------:|------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
| ![Resized thumbnail to 200x100 and Quality of 10%](https://cdnapisec.kaltura.com/p/811441/thumbnail/entry_id/0_wf3km7rh/width/200/height/100/type/1/quality/10) | ![Resized thumbnail to 200x100 and Quality of 50%](https://cdnapisec.kaltura.com/p/811441/thumbnail/entry_id/0_wf3km7rh/width/200/height/100/type/1/quality/50) | ![Resized thumbnail to 200x100 and Quality of 100%](https://cdnapisec.kaltura.com/p/811441/thumbnail/entry_id/0_wf3km7rh/width/200/height/100/type/1/quality/100) |

> Note: The Quality parameter affects the compression value of the JPEG algorithm. To learn more about JPEG Compressions, visit the [JPEG entry on Wikipedia](http://en.wikipedia.org/wiki/JPEG#Effects_of_JPEG_compression).


### Using vid_sec parameter  

The vid_sec parameter allows us to capture a frame from a specific time in a video entry. 
vid_sec is a float, you can use decimal numbers to get particular frames from the video.
To get the time of a particular frame in the video, use the following formula: `frameSec = frameNumber / (durationSeconds * FPS)` .  
The following example shows capturing various frames in the video: 0 (first frame), 10th frame, 100th frame, 500th, 2,000th, and 4,000th.  

```
https://cfvod.kaltura.com/p/811441/thumbnail/entry_id/0_wf3km7rh/width/200/vid_sec/X
```

| Frame  | 0 (first frame)                                                                                                                   | 10th frame                                                                                                                                                          | 100th                                                                                                                                                             | 500th                                                                                                                                                           | 2,000th                                                                                                                                                           | 4,000th                                                                                                                                                         |
|--------|-----------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Second | 0                                                                                                                                 | 0.003252033                                                                                                                                                         | 0.032520325                                                                                                                                                       | 0.162601626                                                                                                                                                     | 0.650406504                                                                                                                                                       | 1.300813008                                                                                                                                                     |
| Image  | ![Thumbnail from the 0 second of the video](https://cfvod.kaltura.com/p/811441/thumbnail/entry_id/0_cm8rhiwp/width/120/vid_sec/0) | ![Thumbnail from the 0.0032520325203252 second of the video](https://cfvod.kaltura.com/p/811441/thumbnail/entry_id/0_cm8rhiwp/width/120/vid_sec/0.0032520325203252) | ![Thumbnail from the 0.032520325203252 second of the video](https://cfvod.kaltura.com/p/811441/thumbnail/entry_id/0_cm8rhiwp/width/120/vid_sec/0.032520325203252) | ![Thumbnail from the 0.16260162601626 second of the video](https://cfvod.kaltura.com/p/811441/thumbnail/entry_id/0_cm8rhiwp/width/120/vid_sec/0.16260162601626) | ![Thumbnail from the 0.650406504065041 second of the video](https://cfvod.kaltura.com/p/811441/thumbnail/entry_id/0_cm8rhiwp/width/120/vid_sec/0.650406504065041) | ![Thumbnail from the 1.30081300813008 second of the video](https://cfvod.kaltura.com/p/811441/thumbnail/entry_id/0_cm8rhiwp/width/120/vid_sec/1.30081300813008) |

> NOTE: If the given vid_sec is out of range, meaning, larger than the duration of the video, the returned thumbnail will be the last frame.  


### Cropping

Using the `src_x`, `src_y`, `src_w` and `src_h` parameters, it is possible to define a cropping rectangle, indicating the X and Y to position the rectangle at and W and H to indicate the size of the rectangle. The returned thumbnail will then be the pixels of the image that are within the defined rectangle.

| Source Thumbnail | Cropped (300, 100, 500, 400) |
|-------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ![Uncropped Thumbnail](https://cdnapisec.kaltura.com/p/811441/thumbnail/entry_id/0_wf3km7rh/width/200/vid_sec/10) | ![Cropped (300, 100, 500, 400)](https://cdnapisec.kaltura.com/p/811441/thumbnail/entry_id/0_wf3km7rh/width/200/height/200/vid_sec/10/src_x/300/src_y/100/src_w/500/src_h/400) |

> NOTE: To accurately calculate the dimension of the cropping rectangle, you should know the original video (source flavor) dimensions. In the above example, the dimensions were 1280 x 720. To avoid having to know the source dimensions, use the `rel_width` and `rel_height` parameters to define a "new-virtual-source-dimensions", the Thumbnail API will use resize the frame to these dimensions and then perform the cropping.


### Slicing

A more advanced use case of the Thumbnail API is to create "animated-thumbnails" where series of thumbnails from the video are shown in rotation one after another, creating the impression of a silent movie.

Slicing can also be used in advanced CSS techniques using sprites.

To learn how to put slicing together in a JavaScript based animated thumbnail, read: [How To Create a Video Thumbnail Rotator in JavaScript](/api-docs/Engage_and_Publish/how-create-video-thumbnail-rotator-javascript.html)

To create thumbnail slices, use the `vid_slices and vid_slice` parameters. `vid_slices` defines the number of frame-slices the video will be divided to and the `vid_slice` indicates the specific frame-slice to retrieve in that specific call (think of it as pager size and page number).

If vid_slices is provided without `vid_slice`, a stripe of all slices will be returned, which can be later used as CSS sprites.


| Slice #15 out of 90 | Slice #30 out of 90 | Slice #60 out of 90 | Slice #75 out of 90 |
|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ![Video Slice #15 from a series of 90 slices starting](https://cdnapisec.kaltura.com/p/811441/thumbnail/entry_id/0_wf3km7rh/width/200/height/100/vid_slices/90/vid_slice/15) | ![Video Slice #30 from a series of 90 slices starting](https://cdnapisec.kaltura.com/p/811441/thumbnail/entry_id/0_wf3km7rh/width/200/height/100/vid_slices/90/vid_slice/30) | ![Video Slice #60 from a series of 90 slices starting](https://cdnapisec.kaltura.com/p/811441/thumbnail/entry_id/0_wf3km7rh/width/200/height/100/vid_slices/90/vid_slice/60) | ![Video Slice #90 from a series of 90 slices starting](https://cdnapisec.kaltura.com/p/811441/thumbnail/entry_id/0_wf3km7rh/width/200/height/100/vid_slices/90/vid_slice/75) |


### Stripe of thumbnail slices (to be used as [CSS stripes](https://www.w3schools.com/css/css_image_sprites.asp))

To create a long stripe of thumbnail slices simply remove the `vid_slice` parameter: 

```
https://cdnapisec.kaltura.com/p/811441/thumbnail/entry_id/0_wf3km7rh/width/120/vid_slices/8/
```

![Stripe of 8 slices](https://cdnapisec.kaltura.com/p/811441/thumbnail/entry_id/0_wf3km7rh/width/120/vid_slices/8/widget_id/0)

> NOTE: The slices are 0 indexed. By default, the first slice in the series will always be 0. If you wish to extract a frames stripe from a shorter segment (clip) of your video, add the `start_sec` and `end_sec` params to indicate the segment of which the thumbnail stripe should be extracted from.
