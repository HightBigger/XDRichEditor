//
//  XDRichEditorTextView.h
//  XDRichEditor
//
//  Created by xiaoda on 2020/11/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XDRichEditorTextView;
@protocol XDRichEditorTextViewDelegate <NSObject>
@optional

- (BOOL)textViewShouldDelete:(XDRichEditorTextView *)textView;
- (void)textViewWillDelete:(XDRichEditorTextView *)textView;
- (void)textViewDidDelete:(XDRichEditorTextView *)textView;

@end

@interface XDRichEditorTextView : UITextView

@property (nonatomic, weak) id<XDRichEditorTextViewDelegate> richTextViewDelegate;

@end

NS_ASSUME_NONNULL_END
