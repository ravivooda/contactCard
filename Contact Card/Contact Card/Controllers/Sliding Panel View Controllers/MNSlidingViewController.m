//
//  MNSlidingViewController.m
//  Contact Card
//
//  Created by Ravi Vooda on 08/02/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import "MNSlidingViewController.h"
#import "MNLeftSidePanelViewController.h"
#import "MEZoomAnimationController.h"

@interface MNSlidingViewController ()

@property (strong, nonatomic) UINavigationController *myContactsNavigationPath; // 1


@property (strong, nonatomic) MNLeftSidePanelViewController *leftSidePanelViewController;

@property (strong, nonatomic) MEZoomAnimationController *zoomingAnimationController;

@end

@implementation MNSlidingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.zoomingAnimationController = [[MEZoomAnimationController alloc] init];
    
    self.delegate = self.zoomingAnimationController;
}

-(void) awakeFromNib {
    [super awakeFromNib];
    [self setTopViewController:self.myContactsNavigationPath];
    [self setUnderLeftViewController:self.leftSidePanelViewController];
    
    self.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
    self.customAnchoredGestures = @[];
}

-(UINavigationController*) myContactsNavigationPath {
    if (!_myContactsNavigationPath) {
        _myContactsNavigationPath = [self.storyboard instantiateViewControllerWithIdentifier:@"myContactsNavigationPath"];
    }
    return _myContactsNavigationPath;
}

-(MNLeftSidePanelViewController*) leftSidePanelViewController {
    if (!_leftSidePanelViewController) {
        _leftSidePanelViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftSidePanel"];
    }
    return _leftSidePanelViewController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
