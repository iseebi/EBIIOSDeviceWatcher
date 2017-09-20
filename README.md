# EBIiOSDeviceWatcher

Observe iOSdevice connect/disconnect on macOS.

## How to use

```
self.watcher = [[EBIMobileDeviceWatcher alloc] init];
self.watcher.delegate = self;
[self.watcher startWatcing];
```

## License

GPLv3

- I learned some techniuques and copied MobileDevice.h from [ios-deploy](https://github.com/phonegap/ios-deploy).
    - Original MobileDevice.h mirrored in [here](https://github.com/svn2github/iphuc/blob/master/MobileDevice.h).