//
//  LamyStatusIndicatorView.m
//  LamySafariNoteplusSwiftExample
//
//  Copyright (c) 2014 Adonit, LLC. All rights reserved.
//

#import "LamyStatusIndicatorView.h"
#import "LamySDK.h"

@interface LamyStatusIndicatorView ()

@property (nonatomic, weak) IBOutlet UILabel* lamyActivityLabel;
@property (nonatomic, weak) IBOutlet UILabel* aButtonLabel;
@property (nonatomic, weak) IBOutlet UILabel* bButtonLabel;
@property (nonatomic, weak) IBOutlet UILabel* friendlyNameLabel;


@end

@implementation LamyStatusIndicatorView {
    BOOL button1TapOn;
    BOOL button2TapOn;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupShortCutButtonLabels];
    }
    return self;
}

#pragma mark - Button Label Setup

/**
 * We are setting up the buttons states to trigger labels so that a developer can see how a stylus reacts once connected to an app. An app could also use these notifications as a way to add more advanced behaviors to the up and down state of stylus buttons.
 */
- (void) setupShortCutButtonLabels
{
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector:@selector(lamyButton1Down)
                                                 name: LamyStylusButton1Down
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector:@selector(lamyButton1Up)
                                                 name: LamyStylusButton1Up
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector:@selector(lamyButton2Down)
                                                 name: LamyStylusButton2Down
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector:@selector(lamyButton2Up)
                                                 name: LamyStylusButton2Up
                                               object:nil];

}

- (void) lamyButton1Down
{
    self.aButtonLabel.text = @"PRESSED";
}

- (void) lamyButton1Up
{
    self.aButtonLabel.text = @"A";
}

- (void) lamyButton2Down
{
    self.bButtonLabel.text = @"PRESSED";
}

- (void) lamyButton2Up
{
   self.bButtonLabel.text = @"B";
}

- (void) setActivityMessage:(NSString *)activityMessage
{
    self.lamyActivityLabel.text = activityMessage;
}

- (void) setConnectedStylusModel:(NSString *)stylusModelName
{
    self.friendlyNameLabel.text = stylusModelName;
}

- (void) lamyButton1Tap:(NSString *)text
{
    self.aTapLabel.text = text;
}

- (void) lamyButton2Tap:(NSString *)text
{
    self.bTapLabel.text = text;
}

- (void) lamyScrollUpdate:(float)value
{
//    NSLog(@"value = %f",[[notification.userInfo objectForKey:JotStylusScrollValue] floatValue]);
    self.scrollValue.value += value;
    self.scrollData.text = [NSString stringWithFormat:@"%f",self.scrollValue.value];
}


#pragma mark - Cleanup
- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
