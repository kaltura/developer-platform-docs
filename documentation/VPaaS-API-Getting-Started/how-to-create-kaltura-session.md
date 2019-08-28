---
layout: page
title: How to Create a Kaltura Session
weight: 103
---

The Kaltura API is representational state transfer [REST](http://en.wikipedia.org/wiki/Representational_state_transfer), which is a style of software architecture for distributed systems such as the World Wide Web. REST has emerged over the past few years as a predominant Web service design model. REST has increasingly displaced other design models such as SOAP and WSDL due to its simpler style and [statelessness](http://en.wikipedia.org/wiki/Stateless_protocol). Every call (request) made to the Kaltura API requires an authentication key, the Kaltura Session (aka KS), identifying the account on which the action to be carried, the authenticated user and its role.

### Methods for Generating a Kaltura Session  

There are three methods for generating a Kaltura Session:

* Calling the [session.start action](https://developer.kaltura.com/api-docs/Generate_API_Sessions/session/session_start): This method is recommended for scripts and applications to which you alone will have access.
* Using the [appToken service](https://developer.kaltura.com/api-docs/VPaaS-API-Getting-Started/application-tokens.html): This method is recommended when providing access to scripts or applications that are managed by others; this method provides tools to manage API tokens per application provider, revoke access to specific applications, and more.
* Calling the [user.loginByLoginId action](https://developer.kaltura.com/api-docs/Generate_API_Sessions/user_loginByLoginId): This method is recommended for managing registered users in Kaltura, and allowing users to log in using email and password. When you log in to the KMC, the KMC application calls the user.loginByLoginId action to authenticate you using your registered email and password. 

## Important Notes When Generating Kaltura Sessions

1.  Familiarize yourself with the concepts of user roles, privileges, access control and entitlements by reading the [Kaltura API Authentication and Security guide](https://developer.kaltura.com/api-docs/VPaaS-API-Getting-Started/Kaltura_API_Authentication_and_Security.html) to ensure that your application is secured. 
2.  Sharing the account API secret keys with 3rd party vendors should be avoided, as secret keys can not be regenerated or blocked for access. Kaltura API based application developers and 3rd party application vendors should build their application to leverage the appToken API to manage (create and revoke access) application tokens.
3.  To ensure best security and analytics tracking during playback, always pass a Kaltura Session to the player embed.
4.  To ensure tracking of end-user analytics, always pass a value to the userId field that is truly unique and represents a unique user in your system. 
5.  To ensure tracking of application level analytics make sure to pass the appid privilege (in the format of "appid:$appName-$appDomain" where $appName is a unique string to identify your application and appDomain is the domain where this app is hosted).

 > Note: To use the Kaltura API, you will need a Publisher Account with API access. [Get a free Kaltura VPaaS trial](https://vpaas.kaltura.com/register.html).
