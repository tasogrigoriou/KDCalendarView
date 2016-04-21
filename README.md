KDCalendarView
==============

Basic Implementation of a Calendar with EventKit read capabilities.

**This repository will not be actively maintained for much longer**, please look at [CalendarView](https://github.com/mmick66/CalendarView)  for an update version written inn Swift


![KDGradientView Sample PNG](http://s23.postimg.org/5dtufcwuj/screenshot.png)

### Installation
- Download the files or clone the project
- Drop the contents of the KDCalendarView group in your project
- Add the EventKit framework (From XCode, click on the project file then Build Phases > Link  Binary With Libraries. Press the + and add the EventKit.framework)

### Basic Use
Create a UIViewController that implementes the KDCalendarDelegate and KDCalendarDataSource and then create the calendar as below:
```objective-c
KDCalendarView* calendarView = [[KDCalendarView alloc] initWithFrame:calendarFrame];
calendarView.delegate = self;
calendarView.dataSource = self;

[self.view addSubview:calendarView]
```
The frame can be arbitrary and the component will morph to fit in the shape it is given.

To show events added from your iOS calendar add:

```objective-c
calendarView.showsEvents = YES;
```

### Data Source and Delegate
The calendar will call on 2 interfaces. 

**KDCalendarDataSource** needs to implement at least the first method that returns the start date. Feel free to set this at today as below:
```objective-c
-(NSDate*)startDate {
  return [NSDate date];
}
```
**KDCalendarDelegate** will respond to scrolling events and date selection events

### Setting Dates

You can either set a date directly or scroll to the month you want if it is within the interval of start and end dates provided by the DataSource. The methods are: 'setMonthDisplayed:animated:' and 'setDateSelected:animated:'
Example of setting the calendar to scroll to the next month:

```objective-c
NSDateComponents* components = [[NSDateComponents alloc] init];
components.month = value;
NSDate* cdate = self.calendarView.monthDisplayed;
NSDate* date = [calendar dateByAddingComponents:components toDate:cdate options:0];
[self.calendarView setMonthDisplayed:date animated:YES];
```

When selecting a start day which is not the first of the month, you can choose whether the days until that will be displayd grayed out.

```objective-c
self.calendarView.showsWholeMonthsOnStartAndEnd = YES;
```

### Design Philosophy

I chose to not use a UIViewController by mimicking the implementation of UITableView and UICollectionView which internally cache a lot of data about what and how it should appear. They use a delegate to get live data which in the case of the calendar is the start and end date, not the days in a spacific month, which although data are universal constants rather than variables.

