//
//  LobbyView.h
//  TrolleyQuiz
//
//  Created by 研修用 on 2014/04/07.
//  Copyright (c) 2014年 Kohei Iwasaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGScrollView.h"
#import "MGBox.h"

@protocol LobbyViewDelegate <NSObject>

- (void)rideTrolley:(NSDictionary *)trolley;

@end

@interface LobbyView : UIView

@property (nonatomic, strong) MGScrollView *scroller;
@property (nonatomic, strong) MGBox *grid;
@property (nonatomic, weak) id<LobbyViewDelegate> delegate;

@end
