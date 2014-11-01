//
//  Creature.m
//  GameOfLife
//
//  Created by Jigar Savla on 10/31/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Creature.h"

@implementation Creature

- (instancetype) initCreature {
    //since we made Creature with CCSprite, the super below refers to CCSprite's constructor
    self = [self initWithImageNamed:@"GameOfLifeAssets/Assets/bubble.png"];
    
    if (self) {
        // once 'init'ialized, then we set the default state to be not-alive
        self.isAlive = NO;
    }
    
    return self;
}

- (void)setIsAlive:(BOOL)newState {
    // when you create an @property as we did in the .h, an instance variable with leading underbar is created for you.
    _isAlive = newState;
    
    // 'visible' is a property of any class that inherits from CCNode. The inheritance hierarchy looks like: Creature <- CCSprite <- CCNode
    self.visible = _isAlive;
}

@end
