//
//  ViewController.m
//  CustomCalendar
//
//  Created by Anindya Das on 6/21/16.
//  Copyright © 2016 XOR. All rights reserved.
//

#import "ViewController.h"

NSString *selectedBtn;
NSString *selectedLbl;

@interface ViewController ()
{
    NSString* flag;
    int yValue;
    CGFloat height;
    NSMutableArray *monthDaysArray;
    
}
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _calendarScroll.backgroundColor=[UIColor darkGrayColor];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    _yearLabel.text=yearString;
    [self drawCalendar:[_yearLabel text]];
    
    
    
    
}

-(void)viewDidLayoutSubviews
{
    // The scrollview needs to know the content size for it to work correctly
    //    self.calendarScroll.contentSize = CGSizeMake(0, 2000);
    //    self.calendarScroll.contentSize = CGSizeMake(
    //                                             self.scrollContent.frame.size.width,
    //                                             self.scrollContent.frame.size.height + 300
    //                                             );
}

-(void)drawCalendar:(NSString*)year{
    for (UIView *v  in [_calendarScroll subviews])
    {
       [v removeFromSuperview];
    }
    monthDaysArray= [[NSMutableArray alloc]init];
    flag=@"";
    yValue=30;
    height = 0;
   
    for (int i=1; i<=12; i++) {
        NSDate *date = [[self returnDateFormatter] dateFromString:[NSString stringWithFormat:@"1/%d/%d",i,[year intValue]
                        ]];
        int numberOfDays = [self numberOfdaysinMonth:i WithDate:date];
        [monthDaysArray addObject:[[NSString alloc]initWithFormat:@"%d",numberOfDays]];
        int index =  [self weekDayForDate:date];
        if (index==0) {
            index=7;
        }
        [self createButtonsAndLablesForNumberOfDays:numberOfDays withStartingAtDay:index monthIndex:i];
    }
    height = yValue;
    _calendarScroll.contentSize = CGSizeMake(0, height);
}

