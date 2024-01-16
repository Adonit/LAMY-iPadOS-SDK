//
//  ViewController.m
//  LamySafariNoteplusSwiftExample
//
//  Created by Adam Wulf on 12/8/12.
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import "ViewController.h"
#import "LamySDK.h"
#import "LamySafariNoteplusExample-Swift.h"
#import <sys/sysctl.h>
#import "ConnectionStatusViewController.h"

typedef NS_ENUM(NSUInteger, ConnectionMode) {
    AdonitUI = 0,
    JotModelUI = 1,
    CustomizeUI = 2
};

@interface ViewController()<LamyStylusScrollValueDelegate,PrototypeBrushAdjustments>

@property (nonatomic, strong) LamyStylusManager *lamyStylusManager;
@property (nonatomic, strong) NSString *lastConnectedStylusName;
@property (nonatomic) BOOL gesturesEnabled;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *canvasViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *canvasViewHeightConstraint;
@property (nonatomic) UIPopoverController *settingsPopoverController;

@property (nonatomic, weak) IBOutlet UIView *brushColorPreview;
@property (nonatomic, weak) IBOutlet UIButton *penButton;
@property (nonatomic, weak) IBOutlet UIButton *brushButton;
@property (nonatomic, weak) IBOutlet UIButton *eraserButton;
@property (nonatomic) UIColor *currentColor;
@property (nonatomic) Brush *penBrush;
@property (nonatomic) Brush *brushBrush;
@property (nonatomic) Brush *eraserBrush;
@property (strong, nonatomic) IBOutlet UIView *switchContainer;
@property (nonatomic) NSTimer *tapTimer;

@end

@implementation ViewController {
    BOOL button1TapOn;
    BOOL button2TapOn;
    BOOL zoomOn;
    BOOL quickUndoRedoOn;
    BOOL toolsOn;
    int  state;
    CGFloat lastIncrement;
    CGFloat step;
    NSInteger currentConnectionUI;
    NSInteger lastConnectionUI;
}

#pragma mark - UIViewController
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Set initial state of Lamy Status Indicators to be off
    [self showLamyStatusIndicators:NO WithAnimation:NO];

    self.canvasView.viewController = self;

    
    self.currentColor = [UIColor darkGrayColor];
    NSInteger penIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentBrushIndex"];
    [self setupPen:penIndex];
    [self adonitLogoButtonPressed:self.adonitLogo];
    self.configContainerView.hidden = YES;
    state = 0;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(cancelTap)];
    [self.connectionStatusView addGestureRecognizer:singleFingerTap];
    
//    [self.connectionStatusView setUserInteractionEnabled:true];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    self.platformLabel.text =  [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    
    free(machine);
    _gesturesEnabled = true;
    [[NSNotificationCenter defaultCenter] addObserver:self                                                       selector:@selector(applicationEnteredForeground:)                                                          name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    // Hook up the lamyStylusManager
    self.lamyStylusManager = [LamyStylusManager sharedInstance];
    self.lamyStylusManager.unconnectedPressure = 256;
    self.lamyStylusManager.lamyStrokeDelegate = self.canvasView;
    [self.lamyStylusManager setLamyStylusScrollValueDelegate:self];
    self.lamyStylusManager.coalescedLamyStrokesEnabled = YES;
    [self.lamyStylusManager enable];
    
    // Register for lamyStylus notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionChanged:) name:LamyStylusManagerDidChangeConnectionStatus object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendlyNameChanged:) name:LamyStylusManagerDidChangeStylusFriendlyName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showRecommendString:) name:LamyStylusNotificationRecommend object:nil];

}

- (void)viewWillAppear:(BOOL)animated
{
    [self setupLamySDK];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults boolForKey:@"isFirstTimeLaunch"]) {
        // Setup shortcut buttons
        [self setupShortcut];
        [userDefaults setBool:YES forKey:@"isFirstTimeLaunch"];
        [userDefaults synchronize];
    } else {
        [self addShortcuts];
    }
    [self setupProtoType];
    lastConnectionUI = [userDefaults integerForKey:@"connection_type"];
    [self.canvasView setGestureEnable:[userDefaults boolForKey:@"gesture_enable"]];
    [self.canvasView setAltitudeEnable:[userDefaults boolForKey:@"altitudeAngle_enable"]];
    [self.canvasView setRadiusViewEnable:[userDefaults boolForKey:@"radius_enable"]];
}

