# TYZDropDownMenu
---
####引入方式

>
>TYDropDownMenu *menu = [[TYDropDownMenu alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 35)];
>
>menu.dataSource = {数据源};

>[self.view addSubview:menu];
>

####数据源格式
`{
    "group_1" =     (
        "data1_1",
        "data1_2",
        "data1_3",
        "data1_4",
        "data1_5"
    );
    "group_2" =     (
        "data2_1",
        "data2_2",
        "data2_3",
        "data2_4",
        "data2_5",
        "data2_6"
    )
}`
