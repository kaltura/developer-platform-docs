---
layout: page
title: Google Play Services Security Provider
weight: 110
---

Google Play Services includes an always up-to-date version of the SSL library. To use it instead of the device's default (which may be out of date and contain security issues, especially on older devices), the application has to "install" it on startup.

Many servers have stopped accepting clients with older versions of SSL/TLS because of known vulnerabilities. Old versions of Android may therefore fail to connect to those servers (and throw an `SSLHandshakeException`). The installable provider is regularly updated, so it won't have these issues. 

# Usage

The full usage is detailed in [Google's guide](https://developer.android.com/training/articles/security-gms-provider). Below are the basic steps.

- Import [com.google.android.gms.security.ProviderInstaller](https://developers.google.com/android/reference/com/google/android/gms/security/ProviderInstaller.html)
- Call the installer:
  - `ProviderInstaller.installIfNeeded(context)` if called from a background thread
  - `ProviderInstaller.installIfNeededAsync(context, listener)` if called from the UI thread

When using the async version, the app has to pass a [ProviderInstallListener](https://developers.google.com/android/reference/com/google/android/gms/security/ProviderInstaller.ProviderInstallListener).

The provider is part of the "base" Google Play Services component; if the app already uses *any* Play Services component, it already has access to `ProviderInstaller`. If not, it should install it as explained in [the setup guide](https://developers.google.com/android/guides/setup).
