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

