/******************************************************************************
 * Copyright (c) 2009, Maher Ali <maher.ali@gmail.com>
 * iPhone SDK 3 Programming - Advanced Mobile Development for Apple iPhone and iPod touch
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 ******************************************************************************/

#import <UIKit/UIKit.h>

@protocol TableAlertViewDelegate
-(void) didSelectRowAtIndex: (NSInteger)row withContext:(id)context;
@end

@interface TableAlertView : UIAlertView < UITableViewDelegate, UITableViewDataSource>{
    UITableView                *myTableView;
    id<TableAlertViewDelegate> caller;
    id                         context;
    NSArray                    *data;
    NSUInteger                 tableHeight;
}

-(id)initWithCaller:(id<TableAlertViewDelegate>)_caller data:(NSArray*)_data
              title:(NSString*)_title buttonTitle:(NSString *) _buttonTitle andContext:(id)_context;
@property(nonatomic, retain) id<TableAlertViewDelegate> caller;
@property(nonatomic, retain) id context;
@property(nonatomic, retain) NSArray *data;
@end

@interface TableAlertView(HIDDEN)
-(void)prepare;
@end
