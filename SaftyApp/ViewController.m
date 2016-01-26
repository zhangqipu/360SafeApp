//
//  ViewController.m
//  SaftyApp
//
//  Created by 张齐朴 on 16/1/26.
//  Copyright © 2016年 张齐朴. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *circleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (assign, nonatomic) CGPoint originCenter;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSUInteger count;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupCircleImageView];
    
    [self setupPangesture];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.originCenter = self.backView.center;
}

- (void)setupCircleImageView
{
    self.circleImageView.animationImages = @[[UIImage imageNamed:@"home_bubbleAnimation1_667h"],
                                             [UIImage imageNamed:@"home_bubbleAnimation2_667h"]];
    self.circleImageView.animationDuration = 0.3;
    self.circleImageView.animationRepeatCount = 1;
}

- (void)setupPangesture
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(panGestureAction:)];
    
    [self.backView addGestureRecognizer:pan];
}

- (void)panGestureAction:(UIPanGestureRecognizer *)pan
{
    CGPoint translatedPoint = [pan translationInView:self.backImageView];
    
    self.backView.center    = CGPointMake(self.backView.center.x + translatedPoint.x,
                                          self.backView.center.y + translatedPoint.y);
    
    [pan setTranslation:CGPointZero inView:self.backImageView];
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:2
                              delay:0
             usingSpringWithDamping:0.3
              initialSpringVelocity:10
                            options:UIViewAnimationOptionLayoutSubviews
                         animations:^{
                             self.backView.center = self.originCenter;
                         } completion:^(BOOL finished) {
                             [self explodeInAnimation];
                             [self performSelector:@selector(beginAnimation)
                                        withObject:nil
                                        afterDelay:0.31];
                         }];
    }
    
}

- (void)beginAnimation
{
    self.circleImageView.image = [UIImage imageNamed:@"home_checkingCircle_667h"];
    
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.toValue           = @(M_PI * 2.0);
    rotateAnimation.duration          = 2.0f;
    rotateAnimation.repeatCount       = 3;
    rotateAnimation.delegate          = self;
    
    [self.circleImageView.layer addAnimation:rotateAnimation forKey:@"rotateAnimation"];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 / 100
                                                  target:self
                                                selector:@selector(updatingPercentLabel)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([((CABasicAnimation*)anim).keyPath isEqualToString:@"transform.rotation.z"]) {
        self.circleImageView.image = [UIImage imageNamed:@"home_bubble_667h"];
        
        NSMutableArray *images     = [NSMutableArray arrayWithArray:self.circleImageView.animationImages];
        [images exchangeObjectAtIndex:0 withObjectAtIndex:1];
        self.circleImageView.animationImages = images;
        
        [self explodeInAnimation];
    }
}

- (void)explodeInAnimation
{
    [self.circleImageView startAnimating];
}

- (void)updatingPercentLabel
{
    if (self.count == 101) {
        [self.timer invalidate];
        self.count = 0;
        
        return;
    }
    
    self.percentLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.count];
    self.count = self.count + 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
