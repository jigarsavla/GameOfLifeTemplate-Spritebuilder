//
//  Grid.m
//  GameOfLife
//
//  Created by Jigar Savla on 10/31/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Grid.h"
#import "Creature.h"

// these are variables that cannot be changed
static const int GRID_ROWS = 8;
static const int GRID_COLUMNS = 10;

@implementation Grid {
    NSMutableArray *_gridArray;
    float _cellWidth;
    float _cellHeight;
}

- (void)onEnter
{
    [super onEnter];
    [self setupGrid];
    
    //accept touches on the grid
    self.userInteractionEnabled = YES;
}

- (void)setupGrid
{
    // divide the grid's size by the number of columns/rows to figure out the right width and height of each cell
    _cellWidth = self.contentSize.width / GRID_COLUMNS;
    _cellHeight = self.contentSize.height / GRID_ROWS;
    
    float x = 0;
    float y = 0;
    
    // initialize the array as a blank NSMutableArray
    _gridArray = [NSMutableArray array];
    
    // initialize Creatures
    for (int i = 0; i < GRID_ROWS; i++) {
        // this is how you create two dimensional arrays in Objective-C. You put arrays into arrays.
        _gridArray[i] = [NSMutableArray array];
        x = 0;
        
        for (int j = 0; j < GRID_COLUMNS; j++) {
            Creature *creature = [[Creature alloc] initCreature];
            creature.anchorPoint = ccp(0, 0);
            creature.position = ccp(x, y);
            [self addChild:creature];
            
            // this is shorthand to access an array inside an array
            _gridArray[i][j] = creature;
            
            // make creatures visible to test this method, remove this once we know we have filled the grid properly
                //creature.isAlive = YES;
            
            x+=_cellWidth;
        }
        
        y += _cellHeight;
    }
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    // get x,y co-ordinates of the touch
    CGPoint touchLocation = [touch locationInNode:self];
    
    // get the creature at that point
    Creature *creature = [self creatureForTouchPosition:touchLocation];
    
    //invert its state
    creature.isAlive = !creature.isAlive;
}

- (Creature *)creatureForTouchPosition:(CGPoint)touchPosition
{
    //get the row and column that was touched, return the Creature inside the corresponding cell
    int row    = touchPosition.y/_cellHeight;
    int column = touchPosition.x/_cellWidth;
    return _gridArray[row][column];
    
}

- (void) evolveStep
{
    // update each Creature's neighobor count
    [self countNeighbors];
    
    //update each Creature's current state
    [self updateCreatures];
    
    //update the generation label, so it shows the correct generation
    _generation++;
}

- (void) countNeighbors
{
    // iterate through the rows
    // NSArray has a method 'count' that will return the number of elements in the array
    for (int i= 0; i < [_gridArray count]; i++)
    {
        //iterate through columns
        for (int j=0; j < [_gridArray[i] count]; j++)
        {
            Creature *currentCreature = _gridArray[i][j];
            int neighborCount = 0;
            // now we calculate how many neighbors are alive
            // first go through the neighborhood rows
            for (int x=(i-1); x<=(i+1); x++) {
                for (int y=(j-1); y<=(j+1); y++) {
                    BOOL isIndexValid = [self isIndexValid:x andY:y];
                    
                    // if its valid and on-screen + its not the creature itself
                    if (isIndexValid
                        && !(x==i && y==j) )
                    {
                        Creature *neighborCreature = _gridArray[x][y];
                        if ([neighborCreature isAlive]) {
                            neighborCount++;
                        }
                    }
                }
            }
            currentCreature.livingNeighbors = neighborCount;
        }
        
    }

}

- (BOOL) isIndexValid:(NSInteger)x andY:(NSInteger)y
{
    if (x<0
        || y<0
        || x>= GRID_ROWS
        || y>= GRID_COLUMNS)
        return FALSE;
    else
        return TRUE;
}

- (void) updateCreatures
{
    // iterate through the rows
    // NSArray has a method 'count' that will return the number of elements in the array
    for (int i= 0; i < [_gridArray count]; i++)
    {
        //iterate through columns
        for (int j=0; j < [_gridArray[i] count]; j++)
        {
            Creature *currentCreature = _gridArray[i][j];
            if (([currentCreature livingNeighbors] >= 4)
                || ([currentCreature livingNeighbors] <= 1))
            {
                currentCreature.isAlive = FALSE;
            }
            else
            {
                currentCreature.isAlive = TRUE;
            }
        }
    }
}


@end
