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
//@property (nonatomic) double scale;
//@property (nonatomic) CGPoint origin;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.infixDisplay.text = [CalculatorBrain descriptionOfProgram:self.program];
//    self.graphView gesture
    
    self.scale = 1.0;
    self.origin = CGPointMake(0, 0);
    
//    [[AxesDrawer class] drawAxesInRect:self.graphView.frame originAtPoint:self.origin scale:self.scale];
    
    NSDictionary *variableValues = [NSDictionary dictionaryWithObject:[NSNull null] forKey:@"x"];
    [CalculatorBrain runProgram:self.program usingVariableValues:variableValues];
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
