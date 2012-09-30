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
-(double)yValue:(double) x;
@end

@interface GraphView : UIView
@property (nonatomic, weak) IBOutlet id <GraphViewDataSource> dataSource;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGFloat scale;
@end
