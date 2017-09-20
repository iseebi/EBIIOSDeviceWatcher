//
//  EBIiOSDeviceWatcher.m
//  EBIiOSDeviceWatcher
//
//  Created by Nobuhiro Ito on 2017/01/06.
//  Copyright © 2017 Nobuhiro Ito. All rights reserved.
//

#import "EBIiOSDeviceWatcher.h"
#include <CoreFoundation/CoreFoundation.h>
#include "MobileDevice.h"

@interface EBIiOSDeviceWatcher ()
    
    @property (readonly) NSMutableArray<EBIiOSDevice *> *mutableDevices;
    
    @property (readwrite) BOOL active;
    @property (assign) CFRunLoopRef runLoop;
    @property (assign) am_device_notification *notif;

    - (void) onDeviceNotificationCallback:(am_device_notification_callback_info *)info;

@end

void EBIiOSDeviceWatcherDeviceNotificationCallback(struct am_device_notification_callback_info *info, void *refcon)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [(__bridge EBIiOSDeviceWatcher *)refcon onDeviceNotificationCallback:info];
    });
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
        
        __weak typeof(self) bself = self;
        [NSThread detachNewThreadWithBlock:^{
            NSLog(@"Watching thread start");
            
            bself.runLoop = CFRunLoopGetCurrent();
            
            AMDeviceNotificationSubscribe(&EBIiOSDeviceWatcherDeviceNotificationCallback, 0, 0, (__bridge void *)(self), &_notif);
            
            [bself.mutableDevices removeAllObjects];
            [bself.delegate iosDeviceWatcherStarted:bself];
            
            CFRunLoopRun();
            NSLog(@"Watching thread stop");

            bself.runLoop = NULL;
            bself.active = NO;

            [bself.delegate iosDeviceWatcherStopped:bself];
        }];
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
                EBIiOSDevice *device = [self detectDevice:info->dev];
                NSLog(@"Connected %@", device);
                break;
            }
            case ADNCI_MSG_DISCONNECTED: {
                EBIiOSDevice *device = [self detectDevice:info->dev];
                NSLog(@"Disconnected %@", device);
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
        
        [self.mutableDevices addObject:device];
        [self.delegate iosDeviceWatcher:self didDiscoveredMobileDevice:device];
    }

    - (void) onTerminatedDevice:(EBIiOSDevice *)device
    {
        if (device == nil) { return; }
        
        NSUInteger index = [self.mutableDevices indexOfObject:device];
        if (index == NSNotFound) { return; }
        
        EBIiOSDevice *disconnectDevice = [self.mutableDevices objectAtIndex:index];
        [self.mutableDevices removeObjectAtIndex:index];
        [self.delegate iosDeviceWatcher:self didDisconnectedMobileDevice:disconnectDevice];
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

