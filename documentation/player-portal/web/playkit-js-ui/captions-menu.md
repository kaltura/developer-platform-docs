---
layout: page
title: Captions Menu Settings
weight: 110
---


## Removing style settings from the captions menu

The player enables viewers to modify the captions style using the **advanced captions settings** in the language menu, and then clicking the **set custom caption** button.

To prevent viewers from applying these modifications, overload the style option's class with **display:none**. 

For example, adding the line below will remove the ability to change the captions color:

{% highlight css %}
.playkit-font-color {
  display: none
}
{% endhighlight %}

See this list of caption settings classes below for detailed information about each class.

## Captions settings class list


| Class Name                             | Description                                          |
| -------------------------------------- | ---------------------------------------------------- |
| `.playkit-font-size`                   | Changes the size of the captions                    |
| `.playkit-font-color`                  | Changes the color of the captions                   |
| `.playkit-font-family`                 | Changes the font family of the captions             |
| `.playkit-font-style`                  | Changes the weight of the captions                  |
| `.playkit-font-opacity`                | Changes the opacity of the captions                 |
| `.playkit-background-color`            | Changes the color of the captions background        |
| `.playkit-background-opacity`          | Changes the opacity of the captions background      |