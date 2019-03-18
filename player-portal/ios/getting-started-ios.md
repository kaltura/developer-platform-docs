---
layout: page
title: Getting started iOS
weight: 110
---

# Kaltura Player SDK 3.0 (iOS) 

This guide will walk you through the steps for adding a Kaltura video player to your iOS mobile application. You'll learn how to import the SDK, find the necessary credentials, and load the player with your Entry ID of choice. **Because the player is focused on performance and giving you the simplest integration possible, it does not contain a UI.** That being said, this guide will show you how to listen to events in order to manage the player state, as well as examples for adding play/pause buttons and a slider to the player. 
Lastly, this guide will cover how to add plugins to the application, specifically the Kaltura Video Analytics plugin.

If you're looking for the Android guide, click here. 

## Before Your Begin

You'll need two things: 
1. Your Kaltura Partner ID, which can be found in the KMC under Settings>Integration Settings 
2. Any video entry, which can be found in the KMC as well. 

### Getting Started with the Kaltura Cocoa Pods

You'll need to install a few Kaltura pods. Consider this sample Podfile 
```
source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

platform :ios, '9.0'

target 'OVPStarter' do
  pod 'PlayKit'
  pod 'PlayKitProviders'
end
```

- The [Playkit Pod](https://cocoapods.org/pods/PlayKit) is made up of the core Player infrastructure 
- The [PlatKitProviders Pod](https://cocoapods.org/pods/PlayKitProviders) adds the Media Entry Providers, which are responsible from bringing in media data from Kaltura 

If you don't have a Podfile already, create a file in your Project directory called Podfile (no extension). Paste the code from above and then run `pod install` from the command line (in that directory). You might need to close and reopen xcode. 

## Add a Basic Kaltura Player 

The code below will cover a few functions needed in order to get the bare bones of a kaltura player, as well as a few additional steps regarding implementing your player UI and adding plugins. 

### Setting Up 

In the Controller, import the relevant Kaltura Libraries 

```
import UIKit
import PlayKit
import PlayKitUtils
import PlayKitKava
import PlayKitProviders
```

Set your partner ID and entry ID 

```
let SERVER_BASE_URL = "https://cdnapisec.kaltura.com"
let PARTNER_ID = 0000000
let ENTRY_ID = "1_abc6st"
```

### Create a Kaltura Session 

The Kaltura Sesssion is an authorization string that identifies the user watching the video. Including a Kaltura Session (KS) in the player allows for monitoring and analytics of the video, as well as the ability to restrict content access. The KS would generally be created on the server side of the application, and passed to the controller. 

```
var ks: String?
```

However, if your application does not already create a Kaltura Session, follow [this guide](https://github.com/tzubeli/developer-portal/blob/master/sdk-portal/ios-kaltura-session.md) to learn how to generate a KS with the Application Token API. 


### Create the Player

Inside the class, below the `ks` declaration, add a declaration for the Player. 

```
var player: Player?
```

Now lets create our video player. Head over to the Storyboard and create a new PlayerView of the desired size. Add a referencing outlet to your ViewController named playerContainer. Create a new function called `playerSetup` and set the player variable to equal the new playerContainer 

```
func setupPlayer() {
    self.player?.view = self.playerContainer
}
```

Now in the `viewDidLoad` function, load the player. We'll start without a pluginConfig, but we will cover adding plugins later in this guide. 

 ```
self.player = try! PlayKitManager.shared.loadPlayer(pluginConfig: nil)
 ```
Next, call the newly created setupPlayer function. 
```
self.setupPlayer()
```

Now create and call a new function called `loadMedia`. 

```
self.loadMedia()
```

In the loadMedia function, you'll use the `SimpleSessionProvider` and `OVPMediaProvider` objects. 

```
let sessionProvider = SimpleSessionProvider(serverURL: SERVER_BASE_URL, partnerId: Int64(PARTNER_ID), ks: ks)
let mediaProvider: OVPMediaProvider = OVPMediaProvider(sessionProvider)
```

Now set your entry ID on that `mediaProvider`

```
mediaProvider.entryId = ENTRY_ID
```

Load the media by creating a `MediaConfig` with a video start time of zero seconds, and then passing that config to `player.prepare()`

```
mediaProvider.loadMedia { (mediaEntry, error) in
    if let me = mediaEntry, error == nil {
    
        let mediaConfig = MediaConfig(mediaEntry: me, startTime: 0.0)

        self.player.prepare(mediaConfig)
    }
}
```

The `loadMedia` function should now look like this: 

```
func loadMedia() {

    let sessionProvider = SimpleSessionProvider(serverURL: SERVER_BASE_URL, partnerId: Int64(PARTNER_ID), ks: ks)

    let mediaProvider: OVPMediaProvider = OVPMediaProvider(sessionProvider)

    mediaProvider.entryId = ENTRY_ID

    mediaProvider.loadMedia { (mediaEntry, error) in
        if let me = mediaEntry, error == nil {

            let mediaConfig = MediaConfig(mediaEntry: me, startTime: 0.0)

            self.player.prepare(mediaConfig)

        }
    }
}
```
At this point, you should be able to successfully run the code and see your video player in the app. Your code would look like this: 

```
import UIKit
import PlayKit
import PlayKitUtils
import PlayKitProviders

let SERVER_BASE_URL = "https://cdnapisec.kaltura.com"
let PARTNER_ID = 1424501
let ENTRY_ID = "1_djnefl4e"

class ViewController: UIViewController {
    
    var ks: String?
    var player: Player!
    
    @IBOutlet weak var playerContainer: PlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.player = try! PlayKitManager.shared.loadPlayer(pluginConfig: createPluginConfig())
        
        self.setupPlayer()
        self.loadMedia()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupPlayer() {
        self.player?.view = self.playerContainer
    }
    
    func loadMedia() {
        let sessionProvider = SimpleSessionProvider(serverURL: SERVER_BASE_URL, partnerId: Int64(PARTNER_ID), ks: ks)
        
        let mediaProvider: OVPMediaProvider = OVPMediaProvider(sessionProvider)
        
        mediaProvider.entryId = ENTRY_ID
        
        mediaProvider.loadMedia { (mediaEntry, error) in
            if let me = mediaEntry, error == nil {
                
                let mediaConfig = MediaConfig(mediaEntry: me, startTime: 0.0)
                
                if let player = self.player {
                    player.prepare(mediaConfig)
                }
            }
        }
    }
}

```

You've probably noticed that there are no buttons for playing or pausing the video. To learn about adding elements to the Player's UI, [click here](https://github.com/tzubeli/developer-portal/blob/master/sdk-portal/ios-ui.md) 

The Kaltura Player SDK also offers various plugins for iOS that can be added to the player. Learn more [here](https://github.com/tzubeli/developer-portal/blob/master/sdk-portal/ios-plugins.md). 



