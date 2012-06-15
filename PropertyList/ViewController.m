//
//  ViewController.m
//  PropertyList
//
//  Created by Marian Paul on 30/03/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import "ViewController.h"


#define kSlider @"slider"
#define kSwitch @"switch"
#define kTextField @"textField"

@interface ViewController ()
- (BOOL)readDataFromFile;
- (BOOL)writeDataToFile;
@end

@implementation ViewController
@synthesize prefDictionary = _prefDictionary;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self readDataFromFile];
    
    _slider.value = [[self.prefDictionary objectForKey:kSlider] floatValue];
    _switch.on = [[self.prefDictionary objectForKey:kSwitch] boolValue];
    _textField.text = [self.prefDictionary objectForKey:kTextField];
    
    NSLog(@"%@", _prefDictionary);
}

- (IBAction)freezeButton:(id)sender
{
    NSNumber *sliderValue = [NSNumber numberWithFloat:_slider.value];
    [self.prefDictionary setObject:sliderValue forKey:kSlider];
    [self.prefDictionary setObject:[NSNumber numberWithBool:_switch.on] forKey:kSwitch];
    [self.prefDictionary setObject:_textField.text forKey:kTextField];
    
    [self writeDataToFile];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (BOOL)readDataFromFile 
{
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"preferences.plist"];
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *dictionary = (NSDictionary *)[NSPropertyListSerialization    propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    if (!dictionary) {
        // Il y a eu une erreur, errorDesc est alloué
        NSLog(@"erreur : %@",errorDesc);
        // retourner NO éventuellement selon l'implémentation désirée
    }
    
    self.prefDictionary = [NSMutableDictionary dictionaryWithDictionary:[dictionary objectForKey:@"prefDictionary"]];    
    return YES;
}

- (BOOL)writeDataToFile 
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"preferences.plist"];    
    
    NSString *errorDesc = nil;
    NSMutableDictionary *prefDict;
    // on remplace par les valeurs que l'on a modifiées    
    prefDict = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObject:self.prefDictionary] forKeys:[NSArray arrayWithObject:@"prefDictionary"]];
    
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:prefDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorDesc];
    if (plistData) {
        BOOL returned = [plistData writeToFile:plistPath atomically:YES];
        return returned;
    }
    else {
        return NO;
    }
    return NO;
}

@end
