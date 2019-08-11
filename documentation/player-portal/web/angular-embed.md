---
layout: page
title: Embedding the Player With Angular
weight: 110
---

## Embedding the Player With Angular

If you've tried embedding the Kaltura Player in your Angular2 app, you may have come across [the issue](https://github.com/angular/angular/issues/4903) where Angular deletes javascript **script** tags. In the embed examples below, we add the player to the Typescript project by creating the embed script *after* the component has been created or initialize, as described in [this workaround](https://stackoverflow.com/questions/35570746/angular2-including-thirdparty-js-scripts-in-component0).

If you are not looking for angular solutions, check out the Player embed-types [here](https://developer.kaltura.com/player/web/embed-types-web/). 

## Auto-Embed

In our video component we create the script dynamically inside the `ngAfterViewInit` function, which is essentially a lifecycle hook that is called *after* Angular has fully initialized a component's view, preventing the script from being deleted during initialization. 

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

Be sure to fill in the missing information needed in the player script: 
- **partner_id**:found in the [KMC Integration Settings](https://kmc.kaltura.com/index.php/kmcng/settings/integrationSettings)
- **uiConf_id** or player ID, found in the [KMC studio](https://kmc.kaltura.com/index.php/kmcng/studio/v2) or, if you're using the API, by calling [uiConf.list](https://developer.kaltura.com/console/service/uiConf/action/list) to see a full list of existing players. 
- **player_placeholder** that corresponds to the div in the HTML code
- **entry_id** of the video that you wish to show in the player. 

## Dynamic Embed 

Dynamic embed allows you to control runtime configuration dynamically or have more control over the embed call. 
For this embed we use the `ngOnInit` function, another lifecycle hook that is actually called after all *properties* have been initialized.  

```javascript 
export class DynamicEmbedComponent implements OnInit {

  constructor() { }

  ngOnInit() {
    try {
      const kalturaPlayer = KalturaPlayer.setup({
        targetId: 'player-placeholder-dynamic',
        provider: {
          partnerId: 'PARTNER_ID',
          uiConfId: 'UI__CONF'
        },
        playback: {
          autoplay: true
        }
      });
      kalturaPlayer.loadMedia({entryId: 'ENTRY_ID'});
    } catch (e) {
      console.error(e.message);
    }
  }
}
```

## iFrame Embed 

The iframe embed is good for sites that with stringent page security requirements that don't allow third-party JavaScript to be embedded in their pages. 

Here we create the iFrame inside the `ngAfterViewInit` function as we did in the auto-embed. 

```javascript 
@Injectable()
export class IframeEmbedComponent {
  constructor(@Inject(DOCUMENT) private document: Document, private elementRef: ElementRef) {
  }

  ngAfterViewInit() {
    var s = this.document.createElement('iframe');
    s.style.width = '640px';
    s.style.height = '360px';
    s.allowFullscreen = true;
    s.frameBorder = 0;
    s.type = 'text/javascript';
    s.src = '//cdnapisec.kaltura.com/p/PARTNER_ID/embedPlaykitJs/uiconf_id/UI_CONF?iframeembed=true&targetId=PLAYER_PLACEHOLDER_IFRAME&entry_id=ENTRY_ID&config[playback]={\"autoplay\":true}';
    this.elementRef.nativeElement.appendChild(s);
  }
}
```