//
//  ALDropDownMenuCell.h
//  AiLi
//
//  Created by TywinZhang on 16/2/2.
//  Copyright © 2016年 AiLi.Technology Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYDropDownMenuCell : UICollectionViewCell
@property (strong, nonatomic) UILabel *nameLabel;
- (void)configCell:(NSString *)titleString;
@end
