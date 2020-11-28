//
//  XDColorSlider.h
//  XDRichEditor
//
//  Created by xiaoda on 2020/11/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDColorSlider : UIView

@property (nonatomic, assign) CGFloat hvalue;

@property (nonatomic, copy) void(^ValueChangedBlock) (CGFloat hvalue);
@property (nonatomic, copy) void(^ColorChangedBlock) (UIColor *color);

@end

NS_ASSUME_NONNULL_END
