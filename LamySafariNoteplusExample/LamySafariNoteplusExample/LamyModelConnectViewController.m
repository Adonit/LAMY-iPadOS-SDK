//
//  LamyModelConnectViewController.m
//
//  Copyright (c) 2017 Adonit. All rights reserved.
//
#import "LamyModelConnectViewController.h"
#import "ShortcutButtonsTableViewController.h"


typedef NS_ENUM(NSUInteger, LamySettingsDetailSection) {
    LamySettingsDetailSectionConnect = 0,
    LamySettingsDetailSectionStylus = 1,
    LamySettingsDetailSectionAccuracyComfort = 2,
    LamySettingsDetailSectionUsageInfo = 3,
    LamySettingsDetailSectionHelp = 4,
    LamySettingsDetailSectionCount
};

typedef NS_ENUM(NSUInteger, LamySettingsDetailStylusRow) {
    LamySettingsDetailStylusStylusRow = 0,
    LamySettingsDetailStylusShortcutARow = 1,
    LamySettingsDetailStylusShortcutBRow = 2,
    LamySettingsDetailStylusRowCount
};

typedef NS_ENUM(NSUInteger, LamySettingsDetailAccuracyAndComfortRow) {
    LamySettingsDetailAccuracyAndComfortRowWritingStyle = 0,
    LamySettingsDetailAccuracyAndComfortRowCount
};

typedef NS_ENUM(NSUInteger, LamySettingsDetailUsageInfoRow) {
    LamySettingsUsageInfoRowEnable = 0,
    LamySettingsUsageInfoRowPrivacy = 1,
    LamySettingsDiagnosticRowCount
};

typedef NS_ENUM(NSUInteger, LamySettingsDetailHelpRow) {
    LamySettingsDetailHelpRowHelp = 0,
    LamySettingsDetailHelpRowCount
};

@interface LamyModelConnectViewController () <PressToConnectViewControllerDelegate>

@property (nonatomic) BOOL pressToConnectAttemptInProgress;
@property IBOutlet NSLayoutConstraint *customCellLeftMarginStylus;
@property IBOutlet NSLayoutConstraint *customCellLeftMarginDiagnostics;


@end

@implementation LamyModelConnectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.stylusManager = [LamyStylusManager sharedInstance];
//    [self updateViewWithConnectionStatus:self.stylusManager.connectionStatus];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionChangeNotification:) name:LamyStylusManagerDidChangeConnectionStatus object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendlyNameChanged:) name:LamyStylusManagerDidChangeStylusFriendlyName object:nil];
    
    self.tableView.contentInset = UIEdgeInsetsMake(33 - 18, 0, 0, 0); // add top margin to container view to match spacing between headers.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateField {
    [self updateStylusCellWithFriendlyName:self.stylusManager.stylusFriendlyName];
    self.modelNameLabel.text = self.stylusManager.stylusModelFriendlyName;
    self.serialNumberLabel.text = self.stylusManager.serialNumber;
    self.firmwareVersionLabel.text = self.stylusManager.firmwareVersion;
    self.hardwareVersionLabel.text = self.stylusManager.hardwareVersion;
    self.adonitSDKVersionLabel.text = [NSString stringWithFormat:@" %@ (%@)",self.stylusManager.SDKVersion,self.stylusManager.SDKBuildVersion];
    self.configVersionLabel.text = self.stylusManager.ConfigVersion;
    self.batteryLabel.text = [[@(self.stylusManager.batteryLevel) stringValue] stringByAppendingString:@"%"];
    
    if ([self.stylusManager stylusShortcutButtonCount] > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            LamyShortcut *shortcutA = self.stylusManager.button1Shortcut;
            if (shortcutA) {
                self.shortcutALabel.text = shortcutA.descriptiveText;
            }

            LamyShortcut *shortcutB = self.stylusManager.button2Shortcut;
            if (shortcutB) {
                self.shortcutBLabel.text = shortcutB.descriptiveText;
            }
        });
    }
    
    
    
//    switch (self.stylusManager.writingStyle) {
//        case LamyWritingStyleRightAverage:
//            self.writingStyleLabel.text = NSLocalizedString(@"Right Average", @"Right Average Writing Style");
//            break;
//        case LamyWritingStyleRightHorizontal:
//            self.writingStyleLabel.text = NSLocalizedString(@"Right Horizontal", @"Right Horizontal Writing Style");
//            break;
//        case LamyWritingStyleRightVertical:
//            self.writingStyleLabel.text = NSLocalizedString(@"Right Vertical", @"Right Veritcal Writing Style");
//            break;
//        case LamyWritingStyleLeftAverage:
//            self.writingStyleLabel.text = NSLocalizedString(@"Left Average", @"Left Average Writing Style");
//            break;
//        case LamyWritingStyleLeftHorizontal:
//            self.writingStyleLabel.text = NSLocalizedString(@"Left Horizontal", @"Left Horizontal Writing Style");
//            break;
//        case LamyWritingStyleLeftVertical:
//            self.writingStyleLabel.text = NSLocalizedString(@"Left Vertical", @"Left Vertical Writing Style");
//            break;
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.stylusManager.isStylusConnected) {
        [self updateField];
    }
}

- (void)friendlyNameChanged:(NSNotification *)notification
{
    NSString *friendlyName = notification.userInfo[LamyStylusManagerDidChangeStylusFriendlyNameNameKey];
    [self updateStylusCellWithFriendlyName:friendlyName];
}

- (void)updateStylusCellWithFriendlyName:(NSString *)friendlyName
{
    self.stylusLabel.text = friendlyName;
}

#pragma mark - Table view data source

- (IBAction)openPrivacyPolicy:(id)sender
{
    [self.stylusManager launchPrivacyPolicyPage];
}

