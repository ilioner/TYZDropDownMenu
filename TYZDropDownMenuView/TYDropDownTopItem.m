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

@synthesize status = _currentStatus;

- (instancetype)initWithFrame:(CGRect)frame withLineSide:(TYDropDownTopItemSideLineStyle)lineSide
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
        
        UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickThis:)];
        tapAction.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapAction];
        self.sideLineStyle = lineSide;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setStatus:(TYDropDownTopItemStatus)status
{
    _currentStatus = DropDownMenuDown;
    _arrowImage.image = [UIImage imageNamed:@"arrow_down"];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.sideLineStyle != kSideLine_none) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, 1);
        CGContextSetAllowsAntialiasing(context, true);
        CGContextSetRGBStrokeColor(context, 235.0 / 255.0, 235.0 / 255.0, 235.0 / 255.0, 1.0);
        CGContextBeginPath(context);
        
        if (self.sideLineStyle == kSideLine_left) {
            CGContextMoveToPoint(context, 0, 8);
            CGContextAddLineToPoint(context, 0, self.frame.size.height-8);
        }else{
            CGContextMoveToPoint(context, self.frame.size.width-1, 8);
            CGContextAddLineToPoint(context, self.frame.size.width-1, self.frame.size.height-8);
        }
        CGContextStrokePath(context);
    }
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
