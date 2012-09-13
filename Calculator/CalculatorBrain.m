//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Roselle Milvich on 9/5/12.
//  Copyright (c) 2012 Roselle Milvich. All rights reserved.
//

#import "CalculatorBrain.h"
@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain
@synthesize operandStack = _operandStack;

- (NSMutableArray *) operandStack{
if (!_operandStack)
        _operandStack = [[NSMutableArray alloc]init];
    return _operandStack;
}

-(double) popOperand{
    NSNumber *operandObject = [self.operandStack lastObject];
    if (operandObject) [self.operandStack removeLastObject];
    return operandObject.doubleValue;
}

-(void) pushOperand:(double) operand{
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

-(double) performOperation:(NSString*) operation{
    double result;
    if ([operation isEqualToString:@"+"]) 
        result = [self popOperand] + [self popOperand];
    else if ([operation isEqualToString:@"*"])
        result = [self popOperand] * [self popOperand];
    else if ([operation isEqualToString:@"-"]){
        double subtrahend = [self popOperand];
        double minuend = [self popOperand];
        if (minuend == 0) result = subtrahend;
        else
        result = minuend - subtrahend;
    }
    else if ([operation isEqualToString:@"/"]){
        double divisor = [self popOperand];
        if (divisor != 0) result = [self popOperand] / divisor;
        else result = 0;
    }
    else if ([operation isEqualToString:@"sin"])
        result = sin([self popOperand]);
    else if ([operation isEqualToString:@"cos"])
        result = cos([self popOperand]);
    else if ([operation isEqualToString:@"sqrt"])
        result = sqrt([self popOperand]);
    else if ([operation isEqualToString:@"pi"])
        result = 3.14159265359;
    else if ([operation isEqualToString:@"+/-"])
        result = -1 * [self popOperand];
    [self pushOperand:result];
    return result;
}

-(void) clearData{
    self.operandStack = nil;//this okay to clear?
}

-(NSString*)description{
    return [NSString stringWithFormat:@"Brain's stack: %@",self.operandStack];
}

@end
