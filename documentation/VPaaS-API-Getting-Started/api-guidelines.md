---
layout: page
title: Kaltura API Usage and Guidelines
weight: 106
---

### Understanding Document Conventions

A string in brackets [] represents a value. Replace the string – including the brackets – with an actual value. For example: replace *[SERVICENAME]* with *syndicationFeed*.

## Latest API Version

To find the version number of the API that contains the latest updates, use the [system.getVersion](https://developer.kaltura.com/console/service/system/action/getVersion) API.

## Kaltura Client Libraries 

Kaltura Client Libraries make it easier and faster to make calls against the Kaltura API. 

A client library is a set of classes that includes:

* The functional infrastructure for communication with the Kaltura API, such as constructing a request, performing an HTTP request, and parsing a response
* A full object representation of all the entities that are available through the Kaltura API, including enumeration objects
* Infrastructure for developers, such as built-in log capabilities

The client library provides code that can, among other things

* Construct a Kaltura request
* Perform an HTTP request
* Parse the result of a Kaltura request
  
### Getting a Client Library for the Kaltura API

The Kaltura API SDK includes client library packages in different languages, including PHP, Java, C#, and JavaScript. For the latest version of all client libraries, refer to [Kaltura API SDK - Native Client Libraries](https://developer.kaltura.com/api-docs/Client_Libraries).

To get the entire API in your IDE, just download the client library for the language that you use to develop your applications and include the client library in your application or project.

### Getting a Client Library for a Language that Kaltura Does Not Provide

The Kaltura client libraries are generated automatically based on API schema. Kaltura also strives to include contributions from the community and customers, and we welcome contributions of client libraries for languages that Kaltura does not yet provide.

You can write a custom generator class in PHP that generates code in the language of your choice.

If you provide the generator class to Kaltura, Kaltura will include your generator class in the Kaltura core generator. The new client library will be automatically generated and will be publicly available.

For more information on creating a client library generator, refer to [Adding New Kaltura API Client Library Generator](https://vpaas.kaltura.com/documentation/VPaaS-API-Getting-Started/introduction-kaltura-client-libraries.html).

## API Authentication and Kaltura Sessions

Most Kaltura API calls require you to authenticate before executing a call. Calls that require authentication usually have a response that cannot be shared between different accounts. For the Kaltura server to know that you are allowed to “ask that question,” you must authenticate before executing the call.

To learn more about the Kaltura Session and API Authentication, read: [Kaltura's API Authentication and Security](https://developer.kaltura.com/api-docs/VPaaS-API-Getting-Started/Kaltura_API_Authentication_and_Security.html).

| Error Code                         | Error Message                                                                                                       |   |
|------------------------------------|---------------------------------------------------------------------------------------------------------------------|---|
| INTERNAL_SERVER_ERROR             | Internal server error occurred                                                                                      |   |
| MISSING_KS                         | Missing KS, session not established                                                                                 |   |
| INVALID_KS                         | Invalid KS "%KS%", Error "%KS_ERROR_CODE%,%KS_ERROR_DESCRIPTION%"                                                   |   |
| SERVICE_NOT_SPECIFIED              | Service name was not specified, please specify one                                                                  |   |
| SERVICE_DOES_NOT_EXISTS            | Service "%SERVICE_NAME%" does not exist                                                                             |   |
| ACTION_NOT_SPECIFIED               | Action name was not specified, please specify one                                                                   |   |
| ACTION_DOES_NOT_EXISTS             | Action "%ACTION_NAME%" does not exist for service "%SERVICE_NAME%"                                                  |   |
| MISSING_MANDATORY_PARAMETER        | Missing parameter "%PARAMETER_NAME%"                                                                                |   |

## Kaltura API Response/Request Format

### Request Structure

The Kaltura API implements a standard HTTP POST/GET URL encoded request structure. URL-encoded requests are targeted to a specific API method.

Each API method location is concatenated from:

* Base URI
* Service identifier string
* Action identifier string

The format of the API method location is: /api_v3/service/[SERVICENAME]/action/[ACTIONNAME], where

* [SERVICENAME] represents a specific service
* [ACTIONNAME] represent an action to be applied in the specific service

### Request Input Parameters

Each API method receives a different set of input parameters.

For all request types:

* Send input parameters as a standard URL-encoded key-value string.
* When an input parameter is an object, flatten it to pairs of ObjectName:Param keys.

### Request Input Parameters Example

{% highlight plaintext %}
id=abc12&name=name%20with%20spaces&entry:tag=mytag&entry:description=mydesc
{% endhighlight %}

In the example, the following parameters are URL encoded and are passed as API input parameters:

{% highlight javascript %}
id = 'abc'
name = 'name with spaces'
entry {
	tag = 'mytag',
	description = 'mydesc'
}
{% endhighlight %}

## API Errors and Error Handling

The Kaltura API can return errors, which are represented by an error identifier followed by a description:

* An error ID is a unique string. The parts of the string are separated by underscores.
* An error description is textual. The description may include a dynamic value.

A comma separates the error ID from the description.

### API Error Example

{% highlight plaintext %}
ENTRY_ID_NOT_FOUND,Entry id "%s" not found
{% endhighlight %}

where *%s* is replaced with the value that is sent to the API call.

In the response XML:

* The `code` node contains the error code (such as *ENTRY\_ID\_NOT_FOUND*).
* The `message` node contains the description (such as *Entry id “%s” not found*).

### ErrorResponse

**Error Handling**

In most client libraries, the client library code throws an exception when an error is returned from the API. Depending on the programming language, catching the exception to read the code and/or the message enables user-friendly error handling. Errors that you encounter during development usually are caused by incorrect implementation.

## The Multi-request API

The Kaltura API can execute several API calls in a single HTTP request to Kaltura. The multi-request feature improves performance in Kaltura integrations. The feature enables a developer to stack multiple API calls and issue them in a single request. This reduces the number of round-trips from server-side or client-side developer code to Kaltura.

### Understanding the Multi-request Feature

The Kaltura API processes each of the API calls that are included in the single HTTP request. The response essentially is a list of the results for each of the calls in the request. The multi-request feature includes the ability to have one request depend on the result of another request.

While the Kaltura API is processing each of the API calls in a multi-request, it detects when there is a dependency in one of the call parameters. The Kaltura API parses the dependency and replaces it with the result of the relevant call.

### Multi-request with Dependency (Sample Use Case)

To create a new entry out of a file in your server, execute several different API calls:

1. [uploadToken.add](https://developer.kaltura.com/console/service/uploadToken/action/add)
2. [uploadToken.upload](https://developer.kaltura.com/console/service/uploadToken/action/upload)
3. baseEntry.addFromUploadedFile(https://developer.kaltura.com/console/service/baseentry/action/addfromuploadedfile)

The result of `uploadToken.add` is an `uploadToken` object that consists of a token string.

You'll need the token string when executing the next action – uploading the file, therefore, you must complete the first action to call the second one.

Using the multi-request feature, in the second request you specify obtaining the value of the token parameter from the token property that is the result of the first request.

### Multi-request Structure

To perform a multi-request call:

1. Define the *GET* parameter of **service** as **multirequest** and define the **action** as **null** using (http://www.kaltura.com/api_v3/?service=multirequest&action=null).

2. Prefix each API call with a number that represents its order in the multi-request call, followed by a colon. Prefix the first call with *1:*, the second with *2:*, and so on.

3. Use the prefix for each of an API call's parameters (service, action, and action parameters).

#### Example

{% highlight plaintext %}
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
{% endhighlight %}

### Multi-request with Dependency - Structure

To create a multi-request with a dependent request, use the following structure as input in the variable whose value you want to replace with a result of a preceding request:

{% highlight plaintext %}
{num:result:propertyName}
{% endhighlight %}

where:

* *num* is the number of the request from which to collect data.
* *result* instructs the Kaltura API to replace this value with a result from another request.
* *propertyName* is the property to obtain from the object of the required result.

#### Example

{% highlight plaintext %}

Request URL: api_v3/index.php?service=multirequest&action=null
	POST variables:
		1:service=media
		1:action=list
		1:filter:nameLike=myentry
		2:service=media
		2:action=get
		2:entryId={1:result:objects:0:id}
		ks={ks}
{% endhighlight %}

In the example, the first request lists entries whose names resemble *myentry*. The [media.list](https://developer.kaltura.com/console/service/media/action/list) request returns an object of type *KalturaMediaListResponse*, which contains an object named *objects* of type *KalturaMediaEntryArray*.

The second request is [media.get](https://developer.kaltura.com/console/service/media/action/get), which uses `entryId` as input.

The `entryId` input is dynamic, and the value is obtained from the first request. Since the [media.list](https://developer.kaltura.com/console/service/media/action/list) response is constructed of array object within a response object, the first property to access is `KalturaMediaEntryArray`.

Since in the `KalturaMediaEntryArray` you want to obtain the first element (index **), add *:0* to the request value.

Since from the first element you want only the ID that is the input for the second request, add *:id* to the request value.

## Maintaining Backward Compatibility and Tracking Version Changes

Maintaining backward compatibility during API upgrades is a common concern for developers utilizing APIs to build applications.

Kaltura's client libraries are automatically generated from the server code, that include an automatic client libraries' generator mechanism. See [Adding the New Kaltura API Client Library Generator](https://vpaas.kaltura.com/documentation/VPaaS-API-Getting-Started/introduction-kaltura-client-libraries.html) for more information. As a result, the Kaltura API client libraries are not available as a static code repository that you can track for changes.

To keep up to date with the changes between releases, follow the [Kaltura API Twitter account](https://twitter.com/Kaltura_API).

For each Kaltura release, the Kaltura API Twitter account notifies followers about additions and changes made to the REST APIs, Players APIs, and changes to the Client Libraries, and release notes are provided about the new release.

Kaltura API based applications do not require frequent updates to the client library used. Kaltura is committed to provide full backward computability to the API layer, keeping deprecated APIs functional, and ensuring that additions or changes introduced in new versions will not break existing applications.

When new functionalities for your applications are introduced, or when maintenance upgrades are made to your applications, we encourage you to keep your client libraries updated even though an upgrade based on the availability of new Kaltura releases is not required.
