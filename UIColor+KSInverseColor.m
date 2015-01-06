#import "UIColor+KSInverseColor.h"

@implementation UIColor (KSInverseColor)

- (CGColorRef)ks_inverseColor
{
    CGFloat r, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    if (!self || a == 0) {
        return [[UIColor greenColor] CGColor];
    }

    return [[UIColor colorWithRed:ABS(1 - r)
                            green:ABS(1 - g)
                             blue:ABS(1 - b)
                            alpha:a] CGColor];
}

@end
