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
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *velocityLabel;
@property (strong, nonatomic) NSTimer *imageTimer;
@property (strong, nonatomic) NSDate *currentImageDate ;
@end


@implementation ControlViewController


-(void)viewDidLoad{
    [super viewDidLoad];

    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
   // UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://hdwallpaperd.com/wp-content/uploads/Hd-Widescreen-Wallpapers-For-Desktop1.jpg"]]] ;
    //NSLog(@"hop");
}

-(void)setRobotInfo:(RobotInfo *)robotInfo{
    self.title  = [NSString stringWithFormat:@"%@: %@", robotInfo.robotName, robotInfo.robotIP];
    _robotInfo = robotInfo;
    if ([ConnectionManager isWiFiConnected]){
        
    }else{
        
    }
}

- (void)tap:(UITapGestureRecognizer *)sender {
    if (!self.velocityLabel.hidden){
        [UIView animateWithDuration:0.8
                         animations:^{
                             self.velocityLabel.alpha = 0;
                             self.velocitySlider.alpha = 0;;
                         } completion:^(BOOL finished) {
                             self.velocityLabel.hidden = YES;
                             self.velocitySlider.hidden = YES;
                         }];
        
    }else{
        self.velocityLabel.hidden = NO;
        self.velocitySlider.hidden = NO;
        [UIView animateWithDuration:0.8
                         animations:^{
                             self.velocityLabel.alpha = 1;
                             self.velocitySlider.alpha = 1;;
                         }];
    }
}



-(void)viewWillAppear:(BOOL)animated{
    [RobotControlState setDefaultState];
    [self startTimer];
 //   [self startImageTimer];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [self resetTimer];
    
}

-(void)startImageTimer{
    self.imageTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                       target:self
                                                     selector:@selector(updateImage:)
                                                     userInfo:[NSDate date]
                                                      repeats:YES];
}

-(void)updateImage:(NSTimer *)timer{
    NSDate *date = [timer userInfo];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://admin:admin@192.168.1.175/jpg/image.jpg"]]] ;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
            NSLog(@"image downloaded");
        });
    });
    
}


-(void)startTimer{
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,
                                            dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    double interval = 0.5;
    dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, 0);
    uint64_t intervalTime = (int64_t)(interval * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, startTime, intervalTime, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        [ConnectionManager sendUDPPacketToRobot:self.robotInfo];
        //[self updateImage];
    });
    
    dispatch_resume(self.timer);
}

-(void)resetTimer{
    dispatch_source_cancel(self.timer);
}

-(void)updateImage{
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://admin:admin@192.168.1.175/jpg/image.jpg"]]] ;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.image = image;
        NSLog(@"image downloaded");
    });
}



@end
