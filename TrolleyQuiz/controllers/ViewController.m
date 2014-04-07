//
//  ViewController.m
//  TrolleyQuiz
//
//  Created by Kohei Iwasaki on 2014/04/05.
//  Copyright (c) 2014年 Kohei Iwasaki. All rights reserved.
//

#import "ViewController.h"
#import "MainScene.h"
#import "LobbyView.h"

//#define WS_URL @"ws://localhost:8081/"
#define WS_URL @"ws://donuts.hacker-meetings.com:8081/"
//#define WS_URL @"ws://172.16.201.22:8081/"

@interface ViewController ()
<LobbyViewDelegate>
{
    SRWebSocket *_socket;
    NSDictionary *_user;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    LobbyView *lobbyView = [[LobbyView alloc] initWithFrame:CGRectMake(0, 120, 320, [UIScreen mainScreen].bounds.size.height-120)];
    lobbyView.delegate = self;
    [self.view addSubview:lobbyView];
    
    _socket = [[SRWebSocket alloc] initWithURLRequest:
                       [NSURLRequest requestWithURL:[NSURL URLWithString:WS_URL]]];
    _socket.delegate = self;
    [_socket open];
    
}

- (void)rideTrolley:(NSDictionary *)trolley
{
    NSDictionary *sendData = @{@"ride_trolley": trolley, @"user_id": _user[@"_id"]};
    NSError *error = nil;
    NSData *data = nil;
    if([NSJSONSerialization isValidJSONObject:sendData]){
        data = [NSJSONSerialization dataWithJSONObject:sendData options:kNilOptions error:&error];
        if(!error){
            [_socket send:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
        }else{
            NSLog(@"error:%@",error);
        }
    }
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    _user = @{@"login": @{ @"facebook": user.id, @"name": user.name }};
    [self login:_socket withUser:_user];
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    NSLog(@"You are logged in ");
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void)login:(SRWebSocket *)socket withUser:(NSDictionary *)user
{
    NSError *error = nil;
    NSData *data = nil;
    if([NSJSONSerialization isValidJSONObject:user]){
        data = [NSJSONSerialization dataWithJSONObject:user options:kNilOptions error:&error];
        if(!error){
            [socket send:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
        }else{
            NSLog(@"error:%@",error);
        }
    }
}

- (void)get_trolleys:(SRWebSocket *)socket
{
    NSDictionary *message = @{@"get_trolleys": [NSNull null]};
    NSError *error = nil;
    NSData *data = nil;
    if([NSJSONSerialization isValidJSONObject:message]){
        data = [NSJSONSerialization dataWithJSONObject:message options:kNilOptions error:&error];
        if(!error){
            [socket send:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
        }else{
            NSLog(@"error:%@",error);
        }
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSData *jsonData = [message dataUsingEncoding:NSUnicodeStringEncoding];
    NSError *error;
    id json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                     options:NSJSONReadingAllowFragments
                                                       error:&error];
    
    if([json isKindOfClass:[NSArray class]]){
        NSLog(@"array recieved:%@",json);
        
    }else if([json isKindOfClass:[NSDictionary class]]){
        NSLog(@"json recieved:%@",json);
        if(json[@"user"]){
            NSDictionary *user = json[@"user"];
            _user = user;
            
            [self get_trolleys:webSocket];
            
        }else if(json[@"trolleys"]){
            
            NSArray *trolleys = json[@"trolleys"];
            NSLog(@"trolleys:%@",trolleys);
        }else if(json[@"trolley"]){
            for (UIView *view in self.view.subviews){
                [view removeFromSuperview];
            }
            
            // Configure the view.
            SKView * skView = (SKView *)self.view;
            skView.showsFPS = YES;
            skView.showsNodeCount = YES;
            
            // Create and configure the scene.
            SKScene *mainScene = [MainScene sceneWithSize:skView.bounds.size];
            mainScene.scaleMode = SKSceneScaleModeAspectFill;
            
            // Present the scene.
            [skView presentScene:mainScene];
        }
        
    }
}
- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.delegate = self;
    [self.view addSubview:loginView];
}
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"close:%ld reason:%@ wasClean:%d",(long)code,reason,wasClean);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
