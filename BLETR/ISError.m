//
//  ISError.m
//  BLEDKSDK
//
//  Created by D500 user on 12/11/19.
//  Copyright (c) 2012年 D500 user. All rights reserved.
//

#import "ISError.h"

@implementation ISError
- (id)init {
    self = [super init];
    if (self) {
        errorDescription = nil;
    }
    return self;
}

- (void) setErrorDescription:(NSString *)str {
    errorDescription = [[NSString alloc] initWithString:str];
}

- (NSString *) localizedDescription {
    return errorDescription;
}

@end