//
//  ShortcutButtonsTableViewController.m
//
//  Copyright (c) 2017 Adonit. All rights reserved.
//

#import "ShortcutButtonsTableViewController.h"
#import "LamySDK.h"

@interface ShortcutButtonsTableViewController ()
@property LamyShortcut *currentShortcut;
@end

@implementation ShortcutButtonsTableViewController

- (void)setButtonNumber:(NSUInteger)buttonNumber
{
    // TODO: update the image
    _buttonNumber = buttonNumber;
    LamyStylusManager *stylusManager = [LamyStylusManager sharedInstance];
    switch (buttonNumber) {
        case 1:
            self.currentShortcut = stylusManager.button1Shortcut;
            self.title = NSLocalizedString(@"Button 1", @"Button 1 shortcut screen title");
            break;
        case 2:
            self.currentShortcut = stylusManager.button2Shortcut;
            self.title = NSLocalizedString(@"Button 2", @"Button 2 shortcut screen title");
            break;
        default:
            self.currentShortcut = nil;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [LamyStylusManager sharedInstance].shortcuts.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LamyShortcut *shortcut = [LamyStylusManager sharedInstance].shortcuts[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShortcutEntryCell"];
    cell.textLabel.text = shortcut.descriptiveText;
    
    if (shortcut == self.currentShortcut) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [self applyColorSchemeToCell:cell];
    
    return cell;
}

- (void)applyColorSchemeToCell:(UITableViewCell *)cell
{
    for (UIView *subview in cell.contentView.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subview;
            if ([label isEqual:cell.detailTextLabel]) {
                label.textColor = [UIColor lamyDetailTextColor];
            } else {
                label.textColor = [UIColor lamyTextColor];
            }
        } else if ([subview isKindOfClass:[UISwitch class]]) {
            UISwitch *cellSwitch = (UISwitch *)subview;
            
//            if (self.switchOnStateColor) {
//                cellSwitch.onTintColor = self.switchOnStateColor;
//            }
            cellSwitch.tintColor = [UIColor lamySeparatorColor];
            // tinting the thumb switch also removes shadows, so abort for now.
            //cellSwitch.thumbTintColor = self.tertiaryColor;
        }
        subview.backgroundColor = [UIColor clearColor];
    }
    
    cell.tintColor = [UIColor lamyPrimaryColor];
    cell.backgroundColor = [UIColor lamyTableViewCellBackgroundColor];
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    selectedBackgroundView.backgroundColor = [UIColor lamySelectedTableViewCellColor];
    cell.selectedBackgroundView = selectedBackgroundView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.currentShortcut = [LamyStylusManager sharedInstance].shortcuts[indexPath.row];
    

    switch (self.buttonNumber) {
        case 1:
            [LamyStylusManager sharedInstance].button1Shortcut = self.currentShortcut;
            break;
        case 2:
            [LamyStylusManager sharedInstance].button2Shortcut = self.currentShortcut;
            break;
        default:
            break;
    }

    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:[self arrayOfIndexPathsForShortCuts] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
}

- (NSArray *) arrayOfIndexPathsForShortCuts
{
    NSMutableArray *arrayOfShortcuts = [NSMutableArray array];
    NSInteger numberOfShortcuts = [self.tableView numberOfRowsInSection:0];
    
    for (NSInteger counter = 0; counter < numberOfShortcuts; counter++) {
        [arrayOfShortcuts addObject:[NSIndexPath indexPathForRow:counter inSection:0]];
    }
    return arrayOfShortcuts;
}

@end
