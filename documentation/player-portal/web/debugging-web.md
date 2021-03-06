---
layout: page
title: Debugging and Troubleshooting for Web Player
weight: 110
---

In this section you'll learn how to use debug mode to view explicit messages in the player to troubleshoot detected problems.

## Running the Player in Debug Mode

To debug the player and view explicit messages in the console, you'll need to run the player in debug mode using one of the following options:

**Option 1: Define a global window debug variable**

In your application, define at the top of your page the following window debug variable:

```
window.DEBUG_KALTURA_PLAYER = true;
```

**Option 2: Add a query string parameter to the page URL**

In your page URL, add the `debugKalturaPlayer` query string parameter:

```
http://my/page/url?debugKalturaPlayer
```

**Options 3: Using Player Config**

```
var config = {
    ...
    logLevel: "DEBUG"
    ...
};
var player = KalturaPlayer.setup(config);
```

## About Player Logs

After implementing one of the options above, open your browser developer tools and look at the player logs, for example:

![player console logs](/assets/images/console-logs-example.png)

### Log Conventions

As you can see from the figure above, the player log conventions are built with the following template:

```
[Component] Message
```

> Note: Remember to stick to these conventions when building you application to ensure that debugging & troubleshooting are easy to understand.

### Controlling the Log Level

If you want to use different log level than `DEBUG`, you'll need to configure the player with the desired log level. For example, to display only logs from a warning level and above in the console, use the following:

```js
var config = {
    ...
    logLevel: "WARN"
    ...
};
```
