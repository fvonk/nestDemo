//
//  ThermostatViewController.m
//  NestDemo
//
//  Created by Pavel Kozlov on 10/19/17.
//  Copyright © 2017 Pavel Kozlov. All rights reserved.
//

#import "ThermostatViewController.h"
#import "ThermostatManager.h"
#import "Thermostat.h"
#import "Configs.h"
#import "UIViewController+Spinner.h"

@interface ThermostatViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentTemp;
@property (weak, nonatomic) IBOutlet UILabel *targetTemp;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) ThermostatManager *thermostatManager;
@property (strong, nonatomic) NSTimer *updateTimer;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end

@implementation ThermostatViewController

@synthesize currentTemp, targetTemp, slider, thermostatManager, indicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    thermostatManager = [[ThermostatManager alloc] initWithThermostatId: self.thermostat.ID];
    indicator = [self setupIndicator];
    
    __weak __typeof(self)weakSelf = self;
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_TIME_INTERVAL repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf requestNewData];
    }];
    
    [self updateData];
    [self requestNewData];
}

-(void)requestNewData
{
    [self.indicator startAnimating];
    __weak __typeof(self)weakSelf = self;
    [thermostatManager getDataWithCompletion:^(Thermostat * _Nullable newThermostat) {
        weakSelf.thermostat = newThermostat;
        [weakSelf updateData];
        [weakSelf.indicator stopAnimating];
    } withFailure:^(NSError * _Nullable error) {
        [weakSelf showErrorAlert:error.description];
    }];
}

-(void)updateData
{
    [currentTemp setText:[NSString stringWithFormat:@"%ld°", self.thermostat.ambientTemperatureF]];
    [targetTemp setText:[NSString stringWithFormat:@"%ld°", self.thermostat.targetTemperatureF]];
    [slider setValue:(float)self.thermostat.targetTemperatureF animated:YES];
}

- (IBAction)changeValue:(UISlider *)sender
{
    [targetTemp setText:[NSString stringWithFormat:@"%ld°", (long)slider.value]];
}

- (IBAction)sliderUp:(UISlider *)sender
{
    [targetTemp setText:[NSString stringWithFormat:@"%ld°", (long)slider.value]];
    [self setupNewTemperature:(NSInteger)slider.value];
}

-(void)setupNewTemperature:(NSInteger)temperature
{
    [self.indicator startAnimating];
    __weak __typeof(self)weakSelf = self;
    [thermostatManager setData:temperature withCompletion:^(NSDictionary * _Nullable json) {
        NSString *errorString = [json objectForKey:@"error"];
        if (errorString) {
            [weakSelf showErrorAlert:errorString];
        }
        [weakSelf requestNewData];
        
    } withFailure:^(NSError * _Nullable error) {
        [weakSelf showErrorAlert:error.description];
    }];

}

-(void)showErrorAlert:(NSString *)errorString
{
    [self.indicator stopAnimating];
    [self.updateTimer invalidate];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warning!" message:errorString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)dealloc
{
    [self.updateTimer invalidate];
    self.updateTimer = nil;
}

@end
