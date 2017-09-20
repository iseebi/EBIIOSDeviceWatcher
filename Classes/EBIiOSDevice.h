//
//  EBIMobileDevice.h
//  EBIMobileDeviceWatcher
//
//  Created by Nobuhiro Ito on 2017/01/06.
//  Copyright © 2017 Nobuhiro Ito. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBIiOSDevice : NSObject

    @property (readonly) NSString* UDID;
    @property (readonly) NSString* name;
    @property (readonly) NSString* model;

    - (instancetype) initWithUDID:(NSString *)UDID name:(NSString *)name model:(NSString *)model;
@end
