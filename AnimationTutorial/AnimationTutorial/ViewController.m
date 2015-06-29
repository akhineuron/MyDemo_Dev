//
//  ViewController.m
//  AnimationTutorial
//
//  Created by Neuron Mac on 20/06/15.
//  Copyright (c) 2015 Neuron Mac. All rights reserved.
//

#import "ViewController.h"
#import "PagedImageScrollView.h"

@interface ViewController ()<UICollectionViewDataSource, UICollisionBehaviorDelegate>
{
    NSArray *collectionImages;
    UIImageView *originalImageView;
    UIImageView *fullScreenImageView;
    UITapGestureRecognizer *gesture;
}

@property (nonatomic) UIDynamicAnimator *animator;
@property (weak, nonatomic) IBOutlet PagedImageScrollView *popup;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *btnCart;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     collectionImages = [NSArray arrayWithObjects:@"image1.png",@"image2.png",@"image3.png",@"image4.png",@"image5.png",@"image6.png",@"image7.png",@"image8.png",@"image9.png",@"image10.png",@"image11.png", nil];
    
    _popup.hidden       = YES;
    
    
    
    gesture  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageTapped)];
    gesture.numberOfTapsRequired    = 1;
    gesture.numberOfTouchesRequired = 1;
    [self.collectionView addGestureRecognizer:gesture];
    
    //Reload collection data
   
       [self.collectionView reloadData];
    // Do any additional setup after loading the view, typically from a nib.
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return collectionImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellIdentifier";
    UICollectionViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *collectionImageView = (UIImageView *)[cell viewWithTag:100];
    collectionImageView.image        = [UIImage imageNamed:[collectionImages objectAtIndex:indexPath.row]];
    cell.layer.borderWidth           = 1.5f;
    cell.layer.borderColor           = [UIColor redColor].CGColor;
    
    return cell;
}
-(void)ImageTapped
{
    CGPoint pointInCollectionView      = [gesture locationInView:self.collectionView];
    NSIndexPath *selectedIndexPath     = [self.collectionView indexPathForItemAtPoint:pointInCollectionView];
    UICollectionViewCell *selectedCell = [self.collectionView cellForItemAtIndexPath:selectedIndexPath];
    if (selectedCell != nil)
    {
        _popup.delegate     = self;
    [_popup setScrollViewContents:collectionImages];

    CGPoint scrollOffset    = CGPointMake(0, selectedIndexPath.row * (_popup.frame.size.height-40));

    // contentSize has now been changed
    [_popup.scrollView setContentOffset:scrollOffset animated:NO];
   
    _popup.pageControl.currentPage = selectedIndexPath.row;
    
    
    
    originalImageView = (UIImageView *)[selectedCell viewWithTag:100]; // or whatever cell element holds your image that you want to zoom
    
    fullScreenImageView = [[UIImageView alloc] init];
    [fullScreenImageView setContentMode:UIViewContentModeScaleToFill];
    
    fullScreenImageView.image = [originalImageView image];

        // You can either use this to zoom in from the center of your cell
    CGRect tempPoint = CGRectMake(originalImageView.center.x, originalImageView.center.y, 0, 0);
    // OR, if you want to zoom from the tapped point...
    //CGRect tempPoint = CGRectMake(pointInCollectionView.x, pointInCollectionView.y, 0, 0);

    CGRect startingPoint = [self.view convertRect:tempPoint fromView:[self.collectionView cellForItemAtIndexPath:selectedIndexPath]];
    [fullScreenImageView setFrame:startingPoint];
    [fullScreenImageView setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.9f]];
    
    [self.view addSubview:fullScreenImageView];
        fullScreenImageView.layer.borderWidth = 1.5;
        fullScreenImageView.layer.borderColor = [UIColor redColor].CGColor;
 [UIView animateWithDuration:0.9
                                       animations:^{
                                           [fullScreenImageView setFrame:CGRectMake(0,
                                                                                    0,
                                                                                    self.view.bounds.size.width,
                                                                                    self.view.bounds.size.height-40)];
                                       } completion:^(BOOL finished) {
                                           
                                           
                                           _popup.hidden              = NO;
                                           fullScreenImageView.hidden = YES;

                                           CATransition *transition    = [CATransition animation];
                                           transition.duration         = 1.6f;
                                           transition.timingFunction   = [CAMediaTimingFunction functionWithName:
                                                                          kCAMediaTimingFunctionEaseInEaseOut];
                                           transition.type             = kCATransitionFade;
                                           
                                           [fullScreenImageView.layer addAnimation:transition forKey:nil];

                                           transition.duration = 0.5f;
                                           [_popup.layer addAnimation:transition forKey:nil];
 }];
    }
}

- (IBAction)btnDone_Action:(id)sender
{
    _popup.hidden = YES;
    UIImageView *imgView = [_popup getImage:_popup.pageControl.currentPage];
    NSLog(@"current page = %ld", (long)_popup.pageControl.currentPage);

    CGRect rect      = self.view.frame;
    rect.size.height = rect.size.height-40;
    imgView.frame    = rect;
    [self.view addSubview:imgView];

    
    imgView.layer.borderWidth = 1.5;
    imgView.layer.borderColor = [UIColor redColor].CGColor;
    imgView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    [UIView animateWithDuration:2.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^()
                     {
                         imgView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                         imgView.center    = self.view.center;
                     }
                     completion:^(BOOL finished)
                     {
                         
                         CGRect rect      = self.view.frame;
                         rect.size.height = 5;
                         rect.size.width  = 3;
                         rect.origin.x    = self.view.frame.size.width/2-1.5;
                         rect.origin.y    = self.view.frame.size.height/2-1.5;
                         imgView.frame    = rect;
                         imgView.layer.borderWidth = 0.5;
                         _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
                         UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[imgView]];
                         [_animator addBehavior:gravityBehavior];
                     }
];

}

-(void)animationDone:(UIView  *)view
{
    [fullScreenImageView removeFromSuperview];
    fullScreenImageView = nil;
}

#pragma mark - Memory warning Method
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
