//
//  ExampleViewController.h
//  JCDialPadDemo
//
//  Created by Aron Bury on 18/01/2014.
//  Copyright (c) 2014 Aron Bury. All rights reserved.
//

#import "JCDialPad.h"

@interface ExampleViewController : UIViewController <JCDialPadDelegate>

@property (strong, nonatomic) JCDialPad *view;

@end
