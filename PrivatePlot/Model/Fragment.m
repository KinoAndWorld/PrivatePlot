//
//  Fragment.m
//  PrivatePlot
//
//  Created by Kino on 13-12-7.
//  Copyright (c) 2013年 kino. All rights reserved.
//

#import "Fragment.h"

#import <CoreText/CoreText.h>

#define kCTFontAttributeName @"fontName"
#define kFontName @"Heiti SC"

@implementation Fragment

- (float)calcLabelHeightByLabelWidth:(float)labelWidth{
    NSMutableAttributedString *infoString = [[NSMutableAttributedString alloc] initWithString:self.contentText];
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)[UIFont fontWithName:kFontName size:14].fontName, 14, NULL);
    [infoString addAttribute:kCTFontAttributeName value:(__bridge id)(fontRef) range:NSMakeRange(0, [infoString length])];
    
    _labelHeight = [CommonTool getAttributedStringHeightWithString:infoString WidthValue:labelWidth];
    return _labelHeight;
}

@end