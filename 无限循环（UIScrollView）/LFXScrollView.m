//
//  LFXScrollView.m
//  无限循环（UIScrollView）
//
//  Created by apple on 13/4/16.
//  Copyright © 2016年 LFX. All rights reserved.
//

#import "LFXScrollView.h"



static CGFloat PageControlH = 40;
static CGFloat PageControlM = 20;
static CGFloat TimeInt = 2.0;

#define TitleF [UIFont systemFontOfSize:12.0]
#define TitleC [UIColor whiteColor]
static CGFloat TitleM = 10;

typedef NS_ENUM(NSInteger,LFXScrollViewDataEnum) {
    LFXScrollViewDataImageName = 0,
    LFXScrollViewDataImage = 1
    
};

@interface  LFXScrollView()<UIScrollViewDelegate>


@property (strong, nonatomic) UIImageView *leftImageView; //左边视图
@property (strong, nonatomic) UIImageView *centerImageView; //中间视图
@property (strong, nonatomic) UIImageView *rightImageView; //右边视图
@property (weak, nonatomic) UIScrollView *scrollView; //滚动视图UIScrollView
@property (assign, nonatomic) NSUInteger imagesCount;  //图片数量
@property (assign, nonatomic) NSUInteger currentImageIndex;  //当前图片索引
@property (weak, nonatomic) UIPageControl *pageControl;  //分页控件
@property (assign, nonatomic)LFXScrollViewDataEnum dateEnum; //数据类型（是图片还是名字）
@property (strong, nonatomic)     NSTimer * scrollTimer;  //滑动定时器
@property (weak, nonatomic) UILabel *titleL; //标题Label

@end



@implementation LFXScrollView

- (instancetype)init {
    self = [super init];
    if (self) {
        /**  添加子控件*/
        [self addSubViews];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        /**  添加子控件*/
        [self addSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        /**  添加子控件*/
        [self addSubViews];
    }
    
    return self;
}

/**
 *  初始化方法
 */
- (instancetype)initWithFrame:(CGRect)frame imagesNameArray:(NSArray *)imageNameA titleNameArray:(NSArray *)titleNameA {
    self = [super initWithFrame:frame];
    if (self) {
        /**  添加子控件*/
        [self addSubViews];
        if (imageNameA) {
            self.imagesNameA = imageNameA;
        }
        
        if (titleNameA) {
            self.titleNameA = titleNameA;
        }
    }
    return self;
}

/**
 *  添加子控件
 */
- (void)addSubViews {
    //添加滚动控件
    [self addScrollView];
    //添加图片控件
    [self addImageViews];
    //添加分页控件
    [self addPapeControl];
    
    self.openAuto = YES; //默认自动轮播
    self.timeInterval = TimeInt;  //轮播时间间隔
}

/**
 *  添加滚动控件
 */
- (void)addScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
}

/**
 *  添加图片控件
 */
- (void)addImageViews {
    self.leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.scrollView addSubview:self.leftImageView];
    self.centerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.scrollView addSubview:self.centerImageView];
    self.rightImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.scrollView addSubview:self.rightImageView];
}

/**
 *  添加分页控件
 */
- (void)addPapeControl {
    //创建一个视图
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor lightGrayColor];
    bgView.tag = 1123;
    [self addSubview:bgView];
    
    //创建UIPageControl
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    
    //居中显示
    self.pageAlignment = LFXScrollViewPageControlAlignmentCenter;
    //只有一页隐藏页码
    pageControl.hidesForSinglePage = YES;
    
    //设置颜色
    pageControl.pageIndicatorTintColor = self.pageTintColor ? self.pageTintColor : [UIColor redColor];
    pageControl.currentPageIndicatorTintColor = self.currentTintColor ? self.currentTintColor : [UIColor blueColor];
    [bgView addSubview:pageControl];
    self.pageControl = pageControl;
    
    
    //创建标题Label
    UILabel *label = [[UILabel alloc] init];
    label.font = TitleF;
    label.textColor = TitleC;
    [bgView addSubview:label];
    self.titleL = label;
    
    
}

#pragma mark
#pragma mark -- 懒加载
-(UIImageView *)leftImageView {
    if (!_leftImageView) {
        self.leftImageView = [[UIImageView alloc] init];
    }
    return _leftImageView;
}

