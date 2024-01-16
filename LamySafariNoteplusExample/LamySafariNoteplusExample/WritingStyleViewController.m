//
//  WritingStyleViewController.m
//
//  Copyright (c) 2017 Adonit. All rights reserved.
//

#import "WritingStyleViewController.h"
#import "WritingStyleSelectionView.h"
#import "LamySDK.h"

@interface WritingStyleViewController ()
@property (weak) WritingStyleSelectionView *selectedView;
@property (nonatomic, weak) IBOutlet WritingStyleSelectionView *leftAverageSelectionView;
@property (nonatomic, weak) IBOutlet WritingStyleSelectionView *leftHorizontalSelectionView;
@property (nonatomic, weak) IBOutlet WritingStyleSelectionView *leftVerticalSelectionView;
@property (nonatomic, weak) IBOutlet WritingStyleSelectionView *rightAverageSelectionView;
@property (nonatomic, weak) IBOutlet WritingStyleSelectionView *rightHorizontalSelectionView;
@property (nonatomic, weak) IBOutlet WritingStyleSelectionView *rightVerticalSelectionView;

@property (nonatomic) CALayer *separatorContainerView;
@property (nonatomic) CALayer *verticalSeparatorView;
@property (nonatomic) CALayer *topHorizontalSeparatorView;
@property (nonatomic) CALayer *bottomHorizontalSeparatorView;
@end

const static CGFloat SeperatorInsetPercentage = 0.04;

@implementation WritingStyleViewController

- (void)viewDidLoad
{
    [self setupSeparatorViews];
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Writing Style", @"Writing Style View Controller Title");
//    switch ([LamyStylusManager sharedInstance].writingStyle) {
//        case LamyWritingStyleLeftAverage:
//            self.selectedView = self.leftAverageSelectionView;
//            break;
//        case LamyWritingStyleLeftHorizontal:
//            self.selectedView = self.leftHorizontalSelectionView;
//            break;
//        case LamyWritingStyleLeftVertical:
//            self.selectedView = self.leftVerticalSelectionView;
//            break;
//        case LamyWritingStyleRightAverage:
//            self.selectedView = self.rightAverageSelectionView;
//            break;
//        case LamyWritingStyleRightHorizontal:
//            self.selectedView = self.rightHorizontalSelectionView;
//            break;
//        case LamyWritingStyleRightVertical:
//            self.selectedView = self.rightVerticalSelectionView;
//            break;
//    }
    NSLog(@"self.selectedView == %@",self.selectedView);
    self.selectedView.selected = YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateViewWithAppearanceSettings];
    [self updateSeparatorFrames];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self updateSeparatorFrames];
}

-(NSBundle *)getResourcesBundle
{
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle bundleForClass:[self class]] URLForResource:@"AdonitSDK" withExtension:@"bundle"]];
    return bundle;
}

