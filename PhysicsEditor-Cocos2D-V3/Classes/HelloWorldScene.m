//
//  HelloWorldScene.m
//  PhysicsEditor-Cocos2D-V3
//
//  Created by Joachim Grill on 10.04.14.
//  Copyright CodeAndWeb GmbH 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "HelloWorldScene.h"
#import "GCCShapeCache.h"

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation HelloWorldScene
{
    CCPhysicsNode *_physicsWorld;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (void)spawnSprite:(NSString *)name atPos:(CGPoint)pos
{
    CCSprite *sprite = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"%@.png", name]];
    sprite.position = pos;
    [[GCCShapeCache sharedShapeCache] setBodyWithName:name onNode:sprite];
    [_physicsWorld addChild:sprite];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;

    // Load shapes
    [[GCCShapeCache sharedShapeCache] addShapesWithFile:@"Shapes.plist"];
    
    // Load background image
    CCSprite *background = [CCSprite spriteWithImageNamed:@"background.png"];
    background.anchorPoint = ccp(0,0);
    [self addChild:background];

    // Setup physics world
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,-900);
    //_physicsWorld.debugDraw = YES;
    [self addChild:_physicsWorld];
    
    // Add ground sprite and drop a banana
    [self spawnSprite:@"ground" atPos:ccp(0,0)];
    [self spawnSprite:@"banana" atPos:ccp(self.contentSize.width/2,self.contentSize.height/2)];

    // done
	return self;
}

// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    
    static int i = 0;
    NSArray *sprites = @[ @"banana", @"cherries", @"crate", @"orange" ];
    
    [self spawnSprite:[sprites objectAtIndex:(i++ % [sprites count])] atPos:touchLoc];
}

// -----------------------------------------------------------------------
@end
