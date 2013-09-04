//
//  CBController.m
//  BLETR
//
//  Created by user D500 on 12/2/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CBController.h"
#import "MyPeripheral.h"

@implementation CBController
@synthesize delegate;
@synthesize devicesList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        devicesList = [[NSMutableArray alloc] init];
        _connectedPeripheralList = [[NSMutableArray alloc] init];
        _transServiceUUID = nil;
        _transTxUUID = nil;
        _transRxUUID = nil;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)dealloc {
    [manager release];
    [devicesList release];
    [self disconnectDevice:nil];
    [super dealloc];
}

- (void) startScan 
{
    NSLog(@"[CBController] start scan");
    [manager scanForPeripheralsWithServices:nil options:nil];
    [devicesList removeAllObjects];
    
}

/*
 Request CBCentralManager to stop scanning for heart rate peripherals
 */
- (void) stopScan 
{
    NSLog(@"[CBController] stop scan");
    [manager stopScan];
}

- (NSMutableData *) hexStrToData: (NSString *)hexStr
{
    NSMutableData *data= [[NSMutableData alloc] init];
    NSUInteger len = [hexStr length];
    
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < len/2; i++) {
        byte_chars[0] = [hexStr characterAtIndex:i*2];
        byte_chars[1] = [hexStr characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1]; 
    }
    return [data autorelease];
}

- (void)connectDevice:(MyPeripheral *) myPeripheral{
    NSLog(@"[CBController] connectDevice: %@", myPeripheral.advName);
    if (myPeripheral.connectStaus != MYPERIPHERAL_CONNECT_STATUS_IDLE)
        return;
    [manager connectPeripheral:myPeripheral.peripheral options:nil];  //connect to device
}

- (void)disconnectDevice: (MyPeripheral *)myPeripheral {
    NSLog(@"[CBController] disconnectDevice");
    [manager cancelPeripheralConnection: myPeripheral.peripheral];
}

- (void)updateDiscoverPeripherals {
    
}

- (void)updateMyPeripheralForNewConnected:(MyPeripheral *)myPeripheral {
    
}

- (void)updateMyPeripheralForDisconnect:(MyPeripheral *)myPeripheral {
    
}

- (void)addDiscoverPeripheral:(CBPeripheral *)aPeripheral advName:(NSString *)advName{
    MyPeripheral *myPeripheral = nil;
    for (uint8_t i = 0; i < [devicesList count]; i++) {
        myPeripheral = [devicesList objectAtIndex:i];
        if (myPeripheral.peripheral == aPeripheral) {
            myPeripheral.advName = advName;
            break;
        }
        myPeripheral = nil;
    }
    if (myPeripheral == nil) {
        [aPeripheral retain];
        myPeripheral = [[MyPeripheral alloc] init];
        myPeripheral.peripheral = aPeripheral;
        myPeripheral.advName = advName;
        [devicesList addObject:myPeripheral];
    }
    //NSLog(@"[CBController] deviceList count = %d", [devicesList count]);
    [self updateDiscoverPeripherals];
}

- (void)storeMyPeripheral: (CBPeripheral *)aPeripheral {
    MyPeripheral *myPeripheral = nil;
    bool b = FALSE;
    for (uint8_t i = 0; i < [devicesList count]; i++) {
        myPeripheral = [devicesList objectAtIndex:i];
        if (myPeripheral.peripheral == aPeripheral) {
            b = TRUE;
            //NSLog(@"storeMyPeripheral 1");
            break;
        }
    }
    if(!b) {
        //NSLog(@"storeMyPeripheral 2");
        myPeripheral = [[MyPeripheral alloc] init];
        myPeripheral.peripheral = aPeripheral;
    }
    myPeripheral.connectStaus = MYPERIPHERAL_CONNECT_STATUS_CONNECTED;
    [_connectedPeripheralList addObject:myPeripheral];
    
}

- (MyPeripheral *)retrieveMyPeripheral:(CBPeripheral *)aPeripheral {
    MyPeripheral *myPeripheral = nil;
    for (uint8_t i = 0; i < [_connectedPeripheralList count]; i++) {
        myPeripheral = [_connectedPeripheralList objectAtIndex:i];
        if (myPeripheral.peripheral == aPeripheral) {
            break;
        }
    }
    return myPeripheral;
}

