
## Supported Analytics for iOS SDK 

Kaltura’s Mobile Video Player SDKs for iOS make it easy for you to integrate analytics data collection, by providing you with several analytics solutions.

>**Important**: Best practice for using analytics is to register plugins in the `AppDelegate` file.

## Youbora Plugin  

This section describes the steps required for implementing the Youbora Plugin on iOS devices. Youbora is an intelligence analytics and optimization platform used in Kaltura's solution to track media analytics events. 

You'll need to set up an account in http://www.youbora.com and then set the account details in the plugin configuration to use this plugin. After these steps, you'll be able to use the Youbora dashboard and watch statistical events and analytics sent by the Kaltura Video Payer.

For additional information on the YouboraPlugin options dictionary refer to their [developer portal](http://developer.nicepeopleatwork.com/plugins/general/setting-youbora-options/).

### Getting Started with the Youbora Plugin  

To enable the Youbora Stats Plugin on iOS devices for the Kaltura Video Player, add the following line to your Podfile: 

```ruby
pod 'PlayKit/YouboraPlugin'
```

#### Register Plugin

```swift
PlayKitManager.shared.registerPlugin(YouboraPlugin.self)
```

#### Create a Config and Load Player

```swift
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
```

>Note: Only now load the player with the Plugin Config.

## TVPAPI Analytics Plugin  

This section describes the steps required for using the TVPAPI analytics plugin on iOS devices to get statistical information on the device, as well as the events supported by the plugin.

### Getting Started with the TVPAPI Plugin  

#### Enabling the TVPAPI Analytics Plugin for the Kaltura Video Player  

To enable the TVPAPI analytics plugin on iOS devices for the Kaltura Video Player, add the following line to your Podfile: 

```ruby
pod 'PlayKit/PhoenixPlugin'
```

#### Register the TVPAPI Analytics Plugin  

Register the TVPAPI analytics plugin in your application as follows:

>swift

```swift
PlayKitManager.shared.registerPlugin(TVPAPIAnalyticsPlugin.self)
```

#### Create a Config and Load Player

```swift
// config params, defaults values, insert your data instead
let initObject: [String: Any] =  [
            "Token": "",
            "SiteGuid": "",
            "ApiUser": "",
            "DomainID": "",
            "UDID": "",
            "ApiPass": "",
            "Locale": [
                "LocaleUserState": "",
                "LocaleCountry": "",
                "LocaleDevice": "",
                "LocaleLanguage": ""
            ],
            "Platform": ""
        ]
         
let tvpapiPluginConfig = TVPAPIAnalyticsPluginConfig(baseUrl: "",
                                               timerInterval: 30,
                                                  initObject: initObject)
// create config dictionary
let config = [TVPAPIAnalyticsPlugin.pluginName: tvpapiPluginConfig]
// create plugin config object
let pluginConfig = PluginConfig(config: config)
// load the player with the created plugin config
let player = PlayKitManager.shared.loadPlayer(pluginConfig: pluginConfig)
```

## Phoenix Analytics Plugin  

This section describes the steps required for configuring the Kaltura Video Player to use the Phoenix Stats Plugin on iOS devices as well as the supported plugin events. This will enable you to obtain important statistical information about usage.

### Getting Started with the Phoenix Plugin  

To enable the Phoenix Analytics plugin on iOS devices for the Kaltura Video Player, add the following line to your Podfile: 

```ruby
pod 'PlayKit/PhoenixPlugin'
```

##### Register the Phoenix Analytics Plugin  

Register the Phoenix Analytics plugin in your application as follows:

```swift
PlayKitManager.shared.registerPlugin(PhoenixAnalyticsPlugin.self)
```

#### Create a Config and Load Player  

```swift
// set config. this are defaults values, insert your data instead
let config = [
    PhoenixAnalyticsPlugin.pluginName: PhoenixAnalyticsPluginConfig(baseUrl: "",
                                                              timerInterval: 30,
                                                                         ks: "",
                                                                  partnerId: 0)
]
// create plugin config object
let pluginConfig = PluginConfig(config: config)
// load the player with the created plugin config
let player = PlayKitManager.shared.loadPlayer(pluginConfig: pluginConfig)
```

## OTT Stats Plugin Info  

This section provides additional information on the OTT Stats plugin.

### OTT Stats Plugin Supported Events  

The OTT Stats Plugins (Phoenix, TVPAPI) supports the following events:

```swift
enum OTTAnalyticsEventType: String {
    case hit
    case play
    case stop
    case pause
    case firstPlay
    case swoosh
    case load
    case finish
    case bitrateChange
    case error
}
```

### Concurrency Handler  

To receive concurrency events from the OTT Stats Plugin, you'll need to add a listener to the following event:

```swift
self.playerController.addObserver(self, events: [OttEvent.concurrency]) { event in
    // handle concurrency event
}                   
```

</p></details>

## Code Sample

[PlayKit iOS samples](https://github.com/kaltura/playkit-ios-samples) repo has a dedicated samples with more details.

## Have Questions or Need Help?

Check out the [Kaltura Player SDK Forum](https://forum.kaltura.org/c/playkit) page for different ways of getting in touch.