- (void)applicationEnteredForeground:(NSNotification *)notification {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    currentConnectionUI = [userDefaults integerForKey:@"connection_type"];
    if (lastConnectionUI != currentConnectionUI) {
        [self setupLamySDK];
        [self.lamyStylusManager disable];
        [self.lamyStylusManager enable];
        lastConnectionUI = currentConnectionUI;
    }
    
    if (![userDefaults boolForKey:@"isFirstTimeLaunch"]) {
        // Setup shortcut buttons
        [self setupShortcut];
    } else {
        [self addShortcuts];
    }

    [self setupProtoType];
    [self.canvasView setGestureEnable:[userDefaults boolForKey:@"gesture_enable"]];
    [self.canvasView setAltitudeEnable:[userDefaults boolForKey:@"altitudeAngle_enable"]];
    [self.canvasView setRadiusViewEnable:[userDefaults boolForKey:@"radius_enable"]];
    
}

#pragma mark - Adonit SDK Setup
- (void)setupLamySDK
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // Hookup Lamy Settings UI
    switch ([userDefaults integerForKey:@"connection_type"]) {
        case AdonitUI:
        {
            UIViewController<LamyModelController> *connectionStatusViewController = [UIStoryboard instantiateLamyViewControllerWithIdentifier:LamyViewControllerUnifiedStatusButtonAndConnectionAndSettingsIdentifier];
            connectionStatusViewController.view.frame = self.connectionStatusView.bounds;
            NSArray *viewsToRemove = [self.connectionStatusView subviews];
            for (UIView *v in viewsToRemove) {
                [v removeFromSuperview];
            }
            [self.connectionStatusView addSubview:connectionStatusViewController.view];
            [self willMoveToParentViewController:connectionStatusViewController];
            [self addChildViewController:connectionStatusViewController];
            if (lastConnectionUI != currentConnectionUI) {
                [connectionStatusViewController dismissViewControllerAnimated:NO completion:nil];
            }
        }
            break;
        case JotModelUI: {
            UIViewController *connectionStatusViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PressedConnectionViewController"];
            
            connectionStatusViewController.view.frame = self.connectionStatusView.bounds;
            NSArray *viewsToRemove = [self.connectionStatusView subviews];
            for (UIView *v in viewsToRemove) {
                [v removeFromSuperview];
            }
            [self.connectionStatusView addSubview:connectionStatusViewController.view];
            [self willMoveToParentViewController:connectionStatusViewController];
            [self addChildViewController:connectionStatusViewController];
            if (lastConnectionUI != currentConnectionUI) {
                [connectionStatusViewController dismissViewControllerAnimated:NO completion:nil];
            }
        }
            break;
        case CustomizeUI:
        {
            UIViewController *connectionStatusViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ConnectionStatusViewController"];
            
            connectionStatusViewController.view.frame = self.connectionStatusView.bounds;
            NSArray *viewsToRemove = [self.connectionStatusView subviews];
            for (UIView *v in viewsToRemove) {
                [v removeFromSuperview];
            }
            [self.connectionStatusView addSubview:connectionStatusViewController.view];
            [self willMoveToParentViewController:connectionStatusViewController];
            [self addChildViewController:connectionStatusViewController];
            if (lastConnectionUI != currentConnectionUI) {
                [connectionStatusViewController dismissViewControllerAnimated:NO completion:nil];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - prototype
- (void)setupShortcut
{
    // Setup shortcut buttons
    [self removeAllShortcuts];
    [self.lamyStylusManager addShortcutOptionButton1Default: [[LamyShortcut alloc]
                                                       initWithDescriptiveText:@"Undo"
                                                       key:@"undo"
                                                       target:self selector:@selector(undoShortCut)
                                                       ]];
    
    [self.lamyStylusManager addShortcutOptionButton2Default: [[LamyShortcut alloc]
                                                       initWithDescriptiveText:@"Redo"
                                                       key:@"redo"
                                                       target:self selector:@selector(redoShortCut)
                                                       ]];
    
    [self.lamyStylusManager addShortcutOption: [[LamyShortcut alloc]
                                         initWithDescriptiveText:@"No Action"
                                         key:@"noaction"
                                         target:self selector:@selector(noActionShortCut)
                                         ]];
    
    [self.lamyStylusManager addScrollShortcutOption: [[LamyShortcut alloc]
                                               initWithDescriptiveText:@"Quick Undo/Redo"
                                               key:@"quickundoredo"
                                               target:self selector:@selector(quickUndoRedo)
                                               ]];
    
    [self.lamyStylusManager addScrollShortcutOption: [[LamyShortcut alloc]
                                               initWithDescriptiveText:@"No Action"
                                               key:@"noaction"
                                               target:self selector:@selector(noActionShortCut)
                                               ]];

}

- (void)addShortcuts
{
    // Setup shortcut buttons
    [self removeAllShortcuts];
    [self.lamyStylusManager addShortcutOption: [[LamyShortcut alloc]
                                                       initWithDescriptiveText:@"Undo"
                                                       key:@"undo"
                                                       target:self selector:@selector(undoShortCut)
                                                       ]];

    [self.lamyStylusManager addShortcutOption: [[LamyShortcut alloc]
                                                       initWithDescriptiveText:@"Redo"
                                                       key:@"redo"
                                                       target:self selector:@selector(redoShortCut)
                                                       ]];

    [self.lamyStylusManager addShortcutOption: [[LamyShortcut alloc]
                                         initWithDescriptiveText:@"No Action"
                                         key:@"noaction"
                                         target:self selector:@selector(noActionShortCut)
                                         ]];
}

- (void)setupProtoType
{
    self.protoController.delegate = self;
    self.protoController.view.tintColor = [UIColor darkGrayColor];

    [self setupToolSelection];

}

- (void)setupToolSelection
{
    NSMutableArray *selectedViews = [NSMutableArray array];
    NSMutableArray *unselectedViews = [NSMutableArray array];
    NSInteger numberOfViews = self.canvasView.brushLibrary.brushes.count;
    CGSize viewSize = [LamyPrototypeOverlayViewController selectionViewSizeForNumberOfItems:numberOfViews];

    for (NSInteger counter = 0; counter < numberOfViews; counter++) {
        Brush *brush = [self.canvasView.brushLibrary.brushes objectAtIndex:counter];
        CGRect viewRect = CGRectMake(0, 0, viewSize.height, viewSize.width); // inverse to rotate 90


        // Selected View
        UIImage *selectedImage = brush.selectedIcon;
        UIImageView *selectedImageView = [[UIImageView alloc]initWithImage:selectedImage];
        selectedImageView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        selectedImageView.frame = viewRect;

        selectedImageView.contentMode = UIViewContentModeCenter;
        selectedImageView.autoresizingMask =
        ( UIViewAutoresizingFlexibleBottomMargin
         | UIViewAutoresizingFlexibleHeight
         | UIViewAutoresizingFlexibleLeftMargin
         | UIViewAutoresizingFlexibleRightMargin
         | UIViewAutoresizingFlexibleTopMargin
         | UIViewAutoresizingFlexibleWidth );

        [selectedViews addObject:selectedImageView];

        // Unselected View
        UIImage *unselectedImage = brush.unselectedIcon;
        UIImageView *unselectedImageView = [[UIImageView alloc]initWithImage:unselectedImage];
        unselectedImageView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        unselectedImageView.frame = viewRect;

        unselectedImageView.contentMode = UIViewContentModeCenter;
        unselectedImageView.autoresizingMask =
        ( UIViewAutoresizingFlexibleBottomMargin
         | UIViewAutoresizingFlexibleHeight
         | UIViewAutoresizingFlexibleLeftMargin
         | UIViewAutoresizingFlexibleRightMargin
         | UIViewAutoresizingFlexibleTopMargin
         | UIViewAutoresizingFlexibleWidth );

        [unselectedViews addObject:unselectedImageView];
    }

    [self.overlayController setToolUnselectedViews:unselectedViews selectedViews:selectedViews];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"prototype_segue"]) {
        self.protoController = (LamyPrototypeViewController *)segue.destinationViewController;
    }

    if ([segue.identifier isEqualToString:@"overlay_segue"]) {
        self.overlayController = (LamyPrototypeOverlayViewController *)segue.destinationViewController;
        self.overlayController.view.tintColor = [UIColor darkGrayColor];
        self.protoController.overLayController = self.overlayController;
        self.overlayController.view.alpha = 0.0;
    }
}

#pragma mark- Lamy SDK / Connection Stylus Changes

/*
 * Stylus connection has changed. We Pass on to a handle method in for this implementation.
 */
- (void)connectionChanged:(NSNotification *)note
{
    LamyConnectionStatus status = [note.userInfo[LamyStylusManagerDidChangeConnectionStatusStatusKey] unsignedIntegerValue];
    [self updateViewWithConnectionStatus:status friendleyName:self.lamyStylusManager.stylusFriendlyName];
}

/*
 * Update the state of your app with the connection change and also alert the user to changes. An example being displaying a on screen HUD showing that their stylus has connected, disconnected, etc.
 */
- (void)updateViewWithConnectionStatus:(LamyConnectionStatus)status friendleyName:(NSString *)friendlyName
{
    switch(status)
    {
        case LamyConnectionStatusConnected:
        {
            [self showLamyStatusIndicators:YES WithAnimation:YES];

            self.lastConnectedStylusName = friendlyName;

            [self.lamyStatusIndicatorContainerView setConnectedStylusModel: [NSString stringWithFormat:@"%@ Connected", self.lastConnectedStylusName]];
            [LamyStatusHUD showLamyHUDInView:self.view isConnected:YES modelName:self.lastConnectedStylusName];

            if ([self.lamyStylusManager stylusSupportsAltitudeAngle]) {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [self.canvasView setAltitudeEnable:[userDefaults boolForKey:@"altitudeAngle_enable"]];
                self.canvasView.altitudeEnable = NO;
            } else {
                self.canvasView.altitudeEnable = NO;
            }

            if ([self.lamyStylusManager stylusSupportsScrollSensor]) {
                self.lamyStatusIndicatorContainerView.scrollData.hidden = NO;
                self.lamyStatusIndicatorContainerView.stylusTapLabel.hidden = NO;
                self.lamyStatusIndicatorContainerView.scrollValue.hidden = NO;
                self.lamyStatusIndicatorContainerView.scrollValueLabel.hidden = NO;
                self.lamyStatusIndicatorContainerView.aTapLabel.hidden = NO;
                self.lamyStatusIndicatorContainerView.bTapLabel.hidden = NO;
            } else {
                self.lamyStatusIndicatorContainerView.scrollValue.hidden = YES;
                self.lamyStatusIndicatorContainerView.scrollValueLabel.hidden = YES;
                self.lamyStatusIndicatorContainerView.aTapLabel.hidden = YES;
                self.lamyStatusIndicatorContainerView.bTapLabel.hidden = YES;
                self.lamyStatusIndicatorContainerView.scrollData.hidden = YES;
                self.lamyStatusIndicatorContainerView.stylusTapLabel.hidden = YES;
            }
            
            if ([self.lamyStylusManager stylusSupportsAzimuthAngle]) {
                [LamyStatusHUD showLamyHUDInView:self.view isConnected:YES modelName:@"stylusSupportsAzimuthAngle"];
            } else {
                [LamyStatusHUD showLamyHUDInView:self.view isConnected:YES modelName:@"stylus not SupportsAzimuthAngle"];
            }
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            if (![userDefaults boolForKey:@"isFirstTimeLaunch"]) {
                // Setup shortcut buttons
                [self setupShortcut];
                [userDefaults setBool:YES forKey:@"isFirstTimeLaunch"];
                [userDefaults synchronize];
            } else {
                [self addShortcuts];
            }
//            [self removeAllShortcuts];
            break;
        }
        case LamyConnectionStatusDisconnected:
        {
            [self.lamyStatusIndicatorContainerView setConnectedStylusModel:@"No Stylus Connected"];
            [self showLamyStatusIndicators:NO WithAnimation:YES];
            if (self.lastConnectedStylusName.length > 0) {
                [LamyStatusHUD showLamyHUDInView:self.view isConnected:NO modelName:self.lastConnectedStylusName];
                self.lastConnectedStylusName = nil;
            }
            break;
        }
        case LamyConnectionStatusOff:
        default:
            break;
    }
}

/*
 * If the user updates the friendly name of their stylus, a nice option is to show them A status HUD reflecting the new change.
 */
- (void)friendlyNameChanged:(NSNotification *)note
{
    NSString *friendlyName = note.userInfo[LamyStylusManagerDidChangeStylusFriendlyNameNameKey];
    [self updateViewWithConnectionStatus:self.lamyStylusManager.connectionStatus friendleyName:friendlyName];
}

- (void)removeAllShortcuts
{
    [self.lamyStylusManager removeAllShorcuts];
}

#pragma mark - Adonit SDK - Handle gesture suggestions from canvas view.

- (void)handleSuggestsToDisableGestures
{
    // disable any other gestures, like a pinch to zoom
    [self.lamyStatusIndicatorContainerView setActivityMessage:@"Suggestion: DISABLE gestures"];
}

- (void)handleSuggestsToEnableGestures
{
    // enable any other gestures, like a pinch to zoom
     [self.lamyStatusIndicatorContainerView setActivityMessage:@"Suggestion: ENABLE gestures"];
}

#pragma mark - IBAction

- (void)dismissSettingsViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)noActionShortCut
{
    [self.lamyStatusIndicatorContainerView setActivityMessage:@"LamyShortCut Triggered: noAction"];
}

