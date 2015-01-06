#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)a{
    CGSize size;
    CALayer *l;
    UIGraphicsBeginImageContext(size);

    [l renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

@end
