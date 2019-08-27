---
layout: page
title: Kaltura Session authentication for iOS
weight: 110
---

# Kaltura Session Authentication 

The Kaltura Session is an authorization string that identifies the user watching the video. This guide will demonstrate how to create a Kaltura Session on the client side using the Application Token API. An Application Token is used in cases where different applications with varying permissions need access to your Kaltura account, without using your Admin Secret. The appToken is created and customized by the account administrator, and then used by the developers to generate Kaltura Sessions for their respective applications. 


### Create the Application Token 

You can create an appToken with the [appToken.add](https://developer.kaltura.com/console/service/appToken/action/add) action. Once you've created it, hold on to its token and ID as you'll need those to create the session. You can also see a list of all available appTokens by using [appToken.list](https://developer.kaltura.com/console/service/appToken/action/list). 

There are a few steps to creating a KS with an appToken.
1. **Generate a basic kaltura session:** because all calls to the API *must* include a Kaltura Session, we first use the session API to create what is called a **widget session**, which has limited functionality and is used in the following steps 
2. **Create a Token Hash** of the appToken token and the widget session, combined. 
3. **Call the appToken.startSession API** with the widget session, the appToken ID, and the hash string. 
You can see all these steps interactively with [this workflow](https://developer.kaltura.com/workflows/Generate_API_Sessions/App_Token_Authentication), or read the guide [here](https://developer.kaltura.com/api-docs/VPaaS-API-Getting-Started/application-tokens.html), but examples below are written for client-side swift code. 

Let's get started. If you're already creating a Kaltura Session on the server side, you can skip these steps. 

**Step 1: Generate a widget session** 
To get a basic KS, we need to construct a URL request to the [session.startWidgetSession](https://developer.kaltura.com/api-docs/service/session/action/startWidgetSession) service. It needs your widget ID, which is basically just your partnerID with an underscore prefix. 
So let's create a function called `generateWidgetSession()` and form that URL. 

{% highlight swift %}
func generateWidgetSession() -> String {
    let widgetPartnerId = "_\(PARTNER_ID)"
    let widgetKsURL = NSString(format:"https://www.kaltura.com/api_v3/service/session/action/startWidgetSession?widgetId=%@&format=1",widgetPartnerId)
{% endhighlight %}

Call the endpoint and extract the `ks` string from the response. Your code should obviously include more error handling than this example. The complete function looks something like this: 

{% highlight swift %}
func generateWidgetSession() -> String {
    let widgetPartnerId = "_\(PARTNER_ID)"

    let widgetKsURL = NSString(format:"https://www.kaltura.com/api_v3/service/session/action/startWidgetSession?widgetId=%@&format=1",widgetPartnerId)

    let widgetKsData = try! Data(contentsOf: URL(string: widgetKsURL as String)!)

    let widgetKsDict = try! JSONSerialization.jsonObject(with: widgetKsData, options: []) as! [String:Any]

    return (widgetKsDict["ks"] as! String)
    }
{% endhighlight %}

We will call this function from another new function called `generateSession()` where you should call the create new variables for the widgetSession, appToken, the appToken ID, and the userId - which can be any string that identifies the user creating the session. 

{% highlight swift %}
func generateSession() {
    let widgetKs: String = generateWidgetSession()
    let appToken = "<TOKEN_OF_APP_TOKEN>"
    let appTokenId = "<ID_OF_APP_TOKEN>"
    let userId = "user"
{% endhighlight %}

**Step 2: Create the token hash**

You'll need to install and import a library of your choice for creating the hash string. We chose a library called [Arcane](https://cocoapods.org/pods/Arcane) which is like the Obj-C CommonCrypto library. Concatenate the widget session with the appToken token, and create the hash string. *Note that you must use the same Hash Type that you used to create the appToken.*

{% highlight swift %}
let tokenHash: String = Hash.SHA256("\(widgetKs)\(appToken)")!
{% endhighlight %}

**Step 3: Get the Kaltura Session** 

Once you have that hash string, you can now form the URL, make the call to [appToken.startSession](https://developer.kaltura.com/console/service/appToken/action/startSession), and extract the KS from the response. Again, a proper application should include error handling when making calls to the API. 

{% highlight swift %}
let URLString = NSString(format:"https://www.kaltura.com/api_v3/service/apptoken/action/startsession?ks=%@&userId=%@&id=%@&tokenHash=%@&format=1",widgetKs,userId,appTokenId,tokenHash)

let ksData = try! Data(contentsOf: URL(string: URLString as String)!)

let ksDict = try! JSONSerialization.jsonObject(with: ksData, options: []) as! [String:Any]
{% endhighlight %}

Lastly, set the application's `ks` to the newly generated KS:

{% highlight swift %}
self.ks = (ksDict["ks"] as! String)
{% endhighlight %}

The complete `generateSession()` function looks like this: 
{% highlight swift %}
func generateSession() {
    let appToken = "c9883312395bf5ed4fd5c9a5d86c985c"
    let userId = "avital.tzubeli@kaltura.com"
    let appTokenId = "0_xeu31jy5"

    let widgetKs: String = generateWidgetSession()

    let tokenHash: String = Hash.SHA256("\(widgetKs)\(appToken)")!

    let URLString = NSString(format:"https://www.kaltura.com/api_v3/service/apptoken/action/startsession?ks=%@&userId=%@&id=%@&tokenHash=%@&format=1",widgetKs,userId,appTokenId,tokenHash)

    let ksData = try! Data(contentsOf: URL(string: URLString as String)!)
    let ksDict = try! JSONSerialization.jsonObject(with: ksData, options: []) as! [String:Any]

    self.ks = (ksDict["ks"] as! String)
}
{% endhighlight %}
> Note that if an appToken is deleted, it can no longer be used for session creation. 
