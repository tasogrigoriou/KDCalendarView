KDCalendarView
==============

Basic Implementation of a Calendar


![KDGradientView Sample PNG](http://s18.postimg.org/55wgwztgp/calendar.png)

### Basic Use

```sh
KDCalendarView* calendarView = [[KDCalendarView alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 200.0)] 
calendarView.delegate = self;
calendarView.dataSource = self;
[self.view addSubview:calendarView]
```

