//
//  ViewController.h
//  LamySafariNoteplusSwiftExample
//
//  Copyright (c) 2012 Adonit. All rights reserved.
//

@import UIKit;
#import "LamySDK.h"
#import "CanvasView.h"
#import "StylusSettingsButton.h"
#import "LamyStatusHUD.h"
#import "LamyStatusIndicatorView.h"
#import "LamyPrototypeViewController.h"
#import "LamyPrototypeOverlayViewController.h"


@class ColorPaletteLibrary,BrushLibrary;
@interface ViewController : UIViewController <UIPopoverControllerDelegate>

// Canvas to draw on for testing
@property (nonatomic, weak) IBOutlet CanvasView *canvasView;
@property (weak, nonatomic) LamyPrototypeViewController *protoController;
@property (weak, nonatomic) LamyPrototypeOverlayViewController *overlayController;
@property (weak, nonatomic) IBOutlet UIView *configContainerView;

// User Interface
@property (nonatomic, weak) IBOutlet UIButton *adonitLogo;
@property (nonatomic, weak) IBOutlet UIView *interfaceContainerView;
@property (nonatomic, weak) IBOutlet UIButton *resetCanvasButton;

@property (weak, nonatomic) IBOutlet UIView *connectionStatusView;

@property (strong, nonatomic) IBOutlet UILabel *platformLabel;
@property (weak, nonatomic) IBOutlet UILabel *angleLabel;
@property (weak, nonatomic) IBOutlet UILabel *radianLabel;

// LamyStatusIndicators Properties & Methods
@property (nonatomic, weak) IBOutlet LamyStatusIndicatorView* lamyStatusIndicatorContainerView;

@property (nonatomic, weak) id<LamyStylusScrollValueDelegate> scrollValueDelegate;

- (IBAction)clear;
- (IBAction)gestureSwitchValueChanged;
- (IBAction)adonitLogoButtonPressed:(UIButton *)sender;

- (void)handleSuggestsToDisableGestures;
- (void)handleSuggestsToEnableGestures;
- (void)updateProtoTypeBrushColor;
- (void)updateProtoTypeBrushSize;
- (void)cancelTap;
- (IBAction)adonitLogoConnect:(id)sender;
@end
