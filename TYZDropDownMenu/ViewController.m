//
//  ViewController.m
//  TYZDropDownMenu
//
//  Created by TywinZhang on 16/2/15.
//  Copyright © 2016年 Tywin. All rights reserved.
//

#import "ViewController.h"
#import "TYDropDownMenu.h"
@interface ViewController ()<TYDropDownMenuDelegate>
{
    NSDictionary *_dic;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self getDataFromPlist];
    [self initDropDownMenu];
}

- (void)getDataFromPlist{

    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DemoData" ofType:@"plist"];
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    _dic = dataDic;
    NSLog(@"dataDic is --->%@",dataDic);
}

- (void)initDropDownMenu{
    TYDropDownMenu *menu = [[TYDropDownMenu alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 35)];
    menu.dataSource = _dic.mutableCopy;
    [self.view addSubview:menu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