-(NSDateFormatter *)returnDateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    return dateFormatter;
    
    
}
-(int)numberOfdaysinMonth:(int)selectedMonthNumber WithDate:(NSDate *)selectedDate
{
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comps = [[NSDateComponents alloc] init] ;
    // Set your month here
    [comps setMonth:selectedMonthNumber];
    
    NSRange range = [cal rangeOfUnit:NSCalendarUnitDay
                              inUnit:NSCalendarUnitMonth
                             forDate:selectedDate];
    NSLog(@"%lu", (unsigned long)range.length);
    return range.length;
}
-(long)weekDayForDate:(NSDate *)date
{
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:NSCalendarUnitWeekday fromDate:date];
    return [comp weekday]-1;
    
}
-(void)createButtonsAndLablesForNumberOfDays:(int)days withStartingAtDay:(int)startIndex monthIndex:(int)month
{
    
    int xpos = 0;
    int ypos = yValue;
    for (int xcount =1; xcount<8; xcount++)
    {
        if (xcount==startIndex)
        {
            break;
        }
        xpos = xpos+46;
    }
    
    for (int i = 1; i<=days; i++)
    {
        if (i==1) {
            UILabel *monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(xpos+8, ypos-30, 46, 26)];
            monthLabel.text=[self getMonthByIndex:month];
            monthLabel.font=[UIFont boldSystemFontOfSize:14.0];
            monthLabel.textAlignment=NSTextAlignmentCenter;
            monthLabel.textColor=[UIColor whiteColor];
            [_calendarScroll addSubview:monthLabel];
        }
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(xpos+8, ypos-5, 46, 16)];
        label.text=[NSString stringWithFormat:@"%d",i];
        label.tag=month*100+i+days;
        label.font=[UIFont boldSystemFontOfSize:11.0];
        label.textAlignment=NSTextAlignmentCenter;
        
        label.textColor=[UIColor whiteColor];
        // label.textColor=[UIColor colorWithRed:87/255.0 green:212/255.0 blue:218/255.0 alpha:.5];
        [_calendarScroll addSubview:label];
        
        
        
        UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        dateButton.frame = CGRectMake(xpos+9, ypos-10, 30, 26);
        dateButton.layer.cornerRadius = 5;
        dateButton.clipsToBounds = YES;
        
        
        //compare date to place marker over current date
        int month1 = 6;
        int year = 2016;
        NSString *actualDate = [[NSString alloc]initWithFormat:@"%d/%d/%d",i,month1,year];
        NSDate *date = [[self  returnDateFormatter] dateFromString:actualDate];
        NSString *todayDatestr= [[self returnDateFormatter] stringFromDate:[NSDate date]];
        NSDate *todayDate = [[self returnDateFormatter]dateFromString:todayDatestr];
        NSComparisonResult result = [date compare:todayDate];
        // compare date with today date to display current date
        
        
        if (result==NSOrderedSame)
        {
            // [dateButton setImage:[UIImage imageNamed:@"Button-tap.png"] forState:UIControlStateNormal];
            
        }
        dateButton.tag=month*100+i;
        [dateButton addTarget:self action:@selector(dateSelected:) forControlEvents:UIControlEventTouchUpInside];
        [_calendarScroll addSubview:dateButton];
        
        xpos=xpos+46;
        startIndex=startIndex+1;
        
        if (startIndex==8)
        {
            xpos=0;
            ypos=ypos+33;
            startIndex=1;
        }
        if (i==days) {
            ypos+=43;
            yValue=ypos;
            
        }
        
    }
    
}
- (IBAction)dateSelected:(UIButton *)sender
{
    UIButton *tempButton = (UIButton *)[self.view viewWithTag:(long)sender.tag];
    [tempButton setImage:[UIImage imageNamed:@"Button-tap.png"] forState:UIControlStateNormal];
    
      //******** Date DESELECT PART*************
    
    if ([selectedBtn containsString:@"-"]) {
        NSArray *arr = [selectedBtn componentsSeparatedByString:@"-"];
        UIButton *tempBtn1 = (UIButton *)[self.view viewWithTag:[[arr objectAtIndex:0]intValue]];
        [tempBtn1 setImage:nil forState:UIControlStateNormal];
        UIButton *tempBtn2 = (UIButton *)[self.view viewWithTag:[[arr objectAtIndex:1]intValue]];
        [tempBtn2 setImage:nil forState:UIControlStateNormal];
       
       
        NSString* temp;
        NSString* temp1;
        if ([[arr objectAtIndex:0]intValue]<1000) {
            temp=[[NSString alloc]initWithFormat:@"%c",[[arr objectAtIndex:0]characterAtIndex:0]];
        }else{
            temp=[[arr objectAtIndex:0]substringToIndex:2];
        }
        
        if ([[arr objectAtIndex:1]intValue]<1000) {
            temp1=[[NSString alloc]initWithFormat:@"%c",[[arr objectAtIndex:1]characterAtIndex:0]];
        }else{
            temp1=[[arr objectAtIndex:1]substringToIndex:2];
        }
        
        if ([[arr objectAtIndex:0]substringToIndex:2]==[[arr objectAtIndex:1]substringToIndex:2]) {
            
            for (int i=[[arr objectAtIndex:0]intValue]; i<=[[arr objectAtIndex:1]intValue]; i++) {
                UILabel *tempLabel = (UILabel *)[self.view viewWithTag:i+[[monthDaysArray objectAtIndex:[temp intValue]-1]intValue]];
                tempLabel.backgroundColor = [UIColor clearColor];
                tempLabel.alpha=1.0;
                tempLabel.textColor = [UIColor whiteColor];
            }
        }else{
            for (int i=[[arr objectAtIndex:0]intValue]; i<=[[temp stringByAppendingString:[monthDaysArray objectAtIndex:[temp intValue]-1]]intValue]; i++) {
                UILabel *tempLabel = (UILabel *)[self.view viewWithTag:i+[[monthDaysArray objectAtIndex:[temp intValue]-1]intValue]];
                tempLabel.backgroundColor = [UIColor clearColor];
                tempLabel.alpha=1.0;
                tempLabel.textColor = [UIColor whiteColor];
            }
            if ([temp1 intValue]-[temp intValue]>1) {
                int count=[temp intValue]+1;
                while (count<[temp1 intValue]) {
                    for (int i=1; i<=[[monthDaysArray objectAtIndex:count-1]intValue]; i++) {
                        UILabel *tempLabel = (UILabel *)[self.view viewWithTag:count*100+i+[[monthDaysArray objectAtIndex:count-1]intValue]];
                        tempLabel.backgroundColor = [UIColor clearColor];
                        tempLabel.alpha=1.0;
                        tempLabel.textColor = [UIColor whiteColor];
                    }
                    count++;
                }
                
            }

            
            for (int i=[temp1 intValue]*100+1; i<[[arr objectAtIndex:1]intValue]; i++) {
                UILabel *tempLabel = (UILabel *)[self.view viewWithTag:i+[[monthDaysArray objectAtIndex:[temp1 intValue]-1]intValue]];
                tempLabel.backgroundColor = [UIColor clearColor];
                tempLabel.alpha=1.0;
                tempLabel.textColor = [UIColor whiteColor];
            }
            
        }
        
        selectedBtn=@"";
    }
    
    // ********* DATE SELECTION PART ********
    
    if ([flag isEqualToString:@""]) {
        selectedBtn=[[NSString alloc]initWithFormat:@"%ld",(long)sender.tag];
        flag=[[NSString alloc]initWithFormat:@"%ld",(long)sender.tag];
        
        
    }
    else{
        if ([flag intValue]<(int)sender.tag) {
            
            selectedBtn=[selectedBtn stringByAppendingString:[[NSString alloc]initWithFormat:@"-%ld",(long)sender.tag]];
            NSArray *TappedBtnTag = [selectedBtn componentsSeparatedByString:@"-"];
            NSString* temp;
            if ([[TappedBtnTag objectAtIndex:0]intValue]<1000) {
                temp=[[NSString alloc]initWithFormat:@"%c",[[TappedBtnTag objectAtIndex:0]characterAtIndex:0]];
            }else{
                temp=[[TappedBtnTag objectAtIndex:0]substringToIndex:2];
            }
            
            NSString* temp1;
            if ([[TappedBtnTag objectAtIndex:1]intValue]<1000) {
                temp1=[[NSString alloc]initWithFormat:@"%c",[[TappedBtnTag objectAtIndex:1]characterAtIndex:0]];
            }else{
                temp1=[[TappedBtnTag objectAtIndex:1]substringToIndex:2];
            }
            if ([temp length]==[temp1 length]) {
                
                if ([temp length]==1) {
                    if ([[NSString alloc]initWithFormat:@"%c",[[TappedBtnTag objectAtIndex:0]characterAtIndex:0]]==[[NSString alloc]initWithFormat:@"%c",[[TappedBtnTag objectAtIndex:1]characterAtIndex:0]]) {
                        
                        for (int i=[flag intValue]; i<(int)sender.tag; i++) {
                            UILabel *tempLabel = (UILabel *)[self.view viewWithTag:i+[[monthDaysArray objectAtIndex:[temp intValue]-1]intValue]];
                            tempLabel.backgroundColor=[UIColor blueColor];
                            tempLabel.alpha=0.2;
                        }
                        
                    }
                    else{
                        
                        for (int i=[[TappedBtnTag objectAtIndex:0]intValue]; i<=[[temp stringByAppendingString:[monthDaysArray objectAtIndex:[temp intValue]-1]]intValue]; i++) {
                            UILabel *tempLabel = (UILabel *)[self.view viewWithTag:i+[[monthDaysArray objectAtIndex:[temp intValue]-1]intValue]];
                            tempLabel.backgroundColor=[UIColor blueColor];
                            tempLabel.alpha=0.2;
                        }
                        if ([temp1 intValue]-[temp intValue]>1) {
                            int count=[temp intValue]+1;
                            while (count<[temp1 intValue]) {
                                for (int i=1; i<=[[monthDaysArray objectAtIndex:count-1]intValue]; i++) {
                                    UILabel *tempLabel = (UILabel *)[self.view viewWithTag:count*100+i+[[monthDaysArray objectAtIndex:count-1]intValue]];
                                    tempLabel.backgroundColor=[UIColor blueColor];
                                    tempLabel.alpha=0.2;
                                }
                                count++;
                            }
                            
                        }
                        
                        for (int i=[temp1 intValue]*100+1; i<[[TappedBtnTag objectAtIndex:1]intValue]; i++) {
                            UILabel *tempLabel = (UILabel *)[self.view viewWithTag:i+[[monthDaysArray objectAtIndex:[temp1 intValue]-1]intValue]];
                            tempLabel.backgroundColor=[UIColor blueColor];
                            tempLabel.alpha=0.2;
                        }
                    }
                }else{
                    if ([[TappedBtnTag objectAtIndex:0]substringToIndex:2]==[[TappedBtnTag objectAtIndex:1]substringToIndex:2]) {
                        
                        for (int i=[flag intValue]; i<(int)sender.tag; i++) {
                            UILabel *tempLabel = (UILabel *)[self.view viewWithTag:i+[[monthDaysArray objectAtIndex:[temp intValue]-1]intValue]];
                            tempLabel.backgroundColor=[UIColor blueColor];
                            tempLabel.alpha=0.2;
                        }
                        
                    }
                    else{
                        
                        for (int i=[[TappedBtnTag objectAtIndex:0]intValue]; i<=[[temp stringByAppendingString:[monthDaysArray objectAtIndex:[temp intValue]-1]]intValue]; i++) {
                            UILabel *tempLabel = (UILabel *)[self.view viewWithTag:i+[[monthDaysArray objectAtIndex:[temp intValue]-1]intValue]];
                            tempLabel.backgroundColor=[UIColor blueColor];
                            tempLabel.alpha=0.2;
                        }
                        
                        
                        for (int i=[temp1 intValue]*100+1; i<[[TappedBtnTag objectAtIndex:1]intValue]; i++) {
                            UILabel *tempLabel = (UILabel *)[self.view viewWithTag:i+[[monthDaysArray objectAtIndex:[temp1 intValue]-1]intValue]];
                            tempLabel.backgroundColor=[UIColor blueColor];
                            tempLabel.alpha=0.2;
                        }
                    }
                }
                
            }else{
                    
                    for (int i=[[TappedBtnTag objectAtIndex:0]intValue]; i<=[[temp stringByAppendingString:[monthDaysArray objectAtIndex:[temp intValue]-1]]intValue]; i++) {
                        UILabel *tempLabel = (UILabel *)[self.view viewWithTag:i+[[monthDaysArray objectAtIndex:[temp intValue]-1]intValue]];
                        tempLabel.backgroundColor=[UIColor blueColor];
                        tempLabel.alpha=0.2;
                    }
                    
                if ([temp1 intValue]-[temp intValue]>1) {
                    int count=[temp intValue]+1;
                    while (count<[temp1 intValue]) {
                        for (int i=1; i<=[[monthDaysArray objectAtIndex:count-1]intValue]; i++) {
                            UILabel *tempLabel = (UILabel *)[self.view viewWithTag:count*100+i+[[monthDaysArray objectAtIndex:count-1]intValue]];
                            tempLabel.backgroundColor=[UIColor blueColor];
                            tempLabel.alpha=0.2;
                        }
                        count++;
                    }
                    
                }

                
                    for (int i=[temp1 intValue]*100+1; i<[[TappedBtnTag objectAtIndex:1]intValue]; i++) {
                        UILabel *tempLabel = (UILabel *)[self.view viewWithTag:i+[[monthDaysArray objectAtIndex:[temp1 intValue]-1]intValue]];
                        tempLabel.backgroundColor=[UIColor blueColor];
                        tempLabel.alpha=0.2;
                    }
            }
            
            
            flag=@"";
        }else{
            UIButton *tempBtn2 = (UIButton *)[self.view viewWithTag:[flag intValue]];
            [tempBtn2 setImage:nil forState:UIControlStateNormal];
            selectedBtn=[[NSString alloc]initWithFormat:@"%ld",(long)sender.tag];
            flag=[[NSString alloc]initWithFormat:@"%ld",(long)sender.tag];
        }
        
    }
    
    NSLog(@"Date Selected :%ld",(long)sender.tag);
}
-(NSString*)getMonthByIndex:(int)month{
    switch (month) {
        case 1:
            return @"Jan";
            break;
       case 2:
            return @"Feb";
            break;
        case 3:
            return @"Mar";
            break;
        case 4:
            return @"Apr";
            break;
        case 5:
            return @"May";
            break;
        case 6:
            return @"Jun";
            break;
        case 7:
            return @"Jul";
            break;
        case 8:
            return @"Aug";
            break;
        case 9:
            return @"Sep";
            break;
            
        case 10:
            return @"Oct";
            break;
        case 11:
            return @"Nov";
            break;
            
            
        default:
            return @"Dec";
            break;
    }
    
}

//** Drag able selector

- (void)wasDragged:(UIButton *)button withEvent:(UIEvent *)event
{
    // get the touch
    UITouch *touch = [[event touchesForView:button] anyObject];
    
    // get delta
    CGPoint previousLocation = [touch previousLocationInView:button];
    CGPoint location = [touch locationInView:button];
    CGFloat delta_x = location.x - previousLocation.x;
    CGFloat delta_y = location.y - previousLocation.y;
    
    // move button
    button.center = CGPointMake(button.center.x + delta_x,
                                button.center.y + delta_y);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)PreviousButton:(id)sender {
    NSString *currentYear=_yearLabel.text;
    NSString *backwardYear=[[NSString alloc]initWithFormat:@"%d",[currentYear intValue]-1];
    _yearLabel.text=backwardYear;
    [self drawCalendar:backwardYear];
}

- (IBAction)ForwordButton:(id)sender {
    NSString *currentYear=_yearLabel.text;
    NSString *forwardYear=[[NSString alloc]initWithFormat:@"%d",[currentYear intValue]+1];
    _yearLabel.text=forwardYear;
    [self drawCalendar:forwardYear];
}
@end
