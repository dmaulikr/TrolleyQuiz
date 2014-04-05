//
//  ViewController.m
//  TrolleyQuiz
//
//  Created by Kohei Iwasaki on 2014/04/05.
//  Copyright (c) 2014年 Kohei Iwasaki. All rights reserved.
//

#import "ViewController.h"
#import "MainScene.h"
#import "SocketIOPacket.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [MainScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
    
    SocketIO *sock = [[SocketIO alloc] initWithDelegate:self];
    [sock connectToHost:@"localhost"
                     onPort:3000
                 withParams:[NSDictionary dictionaryWithObjectsAndKeys:@"1234", @"auth_token", nil]
     ];
    
}

- (void)socketIODidConnect:(SocketIO *)socket
{
    [socket sendMessage:@"connected!"];
}

- (void)socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet
{
    NSLog(@"didReceiveMessage >>> data: %@", packet.data);
}

- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    NSLog(@"didReceiveEvent >>> data: %@", packet.data);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