- (IBAction)undoShortCut
{
    [self.canvasView undo];
    [self.lamyStatusIndicatorContainerView setActivityMessage:@"LamyShortCut Triggered: undo"];
    zoomOn = false;
    quickUndoRedoOn = false;
    state = 0;
}

- (IBAction)redoShortCut
{
    [self.canvasView redo];
    [self.lamyStatusIndicatorContainerView setActivityMessage:@"LamyShortCut Triggered: redo"];
    zoomOn = false;
    quickUndoRedoOn = false;
    state = 0;
}

- (IBAction)selectPen:(UIButton *)sender
{
    self.canvasView.brushLibrary.currentBrushIndex = 0;
    self.canvasView.currentBrush = self.canvasView.brushLibrary.pencil;
    [self highlightSelectedButton:sender];
}

- (IBAction)selectBrush:(UIButton *)sender
{
    self.canvasView.brushLibrary.currentBrushIndex = 1;
    self.canvasView.currentBrush = self.canvasView.brushLibrary.pen;
    [self highlightSelectedButton:sender];
}

- (IBAction)selectEraser:(UIButton *)sender
{
    self.canvasView.brushLibrary.currentBrushIndex = 2;
    self.canvasView.currentBrush = self.canvasView.brushLibrary.eraser;
    [self highlightSelectedButton:sender];
}

