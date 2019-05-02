---
layout: page
title: Playlists for Web 
weight: 110
---

The Kaltura Player exposes several APIs that are used for loading, configuring, and manipulating playlists.

### Load A Playlist

Before loading a playlist, you'll need to set up a Kaltura Player instance as follows.

```javascript
const config = PLAYER_CONFIG;
const kalturaPlayer = KalturaPlayer.setup(config);
```

To learn how to set up a Kaltura Player, see [Player Setup](https://developer.kaltura.com/player/web/player-setup).

Once you have a Kaltura Player instance, you can load a playlist using one of the following methods:

#### By Playlist ID (OVP Only)

To load a playlist by ID, use [`loadPlaylist`](https://developer.kaltura.com/player/web/api-web#loadplaylist) method.

```javascript
kalturaPlayer.loadPlaylist({playlistId: '123456'});
```

#### By Entry List

To load a playlist by entry list, use the [`loadPlaylistByEntryList`](https://developer.kaltura.com/player/web/api-web#loadplaylistbyentrylist) method.

This method creates a playlist according to the given entries.

```javascript
kalturaPlayer.loadPlaylistByEntryList({entries: [{entryId: '01234'}, {entryId: '56789'}]});
```

#### By Configuration

You can load a playlist by configuring the playlist data and items explicitly using the [`configure`](https://developer.kaltura.com/player/web/api-web#configure-3) method.

```javascript
kalturaPlayer.configure({
  playlist: {
    metadata: {
      name: 'my playlist name',
      description: 'my playlist desc'
    },
    items: [
      {
        sources: {
          poster: 'poster_1_url',
          hls: [
            {
              id: 'id1',
              mimetype: 'application/x-mpegURL',
              url: 'source_1_url'
            }
          ]
        }
      },
      {
        sources: {
          poster: 'poster_2_url',
          hls: [
            {
              id: 'id2',
              mimetype: 'application/x-mpegURL',
              url: 'source_2_url'
            }
          ]
        }
      }
    ]
  }
});
```

For all playlist options, see [`KPPlaylistObject`](https://developer.kaltura.com/player/web/api-web#kpplaylistobject).

## Configure the Playlist

### Auto Continue

By default, once the current item is ended, the playlist continues to the next item automatically.

To change this behavior, configure the [`options`](https://developer.kaltura.com/player/web/api-web#kpplaylistoptions) under [`KPPlaylistConfigObject`](https://developer.kaltura.com/player/web/api-web#kpplaylistconfigobject) using one of the following methods:

Via the API:

```javascript
kalturaPlayer.loadPlaylist({playlistId: '123456'}, {options: {autoContinue: false}});
```

```javascript
kalturaPlayer.loadPlaylistByEntryList({entries: [{entryId: '01234'}, {entryId: '56789'}]}, {options: {autoContinue: false}});
```

By configuration:

```javascript
kalturaPlayer.configure({
  playlist: {
    options: {autoContinue: false}
  }
});
```

> Note: The `autoContinue` property is relevant only for the second item onwards.
> 
To play the first entry automatically, use the [`autoplay`](https://developer.kaltura.com/player/web/autoplay) configuration.

For full playlist options see [`KPPlaylistOptions`](https://developer.kaltura.com/player/web/api-web#kpplaylistoptions).

### Countdown

When the current item is about to end and the playlist is set to continue automatically, the user will see a countdown displayed. The user can then skip to the next item immediately or cancel the switching.
![playlist-countdown](images/playlist-countdown.png)

By default, the countdown is displayed for 10 seconds until the end.

To change this behavior, configure the [`countdown`](https://developer.kaltura.com/player/web/api-web#kpplaylistcountdownoptions) under [`KPPlaylistConfigObject`](https://developer.kaltura.com/player/web/api-web#kpplaylistconfigobject):

 For example, to show the countdown for 20 seconds until the end, configure:

Via the API:

```javascript
kalturaPlayer.loadPlaylist({playlistId: '123456'}, {countdown: {duration: 20}});
```

```javascript
kalturaPlayer.loadPlaylistByEntryList({entries: [{entryId: '01234'}, {entryId: '56789'}]}, {countdown: {duration: 20}});
```

By configuration:

```javascript
kalturaPlayer.configure({
  playlist: {
    countdown: {
      duration: 20
    }
  }
});
```

To show the countdown in a specific moment (usually to enable the user to skip the end subtitles) configure:

```javascript
kalturaPlayer.loadPlaylist({playlistId: '123456'}, {countdown: {timeToShow: 600}});
```

In this case the countdown will display at the 600th second for 10 seconds, and then will skip to the next item.

For full countdown options see [`KPPlaylistCountdownOptions`](https://developer.kaltura.com/player/web/api-web#kpplaylistcountdownoptions).

## Switching Items

Using the [`playlist`](https://developer.kaltura.com/player/web/api-web#playlist) API, you can get the playlist data and then switch between the items.

```javascript
// switch to the next item
kalturaPlayer.playlist.playNext();

// switch to the previous item
kalturaPlayer.playlist.playPrev();

// switch to a specific item by index
const lastItemIndex = kalturaPlayer.playlist.items.length - 1;
kalturaPlayer.playlist.playItem(lastItemIndex);
```

For the complete `playlist` API, see [PlaylistManager](https://developer.kaltura.com/player/web/api-web#playlistmanager).

## Change Playlist

To clean the playlist data, you'll need to call the [`playlist.reset`](https://developer.kaltura.com/player/web/api-web#reset-2) method.

Here is an example how to change the playlist using the [`playlist events`](https://developer.kaltura.com/player/web/api-web#playlisteventtype) and [`playlist.reset`](https://developer.kaltura.com/player/web/api-web#reset-2) method.

```javascript
kalturaPlayer.loadPlaylist({playlistId: '01234'});
kalturaPlayer.addEventListener(KalturaPlayer.playlist.PlaylistEventType.PLAYLIST_ENDED, () => {
  kalturaPlayer.playlist.reset();
  kalturaPlayer.loadPlaylist({playlistId: '56789'});
});
```

> Note: The playlist [config](https://developer.kaltura.com/player/web/api-web#KPPlaylistConfigObject) is not removed on reset.

```javascript
kalturaPlayer.loadPlaylist({playlistId: '01234'}, {options: {autoContinue: false}});
kalturaPlayer.playlist.reset();
kalturaPlayer.loadPlaylist({playlistId: '56789'}).then(() => {
  console.log(kalturaPlayer.playlist.options.autoContinue); // false
});
```

> To change this behavior, you'll need to override the configuration as follows:

```javascript
kalturaPlayer.loadPlaylist({playlistId: '01234'}, {options: {autoContinue: false}});
kalturaPlayer.playlist.reset();
kalturaPlayer.loadPlaylist({playlistId: '56789'}, {options: {autoContinue: true}}).then(() => {
  console.log(kalturaPlayer.playlist.options.autoContinue); // true
});
```
