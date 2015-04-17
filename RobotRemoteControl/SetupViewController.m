//
//  ViewController.m
//  RobotRemoteControl
//
//  Created by Admin on 3/30/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "SetupViewController.h"
#import "ControlViewController.h"
#import "RobotCommandGenerator.h"

@interface SetupViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *robotIPTextField;
@property (weak, nonatomic) IBOutlet UITextField *cameraIPTextField;

@end

@implementation SetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.robotIPTextField.delegate = self;
    self.cameraIPTextField.delegate = self;
    self.robotIPTextField.text = @"192.168.1.176";
    self.cameraIPTextField.text = @"admin:admin@192.168.1.175";
    //self.cameraIPTextField.text = @"www.google.com";


    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return  YES;
}


#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"Show the Control Screen"]){
        if ([segue.destinationViewController isKindOfClass:[ControlViewController class]]){
            ControlViewController *cvc = (ControlViewController *)segue.destinationViewController;
            RobotInfo *robotInfo = [[RobotInfo alloc] init];
            robotInfo.robotName = @"Richard";
            robotInfo.robotIP = self.robotIPTextField.text;
            robotInfo.cameraIP = self.cameraIPTextField.text;
            robotInfo.port = 2000;
            cvc.robotInfo = robotInfo;           
        }
    }
}



@end
