//
//  CBController.h
//  BLETR
//
//  Created by user D500 on 12/2/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <CoreBluetooth/CBCentralManager.h>
//#import <CoreBluetooth/CBPeripheral.h>
//#import <CoreBluetooth/CBCharacteristic.h>
//#import <CoreBluetooth/CBDescriptor.h>
//#import <CoreBluetooth/CBService.h>
//#import <CoreBluetooth/CBUUID.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "UUID.h"
#import "MyPeripheral.h"

enum {
    LE_STATUS_IDLE = 0,
    LE_STATUS_SCANNING,
    LE_STATUS_CONNECTING,
    LE_STATUS_CONNECTED
};


@protocol CBControllerDelegate;
@interface CBController : UIViewController<CBCentralManagerDelegate, CBPeripheralDelegate>
{
    CBCentralManager *manager;
    NSMutableArray *devicesList;
    BOOL    notifyState;
    NSMutableArray *_connectedPeripheralList;
    CBUUID *_transServiceUUID;
    CBUUID *_transTxUUID;
    CBUUID *_transRxUUID;
    BOOL    isISSCPeripheral;
}

@property(assign) id<CBControllerDelegate> delegate;
@property (retain) NSMutableArray *devicesList;

- (void) startScan;
- (void) stopScan;
- (void)connectDevice:(MyPeripheral *) myPeripheral;
- (void)disconnectDevice:(MyPeripheral *) aPeripheral;
- (NSMutableData *) hexStrToData: (NSString *)hexStr;
- (BOOL) isLECapableHardware;
- (void)addDiscoverPeripheral:(CBPeripheral *)aPeripheral advName:(NSString *)advName;
- (void)updateDiscoverPeripherals;
- (void)updateMyPeripheralForDisconnect:(MyPeripheral *)myPeripheral;
- (void)updateMyPeripheralForNewConnected:(MyPeripheral *)myPeripheral;
- (void)storeMyPeripheral: (CBPeripheral *)aPeripheral;
- (MyPeripheral *)retrieveMyPeripheral: (CBPeripheral *)aPeripheral;
- (void)removeMyPeripheral: (CBPeripheral *) aPeripheral;
- (void)configureTransparentServiceUUID: (NSString *)serviceUUID txUUID:(NSString *)txUUID rxUUID:(NSString *)rxUUID;
@end

@protocol CBControllerDelegate
@required
- (void)didUpdatePeripheralList:(NSArray *)peripherals;
- (void)didConnectPeripheral:(MyPeripheral *)peripheral;
- (void)didDisconnectPeripheral:(MyPeripheral *)peripheral;
@end