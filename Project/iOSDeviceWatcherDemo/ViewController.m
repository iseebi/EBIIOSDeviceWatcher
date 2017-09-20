//
//  ViewController.m
//  iOSDeviceWatcherDemo
//
//  Created by Nobuhiro Ito on 2017/09/19.
//  Copyright © 2017年 Nobuhiro Ito. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.watcher = [[EBIiOSDeviceWatcher alloc] init];
    self.watcher.delegate = self;
}

- (BOOL)watching
{
    return self.watcher.isActive;
}

- (void)setWatching:(BOOL)watching
{
    if (watching)
    {
        [self.watcher startWatching];
    }
    else
    {
        [self.watcher stopWatching];
    }
}

- (void)iosDeviceWatcherStarted:(EBIiOSDeviceWatcher *)watcher
{
    self.watching = self.watching;
}

- (void)iosDeviceWatcherStopped:(EBIiOSDeviceWatcher *)watcher
{
    self.watching = self.watching;
}

- (void)iosDeviceWatcher:(EBIiOSDeviceWatcher *)watcher didDiscoveredMobileDevice:(EBIiOSDevice *)device
{
    NSLog(@"Discovered: %@", device);
    [self.devicesArrayController rearrangeObjects];
}

- (void)iosDeviceWatcher:(EBIiOSDeviceWatcher *)watcher didDisconnectedMobileDevice:(EBIiOSDevice *)device
{
    NSLog(@"Terminated: %@", device);
    [self.devicesArrayController rearrangeObjects];
}

@end
