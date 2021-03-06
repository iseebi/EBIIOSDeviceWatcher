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

#import "EBIiOSDeviceWatcher.h"
#include <CoreFoundation/CoreFoundation.h>
#include "MobileDevice.h"

@interface EBIiOSDeviceWatcher ()
    
    @property (readonly) NSMutableArray<EBIiOSDevice *> *mutableDevices;
    
    @property (readwrite) BOOL active;
    @property (assign) CFRunLoopRef runLoop;
    @property (assign) am_device_notification *notif;
    @property NSThread *runningThread;

    - (void) onDeviceNotificationCallback:(am_device_notification_callback_info *)info;

@end

void EBIiOSDeviceWatcherDeviceNotificationCallback(struct am_device_notification_callback_info *info, void *refcon)
{
    [(__bridge EBIiOSDeviceWatcher *)refcon onDeviceNotificationCallback:info];
}

@implementation EBIiOSDeviceWatcher
    
    - (instancetype)init
    {
        self = [super init];
        if (self)
        {
            _mutableDevices = [NSMutableArray array];
            _devices = _mutableDevices;
        }
        return self;
    }
    
    - (void)dealloc
    {
        [self stopWatching];
    }

    //--------------------------------------------------------------------------------
    #pragma mark Waiting notification
    //--------------------------------------------------------------------------------

    -(void)startWatching
    {
        if (self.isActive)
        {
            return;
        }
        
        self.active = YES;
        
        self.runningThread = [[NSThread alloc] initWithTarget:self selector:@selector(watchingThreadAction) object:nil];
        [self.runningThread start];
    }

    - (void) watchingThreadAction
    {
        NSLog(@"Watching thread start");
        __weak typeof(self) bself = self;

        self.runLoop = CFRunLoopGetCurrent();

        AMDSetLogLevel(5);
        AMDeviceNotificationSubscribe(&EBIiOSDeviceWatcherDeviceNotificationCallback, 0, 0, (__bridge void *)(self), &_notif);

        [self.mutableDevices removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate iosDeviceWatcherStarted:bself];
        });

        CFRunLoopRun();
        NSLog(@"Watching thread stop");

        self.runLoop = NULL;
        self.active = NO;
        self.runningThread = nil;

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate iosDeviceWatcherStopped:bself];
        });
    }

    - (void)stopWatching
    {
        if (!self.isActive)
        {
            return;
        }

        CFRunLoopStop(self.runLoop);
    }
    
    - (void) onDeviceNotificationCallback:(am_device_notification_callback_info *)info;
    {
        switch (info->msg) {
            case ADNCI_MSG_CONNECTED: {
                // skip wifi device
                if (!self.allowWifi && (AMDeviceGetInterfaceType(info->dev) == 2)) { return; }
                
                EBIiOSDevice *device = [self detectDevice:info->dev];
                [self onMatchedDevice:device];
                break;
            }
            case ADNCI_MSG_DISCONNECTED: {
                EBIiOSDevice *device = [self detectDevice:info->dev];
                [self onTerminatedDevice:device];
                break;
            }
            default:
                break;
        }
    }
    
    - (void) onMatchedDevice:(EBIiOSDevice *)device
    {
        if (device == nil) { return; }
        
        NSUInteger index = [self.mutableDevices indexOfObject:device];
        if (index != NSNotFound) { return; }
        
        __weak typeof(self) bself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [bself.mutableDevices addObject:device];
            [bself.delegate iosDeviceWatcher:self didDiscoveredMobileDevice:device];
        });
    }

    - (void) onTerminatedDevice:(EBIiOSDevice *)device
    {
        if (device == nil) { return; }
        
        NSUInteger index = [self.mutableDevices indexOfObject:device];
        if (index == NSNotFound) { return; }

        __weak typeof(self) bself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            EBIiOSDevice *disconnectDevice = [self.mutableDevices objectAtIndex:index];
            [bself.mutableDevices removeObjectAtIndex:index];
            [bself.delegate iosDeviceWatcher:self didDisconnectedMobileDevice:disconnectDevice];
        });
    }
    
    //--------------------------------------------------------------------------------
    #pragma mark Device validations
    //--------------------------------------------------------------------------------

    - (EBIiOSDevice *) detectDevice:(am_device *)amDevice
    {
        NSString *UDID = (__bridge NSString *) AMDeviceCopyDeviceIdentifier(amDevice);
        AMDeviceConnect(amDevice);
        NSString *name = (__bridge NSString *) AMDeviceCopyValue(amDevice, 0, CFSTR("DeviceName"));
        NSString *model = (__bridge NSString *)  AMDeviceCopyValue(amDevice, 0, CFSTR("HardwareModel"));
        AMDeviceDisconnect(amDevice);
        return [[EBIiOSDevice alloc] initWithUDID:UDID name:name model:model];
    }

@end

