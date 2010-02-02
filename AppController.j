/*
 * AppController.j
 * dbstore
 *
 * Created by You on February 2, 2010.
 * Copyright 2010, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "RLOfflineDataStore.j"


@implementation AppController : CPObject
{
    id dataStorage;
    CPButton aButton;
    CPTextField label;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];

    label = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];

    [label setStringValue:@""];
    [label setFont:[CPFont boldSystemFontOfSize:24.0]];

    [label sizeToFit];

    [label setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
    [label setCenter:[contentView center]];

    [contentView addSubview:label];

    [theWindow orderFront:self];

    // Uncomment the following line to turn on the standard menu bar.
    //[CPMenu setMenuBarVisible:YES];

    dataStorage = [[RLOfflineDataStore alloc] initWithName:@"HelloWorld" delegate:self];
    //[dataStorage setValue:@"World" forKey:@"word1"];
    [dataStorage getValueForKey:@"HelloWorldTestApp"];

    //[dataStorage removeValueForKey:@"word1"];
    
    aButton = [[CPSlider alloc] initWithFrame:CGRectMake(100,100,100,24)];
    [aButton setTarget:self];
    [aButton setAction:@selector(setNewValue:)];
    [contentView addSubview:aButton];
}

- (void)didReciveData:(CPString)aString
{
    [aButton setIntValue:aString]; 
    [label setStringValue:aString];
    [label sizeToFit];
}

- (void)setNewValue:(id)sender
{
    [dataStorage setValue:[sender intValue] forKey:@"HelloWorldTestApp"];
    [label setStringValue:[sender intValue]];
    [label sizeToFit];
}
@end
