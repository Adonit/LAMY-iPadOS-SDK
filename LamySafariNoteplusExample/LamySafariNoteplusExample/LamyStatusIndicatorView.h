//
//  LamyStatusIndicatorView.h
//  LamySafariNoteplusSwiftExample
//
//  Copyright (c) 2014 Adonit, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LamyStatusIndicatorView : UIView

@property (nonatomic,weak) IBOutlet UILabel* rawPressureLabel;
@property (nonatomic,weak) IBOutlet UILabel* pressureLabel;
@property (nonatomic,weak) IBOutlet UISlider *scrollValue;
@property (nonatomic,weak) IBOutlet UILabel* stylusTapLabel;
@property (nonatomic,weak) IBOutlet UILabel* scrollValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* aTapLabel;
@property (nonatomic, weak) IBOutlet UILabel* bTapLabel;
@property (nonatomic, weak) IBOutlet UILabel* scrollData;
@property (nonatomic, weak) IBOutlet UISwitch* altitudeAngleEnable;
@property (nonatomic, weak) IBOutlet UISwitch* gestureEnable;
@property (nonatomic, weak) IBOutlet UILabel* altitudeAngleLabel;
@property (nonatomic, weak) IBOutlet UILabel* platformLabel;
- (void) setActivityMessage:(NSString *)activityMessage;
- (void) setConnectedStylusModel:(NSString *)stylusModelName;
- (void) jotScrollUpdate:(float)value;
- (void) lamyButton1Tap:(NSString *)text;
- (void) lamyButton2Tap:(NSString *)text;
- (void) setPlatformLabel:(UILabel *)platformLabel;
@end
