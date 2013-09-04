//
//  DeviceInfo.m
//  BLETR
//
//  Created by d500_MacMini on 13/6/19.
//  Copyright (c) 2013年 ISSC. All rights reserved.
//

#import "DeviceInfo.h"

@implementation DeviceInfo

@synthesize myPeripheral;
@synthesize mainViewController;

- (id)init {
    self = [super init];
    if (self) {
        mainViewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    }
    return self;
}

- (void)dealloc {
    [mainViewController release];
    [myPeripheral release];
    [super dealloc];
}

@end
