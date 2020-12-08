---
layout: page
title: Kaltura Virtual Meeting Rooms Overview
weight: 102
---
# Kaltura Virtual Meeting Rooms Overview

Kaltura Meetings, via the acquisition of Newrow, allows for live video collaboration tools, such as classrooms, events, and webinars, to be built directly into your applications, using components of the Kaltura API. 

This guide will walk you through the steps of creating a **virtual meeting room URL**, which you can embed into your webpage with an iFrame. 

## Before You Begin 

To use the Kaltura API, you'll need a Kaltura account and credentials. The important credentials can be found in the [Integration Settings]( https://kmc.kaltura.com/index.php/kmcng/settings/integrationSettings) in your KMC. 

You might want to download a [Kaltura Client Library](https://developer.kaltura.com/api-docs/Client_Libraries/) of your choice, although you can also use the [developer console](https://developer.kaltura.com/console) for all the operations  below. 

This integration will be using your KAF endpoint, which should contain your Partner ID. If you're not sure whether you have a KAF endpoint or whether "Newrow" has been enabled on your account, speak to your account rep or email us at vpaas@kaltura.com.

You can refer to this demo app: https://github.com/kaltura-vpaas/liveroom_manager

### Overview

A virtual meeting room is represented as a `KalturaLocationScheduleResource` and we refer to it as a `resource` for short. A scheduled session is represented by a `KalturaRecordScheduleEvent`. One resource can be used for many different events, but an event will only be associated with one resource. The room will be launched using an embed link that is made up of a Kaltura Session with specific configurations, all of which will be discussed below. 

<img src="/assets/images/newrow_room.png" alt="newrow_room" style="zoom:40%;" />

## Creating an Admin Session 

A Kaltura Session is an identification string that authorizes calls to the Kaltura API. You'll need one to create the resource and event objects. If you're logged into the [developer portal](https://developer.kaltura.com), you're already authenticated. However, if you're calling the Kaltura API using a client library, you'll need to create the string yourself using the [`session.start`](https://developer.kaltura.com/console/service/session/action/start) API. 

You can find the necessary credentials in your KMC [Integration Settings](https://kmc.kaltura.com/index.php/kmcng/settings/integrationSettings). You'll use your ADMIN Secret for this operation. 

### Example 

```php
  $secret = "xxxxx"
  $userId = "your-email-address";
  $type = KalturaSessionType::ADMIN;
  $partnerId = 1234567;
  $expiry = 86400;
```

You'll set this KS on the Client that handles all the operations detailed below. 

## Creating a Resource 

A virtual meeting room is also referred to as a "resource" which is short for `KalturaLocationScheduleResource`

You can create a resource using the [`scheduleResource.add`](https://developer.kaltura.com/console/service/scheduleResource/action/add) action, which will return a `KalturaLocationScheduleResource` object. 
The resource *must* have a name, and it should include **tags** of `vcprovider:newrow` in order to be recognized as a virtual meeting room. 

Once created, the response will return an `id`, which you should hold on to.  However, if you've lost track of it - no worries. You can see all of your scheduled resources by calling [`scheduleResource.list`](https://developer.kaltura.com/console/service/scheduleResource/action/list). 

**Note: you should be using an ADMIN Kaltura Session for this creation.**

### Required Parameters 

- **name**: (string) room name 
- **tags**: `vcprovider:newrow`
  
### Optional Parameters 

- **systemName**: (string) 
- **description**: (string) 

### Tags / Adding Playlists 

You must include tag  `vcprovider:newrow` in order to create a virtual meeting room and distinguish from other types of resources.

Tags can also include the URL for a logo or optional parameters for initializing the virtual room with a predefined playlist. Note that the playlist feature is not enabled by default.

| Key  | Type  | Value |
|---|---|---|
| custom_playlist_id  | integer  | Playlist ID to load in this resource |
| custom_playlist_name  | string | Playlist Name to load. Used only if Playlist ID was not passed |
| custom_reset_playlist_instance | boolean | **(default) 1:** creates a new playlist instance if the ID is already loaded in the room. **0:** does not reset playlist instance |
| custom_company_logo | string | URL-encoded string of the logo URL |


### Example
```php
    $schedulePlugin = KalturaScheduleClientPlugin::get($client);
    $scheduleResource = new KalturaLocationScheduleResource();
    $scheduleResource->description = "My first meeting room";
    $scheduleResource->name = "Room-1";
    $scheduleResource->tags = "vcprovider:newrow";

    $result = $schedulePlugin->scheduleResource->add($scheduleResource);
```

#### Response Object 
```json
{
  "id": 1100601,
  "partnerId": 1234567,
  "name": "Room-1",
  "description": "My first meeting room",
  "status": 2,
  "tags": "vcprovider:newrow",
  "createdAt": 1586100234,
  "updatedAt": 1586100234,
  "objectType": "KalturaLocationScheduleResource"
}
```

### Tags  

An event can also include room settings, such as auto-recording, by passing  **tags** as comma-separated key-value-pairs. Tags are optional, and can also be set on the resource.
**Note that any settings on the event will override those of the resource.**

| Key  | Type  | Default  | Other |
|---|---|---|---|
| custom_rec_auto_start  | boolean  | **0:** Auto-start recording is disabled | **1:** Start recording automatically when instructor joins.  **Note that session recordings will be as long as the event duration.** |
| custom_rec_set_reminder  | boolean | **0:** Recording reminder is disabled | **1:** Enable recording reminder prompt once instructor has been in the room for two minutes |
| custom_rs_show_participant  | boolean  | **1:** Show participant list for students and guests | **0:** Hide participant list for students and guests  |
| custom_rs_show_invite  | boolean  | **1:** Show invite option for moderators and instructors  | **0:** Hide invite option for moderators and instructors |
| custom_rs_show_chat  | boolean  | **1:** Enable chat for students and guests  | **0:** Disable chat for students and guests  |
| custom_rs_enable_guests_to_join  | boolean  | **1:** Enable guests to join with invite link  | **0:** Block guests from joining by invite link  |
| custom_rs_class_mode  | string  | **virtual_classroom:** Set room to be in virtual meeting room mode, where users are automatically set to Live and prompted to activate webcams | **webinar:** Set room to webinar mode, where users are not live |
| custom_rs_show_chat_moderators  | boolean  | **1:** Enable moderator chat | **0:** Disable moderator chat |
| custom_rs_show_chat_questions  | boolean  | **1:** Enable Q&A for students and guests | **0:** Disable Q&A for students and guests |
| custom_rs_show_language_selection  | boolean  | **1:** Show "Select Language" in options menu | **0:** Hide "Select Language" in options menu |
| custom_rs_enable_media_library  | boolean  | **1:** Show "Video Library" in tools | **0:** Hide "Video Library" in tools |
| custom_rs_hide_end_session  | boolean  | **0:** Show "End Session" button, which ends the session for all participants | **1:** Hide "End Session" button |
| custom_rs_hide_leave_session  | boolean  | **0:** Show "Leave Session" button, which ends the session for the user | **1:** Hide "Leave Session" button |

#### Language Settings 

Adding a tag of `custom_rs_user_lang` will force the locale language in the room. Supported languages: 
- fr-FR French (France)
- de-DE German
- ko-KR Korean
- pt-BR Portuguese (Brazil)
- ja-JP Japanese
- en-US English (US)
- zh-CN Simplified Chinese (China)
- it-IT Italian
- es-LA Spanish
- he-IL Hebrew
- **en-VE** (special locale for corporate-style events, where the education lingo is less relevant)

## Creating a Kaltura Session 

A Kaltura Session (KS) identifies the user and contains permissions for a given virtual meeting room. 

We'll create the KS by using the [session.start](https://developer.kaltura.com/console/service/session/action/start) action. You'll need:
- Your `PartnerID` from the [integration settings](https://kmc.kaltura.com/index.php/kmcng/settings/integrationSettings) in your KMC
- The **USER** `Secret` from the [integration settings](https://kmc.kaltura.com/index.php/kmcng/settings/integrationSettings) in your KMC
- `userId`, which can be any identifying string, but must be unique to each user in the room 
- `privileges` string, described below

>Tip: if you're logged into the [developer.portal](https://developer.kaltura.com), you can find your credentials by clicking your account at the top right corner and then **View Secrets**


### The Privileges String 

The virtual room settings will be passed into the `privileges` parameter, which is a comma-separated key-value string, much like the **tags** above. It contains information about context, privacy, and even user details.  

In the context of virtual rooms, the string *must* include a `role`, and either a `resourceId` or an `eventId`. 
**If only EventId is set,** the resourceId will be retrieved automatically. 
**If only resourceId is set**, the outcome will be determined by the settings in `userContextualRole`. If the user is a moderator, this will allow entry to the room to prepare materials and content. 
For a regular attendee, entry will only be allowed if the moderator is already in the room. 

| Key  | Required  | Description |
|---|---|---|
| eventId  | yes, if `resourceId` not set  | ID of the event |
| resourceId  | yes, if `eventId` not set | ID of the resource |
| role | yes | `viewerRole` for attendees / `adminRole` for moderator |
| userContextualRole  | no | **0** for instructor / **3** for attendees/guests. |
| firstName | no | first name to appear in participants list|
| lastName | no | last name to appear in participants list |

**Note that `userContextualRole` is what determines a user's permissions in the virtual room. If `userContextualRole` is not set, the role will be set to attendee/guest.**

### Examples 

Below are examples of creating a Kaltura Session in various scenarios. Their expiry time, which is currently set to 86400ms (one day), can be changed to accommodate the security settings of your application. 

#### An Attendee Joining A Room.

```php
  $secret = "xxxxx"
  $userId = "max@organization.com";
  $type = KalturaSessionType::USER;
  $partnerId = 1234567;
  $expiry = 86400;
  $privileges = "resourceId:1100601,role:viewerRole,userContextualRole:3,firstName:Max";

  $result = $client->session->start($secret, $userId, $type, $partnerId, $expiry, $privileges);
```

#### A Moderator Preparing a Virtual Room Before an Event

```php
  $secret = "xxxxx"
  $userId = "speaker@organization.com";
  $type = KalturaSessionType::USER;
  $partnerId = 1234567;
  $expiry = 86400;
  $privileges = "resourceId:1100601,role:adminRole,userContextualRole:0";

  $result = $client->session->start($secret, $userId, $type, $partnerId, $expiry, $privileges);
```

## Creating the Virtual Meeting Room URL

The URL structure for the meeting room looks like this: 

```
[KAF-ENDPOINT]/virtualEvent/launch?ks=[KS]
```
where the KS is the Kaltura Session and your KAF endpoint is `[YOUR PARTNER ID].kaf.kaltura.com`, which must be preconfigured on your account. If you're not sure whether newrow/KAF have already been set up on your account, email us at vpaas@kaltura.com.


### Example 

```
1234567.kaf.kaltura.com/virtualEvent/launch?ks=djJ8MjM2NTQ5MXxGbYGg6kZISSOJqeojxSl9-PRS78DLutFB3LZlbQef1n42zW5NHfkZKBmhHTTUe3aSf0eQg8FkA1SsKvsSz7evqm4VHzPP_Q0POLuKXKvuVDuSOjOeTBltskSaCRlclo1ZLHUXt4p1pMeQdo95jaY0ddYV1xJH7KMMCBNV-AMt2IqbwyWdTaeTlatZ0quTOACZ6uvzhq1v
```

You can navigate to this page directly, or you can embed it in your webpage using an iFrame, like so:

```html
<!DOCTYPE HTML> 
<html>
<body>

  <iframe src="https://1234567.kaf.kaltura.com/virtualEvent/launch?ks=djJ8MjM2NTQ5MXxGbYGg6kZISSOJqeojxSl9-PRS78DLutFB3LZlbQef1n42zW5NHfkZKBmhHTTUe3aSf0eQg8FkA1SsKvsSz7evqm4VHzPP_Q0POLuKXKvuVDuSOjOeTBltskSaCRlclo1ZLHUXt4p1pMeQdo95jaY0ddYV1xJH7KMMCBNV-AMt2IqbwyWdTaeTlatZ0quTOACZ6uvzhq1v" wmode=transparent allow="microphone *; camera *; speakers *; usermedia *; autoplay *; fullscreen *;" width="1100px" height="700px"></iframe>

</body>
</html>
```

**Note that in the iFrame you'll need to add `https://` to the beginning of the URL**

As a best practice, we recommend you embed the URL in an iFrame in the webpage, allowing your application to handle access to the given page. See more about security measures below. 

## Security and Privacy 

It is the responsibility of your application to manage the security and permissions for each meeting room. As mentioned, it is encouraged to embed the URLs within iFrames in your application, to ensure that users are authenticated before arriving at the given webpage. 

**How can I ensure that users are not accessing the room outside of the event time?**
A [Kaltura Session](https://developer.kaltura.com/api-docs/VPaaS-API-Getting-Started/Kaltura_API_Authentication_and_Security.html#the-kaltura-session) can be given an expiry of one day, one hour, even one minute. When the KS expires, that link will no longer be valid. 

**Can somebody use and share the room URL by viewing the source of the page?**
Reminder that userIds must be unique - meaning that a user who copies and shares an embed link would be kicked out of the room once somebody with an identical link joins the room. 

**How can I prevent users from inviting others by using the Invite option in the room?**
You can use `tags=custom_rs_show_invite:0 ` on the resource or event creation to hide the Invite button in the room. 

**How can I allow users to securely invite others to the room?**
Assuming the Invite button is enabled, the invitation modal allows a password to be set on the invite link. 

## Creating an Event 

While not required to create, or join a virtual room an event is a time period for a meeting to happen. One resource can be used for many different events, but an event will only be associated with one resource. 

You'll use the [`scheduleEvent.add`](https://developer.kaltura.com/console/service/scheduleEvent/action/add) action to create an event of type `KalturaRecordScheduleEvent`. This action must include a summary, startDate and endDate, and a recurrence type of NONE. 

### Required Parameters 

- **startDate**: (int) timestamp
- **endDate**: (int) timestamp  
- **recurrenceType**: NONE [0]
- **summary**: (string) event summary 

### Optional Parameters 

- **organizer**: (string) name of the organizer (string)
- **templateEntryId**: (string) the entry used for session recording 
- **ownerId**: (int) in the case that templateEntryId is empty, this user will now own the recording 
- **referenceId**: (string) third party's corresponding event ID 
- **location**: (string) geographical location of the event 
- **tags**: (string) see below 

The creation of the event will return an `id`. Hold on to that as well. And once again, if you've lost track of it, you can use [`scheduleEvent.list`](https://developer.kaltura.com/console/service/scheduleEvent/action/list) to see all of your created events. 


### Example 

```php
    $schedulePlugin = KalturaScheduleClientPlugin::get($client);
    $scheduleEvent = new KalturaRecordScheduleEvent();
    $scheduleEvent->recurrenceType = KalturaScheduleEventRecurrenceType::NONE;
    $scheduleEvent->startDate = 1586185200;
    $scheduleEvent->endDate = 1586188800;
    $scheduleEvent->summary = "Tomorrow's Event";
    $scheduleEvent->tags = "custom_rec_auto_start:1,custom_rs_show_invite:1,custom_rs_user_lang:es-LA";

    $result = $schedulePlugin->scheduleEvent->add($scheduleEvent);
```

This event will take place on April 6th 2020 from 3-4pm GMT, with a Spanish interface. It will begin recording automatically and allows attendees to invite others. 

#### Response Object 

```json
{
  "blackoutConflicts": [],
  "id": 3371011,
  "partnerId": 1234567,
  "summary": "Tomorrow's Event ",
  "status": 2,
  "startDate": 1586186820,
  "endDate": 1586190420,
  "classificationType": 1,
  "ownerId": "vpaas@kaltura.com",
  "sequence": 11,
  "recurrenceType": 0,
  "duration": 3600,
  "createdAt": 1586113200,
  "updatedAt": 1586113200,
  "objectType": "KalturaRecordScheduleEvent"
}
```

## Creating an Event Resource 

An event *must* be associated with a resource. As mentioned, the same resource (room) can be launched at many different times with different events. This allows you to keep specific resources inside a virtual room; for example, for the same class that is taught numerous times with the same lesson plan. 

To associate a session with an event, use the [`scheduleEventResource.add`](https://developer.kaltura.com/console/service/scheduleEventResource/action/add) action. This is where you'll need the resource Id and the event Id that you just created. 

### Example 

```php
  $schedulePlugin = KalturaScheduleClientPlugin::get($client);
  $scheduleEventResource = new KalturaScheduleEventResource();
  $scheduleEventResource->eventId = 3371011;
  $scheduleEventResource->resourceId = 1100601;

  try {
    $result = $schedulePlugin->scheduleEventResource->add($scheduleEventResource);
    var_dump($result);
  } catch (Exception $e) {
    echo $e->getMessage();
  }
```

This Scheduled Event will take place in Room-1 on April 6th 2020 at 3pm GMT. 

#### Response Object 

```json
{
  "eventId": 3371011,
  "resourceId": 1100601,
  "partnerId": 2365491,
  "createdAt": 1586148953,
  "updatedAt": 1586148953,
  "objectType": "KalturaScheduleEventResource"
}
```

#### A Moderator Joining A Scheduled Event 

```php
  $secret = "xxxxx"
  $userId = "speaker@organization.com";
  $type = KalturaSessionType::USER;
  $partnerId = 1234567;
  $expiry = 86400;
  $privileges = "eventId:3371011,role:adminRole,userContextualRole:0,lastName:Speaker";

  $result = $client->session->start($secret, $userId, $type, $partnerId, $expiry, $privileges);
```

#### 

### If Your Virtual Room is Not Working As Expected 

1. Make sure you created the resource with `tags = "vcprovider:newrow"`
2. Check with us to ensure the feature is enabled on your account 
3. Did you associate a resource with the event? 
4. Did you pass `role` in the KS privilege string? 

If you're still experiencing trouble, email us at vpaas@kaltura.com. 