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
    float velocity = self.velocitySlider.value;
    switch (sender.tag) {
        case 0: //up
          //  [RobotControlState setAngle:ANGLE_0_DEGREES];
            [RobotControlState setLinearVelocity:velocity];
            break;
        case 1: //right
            [RobotControlState setRotationVelocity:-velocity];
            break;
        case 2: //down
            [RobotControlState setLinearVelocity:-velocity];
            break;
        case 3: //left
            [RobotControlState setRotationVelocity:velocity];
            break;
        default:
            break;
    }
    
//    [RobotControlState setLinearVelocity:self.velocitySlider.value];
}

- (IBAction)btnUp:(UIButton *)sender {
    [RobotControlState setDefaultState];
}

@end
