//
//  GraphView.m
//  Calculator
//
//  Created by Roselle Milvich on 9/24/12.
//  Copyright (c) 2012 Roselle Milvich. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView
@synthesize dataSource = _dataSource;

-(void) setup{
//delete all setup
}

-(void) awakeFromNib{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)plotGraph{
    NSArray *yValues = self.dataSource.yValues;//position in array represents x, value y
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, [[yValues objectAtIndex:0] doubleValue]);

    for (int i = 1; i < yValues.count; i++) {
        CGContextAddLineToPoint(context, i, [[yValues objectAtIndex:i] doubleValue]);
    }
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}

- (void)drawRect:(CGRect)rect
{
    [AxesDrawer drawAxesInRect:self.frame originAtPoint:self.dataSource.origin scale:self.dataSource.scale];
    [self plotGraph];
}

@end
