
# Webcasting Analytics 

Analytics for the livestream event can be retrieved via the [reporting](https://developer.kaltura.com/console/service/report/) API. The API actions are split between `getTable`, `getGraph`, `getTotal`, etc - depending on the format in which you'd like to receive the data. 

There is also a webcasting module that is part of  [Embedded Analytics Reports](../Analytics-and-Reporting /Embedded-Analytics-Reports.md) 

In this guide, the types of reports will be demonstrated using the [report.getTable](https://developer.kaltura.com/console/service/report/action/getTable) to make it easy to view results. 

If you scroll through the `reportType` field, you'll see that Realtime reports are those with REALTIME in the name, from 10001, to 10013. 

For an understanding of the reporting API, try the TOP_CONTENT report first. 
Note that reports always need a fromDay and toDay in the filter, as well as a pager. 

## TOP CONTENT 

A basic Top Content overview might look something like this: 

```python
report_type = KalturaReportType.TOP_CONTENT
report_input_filter = KalturaReportInputFilter()
report_input_filter.fromDay = "20200212"
report_input_filter.toDay = "20200514"

result = client.report.getTable(report_type, report_input_filter, pager)`
```

If you're using python, a print function for the results can be found [here](https://github.com/kaltura-vpaas/webcasting-app-python/blob/master/print-analytics.py)

## USERS_OVERVIEW_REALTIME

This is an overview on user engagement, best retrieved in small time frames with an interval of ten seconds, like so:

```python
report_type = KalturaReportType.USERS_OVERVIEW_REALTIME
report_input_filter = KalturaReportInputFilter()
pager = KalturaFilterPager()
report_input_filter.fromDay = "20200623"
report_input_filter.toDay = "20200624"
report_input_filter.interval = KalturaReportInterval.TEN_SECONDS


result = client.report.getTable(report_type, report_input_filter, pager, order)
printTable(vars(result), "USERS OVERVIEW REALTIME")
```

The result header will look like this:

```
|date_id|view_unique_audience|view_unique_engaged_users|views|avg_view_engagement|
```

## PLATFORMS REALTIME

The platforms report is a breakdown on which devices viewers are using to watch the livestream. You can even add `object_ids` to filter by entry ID. 

```python
report_type = KalturaReportType.PLATFORMS_REALTIME
report_input_filter = KalturaReportInputFilter()
response_options = KalturaReportResponseOptions()
report_input_filter.fromDay = "20200620"
report_input_filter.toDay = "20200624"
object_ids = "<ENTRY>"
result = client.report.getTable(report_type, report_input_filter, pager, order, object_ids)
printTable(vars(result), "PLATFORMS REALTIME")
```

The result header will look like this: 

```
+----------+----------------------+---------------+
|  device  | view_unique_audience | sum_view_time |
+----------+----------------------+---------------+
```

## BREAKDOWN PER USER 

The breakdown per user report shows the sum time viewed by user and how much buffering they encountered 

```python
report_type = KalturaReportType.ENTRY_LEVEL_USERS_DISCOVERY_REALTIME
report_input_filter = KalturaReportInputFilter()
report_input_filter.fromDay = "20200610"
report_input_filter.toDay = "20200630"
pager = KalturaFilterPager()
response_options = KalturaReportResponseOptions()

result = client.report.getTable(report_type, report_input_filter, pager)
```

The result header will look like this: 

```
|user_id|user_name|sum_view_time_live|sum_view_time_dvr|sum_view_time|avg_view_buffering | avg_view_engagement|view_buffer_time_ratio|
```

