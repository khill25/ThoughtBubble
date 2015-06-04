//
// Created by Kaili Hill on 6/4/15.
// Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SFNode : NSObject

@property (nonatomic) CGPoint connectedAt; // The point that another object's edge connects to this object
@property (nonatomic) CGSize size;
@property (nonatomic) CGPoint center;
@property (nonatomic) UIBezierPath *shapePath;
@property (nonatomic) NSString* content;
@property (nonatomic) NSInteger* weight;

@property (nonatomic) NSMutableArray *connections; // Nodes that are connected

-(id)initWithCenter:(CGPoint)center size:(CGSize)size;
-(void)addConnectionToNode:(SFNode*)connection;
-(void)addConnectionToNodes:(NSArray*)connections;

@end