//
//  DeviceInfoViewController.m
//  BLEDKAPP
//
//  Created by D500 user on 12/10/31.
//  Copyright (c) 2012 ISSC Technologies Corporation. All rights reserved.
//

#import "DeviceInfoViewController.h"

@interface DeviceInfoViewController ()

@end

@implementation DeviceInfoViewController
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
    NSLog(@"[DeviceInfoViewController] viewDidLoad");
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"Back";
    self.navigationItem.backBarButtonItem = backButton;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 28, 57, 57)];
    [titleLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Icon_old"]]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];//aaa
    self.navigationItem.titleView = titleLabel;
    [titleLabel release];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"[DeviceInfoViewController]  viewDidAppear");
    [connectedPeripheral setDeviceInfoDelegate:self];
    [connectedPeripheral readManufactureName];
    [connectedPeripheral readModelNumber];
    [connectedPeripheral readSerialNumber];
    [connectedPeripheral readFirmwareRevision];
    [connectedPeripheral readHardwareRevision];
    [connectedPeripheral readSoftwareRevison];
    [connectedPeripheral readCertificationData];
    [connectedPeripheral readSystemID];
}

- (void)viewDidDisappear:(BOOL)animated; {
    NSLog(@"[DeviceInfoViewController]  viewDidDisappear");
}

- (void)viewDidUnload
{
    NSLog(@"[DeviceInfoViewController]  viewDidUnload");
    [deviceNameLabel release];
    deviceNameLabel = nil;
    [hardwareRevisionLabel release];
    hardwareRevisionLabel = nil;
    [manufactureNameLabel release];
    manufactureNameLabel = nil;
    [modelNumberLabel release];
    modelNumberLabel = nil;
    [serialNumberLabel release];
    serialNumberLabel = nil;
    [firmwareRevisionLabel release];
    firmwareRevisionLabel = nil;
    [softwareRevisionLabel release];
    softwareRevisionLabel = nil;
    [systemIdLabel release];
    systemIdLabel = nil;
    [regulatoryCertificationDataListLabel release];
    regulatoryCertificationDataListLabel = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"[DeviceInfoViewController]  didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"[DeviceInfoViewController] dealloc");
    [deviceNameLabel release];
    [hardwareRevisionLabel release];
    [manufactureNameLabel release];
    [modelNumberLabel release];
    [serialNumberLabel release];
    [firmwareRevisionLabel release];
    [softwareRevisionLabel release];
    [systemIdLabel release];
    [regulatoryCertificationDataListLabel release];
    [super dealloc];
}

- (void)MyPeripheral:(MyPeripheral *)peripheral didUpdateManufactureName:(NSString *)name error:(NSError *)error {
    if (error != nil) {
        NSLog(@"[DeviceInfoViewController] didUpdateManufactureName error = %@",error);
        return;
    }
    if (name == NULL) {
        NSLog(@"[ManufactureName is NULL");
        return;
    }
    [manufactureNameLabel setText:[NSString stringWithFormat:@"Manufacture Name: %@", name]];
}

- (void)MyPeripheral:(MyPeripheral *)peripheral didUpdateModelNumber:(NSString *)modelNumber error:(NSError *)error {
    if (error != nil) {
        NSLog(@"[DeviceInfoViewController] didUpdateModelNumber error = %@",error);
        return;
    }
    if (modelNumber == NULL) {
        NSLog(@"[Model Number is NULL");
        return;
    }
    [modelNumberLabel setText:[NSString stringWithFormat:@"Model Number: %@", modelNumber]];
}

- (void)MyPeripheral:(MyPeripheral *)peripheral didUpdateSerialNumber:(NSString *)serialNumber error:(NSError *)error {
    if (error != nil) {
        NSLog(@"[DeviceInfoViewController] didUpdateSerialNumber error = %@",error);
        return;
    }
    if (serialNumber == NULL) {
        NSLog(@"[Serial Number is NULL");
        return;
    }
    [serialNumberLabel setText:[NSString stringWithFormat:@"Serial Number: %@", serialNumber]];
}

