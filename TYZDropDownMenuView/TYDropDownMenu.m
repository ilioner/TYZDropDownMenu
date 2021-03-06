//
//  TYDropDownMenu.m
//  AiLi
//
//  Created by TywinZhang on 16/2/2.
//  Copyright © 2016年 AiLi.Technology Co. All rights reserved.
//
#import "TYDropDownMenu.h"
#import "TYDropDownMenuCell.h"
#import "TYDropDownMenuConfig.h"
static NSString *collectionCellId = @"collectionCellId";
@interface TYDropDownMenu()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,TYDropDownTopItemDelegate>

@end

@implementation TYDropDownMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, TOPVIEW_H)];
        _topView.backgroundColor = [UIColor whiteColor];
        
        _mainMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topView.frame), self.frame.size.width, [UIScreen mainScreen].bounds.size.height - 120)];
        [self addSubview:_mainMenuView];
        
        _bottomButton = [[UIButton alloc] initWithFrame:CGRectMake(-1, CGRectGetMaxY(_mainMenuView.frame), self.frame.size.width+2, BOTTOM_BUTTON_H)];
        _bottomButton.backgroundColor = RGBA(244, 244, 244, 1);
        _bottomButton.layer.borderColor = RGB(235, 235, 235).CGColor;
        _bottomButton.layer.borderWidth = 1.0f;
        [_bottomButton setTitle:CLOSEBUTTON_TITLE forState:UIControlStateNormal];
        [_bottomButton setTitleColor:RGB(77, 77, 77) forState:UIControlStateNormal];
        [_bottomButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        _bottomButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_bottomButton];
        
        _Level1TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 120, _mainMenuView.frame.size.height) style:UITableViewStylePlain];
        _Level1TableView.dataSource = self;
        _Level1TableView.delegate = self;
        _Level1TableView.showsVerticalScrollIndicator = NO;
        _Level1TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainMenuView addSubview:_Level1TableView];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        _subCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_Level1TableView.frame), 0, _mainMenuView.frame.size.width-CGRectGetMaxX(_Level1TableView.frame), CGRectGetHeight(_Level1TableView.frame)) collectionViewLayout:flowLayout];
        _subCollectionView.dataSource = self;
        _subCollectionView.delegate = self;
        _subCollectionView.backgroundColor = BACKGROUND_WHITE_COLOR;
        [_mainMenuView addSubview:_subCollectionView];
        [self loadConfig];
        
        _otherMenuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TOPVIEW_H, _mainMenuView.frame.size.width, 64) style:UITableViewStylePlain];
        _otherMenuTableView.dataSource = self;
        _otherMenuTableView.delegate = self;
        _otherMenuTableView.scrollEnabled = NO;
        _otherMenuTableView.showsVerticalScrollIndicator = NO;
        _otherMenuTableView.rowHeight = ROW_H;
        [self addSubview:_otherMenuTableView];
        
        [self addSubview:_topView];
        [self initTopButtons:self.frame];
        self.clipsToBounds = YES;
        
        _currentStyleKind = kStyle_grid;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _bottomButton.frame = CGRectMake(-1, self.frame.size.height-20, self.frame.size.width+2, BOTTOM_BUTTON_H);
}

#pragma mark -
#pragma mark - privateMethod -