- (void)removeMyPeripheral: (CBPeripheral *) aPeripheral {
    MyPeripheral *myPeripheral = nil;
    for (uint8_t i = 0; i < [_connectedPeripheralList count]; i++) {
        myPeripheral = [_connectedPeripheralList objectAtIndex:i];
        if (myPeripheral.peripheral == aPeripheral) {
            myPeripheral.connectStaus = MYPERIPHERAL_CONNECT_STATUS_IDLE;
            [self updateMyPeripheralForDisconnect:myPeripheral];
            [_connectedPeripheralList removeObject:myPeripheral];
            return;
        }
    }
    for (uint8_t i = 0; i < [devicesList count]; i++) {
        myPeripheral = [devicesList objectAtIndex:i];
        if (myPeripheral.peripheral == aPeripheral) {
            myPeripheral.connectStaus = MYPERIPHERAL_CONNECT_STATUS_IDLE;
            [self updateMyPeripheralForDisconnect:myPeripheral];
            break;
        }
    }
}

- (void)configureTransparentServiceUUID: (NSString *)serviceUUID txUUID:(NSString *)txUUID rxUUID:(NSString *)rxUUID {
    if (serviceUUID) {
        _transServiceUUID = [CBUUID UUIDWithString:serviceUUID];
        [_transServiceUUID retain];
        _transTxUUID = [CBUUID UUIDWithString:txUUID];
        [_transTxUUID retain];
        _transRxUUID = [CBUUID UUIDWithString:rxUUID];
        [_transRxUUID retain];
    }
    else {
        _transServiceUUID = nil;
        _transTxUUID = nil;
        _transRxUUID = nil;
    }
}

/*
 Uses CBCentralManager to check whether the current platform/hardware supports Bluetooth LE. An alert is raised if Bluetooth LE is not enabled or is not supported.
 */
- (BOOL) isLECapableHardware
{
    NSString * state = nil;
    
    switch ([manager state]) 
    {
        case CBCentralManagerStateUnsupported:
            state = @"The platform/hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff:
            state = @"Bluetooth is currently powered off.";
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"Bluetooth power on");
            return TRUE;
        case CBCentralManagerStateUnknown:
        default:
            return FALSE;
            
    }
    
    NSLog(@"Central manager state: %@", state);
    
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Bluetooth alert"  message:state delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    [alertView show];
    [alertView release];
    return FALSE;
}

#pragma mark - CBCentralManager delegate methods
/*
 Invoked whenever the central manager's state is updated.
 */
- (void) centralManagerDidUpdateState:(CBCentralManager *)central 
{
    [self isLECapableHardware];
}


/*
 Invoked when the central discovers heart rate peripheral while scanning.
 */
- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)aPeripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI 
{    
    NSLog(@"<---------\n[CBController] didDiscoverPeripheral, %@, count=%u, RSSI=%d, count=%d", aPeripheral.UUID, [advertisementData count], [RSSI intValue], [devicesList count]);
    NSArray *advDataArray = [advertisementData allValues];
    NSArray *advValueArray = [advertisementData allKeys];
    for (int i=0; i < [advertisementData count]; i++)
    {
        NSLog(@"adv data=%@, %@ ", [advDataArray objectAtIndex:i], [advValueArray objectAtIndex:i]);
    }
    NSLog(@"-------->");
    [self addDiscoverPeripheral:aPeripheral advName:[advertisementData valueForKey:CBAdvertisementDataLocalNameKey]];
}

/*
 Invoked when the central manager retrieves the list of known peripherals.
 Automatically connect to first known peripheral
 */
- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    NSLog(@"Retrieved peripheral: %u - %@", [peripherals count], peripherals);
    if([peripherals count] >=1)
    {
        [self connectDevice:[peripherals objectAtIndex:0]];
    }
}

/*
 Invoked whenever a connection is succesfully created with the peripheral. 
 Discover available services on the peripheral
 */
- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)aPeripheral 
{    
    NSLog(@"[CBController] didConnectPeripheral, uuid=%@", aPeripheral.UUID);

    [aPeripheral setDelegate:self];

    [self storeMyPeripheral:aPeripheral];
    
    isISSCPeripheral = FALSE;
    NSMutableArray *uuids = [[NSMutableArray alloc] initWithObjects:[CBUUID UUIDWithString:UUIDSTR_DEVICE_INFO_SERVICE], [CBUUID UUIDWithString:UUIDSTR_ISSC_PROPRIETARY_SERVICE], nil];
    if (_transServiceUUID)
        [uuids addObject:_transServiceUUID];
    [aPeripheral discoverServices:uuids];
    [uuids release];
}

/*
 Invoked whenever an existing connection with the peripheral is torn down. 
 Reset local variables
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error
{
    NSLog(@"[CBController] didDisonnectPeripheral uuid = %@, error msg:%d, %@, %@", aPeripheral.UUID, error.code ,[error localizedFailureReason], [error localizedDescription]);

    [self removeMyPeripheral:aPeripheral];
}

/*
 Invoked whenever the central manager fails to create a connection with the peripheral.
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error
{
    NSLog(@"[CBController] Fail to connect to peripheral: %@ with error = %@", aPeripheral, [error localizedDescription]);
    [self removeMyPeripheral:aPeripheral];
}

#pragma mark - CBPeripheral delegate methods
/*
 Invoked upon completion of a -[discoverServices:] request.
 Discover available characteristics on interested services
 */
- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverServices:(NSError *)error 
{
    for (CBService *aService in aPeripheral.services) 
    {
        NSLog(@"[CBController] Service found with UUID: %@", aService.UUID);
      //  NSArray *uuids = [[NSArray alloc] initWithObjects:[CBUUID UUIDWithString:@"2A4D"], nil];
        [aPeripheral discoverCharacteristics:nil forService:aService];
      //  [uuids release];
    }
}

/*
 Invoked upon completion of a -[discoverCharacteristics:forService:] request.
 Perform appropriate operations on interested characteristics
 */
- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error 
{
    NSLog(@"\n[CBController] didDiscoverCharacteristicsForService: %@", service.UUID);
    CBCharacteristic *aChar = nil;
    MyPeripheral *myPeripheral = [self retrieveMyPeripheral:aPeripheral];
    if (myPeripheral == nil) {
        return;
    }

    if (_transServiceUUID && [service.UUID isEqual:_transServiceUUID]) {
        isISSCPeripheral = TRUE;
        for (aChar in service.characteristics)
        {
            if ([aChar.UUID isEqual:_transRxUUID]) {
                [myPeripheral setTransparentDataWriteChar:aChar];
                NSLog(@"found custom TRANS_RX");
            }
            else if ([aChar.UUID isEqual:_transTxUUID]) {
                NSLog(@"found custome TRANS_TX");
                [myPeripheral setTransparentDataReadChar:aChar];
              //  [aPeripheral setNotifyValue:TRUE forCharacteristic:aChar];
            }
        }
    }
    else if ([service.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_ISSC_PROPRIETARY_SERVICE]]) {
        isISSCPeripheral = TRUE;
        for (aChar in service.characteristics)
        {
            if ((_transServiceUUID == nil) && [aChar.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_ISSC_TRANS_RX]]) {
                [myPeripheral setTransparentDataWriteChar:aChar];
                NSLog(@"found TRANS_RX");
                
            }
            else if ((_transServiceUUID == nil) && [aChar.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_ISSC_TRANS_TX]]) {
                 NSLog(@"found TRANS_TX");
                [myPeripheral setTransparentDataReadChar:aChar];
                //[aPeripheral setNotifyValue:TRUE forCharacteristic:aChar];
            }
            else if ([aChar.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_CONNECTION_PARAMETER_CHAR]]) {
                [myPeripheral setConnectionParameterChar:aChar];
                 NSLog(@"found CONNECTION_PARAMETER_CHAR");
            }
            else if ([aChar.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_AIR_PATCH_CHAR]]) {
                [myPeripheral setAirPatchChar:aChar];
                NSLog(@"found UUIDSTR_AIR_PATCH_CHAR");
                
            }
        }
    }
    else if([service.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_DEVICE_INFO_SERVICE]]) {

        for (aChar in service.characteristics)
        {
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_MANUFACTURE_NAME_CHAR]]) {
                [myPeripheral setManufactureNameChar:aChar];
                NSLog(@"found manufacture name char");
            }
            else if ([aChar.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_MODEL_NUMBER_CHAR]]) {
                [myPeripheral setModelNumberChar:aChar];
                    NSLog(@"found model number char");

            }
            else if ([aChar.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_SERIAL_NUMBER_CHAR]]) {
                [myPeripheral setSerialNumberChar:aChar];
                NSLog(@"found serial number char");
            }
            else if ([aChar.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_HARDWARE_REVISION_CHAR]]) {
                [myPeripheral setHardwareRevisionChar:aChar];
                NSLog(@"found hardware revision char");
            }
            else if ([aChar.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_FIRMWARE_REVISION_CHAR]]) {
                [myPeripheral setFirmwareRevisionChar:aChar];
                NSLog(@"found firmware revision char");
            }
            else if ([aChar.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_SOFTWARE_REVISION_CHAR]]) {
                [myPeripheral setSoftwareRevisionChar:aChar];
                NSLog(@"found software revision char");
            }
            else if ([aChar.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_SYSTEM_ID_CHAR]]) {
                [myPeripheral setSystemIDChar:aChar];
                NSLog(@"[CBController] found system ID char");
            }
            else if ([aChar.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_IEEE_11073_20601_CHAR]]) {
                [myPeripheral setCertDataListChar:aChar];
                NSLog(@"found certification data list char");
            }
        }
    }
    
    if (isISSCPeripheral == TRUE) {
        [self updateMyPeripheralForNewConnected:myPeripheral];
    }
}

