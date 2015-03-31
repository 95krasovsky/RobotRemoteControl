//
//  ViewController.m
//  RobotRemoteControl
//
//  Created by Admin on 3/30/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "SetupViewController.h"

@interface SetupViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *robotIPTextField;
@property (weak, nonatomic) IBOutlet UITextField *cameraIPTextField;

@end

@implementation SetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.robotIPTextField.delegate = self;
    self.cameraIPTextField.delegate = self;

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




@end
