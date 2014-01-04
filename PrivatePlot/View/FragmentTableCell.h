//
//  FragmentTableCell.h
//  PrivatePlot
//
//  Created by Kino on 13-12-6.
//  Copyright (c) 2013年 kino. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Fragment;

@interface FragmentTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *backgroundCustomView;

@property (weak, nonatomic) IBOutlet UIButton *faceImageButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
- (IBAction)faceButtonTap:(id)sender;

- (void)updateCellByModel:(Fragment *)fragment;

@end

@interface UITableView(ConfigFragmentTableCell)

- (FragmentTableCell *)fragmentListCell;

@end