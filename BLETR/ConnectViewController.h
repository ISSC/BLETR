//
//  ConnectViewController.h
//  BLETR
//
//  Created by D500 user on 12/9/26.
//  Copyright (c) 2012 ISSC Technologies Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBController.h"
#import "ViewController.h"
#import "UUIDSettingViewController.h"
#import "DeviceInfo.h"

@interface ConnectViewController : CBController<UITableViewDataSource, UITextViewDelegate, UITableViewDelegate>
{
    IBOutlet UITableView *devicesTableView;
    UIActivityIndicatorView *activityIndicatorView;
    UILabel *statusLabel;
    UUIDSettingViewController *uuidSettingViewController;

    NSTimer *refreshDeviceListTimer;

    int connectionStatus;
    //Derek
    DeviceInfo *deviceInfo;
    MyPeripheral *controlPeripheral;
    NSMutableArray *connectedDeviceInfo;//stored for DeviceInfo object
    NSMutableArray *connectingList;//stored for MyPeripheral object
    
    UIBarButtonItem *refreshButton;
    UIBarButtonItem *scanButton;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *uuidSettingButton;
}
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, retain) IBOutlet UILabel *statusLabel;
@property (assign) int connectionStatus;
@property (retain, nonatomic) IBOutlet UILabel *versionLabel;

- (IBAction)refreshDeviceList:(id)sender;
- (IBAction)actionButtonCancelScan:(id)sender;
- (IBAction)manualUUIDSetting:(id)sender;
- (IBAction)actionButtonDisconnect:(id)sender;
- (IBAction)actionButtonCancelConnect:(id)sender;
@end
