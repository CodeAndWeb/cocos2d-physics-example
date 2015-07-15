#import "MainScene.h"
#import "PhysicsShapeCache.h"

@implementation MainScene

CCPhysicsNode *_physicsWorld;

-(instancetype)init
{
    if((self = [super init]))
    {
        // Enable touch handling on scene node
        self.userInteractionEnabled = YES;
        
        // Load the generated physics shapes into the PhysicsShapeCache
        [[PhysicsShapeCache sharedShapeCache] addShapesWithFile:@"Shapes.plist"];
        
        // Load background image
        CCSprite *background = [CCSprite spriteWithImageNamed:@"background.png"];
        background.anchorPoint = ccp(0,0);
        [self addChild:background];
        
        // Setup physics world
        _physicsWorld = [CCPhysicsNode node];
        _physicsWorld.gravity = ccp(0,-900);
        //_physicsWorld.debugDraw = YES;
        [self addChild:_physicsWorld];
        
        // Add ground sprite (set as static in PhysicsEditor)
        [self spawnSprite:@"ground" atPos:ccp(0,0)];
        
        // Add a banana
        [self spawnSprite:@"banana" atPos:ccp(self.contentSize.width/2,self.contentSize.height/2)];
    }
    
    return self;
}

- (void)spawnSprite:(NSString *)name atPos:(CGPoint)pos
{
    // create a CCSprite node and set it's position
    CCSprite *sprite = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"%@.png", name]];
    sprite.position = pos;
    
    // attach the physics body to the sprite
    [[PhysicsShapeCache sharedShapeCache] setBodyWithName:name onNode:sprite];
    
    // add the new physics object to our world
    [_physicsWorld addChild:sprite];
}

-(void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    CGPoint touchLoc = [touch locationInNode:self];
    static int i = 0;
    NSArray *sprites = @[ @"banana", @"cherries", @"crate", @"orange" ];
    
    [self spawnSprite:[sprites objectAtIndex:(i++ % [sprites count])] atPos:touchLoc];
}

@end
