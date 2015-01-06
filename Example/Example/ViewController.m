#import "KSDebugLayer.h"
#import "ViewController.h"

@interface ViewController ()

@property (weak) IBOutlet NSImageView *imageView;

@end

@implementation ViewController

- (void)viewWillAppear
{
    [super viewWillAppear];

    CGPoint anchorPoint = CGPointMake(0.5, 0.5);
    self.imageView.layer = [KSDebugLayer layer];
    self.imageView.layer.anchorPoint = anchorPoint;
    [self.imageView updateLayer];
}

@end
