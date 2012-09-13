//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Roselle Milvich on 9/5/12.
//  Copyright (c) 2012 Roselle Milvich. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize history = _history;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

-(CalculatorBrain*) brain{
    if (!_brain) _brain = [[CalculatorBrain alloc]init];
    return _brain;
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

- (IBAction)operationPressed:(UIButton*)sender {
    if (self.userIsInTheMiddleOfEnteringANumber)
        [self enterPressed];
    NSString *operation = sender.currentTitle;
    [self addToHistory:operation];
    [self addToHistory:@"="];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%.12g", result];
}

- (IBAction)signPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        double value = self.display.text.doubleValue;
        if (value < 0) {
            self.display.text = [self.display.text substringFromIndex:1];
        }
        else self.display.text = [@"-" stringByAppendingString:self.display.text];
    }
    else{
        NSString *operation = sender.currentTitle;
        [self addToHistory:operation];
        [self addToHistory:@"="];
        double result = [self.brain performOperation:operation];
        self.display.text = [NSString stringWithFormat:@"%.12g", result];
    }
}

- (IBAction)enterPressed {
    [self addToHistory:self.display.text];
    [self.brain pushOperand:self.display.text.doubleValue];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}
- (IBAction)deletePressed:(UIButton *)sender {
    int length = self.display.text.length;
    if (self.userIsInTheMiddleOfEnteringANumber && length > 0)
        self.display.text = [self.display.text substringToIndex:length-1];
}

- (IBAction)clearPressed:(UIButton *)sender {
    self.history.text = @"";
    self.display.text = @"";
    self.userIsInTheMiddleOfEnteringANumber = NO;
    [self.brain clearData];
}


- (void) addToHistory:(NSString*)string{
    self.history.text = [self.history.text stringByAppendingFormat:@"%@ ",string];
    if (self.history.text.length > 40) {
        self.history.text = [self.history.text substringFromIndex:self.history.text.length-40];
    }
}

@end























