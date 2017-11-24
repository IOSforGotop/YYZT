//
//  DtyjViewController.m
//  EPostPickUpByCustomer
//
//  Created by lzb on 16/7/27.
//  Copyright © 2016年 gotop. All rights reserved.
//

#import "DtyjViewController.h"


#import "Utility.h"
#import "MyCollectionViewCell.h"

static CGFloat kMagin = 10.f;


//纯代码创建集合视图
static NSString *indentify = @"indentify";

@interface DtyjViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *dtljdjLabel;
@property (weak, nonatomic) IBOutlet UILabel *dttjdjLabel;
@property (weak, nonatomic) IBOutlet UILabel *dtyjttLabel;



@property(strong,nonatomic)UICollectionView *myCollectionV;

@property(strong,nonatomic) NSMutableArray* imageArr;
@property(strong,nonatomic) NSMutableArray* describArr;
@property(strong,nonatomic) NSMutableArray* viewIdentify;
@end

@implementation DtyjViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"代投";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    self.navigationController.navigationBar.translucent= NO; //将按钮设置为 半透明  即可实现 显示栏不被改变
    _imageArr = [[NSMutableArray alloc] initWithObjects:@"kjjs",@"khqj",@"tjdj-1",nil];
    _describArr = [[NSMutableArray alloc] initWithObjects:@"1.代投接收",@"2.妥投登记",@"3.退件登记",nil];
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
    _dtljdjLabel.font = [UIFont systemFontOfSize:fonsize];
    _dttjdjLabel.font = [UIFont systemFontOfSize:fonsize];
    _dtyjttLabel.font = [UIFont systemFontOfSize:fonsize];
   
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

//=====================not use==========================
- (IBAction)dtljdj:(id)sender {
    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"dtljdj"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)dttjdj:(id)sender {
    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"dttjdj"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)dtyjtt:(id)sender {
    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"dtyjtt"];
    
    [self.navigationController pushViewController:vc animated:YES];
}



@end

