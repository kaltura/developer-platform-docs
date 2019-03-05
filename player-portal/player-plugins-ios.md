# Player Plugins  

The Kaltura playkit offers various modules for iOS that can be added to the player. Adding plugins is easy and requires little configuration. You can find a full list of available plugins [here](https://kaltura.github.io/playkit/). This guide will walk you through installing the KAVA plugin. 

### Kava Plugin 

Probably the most important plugin is the KAVA plugin - Kaltura Video Analytics. It provides real time analytics for live and on-demand video. With historical, raw, or summarized data, it is easy to determine how, when, and where content was seen and shared by viewers. 

The [KAVA plugin](https://github.com/kaltura/playkit-ios-kava) is available through CocoaPods as "PlayKitKava". It was included in the Podfile at the beginning of the guide. To use the plugin, we'll need to import it, then register and configure it. 

```
import PlayKitKava
```

Begin with a function that creates the KAVA plugin. It requires the Partner ID, the entry ID, and the KS, which is what identifies the user. The rest of the arguments are optional. Full documentation can be found here. 

```
func createKavaConfig() -> KavaPluginConfig {
    return KavaPluginConfig(partnerId: PARTNER_ID, entryId: entryId, ks: ks, playbackContext: nil, referrer: nil, applicationVersion: nil, playlistId: nil, customVar1: nil, customVar2: nil, customVar3: nil)
}
```

Add that plugin to the player in the `loadMedia` function by calling `player.updatePluginConfig`. This should be included before the `player.prepare`.

```
player.updatePluginConfig(pluginName: KavaPlugin.pluginName, config: self.createKavaConfig())
```

Next, you need a function that manages all the plugins you might want to add to the player. In our case, it will return the function we just created. 

```
func createPluginConfig() -> PluginConfig? {
    return PluginConfig(config: [KavaPlugin.pluginName: createKavaConfig()])
}
```

Lastly, we'll pass that function instead of `nil` to the loadPlayer call in `viewDidLoad`:

```
self.player = try! PlayKitManager.shared.loadPlayer(pluginConfig: createPluginConfig())
```

The KAVA plugin is now included in the player, and all data about plays and shares can be viewed in the KMC or retrieved using the Kaltura Reporting API. 
