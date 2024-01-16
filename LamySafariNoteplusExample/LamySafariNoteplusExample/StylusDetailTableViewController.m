
#import "StylusDetailTableViewController.h"
#import "ShortcutButtonsTableViewController.h"


@interface StylusDetailTableViewController ()

@property IBOutlet NSLayoutConstraint *customCellLeftMarginName;
@property IBOutlet NSLayoutConstraint *customCellLeftMarginBattery;
@property (weak, nonatomic) IBOutlet UILabel *shortcutALabel;
@property (weak, nonatomic) IBOutlet UILabel *shortcutBLabel;
@property (weak, nonatomic) IBOutlet UILabel *writingStyleLabel;

@end

@implementation StylusDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionChangeNotification:) name:LamyStylusManagerDidChangeConnectionStatus object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)connectionChangeNotification:(NSNotification *)notification
{
    LamyConnectionStatus connectionStatus = [notification.userInfo[LamyStylusManagerDidChangeConnectionStatusStatusKey] unsignedIntegerValue];
    if (connectionStatus == LamyConnectionStatusDisconnected) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)applyColorSchemeToCell:(UITableViewCell *)cell
{
    if ([self.tableView respondsToSelector:@selector(layoutMargins)]) {
        self.customCellLeftMarginName.constant = self.tableView.layoutMargins.left;
        self.customCellLeftMarginBattery.constant = self.tableView.layoutMargins.left;
    }
}

- (void)updateViewWithAppearanceSettings
{
    
}

- (IBAction)disconnectTapped:(UITapGestureRecognizer *)sender
{
    [[LamyStylusManager sharedInstance] disconnectStylus];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ButtonAShortcutSettingsSegue"]) {
        ShortcutButtonsTableViewController *shortcutController = (ShortcutButtonsTableViewController*)segue.destinationViewController;
        shortcutController.buttonNumber = 1;
    } else if ([segue.identifier isEqualToString:@"ButtonBShortcutSettingsSegue"]) {
        ShortcutButtonsTableViewController *shortcutController = (ShortcutButtonsTableViewController*)segue.destinationViewController;
        shortcutController.buttonNumber = 2;
    }
}

- (IBAction)openPrivacyPolicy:(id)sender
{
    [[LamyStylusManager sharedInstance] launchPrivacyPolicyPage];
}

- (IBAction)launchHelp:(id)sender
{
    [[LamyStylusManager sharedInstance] launchHelpAndShowAlertOnError:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.stylusNameTextField.text = [LamyStylusManager sharedInstance].stylusFriendlyName;
    self.modelNameLabel.text = [LamyStylusManager sharedInstance].stylusModelFriendlyName;
    self.serialNumberLabel.text = [LamyStylusManager sharedInstance].serialNumber;
    self.firmwareVersionLabel.text = [LamyStylusManager sharedInstance].firmwareVersion;
    self.hardwareVersionLabel.text = [LamyStylusManager sharedInstance].hardwareVersion;
    self.adonitSDKVersionLabel.text = [NSString stringWithFormat:@" %@ (%@)",[LamyStylusManager sharedInstance].SDKVersion,[LamyStylusManager sharedInstance].SDKBuildVersion];
    self.configVersionLabel.text = [LamyStylusManager sharedInstance].ConfigVersion;
    self.batteryLabel.text = [[@([LamyStylusManager sharedInstance].batteryLevel) stringValue] stringByAppendingString:@"%"];
    self.shortcutALabel.text = [LamyStylusManager sharedInstance].button1Shortcut.descriptiveText;
    self.shortcutBLabel.text = [LamyStylusManager sharedInstance].button2Shortcut.descriptiveText;
    
    self.helpLabel.text = [[[LamyStylusManager sharedInstance] stylusModelFriendlyName] stringByAppendingString:@" Help"];
    
//    switch ([LamyStylusManager sharedInstance].writingStyle) {
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

@end
