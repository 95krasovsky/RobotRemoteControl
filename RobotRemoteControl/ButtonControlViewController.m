//
//  ButtonControlViewController.m
//  RobotRemoteControl
//
//  Created by Vlad on 4/17/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "ButtonControlViewController.h"
#import "RobotControlState.h"

@interface ButtonControlViewController ()

@end

@implementation ButtonControlViewController



- (IBAction)btnDown:(UIButton *)sender {
    switch (sender.tag) {
        case 0: //up
            [RobotControlState setAngle:ANGLE_0_DEGREES];
            break;
        case 1: //right
            [RobotControlState setAngle:ANGLE_90_DEGREES];
            break;
        case 2: //down
            [RobotControlState setAngle:ANGLE_180_DEGREES];
            break;
        case 3: //left
            [RobotControlState setAngle:ANGLE_270_DEGREES];
            break;
        default:
            break;
    }
    [RobotControlState setVelocity:self.velocitySlider.value];
}

- (IBAction)btnUp:(UIButton *)sender {
    [RobotControlState setDefaultState];
}

@end
