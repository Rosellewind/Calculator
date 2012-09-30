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

-(void) popOffProgramStack{
    
    if (self.programStack.count >0) [self.programStack removeLastObject];
}

-(double) performOperation:(NSString*) operation{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}

-(double) performOperation:(NSString*) operation usingVariableValues:(NSDictionary *)variableValues{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program usingVariableValues:variableValues];

}

- (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues{
    if (program) {
        return [[self class] runProgram:program usingVariableValues:variableValues];
        
    }
    return [[self class] runProgram:self.program usingVariableValues:variableValues];
}

-(void) clearData{
    self.programStack = nil;//this okay to clear?
}

-(NSString*)description{
    return [NSString stringWithFormat:@"Brain's stack: %@",self.programStack];
}

-(NSString*) descriptionOfProgram:(id)program{
    if (program)
        return [[self class]descriptionOfProgram:program];
    else{
        return [[self class]descriptionOfProgram:self.programStack];
    }
}

+(double)popOperandOffStack:(NSMutableArray*)stack{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    NSLog(@"topOfStack:%@",topOfStack);
    NSLog(@"stack:%@",stack);
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

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues{
    NSMutableArray *programArray = [program mutableCopy];
    
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

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack previousOperation:(NSString*)previousOperation
{
        NSString *description;
        id topOfStack = [stack lastObject];
        if (topOfStack) [stack removeLastObject];
    
        if ([self isBinaryOperation:topOfStack]){          
            NSString *secondOperand = [[self class] descriptionOfTopOfStack:stack previousOperation:topOfStack];
            NSString *firstOperand = [[self class] descriptionOfTopOfStack:stack previousOperation:topOfStack];
            if ([self extraParenthesesInnerOperator:topOfStack outerOperator:previousOperation])
                description = [NSString stringWithFormat:@"%@ %@ %@", firstOperand, topOfStack, secondOperand];
            else description = [NSString stringWithFormat:@"(%@ %@ %@)", firstOperand, topOfStack, secondOperand];
        }
        else if ([self isUnaryOperation:topOfStack]){
            description = [NSString stringWithFormat:@"%@(%@)", topOfStack, [[self class] descriptionOfTopOfStack:stack previousOperation:@"unary"]];
        }
        else if ([topOfStack isKindOfClass:[NSNumber class]])
            description = [topOfStack stringValue];//operand
        else if ([topOfStack isKindOfClass:[NSString class]])
            description = topOfStack;//pi or variable
        else description = @"~";
    return description;
}

+(NSString*) descriptionOfProgram:(id)program{
    NSString *description;
    if ([program isKindOfClass:[NSArray class]]){
        NSMutableArray *stack = [program mutableCopy];
        NSMutableArray *programList = [[NSMutableArray alloc] init];
    
        // get descriptions of sub-programs
        while ([stack count] > 0) {
            [programList addObject:[self descriptionOfTopOfStack:stack previousOperation:nil]];
        }
        
        //join descriptions with ','
        description =  [programList componentsJoinedByString:@", "];
    }
    return description;
}

+ (BOOL)extraParenthesesInnerOperator:(NSString*)innerOperator outerOperator:(NSString*)outerOperator{
    if ([innerOperator isEqualToString:@"/"] ||
        [outerOperator isEqualToString:@"/"] ||
        ([outerOperator isEqualToString:@"*"] && ![innerOperator isEqualToString:@"*"]))
         return NO;
    else return YES;
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
    return [variables copy];//copy?
}

+ (BOOL)isVariable:(NSString *)variable{
    char firstChar = [variable characterAtIndex:0];
    if (firstChar >= 'A' && firstChar <= 'z'  && ![self isOperation:variable])
        return YES;
    else return NO;
}

+ (BOOL)isOperation:(NSString *)operation{
    NSArray *operations = [NSArray arrayWithObjects:@"*", @"/", @"+", @"-", @"sin", @"cos", @"sqrt", @"pi", nil];
    return ([operations containsObject:operation]);
}

+ (BOOL)isBinaryOperation:(NSString*)operation{
    NSSet *operations = [NSSet setWithObjects:@"*", @"/", @"+", @"-", nil];
    if ([operations containsObject:operation])
        return YES;
    else return NO;
}

+ (BOOL)isUnaryOperation:(NSString *)operation{
    NSArray *operations = [NSArray arrayWithObjects:@"sin", @"cos", @"sqrt", nil];
    return ([operations containsObject:operation]);
}

@end
