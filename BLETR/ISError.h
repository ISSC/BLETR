//
//  ISError.h
//  BLEDKSDK
//
//  Created by D500 user on 12/11/19.
//  Copyright (c) 2012年 D500 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISError : NSError {
    NSString *errorDescription;
}
- (void) setErrorDescription:(NSString *)str;
@end