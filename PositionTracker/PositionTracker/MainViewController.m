//
//  ViewController.m
//  LiveTracker
//
//  Created by Thomas Cassany on 04/06/2015.
//  Copyright (c) 2015 Thomas Cassany. All rights reserved.
//

#import "MainViewController.h"
#import "ESTBeaconManager.h"

#import "TrackedBeacon.h"
#import "PositionTrackerContext.h"
#import "BeaconTrackerService.h"
#import "EventBus.h"
#import "BeaconRegionEventHandler.h"
#import "Beacon.h"
#import "BeaconIOService.h"

#import <MessageUI/MessageUI.h>


@interface MainViewController () <UITextViewDelegate, BeaconRegionEventHandler, MFMailComposeViewControllerDelegate>

@property(weak, nonatomic) IBOutlet UITextView *console;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[PositionTrackerContext instance].beaconTrackerService.beaconRegionBus addHandler:self];
}

- (void)addEntry:(NSString *)entry {
    NSString *text = self.console.text;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];

    text = [text stringByAppendingFormat:@"%@ : %@", [dateFormatter stringFromDate:[NSDate date]], entry];
    self.console.text = text;
    NSRange bottom = NSMakeRange(self.console.text.length - 1, 1);
    [self.console scrollRangeToVisible:bottom];

}

- (void)didTrackedBeaconStateChange:(TrackedBeacon *)trackedBeacon {
    if (trackedBeacon.isUserInRegion) {
        [self addEntry:[NSString stringWithFormat:@"Beacon %@ entered in region\n", trackedBeacon.beacon.name]];
    } else {
        [self addEntry:[NSString stringWithFormat:@"Beacon %@ exited in region\n", trackedBeacon.beacon.name]];
    }
}

- (IBAction)didEmailLogTouch:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        NSData *logData = [[PositionTrackerContext instance].beaconIOService csvData];
        [mailViewController addAttachmentData:logData mimeType:@"text/plain" fileName:@"Log.csv"];
        [mailViewController setSubject:@"Log position tracker"];
        [mailViewController setToRecipients:@[@"cassany.thomas@gmail.com"]];

        [self presentViewController:mailViewController animated:YES completion:nil];
    } else {
        NSString *message = @"Sorry, your issue can't be reported right now. This is most likely because no mail accounts are set up on your mobile device.";
        [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didClearLogTouch:(id)sender {
    [self.console scrollsToTop];
    self.console.text = @"";
}

- (IBAction)didLogDebugInfoTouch:(id)sender {
    __block NSString *debugInfo = @"--------------------------------------------------\n";
    NSSet *monitoredRegions = [PositionTrackerContext instance].beaconTrackerService.monitoredRegions;
    debugInfo = [debugInfo stringByAppendingFormat:@"Region monitored count : %d\n", monitoredRegions.count];
    [monitoredRegions enumerateObjectsUsingBlock:^(CLBeaconRegion *region, BOOL *stop) {
        debugInfo = [debugInfo stringByAppendingFormat:@"   Region  : %@\n", region.description];
    }];
    debugInfo = [debugInfo stringByAppendingString:@"--------------------------------------------------\n"];
    [self addEntry:debugInfo];
}

@end
