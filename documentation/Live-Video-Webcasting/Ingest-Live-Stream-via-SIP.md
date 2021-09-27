---
layout: page
title: Connecting to a Webcasting Stream via SIP
weight: 110
---

Kaltura offers [SIP integration](https://knowledge.kaltura.com/help/kaltura-video-conference-integration-v1#activatevcikmsusers) for services like Zoom and Skype. As mentioned previously, webcasting and SIP integration aka VCI must be enabled for your account. Here are API calls to work with SIP and the Kaltura API:

### Check if SIP permission is enabled on this account

Using the [permission.list](https://developer.kaltura.com/console/service/permission/action/list) API Call here are the parameters needed:

```bash
curl -X POST https://www.kaltura.com/api_v3/service/permission/action/list \

  -d "ks=$KALTURA_SESSION" \
  -d "filter[statusEqual]=1" \
  -d "filter[nameEqual]=FEATURE_SIP" \
  -d "filter[objectType]=KalturaPermissionFilter"
```

In the response - Check if "totalCount": 1,--> if it’s 1, than SIP is enabled on this account. If not, go to admin console, configure this account, and add “Kaltura Live - Self Serve enabled”

### Check if the liveStream Entry doesn’t already have a SIP token

[liveStream.get](https://developer.kaltura.com/console/service/liveStream/action/get) 

```bash
curl -X POST https://www.kaltura.com/api_v3/service/livestream/action/get \
    -d "ks=$KALTURA_SESSION" \
    -d "entryId=[YOUR_ENTRY_ID]" \
    -d "version=-1"
```

In the response - Check if "sipToken": null or empty, --> that means you don’t yet have a token

### Generate the SIP token

[pexip.generateSipUrl](https://developer.kaltura.com/console/service/pexip/action/generateSipUrl)  

Based on the result of previous step, if the entry already has a sipToken, and you wish to regenerate a new one – make sure to pass true in the regenerate param below. If the entry does not yet have a sipToken, pass false in regenerate below.

```bash
curl -X POST https://www.kaltura.com/api_v3/service/sip_pexip/action/generateSipUrl \
    -d "ks=$KALTURA_SESSION" \
    -d "entryId=[YOUR_ENTRY_ID]" \
    -d "regenerate=true"
```