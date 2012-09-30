//
//  GraphView.h
//  Calculator
//
//  Created by Roselle Milvich on 9/24/12.
//  Copyright (c) 2012 Roselle Milvich. All rights reserved.
//

#import <UIKit/UIKit.h>

//protocol here datasource
@protocol GraphViewDataSource <NSObject>
@property (nonatomic) CGPoint origin;
@property (nonatomic) float scale;

-(NSArray*)yValues;

@end

@interface GraphView : UIView
@property (nonatomic, weak) IBOutlet id <GraphViewDataSource> dataSource;
@end
