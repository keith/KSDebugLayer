#import "KSDebugLayer.h"
#import "ImageView.h"

@implementation ImageView

+ (Class)layerClass
{
    return [KSDebugLayer class];
}

@end
