---
layout: page
title: On-the-fly Video Thumbnails and Image Transformations
weight: 110
---

The Kaltura API provides a special thumbnail service, aimed at simplifying the creation of thumbnails on-the-fly from video and image entries. (For the static thumbnail assets management API refer to the [thumbAsset](https://developer.kaltura.com/api-docs/#/thumbAsset)) There is also a [legacy Thumbnail API]()

# Interactive Demo

Head over to the [interactive demo](https://kaltura-vpaas.github.io/ThumbnailStudio/demo/) to try any combination of transformations for the Thumbnail API

# Using the Thumbnail API

The Thumbnail API provides a simple means to dynamically transform (change size, crop, add text, apply filters, etc) image entries, and to generate images from Kaltura video entries on the fly.

The images are generated upon request (with caching on disk and via CDN) by calling the following URL format 

```
<serviceUrl>/api_v3/service/thumbnail_thumbnail/p/<partner_id>/action/transform/<transformString>
```

The images are generated upon request (with caching on disk and via CDN) by calling the following URL format. Example: https://cdnsecakmi.kaltura.com/api_v3/service/thumbnail_thumbnail/p/2306071/action/transform/transformString/id-1_4539f8pa,vidSec_s-3.2_w-1500_h-500

# **transformString**

transformString is a collection of transformSteps separated by '+'

`<transformStep>+<transformStep>`

The order in the transformString is important

![https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/p/2421271/action/transform/transformString/id-0_60gyd613,vidsec+id-0_uanuf4gk,vidsec_second-3,crop_height-700_width-1500_x-1_y--140_gravityPoint-5,resize_height-2500_width-0_blur-0_filterType-1,composite_x--800_y--150_opacity-100_compositetype-10](https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/p/2421271/action/transform/transformString/id-0_60gyd613,vidsec+id-0_uanuf4gk,vidsec_second-3,crop_height-700_width-1500_x-1_y--140_gravityPoint-5,resize_height-2500_width-0_blur-0_filterType-1,composite_x--800_y--150_opacity-100_compositetype-10)

https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/p/2421271/action/transform/transformString/id-0_60gyd613,vidsec+id-0_uanuf4gk,vidsec_second-3,crop_height-700_width-1500_x-1_y--140_gravityPoint-5,resize_height-2500_width-0_blur-0_filterType-1,composite_x--800_y--150_opacity-100_compositetype-10

This is an example using two `transformSteps` 

The first is `id-0_60gyd613,vidsec` and the second is added for a different video entry using `+` 

`id-0_uanuf4gk,vidsec_second-3,crop_height-700_width-1500_x-1_y--140_gravityPoint-5,resize_height-2500_width-0_blur-0_filterType-1,composite_x--800_y--150_opacity-100_compositetype-10`

This thumbnail was created using the [interactive demo](https://kaltura-vpaas.github.io/ThumbnailStudio/demo/) to easily lay out the two images and get the order of operations correct.

# **transformStep**

The transformStep format is `<source>,<sourceActions>,<imageActions>`

An example: 

<img src="https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/p/2421271/action/transform/transformString/id-0_60gyd613,vidsec_second-3,crop_height-500_width-500_gravityPoint-5" style="zoom:50%;" />

https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/p/2421271/action/transform/transformString/id-0_60gyd613,vidsec_second-3,crop_height-500_width-500_gravityPoint-5

Here the `<source>` is `id-0_60gyd613`

The `<sourceActions>` is `vidsec_second-3`

And the `<imageActions>` is `crop_height-500_width-500_gravityPoint-5`

# SourceActions

Source actions are used to transform a video source into an image

## VidSec

Picking a frame from a video by second

**Action name:** vidsec **alias:** vsec

**Parameters:**

| **Name** | **Description**                         | **Type** | **Mandatory** | **Aliases** | **Default value** |
| -------- | --------------------------------------- | -------- | ------------- | ----------- | ----------------- |
| second   | The time to snap a frame from the video | float    | Yes           | s, sec      | -                 |
| Height   | Requested height in pixels              | Int      | No            | h           | -                 |
| Width    | Requested width in pixels               | Int      | No            | w           | -                 |

-  example:

vidsec_s-1.1

- URL full example:

https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/p/2306071/action/transform/transformString/id-1_4539f8pa,vidSec_s-1.1

https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/p/2306071/action/transform/transformString/id-1_4539f8pa,vidSec_s-20_w-500_h-250

## **Vid Slice**

Picking a frame by dividing the video into slices and then pick the slice

**Action name:** vidSlice **Alias:** vslice

**Parameters:**

| **Name**       | **Description**                                              | **Type** | **Mandatory** | **Aliases** | **Default value** |
| -------------- | ------------------------------------------------------------ | -------- | ------------- | ----------- | ----------------- |
| numberofslices | Number of slices to split the video                          | Int      | Yes           | nos         | -                 |
| sliceNumber    | Number of slice out of slices                                | Int      | Yes           | sn          | -                 |
| Height         | Requested height in pixels                                   | Int      | No            | h           | -                 |
| width          | Requested width in pixels                                    | Int      | No            | w           | -                 |
| startSec       | The second (or part of second) to begin extracting the slices stripe from (e.g. to avoid black frame in videos that begin with fade to black, set start_sec to the second that is after the black transition). | Float    | No            | ss          | 0                 |
| endSec         | The second (or part of second) to stop extracting slices at (e.g. to create a stripe animation that is smooth but only contains few frames, use this parameter to only extract a short segment of your video instead of extracting slices across the entire video | Float    | No            | es          | -                 |

 

- example:

vslice_nos-13_sn-4

- URL full examples:

https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/p/2306071/action/transform/transformString/id-1_4539f8pa,vslice_nos-10_sn-4
https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/p/2306071/action/transform/transformString/id-1_4539f8pa,vidSlice_nos-20_sn-11_ss-1_se-11

## **VidStrip**

Splitting the video into slices and glue them into one image

**Action name:** vidStrip **Alias:** vstrip

**Parameters:**

| **Name**       | **Description**                                              | **Type** | **Mandatory** | **Aliases** | **Default value** |
| -------------- | ------------------------------------------------------------ | -------- | ------------- | ----------- | ----------------- |
| numberofslices | the number of slices to split the video                      | Int      | Yes           | nos         | -                 |
| Height         | Requested height in pixels                                   | Int      | No            | h           | -                 |
| Width          | Requested width in pixels                                    | Int      | No            | w           | -                 |
| startSec       | The second (or part of second) to begin extracting the slices stripe from (e.g. to avoid black frame in videos that begin with fade to black, set start_sec to the second that is after the black transition). | Float    | No            | ss          | 0                 |
| endSec         | The second (or part of second) to stop extracting slices at (e.g. to create a stripe animation that is smooth but only contains few frames, use this parameter to only extract a short segment of your video instead of extracting slices across the entire video | Float    | No            | es          | -                 |

 

- example:

vstrip_nos-13

- URL full examples:

https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/p/2306071/action/transform/transformString/id-1_4539f8pa,vstrip_nos-5

https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/p/2306071/action/transform/transformString/id-1_4539f8pa,vstrip_nos-10_endSec-30_w-200_h-100



# ImageActions

Actions to manipulate the image

## **Crop**

Crop the image into a smaller one

**Action name:** crop **Alias:** c

**Parameters:**

| **Name**     | **Description**                              | **Type** | **Mandatory**                   | **Aliases** | **Default value** |
| ------------ | -------------------------------------------- | -------- | ------------------------------- | ----------- | ----------------- |
| gravityPoint | The gravity point to where to crop the image | Int      | No if x and y are supplied      | gp          | -                 |
| Height       | The required height                          | Int      | No                              | h           | -                 |
| Width        | The required width                           | Int      | No                              | w           | -                 |
| x            | crop to start from specific x coordinate     | Int      | No if gravity point is supplied | -           | -                 |
| y            | crop to start from specific y coordinate     | Int      | No if gravity point is supplied | -           | -                 |

- gravityPoint can be 1-9 1- northwest, 2 - north, 3 - northeast, 4- west, 5 - center, 6 - east, 7 - southwest, 8 - south, 9 - southeast
- example:

c_w-140_h-120_x-50_y-40

- URL full examples:

https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/p/2306071/action/transform/transformString/id-1_4539f8pa,vidSlice_Nos-10_sn-3_ss-0_es-20,c_x-50_y-50_w-200_h-200_x-100_y-100

[https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/action/transform/p/2306071/transformString/id-1_7anel7ez,c_gp-5_w-200_h-200](https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/action/transform/p/2306071/transformString/id-1_7anel7ez,c_gp-0_w-200_h-200)

## **resize**

Changing the image dimensions

**Action name:** resize **Alias:** re

**Parameters:**

| **Name** | **Description**     | **Type** | **Mandatory**                                                | **Aliases** | **Default value** |
| -------- | ------------------- | -------- | ------------------------------------------------------------ | ----------- | ----------------- |
| height   | The required height | Int      | Yes unless cf is suppliedYou can pass 0 for proportional scalingIf bf isn’t supplied | h           | -                 |
| Width    | The required width  | Int      | Yes unless cf is suppliedYou can pass 0 for proportional scalingIf bf isn’t supplied | w           | -                 |

**Advanced parameters:**

| **Name**     | **Description**                                              | **Type** | **Mandatory** | **Aliases** | **Default value** |
| ------------ | ------------------------------------------------------------ | -------- | ------------- | ----------- | ----------------- |
| Blur         | The blur factor where > 1 is blurry, < 1 is sharp.Only relevant if we resizing to a smaller size | Float    | No            | b           | -                 |
| filterType   | See [Filter List](#Filter List)                              | Int      | No            | ft          | -                 |
| bestFit      | Optional fit parameter                                       | Bool     | No            | bf          | -                 |
| compositeFit | Trying to scale the image to the previous tranformationStep image | Bool     | No            | cf          | -                 |

 

- example:

resize_w-200_h-200

- URL full examples:

https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/action/transform/p/2306071/transformString/id-1_7anel7ez,re_w-500_h-0

https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/action/transform/p/2306071/transformString/id-1_7anel7ez,re_w-50_h-10_bf_b-0.9

## **roundcorners**

Rounding the corners

**Action name:** roundcorners **Alias:** rc

**Parameters:**

| **Name**  | **Description** | **Type** | **Mandatory** | **Aliases** | **Default value** |
| --------- | --------------- | -------- | ------------- | ----------- | ----------------- |
| xRounding | x rounding      | float    | Yes           | x, xr       | -                 |
| yRounding | y rounding      | float    | Yes           | y, yr       | -                 |

**Advanced parameters:**

| **Name**        | **Description**       | **Type** | **Mandatory** | **Aliases** | **Default value** |
| --------------- | --------------------- | -------- | ------------- | ----------- | ----------------- |
| strokeWidth     | stroke width          | float    | No            | sw          | 10                |
| displace        | image displace        | float    | No            | d           | 5                 |
| sizeCorrection  | size correction       | float    | No            | sc          | -6                |
| backgroundColor | color for the corners | color    | No            | bg          | black             |

- example:

rc_x-100_y-100

- URL full examples:

https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/action/transform/p/2306071/transformString/id-1_7anel7ez,rc_x-200_y-100_bg-white_sw--50_sc-10_d-20

https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/action/transform/p/2306071/transformString/id-1_fgy9sh8i,vidsec_s-10,rc_x-200_y-100_bg-red

## **Rotate**

Rotating the image

**Action name:**rotate **Alias:**r

**Parameters:**

| **Name**        | **Description**                                              | **Type** | **Mandatory** | **Aliases** | **Default value** |
| --------------- | ------------------------------------------------------------ | -------- | ------------- | ----------- | ----------------- |
| degrees         | degrees to turn                                              | int      | Yes           | d, deg      | -                 |
| backgroundColor | Color to fill empty space created by the rotationcolor string without # like "fff" or fixed names like "red","blue" | string   | Yes           | b, bg       | black             |

- example:

r_deg-90_b-fff

- URL full examples:

https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/action/transform/p/2306071/transformString/id-1_fgy9sh8i,vidsec_s-10,r_d-90

https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/action/transform/p/2306071/transformString/id-1_fgy9sh8i,vidsec_s-10,r_d-60_bg-pink

https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/action/transform/p/2306071/transformString/id-1_fgy9sh8i,vidsec_s-10,r_d-222_bg-fff124

## Text

Adding a text on the image

**Action name:** text **Alias:** t, txt

**Parameters**:

| Name        | Description                                                | Type                           | Mandatory | Aliases | Default value |
| ----------- | ---------------------------------------------------------- | ------------------------------ | --------- | ------- | ------------- |
| text        | The text, it must be URL encoded                           | string                         | Yes       | t, txt  | -             |
| font        | See [Font List](#Font List)                                | string                         | No        | f       | Courier       |
| fontSize    | The font size                                              | float                          | No        | fs      | 10            |
| strokeWidth | Stroke width                                               | float                          | No        | sw      | 1             |
| x           | Horizontal offset in pixels to the left of the text        | int                            | No        | -       | 0             |
| y           | Vertical offset in pixels to the baseline of the text      | int                            | No        | -       | 10            |
| angle       | The angle to write the text                                | float                          | No        | a       | 0             |
| maxHeight   | If you want to limit the textbox                           | int                            | No        | mh      | -             |
| maxWidth    | If you want to limit the textbox, it will try to word warp | int                            | No        | mw      | -             |
| strokeColor | Stroke color                                               | color string or code without # | No        | sc      | black         |
| fillColor   | Fill color                                                 | color string or code without # | No        | fc      | black         |

- See section 7 for supported font list
- example:

t_text-test2_fs-40_y-80_x-35

- URL full examples:

https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/action/transform/p/2306071/transformString/id-1_fgy9sh8i,vidsec_s-10,t_t-Fire_fs-90_fc-red_y-100_x-200

[https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/action/transform/p/2306071/transformString/id-1_fgy9sh8i,vidsec_s-5,txt_t-An%20example%20_fs-40_sc-green_y-50_x-200_a-90](https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/action/transform/p/2306071/transformString/id-1_fgy9sh8i,vidsec_s-5,txt_t-An example _fs-40_sc-green_y-50_x-200_a-90)

## **Filter**

Applying predefined filters on the image

**Action name:**filter **Alias:**f

**Parameters:**

| Name       | Description        | Type   | Mandatory | Aliases | Default value |
| ---------- | ------------------ | ------ | --------- | ------- | ------------- |
| filterType | the desired filter | string | Yes       | f, ft   | -             |

Current filter type options are

blueshift, charcoal, contrast, edge, oil, polaroid, raise, sepia, shade, solarize, vignette, wave

- Example

[filter_f-shade](http://zuronprem2/api_v3/service/thumbnail_thumbnail/action/transform/p/212/transformString/id-0_rk73kvqj,filter_f-shade/nocache/1)

- URL full examples

https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/action/transform/p/2306071/transformString/id-1_4539f8pa,vidsec_s-10,filter_filtertype-wave

https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/action/transform/p/2306071/transformString/id-1_4539f8pa,vidsec_s-11.2,filter_filtertype-shade

## **Image texture text**

Creating a text with thumbnail image as texture

**Action name:** imageTextureText **Alias:** itt

**Parameters**:

| Name        | Description                                           | Type   | Mandatory | Aliases | Default value |
| ----------- | ----------------------------------------------------- | ------ | --------- | ------- | ------------- |
| text        | The text, it must be URL encoded                      | string | Yes       | t, txt  | -             |
| font        | Name of the font case sensitive                       | string | No        | f       | Courier       |
| fontSize    | The font size                                         | float  | No        | fs      | 10            |
| strokeWidth | Stroke width                                          | float  | No        | sw      | 1             |
| x           | Horizontal offset in pixels to the left of the text   | int    | No        | -       | 0             |
| y           | Vertical offset in pixels to the baseline of the text | int    | No        | -       | 10            |
| angle       | The angle to write the text                           | float  | No        | a       | 0             |

- See below for supported font list
- Example

itt_text-test_fs-40_y-80_x-35

- URL full examples

[https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/p/2306071/action/transform/transformString/id-1_4539f8pa,vidSlice_Nos-10_sn-1_ss-0_es-10,itt_t-test%20test_fs-50_x-200_y-100_sw-5_a-45_mw-10](https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/p/2306071/action/transform/transformString/id-1_4539f8pa,vidSlice_Nos-10_sn-1_ss-0_es-10,itt_t-test test_fs-50_x-200_y-100_sw-5_a-45_mw-10)

https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/action/transform/p/2306071/transformString/id-1_fgy9sh8i,vidsec_s-5,itt_text-candle_fs-180_y-250_x-105_sw-10

## **Composite**

**Action name**: composite **Alias**: comp
**Parameters**:

| Name    | Description                                               | Type | Mandatory | Aliases | Default value |
| ------- | --------------------------------------------------------- | ---- | --------- | ------- | ------------- |
| x       | The column offset of the composited image                 | Int  | No        | -       | 0             |
| y       | The row offset of the composited image                    | Int  | No        | -       | 0             |
| opacity | the opacity of the added image value can be between 1-100 | Int  | No        | op      | -             |

**Advanced parameters:**

| **Name**      | **Description**                                              | **Type** | **Mandatory** | **Aliases** | **Default value** |
| ------------- | ------------------------------------------------------------ | -------- | ------------- | ----------- | ----------------- |
| compositetype | See [Composite Type List](#Composite Type List)              | Int      | No            | ct          | -                 |
| channel       | See [Channel Type List](#Channel Type List) provide any channel constant that is valid for your channel modeTo apply to more than one channel, combine channeltype constants using bitwise operators | Int      | No            | ch          | -                 |

- This action can’t be part of the first transformation step
- If you have more than one transformation step this action become mandatory for the non-first steps
- Example

comp_op-50

- URL full examples

https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/action/transform/p/2306071/transformString/id-1_7anel7ez+id-1_fgy9sh8i,vidsec_s-5,itt_text-erez_fs-180_y-250_x-95_sw-10,comp_x-10_y--30

https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/action/transform/p/2306071/transformString/id-1_4539f8pa,vidsec_s-5+id-1_7anel7ez,re_h-200_w-300,r_d-10_bg-none,comp_x-1130_y-230

 

## **Output**

Modify the image output parameters

**Action name:** output **Alias:** o, io, output, imageoutput

**Parameters:**

| **Name** | **Description**               | **Type** | **Mandatory** | **Aliases** | **Default value** |
| -------- | ----------------------------- | -------- | ------------- | ----------- | ----------------- |
| format   | the image format              | string   | No            | f           | JPEG              |
| quality  | the image compression quality | Int      | No            | q           | 75                |

- example:

o_q-50_f-JPEG

- URL full examples:

[https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/p/2306071/action/transform/transformString/id-1_4539f8pa,vidSlice_Nos-10_sn-3_ss-0_es-20,o_q-50](https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/p/2306071/action/transform/transformString/id-1_4539f8pa,vidSlice_Nos-10_sn-3_ss-0_es-20,o_q-50_d-50)

https://www.kaltura.com/api_v3/service/thumbnail_thumbnail/action/transform/p/2306071/transformString/id-1_7anel7ez,o_f-PNG

# **Font List**

We currently support the following fonts:

AvantGarde-Book, AvantGarde-BookOblique, AvantGarde-Demi, AvantGarde-DemiOblique, Bookman-Demi, Bookman-DemiItalic, Bookman-Light, Bookman-LightItalic, Courier, Courier-Bold, Courier-BoldOblique, Courier-Oblique, fixed, Helvetica, Helvetica-Bold, Helvetica-BoldOblique, Helvetica-Narrow, Helvetica-Narrow-Bold, Helvetica-Narrow-BoldOblique, Helvetica-Narrow-Oblique, Helvetica-Oblique, NewCenturySchlbk-Bold, NewCenturySchlbk-BoldItalic, NewCenturySchlbk-Italic, NewCenturySchlbk-Roman, Palatino-Bold, Palatino-BoldItalic, Palatino-Italic, Palatino-Roman, Symbol, Times-Bold, Times-BoldItalic, Times-Italic, Times-Roman, DejaVu-Sans-Bold, DejaVu-Sans-Mono-Bold, DejaVu-Serif-Bold, symbol

- Please notice the fonts are case sensitive



# Filter List

|   Filter   |Value     |
| ---- | ---- |
|UNDEFINED  |1|
|POINT      |2|
|BOX        |3|
|TRIANGLE   |4|
|HERMITE    |5|
|HANNING    |6|
|HAMMING    |7|
|BLACKMAN   |8|
|GAUSSIAN   |9|
|QUADRATIC  |10|
|CUBIC      |11|
|CATROM     |12|
|MITCHELL   |13|
|LANCZOS    |14|
|BESSEL     |15|
|SINC       |16|



# Composite Type List

|Filter         |Value| Description |
|---------------|-----|-------------|
|DEFAULT        |54|The default composite operator||
|UNDEFINED      |0 |Undefined composite operator|
|NO             |52|No composite operator defined|
|ATOP           |2 |The result is the same shape as image, with composite image obscuring image where the image shapes overlap|
|BLEND          |3 |Blends the image|
|BUMPMAP        |5 |The same as COMPOSITE_MULTIPLY, except the source is converted to grayscale first.|
|CLEAR          |7 |Makes the target image transparent|
|COLORBURN      |8 |Darkens the destination image to reflect the source image|
|COLORDODGE     |9 |Brightens the destination image to reflect the source image|
|COLORIZE       |10|Colorizes the target image using the composite image|
|COPYBLACK      |11|Copies black from the source to target|
|COPYBLUE       |12|Copies blue from the source to target|
|COPY           |13|Copies the source image on the target image|
|COPYCYAN       |14|Copies cyan from the source to target|
|COPYGREEN      |15|Copies green from the source to target|
|COPYMAGENTA    |16|Copies magenta from the source to target|
|COPYOPACITY    |17|Copies opacity from the source to target|
|COPYRED        |18|Copies red from the source to target|
|COPYYELLOW     |19|Copies yellow from the source to target|
|DARKEN         |20|Darkens the target image|
|DSTATOP        |28|The part of the destination lying inside of the source is composited over the source and replaces the destination|
|DST            |29|The target is left untouched|
|DSTIN          |30|The parts inside the source replace the target|
|DSTOUT         |31|The parts outside the source replace the target|
|DSTOVER        |32|Target replaces the source|
|DIFFERENCE     |22|Subtracts the darker of the two constituent colors from the lighter|
|DISPLACE       |23|Shifts target image pixels as defined by the source|
|DISSOLVE       |24|Dissolves the source in to the target|
|EXCLUSION      |33|Produces an effect similar to that of DIFFERENCE, but appears as lower contrast|
|HARDLIGHT      |34|Multiplies or screens the colors, dependent on the source color value|
|HUE            |36|Modifies the hue of the target as defined by source|
|IN             |37|Composites source into the target|
|LIGHTEN        |39|Lightens the target as defined by source|
|LUMINIZE       |44|Luminizes the target as defined by source|
|MODULATE       |48|Modulates the target brightness, saturation and hue as defined by source|
|MULTIPLY       |51|Multiplies the target to the source|
|OUT            |53|Composites outer parts of the source on the target|
|OVER           |54|Composites source over the target|
|OVERLAY        |55|Overlays the source on the target|
|PLUS           |58|Adds the source to the target|
|REPLACE        |59|Replaces the target with the source|
|SATURATE       |60|Saturates the target as defined by the source|
|SCREEN         |61|The source and destination are complemented and then multiplied and then replace the destination|
|SOFTLIGHT      |62|Darkens or lightens the colors, dependent on the source|
|SRCATOP        |63|The part of the source lying inside of the destination is composited onto the destination|
|SRC            |64|The source is copied to the destination|
|SRCIN          |65|The part of the source lying inside of the destination replaces the destination|
|SRCOUT         |66|The part of the source lying outside of the destination replaces the destination|
|SRCOVER        |67|The source replaces the destination|
|THRESHOLD      |68|The source is composited on the target as defined by source threshold|
|XOR            |70|The part of the source that lies outside of the destination is combined with the part of the destination that lies outside of the source|



# Channel Type List

|Channel |Value|
|-----|-----|
|UNDEFINED |0|
|RED |1|
|GRAY |2|
|CYAN |3|
|GREEN |4|
|MAGENTA |5|
|BLUE |6|
|YELLOW |7|
|ALPHA |8|
|OPACITY |16|
|BLACK |25|
|INDEX |32|
|ALL |134217727|
|DEFAULT| 134217727|