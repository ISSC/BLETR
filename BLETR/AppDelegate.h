//
//  AppDelegate.h
//  BLETR
//
//  Created by D500 user on 13/5/7.
//  Copyright (c) 2013年 ISSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConnectViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate>
{
    BOOL _pageTransition;
}
@property (strong, nonatomic) UIWindow *window;

@property(strong, nonatomic) ConnectViewController *viewController;
@property(nonatomic, retain) UINavigationController *navigationController;
@property(assign) BOOL pageTransition;
@end