//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Roselle Milvich on 9/5/12.
//  Copyright (c) 2012 Roselle Milvich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject
-(void) pushOperand:(double) operand;
-(double) performOperation:(NSString*) operation;
-(void) clearData;
-(NSString*) description;

@property (nonatomic, readonly) id program;

+(double) runProgram:(id)program;
+(NSString*) descriptionOfProgram:(id)program;

@end
