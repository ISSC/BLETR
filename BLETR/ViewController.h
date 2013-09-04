//
//  ViewController.h
//  BLEDKAPP
//
//  Created by D500 user on 12/9/25.
//  Copyright (c) 2012 ISSC Technologies Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPeripheral.h"
#import "DataTransparentViewController.h"
#import "DeviceInfoViewController.h"
#import "ProprietaryViewController.h"

@interface ViewController : UIViewController//<MyPeripheralDelegate>
{
    

    UIBarButtonItem *disconnectButton;
}

@property(retain) MyPeripheral    *connectedPeripheral;
@property(retain) DataTransparentViewController *transparentPage;
@property(retain) DeviceInfoViewController *deviceInfoPage;
@property(retain) ProprietaryViewController *proprietaryPage;

- (IBAction)enterTransparentPage:(id)sender;
- (IBAction)enterProprietaryPage:(id)sender;
- (IBAction)enterDeviceInfoPage:(id)sender;
@end