-(UIImage *)loadImageFromResourceBundle:(NSString *)imageName
{
    NSBundle *bundle = [self getResourcesBundle];
    NSString *imageFileName = [NSString stringWithFormat:@"%@.png",imageName];
    UIImage *image = [UIImage imageNamed:imageFileName inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}
#pragma mark - IBAction

- (IBAction)writingStyleTapped:(UITapGestureRecognizer *)recognizer
{
    WritingStyleSelectionView *tappedView = (WritingStyleSelectionView *)recognizer.view;
    self.selectedView.selected = NO;
    tappedView.selected = YES;
    self.selectedView = tappedView;
    LamyStylusManager *stylusManager = [LamyStylusManager sharedInstance];
    
//    if (self.selectedView == self.leftAverageSelectionView) {
//        stylusManager.writingStyle = LamyWritingStyleLeftAverage;
//    } else if (self.selectedView == self.leftHorizontalSelectionView) {
//        stylusManager.writingStyle = LamyWritingStyleLeftHorizontal;
//    } else if (self.selectedView == self.leftVerticalSelectionView) {
//        stylusManager.writingStyle = LamyWritingStyleLeftVertical;
//    } else if (self.selectedView == self.rightAverageSelectionView) {
//        stylusManager.writingStyle = LamyWritingStyleRightAverage;
//    } else if (self.selectedView == self.rightHorizontalSelectionView) {
//        stylusManager.writingStyle = LamyWritingStyleRightHorizontal;
//    } else if (self.selectedView == self.rightVerticalSelectionView) {
//        stylusManager.writingStyle = LamyWritingStyleRightVertical;
//    }
}

#pragma mark - Separators

- (void)setupSeparatorViews
{
    self.separatorContainerView = [[CALayer alloc]init];
    [self.view.layer addSublayer:self.separatorContainerView];
    
    self.verticalSeparatorView = [[CALayer alloc]init];
    [self.separatorContainerView addSublayer:self.verticalSeparatorView];
    
    self.topHorizontalSeparatorView = [[CALayer alloc]init];
    [self.separatorContainerView addSublayer:self.topHorizontalSeparatorView];
    
    self.bottomHorizontalSeparatorView = [[CALayer alloc]init];
    [self.separatorContainerView addSublayer:self.bottomHorizontalSeparatorView];
}

- (void)updateSeparatorFrames
{
    self.separatorContainerView.frame = self.view.bounds;
    self.verticalSeparatorView.frame = CGRectMake(self.separatorContainerView.bounds.size.width / 2.0, 0, 1.0, self.separatorContainerView.bounds.size.height);
    self.topHorizontalSeparatorView.frame = CGRectMake(0, (self.separatorContainerView.bounds.size.height / 3.0), self.separatorContainerView.bounds.size.width, 1.0);
    self.bottomHorizontalSeparatorView.frame = CGRectMake(0, (self.separatorContainerView.bounds.size.height / 3.0) * 2.0, self.separatorContainerView.bounds.size.width, 1.0);
    
    CGFloat horizontalInsetAmount = self.topHorizontalSeparatorView.bounds.size.width * SeperatorInsetPercentage;
    CGFloat verticalInsetAmount = self.verticalSeparatorView.bounds.size.height * SeperatorInsetPercentage;
    CGFloat insetAmount = MAX(horizontalInsetAmount, verticalInsetAmount);
    
    self.verticalSeparatorView.frame = CGRectInset(self.verticalSeparatorView.frame, 0, insetAmount);
    self.topHorizontalSeparatorView.frame = CGRectInset(self.topHorizontalSeparatorView.frame, insetAmount, 0);
    self.bottomHorizontalSeparatorView.frame = CGRectInset(self.bottomHorizontalSeparatorView.frame, insetAmount, 0);
}

#pragma mark - Selection Views

- (NSArray *)arrayOfSelectionViews
{
    if (self.leftHorizontalSelectionView && self.leftAverageSelectionView && self.leftVerticalSelectionView && self.rightHorizontalSelectionView && self.rightAverageSelectionView && self.rightVerticalSelectionView) {
        return @[self.leftHorizontalSelectionView, self.leftAverageSelectionView, self.leftVerticalSelectionView, self.rightHorizontalSelectionView, self.rightAverageSelectionView, self.rightVerticalSelectionView];
    } else {
        return nil;
    }
}

- (void)updateViewWithAppearanceSettings
{
    
    self.view.backgroundColor = [UIColor lamySecondaryColor];
   
    [self setLineSeparatorColor:[UIColor lamySeparatorColor]];
    [self setSelectionViewsUnSelectedColor:[UIColor lamySeparatorColor]];
    [self setSelectionViewsSelectedColor:[UIColor lamyPrimaryColor]];
}

- (void)setSelectionViewsSelectedColor:(UIColor *)selectedColor
{
    for (WritingStyleSelectionView *selectionView in [self arrayOfSelectionViews]) {
        selectionView.selectedColor = selectedColor;
    }
}

- (void)setSelectionViewsUnSelectedColor:(UIColor *)unSelectedColor
{
    for (WritingStyleSelectionView *selectionView in [self arrayOfSelectionViews]) {
        selectionView.unSelectedColor = unSelectedColor;
    }
}

- (void)setLineSeparatorColor:(UIColor *)seperatorColor
{
    self.verticalSeparatorView.backgroundColor = seperatorColor.CGColor;
    self.topHorizontalSeparatorView.backgroundColor = seperatorColor.CGColor;
    self.bottomHorizontalSeparatorView.backgroundColor = seperatorColor.CGColor;
}

@end
