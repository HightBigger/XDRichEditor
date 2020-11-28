//
//  XDRichInputAccessoryView.h
//  XDRichEditor
//
//  Created by xiaoda on 2020/10/28.
//

#import <UIKit/UIKit.h>
#import "XDRichTextObject.h"

NS_ASSUME_NONNULL_BEGIN

@class XDRichInputAccessoryView;
@protocol XDRichInputAccessoryViewDelegate <NSObject>

- (void)richInputAccessoryViewWillResgin:(XDRichInputAccessoryView *)inputAccessoryView;

- (void)richInputAccessoryView:(XDRichInputAccessoryView *)inputAccessoryView
          didClickItemWithType:(XDRichTextInputType)inputType
             completionHandler:(void (^)(BOOL itemSelected))completionHandler;

@end

@interface XDRichInputAccessoryView : UIView

@property(nonatomic,weak) id<XDRichInputAccessoryViewDelegate> delegate;

+ (XDRichInputAccessoryView *)inputAccessoryViewWithItemTypes:(NSArray *)itemTypes;

/// 根据js返回的label数组更新toolbar上的按钮状态
/// @param itemLabels js返回的label数组
- (void)updateInputAccessoryItems:(NSArray*)itemLabels;


@end

NS_ASSUME_NONNULL_END
