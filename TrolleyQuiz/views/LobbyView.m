//
//  LobbyView.m
//  TrolleyQuiz
//
//  Created by 研修用 on 2014/04/07.
//  Copyright (c) 2014年 Kohei Iwasaki. All rights reserved.
//

#import "LobbyView.h"

const float BOX_SIZE = 100;

const float BIG_TAB_WIDTH = 64.0f;
const float BIG_TAB_HEIGHT = 64.0f;
const float SMALL_TAB_WIDTH = 64.0f;
const float SMALL_TAB_HEIGHT = BIG_TAB_HEIGHT/2;

const float BOX_MARGIN = 5.0f;

@implementation LobbyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *tabView = [self createTabView];
        [self addSubview:tabView];
        
        _scroller = [MGScrollView scroller];
        _scroller.frame = CGRectMake(0, tabView.frame.size.height, frame.size.width, frame.size.height - tabView.frame.size.height);
        _scroller.backgroundColor = [UIColor redColor];
        _grid = [self createGridWithSize:_scroller.frame.size];
        [_scroller.boxes addObject:_grid];
        [self addSubview:_scroller];
        
    }
    return self;
}

- (UIView *)createTabView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, BIG_TAB_HEIGHT)];
    
    UIButton *totalButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, BIG_TAB_WIDTH, BIG_TAB_HEIGHT)];
    [totalButton setTitle:@"総合" forState:UIControlStateNormal];
    [totalButton setBackgroundColor:[UIColor blueColor]];
    [view addSubview:totalButton];
    
    UIButton *newButton = [[UIButton alloc] initWithFrame:CGRectMake(BIG_TAB_WIDTH+SMALL_TAB_WIDTH*3, 0, BIG_TAB_WIDTH, BIG_TAB_HEIGHT)];
    [newButton setTitle:@"新規" forState:UIControlStateNormal];
    [newButton addTarget:self action:@selector(createNewTrolley:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:newButton];
    
    NSArray *categories = @[@"スポーツ",@"数学理科",@"文学歴史",@"雑学",@"芸能",@"アニゲー"];
    for(int i=0; i<categories.count; i++){
        NSString *category = categories[i];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(BIG_TAB_WIDTH+(i%3)*SMALL_TAB_WIDTH, (int)(i/3)*SMALL_TAB_HEIGHT, SMALL_TAB_WIDTH, SMALL_TAB_HEIGHT)];
        [button setTitle:category forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [view addSubview:button];
    }
    
    return view;
}

- (void)createNewTrolley:(UIButton *)button
{
    [self updateGridWithTrolleys:[self createNewTrolleys]];
}

- (MGBox *)createGridWithSize:(CGSize)size
{
    MGBox *grid = [MGBox boxWithSize:size];
    grid.backgroundColor = [UIColor yellowColor];
    grid.contentLayoutMode = MGLayoutGridStyle;
    return grid;
}

- (void)updateGridWithTrolleys:(NSArray *)trolleys
{
    [_grid.boxes removeAllObjects];
    for(NSDictionary *trolley in trolleys){
        [_grid.boxes addObject:[self createBox:trolley]];
    }
    [_grid layout];
    [_scroller layout];
}

- (MGBox *)createBox:(NSDictionary *)trolley
{
    MGBox *box = [MGBox boxWithSize:CGSizeMake(BOX_SIZE, BOX_SIZE)];
    box.backgroundColor = [UIColor purpleColor];
    box.leftMargin = BOX_MARGIN;
    box.topMargin = BOX_MARGIN;
    
    UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, BOX_SIZE, BOX_SIZE/2)];
    categoryLabel.text = trolley[@"category"];
    [box addSubview:categoryLabel];
    
    box.onTap = ^{
        NSLog(@"tapped!");
        [self.delegate rideTrolley:trolley];
    };
    
    return box;
    
}

- (NSArray *)createNewTrolleys
{
    NSMutableArray *trolleys = NSMutableArray.new;
    
    NSArray *categories = @[@"スポーツ",@"数学理科",@"文学歴史",@"雑学",@"芸能",@"アニゲー"];
    for(int i=0; i<categories.count; i++){
        NSString *category = categories[i];
        [trolleys addObject:@{@"category": category, @"current_num": @0, @"sec":@5, @"corrects":@0, @"users":@[]}];
    }
    
    return trolleys;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
