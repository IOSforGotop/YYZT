//
//  CollectionViewController.m
//  EPostPickUpByCustomer
//
//  Created by gotop on 2017/11/13.
//  Copyright © 2017年 gotop. All rights reserved.
//

#import "MenuCollectionViewController.h"
#import "MyCollectionViewCell.h"

static CGFloat kMagin = 10.f;
@interface CollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITabBarDelegate>
{
    
    UITabBar *tabBar;
}
@property(strong,nonatomic)UICollectionView *myCollectionV;

@property(strong,nonatomic) NSMutableArray* imageArr;
@property(strong,nonatomic) NSMutableArray* describArr;
@property(strong,nonatomic) NSMutableArray* viewIdentify;
@end
//纯代码创建集合视图
static NSString *indentify = @"indentify";
@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat width = screenBounds.size.width;
    CGFloat height = screenBounds.size.height;
    //#pragma 添加tabBar
    CGFloat tabBarHeight = 64;
    CGFloat tabBarY = height-64;
    self->tabBar = [[UITabBar alloc] initWithFrame:
                   CGRectMake(0, tabBarY, width, tabBarHeight)];
    [self->tabBar setDelegate:self];
    
    //设置切换title
    UITabBarItem *tabBarItem1 = [[UITabBarItem alloc] initWithTitle:@"代收" image:[UIImage imageNamed:@"ds"] tag:1];
    UITabBarItem *tabBarItem2 = [[UITabBarItem alloc] initWithTitle:@"代投" image:[UIImage imageNamed:@"dt"] tag:2];
    UITabBarItem *tabBarItem3 = [[UITabBarItem alloc] initWithTitle:@"查询" image:[UIImage imageNamed:@"ss"] tag:3];
   
    
    NSLog(@"tabBarItem1.tag = %d",tabBarItem1.tag);
    NSLog(@"tabBarItem1.tag = %d",tabBarItem2.tag);
    NSLog(@"tabBarItem1.tag = %d",tabBarItem3.tag);
   
    
    //数组形式添加进 tabBar
    NSArray *tabBarItemArray = [[NSArray alloc]
                                initWithObjects:tabBarItem1, tabBarItem2, tabBarItem3, nil];
    [self->tabBar setItems:tabBarItemArray];
    [self.view addSubview:self->tabBar];
    


   
    _imageArr = [[NSMutableArray alloc] initWithObjects:@"kjjs",@"khqj",@"tjdj-1",@"lscx",@"dxqf",nil];
    _describArr = [[NSMutableArray alloc] initWithObjects:@"1.快件接受",@"2.客户取件",@"3.退减登记",@"4.历史邮件查询",@"5.短信重发",nil];
    _viewIdentify = [[NSMutableArray alloc]initWithObjects:@"ljdj",@"yhqj",@"tjdj",@"lsyjcx",@"dxcf", nil];
    
      self.view.backgroundColor = [UIColor grayColor];
    // Do any additional setup after loading the view.
     [self addTheCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.view.frame.size.height > 480.0f) {
       // [self adjustLayout];
    }
}

//- (void)adjustLayout {
//    _ljdjLabel.font = [UIFont systemFontOfSize:fonsize];
//    _yhqjLabel.font = [UIFont systemFontOfSize:fonsize];
//    _tjdjLabel.font = [UIFont systemFontOfSize:fonsize];
//    _hztjLabel.font = [UIFont systemFontOfSize:fonsize];
//    _lsyjcxLabel.font = [UIFont systemFontOfSize:fonsize];
//    _dxcfLabel.font = [UIFont systemFontOfSize:fonsize];
//    _dtyjLabel.font = [UIFont systemFontOfSize:fonsize];
//}
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
    _myCollectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0,64+30, self.view.frame.size.width,self.view.frame.size.height-64-64-30)collectionViewLayout:flowL];
    //设置代理为当前控制器
    _myCollectionV.delegate =self;
    _myCollectionV.dataSource =self;
    //设置背景
    _myCollectionV.backgroundColor =[UIColor grayColor];
    
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


    
#pragma  UITabBar

-(void) tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSLog(@"item.tag= %d", item.tag);
    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"dtyj"];
    
     [self presentViewController:vc animated:NO completion:^{}];
    //[self.navigationController pushViewController:vc animated:YES];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
