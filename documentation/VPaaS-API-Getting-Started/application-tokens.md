---
layout: page
title: Application Tokens
weight: 110
---

An Application Token is useful in cases where different applications with varying permissions need access to your Kaltura account, without using your Admin Secret. It enables clients to provide their development partners or internal technical teams with restricted access to the Kaltura API. 

The appToken is **created and customized by the account administrator**, and then used by the developers to generate Kaltura Sessions for their respective applications. This allows access to the API to be revoked at any time with the deletion of the appToken. 

## Before You Start

Before you create an appToken, you need to decide whether to create a "blank" appToken, or one preconfigured with permissions. If your only concern is giving access without sharing your Admin secret, a basic appToken is sufficient. But if you want to always limit the permissions of a specific application, you'll need to create the appToken with pre-configured [privileges](https://developer.kaltura.com/api-docs/VPaaS-API-Getting-Started/Kaltura_API_Authentication_and_Security.html). Similarly, it is also possible to limit the appToken to a particular user ID should your implementation call for it. 

> Note: Any configurations (privileges or user ID) included in the creation of the appToken ([`appToken.add`](https://developer.kaltura.com/console/service/appToken/action/add)) *cannot* be overridden when the session is created with that appToken ([`appToken.startSession`](https://developer.kaltura.com/console/service/appToken/action/startSession)). 

The **privileges string** that could be included in the appToken is made up of `key:value` pairs that determine the actions available to this Kaltura Session. The following are common privileges for limiting your appTokens access: 

- `setrole`: When assigning App Tokens to your apps, the easiest way to configure the permitted actions is with User Roles. Roles are created [in the KMC](https://kmc.kaltura.com/index.php/kmcng/administration/roles/list), and give you the option of adding and removing specific actions available to the app. The ID of the Role is then mapped to the `setrole` privilege key in the permissions string. This allows you to easily manage the permitted actions by editing the role at any time after.
- `privacycontext`: If you want to limit the app to the content of a specific category, you could [set entitlements](https://kmc.kaltura.com/index.php/kmcng/settings/integrationSettings) on that category and map it to the `privacycontext` key (examples below). Keep in mind however, that if you set the category's Content Privacy to Private, all end users who will need to access the content in this category must be added as members of the category.

> Note: While a user ID *can* be added to an App Token during session generation (if no user ID was specified in the App Token creation), privileges can NOT be added during session generation. 


## Creating the App Token 

We'll create an AppToken using the [`appToken.add`](https://developer.kaltura.com/console/service/appToken/action/add) API. Possible parameters include: 

| Name        | Type | Writable | Description|
|:------------ |:------------------|:------------------|:------------------|
| sessionType  | int | V         |	The type of Kaltura Session (KS) that was created using the current token.This value should be set to 0 (USER-level KS) for most use cases. Use 2 (ADMIN-level KS) only for testing or advanced use cases. |
| description  | string | V         |	A description and purpose of the Application Token; important for keeping track of various tokens. |
| sessionDuration  | int | V         |	Length of time for which the KS created from this Application Token will be valid. The default is 24-hours (86400 seconds). | 
| sessionPrivileges  | string | V         |	The privileges that will be imparted to KS generated with this Application token. |
| sessionUserId  | string | V         |	ID of the Service User that will provide entitlements for the KS created using this Application Token.  | 
| expiry  | int | V         |	The date and time when this Application Token will expire. This must be provided in a UNIX timestamp format (Epoch time). This field is mandatory and should be set when creating the application token. | 
| hashType  | string | V         |	One of the following:	MD5, SHA1 (default), SHA256, SHA512| 

### Session Type 

Notice that the App Token has a sessionType. If set to type **ADMIN** (2), any session created with it will be a **ADMIN** session, meaning that mostly all actions will be permitted. *Never* use a KalturaSessionType **ADMIN** in a session generated for end users. 
If set to **USER** (0), however, various actions will not be available. A **USER** App Token would be useful, for example, in cases where the application is only uploading media but not viewing it afterwards. 

### Session Expiry

Every token will have a hardcoded expiration date. For short-lived projects, this date can be set only a few months or years into the future. It's also possible to create long-lived Application Tokens that will remain active decades into the future. Note that it's always possible to delete or deactivate an Application Token.

**The expiration date is set using a UNIX timestamp format (Epoch time).**

### HASH Type

We recommend using hash of type [`SHA256`](https://en.wikipedia.org/wiki/SHA-2), but whichever you use, make sure to be consistent between the AppToken creation and the session creation. 

### Session Privileges 

The sessionPrivilege parameter is a string containing two pieces of information: `privacyContext`, which determines which content is available to this session, and `userRole`, which sets the permissions, or actions the user can perform on that content.

## Basic App Token 

We'll start with an App Token without privileges, without a user, and without an expiry date, using [`appToken.add`](https://developer.kaltura.com/console/service/appToken/action/add):

{% code_example apptoken1 %}
&nbsp;


In the result you'll see an `id` as well as a `token`. Hold on to those as you'll need them for session creation. You can also view all your App Tokens with the [`appToken.list`](https://developer.kaltura.com/console/service/appToken/action/list) action. 

### Set a User Role

The easy way to create a **User Role** is [in the KMC](https://kmc.kaltura.com/index.php/kmcng/administration/roles/list). You'll have options to name and describe the new role (make it specific) and then select permitted actions. You'll see that for each category, there is the option to allow all permissions, or to toggle specific permissions: 

* Full Permission (checked) – Grants read-write access to the specified functionality. Includes the add/update/delete/list/get API actions for the relevant API service(s).
* View-Only Permission (partially checked) – Read-only (get/list) functions will be allowed. Write actions will be blocked.
* No Permission (cleared) – No access to the API service(s) associated with the listed functions.

For example, under Content Moderation, you may allow this **User Role** to perform all actions except for deleting. You can also switch off a specific category altogether. Hit save and you should now see your new **User Role** in the list. 

Alternatively, if you know exactly which actions you'd like to include in your **User Role**, you can use the [`userRole.add`](https://developer.kaltura.com/console/service/userRole/action/add) API action to create a new role. You can see all of the available permission names and descriptions by listing them with [`permission.list`](https://developer.kaltura.com/console/service/permission/action/list). Be sure to set the status of your role to Active (1).

> Note: You will not be able to see in the KMC any roles that are created outside the KMC (for example via the API).

You can get a list of all your existing roles, with the [`userRole.list`](https://developer.kaltura.com/console/service/userRole/action/list) action. Make note of the `id` of your new **User Role** as you'll be needing it for your App Token, where you can set the role like this: 

{% code_example apptoken2 %}
&nbsp;


### Add a Privacy Context 

Adding a privacy context will limit the session to the contents of a particular category.  
To enable entitlements on the category, select Add Entitlements in the Integration Settings in [KMC](https://kmc.kaltura.com/index.php/kmcng/settings/integrationSettings). Then select a category and give it a Privacy Context Label. That is the name that should be used in the Privileges String when adding the `privacycontext` key. 

{% code_example apptoken3 %}
&nbsp;

To learn more about KS privileges, see the [Kaltura API Authentication and Security](https://developer.kaltura.com/api-docs/VPaaS-API-Getting-Started/Kaltura_API_Authentication_and_Security.html) guide.


### Add a User to the Category

If you set the Content Privacy setting of that category to Private, for users to access this category, they will also need to be members of the category, which can be done in the Entitlements tab in the Category Settings. You can also use the [`categoryUser.add`](https://developer.kaltura.com/console/service/categoryUser/action/add) action, where you'll need the category ID and the user ID, which can be any string identifying that user. 

{% code_example apptoken4 %}
&nbsp;


### Add a User to the App Token 

In cases where you'd like to use App Tokens to grant access to particular users, you can include the user ID during the creation of the App Token (`appToken.add`). When including a user ID in the App Token object, that user ID can not be overridden when calling `appToken.startSession`. This can be useful when wanting to grant particular users with API access and ensure they can not mask their ID as someone else while carrying API actions.

Let's bring it all together. We have a user. We have a User Role, and its ID. We will use hash of type `SHA256` and give the session a duration of one day. 

{% code_example apptoken5 %}
&nbsp;

> Reminder: You can get a list of all your App Tokens with the [`appToken.list`](https://developer.kaltura.com/console/service/appToken/action/list) action. 

## Generate Kaltura Sessions with the App Token 

The Kaltura Session generated with the App Token will have the content and action permissions that were configured in the App Token. 

### Step 1: Create a Kaltura Session 

Because a Kaltura Session is required for every call to the API, we'll need to create an unprivileged session before being able to create the App Token session. We use the [`session.startWidgetSession`](https://developer.kaltura.com/console/service/appToken/action/startSession) action with the widget ID, which is your partner ID with an underscore prefix. 

{% code_example apptoken6 %}
&nbsp;


The result will contain that unprivileged KS which you need for the next step.

### Step 2: Compute the Token Hash

We'll create a hash of the App Token `token` value together with the unprivileged KS, using a hash function in the language of your choice. 

> Important Note: Make sure to use the same hash type as the one used for creating the App Token.

{% code_example apptoken7 %}
&nbsp;


The resulting string is the `tokenHash` which you'll use in the next step. 

### Step 3: Generate the Session 

We'll use the [`App Token.startSession`](https://developer.kaltura.com/console/service/appToken/action/startSession) action with the unprivileged KS, the hashToken, and the token `ID`: 

> Note: If you created an App Token with a user ID, it will override any user ID value used in `appToken.startSession`. 

{% code_example apptoken8 %}
&nbsp;


You'll notice that the response contains any existing configurations from the App Token creation, regardless of what was passed in during the startSession. The expiry is set to an hour (although you can change this), meaning that after that time has passed, a new session will need to be generated. So if you wish to change permissions on this App Token, you can make those changes to the Role, User, or Privacy Context associated with the App Token. 

To learn more about Kaltura Security, read the [Authentication and Security](https://developer.kaltura.com/api-docs/VPaaS-API-Getting-Started/Kaltura_API_Authentication_and_Security.html) guide.

If you're only just getting started with the Kaltura API, check out the [Getting Starting Guide](https://developer.kaltura.com/api-docs/VPaaS-API-Getting-Started/Getting-Started-VPaaS-API.html/). 


