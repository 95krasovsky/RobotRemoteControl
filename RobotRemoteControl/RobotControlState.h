//
//  RobotControlState.h
//  RobotRemoteControl
//
//  Created by Admin on 4/1/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

 static const int ANGLE_DEFAULT = -1;
 static const int ANGLE_0_DEGREES = 0;
 static const int ANGLE_90_DEGREES = 90;
 static const int ANGLE_180_DEGREES = 180;
 static const int ANGLE_270_DEGREES = 270;
 static const int ANGLE_360_DEGREES = 360;

@interface RobotControlState : NSObject

+(void)setLinearVelocity:(int)linearVelocity;
+(int)linearVelocity;
+(void)setDefaultState;

+(int)rotationVelocity;
+(void)setRotationVelocity:(int)rotationVelocity;

@end
