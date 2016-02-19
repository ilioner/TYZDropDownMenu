//
//  ALDropDownMenuCell.m
//  AiLi
//
//  Created by TywinZhang on 16/2/2.
//  Copyright © 2016年 AiLi.Technology Co. All rights reserved.
//

#import "TYDropDownMenuCell.h"
#import "TYDropDownMenuConfig.h"

@implementation TYDropDownMenuCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!self.nameLabel) {
            self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            [self addSubview:self.nameLabel];
        }
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.font = [UIFont systemFontOfSize:17.0f];
        self.nameLabel.textColor = FONT_COLOR;
    }
    return self;
}

- (void)configCell:(NSString *)titleString
{
    self.nameLabel.text = titleString;
}
@end
