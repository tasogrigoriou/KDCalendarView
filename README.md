KDCalendarView
==============

Basic Implementation of a Calendar


![KDGradientView Sample PNG](http://s23.postimg.org/5dtufcwuj/screenshot.png)

### Installation
- Download the files or clone the project
- Drop the contents of the KDCalendarView group in your project
- Add the EventKit framework (From XCode, click on the project file then Build Phases > Link  Binary With Libraries. Press the + and add the EventKit.framework)

### Basic Use
Create a UIViewController that implementes the KDCalendarDelegate and KDCalendarDataSource and then create the calendar as below:
```sh
KDCalendarView* calendarView = [[KDCalendarView alloc] initWithFrame:calendarFrame];
calendarView.delegate = self;
calendarView.dataSource = self;
[self.view addSubview:calendarView]
```
The frame can be arbitrary and the component will morph to fit in the shape it is given

### Data Source and Delegate
The calendar will call on 2 interfaces. 

**KDCalendarDataSource** needs to implement at least the first method that returns the start date. Feel free to set this at today as below:
```sh
-(NSDate*)startDate {
  return [NSDate date];
}
```
**KDCalendarDelegate** will respond to scrolling events and date selection events

### Setting Dates

You can either set a date directly or scroll to the month you want if it is within the interval of start and end dates provided by the DataSource. The methods are: 'setMonthDisplayed:animated:' and 'setDateSelected:animated:'
Example of setting the calendar to scroll to the next month:
```sh
NSDateComponents* components = [[NSDateComponents alloc] init];
components.month = value;
NSDate* cdate = self.calendarView.monthDisplayed;
NSDate* date = [calendar dateByAddingComponents:components toDate:cdate options:0];
[self.calendarView setMonthDisplayed:date animated:YES];
```

