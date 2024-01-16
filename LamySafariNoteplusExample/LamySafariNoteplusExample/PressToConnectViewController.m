//
//  PressToConnectViewController.m
//
//  Copyright (c) 2017 Adonit. All rights reserved.
//

#import "PressToConnectViewController.h"
#import "LamySDK.h"

@interface PressToConnectViewController ()
@property (nonatomic, strong) LamyStylusManager *lamyStylusManager;

@end

@implementation PressToConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lamyPrimaryColor];
    UIViewController<LamyModelController> *connectionStatusViewController = [UIStoryboard instantiateLamyViewControllerWithIdentifier:LamyViewControllerPressToConnectIdentifier];
    connectionStatusViewController.view.frame = self.pressToConnectView.bounds;
    NSArray *viewsToRemove = [self.pressToConnectView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    connectionStatusViewController.view.backgroundColor = [UIColor lamyPrimaryColor];
    [connectionStatusViewController setSecondaryColor:[UIColor whiteColor]];
    
    [self.pressToConnectView addSubview:connectionStatusViewController.view];
    [self addChildViewController:connectionStatusViewController];
    self.lamyStylusManager = [LamyStylusManager sharedInstance];
    
    // Register for lamyStylus notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionChanged:) name:LamyStylusManagerDidChangeConnectionStatus object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendlyNameChanged:) name:LamyStylusManagerDidChangeStylusFriendlyName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showRecommendString:) name:LamyStylusNotificationRecommend object:nil];
    
    [self updateInstructionsForConnectionStatus:self.lamyStylusManager.connectionStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)connectionChanged:(NSNotification *)note
{
    LamyConnectionStatus status = [note.userInfo[LamyStylusManagerDidChangeConnectionStatusStatusKey] unsignedIntegerValue];
    [self updateViewWithConnectionStatus:status friendleyName:self.lamyStylusManager.stylusFriendlyName];
}

- (void)friendlyNameChanged:(NSNotification *)note
{
    NSString *friendlyName = note.userInfo[LamyStylusManagerDidChangeStylusFriendlyNameNameKey];
    [self updateViewWithConnectionStatus:self.lamyStylusManager.connectionStatus friendleyName:friendlyName];
}

- (void)updateInstructionsForConnectionStatus:(LamyConnectionStatus)status {
    switch(status)
    {
        case LamyConnectionStatusConnected:
        {
            self.connectionInstructionLabel.text = @"Stylus Connected";
            break;
        }
        case LamyConnectionStatusDisconnected:
        {
            
            self.connectionInstructionLabel.text = @"Hold Tip Here";
            break;
        }
        case LamyConnectionStatusPairing:
        {
            self.connectionInstructionLabel.text = @"Connecting...";
            break;
        }
        case LamyConnectionStatusScanning:
        {
            self.connectionInstructionLabel.text = @"Searching...";
            break;
        }
        case LamyConnectionStatusStylusNotSupportThePlatform:
        case LamyConnectionStatusSwapStylusNotSupportThePlatform:
            self.connectionInstructionLabel.text = @"This stylus is compatible with iPad Pro only.";
            break;
        case LamyConnectionStatusOff:
        default:
            break;
    }
}

- (void)showRecommendString:(NSNotification *)note
{
    NSString *recommend = note.userInfo[LamyStylusNotificationRecommendKey];
    self.connectionInstructionLabel.text = recommend;
}


/*
 * Update the state of your app with the connection change and also alert the user to changes. An example being displaying a on screen HUD showing that their stylus has connected, disconnected, etc.
 */
- (void)updateViewWithConnectionStatus:(LamyConnectionStatus)status friendleyName:(NSString *)friendlyName
{
    [self updateInstructionsForConnectionStatus:status];
}

@end
