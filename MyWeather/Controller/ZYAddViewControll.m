//
//  ZYAddViewControll.m
//  MyWeather
//
//  Created by zhuyongqing on 15/11/4.
//  Copyright © 2015年 zhuyongqing. All rights reserved.
//

#import "ZYAddViewControll.h"
#import "UIView+ITTAdditions.h"
@interface ZYAddViewControll ()<UISearchBarDelegate>
{
    //搜索按钮
    UIButton *seachBtn;
}
@property(nonatomic,strong) UISearchBar *seach;

@end

@implementation ZYAddViewControll

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.seach];
    
    seachBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [seachBtn setTitle:@"取消" forState:UIControlStateNormal];
    [seachBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [seachBtn setFrame:CGRectMake(self.seach.right+5,self.seach.top+5,40, 40)];
    [seachBtn  addTarget:self action:@selector(seachBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:seachBtn];
    
    
}

#pragma mark - 搜索按钮点击
- (void)seachBtnAction
{
    
    //给block赋值
    [self seachResult];
}

- (void)seachCityName:(cityName)cityName
{
    self.cityName = cityName;
}

- (void)setCityName:(cityName)cityName
{
    //如果为空就拷贝
    if (_cityName != cityName) {
        _cityName = [cityName copy];
    }
}


- (void)seachResult
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    //取消键盘
    [self.seach resignFirstResponder];
    
    if (self.seach.text.length == 0) {
        return;
    }
    //检查输入的字符串
    NSString *city = @"市";
    NSUInteger index = [self.seach.text rangeOfString:city].location;
    if (index != NSNotFound) {
        self.cityName([self.seach.text substringToIndex:index]);
    }else
        self.cityName(self.seach.text);
    
  
    
}

#pragma mark - 懒加载
- (UISearchBar *)seach
{
    if (!_seach) {
        _seach = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width-60,50)];
        _seach.searchBarStyle = UISearchBarStyleMinimal;
        _seach.placeholder = @"城市名称";
        
        _seach.delegate = self;
    }
    return _seach;
}

#pragma mark - seachBar 代理

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //搜索
    [self seachResult];
    
   
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length>0) {
        [seachBtn setTitle:@"搜索" forState:UIControlStateNormal];;
    }else
        [seachBtn setTitle:@"取消" forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.seach becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