/*
 Invoked upon completion of a -[readValueForCharacteristic:] request or on the reception of a notification/indication.
 */
- (void) peripheral:(CBPeripheral *)aPeripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error 
{
    MyPeripheral *myPeripheral = [self retrieveMyPeripheral:aPeripheral];
    if (myPeripheral == nil) {
        return;
    }
    NSLog(@"[CBController] didUpdateValueForCharacteristic");
    
    if ([characteristic.service.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_DEVICE_INFO_SERVICE]]) {
        if (myPeripheral.deviceInfoDelegate == nil)
            return;
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_MANUFACTURE_NAME_CHAR]]) {
            NSLog(@"[CBController] update manufacture name");
            
            if ([(NSObject *)myPeripheral.deviceInfoDelegate respondsToSelector:@selector(MyPeripheral:didUpdateManufactureName:error:)]) {
                [[myPeripheral deviceInfoDelegate] MyPeripheral:myPeripheral didUpdateManufactureName:[[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding] error:error];
            }
        }
        else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_MODEL_NUMBER_CHAR]]) {
            NSLog(@"[CBController] update model number");

            
            if ([(NSObject *)myPeripheral.deviceInfoDelegate respondsToSelector:@selector(MyPeripheral:didUpdateModelNumber:error:)]) {
                [myPeripheral.deviceInfoDelegate MyPeripheral:myPeripheral didUpdateModelNumber:[[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding] error:error];
            }
        }
        else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_SERIAL_NUMBER_CHAR]]) {
            NSLog(@"[CBController] update serial number");
            
            if ([(NSObject *)myPeripheral.deviceInfoDelegate respondsToSelector:@selector(MyPeripheral:didUpdateSerialNumber:error:)]) {
                [myPeripheral.deviceInfoDelegate MyPeripheral:myPeripheral didUpdateSerialNumber:[[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding] error:error];
            }
        }
        else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_HARDWARE_REVISION_CHAR]]) {
            NSLog(@"[CBController] update hardware revision");

            
            if ([(NSObject *)myPeripheral.deviceInfoDelegate respondsToSelector:@selector(MyPeripheral:didUpdateHardwareRevision:error:)]){
                [myPeripheral.deviceInfoDelegate MyPeripheral:myPeripheral didUpdateHardwareRevision:[[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding] error:error];
            }
        }
        else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_FIRMWARE_REVISION_CHAR]]) {
            NSLog(@"[CBController] update firmware revision");

            
            if ([(NSObject *)myPeripheral.deviceInfoDelegate respondsToSelector:@selector(MyPeripheral:didUpdateFirmwareRevision:error:)]){
                [myPeripheral.deviceInfoDelegate MyPeripheral:myPeripheral didUpdateFirmwareRevision:[[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding] error:error];
            }
        }
        else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_SOFTWARE_REVISION_CHAR]]) {

            NSLog(@"[CBController] update software revision");

            if ([(NSObject *)myPeripheral.deviceInfoDelegate respondsToSelector:@selector(MyPeripheral:didUpdateSoftwareRevision:error:)]){
                [myPeripheral.deviceInfoDelegate MyPeripheral:myPeripheral didUpdateSoftwareRevision:[[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding] error:error];
            }
        }
        else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_SYSTEM_ID_CHAR]]) {
            NSLog(@"[CBController] update system ID");

            if ([(NSObject *)myPeripheral.deviceInfoDelegate respondsToSelector:@selector(MyPeripheral:didUpdateSystemId:error:)]){
                
                [myPeripheral.deviceInfoDelegate MyPeripheral:myPeripheral didUpdateSystemId:characteristic.value error:error];
                
            }
        }
        else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_IEEE_11073_20601_CHAR]]) {
            NSLog(@"[CBController] update IEEE_11073_20601: %@",characteristic.value);

            if ([(NSObject *)myPeripheral.deviceInfoDelegate respondsToSelector:@selector(MyPeripheral:didUpdateIEEE_11073_20601:error:)]){
                
                [myPeripheral.deviceInfoDelegate MyPeripheral:myPeripheral didUpdateIEEE_11073_20601:characteristic.value error:error];
                
            }
        }
    }
    else if ([characteristic.service.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_ISSC_PROPRIETARY_SERVICE]]) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_CONNECTION_PARAMETER_CHAR]]) {
            NSLog(@"[CBController] update connection parameter: %@", characteristic.value);
            unsigned char buf[10];
            CONNECTION_PARAMETER_FORMAT *parameter;
            
            [characteristic.value getBytes:&buf[0] length:sizeof(CONNECTION_PARAMETER_FORMAT)];
            parameter = (CONNECTION_PARAMETER_FORMAT *)&buf[0];

            //NSLog(@"[CBController] %02X, %02x, %02x, %02x, %02X, %02x, %02x, %02x, %02x,status= %d, min= %f,max= %f, latency=%d, timeout=%d", buf[0],buf[1],buf[2],buf[3],buf[4],buf[5],buf[6],buf[7],buf[8],parameter->status, parameter->minInterval*1.25, parameter->maxInterval*1.25, parameter->latency, parameter->connectionTimeout*10);
            
            //first time read
            if ([myPeripheral retrieveBackupConnectionParameter]->status == 0xff) {
                [myPeripheral updateBackupConnectionParameter:parameter];
            }
            else {
                switch (myPeripheral.updateConnectionParameterStep) {
                    case UPDATE_PARAMETERS_STEP_PREPARE:
                        if ((myPeripheral.proprietaryDelegate != nil) && ([(NSObject *)myPeripheral.proprietaryDelegate respondsToSelector:@selector(MyPeripheral:didUpdateConnectionParameterAllowStatus:)]))
                            [myPeripheral.proprietaryDelegate MyPeripheral:myPeripheral didUpdateConnectionParameterAllowStatus:(buf[0] == 0x00)];
                            break;
                    case UPDATE_PARAMETERS_STEP_CHECK_RESULT:
                        if (buf[0] != 0x00) {
                            NSLog(@"[CBController] check connection parameter status again");
                            [myPeripheral checkConnectionParameterStatus];
                        }
                        else {
                            if ((myPeripheral.proprietaryDelegate != nil) && ([(NSObject *)myPeripheral.proprietaryDelegate respondsToSelector:@selector(MyPeripheral:didUpdateConnectionParameterStatus:interval:timeout:latency:)])){
                                if ([myPeripheral compareBackupConnectionParameter:parameter] == TRUE) {
                                    NSLog(@"[CBController] connection parameter no change");
                                    [myPeripheral.proprietaryDelegate MyPeripheral:myPeripheral didUpdateConnectionParameterStatus:FALSE interval:parameter->maxInterval*1.25 timeout:parameter->connectionTimeout*10 latency:parameter->latency];
                                }
                                else {
                                    //NSLog(@"connection parameter update success");
                                    [myPeripheral.proprietaryDelegate MyPeripheral:myPeripheral didUpdateConnectionParameterStatus:TRUE interval:parameter->maxInterval*1.25 timeout:parameter->connectionTimeout*10 latency:parameter->latency];
                                    [myPeripheral updateBackupConnectionParameter:parameter];
                                }
                            }
                        }
                    default:
                        break;
                }
           }
        }
        else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_AIR_PATCH_CHAR]]) {
            [myPeripheral updateAirPatchEvent:characteristic.value];
        }
        else if ((_transServiceUUID == nil) && [characteristic.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_ISSC_TRANS_TX]]) {
            if ((myPeripheral.transDataDelegate != nil) && ([(NSObject *)myPeripheral.transDataDelegate respondsToSelector:@selector(MyPeripheral:didReceiveTransparentData:)])) {
                [myPeripheral.transDataDelegate MyPeripheral:myPeripheral didReceiveTransparentData:characteristic.value];
            }
        }
    }
    else if (_transServiceUUID && [characteristic.service.UUID isEqual:_transServiceUUID]) {
        if ([characteristic.UUID isEqual:_transTxUUID]) {
            if ((myPeripheral.transDataDelegate != nil) && ([(NSObject *)myPeripheral.transDataDelegate respondsToSelector:@selector(MyPeripheral:didReceiveTransparentData:)])) {
                [myPeripheral.transDataDelegate MyPeripheral:myPeripheral didReceiveTransparentData:characteristic.value];
            }
        }
    }
}

