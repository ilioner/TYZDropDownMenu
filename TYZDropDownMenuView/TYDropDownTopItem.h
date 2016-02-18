//
//  TYDropDownTopItem.h
//  AiLi
//
//  Created by TywinZhang on 16/2/2.
//  Copyright © 2016年 AiLi.Technology Co. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DropDownMenuUp,
    DropDownMenuDown
} TYDropDownTopItemStatus;

typedef enum : NSUInteger {
    kSideLine_left,
    kSideLine_right,
    kSideLine_none
} TYDropDownTopItemSideLineStyle;

@protocol TYDropDownTopItemDelegate;
@interface TYDropDownTopItem : UIView

@property (nonatomic, assign) TYDropDownTopItemStatus status;
@property (nonatomic, weak) id<TYDropDownTopItemDelegate> delegate;
@property (nonatomic, assign) TYDropDownTopItemSideLineStyle sideLineStyle;

- (instancetype)initWithFrame:(CGRect)frame withLineSide:(TYDropDownTopItemSideLineStyle)lineSide;
- (void)setItemTitle:(NSString *)title;

@end

@protocol TYDropDownTopItemDelegate <NSObject>

- (void)onItemClick:(TYDropDownTopItem *)item;

@end