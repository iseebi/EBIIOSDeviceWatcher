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

@interface EBIiOSDevice : NSObject

    @property (readonly) NSString* UDID;
    @property (readonly) NSString* name;
    @property (readonly) NSString* model;

    - (instancetype) initWithUDID:(NSString *)UDID name:(NSString *)name model:(NSString *)model;
@end
