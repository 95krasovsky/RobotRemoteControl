//
//  ControlViewController.m
//  RobotRemoteControl
//
//  Created by Admin on 3/31/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "ControlViewController.h"
#import "ConnectionManager.h"
#import "RobotControlState.h"

@interface ControlViewController()

@property (nonatomic) dispatch_source_t timer;
@property (weak, nonatomic) IBOutlet UISlider *velocitySlider;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end


@implementation ControlViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    NSLog(@"load");
    
}

-(void)setRobotInfo:(RobotInfo *)robotInfo{
    self.title  = [NSString stringWithFormat:@"%@: %@", robotInfo.robotName, robotInfo.robotIP];
    _robotInfo = robotInfo;
    if (self.view.window) [self updateWebView];
    if ([ConnectionManager isWiFiConnected]){
        
    }else{
        
    }
}



-(void)viewWillAppear:(BOOL)animated{
    [self updateWebView];
    [RobotControlState setDefaultState];
    [self startTimer];
    
}

-(void)updateWebView{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", self.robotInfo.cameraIP]]];
    [self.webView loadRequest:request];
}

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


-(void)startTimer{
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,
                                            dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    
    double interval = 1;
    dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, 0);
    uint64_t intervalTime = (int64_t)(interval * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, startTime, intervalTime, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        [ConnectionManager sendUDPPacketToRobot:self.robotInfo];
    });
    
    dispatch_resume(self.timer);
}

-(void)resetTimer{
    dispatch_source_cancel(self.timer);
}


-(void)viewWillDisappear:(BOOL)animated{
    [self resetTimer];
}


@end
