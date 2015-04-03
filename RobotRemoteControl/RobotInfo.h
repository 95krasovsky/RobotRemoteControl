//
//  RobotInfo.h
//  RobotRemoteControl
//
//  Created by Admin on 4/1/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RobotInfo : NSObject

@property (strong, nonatomic) NSString *robotName;
@property (strong, nonatomic) NSString *robotIP;
@property (strong, nonatomic) NSString *cameraIP;
@property (nonatomic) NSUInteger port;

@end
