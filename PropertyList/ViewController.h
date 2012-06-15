//
//  ViewController.h
//  PropertyList
//
//  Created by Marian Paul on 30/03/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    IBOutlet UISwitch *_switch;
    IBOutlet UISlider *_slider;
    IBOutlet UITextField *_textField;
}

@property (nonatomic, strong) NSMutableDictionary *prefDictionary;

- (IBAction)freezeButton:(id)sender;
@end
