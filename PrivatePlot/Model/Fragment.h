//
//  Fragment.h
//  PrivatePlot
//
//  Created by Kino on 13-12-7.
//  Copyright (c) 2013年 kino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fragment : NSObject

@property (nonatomic, assign)   NSUInteger ID;
@property (nonatomic, copy)     NSString *contentText;
@property (nonatomic, strong)   NSData *contentImageData;
@property (nonatomic, strong)   NSDate *postTime;
@property (nonatomic, assign)   BOOL display;
@property (nonatomic, copy)     NSString *remark;

//Extend variable for View
@property (nonatomic, assign, readonly)   float labelHeight;

/**
 *  计算文字的高度
 *
 *  @param labelWidth 传入宽度
 */
- (float)calcLabelHeightByLabelWidth:(float)labelWidth;

@end
