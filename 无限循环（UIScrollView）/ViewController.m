//
//  ViewController.m
//  无限循环（UIScrollView）
//
//  Created by apple on 13/4/16.
//  Copyright © 2016年 LFX. All rights reserved.
//

#import "ViewController.h"
#import "LFXScrollView.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //加载图片数据
    [self loadImageDatas];
    
}


/**
 *  加载图片数据
 */
- (void)loadImageDatas {
    NSMutableArray *imagesMuA = [NSMutableArray array];
    for (int i = 1; i < 4; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
        [imagesMuA addObject:image];
    }
    LFXScrollView *l = [[LFXScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    l.imagesA = imagesMuA;
    l.titleNameA = @[@"sdsd-----1",@"sdsd-----2",@"sdsd-----3"];
    l.pageAlignment = LFXScrollViewPageControlAlignmentLeft;
    [self.view addSubview:l];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
