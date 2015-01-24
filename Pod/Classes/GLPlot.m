//
//  GLChartView.m
//  Pods
//
//  Created by LuHuiguo on 15/1/22.
//
//

#import "GLPlot.h"

#import "NSDate+MTDates.h"
#import "GLPoint.h"
#import "GLEntry.h"
#import "GLFormatter.h"

#define DATA_PLOT_IDENTIFIER @"DataPlot"
#define TOUCH_PLOT_IDENTIFIER @"TouchPlot"

#define DEFAULT_X_LENGTH 100

@interface GLPlot ()
{
    
    double _maxY;
}
@end;

@implementation GLPlot

- (id)initWithPlotData:(NSMutableArray *)plotData
{
    self = [super init];
    if (self){
        self.plotData = plotData;
        self.xRangeLength = DEFAULT_X_LENGTH;
    }
    return self;
}


- (void)renderInHostingView:(CPTGraphHostingView *)hostingView withTheme:(CPTTheme *)theme
{

    
    _graph = [[CPTXYGraph alloc] initWithFrame:hostingView.bounds];
    
    [_graph applyTheme:theme];
    hostingView.hostedGraph = _graph;
    
    hostingView.allowPinchScaling = YES;
    _graph.paddingLeft = 0;
    _graph.paddingTop = 0;
    _graph.paddingRight = 0;
    _graph.paddingBottom = 0;
    
    
    CPTXYPlotSpace *plotSpace       = (CPTXYPlotSpace *) _graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.delegate = self;
    
    NSUInteger count = [_plotData count];
    _maxY = 0.0;
    
    
    NSMutableArray* dates = [NSMutableArray arrayWithCapacity:[_plotData count]];
    
    for(GLPoint *point in _plotData)
    {
        _maxY = MAX(_maxY,point.price);
        [dates addObject:[point.date mt_stringFromDateWithFormat:@"yyyy-MM-dd" localized:NO]];
    }
    
    NSUInteger len = MIN(count, _xRangeLength);
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(count-len-1) length:CPTDecimalFromUnsignedInteger(len)];
    plotSpace.globalXRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(0) length:CPTDecimalFromUnsignedInteger(count-1)];
    plotSpace.globalYRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(_maxY)];
    plotSpace.yRange = plotSpace.globalYRange;
    
    
    
    _dataPlot = [[CPTScatterPlot alloc] init];
    _dataPlot.dataSource      = self;
    _dataPlot.delegate        = self;
    _dataPlot.identifier      = DATA_PLOT_IDENTIFIER;
    [_graph addPlot:_dataPlot toPlotSpace:plotSpace];
    if (self.dataLineStyle == nil){
        CPTMutableLineStyle *lineStyle = [_dataPlot.dataLineStyle mutableCopy];
        lineStyle.lineWidth = 0.5f;
        lineStyle.lineColor = [CPTColor darkGrayColor];
        self.dataLineStyle = lineStyle;
    }
    _dataPlot.dataLineStyle = self.dataLineStyle;
    
    
    _touchPlot = [[CPTScatterPlot alloc] init];
    _touchPlot.identifier = TOUCH_PLOT_IDENTIFIER;
    _touchPlot.dataSource = self;
    _touchPlot.delegate = self;
    [_graph addPlot:_touchPlot toPlotSpace:plotSpace];
    
    if (self.touchLineStyle == nil){
        CPTMutableLineStyle *touchLineStyle = [_touchPlot.dataLineStyle mutableCopy];
        touchLineStyle.lineWidth = 0.5f;
        touchLineStyle.lineColor = [CPTColor lightGrayColor];
        self.touchLineStyle = touchLineStyle;
    }
    _touchPlot.dataLineStyle = self.touchLineStyle;
    
    if (self.plotSymbol == nil){
        _plotSymbol = [CPTPlotSymbol diamondPlotSymbol];
        _plotSymbol.lineStyle = self.dataLineStyle;
        _plotSymbol.fill = [CPTFill fillWithColor:[[CPTColor blueColor] colorWithAlphaComponent:0.5]];
        _plotSymbol.size = CGSizeMake(8.0, 8.0);
    }
    
    if (self.touchSymbol == nil){
        _touchSymbol = [CPTPlotSymbol ellipsePlotSymbol];
        _touchSymbol.lineStyle = self.touchLineStyle;
        _touchSymbol.fill = [CPTFill fillWithColor:[[CPTColor redColor] colorWithAlphaComponent:0.5]];
        _touchSymbol.size = CGSizeMake(5.0, 5.0);
    }
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) _graph.axisSet;
    CPTXYAxis *x         = axisSet.xAxis;
    x.labelFormatter = [[GLFormatter alloc] initWithArray:dates];
    
    [self selectAtIndex:count - 1];

    
}

