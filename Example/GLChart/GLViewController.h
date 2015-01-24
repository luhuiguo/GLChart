//
//  GLViewController.h
//  GLChart
//
//  Created by Lu Huiguo on 01/20/2015.
//  Copyright (c) 2014 Lu Huiguo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "GLPlot.h"

@interface GLViewController : UIViewController <GLPlotDelegate, UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic, strong) CPTGraphHostingView *hostingView;
//@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic) NSUInteger selectedCoordination;


@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet CPTGraphHostingView *hostingView;

@property (nonatomic, strong) GLPlot *plot;

@end
