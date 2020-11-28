//
//  UIImage+XDExtension.m
//  XDRichEditor
//
//  Created by xiaoda on 2020/11/23.
//

#import "UIImage+XDExtension.h"
#import "UIColor+XDExtension.h"

@implementation UIImage (XDExtension)

static NSMutableDictionary<NSString *, UIImage *> *colorImages = nil;

+ (NSMutableDictionary<NSString *, UIImage *> *)colorImages
{
    if (!colorImages)
    {
        colorImages = [NSMutableDictionary dictionary];
    }
    
    return colorImages;
}

// 生成1个像素纯色图
+ (UIImage *)imageWithColor:(UIColor *)color
{
    UIImage *image = self.colorImages[color.description];
    if (!image)
    {
        CGRect rect = CGRectMake(0, 0, 1, 1);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return image;
}

+ (UIImage *)imageWithHue:(CGFloat)hue
{
    void* data = malloc(256 * 256 * 4);
    if (data == nil)
        return nil;
    
    CGContextRef context = [self createBGRxImageContext:256 height:256 data:data];
    
    if (context == nil) {
        free(data);
        return nil;
    }
    
    UInt8* dataPtr = data;
    size_t rowBytes = CGBitmapContextGetBytesPerRow(context);
    
    XDRGBStruct rgb = [UIColor rgbFromHue:hue];
    
    UInt8 r_s = (UInt8) ((1.0f - rgb.r) * 255);
    UInt8 g_s = (UInt8) ((1.0f - rgb.g) * 255);
    UInt8 b_s = (UInt8) ((1.0f - rgb.b) * 255);
    
    for (int s = 0; s < 256; ++s) {
        register UInt8* ptr = dataPtr;
        
        register unsigned int r_hs = 255 - [self blend:s percentIn255:r_s];
        register unsigned int g_hs = 255 - [self blend:s percentIn255:g_s];
        register unsigned int b_hs = 255 - [self blend:s percentIn255:b_s];
        
        for (register int v = 255; v >= 0; --v) {
            ptr[0] = (UInt8) (v * b_hs >> 8);
            ptr[1] = (UInt8) (v * g_hs >> 8);
            ptr[2] = (UInt8) (v * r_hs >> 8);
            
            ptr += rowBytes;
        }
        
        dataPtr += 4;
    }
    
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    free(data);
    
    return [UIImage imageWithCGImage:image];
}

+ (UIImage *)imageWithHSV:(NSMutableArray *)hsv barComponentIndex:(InfComponentIndex)barComponentIndex
{
    UInt8 data[256 * 4];
    
    // Set up the bitmap context for filling with color:
    CGContextRef context = [self createBGRxImageContext:1 height:256 data:data];
    
    if (context == nil)
        return nil;
    
    // Draw into context here:
    UInt8* ptr = CGBitmapContextGetData(context);
    if (ptr == nil) {
        CGContextRelease(context);
        return nil;
    }
    
    for (int x = 0; x < 256; ++x)
    {
        //绘制图片时，坐标在左下
        hsv[barComponentIndex] = @(1 - (float) x / 255.0f);
        
        CGFloat h = [hsv[0] floatValue] * 360.0f;
        CGFloat s = [hsv[1] floatValue];
        CGFloat v = [hsv[2] floatValue];
        
        XDRGBStruct rgb = [UIColor rgbFromH:h S:s V:v];
        
        ptr[0] = (UInt8) (rgb.b * 255.0f);
        ptr[1] = (UInt8) (rgb.g * 255.0f);
        ptr[2] = (UInt8) (rgb.r * 255.0f);
        
        ptr += 4;
    }
    
    // Return an image of the context's content:
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
        
    return [UIImage imageWithCGImage:image];
}

#pragma  mark - private
+ (CGContextRef)createBGRxImageContext:(int)width height:(int)height data:(void *)data
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGBitmapInfo kBGRxBitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst;
    // BGRA is the most efficient on the iPhone.
    
    CGContextRef context = CGBitmapContextCreate(data, width, height, 8, width * 4, colorSpace, kBGRxBitmapInfo);
    
    CGColorSpaceRelease(colorSpace);
    
    return context;
}

+ (UInt8)blend:(UInt8)value percentIn255:(UInt8)percentIn255
{
    return (UInt8) ((int) value * percentIn255 / 255);
}

@end
