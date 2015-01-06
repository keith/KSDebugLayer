#import "KSDebugLayer.h"

@implementation KSDebugLayer

- (void)visualizeAnchorPoint
{
    CGPoint anchor = self.anchorPoint;
    CGSize size = self.bounds.size;
    NSInteger x = (NSInteger)(anchor.x * size.width);
    NSInteger y = (NSInteger)(anchor.y * size.height);

    CALayer *anchorPointLayer = [CALayer layer];
    anchorPointLayer.backgroundColor = [NSColor blackColor].CGColor;
    anchorPointLayer.bounds = CGRectMake(0, 0, 6, 6);
    anchorPointLayer.cornerRadius = 3;
    anchorPointLayer.position = CGPointMake(x, y);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    size_t width = (size_t)size.width;
    size_t height = (size_t)size.height;
    CGBitmapInfo info = (CGBitmapInfo)kCGImageAlphaPremultipliedLast;
    CGContextRef contextRef = CGBitmapContextCreate(NULL, width, height,
                                                    8, 0, colorSpace, info);
    [self renderInContext:contextRef];

    CGImageRef image = CGBitmapContextCreateImage(contextRef);
    NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc]
                                  initWithCGImage:image];
    NSInteger flippedY = (NSInteger)(size.height - y);
    NSColor *color = [imageRep colorAtX:x y:flippedY];
    NSColor *inverseColor = [self inverseOfColor:color];
    anchorPointLayer.backgroundColor = inverseColor.CGColor;

    CGImageRelease(image);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(contextRef);

    [self addSublayer:anchorPointLayer];
}

- (void)visualizeBounds
{
    CGPoint anchor = self.anchorPoint;
    CGSize size = self.bounds.size;
    NSInteger x = (NSInteger)(anchor.x * size.width);
    NSInteger y = (NSInteger)(anchor.y * size.height);

    CALayer *boundsLayer = [CALayer layer];
    boundsLayer.borderWidth = 1.0f;
    boundsLayer.borderColor = [self boundsBorderColor];
    boundsLayer.bounds = self.bounds;
    boundsLayer.anchorPoint = self.anchorPoint;
    boundsLayer.position = CGPointMake(x, y);

    [self addSublayer:boundsLayer];
}

- (CGColorRef)boundsBorderColor
{
    return [[NSColor purpleColor] CGColor];
}

- (NSColor *)inverseOfColor:(NSColor *)color
{
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    if (!color || a == 0) {
        return [NSColor greenColor];
    }

    return [NSColor colorWithRed:ABS(1 - r)
                           green:ABS(1 - g)
                            blue:ABS(1 - b)
                           alpha:a];
}

- (void)layoutSublayers
{
    [super layoutSublayers];
    [self visualizeAnchorPoint];
    [self visualizeBounds];
}

@end
