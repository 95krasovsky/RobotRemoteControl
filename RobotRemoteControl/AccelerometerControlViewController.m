//
//  AccelerometerControlViewController.m
//  RobotRemoteControl
//
//  Created by Vlad on 4/17/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "AccelerometerControlViewController.h"
#import "RobotControlState.h"
#import <CoreMotion/CoreMotion.h>

#define MAX_ANGLE 50
#define MIN_ANGLE 5

@interface AccelerometerControlViewController ()

@property (strong, nonatomic) CMMotionManager *motionManager;
@property (weak, nonatomic) IBOutlet UIButton *motionButton;

@end




@implementation AccelerometerControlViewController


-(CMMotionManager *)motionManager{
    if (!_motionManager){
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.accelerometerUpdateInterval = 0.1f;
    }
   
    return _motionManager;
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.motionManager.isAccelerometerActive){
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue]
                                                 withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                     float x = accelerometerData.acceleration.x;
                                                     float y = accelerometerData.acceleration.y;
                                                     float angle = atan(y/-x)/M_PI*180;
                                                     [self updateRobotState:angle];
                                                 }];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.motionManager.isAccelerometerActive){
        [self.motionManager stopAccelerometerUpdates];
    }
}


-(void)updateRobotState:(float)angle{
    if (fabsf(angle)<=MAX_ANGLE && fabs(angle)>=MIN_ANGLE){
        [RobotControlState setRotationVelocity:angle/MAX_ANGLE*100];
    } else if(fabs(angle)<MIN_ANGLE){
        [RobotControlState setRotationVelocity:0];
    }
}

- (IBAction)motionButtonDown:(UIButton *)sender {
    [RobotControlState setLinearVelocity:self.velocitySlider.value];
}

- (IBAction)motionButtonUp:(UIButton *)sender {
    [RobotControlState setLinearVelocity:0];
}




@end
