//
//  MyCollectionViewCell.m
//  EPostPickUpByCustomer
//
//  Created by gotop on 2017/11/13.
//  Copyright © 2017年 gotop. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //定义CELL单元格内容
        _imageV = [[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-80)/2,(frame.size.height-80)/4, 80,80)];
        _imageV.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageV];
        
        _describLabel = [[UILabel alloc]initWithFrame:CGRectMake((frame.size.width-100)/2,(frame.size.height-80)/4+75, 100, 30)];
        _describLabel.backgroundColor = [UIColor clearColor];
        _describLabel.textAlignment =NSTextAlignmentCenter;
        [self addSubview:_describLabel];
    }
    return self;
}

@end
