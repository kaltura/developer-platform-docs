---
layout: page
title: Download-to-go for iOS
weight: 110
---

Download to Go (DTG) is an iOS library that facilitates the download of HLS video assets.

## Supported Features 
- Downloading Kaltura HLS assets (Clear only)
- Background downloading.
- Resuming interrupted/paused downloads.

## Known Limitations
- No track selection (downloads all tracks)
- Can't play downloaded assets in background

## Installation

### [CocoaPods][cocoapods]

Add this to your podfile:

{% highlight swift %}
pod "DownloadToGo"
{% endhighlight %}

## Overview

### Simple Flow

![](simple-flow.svg)

<div hidden>
{% plantuml %}
	@startuml 
	
	title Simple DTG Flow
	
	[*] --> New : Add Item
	
	New --> MetadataLoaded : Load Item Metadata
	
	MetadataLoaded -> InProgress : Start Item
	MetadataLoaded -> Failed : Item Failed
	
	InProgress -> Completed : On Download Finished
	InProgress --> Paused : Pause Item
	InProgress ---> Interrupted : Item Interrupted
	
	InProgress --> Failed : Item Failed
	
	Paused --> InProgress : Start Item
	
	Interrupted ---> InProgress : Start Item
	
	@enduml
 {% endplantuml %}
</div>

>Note: 
* Failed is a temp state, the delegate will notify and item has failed and content manager will remove this item. In addition, keep in mind that when receiving failed state an error will also be provided in the delegate to indicate the reason.
* There is also `Removed` state which is not displayed here. `Removed` is a temporary state indicated an item was removed (can be considered as an event). You can remove an item from all states. 

### Download Sequence

![](download-sequence.svg)

<div hidden>
{% plantuml %}
	@startuml
	
	title Download Sequence
	
	App -> ContentManager : ContentManager.shared.addItem(id, url)
	
	alt successful case
	    App <-- ContentManager : DTGItem
	else item exists
	    App <-- ContentManager : nil
	end
	
	App <- ContentManager : state update (new)
	
	|||
	
	App -> ContentManager : ContentManager.shared.loadItemMetadata(id, preferredVideoBitrate, completionHandler)
	
	... Download and parse the manifest ...
	
	App <-- ContentManager : completionHandler
	
	|||
	
	App -> ContentManager : ContentManager.shared.startItem(id)
	
	note over ContentManager
	    Start the downloader for the item 
	    and begin background downloads
	end note
	
	App <- ContentManager : state update (inProgress)
	
	... Downloading ...
	
	== Repetition ==
	App <- ContentManager : progress updates (id, totalBytesDownloaded, totalBytesEstimated)
	
	... Downloading ...
	
	App <- ContentManager : state update (completed)
	
	|||
	
	App -> ContentManager : ContentManager.shared.itemPlaybackUrl(id)
	
	App <- ContentManager : playback url
	
	|||
	
	note over App, ContentManager
	    You can now use playback url to play the media offline
	end note
	
	@enduml
 {% endplantuml %}
</div>

### Simple Playing Sequence (Using PlayKit Player)

![](playing-sequence.svg)

<div hidden>
{% plantuml %}
	@startuml 
	
	title Playing Sequence
	
	App -> ContentManager
	
	... Downloading HLS stream ...
	
	App <-- ContentManager : playback url
	App -> App : Create media config from playback url
	|||
	App -> PlayKitManager : PlayKitManager.shared.loadPlayer(pluginConfig: nil)
	
	alt successful case
	    |||
	    App <-- PlayKitManager : Player
	    App -> ContentManager : ContentManager.shared.start(completionHandler)
	    ...
	    App <-- ContentManager : completionHandler
	    App -> Player : player.prepare(mediaConfig)
	else failed to create player
	    |||
	    App <-- PlayKitManager : throw error
	end
	
	... Play until end ...
	
	App -> Player : player.destroy()
	
	App -> ContentManager : ContentManager.shared.stop()
	
	@enduml
{% endplantuml %}
</div>

## Usage

To use the DTG make sure to import in each source file:
{% highlight swift %}
import DownloadToGo
{% endhighlight %}

The following classes/interfaces are the public API of the library:
* `ContentManager` - Use this class to interact with the library.
* `DTGContentManager` - This is the main API you will use to interact with the library.
* `ContentManagerDelegate` - Delegate calls available to observe.
* `DTGItem` - Represent a single download item.
* `DTGItemState` - The state of a download item.

Basic Implementation:
{% highlight swift %}
class DownloadManager: ContentManagerDelegate {

    let cm: DTGContentManager

    init() {
        // setup content manager and delegate
        cm = ContentManager.shared
        cm.delegate = self
    }

    func downloadItem(id: String, url: URL) {
        _ = cm.addItem(id: id, url: url) // make sure the item was added
        do {
            try cm.loadItemMetadata(id: self.selectedItem.id, preferredVideoBitrate: 300000)    {
                // metadata loaded
                try cm.startItem(id: self.selectedItem.id)
            }
        } catch {
            // handle errors
        }
    }

    func playbackUrl(id: String) -> URL? {
        do {
            return try downloadManager.itemPlaybackUrl(id: id)
        } catch {
            // handle errors
            return nil
        }
    }

    func item(id: String, didDownloadData totalBytesDownloaded: Int64, totalBytesEstimated: Int64?) {
        // handle progress updates
    }

    func item(id: String, didChangeToState newState: DTGItemState, error: Error?) {
        // handle state changes (metadataLoaded, inProgress, completed etc...)
    }
}
{% endhighlight %}

Basic Implementation with PlayKit:
{% highlight swift %}
class VideoViewController: UIViewController {

    let downloadManager = DownloadManager()
    var player: Player?
    @IBOutlet weak var playerView: PlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let player = try PlayKitManager.shared.loadPlayer(pluginConfig: nil)
            self.player = player
            player.view = self.playerView

            ContentManager.shared.start() {
                if let localUrl = downloadManager.playbackUrl(id: "myLocalId") {
                    let mediaEntry = localAssetsManager.createLocalMediaEntry(for: "myLocalId", localURL: localUrl)
                    player.prepare(MediaConfig(mediaEntry: mediaEntry))
                    // you can now call prepare when you want (in case no error)
                }
            }            
        } catch {
            // handle errors
        }
    }
}
{% endhighlight %}

On `AppDelegate`:
* Make sure to call `ContentManager.shared.setup()`
* (Optional) This is a good place to call `ContentManager.shared.startItems(inStates: _)` to resume interrupted or in progress downloads.

{% highlight swift %}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // setup the content manager - THIS IS A MUST!
        ContentManager.shared.setup()
        
        // this can be a good place to call:
        // ContentManager.shared.startItems(inStates: _)
        // With the needed states (inProgress/paused/interrupted)
        return true
    }

    ...
}
{% endhighlight %}

>Note: Make sure to call `ContentManager.shared.stop()` when finished with playback.

[cocoapods]: https://cocoapods.org/
