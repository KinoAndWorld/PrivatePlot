//
//  PPViewController.m
//  PrivatePlot
//
//  Created by Kino on 13-12-6.
//  Copyright (c) 2013年 kino. All rights reserved.
//

#import "PPViewController.h"

#import "PPParallaxViewController.h"
#import "PPImagePickerViewController.h"
//view
#import "FragmentTableCell.h"
#import "InputBarView.h"
#import <PXAlertView.h>

//db
#import "FragmentDao.h"

NS_ENUM(NSUInteger, InputState){
    InputStateNomal = 0,
    InputStateShow
};

static NSString *kCellIndentifier = @"FragmentTableCellIndentifier" ;

@interface PPViewController ()<PPParallaxViewControllerDelegate , ImagePickerDelegate>

@property (nonatomic, strong) PPParallaxViewController *parallaxTable;
@property (nonatomic, strong) UITableView *fragmentTable;
@property (nonatomic, strong) InputBarView *inputBar;

@property (nonatomic, assign) CGPoint lastOffset;
@property (nonatomic, assign) BOOL isDisplayKeyborad;

@property (nonatomic, assign) enum InputState state;

@property (nonatomic, strong) NSMutableArray *fragments;

@end

@implementation PPViewController

#pragma mark - 初始化 

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    [self initBlock];
    [self initData];
}
/**
 *  初始化UI
 */
- (void)initUI{
    
    if ([CommonTool isIOS7]) {
        self.view.frame = CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    _lastOffset = CGPointZero;
    //self.view.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1.0];
    
    _parallaxTable = [[PPParallaxViewController alloc] initWithImage:[UIImage imageNamed:@"cat.jpg"] withDelegate:self];
    _parallaxTable.WindowHeight = 200;
    _parallaxTable.ImageHeight = 350;
    _parallaxTable.view.frame = CGRectMake(0, 0,
                                           CGRectGetWidth(self.view.frame),
                                           CGRectGetHeight(self.view.frame)-40);
    [self addChildViewController:_parallaxTable];
    [self.view addSubview:_parallaxTable.view];
    
    //[_parallaxTable.tableView registerClass:[FragmentTableCell class] forCellReuseIdentifier:kCellIndentifier];
    //[_parallaxTable.tableView registerNib:[UINib nibWithNibName:@"FragmentTableCell" bundle:nil] forCellReuseIdentifier:kCellIndentifier];
    //输入栏
    CGRect inputBarFrame = CGRectMake(0, App_Frame_Height - kInputBarViewHeight + 20,
                                      App_Frame_Width, kInputBarViewHeight);
    //开始编辑
    CustomBlock beginEditBlock = ^void(){
        _state = InputStateShow;
    };
    //结束
    CustomBlock endEditBlock = ^void(){
        _state = InputStateNomal;
    };
    _inputBar = [[InputBarView alloc] initWithFrame:inputBarFrame withBeginInput:beginEditBlock withEndInput:endEditBlock];
    [self.view addSubview:_inputBar];
}

- (void)initBlock{
    //添加内容
    CustomBlock finishEditBlock = ^void(){
        if ([_inputBar.textField.text length] == 0) {
            [CommonTool showMessage:@"还没写内容惹"];
            return;
        }
        [_inputBar.textField resignFirstResponder];
        
        Fragment *fragment = [[Fragment alloc] init];
        fragment.contentText = _inputBar.textField.text;
        fragment.postTime = [NSDate date];
        fragment.display = YES;
        [[FragmentDao shareInstance] insertRecord:fragment];
        //计算高度方便显示
        [fragment calcLabelHeightByLabelWidth:260];
        
        [CommonTool showMessage:@"添加成功^_^"];
        
        _inputBar.textField.text = @"";
        
        [_fragments addObject:fragment];
        
        if ([_fragments count] > 1) {
            NSIndexPath *indexPathBottom = [NSIndexPath indexPathForRow:[_fragments count]-2 inSection:1];
            [_parallaxTable.tableView scrollToRowAtIndexPath:indexPathBottom
                                            atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_fragments count]-1 inSection:1];
        
        [_parallaxTable.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [_parallaxTable.tableView scrollToRowAtIndexPath:indexPath
                                        atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
    };
    _inputBar.finishInputTextBlock = finishEditBlock;
    
    //选择图片
    CustomBlock pickImageBlock = ^void(){
        PPImagePickerViewController *pcikerVC = [[PPImagePickerViewController alloc] init];
        pcikerVC.delegate = self;
        [self presentViewController:pcikerVC animated:YES completion:nil];
    };
    _inputBar.startPickImageBlock = pickImageBlock;
}

- (void)initData{
    _fragments = [[[FragmentDao shareInstance] getAllRecord] mutableCopy];
    //统一计算一下高度
    for (Fragment *frg in _fragments) {
        if ([frg.contentText isEqualToString:@""]) continue;
        [frg calcLabelHeightByLabelWidth:260];
    }
    //[_parallaxTable.tableView reloadData];
}

#pragma mark - UIScrollView委托

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"滚啊滚");
    //[self.view endEditing:YES];
    if (_state == InputStateNomal) {
        _lastOffset = scrollView .contentOffset;
        
    }else if (_state == InputStateShow){
        //正在滑动
        if (scrollView.isDecelerating) {
            //暂停滚动
            scrollView.contentOffset = _lastOffset;
        }else{
            //隐藏掉InputView
            NSLog(@"取消了");
            [_inputBar.textField resignFirstResponder];
        }
    }
}

#pragma mark - Table 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float labelHeight = ((Fragment *)_fragments[indexPath.row]).labelHeight;
    NSLog(@"今次返回的高度是%f",80+labelHeight);
    return 80 + labelHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_fragments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FragmentTableCell *cell = [_parallaxTable.tableView fragmentListCell];
    Fragment *frg = _fragments[indexPath.row];
    [cell updateCellByModel:frg];
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteAEventByIndexPath:[NSArray arrayWithObject:indexPath]];
    }
}

- (void)deleteAEventByIndexPath:(NSArray *)indexPaths{
    [PXAlertView showAlertWithTitle:@"温馨提示"
                            message:@"删除就不能还原了喔"
                        cancelTitle:@"我再想想"
                         otherTitle:@"确定删鸟"
                         completion:^(BOOL cancel , NSInteger buttonIndex){
                             if (cancel) return ;
                             for (int i = [indexPaths count]-1; i >= 0; i--) {
                                 int frgIndex = ((NSIndexPath *)indexPaths[i]).row;
                                 Fragment *frg = _fragments[frgIndex];
                                 [[FragmentDao shareInstance] deleteRecord:frg];
                                 [_fragments removeObject:frg];
                             }
                             [_parallaxTable.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                             [CommonTool showMessage:@"删除完成╮(╯▽╰)╭"];
    }];
}

#pragma mark - Internal Methods

- (void)handleTap:(UIGestureRecognizer *)gesture {
    //NSLog(@"%@:%@", [self class], NSStringFromSelector(_cmd));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)presentSettingVC:(id)sender {
    
}

#pragma mark - imagePickerDelegate

- (void)imagePickerDidCapture:(PPImagePickerViewController *)imagePickerVC withImage:(UIImage *)image{
    NSLog(@"%f,%f",image.size.height,image.size.width);
}

@end
