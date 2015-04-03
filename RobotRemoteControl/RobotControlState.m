//
//  RobotControlState.m
//  RobotRemoteControl
//
//  Created by Admin on 4/1/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "RobotControlState.h"

@implementation RobotControlState

static int currentAngle = 0;
static int currentVelocity = 0;

+(void)setAngle:(int)angle{
    currentAngle = angle;
}
+(void)setVelocity:(int)velocity{
    currentVelocity = velocity;
}

+(int)velocity{
    return currentVelocity;
}
+(int)angle{
    return currentAngle;
}

+(void)setDefaultState{
    currentAngle = ANGLE_DEFAULT;
    currentVelocity = 0;
}




@end
