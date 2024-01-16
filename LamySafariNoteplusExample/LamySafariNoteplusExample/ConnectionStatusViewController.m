//
//  ConnectionStatusViewController.m
//
//  Copyright (c) 2017 Adonit. All rights reserved.
//

#import "ConnectionStatusViewController.h"
#import "LamySDK.h"
#import "LamyStatusHUD.h"

@interface ConnectionStatusViewController () <UIPopoverPresentationControllerDelegate>
@property (nonatomic, strong) LamyStylusManager *lamyStylusManager;
@end

@implementation ConnectionStatusViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.lamyStylusManager = [LamyStylusManager sharedInstance];
    self.connectionImageView.clipsToBounds = NO;
    self.view.clipsToBounds = NO;
    
    [self.lamyStylusManager enable];
    [self updateViewWithConnectionStatus:[LamyStylusManager sharedInstance].connectionStatus];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionStatusChanged:) name:LamyStylusManagerDidChangeConnectionStatus object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)connectionStatusChanged:(NSNotification *)notification
{
    LamyConnectionStatus connectionStatus = [notification.userInfo[LamyStylusManagerDidChangeConnectionStatusStatusKey] unsignedIntegerValue];
    [self updateViewWithConnectionStatus:connectionStatus];
}

- (IBAction)connectionImageViewTapped:(UITapGestureRecognizer *)sender
{
    if ([LamyStylusManager sharedInstance].isStylusConnected) {
        [self performSegueWithIdentifier:@"StylusDetailSegue" sender:self];
    }
}

- (IBAction)connectionImageViewLongPress:(UILongPressGestureRecognizer *)sender
{
    if (![LamyStylusManager sharedInstance].isStylusConnected) {
        if (sender.state == UIGestureRecognizerStateBegan) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.lamyStylusManager startDiscoveryAndImmediatelyConnect:YES withDiscoveryBlock:nil completionBlock:^(BOOL success, NSError *error){
                    if ([error code] == LamySDKErrorTypeStylusNotSupportedOnTablet) {
                        [LamyStatusHUD showLamyHUDInView:self.parentViewController.view topLineMessage:@"This stylus is compatible with iPad Pro only." bottomeLineMessage:@""];
                        [self.lamyStylusManager stopDiscovery];
                    }
                }];
            });
            
            [self addOpacityAnimationIfNotAlreadyAdded];
        }
        if (sender.state == UIGestureRecognizerStateEnded) {
            [self.lamyStylusManager stopDiscovery];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
    UIViewController *connectionStatusViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StylusDetailTableViewController"];
    [navController setViewControllers:@[connectionStatusViewController] animated:NO];
    navController.popoverPresentationController.delegate = self;
    navController.popoverPresentationController.sourceRect = self.connectionImageView.bounds;
}

- (UIViewController *)presentationController:(UIPresentationController *)controller viewControllerForAdaptivePresentationStyle:(UIModalPresentationStyle)style {
    UIViewController* presentedViewController = controller.presentedViewController;
    if ([controller isKindOfClass:[UIPopoverPresentationController class]] && style == UIModalPresentationFullScreen) {
        if ([presentedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navigationController = (UINavigationController *)presentedViewController;
            return navigationController;
        }
    } else if ([controller isKindOfClass:[UIPopoverPresentationController class]] && style == UIModalPresentationPopover) {
        if ([presentedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navigationController = (UINavigationController *)presentedViewController;
            navigationController.topViewController.navigationItem.rightBarButtonItem = nil;
        }
        
    }
    return presentedViewController;
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator
{
    UIViewController* presentedViewController = self.presentedViewController;
    if ([presentedViewController isKindOfClass:[UINavigationController class]] && (newCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact || newCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact)) {
            UINavigationController *navigationController = (UINavigationController *)presentedViewController;
    } else if ([presentedViewController isKindOfClass:[UINavigationController class]] && newCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
            UINavigationController *navigationController = (UINavigationController *)presentedViewController;
            navigationController.topViewController.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)addDoneButtonToViewController:(UIViewController *)viewController
{
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss:)];
    viewController.navigationItem.rightBarButtonItem = doneButton;
}

- (void)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateViewWithConnectionStatus:(LamyConnectionStatus)connectionStatus
{
    if (connectionStatus == LamyConnectionStatusConnected || connectionStatus == LamyConnectionStatusSwapStylusNotSupportThePlatform) {
        self.connectionImageView.image = [UIImage imageNamed:@"pencil_connect"];
    } else {
        self.connectionImageView.image = [UIImage imageNamed:@"pencil_disconnect"];
    }
    
    if ((connectionStatus == LamyConnectionStatusPairing) || (connectionStatus == LamyConnectionStatusScanning)) {
        [self addOpacityAnimationIfNotAlreadyAdded];
    } else {
        [self removeOpacityAnimation];
    }
}

- (void)addOpacityAnimationIfNotAlreadyAdded
{
    NSArray *animationKeys = self.connectionImageView.layer.animationKeys;
    if ([animationKeys containsObject:@"animateOpacity"]) { return; }
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 1.0;
    opacityAnimation.repeatCount = HUGE_VALF;
    opacityAnimation.autoreverses = YES;
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.3];
    [self.connectionImageView.layer addAnimation:opacityAnimation forKey:@"animateOpacity"];
}

- (void)removeOpacityAnimation
{
    [self.connectionImageView.layer removeAnimationForKey:@"animateOpacity"];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}
@end