- (IBAction)changeColor:(UIButton *)sender
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    [self setBrushColors:color];
}

- (void)highlightSelectedButton:(UIButton *)selectedButton;
{
    NSArray *buttons = @[self.penButton, self.brushButton, self.eraserButton];
    for (UIButton *button in buttons) {
        if (button == selectedButton) {
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)clear
{    
    [self.canvasView clear];
}


- (IBAction)adonitLogoButtonPressed:(UIButton *)sender
{
    self.lamyStatusIndicatorContainerView.hidden = !self.lamyStatusIndicatorContainerView.hidden;
}

/**
 * The Lamy Status Indicator is a view wired up to show
 * the pressure of the stylus as it moves around.
 *
 * It also shows when the A & B button are pressed.
 *
 * This wouldn't be necessary for a shipping application,
 * but might be helpful to get a feel for how the
 * stylus hardware works.
 */
- (void)showLamyStatusIndicators:(BOOL)show WithAnimation:(BOOL)animate
{
    CGFloat opacity =  0.0;
    CGFloat duration = 0.0;
    
    if (show) opacity = 1.0;
    if (animate) duration = 0.5;
    
    // Fade in or out
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.lamyStatusIndicatorContainerView setAlpha:opacity];
                     }
                     completion:^(BOOL finished){}];
}


