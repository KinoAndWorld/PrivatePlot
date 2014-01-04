//
//  InputBarView.m
//  PrivatePlot
//
//  Created by Kino on 13-12-6.
//  Copyright (c) 2013年 kino. All rights reserved.
//

#import "InputBarView.h"

#import "Fragment.h"

@implementation InputBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withBeginInput:(CustomBlock)beginBlock withEndInput:(CustomBlock)endBlock{
    self = [super initWithFrame:frame];
    if (self) {
        _beginInputTextBlock = beginBlock;
        _endInputTextBlock = endBlock;
        [self setupView];
    }
    return self;
}

- (void)setupView{
    
    /*_backgroundView = [[UIView alloc] initWithFrame:self.frame];
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 0.0;
    //添加手势
    UITapGestureRecognizer *tapGuest = [[UITapGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(tapBackGround:)];
    [_backgroundView addGestureRecognizer:tapGuest];
    [self addSubview:_backgroundView];*/
    //
    self.backgroundColor = [UIColor colorWithRed:0.8 green:0.9 blue:0.9 alpha:0.8];
    
    float contentY = 5; //CGRectGetMaxY(self.frame) - 30 - 5;
    _imagePickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _imagePickerButton.frame = CGRectMake(10, contentY, 30, 30);
    [_imagePickerButton setImage:[UIImage imageNamed:@"camera"]
                        forState:UIControlStateNormal];
    [_imagePickerButton setAdjustsImageWhenHighlighted:YES];
    [_imagePickerButton addTarget:self action:@selector(pickImage:)
                 forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_imagePickerButton];
    
    _textField = [[UITextField alloc] initWithFrame:
                  CGRectMake(CGRectGetMaxX(_imagePickerButton.frame) + 20, contentY, 200, 30)];
    _textField.delegate = self;
    _textField.borderStyle = UITextBorderStyleBezel;
    _textField.font = [UIFont systemFontOfSize:13.f];
    [self addSubview:_textField];
    
    _sendButtonl = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendButtonl.frame = CGRectMake(CGRectGetMaxX(_textField.frame) + 10, contentY, 40, 30);
    [_sendButtonl setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButtonl setTitleColor:[UIColor colorWithRed:0.0 green:0.3 blue:0.7 alpha:0.8]
                       forState:UIControlStateNormal];
    [_sendButtonl addTarget:self
                     action:@selector(sendAction:)
           forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sendButtonl];
    
    [self registerForKeyboardNotifications];
}

/**
 *  点击发送按钮
 *
 *  @param sender
 */
- (void)sendAction:(id)sender{
    if (_finishInputTextBlock) {
        _finishInputTextBlock();
    }
}

/**
 *  点击选择图片按钮
 *
 *  @param sender
 */
- (void)pickImage:(id)sender{
    if (_startPickImageBlock) {
        _startPickImageBlock();
    }
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardDidShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardDidHideNotification];
}

#pragma mark - GestureRecognizer

- (void)tapBackGround:(UIGestureRecognizer *)recoginizer{
    NSLog(@"点击背景");
}

#pragma mark - Observer
//键盘挡住
- (void) registerForKeyboardNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification *)notif{
    NSLog(@"键盘出现");
    NSDictionary *info = [notif userInfo];
    //NSLog(@"%@",info);
    NSValue* value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    [UIView animateWithDuration:0.2 animations:^(void){
        self.frame = CGRectMake(0, Main_Screen_Height - keyboardSize.height - CGRectGetHeight(self.frame),
                                Main_Screen_Width, kInputBarViewHeight);
        _backgroundView.alpha = 1.0;
    }];
    
}

- (void)keyboardWasHidden:(NSNotification *)notif{
    [UIView animateWithDuration:0.2 animations:^(void){
        self.frame = CGRectMake(0, Main_Screen_Height - kInputBarViewHeight,
                                Main_Screen_Width , kInputBarViewHeight);
    }];
}


#pragma mark - TextFiled 
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"开始编辑");
    _isDisplayingKeyborad = YES;
    //执行代码块
    _beginInputTextBlock();
    
    [UIView animateWithDuration:0.35 animations:^(void){
        self.frame = CGRectMake(0, Main_Screen_Height - 216 - CGRectGetHeight(self.frame),
                                Main_Screen_Width, kInputBarViewHeight);
    } completion:^(BOOL isfinish){
        
    }];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    _isDisplayingKeyborad = NO;
    //执行代码块
    _endInputTextBlock();
    [UIView animateWithDuration:0.2 animations:^(void){
        self.frame = CGRectMake(0, Main_Screen_Height - kInputBarViewHeight,
                                Main_Screen_Width , kInputBarViewHeight);
    }];
    return YES;
}

@end
