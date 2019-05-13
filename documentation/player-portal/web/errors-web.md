---
layout: page
title: Handling Player Errors 
weight: 110
---

Errors are used to notify a user when a critical issue has occurred or to log recoverable issues. An error object consists of three mandatory parameters:

- Error Severity
- Error Category
- Error Code
- Error Custom Data - An optional object with additional information about the issue.

There are two severities to an error: 
- A **critical error** is triggered in an error event and is shown to the user as error overlay in the player itself.
- A **recoverable error** is not shown to an end user, but appears in the console.

## Error Lists

You'll find the full lists of errors here:

- [Error Severity List](https://github.com/kaltura/playkit-js/blob/master/src/error/severity.js)
- [Error Category List](https://github.com/kaltura/playkit-js/blob/master/src/error/category.js)
- [Error Code List](https://github.com/kaltura/playkit-js/blob/master/src/error/code.js)

## Listening to an Error Event

You can listen to errors the player emits by listening to an '`error`' event as follows:

{% highlight javascript %}
player.addEventListener(player.Event.ERROR, event => {
  const error = e.payload;
  console.log('The error severity is: ' + error.severity);
  console.log('The error category is: ' + error.category);
  console.log('The error code is: ' + error.code);
  console.log('The error data is', error.data);
});
{% endhighlight %}

## Creating an Error

If you wish to change / emit an error event, you'll need to create an error object in the following manner:

{% highlight javascript %}
const myError = new Error(Error.Severity.CRITICAL, Error.Category.NETWORK, Error.Code.HTTP_ERROR, {url: 'www.some-bad-url.com'});
{% endhighlight %}

Next, you'll need to dispatch an `Error` event:

{% highlight javascript %}
player.dispatchEvent(new FakeEvent(player.Event.Error, myError));
{% endhighlight %}

> You can find additional information about dispatching events [here](https://developer.kaltura.com/player/web/player-events-web).

## Using Debug Mode to See Explicit Error Messages

Use the debug mode in the player to view explicit error messages in the console, which look something like this: 

```
[Error] Category:1 | Code:1002 | 'Http Error'
```

> You can find additional information about debugging and troubleshooting the player [here](https://developer.kaltura.com/player/web/debugging-web). 


