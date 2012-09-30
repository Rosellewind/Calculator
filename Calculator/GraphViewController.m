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



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(double)yValue:(double) x{
    return [CalculatorBrain runProgram:self.program usingVariableValues:[NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:x] forKey:@"x"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.infixDisplay.text = [CalculatorBrain descriptionOfProgram:self.program];
//    self.graphView gesture
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
