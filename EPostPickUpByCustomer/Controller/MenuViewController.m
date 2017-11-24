//
//  MenuViewController.m
//  EPostPickUpByCustomer
//
//  Created by user on 15/12/10.
//  Copyright © 2015年 gotop. All rights reserved.
//

#import "MenuViewController.h"
#import "Utility.h"
#import "MenuCollectionViewController.h"
#import "MyCollectionViewCell.h"

static CGFloat kMagin = 10.f;


//纯代码创建集合视图
static NSString *indentify = @"indentify";

@interface MenuViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *yhqjLabel;
@property (weak, nonatomic) IBOutlet UILabel *tjdjLabel;
@property (weak, nonatomic) IBOutlet UILabel *hztjLabel;
@property (weak, nonatomic) IBOutlet UILabel *lsyjcxLabel;
@property (weak, nonatomic) IBOutlet UILabel *dxcfLabel;
@property (weak, nonatomic) IBOutlet UILabel *ljdjLabel;
@property (weak, nonatomic) IBOutlet UILabel *dtyjLabel;


@property(strong,nonatomic)UICollectionView *myCollectionV;

@property(strong,nonatomic) NSMutableArray* imageArr;
@property(strong,nonatomic) NSMutableArray* describArr;
@property(strong,nonatomic) NSMutableArray* viewIdentify;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    
    self.title = @"代收";
    
    //代码设置baritem
   // UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
   // backItem.title = @"返回";
   // self.navigationItem.leftBarButtonItem = backItem;
    
    //16进制颜色转换后 需要／255
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0/255.0 green:109/255.0 blue:70/255.0 alpha:1.0]];//更改全局的导航栏颜色
    
    //这个页面中只有状态栏 并没有导航栏
    self.navigationController.navigationBar.translucent= NO; //将按钮设置为 半透明  即可实现 显示栏不被改变
    //设置状态栏的颜色 默认只有黑白两色
    // self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//
//    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
//
//        statusBar.backgroundColor = [UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:1.0];
//
//    }
//
    
    [self.tabBarController.tabBar setTintColor:[UIColor colorWithRed:0/255.0 green:109/255.0 blue:70/255.0 alpha:1.0]];
    _imageArr = [[NSMutableArray alloc] initWithObjects:@"kjjs",@"khqj",@"tjdj-1",@"lscx",@"dxqf",nil];
    _describArr = [[NSMutableArray alloc] initWithObjects:@"1.快件接收",@"2.客户取件",@"3.退件登记",@"4.历史邮件查询",@"5.短信重发",nil];
    _viewIdentify = [[NSMutableArray alloc]initWithObjects:@"ljdj",@"yhqj",@"tjdj",@"lsyjcx",@"dxcf", nil];
    
    self.view.backgroundColor = [UIColor grayColor];
    // Do any additional setup after loading the view.
    [self addTheCollectionView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.view.frame.size.height > 480.0f) {
        [self adjustLayout];
    }
}

- (void)adjustLayout {
    _ljdjLabel.font = [UIFont systemFontOfSize:fonsize];
    _yhqjLabel.font = [UIFont systemFontOfSize:fonsize];
    _tjdjLabel.font = [UIFont systemFontOfSize:fonsize];
    _hztjLabel.font = [UIFont systemFontOfSize:fonsize];
    _lsyjcxLabel.font = [UIFont systemFontOfSize:fonsize];
    _dxcfLabel.font = [UIFont systemFontOfSize:fonsize];
    _dtyjLabel.font = [UIFont systemFontOfSize:fonsize];
}

//创建视图
-(void)addTheCollectionView{
    
    //=======================1===========================
    //创建一个块状表格布局对象
    UICollectionViewFlowLayout *flowL = [UICollectionViewFlowLayout new];
    //格子的大小 (长，高)
    
    
    //横向最小距离
    flowL.minimumInteritemSpacing =1.f;
    //    flowL.minimumLineSpacing=60.f;//代表的是纵向的空间间隔
    
    CGFloat itemWidth = (self.view.frame.size.width - 4 * kMagin) / 3;
    
    //设置单元格大小
    flowL.itemSize = CGSizeMake(itemWidth, itemWidth);
    //最小行间距(默认为10)
    flowL.minimumLineSpacing = 11;
    //最小item间距（默认为10）
    flowL.minimumInteritemSpacing = 8;
    //设置senction的内边距
    flowL.sectionInset = UIEdgeInsetsMake(kMagin, kMagin, 2*kMagin, kMagin);
    
    //如果有多个区 就可以拉动
    [flowL setScrollDirection:UICollectionViewScrollDirectionVertical];
    //可以左右拉动
    //    [flowL setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    //=======================2===========================
    //创建一个UICollectionView
    _myCollectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0,10, self.view.frame.size.width,self.view.frame.size.height-64-64-30)collectionViewLayout:flowL];
    //设置代理为当前控制器
    _myCollectionV.delegate =self;
    _myCollectionV.dataSource =self;
    //设置背景
    _myCollectionV.backgroundColor =[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0];
    
#pragma mark -- 注册单元格
    [_myCollectionV registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:indentify];
    
    
    //添加视图
    [self.view addSubview:_myCollectionV];
    
}

#pragma mark --UICollectionView dataSource
//有多少个Section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section有多少个元素
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageArr.count;
}
//每个单元格的数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //初始化每个单元格
    MyCollectionViewCell *cell = (MyCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:indentify forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    //给单元格上的元素赋值
    cell.imageV.image = [UIImage imageNamed:_imageArr[indexPath.row]];
    // cell.describLabel.text = [NSString stringWithFormat:@"{%ld-%ld}",indexPath.section,indexPath.row];
    cell.describLabel.text = _describArr[indexPath.row];
    return cell;
    
}


//点击单元格
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.row);
    
    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:_viewIdentify[indexPath.row]];
    
    [self.navigationController pushViewController:vc animated:YES];
}

//==============================not use====================
- (IBAction)ljdj:(id)sender {
    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ljdj"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)yhqj:(id)sender {
    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"yhqj"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)tjdj:(id)sender {
    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"tjdj"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)hztj:(id)sender {
    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    // UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"hzcx"];   //界面更该放弃
    // UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"qdywl"];  //界面测试成功
    
    // UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"wlgsywl"]; //界面测试成功
    
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ywlchangeview"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)lsyjcx:(id)sender {
    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"lsyjcx"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)dxcf:(id)sender {
    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"dxcf"];
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)dtyj:(id)sender {
    
    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"dtyj"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


@end