- (void) peripheral:(CBPeripheral *)aPeripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error 
{
    NSLog(@"[CBController] didWriteValueForCharacteristic error msg:%d, %@, %@", error.code ,[error localizedFailureReason], [error localizedDescription]);
    MyPeripheral *myPeripheral = [self retrieveMyPeripheral:aPeripheral];
    if (myPeripheral == nil) {
        return;
    }
    
    if ((_transServiceUUID == nil) && [characteristic.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_ISSC_TRANS_RX]]) {
        if ((myPeripheral.transDataDelegate != nil) && ([(NSObject *)myPeripheral.transDataDelegate respondsToSelector:@selector(MyPeripheral:didSendTransparentDataStatus:)])) {
            [myPeripheral.transDataDelegate MyPeripheral:myPeripheral didSendTransparentDataStatus:error];
        }
    }
    else if (_transServiceUUID && [characteristic.UUID isEqual:_transRxUUID]) {
        if ((myPeripheral.transDataDelegate != nil) && ([(NSObject *)myPeripheral.transDataDelegate respondsToSelector:@selector(MyPeripheral:didSendTransparentDataStatus:)])) {
            [myPeripheral.transDataDelegate MyPeripheral:myPeripheral didSendTransparentDataStatus:error];
        }
    }
}

- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"[CBController] didDiscoverDescriptorsForCharacteristic error msg:%d, %@, %@", error.code ,[error localizedFailureReason], [error localizedDescription]);
}

- (void) peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    NSLog(@"[CBController] didUpdateValueForDescriptor");
}

-(void) peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"[CBController] didUpdateNotificationStateForCharacteristic, UUID = %@", characteristic.UUID);
    MyPeripheral *myPeripheral = [self retrieveMyPeripheral:peripheral];
    if (myPeripheral == nil) {
        return;
    }
    if ((myPeripheral.transDataDelegate != nil) && ([(NSObject *)myPeripheral.transDataDelegate respondsToSelector:@selector(MyPeripheral:didUpdateTransDataNotifyStatus:)])) {
        [myPeripheral.transDataDelegate MyPeripheral:myPeripheral didUpdateTransDataNotifyStatus:characteristic.isNotifying];
    }
    
}
@end
