---
layout: page
title: Embedding the Player in Angular
weight: 110
---

If you've tried embedding the Kaltura Player in your Angular app, you may have come across [the issue](https://github.com/angular/angular/issues/4903) where Angular deletes javascript **script** tags. In the embed examples below, we add the player to the Typescript project dynamically, or by creating the embed script *after* the component has been created or initialize, as described in [this workaround](https://stackoverflow.com/questions/35570746/angular2-including-thirdparty-js-scripts-in-component0).

If you are not looking for angular solutions, check out the Player embed-types [here](https://developer.kaltura.com/player/web/embed-types-web/). 

## Dynamic Embed 

The best way to embed the player with Angular is dynamically, which allows you to generate the embed call only after all the component properties have been initialized.

We do this by putting the embed code in the `ngOnInit` function, an angular lifecycle function, within the Video Components class. 


{% highlight javascript %}
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
{% endhighlight %}

Notice that in this scenario, the static script that *loads* the player should be in the `index.html` header:

{% highlight javascript %}
<script type="text/javascript" src="//cdnapisec.kaltura.com/p/PARTNER_ID/embedPlaykitJs/uiconf_id/UI_CONF"></script>
{% endhighlight %}

Be sure to fill in the missing information needed in the player script: 
- **partner_id**:found in the [KMC Integration Settings](https://kmc.kaltura.com/index.php/kmcng/settings/integrationSettings)
- **uiConf_id** or player ID, found in the [KMC studio](https://kmc.kaltura.com/index.php/kmcng/studio/v2) or, if you're using the API, by calling [uiConf.list](https://developer.kaltura.com/console/service/uiConf/action/list) to see a full list of existing players. 
- **player_placeholder** that corresponds to the div in the HTML code
- **entry_id** of the video that you wish to show in the player. 


## Auto-Embed

The auto embed is the simplest way to embed a player, is what would be generated in the KMC under **share and embed**. For this scenario we create the script dynamically, this time inside the `ngAfterViewInit` function, another lifecycle hook that is called after Angular has fully initialized a component's view, preventing the script from being deleted during initialization. 

{% highlight javascript %}
@Injectable()
export class VideoComponent {
  constructor(@Inject(DOCUMENT) private document: Document, private elementRef: ElementRef) {
  }

  ngAfterViewInit() {
    var s = this.document.createElement('script');
    s.type = 'text/javascript';
    s.src = 'https://cdnapisec.kaltura.com/p/PARTNER_ID/embedPlaykitJs/uiconf_id/UI_CONF?autoembed=true&targetId=PLAYER_PLACEHOLDER&entry_id=ENTRY_ID&config[playback]={\"autoplay\":true}';
    this.elementRef.nativeElement.appendChild(s);
  }
}
{% endhighlight %}

## iFrame Embed 

The iframe embed is good for sites that with stringent page security requirements that don't allow third-party JavaScript to be embedded in their pages. 

Here we create the iFrame inside the `ngAfterViewInit` function as we did in the auto-embed. 

{% highlight javascript %}
@Injectable()
export class IframeEmbedComponent {
  constructor(@Inject(DOCUMENT) private document: Document, private elementRef: ElementRef) {
  }

  ngAfterViewInit() {
    var s = this.document.createElement('iframe');
    s.style.width = '640px';
    s.style.height = '360px';
    s.allowFullscreen = true;
    s.src = '//cdnapisec.kaltura.com/p/PARTNER_ID/embedPlaykitJs/uiconf_id/UI_CONF?iframeembed=true&targetId=PLAYER_PLACEHOLDER_IFRAME&entry_id=ENTRY_ID&config[playback]={\"autoplay\":true}';
    this.elementRef.nativeElement.appendChild(s);
  }
}
{% endhighlight %}
