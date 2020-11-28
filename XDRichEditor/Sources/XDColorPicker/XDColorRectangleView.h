//
//  XDColorRectangleView.h
//  XDRichEditor
//
//  Created by xiaoda on 2020/11/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDColorRectangleView : UIView

@property (nonatomic, assign) CGFloat hvalue;

@property (nonatomic, assign) CGPoint svvalue;

@property (nonatomic, strong) UIColor *curColor;

@property (nonatomic, copy) void(^colorChangedBlock) (UIColor *color);

@end

NS_ASSUME_NONNULL_END
