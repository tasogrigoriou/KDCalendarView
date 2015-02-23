KDCalendarView
==============

Basic Implementation of a Calendar


![KDGradientView Sample PNG](http://s18.postimg.org/55wgwztgp/calendar.png)

### Basic Use

```sh
CGRect frame = CGRectMake(0.0, 0.0, 200.0, 200.0);
KDCalendarView* calendarView = [[KDCalendarView alloc] initWithFrame:frame];
calendarView.delegate = self;
calendarView.dataSource = self;
[self.view addSubview:calendarView]
```

