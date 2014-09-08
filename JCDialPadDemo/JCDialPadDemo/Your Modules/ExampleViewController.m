//
//  ExampleViewController.m
//  JCDialPadDemo
//
//  Created by Aron Bury on 18/01/2014.
//  Copyright (c) 2014 Aron Bury. All rights reserved.
//

#import "ExampleViewController.h"
#import "JCDialPad.h"
#import "JCPadButton.h"
#import "FontasticIcons.h"

@implementation ExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.buttons = [[JCDialPad defaultButtons] arrayByAddingObjectsFromArray:@[self.twilioButton, self.callButton]];
    self.view.delegate = self;
    
    UIImageView* backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallpaper"]];
	backgroundView.contentMode = UIViewContentModeScaleAspectFill;
	[self.view setBackgroundView:backgroundView];
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (JCPadButton *)twilioButton
{
    UIImage *twilioIcon = [UIImage imageNamed:@"Twilio"];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:twilioIcon];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    JCPadButton *twilioButton = [[JCPadButton alloc] initWithInput:@"T" iconView:iconView subLabel:@""];
    return twilioButton;
}

- (JCPadButton *)callButton
{
    FIIconView *iconView = [[FIIconView alloc] initWithFrame:CGRectMake(0, 0, 65, 65)];
    iconView.backgroundColor = [UIColor clearColor];
    iconView.icon = [FIFontAwesomeIcon phoneIcon];
    iconView.padding = 15;
    iconView.iconColor = [UIColor whiteColor];
    JCPadButton *callButton = [[JCPadButton alloc] initWithInput:@"P" iconView:iconView subLabel:@""];
    callButton.backgroundColor = [UIColor colorWithRed:0.261 green:0.837 blue:0.319 alpha:1.000];
    callButton.borderColor = [UIColor colorWithRed:0.261 green:0.837 blue:0.319 alpha:1.000];
    return callButton;
}

- (BOOL)dialPad:(JCDialPad *)dialPad shouldInsertText:(NSString *)text forButtonPress:(JCPadButton *)button
{
    if ([text isEqualToString:@"T"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Respond to button presses!"
                                                        message:@"Check out the JCDialPadDelegate protocol to do this"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    } else if ([text isEqualToString:@"P"]) {
        NSURL *callURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", dialPad.rawText]];
        [[UIApplication sharedApplication] openURL:callURL];
        return NO;
    }
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
