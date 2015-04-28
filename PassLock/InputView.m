//
//  InputView.m
//  PrivateAlbums
//
//  Created by Du xuechao on 15/4/21.
//  Copyright (c) 2015年 Du xuechao. All rights reserved.
//

#import "InputView.h"
#define numCount1 4

@implementation InputView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
//        self.frame = frame;
//        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 63)];
        self.backgroundColor = [UIColor grayColor];
        self.tag = 11;
        CGFloat spacex = 10;
        CGFloat imagewidth = 61;
        CGFloat fromx = (SCREEN_WIDTH - (spacex + imagewidth) * 3 - imagewidth)/2;
        for (int i = 0; i < numCount1; i++)
        {
            UIImageView * backImageView = [[UIImageView alloc] init];
            backImageView.image = [UIImage imageNamed:@"box_empty"];
            backImageView.tag = i;
            backImageView.frame = CGRectMake((spacex+ imagewidth) * i+ fromx, 5, imagewidth, 53);
            [self addSubview:backImageView];
        }
    }
    return self;
}
@end
