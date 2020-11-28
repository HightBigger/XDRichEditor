//
//  XDRichTextObject.m
//  XDRichEditor
//
//  Created by xiaoda on 2020/10/29.
//

#import "XDRichTextObject.h"

NSString * const ImagePlaceholderTag = @"\U0000fffc";

@implementation XDRichTextEditorConfig

@end

@implementation XDRichTextImageAttach : NSObject

- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    
    if (self)
    {
        self.url = url;
        
    }
    return self;
}

@end

@implementation XDRichTextObject

@end
