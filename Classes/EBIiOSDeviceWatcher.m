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
        
        __weak typeof(self) bself = self;
        [NSThread detachNewThreadWithBlock:^{
            NSLog(@"Watching thread start");
            
            bself.runLoop = CFRunLoopGetCurrent();
            
            AMDSetLogLevel(5);
            AMDeviceNotificationSubscribe(&EBIiOSDeviceWatcherDeviceNotificationCallback, 0, 0, (__bridge void *)(self), &_notif);
            
            [bself.mutableDevices removeAllObjects];
            dispatch_async(dispatch_get_main_queue(), ^{
                [bself.delegate iosDeviceWatcherStarted:bself];
            });
            
            CFRunLoopRun();
            NSLog(@"Watching thread stop");

            bself.runLoop = NULL;
            bself.active = NO;

            dispatch_async(dispatch_get_main_queue(), ^{
                [bself.delegate iosDeviceWatcherStopped:bself];
            });
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

