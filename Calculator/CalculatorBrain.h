//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Roselle Milvich on 9/5/12.
//  Copyright (c) 2012 Roselle Milvich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject
-(void) pushOperand:(id) operand;
-(double) performOperation:(NSString*) operation;
-(double) performOperation:(NSString*) operation usingVariableValues:(NSDictionary *)variableValues;;

-(void) clearData;
-(NSString*) description;

@property (nonatomic, readonly) id program;

+(double) runProgram:(id)program;
    + (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
-(NSString*) descriptionOfProgram:(id)program;
+(NSString*) descriptionOfProgram:(id)program;

@end
