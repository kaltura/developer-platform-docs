---
layout: page
title: Manage Blackout Events
weight: 110
---

A blackout event is a construct that informs the [Kaltura events scheduling API](/Introduction-to-Scheduling-and-Managing-Resources.html) there should be no scheduled events during that time period.

## Create Blackout Event

At [scheduleEvent.add](https://developer.kaltura.com/console/service/scheduleEvent/action/add) one of the main scheduleEvent types is KalturaBlackoutScheduleEvent



<img src="/assets/images/blackout.png" style="zoom:30%;" />

Simply choose the time period of your blackout event and call [scheduleEvent.add](https://developer.kaltura.com/console/service/scheduleEvent/action/add) with necessary parameters.



## Handle Blackout Event

Scheduling conflicts are searched for using this code example:

```php
// To test for scheduling conflicts before assigning an existing resource to a new event, 
$schedulePlugin = KalturaScheduleClientPlugin::get($client);
$filter->systemNameEqual = $yourResourceSystemName;
$scheduledResource = $schedulePlugin->scheduleResource->listAction($filter)->objects[0];
$resourceIds = $scheduledResource->id;
$scheduleEventConflictType = KalturaScheduleEventConflictType::BOTH;
$testForSchedulingConflicts = $schedulePlugin->scheduleEvent->getConflicts($resourceIds, $scheduledEvent, null, $scheduleEventConflictType);
if ($testForSchedulingConflicts->totalCount == 0) {
	//It is safe to assign the resource to the event, no scheduling conflicts found.
} else {
    //Conflicts detected, this resource is already scheduled at this time. 
    //Please resolve conflicts before assigning it to another event at the same time.
}
```

Examine the line:

```php
$scheduleEventConflictType = KalturaScheduleEventConflictType::BOTH;
```

Which relies on the result of [scheduleEvent.getConflicts](https://developer.kaltura.com/console/service/scheduleEvent/action/getConflicts)

Where BOTH handles a RESOURCE_CONFLICT and a BLACKOUT_CONFLICT. Using an approach similar to this, you have the ability to distinguish BLACKOUT_CONFLICTS and could handle each CONFLICT type separately if needed.