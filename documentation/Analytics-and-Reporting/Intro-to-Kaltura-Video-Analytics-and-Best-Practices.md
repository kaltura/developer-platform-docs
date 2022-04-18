---
layout: page
title: Intro to Kaltura Video Analytics and Best Practices
weight: 110
---

The Kaltura Analytics API reports provide you with the insight you need to manage your content, reach your audience, and optimize your video workflow. You can view a quick snapshot of high-level figures, or drill down to user-specific or video-specific information. Use the analytics reports to gain business insights and understand user trends. 

## Report Service

Kaltura analytics data is exposed via the [`Report Service`](https://developer.kaltura.com/console/service/report).   
A number of actions within this service will enable you to pull data for Content, User Engagement, Bandwidth and Storage, and System. A specific set of filters will ensure you get the insights you need. 

You can follow the [Interactive Code Workflow,](https://developer.kaltura.com/workflows/Review_Media_Analytics/Analytics_Reports) or continue reading to learn about a few basic reports:

The Report API contains a couple of different actions for returning data. For the purpose of this doc, we will use [`report.getTable`](https://developer.kaltura.com/console/service/report/action/getTable), which returns an object of the insights data, as well as the respective column headers. Other actions include [`report.getGraphs`](https://developer.kaltura.com/console/service/report/action/getGraphs) which returns points for a graph UI, and [`report.getUrlForReportAsCsv`](https://developer.kaltura.com/console/service/report/action/getUrlForReportAsCsv), which produces a CSV report based on your given headers. 

For any `report.getTable` action, you need: 
- **reportType:** Object enum or integer (list of types found [here](https://developer.kaltura.com/api-docs/General_Objects/Enums/KalturaReportType)) that determines the type of report to produce 
- **reportInputFilter:** Can be of type `KalturaReportInputFilter` or `KalturaEndUserReportInputFilter`. It is required, and allows you to set date range, specific categories, keywords, or custom variables. 
- **pager:** Unlike some other Kaltura APIs, a pager is always required for this action. It contains the `pageIndex` and `pageSize` (number of results you'd like per page). 

Other optional parameters: 
- **objectIds:** For when you want to drill down on statistics for a specific entry or user. 
- **order:** Order by any column from the given results table

## Integrated Analytics Partners

Already using an analytics or audience measurement tool? Leverage the Kaltura pre-integrated plugins for all major analytics providers and consolidate your data securely and reliably.

To learn how to setup player plugins read: [Configuring Analytics Plugins](https://knowledge.kaltura.com/universal-studio-information-guide#configuring_analytics).

* [Youbora](https://knowledge.kaltura.com/node/1675)
* [comScore](http://player.kaltura.com/docs/ComscoreAnalytics)
* [Nielsen](http://player.kaltura.com/docs/NielsenVideoCensus)
* [Google Analytics](https://knowledge.kaltura.com/node/1148#googleanalytics)
* [Chartbeat](http://support.chartbeat.com/docs/video.html#kaltura)



