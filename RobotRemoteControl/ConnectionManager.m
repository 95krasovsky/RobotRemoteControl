//
//  WiFiHelper.m
//  RobotRemoteControl
//
//  Created by Admin on 3/31/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "ConnectionManager.h"
#import "GCDAsyncUdpSocket.h"
#import "RobotCommandGenerator.h"

@implementation ConnectionManager

+(BOOL)isWiFiConnected{
    return YES;
}


+(void)sendUDPPacketToRobot:(RobotInfo *)robotInfo{
    GCDAsyncUdpSocket *socket = [[GCDAsyncUdpSocket alloc] init];
    char *buffer = [RobotCommandGenerator generateCommand];
    
    NSData *data = [NSData dataWithBytes:buffer length:51];    
    [socket sendData:data toHost:robotInfo.robotIP port:robotInfo.port withTimeout:-1 tag:0];

    [socket closeAfterSending];
}



@end
