//
//  EBIMobileDevice.m
//  EBIMobileDeviceWatcher
//
//  Created by Nobuhiro Ito on 2017/01/06.
//  Copyright © 2017 Nobuhiro Ito. All rights reserved.
//

#import "EBIiOSDevice.h"
#include "MobileDevice.h"

@implementation EBIiOSDevice

- (instancetype) initWithUDID:(NSString *)UDID name:(NSString *)name model:(NSString *)model
{
    self = [super init];
    if (self)
    {
        _UDID = UDID;
        _name = name;
        _model = model;
    }
    return self;
}

/*
- (instancetype) initWithAMDevice:(am_device *)device {
    self = [super init];
    if (self)
    {
        AMDeviceConnect(device);
        _UDID = (__bridge NSString *) AMDeviceCopyDeviceIdentifier(device);
        _name = (__bridge NSString *) AMDeviceCopyValue(device, 0, CFSTR("DeviceName"));
        _model = (__bridge NSString *)  AMDeviceCopyValue(device, 0, CFSTR("HardwareModel"));
        AMDeviceDisconnect(device);
    }
    return self;
}
 */

- (NSString *)description
{
    return [NSString stringWithFormat:@"[iOSDevice(%@) model:%@ UDID:%@]", self.name, self.model, self.UDID ];
}

-(BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[EBIiOSDevice class]])
    {
        return false;
    }
    __typeof(self) other = object;
    return ([self.UDID isEqualToString:other.UDID]);
}

-(NSUInteger)hash
{
    return [self.UDID hash];
}

@end

