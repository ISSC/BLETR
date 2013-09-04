//
//  ViewController.m
//  BLEDKAPP
//
//  Created by D500 user on 12/9/25.
//  Copyright (c) 2012 ISSC Technologies Corporation. All rights reserved.
//
#import "AppDelegate.h"
#import "ViewController.h"



@interface ViewController ()

@end

@implementation ViewController
@synthesize connectedPeripheral;
@synthesize transparentPage;
@synthesize deviceInfoPage;
@synthesize proprietaryPage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       NSLog(@"initWithNibName for ViewController");
        if (transparentPage == nil)
            transparentPage = [[DataTransparentViewController alloc] init];
        transparentPage.connectedPeripheral = connectedPeripheral;
        transparentPage.connectedPeripheral.transDataDelegate = transparentPage;
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"[viewController] viewDidLoad");
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"Back";
    self.navigationItem.backBarButtonItem = backButton;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 28, 57, 57)];
    [titleLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Icon_old"]]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];//aaa
    self.navigationItem.titleView = titleLabel;
    [titleLabel release];
    self.navigationItem.leftBarButtonItem = disconnectButton;
    transparentPage = nil;
    deviceInfoPage = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"[viewController] viewDidAppear");
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[appDelegate navigationController] setToolbarHidden:YES animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
 //   NSLog(@"ViewController viewDidUnLoad");
}

- (void) dealloc {
    NSLog(@"[viewController] dealloc");
    if (transparentPage)
        [transparentPage release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    NSLog(@"[viewContrller] didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (IBAction)enterTransparentPage:(id)sender {
    NSLog(@"[viewContrller] enterTransparentPage");
    if (transparentPage == nil)
        transparentPage = [[DataTransparentViewController alloc] init];
    transparentPage.connectedPeripheral = connectedPeripheral;
    transparentPage.connectedPeripheral.transDataDelegate = transparentPage;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[appDelegate navigationController] pushViewController:transparentPage animated:YES];
}

- (IBAction)enterProprietaryPage:(id)sender {
    if (proprietaryPage == nil) {
        proprietaryPage = [[ProprietaryViewController alloc] initWithNibName:@"ProprietaryViewController" bundle:nil];
    }
    
    proprietaryPage.connectedPeripheral = self.connectedPeripheral;
    proprietaryPage.connectedPeripheral.proprietaryDelegate = proprietaryPage;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[appDelegate navigationController] pushViewController:proprietaryPage animated:YES];
}

- (IBAction)enterDeviceInfoPage:(id)sender {
    if (deviceInfoPage == nil) {
        deviceInfoPage = [[DeviceInfoViewController alloc] initWithNibName:@"DeviceInfoViewController" bundle:nil];
    }
    deviceInfoPage.connectedPeripheral = self.connectedPeripheral;
    deviceInfoPage.connectedPeripheral.deviceInfoDelegate = deviceInfoPage;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[appDelegate navigationController] pushViewController:deviceInfoPage animated:YES];
}

@end
