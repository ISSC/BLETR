//
//  ProprietaryViewController.m
//  BLEDKAPP
//
//  Created by D500 user on 12/11/21.
//  Copyright (c) 2012 ISSC Technologies Corporation. All rights reserved.
//
#import "AppDelegate.h"
#import "ProprietaryViewController.h"

@interface ProprietaryViewController ()

@end

@implementation ProprietaryViewController
@synthesize connectedPeripheral;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"Back";
    self.navigationItem.backBarButtonItem = backButton;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 28, 57, 57)];
    [titleLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Icon_old"]]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];//aaa
    self.navigationItem.titleView = titleLabel;
    [titleLabel release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    NSLog(@"[ProprietaryViewcontroller] didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)setConnectionParameters {
    [maxConnectionIntervalText resignFirstResponder];
    [connectionTimeoutText resignFirstResponder];
    [latencyText resignFirstResponder];
    int maxInterval = [[maxConnectionIntervalText text] intValue];
    int connectionTimeout = [[connectionTimeoutText text] intValue];
    int connectionLatency = [[latencyText text] intValue];
    
    NSError *error = [connectedPeripheral setMaxConnectionInterval:maxInterval connectionTimeout:connectionTimeout connectionLatency:connectionLatency];
    if (error !=nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"parameters error"  message:[error domain] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
    }
    [connectionParameterStatusLabel setText:[[NSString alloc] initWithString:@"Processing"]];
}

- (IBAction)updateConnectionParameter:(id)sender {
    [connectedPeripheral checkIsAllowUpdateConnectionParameter];
}

- (IBAction)changeDeviceName:(id)sender {
    [deviceNameText resignFirstResponder];
    if ([[deviceNameText text] length]==0) {
        [connectionParameterStatusLabel setText:[[NSString alloc] initWithString:@"No Process"]];
        return;
    }
    [connectedPeripheral changePeripheralName:[deviceNameText text]];
    [connectionParameterStatusLabel setText:[[NSString alloc] initWithString:@"Processing"]];
}

- (void)dealloc {
    NSLog(@"[ProprietaryViewController] dealloc");
    [maxConnectionIntervalText release];
    [connectionTimeoutText release];
    [connectionParameterStatusLabel release];
    [latencyText release];
    [deviceNameText release];
    [super dealloc];
}
- (void)viewDidUnload {
    NSLog(@"[ProprietaryViewController] viewDidUnload");
    [maxConnectionIntervalText release];
    maxConnectionIntervalText = nil;
    [connectionTimeoutText release];
    connectionTimeoutText = nil;
    [connectionParameterStatusLabel release];
    connectionParameterStatusLabel = nil;
    [latencyText release];
    latencyText = nil;
    [deviceNameText release];
    deviceNameText = nil;
    [super viewDidUnload];
}

- (void)MyPeripheral:(MyPeripheral *)peripheral didUpdateConnectionParameterAllowStatus:(BOOL)status {
    if (status) {
        [self setConnectionParameters];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Not Available"  message:@"Peripheral is not available to update connection parameters at this moment! Please retry it later!" delegate:self cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
    }
}

- (void)MyPeripheral:(MyPeripheral *)peripheral didUpdateConnectionParameterStatus:(BOOL)status interval:(unsigned short)interval timeout:(unsigned short)timeout  latency:(unsigned short)latency{
    NSLog(@"didUpdateConnectionParameterStatus, status=%d, interval=%d, timeout=%d, latency=%d", status, interval, timeout,latency);
    [connectionParameterStatusLabel setText:[[NSString alloc] initWithFormat:@"status=%@, interval=%dms, timeout=%dms, latency=%d", status? @"Success": @"No Change", interval, timeout,latency]];
}

- (void)MyPeripheral:(MyPeripheral *)peripheral didChangePeripheralName:(NSError *)error {
    NSLog(@"didChangePeripheralName, error=%@", error);
    [connectionParameterStatusLabel setText:[[NSString alloc] initWithString:@"Change name success!"]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 16) ? NO : YES;
}
@end
