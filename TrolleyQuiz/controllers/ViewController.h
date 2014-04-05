//
//  ViewController.h
//  TrolleyQuiz
//
//  Created by Kohei Iwasaki on 2014/04/05.
//  Copyright (c) 2014年 Kohei Iwasaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "SRWebSocket.h"

@interface ViewController : UIViewController
<SRWebSocketDelegate, FBLoginViewDelegate>

@end