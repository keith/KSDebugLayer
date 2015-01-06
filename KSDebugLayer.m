@import Foundation;

#if TARGET_OS_IPHONE
#define KSColor UIColor
@import UIKit;
#else
#define KSColor NSColor
@import AppKit;
#endif

#import "KSDebugLayer.h"

@implementation KSDebugLayer

- (void)layoutSublayers
{
    [super layoutSublayers];

    [self visualizeAnchorPoint];
    [self visualizeBounds];
}

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
    anchorPointLayer.borderWidth = 10;
    anchorPointLayer.borderColor = [self inverseColorForLayerWithSize:size
                                                                  AtX:x
                                                                    y:y];

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
    return [[KSColor purpleColor] CGColor];
}

#pragma mark - Heavy Lifting

- (CGColorRef)inverseColorForLayerWithSize:(CGSize)size
                                       AtX:(NSInteger)x
                                         y:(NSInteger)y
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    size_t width = (size_t)size.width;
    size_t height = (size_t)size.height;
    CGBitmapInfo info = (CGBitmapInfo)kCGImageAlphaPremultipliedLast;
    CGContextRef contextRef = CGBitmapContextCreate(NULL, width, height,
                                                    8, 0, colorSpace, info);
    CGColorSpaceRelease(colorSpace);
    [self renderInContext:contextRef];

    CGImageRef image = CGBitmapContextCreateImage(contextRef);
    return InverseColorFromImageAtPoint(image, x, y);
}

CGColorRef InverseColorFromImageAtPoint(CGImageRef image,
                                        NSInteger x,
                                        NSInteger y)
{
    CGContextRef context = CreateBitmapContext(image);
    if (!context) {
        CGImageRelease(image);
        return NULL;
    }

    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    CGRect rect = CGRectMake(0, 0, width, height);
    CGContextDrawImage(context, rect, image);
    unsigned char *data = CGBitmapContextGetData(context);
    CGContextRelease(context);
    CGImageRelease(image);

    if (data) {
        NSInteger offset = 4 * ((width * y) + x);
        NSInteger alpha = data[offset];
        NSInteger red = data[offset + 1];
        NSInteger green = data[offset + 2];
        NSInteger blue = data[offset + 3];

        free(data);
        return InverseColorFromRGBA(red / 255.0f,
                                 green / 255.0f,
                                 blue / 255.0f,
                                 alpha / 255.0f);
    }

    return NULL;
}

CGContextRef CreateBitmapContext(CGImageRef image)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (!colorSpace) {
        return NULL;
    }

    size_t pixelsWide = CGImageGetWidth(image);
    size_t pixelsHigh = CGImageGetHeight(image);
    NSInteger bitmapBytesPerRow = (pixelsWide * 4);
    NSInteger bitmapByteCount = (bitmapBytesPerRow * pixelsHigh);

    void *bitmapData = malloc(bitmapByteCount);
    if (!bitmapData) {
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }

    CGBitmapInfo info = (CGBitmapInfo)kCGImageAlphaPremultipliedFirst;
    CGContextRef context = CGBitmapContextCreate(bitmapData, pixelsWide,
                                                 pixelsHigh, 8,
                                                 bitmapBytesPerRow,
                                                 colorSpace, info);

    if (!context) {
        free(bitmapData);
    }

    CGColorSpaceRelease(colorSpace);

    return context;
}

CGColorRef InverseColorFromRGBA(CGFloat r, CGFloat g, CGFloat b, CGFloat a)
{
    if (a == 0) {
        return [[KSColor greenColor] CGColor];
    }

    return [[KSColor colorWithRed:ABS(1 - r)
                            green:ABS(1 - g)
                             blue:ABS(1 - b)
                            alpha:1] CGColor];
}

@end
