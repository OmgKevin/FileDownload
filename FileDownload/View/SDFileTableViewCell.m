//
//  SDFileTableViewCell.m
//  SunLands
//
//  Created by xingkk on 2019/9/12.
//  Copyright © 2019 Yuxuan. All rights reserved.
//

#import "SDFileTableViewCell.h"

@implementation SDFileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLable.font = [UIFont systemFontOfSize:17];
    self.titleLable.textColor = [UIColor blackColor];
    self.titleLable.numberOfLines = 0;
    self.titleLable.lineBreakMode = NSLineBreakByCharWrapping;
    
    self.downloadSpeedLabel.textColor = [UIColor redColor];
    [self.downloadSpeedLabel setHidden:YES];
    
}

- (IBAction)selectButtonAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(selectRowStr:indexPath:)]) {
        [_delegate selectRowStr:self.titleLable.text indexPath:self.selectedIndexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
