//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Roselle Milvich on 9/5/12.
//  Copyright (c) 2012 Roselle Milvich. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphViewController.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSMutableDictionary *variableValues;
@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize infixDisplay = _infixDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize variableValues = _variableValues;


-(CalculatorBrain*) brain{
    if (!_brain) _brain = [[CalculatorBrain alloc]init];
    return _brain;
}

-(NSMutableDictionary*) variableValues{
    if (!_variableValues) _variableValues = [[NSMutableDictionary alloc]init];
    return _variableValues;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    BOOL isDecimal = NO;
    
    if ([digit isEqualToString:@"."]) isDecimal = YES;
    
    if (self.userIsInTheMiddleOfEnteringANumber){
        if (isDecimal && [self.display.text rangeOfString:@"."].location != NSNotFound)
            return;
        self.display.text = [self.display.text stringByAppendingString:digit];
    }
    else {
        if (isDecimal)
            self.display.text = @"0.";
        else
            self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)variablePressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    if (self.userIsInTheMiddleOfEnteringANumber)
        [self enterPressed];
    self.display.text = [NSString stringWithFormat:@"%@",digit];
}

- (IBAction)operationPressed:(UIButton*)sender {
    if (self.userIsInTheMiddleOfEnteringANumber || [self.display.text isEqualToString:@"x"])
        [self enterPressed];
    NSString *operation = sender.currentTitle;
    double result = [self.brain performOperation:operation usingVariableValues:self.variableValues];
    self.display.text = [NSString stringWithFormat:@"%.12g", result];
    [self displayInfix];

}

- (IBAction)signPressed:(UIButton *)sender {
    NSString *valueString = self.display.text;
    if (self.userIsInTheMiddleOfEnteringANumber) {
        double value = valueString.doubleValue;
        if (value < 0) {
            self.display.text = [self.display.text substringFromIndex:1];
        }
        else self.display.text = [@"-" stringByAppendingString:self.display.text];
    }
    else if ([self.display.text isEqualToString:@"x"])
        self.display.text = @"-x";
    else if ([self.display.text isEqualToString:@"-x"])
        self.display.text = @"x";
    else{
        NSString *operation = sender.currentTitle;
        double result = [self.brain performOperation:operation];
        self.display.text = [NSString stringWithFormat:@"%.12g", result];
    }
}

- (IBAction)enterPressed {
    NSString *stringOfOperand = self.display.text;
    id operand;
    if (self.userIsInTheMiddleOfEnteringANumber){
        operand = [NSNumber numberWithDouble:stringOfOperand.doubleValue];
    }
    else if ([stringOfOperand isEqualToString:@"x"] || [stringOfOperand isEqualToString:@"-x"]){
        operand = stringOfOperand;
    }

    self.userIsInTheMiddleOfEnteringANumber = NO;
    [self.brain pushOperand:operand];
    [self displayInfix];
}

- (IBAction)deletePressed{
    int length = self.display.text.length;
    if (self.userIsInTheMiddleOfEnteringANumber && length > 0)
        self.display.text = [self.display.text substringToIndex:length-1];
}

- (IBAction)clearPressed{
    self.infixDisplay.text = @"";
    self.display.text = @"";
    self.userIsInTheMiddleOfEnteringANumber = NO;
    [self.brain clearData];
}
- (IBAction)undoPressed:(id)sender {
    if (self.userIsInTheMiddleOfEnteringANumber){
            [self deletePressed];
         if (self.display.text.length == 0){
            self.userIsInTheMiddleOfEnteringANumber = NO;
        }
    }
    else{
        [self.brain popOffProgramStack];
        double result = [self.brain runProgram:nil usingVariableValues:self.variableValues];
        self.display.text = [NSString stringWithFormat:@"%.12g", result];
        [self displayInfix];
    }
}

- (void) displayInfix{
    self.infixDisplay.text = [[self brain] descriptionOfProgram:nil];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.destinationViewController isKindOfClass:[GraphViewController class]]) {
        GraphViewController *vc = segue.destinationViewController;
        vc.program = [self.brain program];
    }
}

-(GraphViewController*) splitViewGraphViewController{
    id gvc = [self.splitViewController.viewControllers lastObject];
    if (![gvc isKindOfClass:[GraphViewController class]])
        gvc = nil;
    return gvc;

}

- (IBAction)updateGraph {
    [[self splitViewGraphViewController] setProgram:self.brain.program];
}

-(BOOL) splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation{
    return NO;
}

-(void) awakeFromNib{
    self.splitViewController.delegate = self;
}

- (void)viewDidUnload {
    [self setInfixDisplay:nil];
    [super viewDidUnload];
}
@end























