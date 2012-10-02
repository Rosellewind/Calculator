//
//  GraphView.m
//  Calculator
//
//  Created by Roselle Milvich on 9/24/12.
//  Copyright (c) 2012 Roselle Milvich. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"
#import "CalculatorBrain.h"

#define DEFAULT_SCALE 10.0
#define DEFAULT_X(w) w/2
#define DEFAULT_Y(h) h/2

@interface GraphView()

@end

@implementation GraphView
@synthesize dataSource = _dataSource;
@synthesize origin = _origin;
@synthesize scale = _scale;

-(CGPoint)origin{
    if (!_origin.x){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        id originX = [defaults objectForKey:@"originX"];
        id originY = [defaults objectForKey:@"originY"];

        if ([originX isKindOfClass:[NSNumber class]] && [originY isKindOfClass:[NSNumber class]]) {
            return CGPointMake([originX doubleValue], [originY doubleValue]);
        }
        else return CGPointMake(DEFAULT_X(self.frame.size.width), DEFAULT_Y(self.frame.size.height));
    }
    else return _origin;
}
-(void)setOrigin:(CGPoint)origin{
    if (origin.x != _origin.x && origin.y != _origin.y) {
        _origin.x = origin.x;
        _origin.y = origin.y;
        [self setNeedsDisplay];
    }
}
-(CGFloat)scale{
    if (!_scale){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        id scale = [defaults objectForKey:@"scale"];
        if ([scale isKindOfClass:[NSNumber class]])
            return [scale doubleValue];
        else return DEFAULT_SCALE;

    }
    else return _scale;
}
-(void)setScale:(CGFloat)scale{
    if (scale != _scale){
        _scale = scale;
        [self setNeedsDisplay];
    }
}
-(void) setup{

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

-(NSArray*) getJValues{
    NSMutableArray *jValues = [[NSMutableArray alloc]init];
    //i and j are pixel positions, x and y are graph positions
    int pixels = self.frame.size.width * self.contentScaleFactor;
    for (double i = 0; i<pixels; i++) {
        double x = (i - self.origin.x*self.contentScaleFactor)/(self.scale * self.contentScaleFactor);
        double y = [self.dataSource yValue:x];
        double j = self.origin.y * self.contentScaleFactor - y * self.contentScaleFactor * self.scale;
        [jValues addObject:[NSNumber numberWithDouble:j]];
    }
    return [jValues copy];
}

-(void)plotGraph{
    
    //position in array is i, value  is j
    NSArray *jValues = [self  getJValues];
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, [[jValues objectAtIndex:0] doubleValue]);

    for (double i = 1; i < jValues.count; i++) {
        CGContextAddLineToPoint(context, i/self.contentScaleFactor, [[jValues objectAtIndex:i] doubleValue]/self.contentScaleFactor);
    }
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}

- (void)drawRect:(CGRect)rect
{
    [AxesDrawer drawAxesInRect:self.frame originAtPoint:self.origin scale:self.scale];
    [self plotGraph];
}

-(void)pinch:(UIPinchGestureRecognizer*)gesture{
    if (gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded){
        self.scale *= gesture.scale;
        gesture.scale = 1;
    }
    if (gesture.state == UIGestureRecognizerStateEnded) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setDouble:self.scale forKey:@"scale"];
        [defaults synchronize];
    }
}

-(void)pan:(UIPanGestureRecognizer*)gesture{
        if (gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded){
            CGPoint translation = [gesture translationInView:self];
            self.origin = CGPointMake(self.origin.x + translation.x, self.origin.y + translation.y);
            [gesture setTranslation:CGPointZero inView:self];
        }
    if (gesture.state == UIGestureRecognizerStateEnded) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setDouble:self.origin.x forKey:@"originX"];
        [defaults setDouble:self.origin.y forKey:@"originY"];
        [defaults synchronize];
    }
}
-(void)tripleTap:(UITapGestureRecognizer*)gesture{
    if (gesture.state == UIGestureRecognizerStateEnded){
        self.origin = [gesture locationInView:self];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setDouble:self.origin.x forKey:@"originX"];
        [defaults setDouble:self.origin.y forKey:@"originY"];
        [defaults synchronize];
    }
}

@end