- (void)initTopButtons:(CGRect)frame{
    _currenSelectKind = @"全部类别";
    _all= [[TYDropDownTopItem alloc] initWithFrame:CGRectMake(0, 0, frame.size.width/4-9, 36) withLineSide:kSideLine_right];
    _all.delegate = self;
    [_all setItemTitle:_currenSelectKind];
    [_topView addSubview:_all];
    
    _new = [[TYDropDownTopItem alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_all.frame)-1, -1, frame.size.width/4-9, 36) withLineSide:kSideLine_right];
    _new.delegate = self;
    [_new setItemTitle:@"最新"];
    [_topView addSubview:_new];
    
    _kind = [[TYDropDownTopItem alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_new.frame), -1, frame.size.width/4-9, 36) withLineSide:kSideLine_right];
    _kind.delegate = self;
    [_kind setItemTitle:@"类型"];
    [_topView addSubview:_kind];
    
    _level = [[TYDropDownTopItem alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_kind.frame), -1, frame.size.width/4-9, 36) withLineSide:kSideLine_none];
    _level.delegate = self;
    [_level setItemTitle:@"等级"];
    [_topView addSubview:_level];
    
    _styleButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_level.frame), 0, 36, 36)];
    [_styleButton setBackgroundImage:[UIImage imageNamed:@"drop_list"] forState:UIControlStateNormal];
    [_styleButton addTarget:self action:@selector(onStyleChanged:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_styleButton];
    
    UIView *line_view_bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 34, frame.size.width, 1)];
    line_view_bottom.backgroundColor = RGB(235, 235, 235);
    [_topView addSubview:line_view_bottom];
    UIView *line_view_top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 1)];
    line_view_top.backgroundColor = RGB(235, 235, 235);
    [_topView addSubview:line_view_top];
    _topView.clipsToBounds = YES;
}

- (void)setDataSource:(NSMutableDictionary *)dataSource{
    _dataSource = dataSource;
    _level_1_data_array = [dataSource.allKeys sortedArrayUsingComparator:^(id a, id b)
                           {
                               return [a localizedCompare: b];
                           }];
    [_Level1TableView reloadData];
}

- (void)onStyleChanged:(UIButton *)sender{
    if (_currentStyleKind == kStyle_grid) {
        _currentStyleKind = kStyle_list;
        [_styleButton setBackgroundImage:[UIImage imageNamed:@"drop_grid"] forState:UIControlStateNormal];
    }else{
        _currentStyleKind = kStyle_grid;
        [_styleButton setBackgroundImage:[UIImage imageNamed:@"drop_list"] forState:UIControlStateNormal];
    }
    [_all setStatus:DropDownMenuUp];
    [_new setStatus:DropDownMenuUp];
    [_kind setStatus:DropDownMenuUp];
    [_level setStatus:DropDownMenuUp];
    
    [self menuDisplayOrNotByCurrentItem:nil];
    [self.delegate menu:self styleChanged:_currentStyleKind];
}

- (void)loadCurrentCollectionDataArrayByKey:(NSString *)key{
    _current_collectionData_array = self.dataSource[key];
}

- (void)loadConfig{
    _currentSelectLevel1 = 0;
    [self configCollectionCell];
}

- (void)configCollectionCell{
    [_subCollectionView registerClass:[TYDropDownMenuCell class] forCellWithReuseIdentifier:collectionCellId];
}

- (void)buttonClick{
    if (_currentItem == _all) {
        [_all setStatus:DropDownMenuDown];
    }
    [self menuDisplayOrNotByCurrentItem:_currentItem];
    [self.delegate menu:self];
}

- (void)itemClick{

    if (_currentItem == _all) {
        [_new setStatus:DropDownMenuUp];
        [_kind setStatus:DropDownMenuUp];
        [_level setStatus:DropDownMenuUp];
        _mainMenuView.hidden = NO;
        _otherMenuTableView.hidden = YES;
    }else{
        if (_currentItem == _new){
            [_all setStatus:DropDownMenuUp];
            [_kind setStatus:DropDownMenuUp];
            [_level setStatus:DropDownMenuUp];
            _otherMenuTableView.frame = CGRectMake(0, TOPVIEW_H, _mainMenuView.frame.size.width, MENU_FRO_NEW.count*ROW_H);
        }else if (_currentItem == _kind){
            [_all setStatus:DropDownMenuUp];
            [_new setStatus:DropDownMenuUp];
            [_level setStatus:DropDownMenuUp];
            _otherMenuTableView.frame = CGRectMake(0, TOPVIEW_H, _mainMenuView.frame.size.width, MENU_FRO_CATE.count*ROW_H);
        }else if (_currentItem == _level){
            [_all setStatus:DropDownMenuUp];
            [_new setStatus:DropDownMenuUp];
            [_kind setStatus:DropDownMenuUp];
            _otherMenuTableView.frame = CGRectMake(0, TOPVIEW_H, _mainMenuView.frame.size.width, MENU_FOR_LEVEL.count*ROW_H);
            
        }
        _mainMenuView.hidden = YES;
        _otherMenuTableView.backgroundColor = [UIColor whiteColor];
        _otherMenuTableView.hidden = NO;
        [_otherMenuTableView reloadData];
    }
    
    [self menuDisplayOrNotByCurrentItem:_currentItem];
    [self.delegate menu:self];
}

