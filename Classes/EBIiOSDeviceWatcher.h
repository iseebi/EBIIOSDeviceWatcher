//
//  EBIiOSDeviceWatcher.h
//  EBIiOSDeviceWatcher
//
//  Created by Nobuhiro Ito on 2017/01/06.
//  Copyright © 2017 Nobuhiro Ito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EBIiOSDevice.h"

@class EBIiOSDeviceWatcher;

@protocol EBIiOSDeviceWatcherDelegate <NSObject>

    - (void) iosDeviceWatcherStarted:(EBIiOSDeviceWatcher *)watcher;
    - (void) iosDeviceWatcherStopped:(EBIiOSDeviceWatcher *)watcher;

    - (void) iosDeviceWatcher:(EBIiOSDeviceWatcher *)watcher
       didDiscoveredMobileDevice:(EBIiOSDevice *)device;

    - (void) iosDeviceWatcher:(EBIiOSDeviceWatcher *)watcher
     didDisconnectedMobileDevice:(EBIiOSDevice *)device;

@end


@interface EBIiOSDeviceWatcher : NSObject

    @property (weak) id<EBIiOSDeviceWatcherDelegate> delegate;
    @property (readonly) NSArray<EBIiOSDevice *> *devices;
    @property (readonly, getter=isActive) BOOL active;

    @property (assign) BOOL allowWifi;
    
    - (void) startWatching;
    - (void) stopWatching;
    
@end

