//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Roselle Milvich on 9/5/12.
//  Copyright (c) 2012 Roselle Milvich. All rights reserved.
//

#import "CalculatorBrain.h"
@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain
@synthesize programStack = _programStack;

- (NSMutableArray *) programStack{
if (!_programStack)
        _programStack = [[NSMutableArray alloc]init];
    return _programStack;
}

-(id) program{
    return [self.programStack copy];
}

-(void) pushOperand:(double) operand{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

-(double) performOperation:(NSString*) operation{

    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}

+(double)popOperandOffStack:(NSMutableArray*)stack{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]]){
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"])
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        else if ([operation isEqualToString:@"*"])
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        else if ([operation isEqualToString:@"-"]){
            double subtrahend = [self popOperandOffStack:stack];
            double minuend = [self popOperandOffStack:stack];
            if (minuend == 0) result = subtrahend;
            else
                result = minuend - subtrahend;
        }
        else if ([operation isEqualToString:@"/"]){
            double divisor = [self popOperandOffStack:stack];
            if (divisor != 0) result = [self popOperandOffStack:stack] / divisor;
            else result = 0;
        }
        else if ([operation isEqualToString:@"sin"])
            result = sin([self popOperandOffStack:stack]);
        else if ([operation isEqualToString:@"cos"])
            result = cos([self popOperandOffStack:stack]);
        else if ([operation isEqualToString:@"sqrt"])
            result = sqrt([self popOperandOffStack:stack]);
        else if ([operation isEqualToString:@"pi"])
            result = 3.14159265359;
        else if ([operation isEqualToString:@"+/-"])
            result = -1 * [self popOperandOffStack:stack];
    }
    return result;
}

+(double) runProgram:(id)program{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}


+(NSString*) descriptionOfProgram:(id)program{
    return @"";
}


-(void) clearData{
    self.programStack = nil;//this okay to clear?
}

-(NSString*)description{
    return [NSString stringWithFormat:@"Brain's stack: %@",self.programStack];
}

@end
