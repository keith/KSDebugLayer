# KSDebugLayer

A `CALayer` subclass to visualize the `anchorPoint` and `bounds` of
the layer. Specifically useful for handling off-center animations.

![](https://raw.githubusercontent.com/Keithbsmiley/KSDebugLayer/master/Example/ExampleTests/screenshot.png)

## Example iOS Usage

In your `UIView` subclass while debugging:

```objective-c
+ (Class)layerClass
{
    return [KSDebugLayer class];
}
```

## Example OS X Usage

On the desired `NSView` while debugging:

```objective-c
view.layer = [KSDebugLayer layer];
[view updateLayer];
```

### Resources

- <https://developer.apple.com/library/ios/qa/qa1509/_index.html>
- <http://stackoverflow.com/questions/448125/how-to-get-pixel-data-from-a-uiimage-cocoa-touch-or-cgimage-core-graphics>
- <http://stackoverflow.com/questions/17671398/visualizing-the-anchor-point-of-a-uiimageview/17673965#17673965>
