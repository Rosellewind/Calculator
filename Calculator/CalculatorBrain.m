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

-(void) pushOperand:(id) operand{
    if (operand) {
        [self.programStack addObject:operand];
    }
}

-(double) performOperation:(NSString*) operation{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}

-(double) performOperation:(NSString*) operation usingVariableValues:(NSDictionary *)variableValues{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program usingVariableValues:variableValues];

}

+ (BOOL)isVariable:(NSString *)variable{
    char firstChar = [variable characterAtIndex:0];
    if (firstChar >= 'A' && firstChar <= 'z'  && ![self isOperation:variable])
        return YES;
    else return NO;
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


+ (NSSet *)variablesUsedInProgram:(id)program{
    NSMutableSet *variables;
    for (id obj in program)
    {
        if ([obj isKindOfClass:[NSString class]] && [self isVariable:obj]){
                //alloc local 'variables' if needed
                if (!variables) variables = [[NSMutableSet alloc]init];
                [variables addObject:obj];
        }
    }
    NSLog(@"variables: %@",variables);
    return [variables copy];//copy?
}

+(double) runProgram:(id)program{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues{
    __strong NSMutableArray *programArray = [program mutableCopy];
    
    //replace variables with numbers
    if (variableValues && [programArray isKindOfClass:[NSArray class]]){
        NSSet *variables = [self variablesUsedInProgram:programArray];
        
        //go through the program array
        for (int i = 0; i< programArray.count; i++) {
            id obj = [programArray objectAtIndex:i];
            BOOL needsExchange = NO;

            //go through variables present in program
            for (NSString *var in variables) {
                
                //make sure its a string before checking isVariable
                if ([obj isKindOfClass:[NSString class]]
                    && [self isVariable:obj]){
                    needsExchange = YES;
                    
                    //replace value for variable, make sure value exists first
                    if ([var isEqualToString:obj] && [variableValues objectForKey:obj]){
                        [programArray replaceObjectAtIndex:i withObject:[variableValues objectForKey:obj]];
                        needsExchange = NO;
                        break;
                    }
                }
            }
            if (needsExchange)
                [programArray replaceObjectAtIndex:i withObject:[NSNumber numberWithDouble:0]];
        }
    }
    return [self runProgram:programArray];
}



-(NSString*) descriptionOfProgram:(id)program{
    if (program)
        return [[self class]descriptionOfProgram:program];
    else{
        return [[self class]descriptionOfProgram:self.programStack];
    }
}

+(NSString*) descriptionOfProgram:(id)program{
    return @"";
}

+ (BOOL)isOperation:(NSString *)operation{
    return NO;
}

-(void) clearData{
    self.programStack = nil;//this okay to clear?
}

-(NSString*)description{
    return [NSString stringWithFormat:@"Brain's stack: %@",self.programStack];
}

@end
