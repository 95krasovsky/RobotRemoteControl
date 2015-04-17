//
//  WiFiHelper.h
//  RobotRemoteControl
//
//  Created by Admin on 3/31/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RobotInfo.h"
@interface ConnectionManager : UIViewController

+(BOOL)isWiFiConnected;
+(void)sendUDPPacketToRobot:(RobotInfo *)robotInfo;

@end
