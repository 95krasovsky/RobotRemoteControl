//
//  JoystickControlViewController.m
//  RobotRemoteControl
//
//  Created by Admin on 4/3/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "JoystickControlViewController.h"
#import <UIKit/UIKit.h>

@interface JoystickControlViewController ()

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIAttachmentBehavior *attachment;
@property (strong, nonatomic) UICollisionBehavior *collision;
@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (weak, nonatomic) IBOutlet UIView *dropView;
//@property (weak, nonatomic) IBOutlet UIView *bigView;

@end

@implementation JoystickControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   
    NSLog(@"yFrame: %f; yBound: %f", self.dropView.frame.origin.y, self.dropView.bounds.origin.y);
    // Do any additional setup after loading the view.
}


-(UIDynamicAnimator *)animator{
    if (!_animator){
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return  _animator;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.collision = [[UICollisionBehavior alloc] initWithItems:@[self.dropView]];
    self.collision.translatesReferenceBoundsIntoBoundary = YES;
   // self.gravity = [[UIGravityBehavior alloc] initWithItems:@[self.dropView]];

    //[self.animator addBehavior:self.gravity];
    [self.animator addBehavior:self.collision];
    //[self.collision addBoundaryWithIdentifier:@"boundary" forPath:[UIBezierPath bezierPathWithOvalInRect:<#(CGRect)#>]];
}



//- (IBAction)pan:(UIPanGestureRecognizer *)sender {
//    CGPoint gesturePoint = [sender locationInView:self.view];
//    
//
//    if(sender.state == UIGestureRecognizerStateBegan){
//        self.attachment = [[UIAttachmentBehavior alloc] initWithItem:self.dropView attachedToAnchor:gesturePoint];
//        self.attachment.length = 0;
//        [self.animator addBehavior:self.attachment];
//        self.attachment.anchorPoint = gesturePoint;
//
//    }else if (sender.state == UIGestureRecognizerStateChanged){
//        self.attachment.anchorPoint = gesturePoint;
//    }else if (sender.state == UIGestureRecognizerStateEnded){
//        [self.animator removeBehavior:self.attachment];
//    }
//
//}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint gesturePoint = [touch locationInView:self.view];

    self.attachment = [[UIAttachmentBehavior alloc] initWithItem:self.dropView attachedToAnchor:gesturePoint];
    [self.animator addBehavior:self.attachment];
    self.attachment.anchorPoint = gesturePoint;
    self.attachment.length = 0;


    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    


    // If the touch was in the placardView, move the placardView to its location
//    if ([touch view] == self.dropView) {
//        CGPoint location = [touch locationInView:self.view];
//        self.dropView.center = location;
//        [self.animator updateItemUsingCurrentState:self.dropView];
//        return;
//    }
}



@end
