//
//  Grid.h
//  GameOfLife
//
//  Created by Jigar Savla on 10/31/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Grid : CCSprite

@property (nonatomic,assign) int totalAlive;
@property (nonatomic,assign) int generation;

@end