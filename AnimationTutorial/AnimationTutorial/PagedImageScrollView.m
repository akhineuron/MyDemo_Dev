//
//  PagedImageScrollView.m
//  Test
//
//  Created by jianpx on 7/11/13.
//  Copyright (c) 2013 PS. All rights reserved.
//

#import "PagedImageScrollView.h"

@interface PagedImageScrollView () <UIScrollViewDelegate>
{
    NSMutableArray *arryImages;
}

@property (nonatomic) BOOL pageControlIsChangingPage;

@end

@implementation PagedImageScrollView


#define PAGECONTROL_DOT_WIDTH 30
#define PAGECONTROL_HEIGHT 30

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView      =      [[UIScrollView alloc] initWithFrame:frame];
        self.pageControl     =      [[UIPageControl alloc] init];
        [self setDefaults];
        [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        self.scrollView.delegate = self;
    }
    return self;
}


- (void)setPageControlPos:(enum PageControlPosition)pageControlPos
{
    CGFloat width = PAGECONTROL_DOT_WIDTH * self.pageControl.numberOfPages;
    _pageControlPos = pageControlPos;
    if (pageControlPos == PageControlPositionRightCorner)
    {
        self.pageControl.frame = CGRectMake(self.scrollView.frame.size.width - width, self.scrollView.frame.size.height+3 - PAGECONTROL_HEIGHT, width, PAGECONTROL_HEIGHT);
    }else if (pageControlPos == PageControlPositionCenterBottom)
    {
        self.pageControl.frame = CGRectMake((self.scrollView.frame.size.width - width) / 2, self.scrollView.frame.size.height+3 - PAGECONTROL_HEIGHT+20, width, PAGECONTROL_HEIGHT);
    }else if (pageControlPos == PageControlPositionLeftCorner)
    {
        self.pageControl.frame = CGRectMake(0, self.scrollView.frame.size.height+3 - PAGECONTROL_HEIGHT, width, PAGECONTROL_HEIGHT);
    }
}

- (void)setDefaults
{
    self.pageControl.currentPageIndicatorTintColor = [UIColor clearColor];
    [self.pageControl  setPageIndicatorTintColor:[UIColor clearColor]];
    self.pageControl.backgroundColor               = [UIColor clearColor];
    self.pageControl.hidesForSinglePage            = NO;
    self.scrollView.pagingEnabled                  = YES;
    self.scrollView.showsVerticalScrollIndicator   = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.pageControlPos                            = PageControlPositionRightCorner;
}
- (void)setScrollViewContents: (NSArray *)images {
    
    CGRect frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height-40);

    self.scrollView      =      [[UIScrollView alloc] initWithFrame:frame];
    self.pageControl     =      [[UIPageControl alloc] init];
    [self setDefaults];
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    self.scrollView.delegate = self;
    
    arryImages = [[NSMutableArray alloc] init];
    
    //remove original subviews first.
    for (UIView *subview in [self.scrollView subviews])
    {
        [subview removeFromSuperview];
    }
    
    if (images.count <= 0)
    {
        self.pageControl.numberOfPages = 0;
        return;
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height * images.count);
    
    for (int i = 0; i < images.count; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.scrollView.frame.size.height * i, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        imageView.image       = [UIImage imageNamed:[images objectAtIndex:i]];
        imageView.contentMode = UIViewContentModeScaleToFill;
        
        self.scrollView.tag   = i;
        [self.scrollView addSubview:imageView];
        imageView.clipsToBounds = YES;
        [arryImages addObject:imageView];
    }
    
    self.pageControl.numberOfPages = images.count;
    //self.pageControl.currentPage=1;
    self.pageControlPos = self.pageControlPos;
}

- (UIImageView *)getImage:(int) pos
{
    return [arryImages objectAtIndex:pos];
   
}

- (void)changePage:(UIPageControl *)sender
{
    CGRect frame   = self.scrollView.frame;
    frame.origin.x = frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size     = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    self.pageControlIsChangingPage = YES;
}

#pragma Scrollview Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.pageControlIsChangingPage)
    {
        return;
    }
    
    CGFloat pageWidth = scrollView.frame.size.width;
    //switch page at 50% across
    int page          = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    self.pageControl.currentPage = page;
    NSString *pos = [[NSString alloc] initWithFormat:@"%d",page];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:pos forKey:@"imgposition"];
   
      NSLog(@"content offset%ld",(long)self.pageControl.currentPage);
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControlIsChangingPage = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.pageControlIsChangingPage = NO;
}
@end
