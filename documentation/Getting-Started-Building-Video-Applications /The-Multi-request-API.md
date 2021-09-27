---
layout: page
title: The Multi-request API
weight: 110
---

The Kaltura API can execute several API calls in a single HTTP request. The multi-request feature improves performance in Kaltura integrations. The feature enables a developer to stack multiple API calls and issue them in a single request. This reduces the number of round-trips from server-side or client-side developer code to Kaltura.

The Kaltura API Clients have a built in feature to handle multi-request. Below is a link to examples of multi-request in each language:

| [![ios](/assets/images/clientlangs/ios.png)](https://github.com/kaltura/KalturaGeneratedAPIClientsSwift/blob/master/Example/Tests/MultirequestTest.swift) | [![php](/assets/images/clientlangs/php.png)](https://github.com/kaltura/KalturaGeneratedAPIClientsPHP/blob/master/TestCode/TestMain.php#L105) | [![java](/assets/images/clientlangs/java.png)](https://github.com/kaltura/KalturaGeneratedAPIClientsJava/blob/master/src/test/java/com/kaltura/client/test/MultiRequestTest.java) | [![node](/assets/images/clientlangs/node.png)](https://github.com/kaltura/KalturaGeneratedAPIClientsNodeJS/blob/master/example.js#L234) | [![python](/assets/images/clientlangs/python.png)](https://github.com/kaltura/KalturaGeneratedAPIClientsPython/blob/master/KalturaClient/tests/test_functional.py#L222) | [![ruby](/assets/images/clientlangs/ruby.png)](https://github.com/kaltura/KalturaGeneratedAPIClientsRuby/blob/master/test/media_service_test.rb#L145) | [![ts](/assets/images/clientlangs/ts.png)](https://github.com/kaltura/KalturaGeneratedAPIClientsTypescript/blob/master/src/tests/kaltura-multi-request.spec.ts) | [![ajax](/assets/images/clientlangs/ajax.png)](https://github.com/kaltura/KalturaGeneratedAPIClientsAJAX/blob/master/test/multi-request.test.js) | [![csharp](/assets/images/clientlangs/csharp.png)](https://github.com/kaltura/KalturaGeneratedAPIClientsCsharp/blob/master/KalturaClientTester/ClientTester.cs#L446) | [![angular](/assets/images/clientlangs/angular.png)](https://github.com/kaltura/KalturaGeneratedAPIClientsAngular/blob/master/projects/kaltura-ngx-client/src/tests/kaltura-multi-request.spec.ts) |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |

The multi-request feature includes the ability to have one request depend on the result of another request.

While the Kaltura API is processing each of the API calls in a multi-request, it detects when there is a dependency in one of the call parameters. The Kaltura API parses the dependency and replaces it with the result of the relevant call.

### Multi-request Structure

Regardless of what language you use, the following structure will need to be passed as a string in order to specify which properties, from which API call you want to be passed. 

To create a multi-request with a dependent request, use the following structure as input in the variable whose value you want to replace with a result of a preceding request:

```
{num:result:propertyName}
```

where:

- *num* is the number of the request from which to collect data.
- *result* instructs the Kaltura API to replace this value with a result from another request.
- *propertyName* is the property to obtain from the object of the required result

Here is an excerpt from the [node.js](https://github.com/kaltura/KalturaGeneratedAPIClientsNodeJS/blob/master/example.js#L115) example:

```javascript
function multirequest_single_callback(){
		...
		kaltura.services.media.add(entry)
		.add(kaltura.services.media.deleteAction("{1:result:id}"))
```

Two API calls are used. The first is [media.add](https://developer.kaltura.com/console/service/media/action/add)

```javascript
kaltura.services.media.add(entry)
```

Which then immediately calls [media.delete](https://developer.kaltura.com/console/service/media/action/delete):

```javascript
.add(kaltura.services.media.deleteAction("{1:result:id}"))
```

Take note of the second `.add` which is part of the kaltura client library for multirequests and is different from the first `.add` which is the api endpoint `media.add`.  The multi-request argument is `{1:result:id}` which passes the `id` from the `mediaEntry` created in the first API call to the second API call `delete` . `delete` only has 1 argument, `entryId`

#### Selecting specific response values:

```javascript
kaltura.services.media.listAction(filter, pager)
    .add(kaltura.services.media.get("{1:result:objects:0:id}", version)
```

The [media.list](https://developer.kaltura.com/console/service/media/action/list) request returns an object of type *KalturaMediaListResponse*, which contains an object named *objects* 

The second request is [media.get](https://developer.kaltura.com/console/service/media/action/get), which uses `entryId` as its first argument.

The `entryId` input is dynamic, and the value is obtained from the first request. Since the [media.list](https://developer.kaltura.com/console/service/media/action/list) response is constructed from array object within a response object, the first property to access is `KalturaMediaEntryArray`

Here is a partial json response from `media.list`:

```javascript
{ //KalturaMediaListResponse
  "objects": [ //KalturaMediaEntryArray
    { 'id':'this is an entryId'
```

In the `KalturaMediaEntryArray` you want to obtain the first element (index **), so add  \*:0* to the request value.

Since from the first element you want only the ID that is the input for the second request, add *:id* to the request value. And the final multi-request string is:

```javascript
{1:result:objects:0:id}
```

which is passed to the `entryId` argument of `media.get` 

### Multi-request Structure Protocol

Here is a lower level explanation of the multi-request protocol:

To perform a multi-request call:

1. Define the *GET* parameter of **service** as **multirequest** and define the **action** as **null** using (http://www.kaltura.com/api_v3/?service=multirequest&action=null).
2. Prefix each API call with a number that represents its order in the multi-request call, followed by a colon. Prefix the first call with *1:*, the second with *2:*, and so on.
3. Use the prefix for each of an API call’s parameters (service, action, and action parameters).

#### Example

```
Request URL: api_v3/index.php?service=multirequest&action=null
	POST variables:
		1:service=baseEntry
		1:action=get
		1:version=-1
		1:entryId=0_zsadqv3e
		2:service=flavorasset
		2:action=getWebPlayableByEntryId
		2:entryId=0_zsadqv3e
		2:version=-1
		ks={ks}
```

### 
