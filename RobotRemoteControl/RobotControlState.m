//
//  RobotControlState.m
//  RobotRemoteControl
//
//  Created by Admin on 4/1/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "RobotControlState.h"

@implementation RobotControlState

static int linearVelocity = 0;
static int rotationVelocity = 0;


+(void)setLinearVelocity:(int)velocity{
    linearVelocity = velocity;
}

+(int)linearVelocity{
    return linearVelocity;
}

+(void)setRotationVelocity:(int)velocity{
    rotationVelocity = velocity;
}

+(int)rotationVelocity{
    return rotationVelocity;
}

+(void)setDefaultState{
    linearVelocity = 0;
    rotationVelocity = 0;
}

@end