#pragma mark - Brushes
- (void)setCurrentColor:(UIColor *)currentColor
{
    _currentColor = currentColor;
    [self setBrushColors:currentColor];
}

- (void)setBrushColors:(UIColor *)brushColors
{
    self.penBrush.brushColor = brushColors;
    self.brushBrush.brushColor = brushColors;
    self.brushColorPreview.backgroundColor = brushColors;
    self.canvasView.currentBrush.brushColor = brushColors;
    self.canvasView.brushLibrary.currentBrush.brushColor = brushColors;
    self.canvasView.currentColor = brushColors;
}

- (void)updateProtoTypeBrushColor
{
    [self.overlayController setBrushColor:self.canvasView.currentColor currentOpacity:self.canvasView.currentBrush.maxPressureOpacity minValue:self.canvasView.currentBrush.minOpacity maxValue:self.canvasView.currentBrush.maxOpacity];

    self.overlayController.selectedColorIndex = self.canvasView.colorLibrary.currentColorIndex;
}

- (void)updateProtoTypeBrushSize
{
    [self.overlayController setBrushSize:self.canvasView.currentBrush.maxPressureSize minSize:self.canvasView.currentBrush.minSize maxSize:self.canvasView.currentBrush.maxSize];
    self.overlayController.selectedToolIndex = self.canvasView.brushLibrary.currentBrushIndex;
}

