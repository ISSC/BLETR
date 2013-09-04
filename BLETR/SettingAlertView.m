//
//  settingAlertView.m
//  BLEServerTest
//
//  Created by D500 user on 13/1/15.
//  Copyright (c) 2013年 D500 user. All rights reserved.
//

#import "SettingAlertView.h"

@implementation SettingAlertView
@synthesize callerDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message settingID:(int)ID delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles,... {
   
    if((self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles: nil])) {
        buttonNumber = 1;
        if (otherButtonTitles != nil) {
            va_list args;
            va_start(args, otherButtonTitles);
            for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString*))
            {
                [self addButtonWithTitle:arg];
                buttonNumber++;
            }
            va_end(args);
        }
        callerDelegate = delegate;
        self.delegate = self;
    }
    settingID = ID;
    return self;
}

- (NSInteger)addButtonWithTitle:(NSString *)title {
    buttonNumber = [super addButtonWithTitle:title] + 1;
    return buttonNumber-1;
}

- (void)layoutSubviews {
    CGRect rect = self.bounds;
    NSLog(@"textFieldCount=%d, buttonNumber=%d", textFieldCount, buttonNumber);
    rect.size.height += (textFieldCount)*(kMAlertViewTextFieldHeight + kMAlertViewMargin);
    if (buttonNumber > 2) {
       // rect.size.height -= ((buttonNumber - buttonNumber/2) * kMAlertViewTextFieldHeight + kMAlertViewMargin);
    }
    else
        rect.size.height += 3*kMAlertViewMargin;
    NSLog(@"textFieldCount=%d, buttonNumber=%d, height=%f", textFieldCount, buttonNumber, rect.size.height);
    self.bounds = rect;
    float maxLabelY = 15.f;
    float maxLabelx = 0.f;
    int textFieldIndex = 0;
    int buttonCount = 0;
    int buttonPositionX = kMAlertViewMargin;
    
    for (UIView *view in self.subviews) {
        
        if ([view isKindOfClass:[UIImageView class]]) {
            
        }
        else if ([view isKindOfClass:[UILabel class]]) {
            //    UILabel *a = view;
            rect = view.frame;
            rect.origin.x = kMAlertViewMargin;
            
            //  if (rect.size.height != kMAlertViewTextFieldHeight) {
            if (view.tag != 1) {
                
                //maxLabelY = rect.origin.y + rect.size.height;
                rect.origin.y = maxLabelY;
                maxLabelY += rect.size.height + kMAlertViewMargin;
                maxLabelx = kMAlertViewMargin;
                
                view.frame = rect;
              //  NSLog(@"lable = %@, %f, %f, %f", [view text], rect.origin.y, rect.size.height, maxLabelY);
            }
            else {
                [view setBackgroundColor:[UIColor clearColor]];
                [(UILabel *)view setTextColor:[UIColor whiteColor]];
                rect.origin.y = maxLabelY;// + kMAlertViewMargin*(textFieldIndex+1) + kMAlertViewTextFieldHeight*textFieldIndex;
                rect.size.height = kMAlertViewTextFieldHeight;
                //maxLabelY += rect.size.height + kMAlertViewMargin;
                rect.size.width = self.bounds.size.width/2;
                maxLabelx = rect.origin.x + rect.size.width;
                view.frame = rect;
            }
        }
        else if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UISwitch class]]) {
            
            rect = view.frame;
            rect.size.width = self.bounds.size.width - maxLabelx - 2*kMAlertViewMargin;//self.bounds.size.width - 2*kMAlertViewMargin;
            rect.size.height = kMAlertViewTextFieldHeight;
            rect.origin.x = maxLabelx;// + kMAlertViewMargin;
            rect.origin.y = maxLabelY;// + kMAlertViewMargin*(textFieldIndex+1) + kMAlertViewTextFieldHeight*textFieldIndex;
            maxLabelY += rect.size.height + kMAlertViewMargin;
            view.frame = rect;
            textFieldIndex++;
        }
        else if ([view isKindOfClass:[UIButton class]]){  //UIThreePartButton
            
            rect = view.frame;
            if (buttonNumber > 2 ) {
                if (buttonCount < 3 && buttonNumber%2) {
                    rect.size.width = ((self.bounds.size.width - 4*kMAlertViewMargin)/3);
                   // rect.size.width = ((self.bounds.size.width - (buttonNumber+1)*kMAlertViewMargin)/buttonNumber);
                    buttonPositionX = kMAlertViewMargin + buttonCount * (rect.size.width + kMAlertViewMargin);
                    rect.origin.x =  buttonPositionX;
                    rect.origin.y = self.bounds.size.height - 65.0 - (rect.size.height+kMAlertViewMargin) * (buttonNumber/2 - 1);
                }
                else {
                    rect.size.width = ((self.bounds.size.width - 3*kMAlertViewMargin)/2);
                    buttonPositionX = kMAlertViewMargin + ((buttonCount+(buttonNumber%2))%2) * (rect.size.width + kMAlertViewMargin);
                    rect.origin.x =  buttonPositionX;
                    rect.origin.y = self.bounds.size.height - 65.0 - (rect.size.height + kMAlertViewMargin) * (buttonNumber/2 - buttonCount/2 - 1);
                    NSLog(@"y = %f", rect.origin.y);
                }
            }
            else {
                rect.origin.y = self.bounds.size.height - 65.0;
            }
            view.frame = rect;
            buttonCount++;
        }
        else {
            
        }
    }
}

- (void)addOptionComponent:(UIView *)componet componentTag:(NSInteger)componentTag text:(NSString *)text LabelText:(NSString *)labelText {
    if (labelText != nil) {
        UILabel *aLabel = [UILabel new];
        CGRect rect = aLabel.frame;
        rect.size.width = self.bounds.size.width/2;
        rect.size.height = kMAlertViewTextFieldHeight;
        aLabel.frame = rect;
        aLabel.text = labelText;
        aLabel.tag = 1;
        componet.tag = componentTag;
        [self addSubview:aLabel];
    }
    if (componet != nil) {
        textFieldCount++;
        if ([componet isKindOfClass:[UITextField class]]) {
            componet.frame = CGRectZero;
            ((UITextField *)componet).borderStyle = UITextBorderStyleRoundedRect;
            
            ((UITextField *)componet).text = text;
            ((UITextField *)componet).delegate = (id<UITextFieldDelegate>)self;
            
        }
        [self addSubview:componet];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSMutableArray *paramArray = [NSMutableArray new];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            [paramArray addObject:[(UITextField*)view text]];
        }
        else if ([view isKindOfClass:[UISwitch class]]) {
            if (((UISwitch *)view).on) {
                [paramArray addObject:@"Y"];
            }
            else {
                [paramArray addObject:@"N"];
            }
         }
    }
    
    [callerDelegate didEditTextFieldForType:buttonIndex settingID:settingID text:paramArray];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end


