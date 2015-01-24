//
//  GLViewController.m
//  GLChart
//
//  Created by Lu Huiguo on 01/20/2015.
//  Copyright (c) 2014 Lu Huiguo. All rights reserved.
//

#import "GLViewController.h"

#import "AFNetworking.h"

#import "NSDate+MTDates.h"
#import "GLPoint.h"
#import "GLEntry.h"
#import "GLFormatter.h"


#define THEME @"Gildata"

@interface GLViewController ()
{
    
    NSMutableArray * _tableData;
    NSMutableArray * _filteredTableData;
    
}


- (void)filterPlotSymbolWithTag:(NSString*) tag;

@end

@implementation GLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://localhost:8080/rest/candlestick/600570.SH" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray* data = [NSMutableArray array];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            
            NSArray* responseArray = (NSArray*)responseObject;
            
            
            
            for (NSDictionary* dict in responseArray){
                GLPoint* point = [[GLPoint alloc] init];
                point.date = [NSDate mt_dateFromISOString:[dict objectForKey:@"date"]];
                point.price = [[dict objectForKey:@"close"] doubleValue];
                point.hasSymbol = NO;
                
                [data addObject:point];
                
            }
        }
        

        self.plot = [[GLPlot alloc]initWithPlotData:data];
        
        self.plot.delegate = self;
        
        [self generateData];
        [self.plot renderInHostingView:self.hostingView withTheme:[CPTTheme themeNamed:THEME]];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)generateData
{
    if ( _tableData == nil ) {
        NSMutableArray *contentArray = [NSMutableArray array];
        for ( NSUInteger i = 0; i < [self.plot.plotData count]; i++ ) {
            GLPoint* point = [self.plot.plotData objectAtIndex:i];
            double x = (double)rand() / (double)RAND_MAX;
            if (  x> 0.5){
                point.hasSymbol = YES;
                
                GLEntry* entry = [[GLEntry alloc] init];
                entry.date = point.date;
                entry.title = [NSString stringWithFormat:@"测试研报测试研报测试研报 %lu", i];
                if (x >0.7){
                   entry.tag = @"作者A";
                }else{
                   entry.tag = @"作者B";
                }
                [contentArray addObject:entry];
//
                
            }
        }
        _tableData = contentArray;
    }
}


- (void)plot:(GLPlot *)plot selectedAtIndex:(NSUInteger)index
{
    NSLog(@"=========");
    
    GLPoint* p = [plot.plotData objectAtIndex:index];
    NSDate* d = p.date;
    
    _filteredTableData = [NSMutableArray array];
    
    for (GLEntry* entry in _tableData){
        
        if ([entry.date mt_isWithinSameWeek:d]) {
            [_filteredTableData addObject:entry];

        }
    }
    [self.tableView reloadData];
    
}

- (void)filterPlotSymbolWithTag:(NSString*) tag
{
    
    NSMutableArray*  filtered = [NSMutableArray array];
    
    for (GLEntry* entry in _tableData){
        if ([entry.tag isEqualToString:tag]) {
            [filtered addObject:entry];
        }
    }
    
    for (GLPoint* p in self.plot.plotData){
        p.hasSymbol = NO;
        for (GLEntry* e in filtered){
            if ([p.date isEqualToDate:e.date]) {
                p.hasSymbol = YES;
                break;
            }
        }
        
    }
    
    [self.plot reloadDataPlot];
 
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _filteredTableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tableCell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    GLEntry *entry = [_filteredTableData objectAtIndex:indexPath.row];

    cell.textLabel.text = entry.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", [entry.date mt_stringFromDateWithFormat:@"yyyy-MM-dd" localized:NO], entry.tag];
    
    return cell;
}




#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    GLEntry *entry = [_filteredTableData objectAtIndex:indexPath.row];
    
    
    
    [self filterPlotSymbolWithTag:entry.tag];

}




@end
