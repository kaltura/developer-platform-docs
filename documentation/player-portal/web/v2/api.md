
[Source](http://player.kaltura.com/docs/api "Permalink to Kaltura Player - Fast, Flexible, Video Player Toolkit")

# Kaltura Player - Fast, Flexible, Video Player Toolkit

This documentation covers version **_2.74.1__1e322ce7_** of the html5 library. 

The kWidget API is available after you include the Kaltura player library. kWidget provides embedding and basic utility functions. The Kaltura player library can be embeded into both 

. 

After you include the Kaltura player library, the following kWidget API is available: 

* * *

#### kWidget.embed ( [targetId], settings)

Used to embed the Kaltura player against an element target in the DOM

##### PARAMETERS:

* **targetId** String _( Optional )_ The DOM player target id attribute string. ( if not included, you must include targetId in "settings" object )
* **settings** [kWidget.settingsObject][1] Object of settings to be used in embedding.

##### RETURNS:

* boolean|null Returns boolean false if id not found

##### EXAMPLES:

* * *

#### kWidget.thumbEmbed ( [targetId], settings)

Used to embed a thumbnail player. When the user clicks on the thumbnail kWidget.embed will be called with the provided settings.

##### PARAMETERS:

* **targetId** String _( Optional )_ The DOM player target id attribute string. ( if not included, you must include targetId in "settings" object
* **settings** [kWidget.settingsObject][1] Object of settings to be used in embedding.

##### EXAMPLES:

* * *

#### kWidget.getKalturaThumbUrl (settings)

Get video thumbnail URL.

* * *

#### kWidget.addReadyCallback (readyCallback)

Adds a ready callback to be called after the KDP or HTML5 player is ready.

##### PARAMETERS:

* **readyCallback** String Function to call after a player or widget is ready on the page.

##### EXAMPLES:

* * *

#### kWidget.destroy (target)

Removes the player from the DOM.

##### PARAMETERS:

* **target** String The target element or element ID to destroy.

##### EXAMPLES:

###  User Agent and Feature Detection 

* * *

#### kWidget.isMobileDevice ()

If user agent identifies as mobile device ( android, iOS or windows phone )

* * *

#### kWidget.supportsHTML5 ()

If the device or browser supports HTML5

* * *

#### kWidget.supportsFlash ()

If the device or browser supports Flash ( version 10 and above )

* * *

#### kWidget.isIOS ()

If user agent identifies as iOS device

* * *

#### kWidget.isIE ()

If user agent identifies as Internet Explorer browser

* * *

#### kWidget.isIE8 ()

If user agent identifies as Internet Explorer 8 browser

* * *

#### kWidget.isAndroid ()

If user agent identifies as Android device

* * *

#### kWidget.isWindowsDevice ()

If user agent identifies as Windows Phone device

###  Settings Embed Object: 

* * *

#### kWidget.settingsObject

* **targetId** String The DOM player target id attribute string if not defined as top level param.
* **wid** String Widget id, usually the partner id prefixed by underscore.
* **uiconf_id** Number _( Optional )_ The player uiconf_id
* **entry_id** String The content entry id. Can be left empty for a JavaScript based entry id.
* **flashvars** Object Runtime configuration object, can override arbitrary uiVars and plugin config.
* **params** Object Runtime configuration object, can override arbitrary uiVars and plugin config.
* **cache_st** String _( Optional )_ String to burst player cache
* **readyCallback** Function _( Optional )_ Local callback method to be called once player is ready for bindings. Player id is passes as an argument. See [live example][2]

### Server API requests ( kWidget.api )

kWidget Server API enables direct [Kaltura Server API][3] calls from JavaScript. This should not be confused with the [JavaScript client library][4], which offers object mappings and works with the code generated in the [test me console][5].   
The Kaltura Server API offers minimal object validation, in exchange for being much smaller, and included with every kaltura player library include.

Creating a kWidget API object, issue a playlist request, log the result: 
    
    
    new kWidget.api( { 'wid' : '_243342', })
    .doRequest({'service':'playlist', 'action': 'execute', 'id': '1_e387kavu'}, 
    	function( data ){
    		console.log( data );
    	}
    );
    

For more examples see the [kWidget.api test page.][6]

* * *

#### kWidget.api (apiObject, callback)

The kWidget API object, used to create new instances of Kaltura API request.

##### PARAMETERS:

* **apiObject** [kWidget.apiOptions][7] Object of API settings to be used in API requests.
* **callback** function Callback of API response, with data as the first argument.

##### RETURNS:

* kWidget.api Returns an instance of the kWidget API object.

##### EXAMPLES:

* * *

#### kWidget.apiOptions

* **wid** String The partner id to be used in the API request.
* **ks** String The Kaltura secret to be used in the request, if not supplied an anonymous KS will be generated and used.
* **serviceUrl** String Can be overwritten to target a different Kaltura server.
* **serviceBase** String Can be overwritten to alternate Kaltura service path.
* **statsServiceUrl** String Default supplied via Kaltura library include, can be overwritten to alternate URL for core analytics events.
* **disableCache** String Sends no-cache param to API, for a fresh result. Can hurt performance and CDN cachability should be used sparingly.

## Player Configuration key value pairs ( UiVars )

[Services »][8] [MediaEntry »][9] [Layout »][10] [Playback »][11] [PlayerProperties »][12] [MediaProxy »][13]  

UiVars enable configuration of all player features. There are two classes of UiVars: 

* top level configuration options
* plugins configuration options
These values can be set a few ways:

Within the [player studio][14] UiVar configuration appears plugins -> uivars:  
![][15]

You can control the raw JSON code for UiVars by modifying the "uiVars" section of the JSON config using the [player version utility][16]. 
    
    
    {
       "plugins":{
    	/* plugins go here */
       },
       "uiVars": [{
    	"key": "autoPlay",
    	"value": false,
    	"overrideFlashvar": false
       }]
    }
    

Player configuration can be set at embed time as "flashvars": 
    
    
    kWidget.embed({
    	...
    	flashvars:{
    		"autoPlay": false
    	}
    })
    

All player properties can also be retrieved at runtime or used in plugins macro evaluations. 
    
    
    kWidget.addReadyCallback( function(playerId){
    	alert( document.getElementById( playerId ).evaluate("{autoPlay}") );
    })
    

Finally many properties can be upated at runtime using [setKDPAttribute][17]. 

Kaltura service variables define define respective Kaltura API configuration.

* Kaltura.ServiceUrl  
The API service URL, used to for all API calls. Can be overwritten for on-prem or api proxy setups.  
Type:   
    String  
Default:   
    http://cdnapi.kaltura.com
* Kaltura.ServiceBase  
URL Path on the server to the API services.  
Type:   
    String  
Default:   
    /api_v3/index.php?service=
* Kaltura.StatsServiceUrl  
The URL used for all Kaltura analytics events.  
Type:   
    String  
Default:   
    http://stats.kaltura.com
* Kaltura.NoApiCache  
Set to true to disable the player API cache.  
Type:   
    String  
Default:   
    false
* Kaltura.ForceIframeEmbed  
Set to true to force iframe output with player API. Useful for simulating iframe syndication environment.  
Type:   
    String  
Default:   
    false
* Kaltura.KWidgetPsPath  
Used to append path to additional library of professional service scripts and plugins, that are outside the mwEmbed repository.   
Type:   
    String  
Default:   
    ../kwidget-ps/
* Kaltura.AllowIframeRemoteService  
By default external API service URLs are not allowed, set this to true to allow them  
Type:   
    String  
Default:   
    false
* Kaltura.ForceFlashOnDesktop  
If the player should be forced to use flash on desktop (kdp only).  
Type:   
    String  
Default:   
    false  
[Usage Example][18]
* ForceFlashOnDesktopSafari  
If the player should be forced to use flash on desktop Safari.  
Type:   
    String  
Default:   
    false  
[Usage Example][19]
* Kaltura.EnableEmbedUiConfJs  
If the player should request uiConf Javascript prior to embed  
Type:   
    String  
Default:   
    false  
[Usage Example][20]
* Kaltura.ForceFlashOnIE10  
Will force flash exclusively on IE10  
Type:   
    String  
Default:   
    false
* Kaltura.IframeRewrite  
Enables the HTML5 player. A legacy flag to convert objects to iframes  
Type:   
    String  
Default:   
    true
* Kaltura.LicenseServerURL  
The playReady license server URL.  
Type:   
    String  
Default:   
    null
* Kaltura.BlackVideoSources  
A array of assets used for black video streams. Used to capture user gestures against a valid asset where the actual asset is not yet available  
Type:   
    String
* Kaltura.UseManifestUrls  
Used to designate usage of playMainfest URL type instead of legacy flvclipper Kaltura media URLs  
Type:   
    String  
Default:   
    true
* Kaltura.CdnUrl  
The CDN URL used to construct Kaltura media asset URLs  
Type:   
    String  
Default:   
    http://cdnakmi.kaltura.com
* Kaltura.Protocol  
The current protocol of player instance, http or https. Protocol relative urls can't be used where different CDN prefixes for secure and standard http  
Type:   
    String  
Default:   
    http
* Kaltura.UseFlavorIdsUrls  
If the adaptive streams should be dynamically constructed passing along respective flavor list per device capabilities.  
Type:   
    String  
Default:   
    true
* Kaltura.LeadHLSOnAndroid  
If Apple HLS streams should be used when available on Android devices, by default progressive streams are used on Android because of Android HLS compatibility issues.  
Type:   
    String  
Default:   
    true  
[Usage Example][21]
* Kaltura.UseAppleAdaptive  
If apple HLS streams should be used when available  
Type:   
    String  
Default:   
    true  
[Usage Example][21]
* LeadWithHLSOnFlash  
If Apple HLS streams should be on desktop browsers where Flash and an HLS stream are available  
Type:   
    Boolean  
Default:   
    false  
[Usage Example][22]
* forceHDS  
Force HDS streamerType for Kaltura Live (HLS by default)  
Type:   
    Boolean  
Default:   
    false
* ignoreAkamaiHD  
Play HDS without AkamaiHD plugin (the plugin is loaded by default for HDNETWORK or HDNETWORK_HDS streamerTypes)  
Type:   
    Boolean  
Default:   
    false
* host  
The URL of the Kaltura server to work with  
Type:   
    String
* cdnHost  
The base URL of the CDN to load media and assets from  
Type:   
    String  
Default:   
    The host parameter value
* clientTag  
A custom text that is concatenated to KDP version. The tag is used by the Kaltura server widget caching mechanism and for tracking and analytics  
Type:   
    String  
Default:   
    KDP:KDP_VERSION
* srvUrl  
Reserved for future use, determine the API services part of the base Kaltura API calls  
Type:   
    String  
Legacy Only
* partnerId  
The id of the current Kaltura partner  
Type:   
    String
* ks  
Kaltura Session  
Type:   
    String  
Default:   
    By default, the KDP generates a KS by calling the widget.get API
* referrer  
The URL of the hosting web page for tracking and analytics  
Type:   
    String
* disableReferrerOverride  
Flag indicating whether to take the referrer from the page (if true) or from the referrer Flashvar (if false)  
Type:   
    Boolean  
Default:   
    false  
Legacy Only
* storageId  
This Flashvar contains the storageId from which the entry loads (assuming there is such storage. If there isn't, there is no reason to pass this Flashvar)  
Type:   
    String
* jsTraces  
Flag indicating whether to print traces to a box in the page. Useful when there's no Flash debugger version  
Type:   
    Boolean  
Default:   
    false  
Legacy Only
* centerPreloader  
Flag indicating whether to center the preloader SWF. Should be true in case the preloader registration point is not at its center.  
Type:   
    Boolean  
Default:   
    false  
Legacy Only
* usePreloaderBufferAnimation  
Flag indication whether we should use the preloader SWF animation as the buffering animation. if "false", buffering animation is taken from "kspin" class in KDP skin.  
Type:   
    Boolean  
Default:   
    false  
Legacy Only
* httpProtocol  
The HTTP protocol to load the KDP application from  
Type:   
    String  
Default:   
    Trimmed protocol of the URL the KDP was loaded from  
Legacy Only
* strings.ks-no-flash-installed  
No Flash installed message for IE8 users. This Flashvar can be used only through mw.setConfig(). For example: mw.setConfig( 'strings.ks-no-flash-installed' , 'Flash Player nėra įdiegtas jūsų kompiuteryje' ); Note: IE8 may parse utf-8 characters incorrectly. To translate the message, save the HTML file with UTF-8 encoding and add a META tag to the HEAD of the HTML page:   
Type:   
    String  
Default:   
    Flash does not appear to be installed or active. Please install or activate Flash.

  

## MediaEntry

Kaltura mediaEntry variables enable controls of flavor and protocol selection.

* entryId  
Valid Kaltura media entry id. To support directly assigning media see [MediaProxy][13]  
Type:   
    String  
[Usage Example][2]
* referenceId  
Reference Id is an alternate unique identifier for media assets. Can be used instead of the entry id. The player will use the first found matching referenceId found.  
Type:   
    String  
[Usage Example][23]
* flavorId  
The flavor asset id of the media entry being played (applicable only when sourceType=entryId)  
Type:   
    String
* sourceType  
The type of media source to load, either a URL or id of valid Kaltura media entry  
Type:   
    String  
Default:   
    entryId  
Legacy Only
* streamerType  
The media source streaming protocol to use (http / rtmp / live / hdnetwork / auto ). Auto will select http or adaptive based on content length and protocols available on the platform.  
Type:   
    String  
Default:   
    auto
* streamerUrl  
A full RTMP URL to the streaming application that will be used as the streaming provider, e.g. 'rtmp://rtmpakmi.kaltura.com/ondemand' (Used by the FMSURL OSMF class)  
Type:   
    String  
Legacy Only
* streamFormat  
Defines the video type of the RTMP stream to be played. To play mp4 streams over RTMP, pass streamFormat=mp4  
Type:   
    String  
Default:   
    undefined  
Legacy Only
* rtmpFlavors  
Determine whether to use a multi-bitrate content flavors for dynamic streaming (set to 1)  
Type:   
    String  
Default:   
    undefined  
Legacy Only
* useRtmptFallback  
Flag indicating whether KDP should try to connect to rtmpt/rtmpte when mediaProtocol is rtmp/rtmpe.  
Type:   
    Boolean  
Default:   
    true  
Legacy Only
* disableBitrateCookie  
Flag indicating whether the KDP should take the bitrate from the Flash cookie  
Type:   
    Boolean  
Default:   
    false
* requiredMetadataFields  
This Flashvar is a flag indicating whether the player should request entry metadata  
Type:   
    Boolean  
Default:   
    false
* metadataProfileId  
This Flashvar contains a specific custom metadata profile id to deliver. If it is not passed, the KDP delivers the latest custom metadata profile  
Type:   
    String
* getCuePointsData  
This Flashvar is a flag indicating whether the player should deliver cue-point data related to the current playing entry  
Type:   
    Boolean  
Default:   
    true
* loadThumbnailWithKs  
Flag indicating whether the KDP should append the KS to the thumbnail request. Default value "false" to take advantage of caching.  
Type:   
    Boolean  
Default:   
    false
* loadThumbnailWithReferrer  
Flag indicating whether the KDP should append the referrer to the thumbnail serve request. Default value "false" to take advantage of caching.  
Type:   
    Boolean  
Default:   
    false
* noThumbnail  
Flag indicating whether the KDP should forgo loading the thumbnail  
Type:   
    Boolean  
Default:   
    false  
Legacy Only
* liveCore.showThumbnailWhenOffline  
Flag indicating whether the the default thumbnail should be shown if live stream becomes offline  
Type:   
    Boolean  
Default:   
    false

  

## Layout

Controls basic layout properties and provides access to player config ids.

* widgetId  
The widget id as provided by Preview & Embed in KMC (if unsure use _partnerId e.g. _309)  
Type:   
    String
* uiConfId  
The player uiConf id as provided by KMC (or by calling uiConf.add api)  
Type:   
    String
* disableAlerts  
Disable the alert boxes  
Type:   
    Boolean  
Default:   
    false
* debugMode  
Reserved for future use or use by plugins; Usually used to allow Flash trace commands  
Type:   
    Boolean  
Default:   
    false
* disableOnScreenClick  
This Flashvar configures whether the on-screen click in KDP pauses/resumes playback  
Type:   
    Boolean  
Default:   
    false
* KalturaSupport_ForceUserAgent  
Enable forcing a specific user agent by setting the user agent string. Player rules are validated against this user agent string  
Type:   
    String
* disableForceMobileHTML5  
Disables forced usage of the HTML5 player set by the forceMobileHTML5 Flash var  
Type:   
    Boolean  
[Usage Example][24]
* forceMobileHTML5  
When set to true, forces the usage of the HTML5 player  
Type:   
    Boolean   
[Usage Example][24]
* alertForCookies  
When set to true, pops a user confirmation alert when the player needs to save a cookie in the local machine  
Type:   
    Boolean  
Default:   
    false  
[Usage Example][25]
* fileSystemMode  
Use to load the uiConf XML and skin assets from predefined path when debugging or loading KDP from local file system  
Type:   
    Boolean  
Default:   
    false  
Legacy Only
* thumbnailUrl  
External thumbnail URL to load instead of the entry default thumbnail. Supports evaluated expressions within curly brackets  
Type:   
    String  
[Usage Example][26]
* kml  
The source from which to load the KDP uiConf (KML=Kaltura Meta ui Language). If undefined, the kml will be loaded from the Kaltura server via uiConf.get api. Options are: local / inject  
Type:   
    String  
Default:   
    undefined  
Legacy Only
* kmlPath  
An accessible path to valid kml file (use with kml=local)  
Type:   
    String  
Default:   
    config.xml  
Legacy Only
* embeddedWidgetData  
Valid uiConf XML result, that is used by the 'KDP wrapper'; A Flash application that wraps the KDP for caching purposes  
Type:   
    String  
Default:   
    null  
Legacy Only
* disableTrackElement  
Under iOS - if there are captions within the HLS stream, users should set disableTrackElement to true to prevent caption duplications  
Type:   
    Boolean  
Default:   
    false  
[Usage Example][27]
* KalturaSupport.LeadWithHTML5  
When set to true, first tries to load the HTML5 player and if loading fails, loads the Flash player  
Type:   
    Boolean  
Default:   
    false
* KalturaSupport.PlayerConfig  
The Kaltura player configuration object  
Type:   
    Object

  

## Playback

UiVars for contoling basic playback.

* autoPlay  
Auto play single media (doesn't apply to playlists)  
Type:   
    Boolean  
Default:   
    false  
[Usage Example][28]
* EmbedPlayer.WebKitPlaysInline  
Determines if should play the video inline when inside a webview on iOS.  
Type:   
    Boolean  
Default:   
    false
* autoMute  
Determine whether to start playback with volume muted (usually used by video ads or homepage auto play videos)  
Type:   
    Boolean  
Default:   
    false  
[Usage Example][29]
* loop  
Indicates whether the media should be played again after playback has completed  
Type:   
    Boolean  
Default:   
    false  
[Usage Example][30]
* enableControlsDuringAd  
If true, play pause button will be active during ad playback  
Type:   
    Boolean  
Default:   
    false  
[Usage Example][31]
* adsOnReplay  
Indicates whether to play ads after video replay  
Type:   
    Boolean  
Default:   
    false  
[Usage Example][32]
* autoRewind  
Determine whether the first or the last frame of the media will show when playback ends  
Type:   
    Boolean  
Default:   
    false  
Legacy Only
* stretchVideo  
When true, stretchs the video to fill its container even if video aspect ratio breaks  
Type:   
    Boolean  
Default:   
    false  
Legacy Only

  

## PlayerProperties

Properties that control basic embed and player types.

* EmbedPlayer.DisableVideoTagSupport  
If video tag support should be disabled all-together  
Type:   
    Boolean  
Default:   
    false
* EmbedPlayer.DisableHTML5FlashFallback  
If detected, browser Flash support should be ignored and Flash support should be set to false. This eliminates support for Flash based playback.  
Type:   
    Boolean  
Default:   
    false
* EmbedPlayer.UseFlashOnAndroid  
If on Android, should use HTML5 ( even if Flash is installed on the machine )  
Type:   
    Boolean  
Default:   
    false
* EmbedPlayer.RewriteSelector  
What tags will be re-written to video player by default. Set to empty string or null to avoid automatic video tag rewrites to embedPlayer  
Type:   
    String  
Default:   
    video,audio,playlist
* EmbedPlayer.DefaultSkin  
Default player skin name  
Type:   
    String  
Default:   
    mvpcf
* EmbedPlayer.MonitorRate  
Number of milliseconds between interface updates  
Type:   
    Integer  
Default:   
    250
* EmbedPlayer.DefaultSize  
Default video size ( if no size provided )  
Type:   
    String  
Default:   
    400x300
* EmbedPlayer.ReplaceSources  
Can be used to set player sources via configuration  
Type:   
    Boolean  
Default:   
    false
* EmbedPlayer.NotPlayableDownloadLink  
When there is no in-browser playback mechanism, provides a download link for the play button  
Type:   
    Boolean  
Default:   
    true
* EmbedPlayer.BlackPixel  
A Base64 black pixel image for source switching  
Type:   
    String
* EmbedPlayer.DisableEntryCache  
When set to true, entry data is not saved in the player cache. This can improve performances, especially when using long play lists  
Type:   
      
Default:   
    false  
[Usage Example][33]
* EmbedPlayer.NativeControls  
Determines if mwEmbed should use the Native player controls. This will prevent video tag rewriting and skinning. Useful for devices such as iPad / iPod that don't fully support DOM overlays or don't expose full-screen functionality to JavaScript  
Type:   
    Boolean  
Default:   
    false  
[Usage Example][34]
* EmbedPlayer.EnableIpadHTMLControls  
Determines if iPad should use HTML controls. With HTML controls you can't access native fullscreen. With HTML controls you can support HTML themed controls, overlays, ads etc.  
Type:   
    Boolean  
Default:   
    true
* EmbedPlayer.OverlayControls  
Determines if the player controls should be overlaid on top of the video ( if supported by playback method)  
Type:   
    Boolean  
Default:   
    true
* EmbedPlayer.ShareEmbedMode  
The default share embed mode ( can be 'iframe' or 'xssVideo' )  
Type:   
    String  
Default:   
    iframe
* EmbedPlayer.EnableURLTimeEncoding  
Determines if embedPlayer should support server side temporal URLs for seeking  
Type:   
    Boolean
* EmbedPlayer.DefaultImageDuration  
Default duration for playing images  
Type:   
    Integer  
Default:   
    2
* EmbedPlayer.SeekTargetThreshold  
Seek target precision threshold. Will not seek if difference between playback element time and seek target time is lower than the specified value  
Type:   
    Number  
Default:   
    0.1
* EmbedPlayer.EnableFullscreen  
If fullscreen is globally enabled  
Type:   
    Boolean  
Default:   
    true
* EmbedPlayer.NewWindowFullscreen  
Determines if fullscreen should pop-open a new window ( instead of trying to expand the video player to browser fullscreen )  
Type:   
    Boolean  
Default:   
    false
* EmbedPlayer.EnableIpadNativeFullscreen  
Whether to use the native device fullscreen call on iPad  
Type:   
    Boolean  
Default:   
    false
* EmbedPlayer.EnableNativeChromeFullscreen  
Whether to use the native device fullscreen call on Android Chrome  
Type:   
    Boolean  
Default:   
    false
* EmbedPlayer.FullScreenZIndex  
The z-index given to the player interface during full screen ( high z-index )  
Type:   
    Integer  
Default:   
    999998
* EmbedPlayer.CodecPreference  
The preferred media codec preference ('h264', 'webm', 'ogg')  
Type:   
    String  
Default:   
    n/a
* EmbedPlayer.ShowPosterOnStop  
When set to true, shows the movie thumbnail upon movie ends  
Type:   
    Boolean  
Default:   
    true
* EmbedPlayer.HidePosterOnStart  
When set to true, movie thumbnail doesn't show upon movie load (before playback starts)  
Type:   
    Boolean  
Default:   
    false
* EmbedPlayer.ShowOriginalPoster  
When set to true, the thumbnail is loaded with its original size  
Type:   
    Boolean  
Default:   
    false  
[Usage Example][35]
* EmbedPlayer.ControlsHeight  
Default player controls size  
Type:   
    Integer  
Default:   
    31
* EmbedPlayer.HoverOutTimeout  
Default Timeout (in milliseconds) for Player controls hover out  
Type:   
    Integer  
Default:   
    1000
* EmbedPlayer.EnableRightClick  
If users can right click on the player  
Type:   
    Boolean  
Default:   
    true
* EmbedPlayer.ShowNativeWarning  
Set the browser player warning flag displays warning for non optimal playback  
Type:   
    Boolean  
Default:   
    false
* EmbedPlayer.WaitForMeta  
If the player should wait for metadata like video size and duration before trying to draw the player interface.  
Type:   
    Boolean  
Default:   
    true
* EmbedPlayer.ForceKPlayer  
Force loading the legacy KDP Flash video player.  
Type:   
    Boolean  
Default:   
    false  
[Usage Example][36]
* EmbedPlayer.ForceSPlayer  
Force loading the Silverlight video player.  
Type:   
    Boolean  
Default:   
    false
* EmbedPlayer.iPhoneShowHTMLPlayScreen  
By default, an HTML play screen is displayed with image, thumb and play button. If you are not using ad plugins you may want to set this to false and display the native play button  
Type:   
    Boolean  
Default:   
    true
* EmbedPlayer.twoPhaseManifestHlsAndroid  
If the player should load the final location of m3u8 file and not a URL that redirects to the m3u8 file on Android set this flag to true  
Type:   
    Boolean  
Default:   
    false
* EmbedPlayer.DisableBufferingSpinner  
If the player should hide the loading spinner when it is in buffering mode  
Type:   
    Boolean  
Default:   
    false
* EmbedPlayer.KeepPoster  
Keeps the entry thumbnail shown during playback (covers the video)  
Type:   
    Boolean  
Default:   
    false

  

## MediaProxy

The MediaProxy object is responsible for referencing and loading of the current playing media.

* mediaProxy.entry  
Supports partial or complete override of [entry object][37].  
Type:   
    Object  
[Usage Example][38]
* mediaProxy.entryCuePoints  
Supports partial or complete override of [player cuePoints][39].  
Type:   
    Object  
[Usage Example][38]
* mediaProxy.contextData  
Supports partial or complete override of entry access control restriction.  
Type:   
    Object  
[Usage Example][38]
* mediaProxy.entryMetadata  
Supports partial or complete override of entry custom metadata.  
Type:   
    Object  
[Usage Example][38]
* mediaProxy.sources  
Supports partial or complete override of entry media sources.  
Type:   
    Object  
[Usage Example][38]
* mediaProxy.selectedFlavorId  
The transcoding flavor currently playing. A valid id of a transcoding flavor associated with Kaltura entry currently being played  
Type:   
    String  
Legacy Only
* mediaProxy.preferedFlavorBR  
A prefered bitrate for selecting the flavor to be played (progressive download and RTMP). In case of an RTMP adaptive mbr, a -1 value will force an auto switching as opposed to manual one. Will be affective only if the "disableBitrateCookie=true" Flashvar is sent.  
Type:   
    Integer  
Default:   
    1000  
[Usage Example][40]
* mediaProxy.imageDefaultDuration  
In case an Image media is played in a playlist, this value sets the default time period that the image will hold until the next image is presented. Any positive number representing seconds is acceptable  
Type:   
    Integer  
Default:   
    3
* mediaProxy.supportImageDuration  
This is used to turn an image to a timed image. It is useful in case of playlist where an image should only show for a specific time before the next item will show. If the image should show without time (static), set this to false  
Type:   
    Boolean  
Default:   
    true in case of playlists, false in case of single image  
Legacy Only
* mediaProxy.initialBufferTime  
Set the initial buffer time in dual buffering method. When a number of seconds indicated by this parameter will be buffered, the stream playback will start and the buffer size will increase to expandedBufferTime. Any positive number representing the number of seconds the buffer should hold before playback  
Type:   
    Integer  
Default:   
    2  
Legacy Only
* mediaProxy.expandedBufferTime  
Set the desired buffer time in dual buffering method. After the stream buffer has accumulated the number of seconds indicated by initialBufferTime, the buffer size increases to the number of seconds indicated by this parameter to maximize the buffer download size during playback. Any positive number representing the desired seconds to buffer  
Type:   
    Integer  
Default:   
    10  
Legacy Only
* mediaProxy.mediaPlayFrom  
Indicates the time from which to play the media. If passed and unequal to 0, the player seeks to this time before beginning to play content.  
Type:   
    Integer  
Default:   
    null  
[Usage Example][41]
* mediaProxy.mediaPlayTo  
Indicates the time to which to play the media. If passed and unequal to 0, the player pauses upon arrival at this time  
Type:   
    Integer  
Default:   
    null  
[Usage Example][41]

  

### KDP Components & Plugins:

Using a standard OOP dot notation, each KDP component and plugin attribute can be overridden via Flashvars: objectId.parameter=value.  
For example, to set the playlist to load automatically, pass the following Flashvar: playlistAPI.autoPlay=true

Code sample:  

    
    
    kWidget.embed({
      "targetId": "kaltura_player_1402219661",
      "wid": "_1645161",
      "uiconf_id": 24231962,
      "flashvars": {
    		'autoMute': true,
    		'autoPlay': false,
    		'adsOnReplay': true,
    		'imageDefaultDuration': 5,
    		'mediaProxy.preferedFlavorBR': 1400,
    		'closedCaptions': {
    				'layout': 'ontop',
    				'useCookie': true,
    				'defaultLanguageKey': 'en',
    				'fontsize': 12,
    				'bg' : '0x335544',
    				'fontFamily' : 'Arial',
    				'fontColor' : '0xFFFFFF',
    				'useGlow' : 'false',
    				'glowBlur': 4,
    				'glowColor': '0x133693'
    				}
      },
      "cache_st": 1402219661,
      "entry_id": "1_a3njcsia"
    });
    

## Player API

The JavaScript API is a two-way communication channel that lets the player communicate what it is doing and lets you instruct the player to perform operations.   
For more information: [JavaScript API for Kaltura Media Players][42]

Available JavaScript API:

[Ready Notifications][43] [sendNotification][44] [Bind][45] [unBind][46] [Evaluate][47] [Update properties][17]

### Receiving notification that the player API is ready

See [kWidget.addReadyCallback][48] or the "[readyCallback][1]" function within a dynamic embed.

### Calling a player method from JavaScript

Use the **sendNotification** method to create custom notifications that instruct the player to perform an action, such as play, seek, or pause.
* * *

#### sendNotification (notificationName, [notificationData])

Call a KDP notification (perform actions using this API, for example: play, pause, changeMedia, etc.)

##### PARAMETERS:

* **notificationName** String The name of notification to call.
* **notificationData** Object _( Optional )_ The custom data to pass with the notification.

Code sample:  

    
    
    kWidget.addReadyCallback( function( playerId ){
    	var kdp = document.getElementById( playerId );
    	kdp.kBind( 'mediaReady', function(){
    		// Seek to 30 seconds from the start of the video
    		kdp.sendNotification("doSeek", 30);
    	})
    });
    

#### Available Notifications:

* doPause  
Pauses media playback.  
[Usage Example][49]
* doPlay  
Plays media. If in stopped state will initiate playback sequence.  
[Usage Example][49]
* doStop  
Stops media playback. Will pause and move the playhead to 0.  
[Usage Example][49]
* doSeek  
Issues a seek.  
Notification Data: FloatSeconds of target seek position.  
Sample:
    
        kdp.sendNotification("doSeek", 30);

  
[Usage Example][50]
* changeMedia  
Change the current media entry within the player.  
Notification Data: ObjectData object can specify an entryId or referenceId  
Sample:
    
        kdp.sendNotification("changeMedia", { "entryId" : "0_wm82kqmm" });
    
        kdp.sendNotification("changeMedia", { "mediaProxy" : mediaProxyObject });

  
[Usage Example][51]
* changeVolume  
Change the audio volume  
Notification Data: FloatVolume value from 0 to 1  
Sample:
    
        kdp.sendNotification("changeVolume", 0.5);

  
[Usage Example][52]
* cleanMedia  
Cleans the media from the player.
* doSwitch  
Command the player to manually switch between streams within the resource.  
Notification Data: ObjectSwitch to a target flavor index  
Sample:
    
        kdp.sendNotification("doSwitch", { flavorIndex: 3 });

* changePreferredBitrate  
Change the preferedFlavorBR on mediaProxy.vo object  
Notification Data: The new preferred bitrate  
Legacy Only
* doReplay  
Re-plays the video
* alert  
Pop up an alert  
Notification Data: message: alert message, title: alert title  
[Usage Example][53]
* showUiElement  
Show/hide an element from the layout  
Notification Data: id: ID of the element, show: true / false  
Legacy Only
* removeAlerts  
Fired when all alerts popped by the player need to be removed  
Notification Data: None  
Legacy Only
* enableGui  
Enable or Disable GUI  
Notification Data: { guiEnabled: true / false, enableType: full / controls }  
[Usage Example][54]
* cancelAlerts  
Hide Alerts at the Alerts Mediator  
Notification Data: None  
Legacy Only
* liveEntry  
Call the LiveStream command which tests whether the stream is currently on air  
Notification Data: The URL resource of the played entry  
Legacy Only
* showClosedCaptions  
Display closed captions  
Notification Data: None  
[Usage Example][27]
* hideClosedCaptions  
Hide closed captions  
Notification Data: None  
[Usage Example][27]

  

#### Registering to a player event ( kBind )

Use the **kBind** method to add listen for a specific notification that something happened in the player, such as the video is playing or is paused.
* * *

#### kBind (eventName, callback)

Register a JavaScript handler function for a KDP notification

##### PARAMETERS:

* **eventName** String The name of the notification to listen to. Can be namespaced for easy group event removal.
* **callback** String A function to be called when the named event is triggered.

##### EXAMPLES:

Code sample:  

    
    
    kWidget.addReadyCallback(function( playerId ){
    	var kdp = document.getElementById( playerId );
    	// binds an event and namespces it to "myPluginName"
    	kdp.kBind("playerUpdatePlayhead.myPluginName", function( data, id ){
    		// data = the player's progress time in seconds
    		// id = the ID of the player that fired the notification
    	});
    });
    

### Un-registering a player event

Use the **kUnbind** method to remove a listener that is no longer needed.

Removing event listeners that are no longer needed can improve performance 

Code sample:  

    
    
    kWidget.addReadyCallback(function( playerId ){
    	var kdp = document.getElementById( playerId );
    	// removes all events namespaced with "myPluginName"
    	kdp.kUnbind(".myPluginName");
    	// removes events by event name: 
    	kdp.kUnbind("playerUpdatePlayhead");
    });
    

### Player Life Cycle:

* startUp  
The first command that registers the main proxys and main view mediator.  
Callback Args:   
    Root of the application  
Legacy Only
* initiatApp  
Start the init macro commands.  
Legacy Only
* skinLoaded  
Dispatched when the skin is loaded.  
Legacy Only
* skinLoadFailed  
Dispatched when the skin load failed.  
Legacy Only
* sourceReady  
When the source is ready use to set the media element to the media player.  
Legacy Only
* kdpReady  
Notify that the application is ready to be used and events can be listened to and that the loaded entry is ready to be played.
* kdpEmpty  
Notify that the application is ready to be used and events can be listened to, but no media was loaded
* layoutReady  
Dispatched when the init macro command is done and the layout is ready
* layoutBuildDone  
Dispatched when the player layout is ready and rendered on the screen
* playerReady  
Dispatches when the player is ready to play the media. playerReady event is dispatched each time media is changed.
* pluginsLoaded  
Notification fired when all plugins finished the loading process.  
Callback Args:   
    Plugins map object. Every key is a plugin ID, value is the status of the plugin (see PluginStatus class)  
Legacy Only
* singlePluginLoaded  
Notification fired when a single plugin is ready  
Callback Args:   
    The plugin ID  
Legacy Only
* singlePluginFailedToLoad  
Notification fired when a single plugin failed to load  
Callback Args:   
    The plugin ID  
Legacy Only
* readyToPlay  
Notification added with version 3.5.0, signifies that an entry / media is ready to be played in the KDP  
Callback Args:   
    None  
Legacy Only
* readyToLoad  
Dispatched when the skin is loaded.  
Callback Args:   
    None
* entryReady  
The Entry is set  
Callback Args:   
    The entry object (KalturaBaseEntry)
* entryFailed  
Get Entry failed  
Callback Args:   
    None
* entryNotAvailable  
Notification fired when the BaseEntry object has been retrieved but KDP can't play the entry. Possible reasons: status not ready / moderation status/ access control  
Callback Args:   
    entryId: The new entry ID  
Legacy Only
* mediaReady  
The loadable media has completed loading  
Callback Args:   
    None
* mediaError  
The player notify on media error  
Callback Args:   
    errorEvent: the media error event (MediaErrorEvent)
* mediaLoaded  
MediaLoaded is triggered between each content load. i.e once between every item in a playlist. It indicates the mediaProxy is populated with entry metadata and the metadata from the content media asset or manifest has been loaded  
Callback Args:   
    None

### Player State Events:

* firstPlay  
Triggered once per content entry when first played. If user initiates a replay this is a new content playback sequence and will triger firstPlay again.
* firstQuartile  
The player reached 25% of the entry playback
* secondQuartile  
The player reached 50% of the entry playback
* thirdQuartile  
The player reached 75% of the entry playback
* playerPlayEnd  
The played media has reached the end of content playback.  
Callback Args:   
    None
* durationChange  
Notify a change in the playing entry duration  
Callback Args:   
    New duration value
* rootResize  
The player parent was resized  
Callback Args:   
    width: new width, height: new height  
Legacy Only
* mediaViewableChange  
Used mainly to know when OSMF Media Player is viewable  
Callback Args:   
    None  
Legacy Only
* playerStateChange  
Dispatched when media player's state has changed (OSMF MediaPlayerState: uninitialized / loading / ready / playing / paused / buffering / playbackError  
Callback Args:   
    The new state (MediaPlayerState)
* playerPaused  
The player is now in pause state  
Callback Args:   
    None
* playerPlayed  
Triggered when the player enters a play state. This event be triggered multiple times during a single playback session. For example, playerPlayed will be triggered between ads and when the user plays content after pausing it.  
Callback Args:   
    None
* userInitiatedPlay  
Triggered when the player enters a play state due to user action. For example, when user clicked the play button.  
Callback Args:   
    None
* userInitiatedPause  
Triggered when the player enters a pause state due to user action. For example, when user clicked the pause button.  
Callback Args:   
    None
* preSeek  
Notify about a seek activity that is about to start  
Callback Args:   
    seekTime: The target time to seek to
* seek  
Notify about a seek activity that started  
Callback Args:   
    currentTime: The player current time when the seek operation starts
* seeked  
Notify that the seek activity has finished  
Callback Args:   
    seekedTime: The time that the player actually seeked to
* userInitiatedSeek  
Triggered when the player performs a seek operation due to user action. For example, when user moves the scrubber head or clicks the scrubber track.  
Callback Args:   
    None
* monitorEvent  
Triggers few times a second while the player plays. Used to update the play head and for sync tasks. The exact event interval is defined by the [EmbedPlayer.MonitorRate][55] Flashvar.  
Callback Args:   
    None
* playerUpdatePlayhead  
An update event that notifies about the progress in time when playback is running  
Callback Args:   
    Player current time
* openFullScreen  
Player entered full screen mode  
Callback Args:   
    None  
[Usage Example][56]
* closeFullScreen  
Player exited from full screen mode  
Callback Args:   
    None  
[Usage Example][56]
* hasCloseFullScreen  
The fullscreen has just closed  
Callback Args:   
    None  
[Usage Example][56]
* hasOpenedFullScreen  
The fullscreen was just activated  
Callback Args:   
    None  
[Usage Example][56]
* volumeChanged  
Notification about a change in the player volume  
Callback Args:   
    New volume value
* volumeChangedEnd  
Notification fired when volumeChanged process ended (volume slider thumb release / volume button click). Saves value to cookie if possible  
Callback Args:   
    New volume value  
Legacy Only
* mute  
Notification fired when the player is muted  
Callback Args:   
    None
* unmute  
Notification fired when the player is unmuted  
Callback Args:   
    None
* bytesDownloadedChange  
Notify the current and the previous value of bytesDownloaded  
Callback Args:   
    newValue: bytes loaded
* bytesTotalChange  
Dispatched by the player when the value of the property 'bytesTotal' has changed  
Callback Args:   
    newValue: total bytes
* bufferProgress  
The player dispatches this event when the buffer time has changed  
Callback Args:   
    newTime: new buffer time
* bufferChange  
Dispatches when the player starts or stops buffering  
Callback Args:   
    true / false
* bufferStartEvent  
Dispatches when the player starts buffering  
[Usage Example][57]
* bufferEndEvent  
Dispatches when the player starts buffering  
Callback Args:   
    bufferTime: The amount of time since last buffer start event.  
[Usage Example][57]
* scrubberDragStart  
The scrubber had started being dragged  
Callback Args:   
    None  
Legacy Only
* scrubberDragEnd  
The scrubber had stopped being dragged  
Callback Args:   
    None  
Legacy Only
* intelliSeek  
Notification fired when the player has started intelligent seeking  
Callback Args:   
    intelliseekTo: new position to seek to  
Legacy Only
* freePreviewEnd  
A notification that is called on the hosting page with content that should be purchased after a short preview  
Callback Args:   
    id of the viewed entry
* changeMediaProcessStarted  
Notification fired when the first mini-command of the ChangeMedia macro command has started  
Callback Args:   
    entryId: The new entry ID  
Legacy Only
* metadataReceived  
Notification fired when entry custom data was received  
Callback Args:   
    None
* cuePointsReceived  
Notification fired when the player has successfully loaded an entry's cue-point configuration  
Callback Args:   
    Cue Points Map. Object mapping between start-times and arrays of the cue points found on that start-time
* cuePointReached  
Notification fired when the player reaches a cuePoint  
Callback Args:   
    Current cuePoint object. Return Object with context and a cuePoint object  
[Usage Example][58]
* switchingChangeStarted  
Notification dispatched when the player has started switching to a different dynamic bitrate  
Callback Args:   
    newIndex: The index of the bitrate the player started switching to. If auto, send -1, newBitrate: The bitrate the player started switching to. If auto, send null
* switchingChangeComplete  
Notification dispatched when the player has finished switching to a different dynamic bitrate  
Callback Args:   
    currentIndex: The index of the bitrate that the player finished switching to, currentBitrate: The bitrate the player finished switching to
* playbackComplete  
Signifies the end of a media in the player (can be either ad or content)  
Callback Args:   
    None
* closedCaptionsHidden  
Notification dispatched when captions are hidden  
Callback Args:   
    None
* closedCaptionsDisplayed  
Notification dispatched when captions are displayed  
Callback Args:   
    language: the selected language
* changedClosedCaptions  
Notification dispatched when captions language is changed  
Callback Args:   
    language: the new selected language

### Player Advertisement Related Notifications:

* adOpportunity  
Notification fired when the player's time progress reaches an ad cue point  
Callback Args:   
    context: context of the ad opportunity: pre, post, mid, cuePoint: the cue point object  
[Usage Example][59]
* sequenceItemPlayStart  
Signifies the start of an entry that is part of a sequence  
Callback Args:   
    sequenceContext: pre / post / mid / main (see SequenceContextType class), currentIndex: index of current item  
Legacy Only
* sequenceItemPlayEnd  
Signifies the end of an entry that is part of a sequence as opposed to the end of a regular entry  
Callback Args:   
    sequenceContext: pre / post / mid / main (see SequenceContextType class), currentIndex: index of current item  
Legacy Only
* preSequenceStart  
Signifies the start of the pre-sequence  
Callback Args:   
    None
* preSequenceComplete  
Signifies the end of the pre-sequence  
Callback Args:   
    None
* postSequenceStart  
Signifies the start of the post-sequence  
Callback Args:   
    None
* postSequenceComplete  
Signifies the end of the post-sequence  
Callback Args:   
    None
* midSequenceStart  
Notification fired when the midroll sequence starts  
Callback Args:   
    None
* midSequenceComplete  
Notification fired when the midroll sequence ends  
Callback Args:   
    None
* bumperStarted  
Defines the value of the type property of a bumper start notification  
Callback Args:   
    timeSlot: preroll / postroll  
Legacy Only
* bumperClicked  
Defines the value of the type property of a bumper click notification  
Callback Args:   
    None  
Legacy Only
* adStart  
Defines the value of the type property of an ad start notification  
Callback Args:   
    timeSlot: pre / post / mid / main (see SequenceContextType class)
* onAdPlay  
Dispatched when the ad starts to play. Use this event to get the ad property values  
Callback Args:   
    Ad ID, Ad System, Ad Type, Ad Position, Ad Duration, Ad Pod Position, Ad Pod start time, Ad title, Trafficking Parameters (DoubleClick only)  
[Usage Example][60]
* adClick  
Defines the value of the type property of an ad click notification  
Callback Args:   
    timeSlot: pre / post / mid / main (see SequenceContextType class)
* adEnd  
Defines the value of the type property of an ad end notification  
Callback Args:   
    timeSlot: pre / post / mid / main (see SequenceContextType class)
* firstQuartileOfAd  
Defines the value of the type property of 25% of ad notification  
Callback Args:   
    timeSlot: pre / post / mid / main (see SequenceContextType class)  
Legacy Only
* midOfAd  
Defines the value of the type property of 50% of ad notification  
Callback Args:   
    timeSlot: pre / post / mid / main (see SequenceContextType class)  
Legacy Only
* ThirdQuartileOfAd  
Defines the value of the type property of 75% of ad notification  
Callback Args:   
    timeSlot: pre / post / mid / main (see SequenceContextType class)  
Legacy Only
* adErrorEvent  
Fired when an ad fails to load (applicable to all ad systems)  
Callback Args:   
    None

### Playlist and Related Notifications:

* relatedVideoSelect  
Called when user clicks or auto continues to a related video.  
Callback Args:   
    An object with "entryId" property with the current selected entry as a value.  
[Usage Example][61]
* playlistReady  
The playlist layout is ready.  
[Usage Example][33]
* playlistPlayNext  
The next clip was requested.  
[Usage Example][33]
* playlistPlayPrevious  
The previous clip was requested.  
[Usage Example][33]
* playlistFirstEntry  
The first clip in the playlist was loaded.  
[Usage Example][33]
* playlistMiddleEntry  
A clip that is not the first or the last clip in the playlist was loaded.  
[Usage Example][33]
* playlistLastEntry  
The last clip in the playlist was loaded.  
[Usage Example][33]

### Retrieving a player property

Use the **evaluate** method to find out something about a player by extracting data from player components.
* * *

#### evaluate (object.property.properties)

Retrieves the value of a KDP model property or component's property, using the standard OOP dot notation inside curly braces

##### PARAMETERS:

* **object.property.properties** String The reference to the component object with data that you want to extract. Enclose the reference in curly braces within single or double quotation marks.

Code sample:  

    
    
    kWidget.addReadyCallback(function( playerId ){
    	var kdp = document.getElementById( playerId );
    	// alert the entry name
    	alert('Entry name: '+ kdp.evaluate('{mediaProxy.entry.name}') );
    });
    

### Available Properties:

* isHTML5  
A flag specifying if the current player is an HTML5 player (Universal player)
* playerVersion  
The current version of the player library. Versions are represented in major.minor.point format  
[Usage Example][62]
* flashVersion  
The version of Adobe Flash available. Returns 0,0,0 if Flash is not available.  
[Usage Example][62]
* sequenceProxy.timeRemaining  
Time remaining until the end of the current ads sequence
* sequenceProxy.duration  
The total duration of the current ad set.
* sequenceProxy.isInSequence  
A flag specifying if the player is currently playing ads
* sequenceProxy.skipOffsetRemaining  
During ad playback, the time remaining until the Skip button appears
* sequenceProxy.activePluginMetadata  
Metadata object of the plugin currently playing the ads sequence
* video.volume  
The volume of the currently playing video (0-1)
* video.player.currentTime  
The current video time in seconds
* video.player.width  
The current video player width in pixels.  
[Usage Example][62]
* video.player.height  
The current video player height in pixels.  
[Usage Example][62]
* video.buffer.lastBufferDuration  
How long the player was in a buffering state, during the last buffer event. Should be read after bufferEndEvent. Value is in seconds.  
[Usage Example][57]
* video.buffer.lastBufferDurationMs  
Same as lastBufferDuration but in Milliseconds.  
[Usage Example][57]
* video.buffer.bufferEndTime  
Timestamp of last buffer end, in ms.  
[Usage Example][57]
* video.buffer.bufferStartTime  
Timestamp of last buffer start, in ms.  
[Usage Example][57]
* video.buffer.percent  
Percentage of the video that has been buffered.  
[Usage Example][57]
* duration  
Current video duration in seconds
* mediaProxy.entry  
Return or set all entry properties. Entry properties include: 'id','name','description','plays','views','duration','createdAt', 'thumbnailUrl' and others. See Kaltura [base entry object][63], in Kaltura API definition for full set of properties.  
[Usage Example][38]
* mediaProxy.entryCuePoints  
Return or set cue points for the current media entry. See Kaltura [cuePoint object][64], in Kaltura API definition for full set of properties.  
[Usage Example][38]
* mediaProxy.entryMetadata  
Metadata object for the current entry. Enables reading custom metadata key value pairs.  
[Usage Example][65]
* mediaProxy.sources  
An array of HTML5 sources with src attribute for fully resolved URL and Type attribute which should match HTML5 source type value.  
[Usage Example][38]
* mediaProxy.isLive  
Returns true, if the the current entries live broadcast is active.
* mediaProxy.isOffline  
Returns true if the current entries live broadcast is offline.
* mediaProxy.kalturaMediaFlavorArray  
An array holding all available flavours for the current media
* configProxy  
The player configuration object. Allows access to all UI vars and plugin properties
* playerStatusProxy.kdpStatus  
The player status. Can be "empty" or "ready"
* playerStatusProxy.loadTime  
The time it took to load the player on the page
* playlistAPI.dataProvider  
The data provider of a play list holding all the entries for this list
* utility.random  
Utility for generating a random number
* utility.timestamp  
Utility for generating the current time stamp
* utility.referrer_url  
Retrieve the referrer URL
* utility.referrer_host  
Retrieve the referrer host
* utility.nativeAd  
The native device identifier, [ AdvertisingIdentifier ][66] for Apple and [ AdvertisingIdClient ][67] for Android.  
[Usage Example][38]

### Setting a player attribute

Use the **setKDPAttribute** method to change a player attribute by setting its value.

  
Code sample:
    
    
    kdp.setKDPAttribute("configProxy.flashvars","autoPlay","true")
    

Some plugins support runtime updates using **setKDPAttribute**.   
For example, the "theme" plugin supports such updates:
    
    
    var kdp = document.getElementById('kVideoTarget');
    kdp.setKDPAttribute("theme", "buttonsSize", "14");
    

* * *

#### setKDPAttribute (object, property, value)

Change a value of a player configuration property or component's property using the standard OOP dot notation.

##### PARAMETERS:

* **object** String A string that represents the object you want to modify. Use standard dot notation to specify sub-objects, for example, configProxy.flashvars
* **property** String The player property that you want to modify.
* **value** String The new value that you want to set for the player property.

###  Stand Alone Player Modes 

Kaltura player supports several modes for associating content and configuration with the player. To evaluate of what is best for your integration requirements we strongly recommend consulting with Kaltura Solutions team.

* **MediaProxy Override** \-- Overrides media and player configuration at embed time. 
    * Good for "light" integrations tests a few lines of JavaScript
    * Can be used with changeMedia, to retain CDN cache for player & config
    * Not good for portability, native apps, or player iframe services.
    * Not compatible with entity baased plugins or clip lists ( playlist, related videos, bumper ) 
* **Embed Services Lib** \-- The "embed service" library includes tools for translating your own entitiy and player JSON data store against Kaltura player provided identifiers. 
    * Recommended approach for connecting the player to multiple entity services outside of Kaltura API
    * Retains portability, native apps, and player iframe services.
    * Compatible with entity baaed plugins or clip lists ( playlist, related videos, etc. ) 
* ** Kaltura Platform API ** \-- baseline platform data provider 
    * Uses Kaltura provided entries with flexible custom MetaData store, internal and external asset urls references etc.

### MediaProxy Object

Defines the full set of entities for mediaProxy object: 

[1]: http://player.kaltura.com#kWidget.settingsObject
[2]: http://player.kaltura.com/modules/KalturaSupport/tests/kWidget.embed.qunit.html
[3]: http://www.kaltura.com/api_v3/testmeDoc/index.php
[4]: http://www.kaltura.com/api_v3/testme/client-libs.php
[5]: http://www.kaltura.com/api_v3/testme/index.php
[6]: http://player.kaltura.com/kWidget/tests/kWidget.api.html
[7]: http://player.kaltura.com#kWidget.apiOptions
[8]: http://player.kaltura.com#uiVarsServices
[9]: http://player.kaltura.com#uiVarsMediaEntry
[10]: http://player.kaltura.com#uiVarsLayout
[11]: http://player.kaltura.com#uiVarsPlayback
[12]: http://player.kaltura.com#uiVarsPlayerProperties
[13]: http://player.kaltura.com#uiVarsMediaProxy
[14]: http://knowledge.kaltura.com/universal-studio-information-guide
[15]: http://knowledge.kaltura.com/sites/default/files/styles/large/public/ui_variables_2.png
[16]: http://player.kaltura.com/kWidget/tests/PlayerVersionUtility.html
[17]: http://player.kaltura.com#setKDPAttribute-desc
[18]: http://player.kaltura.com/modules/KalturaSupport/tests/ForceFlashOnDesktop.html
[19]: http://player.kaltura.com/modules/KalturaSupport/tests/ForceFlashOnDesktopSafari.html
[20]: http://player.kaltura.com/modules/KalturaSupport/tests/ExternalResources.qunit.html
[21]: http://player.kaltura.com/modules/KalturaSupport/tests/UseHLS_WhereAvailable.qunit.html
[22]: http://player.kaltura.com/modules/KalturaSupport/tests/LeadWithHLSOnFlash.html
[23]: http://player.kaltura.com/modules/KalturaSupport/tests/ReferenceId.html
[24]: http://player.kaltura.com/modules/KalturaSupport/tests/UserAgentPlayerRules.html
[25]: http://player.kaltura.com/modules/KalturaSupport/tests/AlertForCookies.qunit.html
[26]: http://player.kaltura.com/modules/KalturaSupport/tests/ThumbnailEmbedExternalThumbnail.html
[27]: http://player.kaltura.com/modules/KalturaSupport/tests/ClosedCaptions.html
[28]: http://player.kaltura.com/modules/KalturaSupport/tests/AutoPlay.qunit.html
[29]: http://player.kaltura.com/modules/KalturaSupport/tests/PlaylistAutoMute.html
[30]: http://player.kaltura.com/modules/KalturaSupport/tests/Loop.qunit.html
[31]: http://player.kaltura.com/modules/KalturaSupport/tests/AdEnableControls.html
[32]: http://player.kaltura.com/modules/DoubleClick/tests/DoubleClickManagedPlayerAdApi.qunit.html
[33]: http://player.kaltura.com/modules/KalturaSupport/tests/PlaylistEvents.qunit.html
[34]: http://player.kaltura.com/modules/KalturaSupport/tests/iPadNativeControls.html
[35]: http://player.kaltura.com/modules/KalturaSupport/tests/ImageEntry.html
[36]: http://player.kaltura.com/modules/KalturaSupport/tests/ForceKPlayer.qunit.html
[37]: http://www.kaltura.com/api_v3/testmeDoc/index.php?object=KalturaBaseEntry
[38]: http://player.kaltura.com/modules/KalturaSupport/tests/StandAlonePlayerMediaProxyOverride.html
[39]: http://www.kaltura.com/api_v3/testmeDoc/index.php?object=KalturaCuePoint
[40]: http://player.kaltura.com/modules/KalturaSupport/tests/FlavorSelector.preferedFlavorBR.qunit.html
[41]: http://player.kaltura.com/modules/KalturaSupport/tests/PlayFromOffsetStartTimeToEndTime.html
[42]: http://knowledge.kaltura.com/javascript-api-kaltura-media-players#UnderstandingtheJavaScriptAPIWorkflow
[43]: http://player.kaltura.com#kWidget.addReadyCallback-desc
[44]: http://player.kaltura.com#sendNotification-desc
[45]: http://player.kaltura.com#kBind-desc
[46]: http://player.kaltura.com/kUnbind-desc
[47]: http://player.kaltura.com#evaluate-desc
[48]: http://player.kaltura.com#kWidget.addReadyCallback
[49]: http://player.kaltura.com/modules/KalturaSupport/tests/PlayStopApi.qunit.html
[50]: http://player.kaltura.com/modules/KalturaSupport/tests/SeekApi.qunit.html
[51]: http://player.kaltura.com/modules/KalturaSupport/tests/ChangeMediaEntry.qunit.html
[52]: http://player.kaltura.com/modules/KalturaSupport/tests/SendNotificationWithAds.html
[53]: http://player.kaltura.com/modules/KalturaSupport/tests/showAlert.html
[54]: http://player.kaltura.com/modules/KalturaSupport/tests/EnableGui.html
[55]: http://player.kaltura.com#EmbedPlayer.MonitorRate
[56]: http://player.kaltura.com/modules/KalturaSupport/tests/FullscreenOnPlay.html
[57]: http://player.kaltura.com/modules/KalturaSupport/tests/PlayerBufferTest.qunit.html
[58]: http://player.kaltura.com/modules/KalturaSupport/components/related/CuePointsMidrollVast.html
[59]: http://player.kaltura.com/modules/KalturaSupport/tests/CuePointsMidrollVast.html
[60]: http://player.kaltura.com/modules/DoubleClick/tests/DoubleClickAdEvents.qunit.html
[61]: http://player.kaltura.com/modules/KalturaSupport/components/related/Related.html
[62]: http://player.kaltura.com/modules/AdSupport/tests/AdTagUrlSubstitutions.html
[63]: http://www.kaltura.com/api_v3/testmeDoc/?object=KalturaBaseEntry
[64]: "http://www.kaltura.com/api_v3/testmeDoc/?object=KalturaCuePoint"
[65]: http://player.kaltura.com/modules/KalturaSupport/tests/CustomMetaData.html
[66]: https://developer.apple.com/library/ios/documentation/AdSupport/Reference/ASIdentifierManager_Ref/#//apple_ref/occ/instp/ASIdentifierManager/advertisingIdentifier
[67]: http://developer.android.com/reference/com/google/android/gms/ads/identifier/AdvertisingIdClient.Info.html

  
