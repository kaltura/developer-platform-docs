---
layout: page
title: Embedding the Player With Angular
weight: 110
---

## Embedding the Player With Angular

If you've tried embedding the Kaltura Player in your Angular2 app, you may have come across the [issue](https://github.com/angular/angular/issues/4903) where Angular deletes javascript *script* tags. 
We used the workaround described [here](https://stackoverflow.com/questions/35570746/angular2-including-thirdparty-js-scripts-in-component) to add a player to a typescript project. 

In our `video.component.ts` we create the script dynamically inside the `ngAfterViewInit` function, which is essentially a lifecycle hook that is called *after* Angular has fully initialized a component's view, preventing the script from being deleted during initialization. 

```javascript
@Injectable()
export class VideoComponent {
  constructor(@Inject(DOCUMENT) private document: Document, private elementRef: ElementRef) {
  }

  ngAfterViewInit() {
    console.log('onInit called');
    var s = this.document.createElement('script');
    s.type = 'text/javascript';
    s.src = 'https://cdnapisec.kaltura.com/p/PARTNER_ID/embedPlaykitJs/uiconf_id/UI_CONF?autoembed=true&targetId=PLAYER_PLACEHOLDER&entry_id=ENTRY_ID&config[playback]={\"autoplay\":true}';
    this.elementRef.nativeElement.appendChild(s);
  }
}
```

Be sure to fill in the missing information (and delete the brackets) needed in the player script: 
- **partner_id**:found in the [KMC Integration Settings](https://kmc.kaltura.com/index.php/kmcng/settings/integrationSettings)
- **uiConf_id** or player ID, found in the [KMC studio](https://kmc.kaltura.com/index.php/kmcng/studio/v2) or, if you're using the API, by calling [uiConf.list](https://developer.kaltura.com/console/service/uiConf/action/list) to see a full list of existing players. 
- **player_placeholder** that corresponds to the div in the HTML code
- **entry_id** of the video that you wish to show in the player. Read about other [embed types](https://developer.kaltura.com/player/web/embed-types-web) to learn how to dynamically load the entry in the player. 