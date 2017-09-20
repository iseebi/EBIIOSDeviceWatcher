# EBIiOSDeviceWatcher

Observe iOSdevice connect/disconnect on macOS.

## How to use

```
self.watcher = [[EBIMobileDeviceWatcher alloc] init];
self.watcher.delegate = self;
[self.watcher startWatcing];
```

## Development Note

### Copy MobileDevice.framework

EBIiOSDeviceWatcher use Apple's private framework MobileDevice.framework. If install from remote repo, automatically copy framework from local system by podspec prepare_command.

But CocoaPods not execute prepare_command in local podspecs. We need copy manually from `/System/Library/PrivateFrameworks/MobileDevice.framework` to `Project/Pods/EBIiOSDeviceWatcher`.

## License

GPLv3

- I learned some techniuques and copied MobileDevice.h from [ios-deploy](https://github.com/phonegap/ios-deploy).
    - Original MobileDevice.h mirrored in [here](https://github.com/svn2github/iphuc/blob/master/MobileDevice.h).