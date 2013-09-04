//
//  ProprietaryViewController.h
//  BLEDKAPP
//
//  Created by D500 user on 12/11/21.
//  Copyright (c) 2012 ISSC Technologies Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPeripheral.h"

@interface ProprietaryViewController : UIViewController <MyPeripheralDelegate, UITextFieldDelegate>
{
    
    IBOutlet UILabel *latencyText;
    IBOutlet UITextField *deviceNameText;
    IBOutlet UITextField *connectionTimeoutText;
    IBOutlet UITextField *maxConnectionIntervalText;
    IBOutlet UILabel *connectionParameterStatusLabel;
}

@property(retain) MyPeripheral *connectedPeripheral;
- (IBAction)updateConnectionParameter:(id)sender;
- (IBAction)changeDeviceName:(id)sender;
- (void)setConnectionParameters;
@end
