//
//  DataFetch.h
//  LocationNavigator
//
//  Created by Roshan Lamichhane on 4/14/15.
//  Copyright (c) 2015 Vastika. All rights reserved.
//

#import "ViewController.h"

@interface DataFetch : ViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *user;
- (IBAction)done:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *locality;
@property (weak, nonatomic) IBOutlet UILabel *zipcode;

@end
