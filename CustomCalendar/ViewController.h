//
//  ViewController.h
//  CustomCalendar
//
//  Created by Anindya Das on 6/21/16.
//  Copyright © 2016 XOR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *calendarScroll;
@property (strong, nonatomic) IBOutlet UILabel *yearLabel;
- (IBAction)PreviousButton:(id)sender;
- (IBAction)ForwordButton:(id)sender;

@end

