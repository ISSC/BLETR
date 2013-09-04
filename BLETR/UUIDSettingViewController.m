//
//  UUIDSettingViewController.m
//  BLETR
//
//  Created by D500 user on 13/6/14.
//  Copyright (c) 2013年 ISSC. All rights reserved.
//

#import "UUIDSettingViewController.h"
#import "AppDelegate.h"

@interface UUIDSettingViewController ()

@end

@implementation UUIDSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.transServiceUUIDStr = nil;
        self.transTxUUIDStr = nil;
        self.transRxUUIDStr = nil;
        self.isUUIDAvailable = FALSE;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"[UUIDSettingViewController] textFieldShouldReturn");

    
    return TRUE;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSCharacterSet *unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890aAbBcCdDeEfF"] invertedSet];
    if ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] > 1)
        return NO;
    else {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 4) ? NO : YES;
    }
}
- (void)dealloc {
    [_serviceUUID release];
    [_txUUID release];
    [_rxUUID release];
    if (self.transServiceUUIDStr)
        [self.transServiceUUIDStr release];
    if (self.transTxUUIDStr)
        [self.transTxUUIDStr release];
    if (self.transRxUUIDStr)
        [self.transRxUUIDStr release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setServiceUUID:nil];
    [self setTxUUID:nil];
    [self setRxUUID:nil];
    [super viewDidUnload];
}
- (IBAction)applySetting:(id)sender {

    if (([[self.serviceUUID text] length] != 4) || ([[self.txUUID text] length] != 4) || ([[self.rxUUID text] length] != 4)) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Invalid UUID Setting" message:@"UUID must match 16-bit format" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        return;
    }
    if (self.transServiceUUIDStr)
        [self.transServiceUUIDStr release];
    if (self.transTxUUIDStr)
        [self.transTxUUIDStr release];
    if (self.transRxUUIDStr)
        [self.transRxUUIDStr release];
    self.transServiceUUIDStr = [[NSString alloc] initWithString:[self.serviceUUID text]];
    self.transTxUUIDStr = [[NSString alloc] initWithString:[self.txUUID text]];
    self.transRxUUIDStr = [[NSString alloc] initWithString:[self.rxUUID text]];
    self.isUUIDAvailable = TRUE;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[appDelegate navigationController] popToRootViewControllerAnimated:YES];
}

- (IBAction)resetSetting:(id)sender {
    self.isUUIDAvailable = FALSE;
    [self.serviceUUID setText:@""];
    [self.txUUID setText:@""];
    [self.rxUUID setText:@""];
}
@end
