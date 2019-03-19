---
layout: page
title: Player UI Tutorial for iOS
weight: 110
---

The Kaltura Player does not inherently include a UI, but this guide will walk you through an example of how to add play/pause buttons and a scrubber to your player. 
At this point you should have a Kaltura Player embedded in your application and showing your entry, as seen in [this guide](https://github.com/tzubeli/developer-portal/edit/master/sdk-portal/getting-started-ios.md).

We will start by adding button images of your choice to the Assets catalogue of your project. Then, in the storyboard, create a play/pause button, a slider (scrubber), a current position label, and a (remaining) duration label. For the play/pause button, in the Attributes Inspector, click the dropdown for Title and select Attributed. Under Image, type in the name of the play button file (it should have autocomplete for existing files). 
Lastly, create the outlets for all your new objects in the Controller: 

```
@IBOutlet weak var playPauseButton: UIButton!
@IBOutlet weak var playheadSlider: UISlider!
@IBOutlet weak var positionLabel: UILabel!
@IBOutlet weak var durationLabel: UILabel!
```

### Player State 

Currently our play button is only set to show a play icon, and we'll want it to change for different scenarios. What we'll need is to handle the state of what's happening in the player - whether it is idle, playing, paused, or ended. Let's add an enum called state at the top of the class:
```
enum State {
    case idle, playing, paused, ended
}
```
And a Property Observer on that enum which switches on each state.

```
var state: State = .idle {
      didSet {
          switch state {
          case .idle:
              playPauseButton.setImage(UIImage(named: "btn_play"), for: .normal)
          case .playing:
              playPauseButton.setImage(UIImage(named: "btn_pause"), for: .normal)
          case .paused:
              playPauseButton.setImage(UIImage(named: "btn_play"), for: .normal)
          case .ended:
              playPauseButton.setImage(UIImage(named: "btn_refresh"), for: .normal)
          }
        }
    }
```

What this does is listen for a change to the state, and based on whether the player is currently idle, paused, or playing, the picture of the play/pause button is changed accordingly. 

At the beginning of the `viewDidLoad` function, set the state to idle. 

`self.state = .idle` 

On the playPauseButton, add a new IBAction for a "Touch Up Inside" event and link it to a new `playerTouched` function that calls play/pause on the player when the button is touched. Available Basic Player actions can be found [here](https://kaltura.github.io/playkit/api/ios/core/Protocols/BasicPlayer.html) 

```
@IBAction func playTouched(_ sender: Any) {
    guard let player = self.player else {
        print("player is not set")
        return
    }

    switch state {
    case .playing:
        player.pause()
    case .idle:
        player.play()
    case .paused:
        player.play()
    case .ended:
        player.seek(to: 0)
        player.play()
    }
}
```

### Player Slider 

The slider is made up of a few components: the playhead, the current time stamp, and the duration of the entry. All of this configuration happens in the `setupPlayer` function. Firstly, a formatter for displaying the number of seconds as `HH:MM:SS` 

```
let formatter = DateComponentsFormatter()
formatter.allowedUnits = [.hour, .minute, .second]
formatter.unitsStyle = .positional
formatter.zeroFormattingBehavior = .pad

func format(_ time: TimeInterval) -> String {
    if let s = formatter.string(from: time) {
        return s.count > 7 ? s : "0" + s
    } else {
        return "00:00:00"
    }
}
```

Then, we'll add three observers. The first one checks on the media's progress in the task queue every fifth of a second and then updates the player slider accordingly, as well as the text of the current position label (using the time formatter)

```
self.player?.addPeriodicObserver(interval: 0.2, observeOn: DispatchQueue.main, using: { (pos) in
    self.playheadSlider.value = Float(pos)
    self.positionLabel.text = format(pos)
})
```
The second observer waits for Player event `durationChanged` which happens when the media loads and the duration of the video is known. This happens once per playback. It then sets the maximum value of the slider playhead, and the text of the duration label. 

```
self.player?.addObserver(self, events: [PlayerEvent.durationChanged], block: { (event) in
    if let e = event as? PlayerEvent.DurationChanged, let d = e.duration as? TimeInterval {
        self.playheadSlider.maximumValue = Float(d)
        self.durationLabel.text = format(d)
    }
})
```        

The third observer listens for player events, and updates the State when the player begins playing, is paused, or has ended, which is what the switch case above is dependent on. Player events can be found [here](https://kaltura.github.io/playkit/api/ios/core/Classes/PlayerEvent.html#/s:7PlayKit11PlayerEventC12StateChangedC)

```
self.player?.addObserver(self, events: [PlayerEvent.play, PlayerEvent.ended, PlayerEvent.pause], block: { (event) in
    switch event {
    case is PlayerEvent.Play, is PlayerEvent.Playing:
        self.state = .playing

    case is PlayerEvent.Pause:
        self.state = .paused

    case is PlayerEvent.Ended:
        self.state = .ended

    default:
        break
    }
})
```

Lastly, in the Storyboard, set a new referencing action on the Playhead Slider for the "Value Changed" event. Call it `playheadValueChanged`. Add it after the `playTouched` function. It should set the current time position according to the value of the palyhead, and change the State to paused in the case of moving the slider back after the video has ended. 

```
@IBAction func playheadValueChanged(_ sender: Any) {
    guard let player = self.player else {
        print("player is not set")
        return
    }

    if state == .ended && playheadSlider.value < playheadSlider.maximumValue {
        state = .paused
    }
    player.currentTime = TimeInterval(playheadSlider.value)
}
```
You should be able to run the code, and use the basic player functions. Thec complete code should look like this: 

```
import UIKit
import PlayKit
import PlayKitUtils
import PlayKitProviders

fileprivate let SERVER_BASE_URL = "https://cdnapisec.kaltura.com"
fileprivate let PARTNER_ID = 1424501
fileprivate let ENTRY_ID = "1_djnefl4e"

class ViewController: UIViewController {

    enum State {
        case idle, playing, paused, ended
    }
    
    var entryId: String?
    var ks: String?
    var player: Player? // Created in viewDidLoad
    var state: State = .idle {
          didSet {
              switch state {
              case .idle:
                  playPauseButton.setImage(UIImage(named: "btn_play"), for: .normal)
              case .playing:
                  playPauseButton.setImage(UIImage(named: "btn_pause"), for: .normal)
              case .paused:
                  playPauseButton.setImage(UIImage(named: "btn_play"), for: .normal)
              case .ended:
                  playPauseButton.setImage(UIImage(named: "btn_refresh"), for: .normal)
              }
          }
      }
    
    @IBOutlet weak var playerContainer: PlayerView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var playheadSlider: UISlider!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.state = .idle

        self.player = try! PlayKitManager.shared.loadPlayer(pluginConfig: nil)
        self.setupPlayer()
        
        entryId = ENTRY_ID
        self.loadMedia()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
/************************/
// MARK: - Player Setup
/***********************/
    func setupPlayer() {
        
        self.player?.view = self.playerContainer
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        func format(_ time: TimeInterval) -> String {
            if let s = formatter.string(from: time) {
                return s.count > 7 ? s : "0" + s
            } else {
                return "00:00:00"
            }
        }

        // Observe media progress
        self.player?.addPeriodicObserver(interval: 0.2, observeOn: DispatchQueue.main, using: { (pos) in
            self.playheadSlider.value = Float(pos)
            self.positionLabel.text = format(pos)
        })
        
        // Observe duration
        self.player?.addObserver(self, events: [PlayerEvent.durationChanged], block: { (event) in
            if let e = event as? PlayerEvent.DurationChanged, let d = e.duration as? TimeInterval {
                self.playheadSlider.maximumValue = Float(d)
                self.durationLabel.text = format(d)
            }
        })

        // Observe play/pause
        self.player?.addObserver(self, events: [PlayerEvent.play, PlayerEvent.ended, PlayerEvent.pause], block: { (event) in
            switch event {
            case is PlayerEvent.Play, is PlayerEvent.Playing:
                self.state = .playing
                
            case is PlayerEvent.Pause:
                self.state = .paused
                
            case is PlayerEvent.Ended:
                self.state = .ended
                
            default:
                break
            }
        })
    }

    func loadMedia() {
        let sessionProvider = SimpleSessionProvider(serverURL: SERVER_BASE_URL, partnerId: Int64(PARTNER_ID), ks: ks)
        let mediaProvider: OVPMediaProvider = OVPMediaProvider(sessionProvider)
        mediaProvider.entryId = entryId
        mediaProvider.loadMedia { (mediaEntry, error) in
            if let me = mediaEntry, error == nil {
                let mediaConfig = MediaConfig(mediaEntry: me, startTime: 0.0)
                if let player = self.player {
                    player.prepare(mediaConfig)
                }
            }
        }
    }
    
/************************/
// MARK: - Actions
/***********************/
    
    @IBAction func playTouched(_ sender: Any) {
        guard let player = self.player else {
            print("player is not set")
            return
        }
        
        switch state {
        case .playing:
            player.pause()
        case .idle:
            player.play()
        case .paused:
            player.play()
        case .ended:
            player.seek(to: 0)
            player.play()
        }
    }
    
    @IBAction func playheadValueChanged(_ sender: Any) {
        guard let player = self.player else {
            print("player is not set")
            return
        }
        
        if state == .ended && playheadSlider.value < playheadSlider.maximumValue {
            state = .paused
        }
        player.currentTime = TimeInterval(playheadSlider.value)
    }
}

```
