// Copyright © 2017 Nobuhiro Ito
// This file is part of EBIiOSDeviceWatcher.
//
// EBIiOSDeviceWatcher is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License any later version.
//
// EBIiOSDeviceWatcher is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with EBIiOSDeviceWatcher.  If not, see <http://www.gnu.org/licenses/>.

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

