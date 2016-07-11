//
//  ViewController.m
//  LLProgressView
//
//  Created by ETH Tech. on 16/7/11.
//  Copyright © 2016年 linl. All rights reserved.
//

#import "ViewController.h"
#import "LLProgressView.h"

@interface ViewController ()
@property (nonatomic, strong) LLProgressView *progressView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.progressView = [[LLProgressView alloc] initWithFrame:CGRectMake(150, 160, 50, 50)];
    [self.view addSubview:self.progressView];
}
- (IBAction)startAnimation:(id)sender {
    [self.progressView startCircleAnimation:^(BOOL isFinish) {
        NSLog(@"整个动画结束了！！！");
    }];
    __block LLProgressView *targetView = self.progressView;
    dispatch_time_t time_after = dispatch_time(DISPATCH_TIME_NOW, 2.0*NSEC_PER_SEC);
    dispatch_after(time_after, dispatch_get_main_queue(), ^{
        targetView.isCircleStop = YES;
        NSLog(@"耗时工作结束了！！！兄弟！！！");
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
