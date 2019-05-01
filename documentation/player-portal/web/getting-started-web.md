---
layout: page
title: Getting Started with the Web Player
weight: 110
---

The Kaltura HTML5 Player is really awesome and cool and fast and has nice features. 

## Before You Begin 

To create a new Kaltura Player, you'll need to have an active Kaltura Management Console (KMC) account. Click [here](https://corp.kaltura.com/Products/Video-Applications/Kaltura-Video-Management-Console) for more information about getting access.

## Creating a TV Studio Player

Kaltura Video Players are created and managed in the KMC [Studio](https://kmc.kaltura.com/index.php/kmcng/studio/v3), which is the second tab in the header. You'll find options for the Universal Studio, for legacy support, and the TV Platform Studio - which is colloquially referred to as Player V3. There you will also find all your available players in both categories. This guide will walk you through creating and embedding a TV Studio Player, which is focused on speed and performance.

1. Click the **Add New Player** button, and give it a name. At this point, you can save the player, as default settings are enough.

2. To customize the player, however, tabs in the left sidebar give you options for monetization and analytics settings, as well as the ability to update the player's config file.

3. If you've made changes to your player, you can see what different entries look like in that player in the Basic Settings tab. Save the player and go back to the player list.

4. You should see your new player in your player list, and that's it - you've created a new Kaltura Player which you can now use to play your videos!

## Generating a Kaltura Player Embed Code

In the [**Content**](https://kmc.kaltura.com/index.php/kmcng/content/entries/list) tab in the KMC, you'll find all your available entries and playlists.

Click the options dropdown for the entry you want to embed (three dots) and select Share & Embed. At the top, select the player you wish to use. In advanced settings, select auto-embed and then copy the embed code that is produced. The **Auto Embed** method gets the player onto the page quickly and easily, without any runtime customizations.  

## Create a Kaltura Player Embed Code

To manually write an embed code, you'll need a few things:

- Your partner ID, which can be found in the KMC under [Integration Settings](https://kmc.kaltura.com/index.php/kmcng/settings/integrationSettings)
- The Player ID of the player you wish to use, which can be found in the Studio tab in the ID column. It is also known as the UI Conf ID. 
- The Entry ID for the entry you want to embed, which is found in the Content tab 
- An HTML div in the page you want to embed your player 

Let's walk through the steps for writing that embed code. 

1. Create an HTML page and add a div with the ID of your choice. You can set the dimensions of the player here as well:

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
<head>
<body>
  <div id="new-player" style="width: 640px;height: 360px"></div>
</body>
</html>
```
2. Load the player library with this script: 

```html 
  <script type="text/javascript" src="https://cdnapisec.kaltura.com/p/2196781/embedPlaykitJs/uiconf_id/41483031"></script>
```

3. The embed script contains the targetId, which is your div ID, as well as your partnerID, the uiConfId (player ID), and the entry ID.  

```html
<script type="text/javascript">
  try {
    let kalturaPlayer = KalturaPlayer.setup({
      targetId: "kalturaPlayer",
      provider: {
        partnerId: 0000000,
        uiConfId: 22222222
      },
      playback: {
        autoplay: true
        }
    });
    kalturaPlayer.loadMedia({entryId: '1_p2bzler6'});
  } catch (e) {
  console.error(e.message)
  }
</script>
```

4. Bring it all together: 

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
<head>
<body>
  <div id="new-player" style="width: 640px;height: 360px"></div>

  <script type="text/javascript" src="https://cdnapisec.kaltura.com/p/2196781/embedPlaykitJs/uiconf_id/41483031"></script>

  <script type="text/javascript">
  try {
    let kalturaPlayer = KalturaPlayer.setup({
      targetId: "kalturaPlayer",
      provider: {
        partnerId: 2365491,
        uiConfId: 42929341
      },
      playback: {
        autoplay: true
        }
    });
    kalturaPlayer.loadMedia({entryId: '1_p2bzler6'});
  } catch (e) {
    console.error(e.message)
  }
  </script>

</body>
</html>
```

Congrats! Running this page should show you a Kaltura Player loaded with the entry that you chose. 

Notice that this method is the **Dynamic Embed**, which is different than the aforementioned auto embed code, and is useful for cases when you want control runtime configuration dynamically. Click [here](https://developer.kaltura.com/player/web/embed-types-web) to read more about embed types. 

## Configuring the Player

After creating a player and embedding it in your site, you may want to configure it using the wide range of configuration options. Click [here](https://developer.kaltura.com/player/web/configration) to learn more about the various ways of configuring your player. 
