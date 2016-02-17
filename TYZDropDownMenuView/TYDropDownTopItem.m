//
//  TYDropDownTopItem.m
//  AiLi
//
//  Created by TywinZhang on 16/2/2.
//  Copyright © 2016年 AiLi.Technology Co. All rights reserved.
//

#import "TYDropDownTopItem.h"


@interface TYDropDownTopItem()
{
    UIImageView *_arrowImage;
    UILabel *_titleLabel;
    TYDropDownTopItemStatus _currentStatus;
}

@end
@implementation TYDropDownTopItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-12, frame.size.height/2-3, 8, 5)];
        _arrowImage.image = [UIImage imageNamed:@"arrow_down"];
        [self addSubview:_arrowImage];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - CGRectGetWidth(_arrowImage.frame), frame.size.height)];
        _titleLabel.text = @"全部";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:_titleLabel];
        
        _currentStatus = DropDownMenuDown;
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithRed:235 green:235 blue:235 alpha:1.0f].CGColor;
        
        UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickThis:)];
        tapAction.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapAction];
    }
    return self;
}

- (void)setStatus:(TYDropDownTopItemStatus)status
{
    _currentStatus = DropDownMenuDown;
    _arrowImage.image = [UIImage imageNamed:@"arrow_down"];
}

- (void)setItemTitle:(NSString *)title
{
    _titleLabel.text = title;
}

- (void)onClickThis:(UITapGestureRecognizer *)tap
{
    if (_currentStatus == DropDownMenuDown) {
        _currentStatus = DropDownMenuUp;
        _arrowImage.image = [UIImage imageNamed:@"arrow_up"];
    }else{
        _currentStatus = DropDownMenuDown;
        _arrowImage.image = [UIImage imageNamed:@"arrow_down"];
    }
    [self.delegate onItemClick:self];
}
@end
