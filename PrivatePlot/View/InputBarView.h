//
//  InputBarView.h
//  PrivatePlot
//
//  Created by Kino on 13-12-6.
//  Copyright (c) 2013年 kino. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSUInteger kInputBarViewHeight = 40;

typedef void (^CustomBlock)(void);

@interface InputBarView : UIView<UITextFieldDelegate>

@property (nonatomic ,strong) UIView *backgroundView;

@property (nonatomic, strong) UIButton *imagePickerButton;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIButton *sendButtonl;

@property (nonatomic, assign ) BOOL isDisplayingKeyborad;

@property (nonatomic, copy) CustomBlock beginInputTextBlock;

@property (nonatomic, copy) CustomBlock endInputTextBlock;

@property (nonatomic, copy) CustomBlock finishInputTextBlock;

@property (nonatomic, copy) CustomBlock startPickImageBlock;

- (id)initWithFrame:(CGRect)frame withBeginInput:(CustomBlock)beginBlock withEndInput:(CustomBlock)endBlock;


@end
