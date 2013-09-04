//
//  UUIDSettingViewController.h
//  BLETR
//
//  Created by D500 user on 13/6/14.
//  Copyright (c) 2013年 ISSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUIDSettingViewController : UIViewController<UITextFieldDelegate>
{

}
- (IBAction)applySetting:(id)sender;
- (IBAction)resetSetting:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *serviceUUID;
@property (retain, nonatomic) IBOutlet UITextField *txUUID;
@property (retain, nonatomic) IBOutlet UITextField *rxUUID;
@property (retain, nonatomic) NSString *transServiceUUIDStr;
@property (retain, nonatomic) NSString *transTxUUIDStr;
@property (retain, nonatomic) NSString *transRxUUIDStr;
@property (assign, nonatomic) BOOL isUUIDAvailable;
@end