-(UIImageView *)centerImageView {
    if (!_centerImageView) {
        self.centerImageView = [[UIImageView alloc] init];
    }
    
    return _centerImageView;
}

-(UIImageView *)rightImageView {
    if (!_rightImageView) {
        self.rightImageView = [[UIImageView alloc] init];
    }
    
    return _rightImageView;
}


- (void)setImagesA:(NSArray *)imagesA {
    _imagesA = imagesA;
    if (imagesA) {
        self.imagesCount = imagesA.count;
        self.dateEnum = LFXScrollViewDataImage;
        //设置pageControl页数
        self.pageControl.numberOfPages = self.imagesCount;
    }
}

- (void)setImagesNameA:(NSArray *)imagesNameA {
    _imagesNameA = imagesNameA;
    if (imagesNameA) {
        self.imagesCount = imagesNameA.count;
        self.dateEnum = LFXScrollViewDataImageName;
        //设置pageControl页数
        self.pageControl.numberOfPages = self.imagesCount;
    }
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
    /** 设置ScrollView的大小和ImageView大小和图片*/
    [self setScrollViewSizeAndImageViewSizeImage];
    
   
    /**设置PageControll大小*/
    [self setPageControlSize];
    
}

/**
 *  设置ScrollView的大小和ImageView大小和图片
 */
- (void)setScrollViewSizeAndImageViewSizeImage {
    CGFloat W = self.frame.size.width ;
    CGFloat H = self.frame.size.height ;
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(W * 3, 0);
    //让scrollView滑动到第一张图片位置
    [self.scrollView setContentOffset:CGPointMake(W, 0) animated:NO];
    self.leftImageView.frame = CGRectMake(0, 0, W, H);
    self.centerImageView.frame = CGRectMake(1 * W, 0, W, H);
    self.rightImageView.frame = CGRectMake(2 * W, 0, W, H);
    if (self.dateEnum == LFXScrollViewDataImage) {
        self.leftImageView.image = [self.imagesA lastObject];
        self.centerImageView.image = [self.imagesA firstObject];
        self.rightImageView.image = self.imagesA[1];
    } else {
        self.leftImageView.image = [UIImage imageNamed:[self.imagesNameA lastObject]];
        self.centerImageView.image = [UIImage imageNamed:[self.imagesNameA firstObject]];
        self.rightImageView.image =[UIImage imageNamed:self.imagesNameA[1]] ;
    }
    self.currentImageIndex = self.selectCurrentPage = 0;
}


/**
 *  设置PageControll大小
 */
- (void)setPageControlSize {
    CGFloat W = self.frame.size.width ;
    CGFloat H = self.frame.size.height ;
    UIView *bgV = (UIView *)[self viewWithTag:1123];
    bgV.frame = CGRectMake(0, H - PageControlH, W, PageControlH);
    
    //注意此方法可以根据页数返回UIPageControl合适的大小
    CGSize pageCSize = [self.pageControl sizeForNumberOfPages:self.pageControl.numberOfPages];
    
    //设置对齐方式
    switch (self.pageAlignment) {
        case LFXScrollViewPageControlAlignmentCenter: {
            self.pageControl.frame = CGRectMake((W - pageCSize.width) / 2.0, 0, pageCSize.width, PageControlH);
        }
            break;
        case LFXScrollViewPageControlAlignmentLeft: {
            self.pageControl.frame = CGRectMake(PageControlM, 0, pageCSize.width, PageControlH);
            //判断是否有说明标题
            if (self.titleNameA.count) {
                CGFloat M_X = PageControlM + pageCSize.width;
                self.titleL.frame = CGRectMake(M_X, 0,W - M_X - TitleM, PageControlH);
                self.titleL.textAlignment = NSTextAlignmentRight;
                self.titleL.text = self.titleNameA[self.currentImageIndex];
            }
        }
            break;
        case LFXScrollViewPageControlAlignmentRight: {
            CGFloat page_x = - (self.pageControl.bounds.size.width - pageCSize.width - PageControlM) / 2.0 ;
            self.pageControl.bounds = CGRectMake(page_x, self.pageControl.frame.origin.y, self.pageControl.bounds.size.width, PageControlH);
            //判断是否有说明标题
            if (self.titleNameA.count) {
                CGFloat M_X = PageControlM + pageCSize.width;
                self.titleL.frame = CGRectMake(TitleM, 0,W - M_X, PageControlH);
                self.titleL.textAlignment = NSTextAlignmentLeft;
                self.titleL.text = self.titleNameA[self.currentImageIndex];
            }
        }
            
            break;
            
        default:
            break;
    }
    
    
    if(self.openAuto) {
        /**先移除定时器*/
        if (self.scrollTimer)[self releaseTimer];
        /** 添加定时器*/
        [self addTimer];
    }
   
}

