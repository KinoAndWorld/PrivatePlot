//
//  PPParallaxViewController.m
//  PrivatePlot
//
//  Created by Kino on 13-12-7.
//  Copyright (c) 2013年 kino. All rights reserved.
//

#import "PPParallaxViewController.h"

@interface PPParallaxViewController ()

@end

@implementation PPParallaxViewController


- (id)initWithImage:(UIImage *)image {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        [self initalizeView:image withDelegate:nil];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image withDelegate:(id<PPParallaxViewControllerDelegate>)delegete{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        [self initalizeView:image withDelegate:delegete];
    }
    return self;
}

- (void)initalizeView:(UIImage *)image withDelegate:(id<PPParallaxViewControllerDelegate>)delegate{
    _delegate = delegate;
    UIScrollView *scrollView = nil;
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewForBackgroundView:)]) {
        scrollView = [_delegate scrollViewForBackgroundView:self];
    }
    
    _imageScroller = (scrollView == nil ? [[UIScrollView alloc] initWithFrame:CGRectZero] : scrollView);
    _imageScroller.backgroundColor                  = [UIColor clearColor];
    _imageScroller.showsHorizontalScrollIndicator   = NO;
    _imageScroller.showsVerticalScrollIndicator     = NO;
    
    _imageView = [[UIImageView alloc] initWithImage:image];
    [_imageScroller addSubview:_imageView];
    
    _tableView = [[UITableView alloc] init];
    _tableView.backgroundColor              = [UIColor clearColor];
    _tableView.dataSource                   = self;
    _tableView.delegate                     = self;
    _tableView.separatorStyle               = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_imageScroller];
    [self.view addSubview:_tableView];
}

#pragma mark - Parallax effect

- (void)updateOffsets {
    CGFloat yOffset   = _tableView.contentOffset.y;
    CGFloat threshold = _ImageHeight - _WindowHeight;
    
    if (yOffset > -threshold && yOffset < 0) {
        _imageScroller.contentOffset = CGPointMake(0.0, floorf(yOffset / 2.0));
    } else if (yOffset < 0) {
        _imageScroller.contentOffset = CGPointMake(0.0, yOffset + floorf(threshold / 2.0));
    } else {
        _imageScroller.contentOffset = CGPointMake(0.0, yOffset);
    }
}

#pragma mark - View Layout
- (void)layoutImage {
    CGFloat imageWidth   = _imageScroller.frame.size.width;
    CGFloat imageYOffset = floorf((_WindowHeight  - _ImageHeight) / 2.0);
    CGFloat imageXOffset = 0.0;
    
    _imageView.frame             = CGRectMake(imageXOffset, imageYOffset, imageWidth, _ImageHeight);
    _imageScroller.contentSize   = CGSizeMake(imageWidth, self.view.bounds.size.height);
    _imageScroller.contentOffset = CGPointMake(0.0, 0.0);
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGRect bounds = self.view.bounds;
    
    _imageScroller.frame        = CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height);
    _tableView.backgroundView   = nil;
    _tableView.frame            = bounds;
    
    [self layoutImage];
    [self updateOffsets];
}


#pragma mark - Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) { return 1;  }
    else{
        if (_delegate){
            return [_delegate tableView:tableView numberOfRowsInSection:section];
        }
        return 26;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) { return _WindowHeight; }
    else                        {
        if (_delegate){
            return [_delegate tableView:tableView heightForRowAtIndexPath:indexPath];
        }
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellReuseIdentifier   = @"RBParallaxTableViewCell";
    static NSString *windowReuseIdentifier = @"RBParallaxTableViewWindow";
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:windowReuseIdentifier];
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:windowReuseIdentifier];
            cell.backgroundColor             = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle              = UITableViewCellSelectionStyleNone;
        }
    } else {
        //委托
        if (_delegate){
            return [_delegate tableView:tableView cellForRowAtIndexPath:indexPath];
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
                cell.contentView.backgroundColor = [UIColor clearColor];
                cell.selectionStyle              = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = [NSString stringWithFormat:@"%d-cell-content",indexPath.row];
            }
        }
    }
    return cell;
}

#pragma mark - Table View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateOffsets];
    if (_delegate){
        return [_delegate scrollViewDidScroll:scrollView];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate){
        return [_delegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    }
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate){
        return [_delegate tableView:tableView canEditRowAtIndexPath:indexPath];
    }
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate){
        return [_delegate tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

@end
