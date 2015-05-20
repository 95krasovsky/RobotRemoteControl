//
//  RobotCommandHelper.m
//  RobotRemoteControl
//
//  Created by Admin on 4/1/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "RobotCommandGenerator.h"
#import "RobotControlState.h"
#define ROTATION_VELOCITY_FACTOR 0.8

@implementation RobotCommandGenerator

static const char extendedCharBuffer[] = {'$','0','0','0','0','0','0','0','0','-',
    '0','0','0','0','-','0','0','0','0','-',
    '0','0','0','0','-','0','0','0','0','0',
    '0','0','0','0','0','0','6','c','t','r',
    'l','$',0,0,(char)128,(char)128,(char)128,0,(char)128,0,
    '#'};
static const int size = 51;


/*
 char: -128..127
 
 when robot move forward, wheels rotate back:     slow  126...0  fast
 
 when robot move back, wheels rotate forward:     slow -127...-1 fast
 
 velocity: 0...100
 
 */
static const char MIN_FORWARD_POWER = 126;
static const char MAX_FORWARD_POWER = 0;
static const char MIN_BACK_POWER = -127;
static const char MAX_BACK_POWER = -1;
static const int MAX_VELOCITY = 100;


//+(int)getSize{
//    return sizeof(extendedCharBuffer);
//}

+(char) calculateForwardVelocity:(double) velocity {
    char value = MIN_FORWARD_POWER + (MAX_FORWARD_POWER-MIN_FORWARD_POWER)*(velocity/MAX_VELOCITY);
    return value;
}
+(char) calculateBackVelocity:(double) velocity {
    char value = MIN_BACK_POWER + (MAX_BACK_POWER-MIN_BACK_POWER)*(velocity/MAX_VELOCITY);
    return value;
}

//          up
//          100

//left 100      -100 right

//          -100
//          down
+(int)adjustWheelVelocity:(int)wheelVelocity{
    if (abs(wheelVelocity) <= MAX_VELOCITY){
        return wheelVelocity;
    } else{
        return (wheelVelocity >= 0) ? 100 : -100;
    }
}
+(char)calculateVelocity:(double) velocity {
    char value;
    if (velocity>0){
        value = MIN_FORWARD_POWER + (MAX_FORWARD_POWER-MIN_FORWARD_POWER)*(velocity/MAX_VELOCITY);
    } else{
        value = MIN_BACK_POWER + (MAX_BACK_POWER-MIN_BACK_POWER)*(-velocity/MAX_VELOCITY);
    }
    return value;
}

+(char*)generateCommand{
   
    int linearVelocity = [RobotControlState linearVelocity];
    int rotationVelocity = [RobotControlState rotationVelocity];
    rotationVelocity = rotationVelocity * ROTATION_VELOCITY_FACTOR;
    
    
    int rightWheelVelocity, leftWheelVelocity;
    if (linearVelocity>=0){
        rightWheelVelocity = linearVelocity + rotationVelocity;
        leftWheelVelocity = linearVelocity - rotationVelocity;
    } else{
        rightWheelVelocity = linearVelocity - rotationVelocity;
        leftWheelVelocity = linearVelocity + rotationVelocity;
    }

    rightWheelVelocity = [self adjustWheelVelocity:rightWheelVelocity];
    leftWheelVelocity = [self adjustWheelVelocity:leftWheelVelocity];
    
    NSLog(@"left: %d, right: %d", leftWheelVelocity, rightWheelVelocity);
    NSLog(@"linear: %d, rotation: %d", linearVelocity , rotationVelocity);
    
    char *resultBuffer = malloc(size);
    
    for (int i = 0; i < size; ++i)
    {
        resultBuffer[i] = extendedCharBuffer[i];
    }
    
    resultBuffer[45]=[self calculateVelocity:leftWheelVelocity];
    resultBuffer[48]=[self calculateVelocity:rightWheelVelocity];
    
    return resultBuffer;
}

@end
