---
layout: page
title: Analytics Plugins for iOS
weight: 110
---

The Kaltura playkit offers various analytics modules for iOS that can be added to the player. Adding these plugins is easy and requires little configuration. You can find a full list of available plugins [here](https://kaltura.github.io/playkit/). This guide will cover a thorough implementation of the Kava Plugin, as well as a sample config for the Youbora plugin.

## Kava Plugin 

Probably the most important plugin is the KAVA plugin - Kaltura Video Analytics. It provides real time analytics for live and on-demand video. With historical, raw, or summarized data, it is easy to determine how, when, and where content was seen and shared by viewers. 

The [KAVA plugin](https://github.com/kaltura/playkit-ios-kava) is available through CocoaPods as "PlayKitKava". It was included in the Podfile at the beginning of the guide. To use the plugin, we'll need to import it, then register and configure it. 

{% highlight swift %}
import PlayKitKava
{% endhighlight %}

Begin with a function that creates the KAVA plugin. It requires the Partner ID, the entry ID, and the KS, which is what identifies the user. The rest of the arguments are optional. Full documentation can be found here. 

{% highlight swift %}
func createKavaConfig() -> KavaPluginConfig {
    return KavaPluginConfig(partnerId: PARTNER_ID, entryId: entryId, ks: ks, playbackContext: nil, referrer: nil, applicationVersion: nil, playlistId: nil, customVar1: nil, customVar2: nil, customVar3: nil)
}
{% endhighlight %}

Add that plugin to the player in the `loadMedia` function by calling `player.updatePluginConfig`. This should be included before the `player.prepare`.

{% highlight swift %}
player.updatePluginConfig(pluginName: KavaPlugin.pluginName, config: self.createKavaConfig())
{% endhighlight %}

Next, you need a function that manages all the plugins you might want to add to the player. In our case, it will return the function we just created. 

{% highlight swift %}
func createPluginConfig() -> PluginConfig? {
    return PluginConfig(config: [KavaPlugin.pluginName: createKavaConfig()])
}
{% endhighlight %}

Lastly, we'll pass that function instead of `nil` to the loadPlayer call in `viewDidLoad`:

{% highlight swift %}
self.player = try! PlayKitManager.shared.loadPlayer(pluginConfig: createPluginConfig())
{% endhighlight %}

The KAVA plugin is now included in the player, and all data about plays and shares can be viewed in the KMC or retrieved using the Kaltura Reporting API. 


## Youbora Plugin  

Youbora is an intelligence analytics and optimization platform used in Kaltura's solution to track media analytics events. 

You'll need to set up an account in http://www.youbora.com and then set the account details in the plugin configuration to use this plugin. After these steps, you'll be able to use the Youbora dashboard and watch statistical events and analytics sent by the Kaltura Video Payer.

For additional information on the YouboraPlugin options dictionary refer to their [developer portal](http://developer.nicepeopleatwork.com/plugins/general/setting-youbora-options/).

### Getting Started with the Youbora Plugin  

Import and enable: 

{% highlight swift %}
pod "PlayKit/YouboraPlugin"
{% endhighlight %}

{% highlight swift %}
PlayKitManager.shared.registerPlugin(YouboraPlugin.self)
{% endhighlight %}

A sample Youbora config looks something like this: 

{% highlight swift %}
// config options
let youboraOptions: [String: Any] = [
    "accountCode": "nicetest" // mandatory
    // YouboraPlugin.enableSmartAdsKey: true - use this if you want to enable smart ads
]
// create analytics config with the created params
let youboraConfig = AnalyticsConfig(params: youboraOptions)
// create config dictionary
let config = [YouboraPlugin.pluginName: youboraConfig]
// create plugin config object
let pluginConfig = PluginConfig(config: config)
// load the player with the created plugin config
let player = PlayKitManager.shared.loadPlayer(pluginConfig: pluginConfig)
{% endhighlight %}
