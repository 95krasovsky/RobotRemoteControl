//
//  RobotCommandHelper.m
//  RobotRemoteControl
//
//  Created by Admin on 4/1/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "RobotCommandGenerator.h"
#import "RobotControlState.h"
//#import "math.h"

@implementation RobotCommandGenerator

static const char extendedCharBuffer[] = {'$','0','0','0','0','0','0','0','0','-',
    '0','0','0','0','-','0','0','0','0','-',
    '0','0','0','0','-','0','0','0','0','0',
    '0','0','0','0','0','1','4','c','t','r',
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

static const char directRobotPowerValues[] = {(char)142,(char)156,(char)170,(char)184, (char)198, (char)212,(char)226,(char)240,(char)255};
static const int directRobotPowerValueslength = 9;

static const char inDirectRobotPowerValues[] = {(char)112,(char)98,(char)84,(char)70,(char)56,(char)42,(char)28,(char)14,(char)0};
static const int inDirectRobotPowerValueslength = 9;



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

+(int) calculateDirectPowerValueIndex:(int) velocity {
    int value = 0;
    value = (int) floor((velocity * 128 / 100) / (128 / (directRobotPowerValueslength - 1)));
    //NSLog(@"velocity: %i; direct value: %i", velocity, value);
    return value;
}

+(int) calculateInDirectPowerValueIndex:(int) velocity {
    int value = 0;
    value = (int) floor((velocity * 128 / 100) / (128 / (inDirectRobotPowerValueslength - 1)));
    //NSLog(@"velocity: %i; direct value: %i", velocity, value);

    return value;
}

+(int) calculateProjectionX:(int) power
                      angle:(int) angle {
    int num = (int) (power * cos(angle));
    if(num < 0) {
        return 0;
    }
    return num;
}

+(int) calculateProjectionY:(int) power
                      angle:(int) angle {
    
    int num = (int)(power * cos(90.0 - angle));
    if(num < 0) {
        return 0;
    }
    return num;
}

+(char*)generateCommand{
    int currentAngle = [RobotControlState angle];
    int currentVelocity = [RobotControlState velocity];
    

    char *resultBuffer = malloc(size);

    for (int i = 0; i < size; ++i)
    {
        resultBuffer[i] = extendedCharBuffer[i];
    }
    
    NSString *command;
    //[45] - left wheels
    //[48] - right wheels
    if (currentVelocity > 0 && currentAngle != ANGLE_DEFAULT) {
        if (currentAngle == ANGLE_0_DEGREES) {
            command = @"STRAIGHT";
            resultBuffer[45]=[self calculateForwardVelocity:currentVelocity];
            resultBuffer[48]=[self calculateForwardVelocity:currentVelocity];
        } else if (currentAngle == ANGLE_90_DEGREES) {
            command = @"RIGHT";
            resultBuffer[45]=[self calculateForwardVelocity:currentVelocity];
            resultBuffer[48]=[self calculateBackVelocity:currentVelocity];

            
        } else if (currentAngle == ANGLE_180_DEGREES) {
            command = @"BACK";
            resultBuffer[45]=[self calculateBackVelocity:currentVelocity];
            resultBuffer[48]=[self calculateBackVelocity:currentVelocity];
            
        } else if (currentAngle == ANGLE_270_DEGREES) {
            command = @"LEFT";
            resultBuffer[45]=[self calculateBackVelocity:currentVelocity];
            resultBuffer[48]=[self calculateForwardVelocity:currentVelocity];
            
        } else if(currentAngle > ANGLE_0_DEGREES && currentAngle < ANGLE_90_DEGREES) {
            resultBuffer[45] = (char) inDirectRobotPowerValues[[self calculateInDirectPowerValueIndex:[self calculateProjectionY:currentVelocity angle:currentAngle]]];
            resultBuffer[48] = (char) directRobotPowerValues[[self calculateDirectPowerValueIndex:[self calculateProjectionX:currentVelocity angle:currentAngle]]];
        } else if(currentAngle > ANGLE_90_DEGREES && currentAngle < ANGLE_180_DEGREES) {
            resultBuffer[45] = (char) inDirectRobotPowerValues[[self calculateInDirectPowerValueIndex:[self calculateProjectionX:currentVelocity angle:currentAngle]]];
            resultBuffer[48] = (char) directRobotPowerValues[[self calculateDirectPowerValueIndex:[self calculateProjectionY:currentVelocity angle:currentAngle]]];
        } else if(currentAngle > ANGLE_180_DEGREES && currentAngle < ANGLE_270_DEGREES) {
           // Log.e("log", " " + calculateDirectPowerValueIndex(calculateProjectionX(currentVelocity, currentAngle)));
           // Log.e("log", " " + calculateInDirectPowerValueIndex(calculateProjectionY(currentVelocity, currentAngle)));
            resultBuffer[45] = (char) directRobotPowerValues[[self calculateDirectPowerValueIndex:[self calculateProjectionX:currentVelocity angle:currentAngle]]];
            resultBuffer[48] = (char) inDirectRobotPowerValues[[self calculateInDirectPowerValueIndex:[self calculateProjectionY:currentVelocity angle:currentAngle]]];
        } else if(currentAngle > ANGLE_270_DEGREES && currentAngle < ANGLE_360_DEGREES) {
            resultBuffer[45] = (char) directRobotPowerValues[[self calculateDirectPowerValueIndex:[self calculateProjectionY:currentVelocity angle:currentAngle]]];
            resultBuffer[48] = (char) inDirectRobotPowerValues[[self calculateInDirectPowerValueIndex:[self calculateProjectionX:currentVelocity angle:currentAngle]]];
        }
        command = [command stringByAppendingString:[NSString stringWithFormat:@": %d", currentVelocity]];
    }else{
        command = [NSString stringWithFormat:@"STOP: %d", currentVelocity];
    }
    
    //NSLog(@"%@", command);
        return resultBuffer;
}

@end