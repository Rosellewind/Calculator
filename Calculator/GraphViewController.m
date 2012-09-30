//
//  GraphViewController.m
//  Calculator
//
//  Created by Roselle Milvich on 9/23/12.
//  Copyright (c) 2012 Roselle Milvich. All rights reserved.
//

#import "GraphViewController.h"
#import "CalculatorBrain.h"
#import "AxesDrawer.h"


@interface GraphViewController ()

@end

@implementation GraphViewController
@synthesize program = _program;
@synthesize infixDisplay = _infixDisplay;
@synthesize graphView = _graphView;
@synthesize scale = _scale;
@synthesize origin = _origin;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSArray*)yValues{
    NSMutableArray *yValues = [[NSMutableArray alloc]init];

    //i and j are pixel positions, x and y are graph positions
    for (double i = 0; i<self.graphView.frame.size.width; i++) {
        double x = (i - self.origin.x)/self.scale;
        double y = [CalculatorBrain runProgram:self.program usingVariableValues:[NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:x] forKey:@"x"]];
        double j = self.origin.y - self.scale * y;
        [yValues addObject:[NSNumber numberWithDouble:j]];
        NSLog(@"x:%f, y:%f, i:%f, j:%f",x,y,i,j);
    }
    return [yValues copy];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.infixDisplay.text = [CalculatorBrain descriptionOfProgram:self.program];
//    self.graphView gesture
    
#define DEFAULT_SCALE 10.0

    self.scale = DEFAULT_SCALE;
    self.origin = CGPointMake(self.graphView.frame.size.width/2, self.graphView.frame.size.height/2);
}

- (void)viewDidUnload
{
    [self setInfixDisplay:nil];
    [self setGraphView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