- (void) zoom
{
    // do something for zoom
    if (self.gesturesEnabled) {
        state = 1;
        zoomOn = !zoomOn;
        if (zoomOn) {
            [self.lamyStylusManager setRequireScrollData:true];
            [LamyStatusHUD showLamyHUDInView:self.view topLineMessage:@"Scroll enable" bottomeLineMessage:@"Zooming"];
            quickUndoRedoOn = false;
            toolsOn = false;
            if (self.protoController.overLayController.currentScrollInteractionFocus == Scroll_Interaction_Focus_Tool_Switch) {
                [self.protoController noneSelectShortCut];
            }
        } else {
            [self.lamyStylusManager setRequireScrollData:false];
            state = 0;
            [LamyStatusHUD showLamyHUDInView:self.view topLineMessage:@"Scroll disable" bottomeLineMessage:@"Zooming"];
        }
    }
    
}

- (void) quickUndoRedo
{
    // do something for undo redo
    state = 2;
    quickUndoRedoOn = !quickUndoRedoOn;
    if (quickUndoRedoOn) {
        [self.lamyStylusManager setRequireScrollData:true];
        [LamyStatusHUD showLamyHUDInView:self.view topLineMessage:@"Scroll enable" bottomeLineMessage:@"Undo/Redo"];
        zoomOn = false;
        toolsOn = false;
        if (self.protoController.overLayController.currentScrollInteractionFocus == Scroll_Interaction_Focus_Tool_Switch) {
            [self.protoController noneSelectShortCut];
        }
    } else {
        [self.lamyStylusManager setRequireScrollData:false];
        state = 0;
        [LamyStatusHUD showLamyHUDInView:self.view topLineMessage:@"Scroll disable" bottomeLineMessage:@"Undo/Redo"];
    }
}

- (void) lamyButton1Tap
{
    button1TapOn = !button1TapOn;
    if (button1TapOn) {
        [self.lamyStylusManager setRequireScrollData:true];
        [self.lamyStatusIndicatorContainerView lamyButton1Tap:@"ON"];
        [self.lamyStatusIndicatorContainerView lamyButton2Tap:@"OFF"];
        button2TapOn = false;
        state = 1;
        [self.protoController noneSelectShortCut];
    } else {
        [self.lamyStylusManager setRequireScrollData:false];
        [self.lamyStatusIndicatorContainerView lamyButton1Tap:@"OFF"];
        state = 0;
    }
}

