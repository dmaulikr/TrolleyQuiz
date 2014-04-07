//
//  MainScene.m
//  TrolleyQuiz
//
//  Created by 研修用 on 2014/04/05.
//  Copyright (c) 2014年 Kohei Iwasaki. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene
{
    CMMotionManager *_motionManager;
}
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Hello, World!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
        
        _motionManager = [[CMMotionManager alloc] init];
        
        if(_motionManager.accelerometerAvailable){
            _motionManager.accelerometerUpdateInterval = 0.3;
            [_motionManager startAccelerometerUpdates];
        }
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        sprite.name = @"player";
        
        sprite.position = location;
        
        [self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    //NSLog(@"%f",currentTime);
    
    float x = _motionManager.accelerometerData.acceleration.x * 2;
    float y = _motionManager.accelerometerData.acceleration.y * 2 + 0.15;
    
    SKSpriteNode *player = (SKSpriteNode *)[self childNodeWithName:@"player"];
    if(player){
        player.position = CGPointMake(player.position.x + x, player.position.y + y);
        NSLog(@"%f %f",x,y);
    }
}

@end
