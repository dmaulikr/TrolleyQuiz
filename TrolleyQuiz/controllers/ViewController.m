//
//  ViewController.m
//  TrolleyQuiz
//
//  Created by Kohei Iwasaki on 2014/04/05.
//  Copyright (c) 2014年 Kohei Iwasaki. All rights reserved.
//

#import "ViewController.h"
#import "MainScene.h"

#define DEVELOPMENT @"ws://localhost:3000/"
#define STAGING @"ws://hacker-meetings.com/"
#define PRODUCTION @"ws://172.16.201.22:3000/"

#define WS_URL STAGING

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
    
    SRWebSocket *ws = [[SRWebSocket alloc] initWithURLRequest:
                       [NSURLRequest requestWithURL:[NSURL URLWithString:WS_URL]]];
    ws.delegate = self;
    [ws open];
    
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"message recieved:%@",message);
}
- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"aa");
    [webSocket send:@"ハットリのバーか"];
}
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"close:%d reason:%@ wasClean:%d",code,reason,wasClean);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
