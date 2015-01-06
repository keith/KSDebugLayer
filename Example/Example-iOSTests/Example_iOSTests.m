@import UIKit;
@import XCTest;
#import <FBSnapshotTestCase/FBSnapshotTestCase.h>

@interface Example_iOSTests : FBSnapshotTestCase

@end

@implementation Example_iOSTests

- (void)setUp
{
    [super setUp];
//    self.recordMode = YES;
}

- (void)testMainView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    FBSnapshotVerifyView(viewController.view, @"MainView");
}

@end
