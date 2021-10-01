---
layout: page
title: Common Analytics Reports
weight: 110
---

So you want basic insights on how much engagement your entries have been drawing in the last month, like how many times the video has been loaded and then actually played, and when users are likely to drop-off. In the example below, we set the `reportType` to Top Content (1), the date range to the entire month of October, and a page size of 20. The result contains a list of entries and their statistics.

{% code_example analytics1 %}
&nbsp;

The result header looks like this: 

{% highlight csv %}
object_id,entry_name,count_plays,sum_time_viewed,avg_time_viewed,count_loads,load_play_ratio,avg_view_drop_off
{% endhighlight %}

Maybe you only want insights for a particular *channel* in your media. In this case you'd set `categories` on the filter to the *full name* of your category, which can be found in the KMC by hovering over the category name, OR by calling `category.get` action with the category ID. The full name of the category usually includes its parent directories. 

{% code_example analytics2 %}
&nbsp;

If you set `objectIds` as one of the entries from the results, change the reportType to User Engagement (11), and set the filter to an End User filter, you'd get specific user engagement stats on that entry: 

{% code_example analytics3 %}
&nbsp;

The result header looks like this: 

{% highlight csv %}
name,unique_videos,count_plays,sum_time_viewed,avg_time_viewed,avg_view_drop_off,count_loads,load_play_ratio
{% endhighlight %}

## User Reports 

Perhaps you're interested in which employees at the company have contributed the most videos. In the example below, we set the `reportType` to Top Contributors (5) and order by the total count. 

{% code_example analytics4 %}
&nbsp;

Result header: 

{% highlight csv %}
object_id,name,count_total,count_video,count_audio,count_image,count_mix
{% endhighlight %}

You can also get engagement insights by **geographic region**, by changing the `reportType` to Map Overlay (4). Setting the `objectIds` to one of the regions from the results will break down those insights by city. 

{% code_example analytics5 %}


Result header: 

{% highlight csv %}
object_id,location_name,count_plays,count_plays_25,count_plays_50,count_plays_75,count_plays_100,play_through_ratio
{% endhighlight %}

As you can see, there are many ways to customize your report based on your business use cases. You can easily try them out using our [Interactive Console](https://developer.kaltura.com/console/service/report/action/getTable) or see what they look like in the [KMC](https://kmc.kaltura.com/index.php/kmc/kmc4#analytics\|contentDashboard). 