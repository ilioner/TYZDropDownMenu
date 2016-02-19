//
//  TYDropDownMenu.h
//  AiLi
//
//  Created by TywinZhang on 16/2/2.
//  Copyright © 2016年 AiLi.Technology Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYDropDownTopItem.h"

typedef enum : NSUInteger {
    kStyle_grid,
    kStyle_list
} TYDropDownMenuStyleChangeKind;

#define LEFTLINE_TAG             101
#define BOTTOM_TAG               102
#define RIGHT_TAG                103
#define BOTTOM_BUTTON_H          21.0f
#define TOPVIEW_H                35.0f
#define ROW_H                    30.0f

#define CLOSEBUTTON_TITLE        @"收起"
#define MENU_FRO_NEW             @[@"最新",@"最热",@"收起"]
#define MENU_FRO_CATE            @[@"全部",@"知识精讲",@"项目实践",@"收起"]
#define MENU_FOR_LEVEL           @[@"全部",@"初级",@"中级",@"高级",@"收起"]

@protocol TYDropDownMenuDelegate;
@interface TYDropDownMenu : UIView
{
    NSArray *_level_1_data_array;
    NSArray *_current_collectionData_array;
    
    NSInteger _currentSelectLevel1;
    
    UITableView *_Level1TableView;
    UITableView *_otherMenuTableView;
    UICollectionView *_subCollectionView;
    
    UIView *_topView;
    UIView *_mainMenuView;
    UIButton *_bottomButton;
    
    TYDropDownMenuStyleChangeKind _currentStyleKind;
    NSString *_currenSelectKind;
    
    TYDropDownTopItem *_all;
    TYDropDownTopItem *_new;
    TYDropDownTopItem *_kind;
    TYDropDownTopItem *_level;
    TYDropDownTopItem *_currentItem;
    UIButton *_styleButton;
}
@property (nonatomic, weak) id<TYDropDownMenuDelegate> delegate;
@property (nonatomic, strong) NSMutableDictionary *dataSource;


@end

@protocol TYDropDownMenuDelegate <NSObject>

- (void)menu:(TYDropDownMenu *)menu;

/**
 *  点击切换列表还是网格视图触发代理
 *
 *  @param menu  下拉menu本身
 *  @param style 视图显示状态
 */
- (void)menu:(TYDropDownMenu *)menu styleChanged:(TYDropDownMenuStyleChangeKind)style;

@end