//
//  DevicesTableViewController.m
//  NestDemo
//
//  Created by Pavel Kozlov on 10/18/17.
//  Copyright © 2017 Pavel Kozlov. All rights reserved.
//

#import "DevicesTableViewController.h"
#import "LoginViewController.h"
#import "SessionManager.h"
#import "Thermostat.h"
#import "Camera.h"
#import "UIViewController+Spinner.h"
#import "ThermostatViewController.h"

@interface DevicesTableViewController ()

@property (nonatomic, strong) NSMutableArray *devices;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end

@implementation DevicesTableViewController

@synthesize devices, indicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    indicator = [self setupIndicator];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestNewData];
}

-(void)requestNewData
{
    [self.indicator startAnimating];
    __weak __typeof(self)weakSelf = self;
    [[SessionManager shared] getDataWithMethod:@"devices" withCompletion:^(NSDictionary *json){
        NSMutableArray *newDevices = [[NSMutableArray alloc] init];
        
        NSArray *thermostats = [json objectForKey:@"thermostats"];
        for (NSString *key in thermostats) {
            Thermostat *thermostat = [[Thermostat alloc] initWithDictionary:[thermostats valueForKey:key]];
            [newDevices addObject: thermostat];
        }
        NSArray *cameras = [json objectForKey:@"cameras"];
        for (NSString *key in cameras) {
            Camera *camera = [[Camera alloc] initWithDictionary:[cameras valueForKey:key]];
            [newDevices addObject: camera];
        }
        weakSelf.devices = newDevices;
        [weakSelf.tableView reloadData];
        [weakSelf.indicator stopAnimating];
    } withFailure:^(NSError *error) {
        [[weakSelf devices] removeAllObjects];
        [weakSelf.tableView reloadData];
        NSLog(@"Error: %@", error);
        [weakSelf.indicator stopAnimating];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return devices.count;
        case 1:
            return 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceCell" forIndexPath:indexPath];
            Device *device = (Device *)[devices objectAtIndex:indexPath.row];
            cell.textLabel.text = device.name;
            cell.detailTextLabel.text = device.ID;
            return cell;
        }
        default:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogoutCell" forIndexPath:indexPath];
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 44;
        default:
            return 50;
    }
}

#pragma mark - Logout

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return;
        default:
            [self logout];
            break;
    }
}

-(void)logout
{
    if ([self.delegate conformsToProtocol:@protocol(LogoutFlowDelegate)]) {
        [self.delegate logoutUser];
    }
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath.row < devices.count) {
        if ([[devices objectAtIndex:indexPath.row] isKindOfClass:[Thermostat class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ThermostatViewController *thermostatViewController = (ThermostatViewController *)[segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath.row < devices.count) {
        Thermostat *thermostat = (Thermostat *)[devices objectAtIndex:indexPath.row];
        [thermostatViewController setThermostat:thermostat];
    }
}

@end
