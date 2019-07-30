---
layout: page
title: Introduction to Kaltura's Client Libraries
weight: 106
---

>Note: This article applies to Kaltura API version 3 and later. It does not address how to implement specific flows using the Kaltura API.

## Kaltura's Client Libraries

A Kaltura client library:

* Is an SDK package in a specific programming language
* Provides developers with easy access to the Kaltura API
* Makes it easy to develop Kaltura applications

The Kaltura client library is a collection of classes. Each class consists of objects and service classes. The collection of classes represents the entities, services, and actions that the Kaltura API provides.

## Why Should You Use a Kaltura Client Library?

Kaltura recommends that you use a Kaltura Client Library when you develop applications that interact with the Kaltura API. Client libraries provide the following benefits:

* All objects and enums are auto-generated for you.
* All services and actions are auto-generated for you.
* Because they are auto-generated, there is lower chance for mistakes.
* The low level is already implemented for you, including:
* HTTP communication
* Serialization and de-serialization
* Error handling
* Authentication is built-in.
* Multi-request is built-in.
* Response-profile is built-in.
* Global parameters are utilized for you.

## What Are the Types of Client Libraries Available?

There are different types of client libraries:

* Client libraries for the Kaltura Hosted Edition
* Local client libraries for Kaltura On-Prem™ and [Kaltura Community Edition (CE)](https://github.com/kaltura/platform-install-packages/#kaltura-installation-packages-project)
* Specialized Kaltura [client libraries](https://developer.kaltura.com/api-docs/Client_Libraries/)

## Client Libraries

First, choose the [client library](https://developer.kaltura.com/api-docs/Client_Libraries/) in the language that's right for you.

### Sample Code Usage

All sample code is PHP5, unless otherwise stated.

The sample code is designed to show you how to use the features of Kaltura client libraries.

>Note: The sample code is formatted for this document and includes hard-coded examples. Before using sample code copied from this document, replace the examples and adapt the formatting.

### Document Conventions

* File paths and names appear in bold.
  Example:** /[INSTALLATION_PATH]/app/generator/config.ini**

* A string in brackets [] represents a value.
  Replace the string – including the brackets – with an actual value.
  Example: Replace *[yourClientLibraryName]* with *Java*.

### Client Library Programming Languages

Kaltura provides [downloadable client libraries][8] for the Kaltura Hosted Edition in various programming languages.

**Available Client Library Languages**

* PHP5
* Zend Framework-compatible library: Eases library integration in terms of coding standards and auto-loading
* JavaScript  
* Node.JS
* C# .NET
* Java
* Ruby
* Python
* Objective-C/Cocoa
* Java Android
* CLI

[5]: https://github.com/kaltura/platform-install-packages/#kaltura-installation-packages-project

[8]: https://developer.kaltura.com/api-docs/Client_Libraries

[9]: https://developer.kaltura.com/api-docs/VPaaS-API-Getting-Started/client-library-generator.html

[11]: https://developer.kaltura.com/api-docs/VPaaS-API-Getting-Started/api-guidelines.html

## Generating a Client Library for a Language that Kaltura Does Not Provide

If you want a client library for a language that Kaltura does not provide, you need to [generate a specialized Kaltura client library][8].

Kaltura welcomes contributions of client libraries for languages that Kaltura does not yet provide.

For more information, refer to [Kaltura API Usage Guidelines][11]


### Using APIs from a Customized Server Plugin

If you want a client library to include customized APIs from a server plugin, you need to [generate a specialized Kaltura client library][9].

### Using a Sub-Set of Kaltura APIs

If you want to use only a specific sub-set of Kaltura APIs without accessing other APIs, you need to [generate a specialized Kaltura client library][9].

### Getting a Client Library for Kaltura Hosted Edition

You need Kaltura Hosted client libraries if you use a standard Kaltura Hosted Edition.

If you use a different Kaltura edition, see [Generating a Client Library for Kaltura On-Prem and Kaltura CE][5].

If you have specialized needs, see [Generating a Specialized Kaltura Client Library][9].

#### How Is a Kaltura Hosted Client Library Generated?

Kaltura Hosted Edition client libraries are generated automatically based on the [schema](http://www.kaltura.com/api_v3/api_schema.php) of the latest API version.


**_Client libraries are updated automatically when Kaltura updates Hosted servers with a new API version._**

#### How to Get a Kaltura Hosted Client Library?

Download client libraries from [Kaltura API SDK - Native Client Libraries][8].

## Understanding Client Libraries and Self-Hosted Kaltura Servers

Kaltura On-Prem and Kaltura CE use self-hosted Kaltura servers.

Generating a client library locally ensures that the client library is compatible with the API version of the Kaltura edition on your self-hosted Kaltura server.

#### How Is a Kaltura Self-Hosted Client Library Generated?

If the version of your self-hosted edition is:

* Dragonfly or earlier – Use the Kaltura server client generator to generate a client library locally.
* Eagle or later – The Kaltura server client generator is executed automatically during installation.

> Do not generate a client library locally when you use an application developed by Kaltura or the community that is packaged with a client library. Changing the client library in the application may cause the application to fail.

# Generating a Specialized Kaltura Client Library

You need to [generate specialized client libraries][9] if you want:

* A client library for a language that Kaltura does not provide
* A client library to include customized APIs from a server plugin
* To use only a specific sub-set of Kaltura APIs without accessing other APIs

Generating a client library may require:

* Creating a language-specific *KalturaClientBase* class
* Creating a language-specific generator class
* Including a Kaltura server plugin in a generator
* Modifying a generator **config.ini** file
* Running a generator

The Kaltura system includes generator code that generates client libraries.

The generator:

* Is written in PHP
* Uses the *Zend_Reflection* class
* Parses the entire Kaltura API code, including the PHP code comments
* Generates a client library according to the services and actions in the Kaltura API

###  Understanding the KalturaClientBase class

The *KalturaClientBase* class:

* Contains all of the logic for communicating with the Kaltura API
* Consists of methods for activities such as:
  * Submitting the HTTP request to the Kaltura API
  * Building the HTTP request from objects
  * Parsing the API output (from XML or other output format) back in to the response object,
  * Writing logs
* Is independent of most Kaltura API services and actions
* Is written manually for each client library

###  Understanding the Kaltura Client Library Generator Class

Each client library is generated using a language‑specific generator class.

The generator class has methods that are required to be implemented so that the code output is in the relevant language.

The generator class includes methods such as:

* *writeEnum* –Outputs code of an enumeration class (for example, [KalturaEntryStatus](https://developer.kaltura.com/api-docs/General_Objects/Enums/KalturaEntryStatus))
* *writeClass* – Outputs code of an object that represents a Kaltura entity (for example, [KalturaBaseEntry](https://developer.kaltura.com/api-docs/General_Objects/Objects/KalturaBaseEntry))
* *writeService* - Outputs code of an object that represents a Kaltura service.
  The object has methods. Each method represents an action that is available in the service.
* *writeAction* - Outputs code of an action method within a service object.

A generator's methods collectively generate the code of an entire language‑specific client library.

A generator class is written in PHP.

The generator class structure usually is the same for all languages.

The main difference between generator classes is the method outputs.

####  Required Developer Knowledge

A developer who writes a language‑specific generator requires:

* Wide knowledge of the language of the generated client library
* Familiarity with the language's limitations and behaviors.
  For example, whether the language supports nullable Boolean values.

###  Understanding Inclusion of a Kaltura Server Plugin in a Client Library

The Kaltura server supports extending the API with server plugins. Kaltura server plugins can provide new API services.

A server plugin usually contains a configuration file that includes the plugin in a client library.

A generator places all server plugin APIs in separate files.

The server can disable a server plugin. Similarly, a client library can exclude a server plugin by excluding the server plugin API files.

####  Coding Standard Compliance

When you write a Kaltura server plugin that extends the Kaltura API, Kaltura strongly recommends that you follow Kaltura API coding standards. A generator can handle server plugins for a client library accurately only if the plugin services comply with API coding standards, including code comments.

### Understanding the Generator config.ini File

A generator refers to a **config.ini** file during execution.

The **config.ini**:

* Specifies the client library package to generate
* Specifies the services and actions to include or exclude
* Is located in **[INSTALLATION_PATH]/app/generator/config.ini**

##  Producing a Specialized Kaltura Client Library

### Creating a Language-Specific KalturaClientBase Class

1. [Download a client library][8] for an existing language.
2. Base the language-specific class on a *KalturaClientBase* class in the downloaded client library.
  *KalturaClientBase* is located in **/[INSTALLATION\_PATH]/app/generator/sources/[LANGUAGE\_NAME]/**

### Creating a Language-Specific Generator Class

1. [Download a client library][8] for an existing language.
2. Base the language-specific class on a generator class in the downloaded client library.
  An example of a generator class path and name is: **/[INSTALLATION_PATH]/app/generator/JavaClientGenerator.php**

### Including a Kaltura Server Plugin in a Generator

In your Kaltura server plugin, include a configuration that defines the plugin services included in client libraries.

The client library generator refers to the plugin configuration. The generator includes or excludes plugin services in the generated client libraries as specified in the plugin configuration.

> Do not modify the generator config.ini file to include or exclude plugin services.

### Modifying a Generator config.ini File

**To include specific services and actions in the generator config.ini file:**

1. Open **/[INSTALLATION_PATH]/app/generator/config.ini**.
2. For the language you are generating:
* Add an *include* command with the services and actions to include. For example:
  {% highlight bash %}include = batch.*, batchcontrol.*, jobs.*, media.addfrombulk{% endhighlight %} An asterisk includes all of a service's actions. For example, *batch.** includes all *batch* service actions.
  Specifying a service and action includes only the specific action of the service. For example, *media.addfrombulk* includes only the *addfrombulk* action of the *media* service.
* If an *include* command exists, add to the command the services and actions you want to include.

3. Save the file.

**To exclude specific services and actions from the generator config.ini file:**

1. Open **/[INSTALLATION_PATH]/app/generator/config.ini**.
2. For the language you are generating:
* Add an *exclude* command with the services and actions to exclude. For example:
  {% highlight bash %}exclude = batch.*, batchcontrol.*, jobs.*, media.addfrombulk{% endhighlight %} An asterisk excludes all of a service's actions. For example, *batch.** excludes all *batch* service actions.
  Specifying a service and action excludes only the specific action of the service. For example, *media.addfrombulk* excludes only the *addfrombulk* action of the *media* service.
* If an *exclude* command exists, add to the command the services and actions you want to exclude.

3. Save the file.

**To include your client library in the generator config.ini file:**

1. Open **/[INSTALLATION_PATH]/app/generator/config.ini**.
2. Add a section that specifies:
3. The client library name: for example, when generating a client library in a new language, typically you use the language name.
4. The generator class name
5. Save the file.

Example of the section to add:

```
[yourClientLibraryName] generator = [classNameOfYourGenerator]
```

### Running a Generator

**To generate a client library on your local Kaltura server:**

Run the following script with root permissions:

```
cd /[INSTALLATION_PATH]/app/generator/ ./generate.sh
```
> The generator may not have permission to create the Kaltura client library files if you run the script without root permissions.

Your client library will be located under the output folder. For example: **/[INSTALLATION_PATH]/web/content/clientslibs/[yourClientLibraryName]/**

# Using a Kaltura Client Library

## Including a Client Library in an Application

Before you can use a client library, you include the client library in your application.

Depending on your programming language and application setup, either:

* You explicitly include the client library in your application.
* Your environment automatically includes the client library in your application using a feature such as the PHP auto-loading capability.

The client library files included in your application depend on the client library generator. Usually you include only the *KalturaClient* file.

The *KalturaClient* file is the main class that includes:

* All other classes (including *KalturaClientBase*)
* Most core Kaltura APIs:
  * Entity objects
  * Enumeration objects
  * Filter objects
  * Service classes
  * Service class methods

To explicitly include a client library in your application:

Implement the following code in your application:
{% highlight php %}
<?php
require_once 'KalturaClient.php';
{% endhighlight %}

## Excluding a Server Plugin from an Application

All APIs that belong to a Kaltura server plugin are generated in separate files.

The server can disable a server plugin. Similarly, a client library can exclude a server plugin by excluding the server plugin API files.

To exclude a server plugin from an application:

Do not include the server plugin API files in the client library.

# Accessing the Kaltura API

To make a call to the Kaltura API, you'll need a Kaltura Client that includes a valid Kaltura Session. You can read in depth [here](https://developer.kaltura.com/api-docs/VPaaS-API-Getting-Started/how-to-create-kaltura-session.html) about the different ways of creating a session and accessing the API.

Creating a Client requires a Configuration Object first.

## Creating a Configuration Object

The Configuration Object should be created using your Partner ID.
The service is set by default as "https://www.kaltura.com/"
The Client Object is then created using the configuration. Once you generate a Kaltura Session, you set it on the Client.

{% highlight php %}
<?php
$kalturaConfig = new KalturaConfiguration(123);
// where 123 is your partner ID
$kalturaConfig->serviceUrl = 'kaltura server'
$kalturaClient = new KalturaClient($kalturaConfig);
{% endhighlight %}

## Starting a Kaltura Session

You need to start a Kaltura session (KS) before using a client object for most API calls.

For more information about a KS, refer to [Kaltura API Usage Guidelines][11].

To create a KS:

Implement the following code:

{% highlight php %}
<?php
$ks = $kalturaClient->generateSession($adminSecret, $userId, KalturaSessionType::ADMIN, $partnerId, $expiry,$privileges);
{% endhighlight %}

### Setting the Kaltura Session for the Configuration Object

**To set the KS for the configuration object:**

Implement the following code:
{% highlight php %}
$kalturaClient->setKs($ks);
{% endhighlight %}

## The Kaltura API

The Kaltura API structure consists of a list of services, represented by service objects. Each service object consists of different actions, represented by a method in the service object.

**For example:**

1. To call the **media** service in order to get a specific media entry instance from the Kaltura server entry, you use the *get* action.
  The result of [`media.get`](https://developer.kaltura.com/console/service/media/action/get) is an object of type [`KalturaMediaEntry`][22].
2. The `media.get` call, provides information about the entry, such as its name or date of creation.

[22]: https://developer.kaltura.com/console/service/media/

For more information about the Kaltura API structure, refer to [Kaltura API Usage Guidelines][11] or try it out using the [console](https://developer.kaltura.com/console)

To perform a `media.get` call:

Implement the following code:

{% highlight php %}
$entryId = 'XXXYYYZZZA'; // a known ID of media entry that you have
$mediaEntry = $client->media->get($entryId);
{% endhighlight %}

To print the name of the media entry:

Implement the following code:
{% highlight php %}
echo $mediaEntry->name;
{% endhighlight %}

## Example Workflow

An example workflow for printing a known media item's name from a client library involves:

1. Including a Client Library in an Application
2. Instantiating a Client Object
3. Creating a configuration object
4. Starting a Kaltura session
5. Setting the Kaltura session for the configuration object
6. Using a Client Object to Perform an API Call
Performing a [`media.get call](https://developer.kaltura.com/console/service/media/action/get)
Printing the name of the media entry

### Sample Code for Printing a Known Media Item's Name:

{% highlight php %}
require_once 'KalturaClient.php';
$kalturaConfig = new KalturaConfiguration(123);
// where 123 is your partner ID
$kalturaConfig->serviceUrl = 'http://KalturaServerDomain';
// if you want to communicate with a Kaltura server which is
// other than the default http://www.kaltura.com
$kalturaClient = new KalturaClient($kalturaConfig);
$ks = $kalturaClient->generateSession($adminSecret, $userId, KalturaSessionType::ADMIN, $partnerId, $expiry,$privileges); $kalturaClient->setKs($ks);
$entryId = 'XXXYYYZZZA';
// a known ID of media entry that you have $mediaEntry = $client->media->get($entryId); echo $mediaEntry->name;
{% endhighlight %}

### Performing an API Call with a Server-Side Plugin Service

Plugin APIs (services and objects) are generated in separate files. You can remove API files from the package easily without breaking inner dependency.

Since plugin APIs are not included in an application as a generic part of the client library, you use plugin APIs differently than client library objects.

To perform a call using a plugin's metadata API:

Implement the following code:

{% highlight php %}
require_once 'KalturaClient.php';
$kalturaConfig = new KalturaConfiguration(123);
// where 123 is your partner ID
$kalturaConfig->serviceUrl = 'http://KalturaServerDomain';
// if you want to communicate with a Kaltura server which is other than the default http://www.kaltura.com
$kalturaClient = new KalturaClient($kalturaConfig);
$ks = $kalturaClient->generateSession($adminSecret, $userId, KalturaSessionType::ADMIN, $partnerId, $expiry,$privileges);
$kalturaClient->setKs($ks);
$entryId = 'XXXYYYZZZA';
// a known ID of media entry that you have instantiating a filter object required for the API call.
$metadataFilter = new KalturaMetadataFilter();
// 1111 is a known ID of metadata profile
$metadataFilter->metadataProfileIdEqual = '1111';
$metadataFilter->metadataObjectTypeEqual = KalturaMetadataObjectType::ENTRY;
// filtering metadata objects for specific entry:
$metadataFilter->objectIdEqual = $entryId;
// instantiating a plugin object which holds its own services. note that we pass the client to the plugin object
$metadataPlugin = KalturaMetadataClientPlugin::get($kalturaClient);
// calling the specific service 'metadata' and a specific action 'list'
$metadataForEntry = $metadataPlugin->metadata->listAction($metadataFilter);
var_dump($metadataForEntry);
{% endhighlight %}

### Performing Multi-Requests

The Kaltura API supports the multi-request feature.

The multi-request feature allows you to stack multiple required calls and issue them in a single HTTP request. The multi-request feature reduces the number of network round trips between your server and Kaltura.

You instruct the client to start a multi-request stack of calls. When all of the required calls are stacked, you instruct the client to perform the actual HTTP request.

The multi-request feature supports the ability to have one request depend on the result of another request.

For more information about the multi-request feature, refer to Kaltura API Usage Guidelines[11]

**To perform a multi-request:**

Implement code based on the following example:

{% highlight php %}
require_once 'KalturaClient.php';
$kalturaConfig = new KalturaConfiguration(123); // where 123 is your partner ID
$kalturaConfig->serviceUrl = 'http://KalturaServerDomain'; // if you want to communicate with a Kaltura server which is other than the default http://www.kaltura.com
$kalturaClient = new KalturaClient($kalturaConfig);
$ks = $kalturaClient->generateSession($adminSecret, $userId, KalturaSessionType::ADMIN, $partnerId, $expiry,$privileges);
$kalturaClient->setKs($ks); $entryId = 'XXXYYYZZZA'; // a known ID of media entry that you have
try { // tell the client to start stacking actions for multi-request
$kalturaClient->startMultiRequest(); // add first call to multi-request stack
$kalturaClient->media->get($entryId); // create empty object for updating
$emptyEntryForUpdate = new KalturaMediaEntry(); // set dependency between second call and first call, the description to be set on the entry is the tags from the previous 'media.get' call
$emptyEntryForUpdate->description = '{1:result:tags}'; // add second call to multi-request stack
$kalturaClient->media->update($entryId, $emptyEntryForUpdate); // tell the client to perform the actual HTTP request for the stacked actions
$results = $kalturaClient->doMultiRequest(); // extract result objects from array of results
$mediaEntry = $results[0];
$updatedMediaEntry = $results[1];
echo "entry tags: " . $mediaEntry->tags;
echo "new entry description: " . $updatedMediaEntry->description;
} catch(Exception $ex) {
echo "could not get entry from Kaltura. Reason: " . $ex->getMessage();
}
{% endhighlight %}

### Error Handling

The Kaltura API can return errors.

The API follows object-oriented programming (OOP) principles. A client library is generated as OOP code that consists of classes and methods. The best way for a client library to handle errors natively is by using exceptions, as follows:

A client library parses an API output. If the API returned an error, the client throws an exception that includes the error code and message that the Kaltura server returned.

Kaltura recommends that you wrap API calls in your code in a *try-catch* block to enable user-friendly error handling. This approach prevents your application from crashing.

For more information about Kaltura API error handling, refer to Kaltura API Usage Guidelines[11]

### API Error Handling – Sample Code

The following is an example of error handling for printing a known media item's name:

{% highlight php %}
require_once 'KalturaClient.php';
$kalturaConfig = new KalturaConfiguration(123);
// where 123 is your partner ID
$kalturaConfig->serviceUrl = 'http://KalturaServerDomain';
// if you want to communicate with a Kaltura server which is other than the default http://www.kaltura.com
$kalturaClient = new KalturaClient($kalturaConfig);
$ks = $kalturaClient->generateSession($adminSecret, $userId, KalturaSessionType::ADMIN, $partnerId, $expiry,$privileges);
$kalturaClient->setKs($ks);
$entryId = 'XXXYYYZZZA'; // a known ID of media entry that you have
try {
  $mediaEntry = $client->media->get($entryId);
  echo $mediaEntry->name;
} catch(Exception $ex) {
  echo "could not get entry from Kaltura. Reason: " . $ex->getMessage();
}
{% endhighlight %}

## Tips and Tricks

* To learn about the Kaltura API, refer to the [Kaltura API Test Console][24].
* In the [Kaltura API Test Console][24], you can toggle between PHP, Java, and C# to display a code example.
* To learn about specific services, actions, and objects, refer to the [API documentation][25].
* For examples used in this document in languages available in the [Kaltura API SDK - Native Client Libraries][8], see [Sample Code for Multiple Client Library Languages][7].

[24]: https://developer.kaltura.com/console
[25]: https://developer.kaltura.com/api-docs

# Sample Code

The sample code demonstrates the following scenario for using a Kaltura client library:

1. Including a Client Library in an Application
2. Instantiating a Client Object
3. Creating a configuration object
4. Starting a Kaltura session
5. Setting the Kaltura session for the configuration object
6. Using a Client Object to Perform an API Call][15] (*media.get*)
7. Performing a [media.get call](https://developer.kaltura.com/console/service/media/action/get)
8. Printing the name of the media entry
9. Error Handling

To understand the sample code in detail, try it out in the [console](https://developer.kaltura.com/console).

## Sample Code – Available Languages

Sample code appears for the following languages:

* PHP
* Java
* C#
* Python
* Ruby
* AS3
* JavaScript
* Objective-C/Cocoa

### PHP5

{% highlight php %}
require_once 'KalturaClient.php';
$kalturaConfig = new KalturaConfiguration(123); // where 123 is your partner ID
$kalturaConfig->serviceUrl = 'http://KalturaServerDomain'; // if you want to communicate with a Kaltura server which is other than the default http://www.kaltura.com
$kalturaClient = new KalturaClient($kalturaConfig);
$ks = $kalturaClient->generateSession($adminSecret, $userId, KalturaSessionType::ADMIN, $partnerId, $expiry,$privileges);
$kalturaClient->setKs($ks);
$entryId = 'XXXYYYZZZA'; // a known ID of media entry that you have
try {
  $mediaEntry = $client->media->get($entryId);
  echo $mediaEntry->name;
} catch(Exception $ex) {
  echo "could not get entry from Kaltura. Reason: " . $ex->getMessage();
}
{% endhighlight %}

### Java

{% highlight java %}
package com.kaltura.code.example;
import com.kaltura.client.enums.*;
import com.kaltura.client.types.*;
import com.kaltura.client.services.*;
import com.kaltura.client.KalturaApiException;
import com.kaltura.client.KalturaClient;
import com.kaltura.client.KalturaConfiguration;
class CodeExample
{
  public static void main(String[] args)
  {
KalturaConfiguration config = new KalturaConfiguration();
config.setPartnerId(123); // where 123 is your partner ID config.setEndpoint("http://www.kaltura.com/"); if you want to communicate with a Kaltura server which isother than the default http://www.kaltura.com
KalturaClient client = new KalturaClient(config);
String entryId = null;
int version = 0;
String ks = client.generateSession( adminSecret, userId, type, partnerId, expiry, privileges );
client.setSessionId(ks); entryId = "XXXYYYZZZA"; // a known ID of media entry that you have
try{
    KalturaMediaEntry mediaEntry = client.getMediaService().get(entryId);
    System.out.print(mediaEntry.getName());
}catch(KalturaApiException e){
    System.out.print("could not get entry from Kaltura. Reason: "); e.printStackTrace();
}
  }
}
{% endhighlight %}

### C\#

{% highlight csharp %}
using System.Collections.Generic;
using System.Text;
using System.IO;
namespace Kaltura
{
  class CodeExample
  {
static void Main(string[] args)
    {
  KalturaConfiguration config = new KalturaConfiguration(123); // where 123 is your partner ID
  config.ServiceUrl = "http://www.kaltura.com/"; // if you want to communicate with a Kaltura server which is other than the default http://www.kaltura.com
  KalturaClient client = new KalturaClient(config);
  String ks = client.GenerateSession( adminSecret, userId, type, partnerId, expiry, privileges ); // GenerateSession method is already implemented in the C# library
  String entryId = null;
  int version = 0;
  client.KS = ks;
  entryId = "XXXYYYZZZA"; // a known ID of media entry that you have
  try {
      KalturaMediaEntry mediaEntry = client.MediaService.Get(entryId);
      System.Console.WriteLine(mediaEntry.name);
  } catch(KalturaException ex) {
      System.Console.WriteLine("could not get entry from Kaltura. ");
      System.Console.WriteLine("Reason: "); System.Console.WriteLine(ex.toString());
  }
    }
  }
}
{% endhighlight %}

### Python

{% highlight python %}
from KalturaClient import *
config = KalturaConfiguration(123) # where 123 is your partner ID
config.serviceUrl = "http://devtests.kaltura.co.cc/" # if you want to communicate with a Kaltura server which is other than the default http://www.kaltura.com
client = KalturaClient(config)
ks = client.generateSession(adminSecret, userId, type, partnerId, expiry, privileges)
client.setKs(ks)
entryId = "XXXYYYZZZA"; # a known ID of media entry that you have
try:
  mediaEntry = client.media.get(entryId)
  print mediaEntry.getName()
except KalturaException, e:
  print "could not get entry from Kaltura. Reason: %s" % repr(e)
{% endhighlight %}

### Ruby

{% highlight ruby %}
require "ruby_client.rb"
include Kaltura
config = KalturaConfiguration.new(123) # where 123 is your partner ID
config.service_url = 'http://www.kaltura.com/' # if you want to communicate with a Kaltura server which is
# other than the default http://www.kaltura.com
client = KalturaClient.new(config)
ks = client.session_service.start (secret, userId, type, partnerId, expiry, privileges)
client.ks = ks entry_id = 'XXXYYYZZZA'
media_entry = client.media_service.get(entry_id)
puts media_entry.name
{% endhighlight %}

>Note: The Ruby client library does not include a local generateSession function to generate a Kaltura session. Instead, use the session service to start a session.

### JavaScript

{% highlight javascript %}
<script type="text/javascript">
var kConfig;
var kClient;
var partnerId = 123; // where 123 is your partner ID
var userId = "someone";
var expiry = 86400; var privileges = ""; // call server side to generate a KS for you so secrets will not be compromised
var ks = ajaxGetKs(partnerId, userId, expiry, privileges);
var entryId = "XXXYYYZZZA"; // a known ID of media entry that you have
function pageLoad()
{
  kConfig = new KalturaConfiguration(partnerId);
  kConfig.serviceUrl = "http://www.kaltura.com"; // if you want to communicate with a Kaltura server which is
  // other than the default http://www.kaltura.com
  kClient = new KalturaClient(kConfig);
  kClient.ks = ks;
  getEntrySample();
  return false;
}
function getEntrySample()
{
  kClient.media.get(getEntryResult, entryId);
}
function getEntryResult(success, data)
{
  if (data.code) {
alert("Error: "+data.message);
  } else {
alert("Your entry name: "+data.name);
  }
}
</script>
{% endhighlight %}

#### Handling Secrets

Because JavaScript is a client-side programming language, secrets included in the code are compromised. Exposing secrets causes a security issue.

To avoid exposing the KS secret, Kaltura recommends calling an AJAX (or similar methodology) server‑side action that returns a KS. The sample code implements the recommendation:

{% highlight javascript %}
var ks = ajaxGetKs(partnerId, userId, expiry, privileges);
{% endhighlight %}

For more information about security issues related to accessing the Kaltura API using client-side technology, refer to [Kaltura API Authentication and Security](https://developer.kaltura.com/api-docs/VPaaS-API-Getting-Started/Kaltura_API_Authentication_and_Security.html).

### Objective-C/Cocoa

{% highlight objc %}
#import "KalturaClient.h"
#define SERVICE_URL (@"http://www.kaltura.com")
#define ADMIN_SECRET (@"1234abcd")
#define PARTNER_ID (1234)
#define USER_ID (@"user")
#define ENTRY_ID (@"0_12345678")
@interface GetEntrySample : NSObject - (void)sample; @end @implementation GetEntrySample - (void)sample
{
  KalturaClientConfiguration* config = [[KalturaClientConfiguration alloc] init];
  config.serviceUrl = SERVICE_URL;
  KalturaNSLogger* logger = [[KalturaNSLogger alloc] init];
  config.logger = logger;
  [logger release]; // retained on config
  config.partnerId = PARTNER_ID;
  KalturaClient* client = [[KalturaClient alloc] initWithConfig:config];
  [config release]; // retained on the client
  client.ks = [KalturaClient generateSessionWithSecret:ADMIN_SECRET withUserId:USER_ID withType:[KalturaSessionType ADMIN] withPartnerId:PARTNER_ID withExpiry:86400 withPrivileges:@""];
  KalturaMediaEntry* mediaEntry = [client.media getWithEntryId:ENTRY_ID];
  if (client.error != nil) NSLog(@"Failed to get entry, domain=%@ code=%d", error.domain, error.code);
  else NSLog(@"Entry name %@", mediaEntry.name); [client release];
}
@end
{% endhighlight %}
