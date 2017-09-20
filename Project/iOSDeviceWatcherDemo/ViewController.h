//
//  ViewController.h
//  iOSDeviceWatcherDemo
//
//  Created by Nobuhiro Ito on 2017/09/19.
//  Copyright © 2017年 Nobuhiro Ito. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EBIiOSDeviceWatcher.h"

@interface ViewController : NSViewController<EBIiOSDeviceWatcherDelegate>

@property (strong) IBOutlet NSArrayController *devicesArrayController;

@property (nonatomic, strong) EBIiOSDeviceWatcher *watcher;

@property (nonatomic, assign) BOOL watching;

@end

