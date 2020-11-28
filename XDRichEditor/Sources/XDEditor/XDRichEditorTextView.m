//
//  XDRichEditorTextView.m
//  XDRichEditor
//
//  Created by xiaoda on 2020/11/2.
//

#import "XDRichEditorTextView.h"

@implementation XDRichEditorTextView

- (void)deleteBackward
{
    BOOL shouldDelete = YES;
    if ([self.richTextViewDelegate respondsToSelector:@selector(textViewShouldDelete:)])
    {
        shouldDelete = [self.richTextViewDelegate textViewShouldDelete:self];
    }
    
    if (shouldDelete)
    {
        if ([self.richTextViewDelegate respondsToSelector:@selector(textViewWillDelete:)])
        {
           [self.richTextViewDelegate textViewWillDelete:self];
        }
        
        [super deleteBackward];
        
        if ([self.richTextViewDelegate respondsToSelector:@selector(textViewDidDelete:)])
        {
           [self.richTextViewDelegate textViewDidDelete:self];
        }
    }
}

@end