- (IBAction)launchHelp:(id)sender
{
    [self.stylusManager launchHelpAndShowAlertOnError:YES];
}

- (IBAction)disconnectButtonPressed:(id)sender
{
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
       
        // Let's highlight the disconnect cell to at least let people know they have successfully started a disconnect.
        UITapGestureRecognizer *tapGesture = sender;
        if ([tapGesture.view.superview isKindOfClass:[UITableViewCell class]]) {
            // gesture on contentView on TableviewCell
            UITableViewCell *cell = (UITableViewCell *) tapGesture.view.superview;
            
            [cell setHighlighted:YES];
        }
    }
    
    [self.stylusManager disconnectStylus];
}

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if (![self.stylusManager isStylusConnected]) {
        return 1;
    }
    return [super numberOfSectionsInTableView:tableView];
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == LamySettingsDetailSectionStylus) {
        return self.stylusManager.stylusShortcutButtonCount + 8;
    }
    if (section == LamySettingsDetailSectionConnect) {
        if ([self.stylusManager isEnabled]) {
            return 2;
        } else {
            return 1;
        }
    }
  
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *title = [super tableView:tableView titleForHeaderInSection:section];
    return (title.length > 0) ? 33 : 0.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == LamySettingsDetailSectionConnect) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (indexPath.row == 0) {
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            if ([self.stylusManager isEnabled]) {
                [switchView setOn:YES animated:NO];
            } else {
                [switchView setOn:NO animated:NO];
            }
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        }
    }
    else if (indexPath.section == LamySettingsDetailSectionStylus) {
        if ([cell.textLabel.text isEqualToString:@"Button 1"]) {
            if (self.stylusManager.shortcuts.count == 0) {
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.accessoryType = UITableViewCellAccessoryNone;
                self.shortcutALabel.text = @"Disabled";
            } else {
                [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.textColor = [UIColor lamyDetailTextColor];
            }
        } else if ([cell.textLabel.text isEqualToString:@"Button 2"]) {
            if (self.stylusManager.shortcuts.count == 0) {
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.accessoryType = UITableViewCellAccessoryNone;
                self.shortcutBLabel.text = @"Disabled";
            } else {
                [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.textColor = [UIColor lamyDetailTextColor];
            }
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"ButtonAShortcutSettingsSegue"]) {
        ShortcutButtonsTableViewController *shortcutController = (ShortcutButtonsTableViewController*)segue.destinationViewController;
        shortcutController.buttonNumber = 1;
    } else if ([segue.identifier isEqualToString:@"ButtonBShortcutSettingsSegue"]) {
        ShortcutButtonsTableViewController *shortcutController = (ShortcutButtonsTableViewController*)segue.destinationViewController;
        shortcutController.buttonNumber = 2;
    } else if ([segue.identifier isEqualToString:@"EmbedPressToConnectHeaderSegue"]) {
        PressToConnectViewController *viewController = segue.destinationViewController;
        viewController.delegate = self;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"ButtonAShortcutSettingsSegue"]) {
        if (self.stylusManager.shortcuts.count == 0) {
            return NO;
        }
    } else if ([identifier isEqualToString:@"ButtonBShortcutSettingsSegue"]) {
        if (self.stylusManager.shortcuts.count == 0) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - state updates

- (IBAction)enableDiagnosticsSwitchValueDidChange:(id)sender
{
    if (self.enableDiagnosticsSwitch.isOn == self.stylusManager.reportDiagnosticData) {
        return;
    }
    self.stylusManager.reportDiagnosticData = self.enableDiagnosticsSwitch.isOn;
}

- (void)connectionChangeNotification:(NSNotification *)notification
{
    LamyConnectionStatus connectionStatus = [notification.userInfo[LamyStylusManagerDidChangeConnectionStatusStatusKey] unsignedIntegerValue];
    [self updateViewWithConnectionStatus:connectionStatus];
}

- (void)updateViewWithConnectionStatus:(LamyConnectionStatus)connectionStatus
{
    if (connectionStatus == LamyConnectionStatusConnected || connectionStatus == LamyConnectionStatusSwapStylusNotSupportThePlatform) {
        [self updateHelpLabelWithModelName:self.stylusManager.stylusModelFriendlyName];
        [self updateField];
        if (connectionStatus == LamyConnectionStatusConnected) {
            [self.tableView reloadData];
        }
    } else if (!self.pressToConnectAttemptInProgress) {
        [self.tableView reloadData];
    }
}

- (void)updateHelpLabelWithModelName:(NSString *)modelName
{
    self.helpLabel.text = [modelName stringByAppendingString:@" Help"];
}

- (void)applyColorSchemeToCell:(UITableViewCell *)cell
{
    
    if ([cell.contentView.subviews containsObject:self.disconnectLabel]) {
        self.disconnectLabel.textColor = [UIColor lamyPrimaryColor];
    }
    
    if ([self.tableView respondsToSelector:@selector(layoutMargins)]) {
        self.customCellLeftMarginStylus.constant = self.tableView.layoutMargins.left;
        self.customCellLeftMarginDiagnostics.constant = self.tableView.layoutMargins.left;
    }
}

- (void)switchChanged:(id)sender {
    UISwitch *switchControl = sender;
    if (switchControl.on) {
        [self.stylusManager enable];
    } else {
        [self.stylusManager disable];
    }
    [self.tableView reloadData];
}

#pragma mark - JotPressToDisconnectViewControllerDelegate

- (void)pressToConnectControllerDidBeginConnectionAttempt:(PressToConnectViewController *)controller
{
    self.pressToConnectAttemptInProgress = YES;
}

- (void)pressToConnectControllerDidEndConnectionAttempt:(PressToConnectViewController *)controller
{
    self.pressToConnectAttemptInProgress = NO;
}

@end

