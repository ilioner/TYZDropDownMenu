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
    DropDownMenuShow,
    DropDownMenuHidden
} TYDropDownMenuShowKind;
@protocol TYDropDownMenuDelegate;
@interface TYDropDownMenu : UIView
{
    NSArray *_level_1_data_array;
    NSArray *_current_collectionData_array;
    NSInteger _currentSelectLevel1;
    UITableView *_Level1TableView;
    UICollectionView *_subCollectionView;
    UIView *_topView;
    UIButton *_bottomButton;
    TYDropDownMenuShowKind _currentKind;
    NSString *_currenSelectKind;
    TYDropDownTopItem *_all;
    TYDropDownTopItem *_new;
    TYDropDownTopItem *_kind;
    TYDropDownTopItem *_level;
}
@property (nonatomic, weak) id<TYDropDownMenuDelegate> delegate;
@property (nonatomic, strong) NSMutableDictionary *dataSource;
@end

@protocol TYDropDownMenuDelegate <NSObject>

- (void)menu:(TYDropDownMenu *)menu showWithStatus:(TYDropDownMenuShowKind)kind;

@end