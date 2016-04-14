//
//  LFXScrollView.h
//  无限循环（UIScrollView）
//
//  Created by apple on 13/4/16.
//  Copyright © 2016年 LFX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LFXScrollViewPageControlAlignment) {
    LFXScrollViewPageControlAlignmentCenter = 0,  //居中
    LFXScrollViewPageControlAlignmentLeft = 1,  //左对齐
    LFXScrollViewPageControlAlignmentRight = 2,  //右对齐
};

@interface LFXScrollView : UIView

@property (strong, nonatomic) NSArray *imagesA; //图片数据
@property (strong, nonatomic) NSArray *imagesNameA; //图片数据
@property (strong, nonatomic) NSArray *titleNameA; //说明数据
@property (strong, nonatomic) UIColor *pageTintColor; //UIPageControl未选中颜色
@property (strong, nonatomic) UIColor *currentTintColor; //UIPageControl选中颜色
@property (assign, nonatomic) NSInteger selectCurrentPage;   //当前选中的页数
@property (assign, nonatomic) LFXScrollViewPageControlAlignment pageAlignment; //对齐方式
@property (assign, nonatomic) BOOL openAuto; //是否自动轮播
@property (assign, nonatomic) CGFloat timeInterval;  //轮播时间间隔



/**
 *  初始化方法
 *
 *  @param frame      大小
 *  @param imageNameA 图片名字数据
 *  @param titleNameA 说明标题数据
 *
 *  @return 返回LFXScrollView对象
 */
- (instancetype)initWithFrame:(CGRect)frame imagesNameArray:(NSArray *)imageNameA titleNameArray:(NSArray *)titleNameA;

@end
