//
//  XDFontSlider.h
//  XDRichEditor
//
//  Created by xiaoda on 2020/11/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDFontSlider : UIView

@property (nonatomic, assign) CGFloat percent;

@property (nonatomic, copy) void(^percentChangedBlock) (CGFloat percent);

@end

NS_ASSUME_NONNULL_END
