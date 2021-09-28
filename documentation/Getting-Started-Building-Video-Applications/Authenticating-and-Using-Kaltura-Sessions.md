---
layout: page
title: Authenticating and Using Kaltura Sessions
weight: 110
---

# Authenticating and Using Kaltura Sessions 

Because the Kaltura API is stateless aka [REST](http://en.wikipedia.org/wiki/Representational_state_transfer), every request requires an authentication session aka the Kaltura Session (KS), identifying the account on which the action is to be carried, the authenticated user and its role.

With the client library, it’s easy to set using the [`session.start`](https://developer.kaltura.com/console/service/session/action/start) API action, like this:

{% code_example session %}

*Specifying an `app id` which contains the name and domain of the app allows you to get specific analytics per application, for cases where you’re running your application on various domains.*

Try it interactively [with this workflow](https://developer.kaltura.com/workflows/Generate_API_Sessions/Authentication). 

### Methods for Generating a Kaltura Session  

There are three methods for generating a Kaltura Session:

* Calling the [session.start action](https://developer.kaltura.com/api-docs/Generate_API_Sessions/session/session_start): This method is recommended for scripts and applications to which you alone will have access.
* Using the [apptoken service](Application-Tokens.html): This method is recommended when providing access to scripts or applications that are managed by others; this method provides tools to manage API tokens per application provider, revoke access to specific applications, and more.
* Calling the [user.loginByLoginId action](https://developer.kaltura.com/api-docs/Generate_API_Sessions/user_loginByLoginId): This method is recommended for managing registered users in Kaltura, and allowing users to log in using email and password. When you log in to the KMC, the KMC application calls the user.loginByLoginId action to authenticate you using your registered email and password. 

## Important Notes When Generating Kaltura Sessions

1.  Familiarize yourself with the concepts of user roles, privileges, access control and entitlements by reading the  [Kaltura API Authentication and Security Guide](Kaltura_API_Authentication_and_Security.html)  to ensure that your application is secured. 
2.  Sharing the account API secret keys with 3rd party vendors should be avoided, as secret keys can not be regenerated or blocked for access. Kaltura API based application developers and 3rd party application vendors should build their application to leverage the appToken API to manage (create and revoke access) application tokens.
3.  To ensure best security and analytics tracking during playback, always pass a Kaltura Session to the player embed.
4.  To ensure tracking of end-user analytics, always pass a value to the userId field that is truly unique and represents a unique user in your system. 
5.  To ensure tracking of application level analytics make sure to pass the appid privilege (in the format of "appid:$appName-$appDomain" where $appName is a unique string to identify your application and appDomain is the domain where this app is hosted).

 > Note: To use the Kaltura API, you will need a Publisher Account with API access. [Get a free Kaltura VPaaS trial](https://vpaas.kaltura.com/register.html).

## The Kaltura Media Access Control Model

An [Access Control Profile](../Video-On-Demand-and-Digital-Assets-Management/Media-Access-Control.html) defines authorized and restricted domains where your content can or cannot be displayed, countries from which it can or cannot be viewed, white and black lists of IP addresses and authorized and unauthorized domains and devices in which your media can be embedded.

For information on Kaltura session-based restrictions, refer to [Kaltura’s API Authentication and Security](http://knowledge.kaltura.com/node/229). 

## Managing End-User Content Entitlements

[Content Entitlements](https://developer.kaltura.com/api-docs/Secure_Control_and_Govern/Content-Categories-Management.html#Managing End-User Content Entitlements) is a method to allow end users access to a group of content items (entries).
Entitlements are configured on the category level by setting a special unique key to identify the applicative context in which to allow or deny access to the category’s entries.

Applications such as [Kaltura MediaSpace](http://corp.kaltura.com/Products/Video-Applications/Kaltura-Mediaspace-Video-Portal) implement entitlements to achieve the concept of “Authenticated Content Channels”.
Example use-cases based on content entitlements:

- group collaboration based on channel membership
- premium content - get access to channels/categories based on a paid subscription

