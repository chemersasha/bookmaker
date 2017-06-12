//
//  BKMKRTotalDetailViewController.m
//  BKMKRManager
//
//  Created by Chemersky on 5/27/17.
//  Copyright © 2017 Chemer. All rights reserved.
//

#import "BKMKRTotalDetailViewController.h"
#import "Total+CoreDataClass.h"
#import "Event+CoreDataClass.h"

@interface BKMKRTotalDetailViewController () <NSComboBoxDelegate>
@property (nonatomic, strong) Total *total;
@property (weak) IBOutlet NSComboBox *totalComboBox;
@property (weak) IBOutlet NSTextField *eventIdLabel;
@property (weak) IBOutlet NSTextField *betLTextField;
@property (weak) IBOutlet NSTextField *profitLTextField;
@property (weak) IBOutlet NSTextField *betMTextField;
@property (weak) IBOutlet NSTextField *profitMTextField;
@property (weak) IBOutlet NSTextField *profitTextField;
@end


@implementation BKMKRTotalDetailViewController

- (instancetype)initWithTotal:(Total *)total
{
    self = [super init];
    if (self) {
        self.total = total;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self update];
}

- (void)update {
    self.eventIdLabel.stringValue = self.total.event.eventId;
    self.totalComboBox.stringValue = [[NSNumber numberWithFloat:self.total.total] stringValue];
    self.betLTextField.stringValue = [[NSNumber numberWithFloat:self.total.betL] stringValue];
    self.profitLTextField.stringValue = [[NSNumber numberWithFloat:self.total.profitL] stringValue];
    self.betMTextField.stringValue = [[NSNumber numberWithFloat:self.total.betM] stringValue];
    self.profitMTextField.stringValue = [[NSNumber numberWithFloat:self.total.profitM] stringValue];
    self.profitTextField.stringValue = [[NSNumber numberWithFloat:self.total.profit] stringValue];
}

#pragma mark - NSComboBoxDelegate

- (void)comboBoxSelectionDidChange:(NSNotification *)notification {
    NSComboBox *combobox = notification.object;
    NSString *newValue = [combobox itemObjectValueAtIndex:[combobox indexOfSelectedItem]];
    
    self.total.total = [newValue floatValue];
}

#pragma mark - Actions

- (IBAction)close:(id)sender {
    [self.presentingViewController dismissViewController:self];
}

- (IBAction)updateProfit:(NSTextField *)sender {
    self.total.profit = sender.floatValue;
}

- (IBAction)updateBetL:(NSTextField *)sender {
    self.total.betL = sender.floatValue;
}

- (IBAction)updateProfitL:(NSTextField *)sender {
    self.total.profitL = sender.floatValue;
}

- (IBAction)updateBetM:(NSTextField *)sender {
    self.total.betM = sender.floatValue;
}

- (IBAction)updateProfitM:(NSTextField *)sender {
    self.total.profitM = sender.floatValue;
}

@end
