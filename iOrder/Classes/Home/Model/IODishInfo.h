//
//  IODishInfo.h
//  iOrder
//
//  Created by 易无解 on 4/29/16.
//  Copyright © 2016 易无解. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MJExtension.h"


#pragma mark - interface IODishInfo
@interface IODishInfo : NSObject<MJKeyValue>

/**
 *  所有的菜
 */
@property (nonatomic, strong) NSArray *dishs;

/**
 *  菜的类别
 */
@property (nonatomic, copy) NSString *category;

@end


#pragma mark - interface IODish
@interface IODish : NSObject<MJKeyValue>

/**
 *  菜品ID，唯一标识,
 */
@property (nonatomic, assign) NSInteger dishesId;

/**
 *  菜品图片url，不包含图片服务器根地址，需自行拼接
 */
@property (nonatomic, copy) NSString *picture;

/**
 *  菜品名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  菜品月售数量
 */
@property (nonatomic, assign) int monSal;

/**
 *  菜品点赞数量
 */
@property (nonatomic, assign) int praAmt;

/**
 *  菜品价格，两位小数
 */
@property (nonatomic, assign) float price;

/**
 *  菜品评论数量
 */
@property (nonatomic, assign) int comAmt;

@end



#pragma mark - interface IODishes
@interface IODishes : NSObject<MJKeyValue>

/**
 *  某个分类下的所有菜品列表
 */
@property (nonatomic, strong) NSArray *dishes;

/**
 *  该分类的名称
 */
@property (nonatomic, copy) NSString *catgName;

@end
