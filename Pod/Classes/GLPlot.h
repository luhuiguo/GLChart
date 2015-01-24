//
//  GLChartView.h
//  Pods
//
//  Created by LuHuiguo on 15/1/22.
//
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"


@protocol GLPlotDelegate;


@interface GLPlot : NSObject <CPTScatterPlotDataSource,CPTScatterPlotDelegate, CPTPlotSpaceDelegate>

@property (nonatomic, weak) id<GLPlotDelegate> delegate;

@property (nonatomic, strong) CPTGraph *graph;
@property (nonatomic, strong) CPTScatterPlot *dataPlot;
@property (nonatomic, strong) CPTScatterPlot *touchPlot;

@property (nonatomic, strong) CPTPlotSymbol * plotSymbol;
@property (nonatomic, strong) CPTPlotSymbol * touchSymbol;

@property (nonatomic, strong) CPTLineStyle * dataLineStyle;
@property (nonatomic, strong) CPTLineStyle * touchLineStyle;

@property (nonatomic, copy) NSMutableArray * plotData;
@property (nonatomic) NSUInteger selectedCoordination;

@property (nonatomic) NSUInteger xRangeLength;

- (id)initWithPlotData:(NSMutableArray *)plotData;

- (void)renderInHostingView:(CPTGraphHostingView *)hostingView withTheme:(CPTTheme *)theme;

- (void)reloadDataPlot;

- (void)selectAtIndex:(NSUInteger)index;

@end

@protocol GLPlotDelegate <NSObject>

- (void)plot:(GLPlot *)plot selectedAtIndex:(NSUInteger)index;


@end