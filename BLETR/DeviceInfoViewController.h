//
//  DeviceInfoViewController.h
//  BLEDKAPP
//
//  Created by D500 user on 12/10/31.
//  Copyright (c) 2012 ISSC Technologies Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPeripheral.h"

@interface DeviceInfoViewController : UIViewController</*GAPControllerDelegate, */MyPeripheralDelegate>
{
    IBOutlet UILabel *deviceNameLabel;

    IBOutlet UILabel *manufactureNameLabel;
    
    IBOutlet UILabel *modelNumberLabel;
    IBOutlet UILabel *hardwareRevisionLabel;

    IBOutlet UILabel *softwareRevisionLabel;
    IBOutlet UILabel *firmwareRevisionLabel;
    IBOutlet UILabel *serialNumberLabel;
    IBOutlet UILabel *systemIdLabel;
    IBOutlet UILabel *regulatoryCertificationDataListLabel;
}

@property(retain) MyPeripheral *connectedPeripheral;
@end
