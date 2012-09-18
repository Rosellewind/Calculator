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
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringAVariable;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSMutableDictionary *variableValues;
@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize history = _history;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize userIsInTheMiddleOfEnteringAVariable = _userIsInTheMiddleOfEnteringAVariable;
@synthesize brain = _brain;
@synthesize values = _values;
@synthesize description = _description;
@synthesize variableValues = _variableValues;


-(CalculatorBrain*) brain{
    if (!_brain) _brain = [[CalculatorBrain alloc]init];
    return _brain;
}

-(NSMutableDictionary*) variableValues{
    if (!_variableValues) _variableValues = [[NSMutableDictionary alloc]init];
    return _variableValues;
}

- (void) addToHistory:(NSString*)string{
    self.history.text = [self.history.text stringByAppendingFormat:@"%@ ",string];
    if (self.history.text.length > 40) {
        self.history.text = [self.history.text substringFromIndex:self.history.text.length-40];
    }
}

- (IBAction)enterPressed {
    NSString *stringOfOperand = self.display.text;
    id operand;
    if (self.userIsInTheMiddleOfEnteringANumber){
        operand = [NSNumber numberWithDouble:stringOfOperand.doubleValue];
        [self addToHistory:stringOfOperand];
    }
    else if (self.userIsInTheMiddleOfEnteringAVariable){
        if ([self isValidVariable:stringOfOperand]){
            operand = stringOfOperand;
            [self addToHistory:stringOfOperand];
        }
        else self.display.text = @"0";

    }
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userIsInTheMiddleOfEnteringAVariable = NO;
    [self.brain pushOperand:operand];
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    BOOL isDecimal = NO;
    
    if (self.userIsInTheMiddleOfEnteringAVariable)
        [self enterPressed];
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
    if (self.userIsInTheMiddleOfEnteringAVariable)
        self.display.text = [self.display.text stringByAppendingString:digit];
    else
        self.display.text = [NSString stringWithFormat:@"%@",digit];
    self.userIsInTheMiddleOfEnteringAVariable = YES;
}

- (IBAction)operationPressed:(UIButton*)sender {
    if (self.userIsInTheMiddleOfEnteringANumber || self.userIsInTheMiddleOfEnteringAVariable)
        [self enterPressed];
    NSString *operation = sender.currentTitle;
    [self addToHistory:operation];
    [self addToHistory:@"="];
    double result = [self.brain performOperation:operation usingVariableValues:self.variableValues];
    //[[self.brain class] runProgram:operation usingVariableValues:self.variableValues];
    //double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%.12g", result];
}

- (IBAction)signPressed:(UIButton *)sender {
    NSString *valueString = self.display.text;
    if (self.userIsInTheMiddleOfEnteringAVariable){
        if ([valueString characterAtIndex:0] == '-')
            self.display.text = [self.display.text substringFromIndex:1];
        else self.display.text = [@"-" stringByAppendingString:self.display.text];
    }
    else if (self.userIsInTheMiddleOfEnteringANumber) {
        double value = valueString.doubleValue;
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

- (IBAction)deletePressed:(UIButton *)sender {
    int length = self.display.text.length;
    if ((self.userIsInTheMiddleOfEnteringANumber || self.userIsInTheMiddleOfEnteringAVariable) && length > 0)
        self.display.text = [self.display.text substringToIndex:length-1];
}

- (IBAction)clearPressed:(UIButton *)sender {
    self.history.text = @"";
    self.display.text = @"";
    self.userIsInTheMiddleOfEnteringANumber = NO;
    [self.brain clearData];
}

- (BOOL)isValidVariable:(NSString *)variable{

    if (variable != @"sin" && variable != @"cos" && variable != @"Enter" && variable != @"sqrt" && variable != @"pi" && variable != @"clear" && variable != @"delete" && variable != @"test 1" && variable != @"test 2")
        return YES;
    else return NO;
}

//this is a temporary method, delete later, dynamically update textfield later if implemented
- (IBAction)testPressed:(UIButton *)sender {
    if (sender.tag == 1){
        [self.variableValues setValue:[NSNumber numberWithDouble:3.4] forKey:@"a"];
        [self.variableValues setValue:[NSNumber numberWithDouble:4.5] forKey:@"b"];
        [self.variableValues setValue:[NSNumber numberWithDouble:5.8] forKey:@"ab"];
        [self.variableValues setValue:[NSNumber numberWithDouble:1.2] forKey:@"ba"];
        [self.variableValues setValue:[NSNumber numberWithDouble:99.8] forKey:@"aba"];
        [self.variableValues setValue:[NSNumber numberWithDouble:2630.0] forKey:@"bab"];
        self.values.text = @"a = 3.4, b = 4.5, ab = 5.8, ba = 1.2, aba = 99.8, bab = 2630";
    }
    else if (sender.tag == 2){
        [self.variableValues setValue:[NSNumber numberWithDouble:1.0] forKey:@"a"];
        [self.variableValues setValue:[NSNumber numberWithDouble:2.0] forKey:@"b"];
        [self.variableValues setValue:[NSNumber numberWithDouble:3.0] forKey:@"ab"];
        [self.variableValues setValue:[NSNumber numberWithDouble:12.3] forKey:@"ba"];
        [self.variableValues setValue:[NSNumber numberWithDouble:870.0] forKey:@"aba"];
        [self.variableValues setValue:[NSNumber numberWithDouble:999.88] forKey:@"bab"];
        self.values.text = @"a = 1, b = 2, ab = 3, ba = 12.3, aba = 870, bab = 999.88";
    }
    else {
        self.variableValues = nil;
        self.values.text = @"variables = zero";
    }
}
- (IBAction)descriptionPressed {
    [self.brain descriptionOfProgram:nil];
}

- (void)viewDidUnload {
    [self setDescription:nil];
    [super viewDidUnload];
}
@end























