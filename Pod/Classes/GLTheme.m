//
//  GLTheme.m
//  Pods
//
//  Created by LuHuiguo on 15/1/23.
//
//

#import "GLTheme.h"

NSString *const kGildataTheme = @"Gildata";

@implementation GLTheme

+(void)load
{
    [self registerTheme:self];
}

+(NSString *)name
{
    return kGildataTheme;
}

-(id)init
{
    if ( (self = [super init]) ) {
        self.graphClass = [CPTXYGraph class];
    }
    return self;
}



-(id)newGraph
{
    CPTXYGraph *graph;
    
    if ( self.graphClass ) {
        graph = [(CPTXYGraph *)[self.graphClass alloc] initWithFrame : CPTRectMake(0.0, 0.0, 200.0, 200.0)];
    }
    else {
        graph = [(CPTXYGraph *)[CPTXYGraph alloc] initWithFrame : CPTRectMake(0.0, 0.0, 200.0, 200.0)];
    }
    graph.paddingLeft   = CPTFloat(60.0);
    graph.paddingTop    = CPTFloat(60.0);
    graph.paddingRight  = CPTFloat(60.0);
    graph.paddingBottom = CPTFloat(60.0);
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(-1.0) length:CPTDecimalFromDouble(1.0)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(-1.0) length:CPTDecimalFromDouble(1.0)];
    
    [self applyThemeToGraph:graph];
    
    return graph;
}


-(void)applyThemeToBackground:(CPTGraph *)graph
{
    graph.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
}

-(void)applyThemeToPlotArea:(CPTPlotAreaFrame *)plotAreaFrame
{
    plotAreaFrame.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    
    plotAreaFrame.paddingTop =30.0;
    plotAreaFrame.paddingBottom = 20;
    plotAreaFrame.paddingLeft = 30.0;
    plotAreaFrame.paddingRight = 10.0;

    
//    CPTMutableLineStyle *borderLineStyle = [CPTMutableLineStyle lineStyle];
//    borderLineStyle.lineColor = [CPTColor blackColor];
//    borderLineStyle.lineWidth = CPTFloat(1.0);
//    
//    plotAreaFrame.borderLineStyle = borderLineStyle;
//    plotAreaFrame.cornerRadius    = CPTFloat(0.0);
}

-(void)applyThemeToAxisSet:(CPTAxisSet *)axisSet
{
    CPTXYAxisSet *xyAxisSet             = (CPTXYAxisSet *)axisSet;
    CPTMutableLineStyle *majorLineStyle = [CPTMutableLineStyle lineStyle];
    
    majorLineStyle.lineCap   = kCGLineCapButt;
    majorLineStyle.lineColor = [CPTColor blackColor];
    majorLineStyle.lineWidth = CPTFloat(1);
    
    CPTMutableLineStyle *minorLineStyle = [CPTMutableLineStyle lineStyle];
    minorLineStyle.lineCap   = kCGLineCapButt;
    minorLineStyle.lineColor = [CPTColor darkGrayColor];
    minorLineStyle.lineWidth = CPTFloat(0.25);
    
    CPTMutableLineStyle * majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = CPTFloat(0.5);
    majorGridLineStyle.lineColor = [CPTColor lightGrayColor];
    majorGridLineStyle.dashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInteger:5], [NSNumber numberWithInteger:5], nil];
    
    CPTMutableLineStyle * minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth = CPTFloat(0.25);
    minorGridLineStyle.lineColor = [CPTColor lightGrayColor];
    
    CPTXYAxis *x                        = xyAxisSet.xAxis;
    CPTMutableTextStyle *blackTextStyle = [[CPTMutableTextStyle alloc] init];
    blackTextStyle.color    = [CPTColor darkGrayColor];
    blackTextStyle.fontSize = CPTFloat(9.0);
    CPTMutableTextStyle *minorTickBlackTextStyle = [[CPTMutableTextStyle alloc] init];
    minorTickBlackTextStyle.color    = [CPTColor lightGrayColor];
    minorTickBlackTextStyle.fontSize = CPTFloat(7.0);
    x.labelingPolicy                 = CPTAxisLabelingPolicyAutomatic;
    x.majorIntervalLength            = CPTDecimalFromDouble(0.5);
    x.orthogonalCoordinateDecimal    = CPTDecimalFromDouble(0.0);
    x.tickDirection                  = CPTSignNone;
    x.minorTicksPerInterval          = 4;
    x.majorGridLineStyle             = majorGridLineStyle;
    x.majorTickLineStyle             = majorLineStyle;
    x.minorTickLineStyle             = minorLineStyle;
    x.axisLineStyle                  = majorLineStyle;
    x.majorTickLength                = CPTFloat(7.0);
    x.minorTickLength                = CPTFloat(5.0);
    x.labelTextStyle                 = blackTextStyle;
    x.minorTickLabelTextStyle        = blackTextStyle;
    x.titleTextStyle                 = blackTextStyle;
    
    CPTXYAxis *y = xyAxisSet.yAxis;
    y.axisConstraints    = [CPTConstraints constraintWithLowerOffset:0];
    y.labelingPolicy              = CPTAxisLabelingPolicyAutomatic;
    y.majorIntervalLength         = CPTDecimalFromDouble(0.5);
    y.minorTicksPerInterval       = 4;
    y.orthogonalCoordinateDecimal = CPTDecimalFromDouble(0.0);
    y.tickDirection               = CPTSignNone;
    y.majorGridLineStyle          = majorGridLineStyle;
    y.majorTickLineStyle          = majorLineStyle;
    y.minorTickLineStyle          = minorLineStyle;
    y.axisLineStyle               = majorLineStyle;
    y.majorTickLength             = CPTFloat(7.0);
    y.minorTickLength             = CPTFloat(5.0);
    y.labelTextStyle              = blackTextStyle;
    y.minorTickLabelTextStyle     = minorTickBlackTextStyle;
    y.titleTextStyle              = blackTextStyle;
}

#pragma mark -
#pragma mark NSCoding Methods

-(Class)classForCoder
{
    return [CPTTheme class];
}


@end
