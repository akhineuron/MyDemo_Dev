//
//  PagedImageScrollView.h
//  Test
//
//  Created by jianpx on 7/11/13.
//  Copyright (c) 2013 PS. All rights reserved.
//

#import <UIKit/UIKit.h>

enum PageControlPosition {
    PageControlPositionRightCorner = 0,
    PageControlPositionCenterBottom = 1,
    PageControlPositionLeftCorner = 2,
    
    };

@protocol PageControllerDelegate <NSObject>
@required
- (void)didScrollPage : (int) page;
@end

@interface PagedImageScrollView : UIView
{
    id <PageControllerDelegate> delegate;
}

@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) enum PageControlPosition pageControlPos; //default is PageControlPositionRightCorner

@property (nonatomic, assign) BOOL isColorGallery;

- (UIImageView *)getImage:(int) pos;
- (void)setScrollViewContents: (NSArray *)images;
- (void)changePage:(UIPageControl *)sender;
//- (void)setScrollViewContents1: (NSArray *)images1 :(NSArray *) imagename1;
@end
