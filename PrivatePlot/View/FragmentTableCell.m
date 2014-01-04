//
//  FragmentTableCell.m
//  PrivatePlot
//
//  Created by Kino on 13-12-6.
//  Copyright (c) 2013年 kino. All rights reserved.
//

#import "FragmentTableCell.h"
#import "Fragment.h"

#import "UIImage+RoundedCorner.h"
#import "NSDate-Utilities.h"

@implementation FragmentTableCell

- (IBAction)faceButtonTap:(id)sender {
    
}

- (void)updateCellByModel:(Fragment *)fragment{
    UIImage *faceImage = self.faceImageButton.imageView.image;
    [self.faceImageButton setImage:[faceImage roundedCornerImage:80 borderSize:10] forState:UIControlStateNormal];
    self.timeLabel.text = [fragment.postTime stringShortByChinese];
    self.contentLabel.text = [NSString stringWithFormat:@"%@",fragment.contentText];
    self.contentLabel.frame = CGRectMake(CGRectGetMinX(self.contentLabel.frame),
                                         CGRectGetMinY(self.contentLabel.frame),
                                         CGRectGetWidth(self.contentLabel.frame),
                                         fragment.labelHeight);
    
    float r = ((arc4random() % 55) + 200) / 255.f;
    float g = ((arc4random() % 55) + 200) / 255.f;
    float b = ((arc4random() % 55) + 200) / 255.f;
    self.backgroundCustomView.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:0.6];
    
    self.backgroundCustomView.layer.masksToBounds = NO;
    //self.backgroundCustomView.layer.cornerRadius = 4; // if you like rounded corners
    self.backgroundCustomView.layer.shadowOffset = CGSizeMake(-2, 2);
    self.backgroundCustomView.layer.shadowRadius = 5;
    self.backgroundCustomView.layer.shadowOpacity = 0.3;
}

@end


#pragma mark - Tableview扩展

@implementation UITableView(ConfigFragmentTableCell)

- (FragmentTableCell *)fragmentListCell{
    static NSString *CellIdentifier = @"FragmentTableCellIndentifier";
    FragmentTableCell *cell = (FragmentTableCell *)[self dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FragmentTableCell" owner:self options:nil];
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[FragmentTableCell class]])
                cell = (FragmentTableCell *)oneObject;
    }
    
    return cell;
}

@end

