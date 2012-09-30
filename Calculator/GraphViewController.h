//
//  GraphViewController.h
//  Calculator
//
//  Created by Roselle Milvich on 9/23/12.
//  Copyright (c) 2012 Roselle Milvich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"

@interface GraphViewController : UIViewController<GraphViewDataSource>
@property (nonatomic, strong) id program;//model
@property (weak, nonatomic) IBOutlet UILabel *infixDisplay;
@property (weak, nonatomic) IBOutlet GraphView *graphView;

@end