- (void)menuDisplayOrNotByCurrentItem:(TYDropDownTopItem *)item
{
    __block CGRect rect = self.frame;
    [UIView animateWithDuration:0.3f animations:^{
            if (item == _new) {
                if (_new.status == DropDownMenuUp) {
                    rect.size.height = MENU_FRO_NEW.count*ROW_H+TOPVIEW_H;
                }else{
                    rect.size.height = TOPVIEW_H;
                }
            }else if (item == _kind){
                if (_kind.status == DropDownMenuUp) {
                    rect.size.height = MENU_FRO_CATE.count*ROW_H+TOPVIEW_H;
                }else{
                    rect.size.height = TOPVIEW_H;
                }
            }else if (item == _level){
                if (_level.status == DropDownMenuUp) {
                    rect.size.height = MENU_FOR_LEVEL.count*ROW_H+TOPVIEW_H;
                }else{
                    rect.size.height = TOPVIEW_H;
                }
            }else if (item == _all){
                if (_all.status == DropDownMenuUp) {
                    [_Level1TableView reloadData];
                    rect.size.height = 385.0f;
                }else{
                    rect.size.height = TOPVIEW_H;
                }
            }else{
                rect.size.height = TOPVIEW_H;
            }
        self.frame = rect;
    }completion:^(BOOL finished) {
        if (item == _all) {
            if (_all.status == DropDownMenuUp) {
                [self tableView:_Level1TableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            }
        }
    }];
}

#pragma mark
#pragma mark - UITableViewDataSource,UITableViewDelegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView != _otherMenuTableView) {
        static NSString *cellId = @"Cate_1_CellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",_level_1_data_array[indexPath.row]];
        cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        
        if ([cell viewWithTag:BOTTOM_TAG] == nil && [cell viewWithTag:RIGHT_TAG] == nil && [cell viewWithTag:LEFTLINE_TAG] == nil) {
            UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(cell.frame)-1, 0, 1, CGRectGetHeight(cell.frame))];
            rightLine.backgroundColor = RGBA(217, 217, 217, 1);
            rightLine.tag = RIGHT_TAG;
            
            UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(cell.frame)-1, CGRectGetWidth(cell.frame), 1)];
            bottomLine.backgroundColor = RGBA(217, 217, 217, 1);
            bottomLine.tag = BOTTOM_TAG;
            UIView *leftLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, cell.frame.size.height)];
            leftLineView.backgroundColor = RGB(163, 44, 37);
            leftLineView.tag = LEFTLINE_TAG;
            [cell addSubview:bottomLine];
            [cell addSubview:rightLine];
            [cell bringSubviewToFront:bottomLine];
            [cell bringSubviewToFront:rightLine];
            [cell addSubview:leftLineView];
            leftLineView.hidden = YES;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == _currentSelectLevel1) {
            cell.backgroundColor = BACKGROUND_WHITE_COLOR;
            [cell viewWithTag:LEFTLINE_TAG].hidden = NO;
            cell.textLabel.textColor = RGB(163, 44, 37);
        }else{
            cell.backgroundColor = BACKGROUND_GRAY_COLOR;
            [cell viewWithTag:LEFTLINE_TAG].hidden = YES;
            cell.textLabel.textColor = RGB(0, 0, 0);
        }
        
        return cell;
    }else{
        static NSString *cellId = @"menu_CellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        NSString *itemName = nil;
        if (_currentItem == _new) {
            itemName = MENU_FRO_NEW[indexPath.row];
            if ([MENU_FRO_NEW[indexPath.row] isEqualToString:CLOSEBUTTON_TITLE]) {
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.backgroundColor = RGBA(244, 244, 244, 1);
            }else{
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                cell.backgroundColor = [UIColor whiteColor];
            }
        }else if (_currentItem == _kind){
            itemName = MENU_FRO_CATE[indexPath.row];
            if ([MENU_FRO_CATE[indexPath.row] isEqualToString:CLOSEBUTTON_TITLE]) {
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.backgroundColor = RGBA(244, 244, 244, 1);
            }else{
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                cell.backgroundColor = [UIColor whiteColor];
            }
        }else if (_currentItem == _level) {
            itemName = MENU_FOR_LEVEL[indexPath.row];
            if ([MENU_FOR_LEVEL[indexPath.row] isEqualToString:CLOSEBUTTON_TITLE]) {
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.backgroundColor = RGBA(244, 244, 244, 1);
            }else{
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                cell.backgroundColor = [UIColor whiteColor];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [NSString stringWithFormat:@"%@",itemName];
        cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_currentItem == _all) {
        return 44.0f;
    }else{
        if (_currentItem == _new) {
            if ([MENU_FRO_NEW[indexPath.row] isEqualToString:CLOSEBUTTON_TITLE]) {
                return BOTTOM_BUTTON_H;
            }else{
                return ROW_H;
            }
        }else if (_currentItem ==_kind){
        
            if ([MENU_FRO_CATE[indexPath.row] isEqualToString:CLOSEBUTTON_TITLE]) {
                return BOTTOM_BUTTON_H;
            }else{
                return ROW_H;
            }
            
        }else{
            if ([MENU_FOR_LEVEL[indexPath.row] isEqualToString:CLOSEBUTTON_TITLE]) {
                return BOTTOM_BUTTON_H;
            }else{
                return ROW_H;
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_currentItem == _all) {
        return _level_1_data_array.count;
    }else if (_currentItem == _new) {
        return MENU_FRO_NEW.count;
    }else if (_currentItem == _kind){
        return MENU_FRO_CATE.count;
    }else if (_currentItem == _level) {
        return MENU_FOR_LEVEL.count;
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentItem == _all) {
        _currentSelectLevel1 = indexPath.row;
        [tableView reloadData];
        [self loadCurrentCollectionDataArrayByKey:_level_1_data_array[indexPath.row]];
        [_subCollectionView reloadData];
    }else{
        if (_currentItem == _new) {
            if ([MENU_FRO_NEW[indexPath.row] isEqualToString:CLOSEBUTTON_TITLE]) {
               [_new setStatus:DropDownMenuDown];
            }
        }else if (_currentItem == _kind){
            if ([MENU_FRO_CATE[indexPath.row] isEqualToString:CLOSEBUTTON_TITLE]) {
                [_kind setStatus:DropDownMenuDown];
            }
        }else if (_currentItem == _level) {
            if ([MENU_FOR_LEVEL[indexPath.row] isEqualToString:CLOSEBUTTON_TITLE]) {
                [_level setStatus:DropDownMenuDown];
            }
        }
        [self menuDisplayOrNotByCurrentItem:_currentItem];
    }
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _current_collectionData_array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TYDropDownMenuCell *cell = (TYDropDownMenuCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellId forIndexPath:indexPath];
    NSString *itemName = [NSString stringWithFormat:@"%@",_current_collectionData_array[indexPath.row]];
    [cell configCell:itemName];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _currenSelectKind = _current_collectionData_array[indexPath.item];
    [_all setItemTitle:_currenSelectKind];
    [_all setStatus:DropDownMenuDown];
    [self buttonClick];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, collectionView.frame.size.width/2-10, 40)];
    label.text = _current_collectionData_array[indexPath.item];
    label.numberOfLines = 0;
    [label sizeToFit];
    return CGSizeMake(collectionView.frame.size.width/2-10, label.frame.size.height*1.2);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 5, 2, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
}

#pragma mark - TYDropDownTopItemDelegate -
- (void)onItemClick:(TYDropDownTopItem *)item
{
    _currentItem = item;
    [self itemClick];
    if (item != _all) {
        _mainMenuView.hidden = YES;
        _bottomButton.hidden = YES;
        
    }else{
        _mainMenuView.hidden = NO;
        _bottomButton.hidden = NO;
    }
}
@end
