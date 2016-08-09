//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  WT_UIBoard.m
//  WTFramework
//

#import "WT_UIBoard.h"

#import "NSObject+WT_UIPropertyMapping.h"
#import "NSObject+WT_Http.h"

#import "_pragma_push.h"

@implementation WTUIBoard
{
    id _navigationBarLeft;
    id _navigationBarRight;
    
    BOOL _viewCreated;
    BOOL _viewLayouted;
}

@def_signal(Load)
@def_signal(Unload)
@def_signal(CreateViews)
@def_signal(DeleteViews)
@def_signal(WillAppear)
@def_signal(DidAppear)
@def_signal(WillDisappear)
@def_signal(DidDisappear)
@def_signal(MemoryWarning)

- (void)dealloc
{
    [self cancelAllRequests];
    [self sendSignal:WTUIBoard.Unload withObject:nil];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self sendSignal:WTUIBoard.Load withObject:nil];
}

- (void)loadView
{
    [super loadView];
    
    if(!_viewCreated)
    {
        [self initialize];
        [self mapPropertiesFromView:self.view];
        
        [self sendSignal:WTUIBoard.CreateViews withObject:nil];
        _viewCreated = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(!_viewCreated)
    {
        [self initialize];
        [self mapPropertiesFromView:self.view];
        
        [self sendSignal:WTUIBoard.CreateViews withObject:nil];
        _viewCreated = YES;
    }
    [self sendSignal:WTUIBoard.WillAppear withObject:nil];
    
    [self refreshLayout];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self sendSignal:WTUIBoard.DidAppear withObject:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self sendSignal:WTUIBoard.WillDisappear withObject:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self sendSignal:WTUIBoard.DidDisappear withObject:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self sendSignal:WTUIBoard.MemoryWarning withObject:nil];
}

- (void)initialize {}
- (void)performLayout:(BOOL)refresh {}
- (void)refreshLayout
{
    [self performLayout:_viewLayouted];
    if(!_viewLayouted)
    {
        _viewLayouted = YES;
    }
    else
    {
        [self.view layoutIfNeeded];
    }
}

@end

#import "_pragma_pop.h"