- (void)MyPeripheral:(MyPeripheral *)peripheral didUpdateFirmwareRevision:(NSString *)firmwareRevision error:(NSError *)error {
    if (error != nil) {
        NSLog(@"[DeviceInfoViewController] didUpdateFirmwareRevision error = %@",error);
        return;
    }
    if (firmwareRevision == NULL) {
        NSLog(@"[Firmware Revision is NULL");
        return;
    }
    [firmwareRevisionLabel setText:[NSString stringWithFormat:@"Firmware Revision: %@", firmwareRevision]];
}

- (void)MyPeripheral:(MyPeripheral *)peripheral didUpdateHardwareRevision:(NSString *)hardwareRevision error:(NSError *)error {
    if (error != nil) {
        NSLog(@"[DeviceInfoViewController] didUpdateHardwareRevision error = %@",error);
        return;
    }
    if (hardwareRevision == NULL) {
        NSLog(@"[Hardware Revision is NULL");
        return;
    }
    [hardwareRevisionLabel setText:[NSString stringWithFormat:@"Hardware Revision: %@", hardwareRevision]];
}

- (void)MyPeripheral:(MyPeripheral *)peripheral didUpdateSoftwareRevision:(NSString *)softwareRevision error:(NSError *)error {
    if (error != nil) {
        NSLog(@"[DeviceInfoViewController] didUpdateSoftwareRevision error = %@",error);
        return;
    }
    if (softwareRevision == NULL) {
        NSLog(@"[Software Revison is NULL");
        return;
    }
    [softwareRevisionLabel setText:[NSString stringWithFormat:@"Software Revison: %@", softwareRevision]];
}

- (void)MyPeripheral:(MyPeripheral *)peripheral didUpdateSystemId:(NSData *)systemId error:(NSError *)error {
    if (error != nil) {
        NSLog(@"[DeviceInfoViewController] didUpdateSystemId error = %@",error);
        return;
    }
    if (systemId == NULL) {
        NSLog(@"[SystemId is NULL");
        return;
    }
    [systemIdLabel setText:[NSString stringWithFormat:@"System ID: %@", systemId]];
}

- (void)MyPeripheral:(MyPeripheral *)peripheral didUpdateIEEE_11073_20601:(NSData *)IEEE_11073_20601 error:(NSError *)error {
    if (error != nil) {
        NSLog(@"[DeviceInfoViewController] didUpdateIEEE_11073_20601 error = %@",error);
        return;
    }
    if (([IEEE_11073_20601 length] == 0) || (IEEE_11073_20601 == nil)) {
        NSLog(@"[IEEE_11073_20601 is NULL");
        return;
    }
    NSMutableString *dataStr = [NSMutableString stringWithCapacity:64];
    NSUInteger length = [IEEE_11073_20601 length];
    char *bytes = malloc(sizeof(char) * length);
    
    [IEEE_11073_20601 getBytes:bytes length:length];
    
    [dataStr appendFormat:@"Count: 0x%02.2hhX%02.2hhX    ", bytes[0],bytes[1]];
    [dataStr appendFormat:@"Len: 0x%02.2hhX%02.2hhX", bytes[2],bytes[3]];
    int count = ((bytes[0]>>8)|bytes[1]);
    int offset = 4;
    
    int dataLen = 0;
    for (int i = 0; i < count; i++)
    {
        [dataStr appendFormat:@"\n"];
        [dataStr appendFormat:@"(List%d)    ",i+1];
        [dataStr appendFormat:@"Body: 0x%02.2hhX    ",bytes[offset]];
        [dataStr appendFormat:@"Type: 0x%02.2hhX\n",bytes[offset+1]];
        [dataStr appendFormat:@"Data: "];
        dataLen = ((bytes[offset+2]>>8) | bytes[offset+3]);
        if (dataLen > 0) {
            [dataStr appendFormat:@"0x"];
        }
        for (int j=0; j<dataLen; j++) {
            [dataStr appendFormat:@"%02.2hhX",bytes[offset+4+j]];
        }
        offset += (dataLen+4);
    }
    free(bytes);
    NSLog(@"dataStr: %@", dataStr);
    
    [regulatoryCertificationDataListLabel setText:[NSString stringWithFormat:@"[Regulatory Certification Data List]\n%@", dataStr]];
    [regulatoryCertificationDataListLabel sizeToFit];

}

@end