- (void) lamyButton2Tap
{
    button2TapOn = !button2TapOn;
    if (button2TapOn) {
        [self.lamyStylusManager setRequireScrollData:true];
        [self.lamyStatusIndicatorContainerView lamyButton1Tap:@"OFF"];
        [self.lamyStatusIndicatorContainerView lamyButton2Tap:@"ON"];
        button1TapOn = false;
        state = 2;
    } else {
        [self.lamyStylusManager setRequireScrollData:false];
        [self.lamyStatusIndicatorContainerView lamyButton2Tap:@"OFF"];
        state = 0;
    }
}

- (void)cancelTap
{
    state           = 0;
    button1TapOn    = false;
    button2TapOn    = false;
    toolsOn         = false;
    quickUndoRedoOn = false;
    zoomOn          = false;
    [self.lamyStylusManager setRequireScrollData:false];
    [self.lamyStatusIndicatorContainerView lamyButton1Tap:@"OFF"];
    [self.lamyStatusIndicatorContainerView lamyButton2Tap:@"OFF"];
    [self.protoController noneSelectShortCut];
}

- (IBAction)adonitLogoConnect:(id)sender {
}

#pragma mark - Cleanup
- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.lamyStylusManager = nil;
}

- (void)toolsSelect
{
//    [self.protoController toolSelectShortCut];
//    state = 3;
//    toolsOn = !toolsOn;
//    if (toolsOn) {
//        zoomOn = false;
//        quickUndoRedoOn = false;
//        [self.lamyStylusManager setRequireScrollData:true];
//    } else {
//        [self.lamyStylusManager setRequireScrollData:false];
//    }
}

- (void)scrollValueUpdate:(CGFloat)value
{
//    [self.lamyStatusIndicatorContainerView jotScrollUpdate:value];
//    switch (state) {
//        case 1:
//            if (_gesturesEnabled) {
//                [self adjustZoomScaleBy:value];
//            }
//            break;
//        case 2:
//            [self handleUndoRedoBy:value];
//            break;
//        case 3:
//            [self.protoController relativeSliderUpdateByValue:value];
//            break;
//        default:
//            break;
//    }
}

- (void)scrollShortcutChange
{
    [self cancelTap];
}

- (void)adjustZoomScaleBy:(CGFloat)zoomScaleIncrement
{
    CGFloat zoomScale = 1.0;
    zoomScale += zoomScaleIncrement / 100.0;
    [self.canvasView scrollToZoom:zoomScale];
}

- (void)handleUndoRedoBy:(CGFloat)increment
{
    step += fabs(increment - lastIncrement);
    if (step > 2) {
        if (increment > 0) {
            [self.canvasView redo];
        } else if (increment < 0){
            [self.canvasView undo];
        }
        step = 0;
    }
    lastIncrement = increment;
}

#pragma mark - Prototype Scroll Adjustments
- (void)moveBrushSelectionBy:(CGFloat)selectionIncrement
{
    NSInteger selectedBrush = [self.overlayController toolSelectedAfterAdjustingByAmount:selectionIncrement];
    if (self.canvasView.brushLibrary.currentBrushIndex != selectedBrush) {
        self.canvasView.brushLibrary.currentBrushIndex = selectedBrush;
        [self updateProtoTypeBrushSize];
        [self setupPen:selectedBrush];
    }
}

- (void)setupPen:(NSInteger)index
{
    switch (index) {
        case 0:
            [self selectPen:self.penButton];
            break;
        case 1:
            [self selectBrush:self.brushButton];
            break;
        case 2:
            [self selectEraser:self.eraserButton];
            break;
        default:
            break;
    }
}

- (void)showRecommendString:(NSNotification *)note
{
    NSString *recommend = note.userInfo[LamyStylusNotificationRecommendKey];
    [LamyStatusHUD showLamyHUDInView:self.view topLineMessage:recommend bottomeLineMessage:@""];
}

- (void)setGestureEnable:(id)sender
{
    [self.canvasView setGestureEnable:[sender isOn]];
    _gesturesEnabled = [sender isOn];
}

@end
