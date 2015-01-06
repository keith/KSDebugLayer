@import Foundation;

#if TARGET_OS_IPHONE
@import UIKit;
#import "UIColor+KSInverseColor.h"
#else
@import AppKit;
#import "NSColor+KSInverseColor.h"
#endif

#import "KSDebugLayer.h"

@implementation KSDebugLayer

- (void)visualizeAnchorPoint
{
    CGPoint anchor = self.anchorPoint;
    CGSize size = self.bounds.size;
    NSInteger x = (NSInteger)(anchor.x * size.width);
    NSInteger y = (NSInteger)(anchor.y * size.height);

    CALayer *anchorPointLayer = [CALayer layer];
    anchorPointLayer.bounds = CGRectMake(0, 0, 6, 6);
    anchorPointLayer.cornerRadius = 3;
    anchorPointLayer.position = CGPointMake(x, y);

    anchorPointLayer.backgroundColor = [self inverseColorForLayerWithSize:size
                                                                      AtX:x
                                                                        y:y];

    [self addSublayer:anchorPointLayer];
}

- (CGColorRef)inverseColorForLayerWithSize:(CGSize)size
                                       AtX:(NSInteger)x
                                         y:(NSInteger)y
{
    CGColorRef colorRef;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    size_t width = (size_t)size.width;
    size_t height = (size_t)size.height;
    CGBitmapInfo info = (CGBitmapInfo)kCGImageAlphaPremultipliedLast;
    CGContextRef contextRef = CGBitmapContextCreate(NULL, width, height,
                                                    8, 0, colorSpace, info);
    CGColorSpaceRelease(colorSpace);
    [self renderInContext:contextRef];

    CGImageRef image = CGBitmapContextCreateImage(contextRef);

    CGImageRelease(image);
    CGContextRelease(contextRef);
#if TARGET_OS_IPHONE
    return nil;
#else
    NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc]
                                  initWithCGImage:image];
    NSInteger flippedY = (NSInteger)(size.height - y);
    NSColor *color = [imageRep colorAtX:x y:flippedY];


    colorRef = [color ks_inverseColor];
#endif

    return colorRef;
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
#if TARGET_OS_IPHONE
    return [[UIColor purpleColor] CGColor];
#else
    return [[NSColor purpleColor] CGColor];
#endif
}

- (void)layoutSublayers
{
    [super layoutSublayers];

    [self visualizeAnchorPoint];
    [self visualizeBounds];
}

@end