#pragma mark
#pragma mark -- UIScrollViewDelegate
//滚动停止事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //重新加载图片
    [self reloadImage];
    
    //让scrollView滑动到第一个视图位置
    [self.scrollView setContentOffset:CGPointMake(scrollView.frame.size.width, 0) animated:NO];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    /**  添加定时器*/
    [self addTimer];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    /** 移除定时器*/
    [self releaseTimer];
}

/**
 *  移除定时器
 */
- (void)releaseTimer {
    if (self.scrollTimer) {
        [self.scrollTimer invalidate];
        self.scrollTimer = nil;
    }
}


/**
 *  添加定时器
 */
- (void)addTimer {
    NSTimer *timer = [NSTimer timerWithTimeInterval: self.timeInterval target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
#warning 当视图滑动时，定时器不执行方法，可以切换定时器模式为（NSRunLoopCommonModes）解决，即：
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes]
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    self.scrollTimer = timer;
}

/**
 *  重新加载图片
 */
- (void)reloadImage {
    CGFloat W = self.frame.size.width ;
   
    CGPoint offset = self.scrollView.contentOffset;
    if (offset.x > W) { //向右滑动（指向下一张图片索引）
         _currentImageIndex = (_currentImageIndex + 1) % self.imagesCount;
    }else if(offset.x < W){ //向左滑动（指向上一张图片索引）
         _currentImageIndex =(_currentImageIndex + self.imagesCount - 1) % self.imagesCount;
    }
   
    //改变PageControl页码
    self.selectCurrentPage = self.pageControl.currentPage = self.currentImageIndex;
    
    //修改标题
    if (self.titleNameA.count) {
        self.titleL.text = self.titleNameA[self.currentImageIndex];
    }
    /**重新设置左右图片*/
    [self setLeftImageViewAndRightImageView];
}


/**
 * 重新设置左右图片
 */
- (void)setLeftImageViewAndRightImageView {
    NSUInteger leftImageIndex,rightImageIndex;  //图片索引
    //重新设置左右图片
    leftImageIndex = (_currentImageIndex + self.imagesCount - 1 ) % self.imagesCount;
    rightImageIndex = (_currentImageIndex + 1) % self.imagesCount;
    
    if (self.dateEnum == LFXScrollViewDataImage) {
        self.leftImageView.image = self.imagesA[leftImageIndex];
        self.centerImageView.image = self.imagesA[_currentImageIndex];
        self.rightImageView.image = self.imagesA[rightImageIndex];
    } else {
        self.leftImageView.image = [UIImage imageNamed:self.imagesNameA[leftImageIndex]];
        self.centerImageView.image = [UIImage imageNamed:self.imagesNameA[_currentImageIndex]];
        self.rightImageView.image =[UIImage imageNamed:self.imagesNameA[rightImageIndex]] ;
    }

}


#pragma mark
#pragma mark -- NSTimer 事件
- (void)timerAction:(NSTimer *)timer {
    //让scrollView滑动到第二个视图位置
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * 2, 0) animated:YES];

    //重新设置索引
    if (self.currentImageIndex == self.imagesCount - 1) {
        self.currentImageIndex = 0;
    } else {
        self.currentImageIndex ++;
    }
    
    self.selectCurrentPage = self.pageControl.currentPage = self.currentImageIndex;
    
    //修改标题
    if (self.titleNameA.count) {
        self.titleL.text = self.titleNameA[self.currentImageIndex];
    }
    
    //延迟执行方法,使其能出现滑动的效果
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( self.timeInterval * .1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //重新设置左右图片
        [self setLeftImageViewAndRightImageView];
        //让scrollView滑动到第一个视图位置
        [self.scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
    });
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