- (void)reloadDataPlot{
    [self.dataPlot reloadData];
}

- (void)selectAtIndex:(NSUInteger)index
{
    self.selectedCoordination = index;
    if ([self.delegate respondsToSelector:@selector(plot:selectedAtIndex:)]){
        [self.delegate plot:self selectedAtIndex:index];
    }

}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    if ([(NSString *)plot.identifier isEqualToString:DATA_PLOT_IDENTIFIER]) {
        return [_plotData count];
    }else if ([(NSString *)plot.identifier isEqualToString:TOUCH_PLOT_IDENTIFIER]) {
        return 3;
    }
    return 0;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    
    NSNumber *num = [NSDecimalNumber zero];
    GLPoint* point = [_plotData objectAtIndex:index];
    
    
    if ([(NSString *)plot.identifier isEqualToString:DATA_PLOT_IDENTIFIER]) {
        if (fieldEnum == CPTScatterPlotFieldX)
            return [NSDecimalNumber numberWithUnsignedInteger:index];
        else
            return [NSDecimalNumber numberWithDouble:point.price];
        
    } else if ([(NSString *)plot.identifier isEqualToString:TOUCH_PLOT_IDENTIFIER]) {
        
        
        GLPoint* p = [_plotData objectAtIndex:self.selectedCoordination];
        
        if ( fieldEnum == CPTScatterPlotFieldY ){
            switch (index) {
                case 0:
                    num = [NSDecimalNumber zero];
                    break;
                case 2:
                    num = [NSNumber numberWithInt:_maxY];
                    break;
                default:
                    num = [NSNumber numberWithDouble:p.price];
                    break;
            }
        }
        else if (fieldEnum == CPTScatterPlotFieldX){
            num = [NSNumber numberWithUnsignedInteger: self.selectedCoordination];
        }
    }
    
    return num;
}

#pragma mark
#pragma mark ScatterPlot Data Source Methods
- (CPTPlotSymbol *)symbolForScatterPlot:(CPTScatterPlot *)plot recordIndex:(NSUInteger)idx
{
    GLPoint* point = [_plotData objectAtIndex:idx];
    
    if ([(NSString *)plot.identifier isEqualToString:DATA_PLOT_IDENTIFIER]) {
        if (point.hasSymbol){
            return _plotSymbol;
        }
        return nil;
    } else if ([(NSString *)plot.identifier isEqualToString:TOUCH_PLOT_IDENTIFIER]) {
        if (idx == 1) {
            return _touchSymbol;
        }
        
        
    }
    
    return nil;
}

#pragma mark -
#pragma mark PlotSpace Delegate Methods
- (CPTPlotRange *)plotSpace:(CPTPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate;
{
    if (coordinate == CPTCoordinateY) {
        newRange = ((CPTXYPlotSpace*)space).globalYRange;
    }
    return newRange;
}

- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDownEvent:(CPTNativeEvent *)event atPoint:(CGPoint)point
{
    CGPoint pointInPlotArea = [_graph convertPoint:point toLayer:_graph.plotAreaFrame.plotArea];
    
    NSDecimal newPoint[2];
    [_graph.defaultPlotSpace plotPoint:newPoint numberOfCoordinates:_graph.defaultPlotSpace.numberOfCoordinates forPlotAreaViewPoint:pointInPlotArea];
    NSDecimalRound(&newPoint[0], &newPoint[0], 0, NSRoundPlain);
    NSInteger x = [[NSDecimalNumber decimalNumberWithDecimal:newPoint[0]] integerValue];
    
    if (x < 0)
    {
        x = 0;
    }
    else if (x > [_plotData count])
    {
        x = [_plotData count];
    }
    [self selectAtIndex:x];

    [_touchPlot reloadData];

    return YES;
}

- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceUpEvent:(CPTNativeEvent *)event atPoint:(CGPoint)point
{
    return YES;
}



@end
