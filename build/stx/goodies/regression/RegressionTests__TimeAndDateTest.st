"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#TimeAndDateTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-DateAndTime'
!


!TimeAndDateTest methodsFor:'Testing'!

test_01_ReadingTimes

     self assert:(Time readFrom:'0:00'    ) = (Time hour:0 minute:0 second:0).
     self assert:(Time readFrom:'2:00'    ) = (Time hour:2 minute:0 second:0).
     self assert:(Time readFrom:'12:00'   ) = (Time hour:12 minute:0 second:0).
     self assert:(Time readFrom:'14:00'   ) = (Time hour:14 minute:0 second:0).
     self assert:(Time readFrom:'23:00'   ) = (Time hour:23 minute:0 second:0).
     self assert:(Time readFrom:'24:00'   ) = (Time hour:0 minute:0 second:0).
     self assert:(Time readFrom:'2:30 am' ) = (Time hour:2 minute:30 second:0).
     self assert:(Time readFrom:'2:30 pm' ) = (Time hour:14 minute:30 second:0).
     self assert:(Time readFrom:'14'      ) = (Time hour:14 minute:0 second:0).
     self assert:(Time readFrom:'2 am'    ) = (Time hour:2 minute:0 second:0).
     self assert:(Time readFrom:'2 pm'    ) = (Time hour:14 minute:0 second:0).
     self assert:(Time readFrom:'12:05 pm') = (Time hour:12 minute:5 second:0).
     self assert:(Time readFrom:'12:06 am') = (Time hour:0 minute:6 second:0).

     self assert:(Time readFrom:'18:22:00') = (Time hour:18 minute:22 second:0).
     self assert:(Time readFrom:'14:00:11') = (Time hour:14 minute:0 second:11).
     self assert:(Time readFrom:'7:00:11' ) = (Time hour:7 minute:0 second:11).
     self assert:(Time readFrom:'24:00:00') = (Time hour:0 minute:0 second:0).
     self assert:(Time readFrom:'0:00:00' ) = (Time hour:0 minute:0 second:0).
     self assert:(Time readFrom:'12:00:00') = (Time hour:12 minute:0 second:0).
     self assert:(Time readFrom:'0:00:00' ) = (Time hour:0 minute:0 second:0).
     self assert:(Time readFrom:'6:22:00 pm' ) = (Time hour:18 minute:22 second:0).
     self assert:(Time readFrom:'2:00:11 pm' ) = (Time hour:14 minute:0 second:11).
     self assert:(Time readFrom:'7:00:11 am' ) = (Time hour:7 minute:0 second:11).
     self assert:(Time readFrom:'12:00:00 am') = (Time hour:0 minute:0 second:0).
     self assert:(Time readFrom:'0:00:00 am' ) = (Time hour:0 minute:0 second:0).
     self should:[ Time readFrom:'24:00:00 am' ] raise:TimeConversionError.
     self assert:(Time readFrom:'12:00:00 pm') = (Time hour:12 minute:0 second:0).
     self assert:(Time readFrom:'0:00:00 pm' onError:'invalid') = 'invalid'.
     self should:[ Time readFrom:'24:00:00 pm' ] raise:TimeConversionError.

    "
     self new test_01_Reading
    "
!

test_02_ReadingDates

     self assert:(Date
		    readFrom:'2-may-2010'
		    printFormat:'%d-%shortMonthName-%y'
		    language:'en'
		    onError:[self error]
		  ) = (Date newDay:2 month:5 year:2010).

    {
	{   '3-jan-2012'   .   (Date newDay:3 month:1 year:2012)    } .
	{   '15-feb-2012'   .   (Date newDay:15 month:2 year:2012)  } .
	{   '06-mar-2011'   .   (Date newDay:6 month:3 year:2011)   } .
	{   '19-apr-2013'   .   (Date newDay:19 month:4 year:2013)  } .
	{   '21-may-2015'   .   (Date newDay:21 month:5 year:2015)  } .
	{   '21-jun-2015'   .   (Date newDay:21 month:6 year:2015)  } .
	{   '21-jul-2015'   .   (Date newDay:21 month:7 year:2015)  } .
	{   '21-aug-2015'   .   (Date newDay:21 month:8 year:2015)  } .
	{   '21-sep-2015'   .   (Date newDay:21 month:9 year:2015)  } .
	{   '21-oct-2015'   .   (Date newDay:21 month:10 year:2015)  } .
	{   '21-nov-2015'   .   (Date newDay:21 month:11 year:2015)  } .
	{   '21-dec-2015'   .   (Date newDay:21 month:12 year:2015)  } .
    } do:[:eachTestPair |
	 self assert:(Date
			readFrom:(eachTestPair first)
			printFormat:'%d-%shortMonthName-%y'
			language:'en'
			onError:[self error]
		      ) = (eachTestPair second).
    ].

     self assert:(Date
		    readFrom:'2-may-2010'
		    printFormat:'%d-%monthName-%y'
		    language:'en'
		    onError:[self error]
		  ) = (Date newDay:2 month:5 year:2010).

     self assert:(Date
		    readFrom:'2-may-2010'
		    printFormat:'%d-%(shortMonthName)-%y'
		    language:'en'
		    onError:[self error]
		  ) = (Date newDay:2 month:5 year:2010).

     self assert:(Date
		    readFrom:'2-may-2010'
		    printFormat:'%d-%(monthName)-%y'
		    language:'en'
		    onError:[self error]
		  ) = (Date newDay:2 month:5 year:2010).

     self assert:(Date
		    readFrom:'2-5-2010'
		    printFormat:'%d-%m-%y'
		    onError:[self error]
		  ) = (Date newDay:2 month:5 year:2010).

     self assert:(Date
		    readFrom:'5/2/2010'
		    printFormat:'%m/%d/%y'
		    onError:[self error]
		  ) = (Date newDay:2 month:5 year:2010).

     self assert:(Date
		    readFrom:'2010-5-2'
		    printFormat:'%y-%m-%d'
		    onError:[self error]
		  ) = (Date newDay:2 month:5 year:2010).

    "
     self new test_02_ReadingDates
    "
!

test_03_calenderWeek
    self assert:(Date newDay:5 month:11 year:2012) weekInYear == 45.
    self assert:(Date newDay:11 month:11 year:2012) weekInYear == 45.

    self assert:(Date newDay:4 month:11 year:2012) weekInYear == 44.
    self assert:(Date newDay:12 month:11 year:2012) weekInYear == 46.

    self assert:(Date newDay:29 month:12 year:2014) weekInYear == 1.    "/ YES!!
    self assert:(Date newDay:30 month:12 year:2014) weekInYear == 1.    "/ YES!!
    self assert:(Date newDay:31 month:12 year:2014) weekInYear == 1.    "/ YES!!
    self assert:(Date newDay:1 month:1 year:2015) weekInYear == 1.
    self assert:(Date newDay:2 month:1 year:2015) weekInYear == 1.
    self assert:(Date newDay:3 month:1 year:2015) weekInYear == 1.
    self assert:(Date newDay:4 month:1 year:2015) weekInYear == 1.

    self assert:(Date newDay:5 month:1 year:2015) weekInYear == 2.

    "/ every 4th of january is in the 1st week
    1902 to:2100 do:[:y |
	|d|
	d := Date newDay:4 month:1 year:y.
	self assert:d weekInYear == 1.
    ].

    "
     self new test_03_calenderWeek
    "
!

test_04_calenderWeek_fails
    <test: broken>
^ self.
    "/ currently fails for date before 1901
    1900 to:1905 do:[:y |
	|d|
	d := Date newDay:4 month:1 year:y.
	self assert:d weekInYear == 1.
    ].

    "
     self new test_04_calenderWeek_fails
    "
!

test_05_weekDayConversion
    {
	{ #( 6 53 2004) "2004-W53-6" . (Date newDay:1 month:1 year:2005) }   .
	{ #( 7 53 2004) "2004-W53-7" . (Date newDay:2 month:1 year:2005) }   .
	{ #( 6 52 2005) "2005-W52-6" . (Date newDay:31 month:12 year:2005) } .
	{ #( 1 1  2007) "2007-W01-1" . (Date newDay:1 month:1 year:2007) }   .
	{ #( 7 52 2007) "2007-W52-7" . (Date newDay:30 month:12 year:2007) } .

	{ #( 1 1  2008) "2008-W01-1" . (Date newDay:31 month:12 year:2007) } .
	{ #( 2 1  2008) "2008-W01-2" . (Date newDay:1 month:1 year:2008) }   .
	{ #( 7 52 2008) "2008-W52-7" . (Date newDay:28 month:12 year:2008) } .

	{ #( 1 1  2009) "2009-W01-1" . (Date newDay:29 month:12 year:2008) }     .
	{ #( 2 1  2009) "2009-W01-2" . (Date newDay:30 month:12 year:2008) }     .
	{ #( 3 1  2009) "2009-W01-3" . (Date newDay:31 month:12 year:2008) }     .
	{ #( 4 1  2009) "2009-W01-4" . (Date newDay:1 month:1 year:2009) }       .

	{ #( 4 53 2009) "2009-W53-4" . (Date newDay:31 month:12 year:2009) }     .
	{ #( 5 53 2009) "2009-W53-5" . (Date newDay:1 month:1 year:2010) }       .
	{ #( 6 53 2009) "2009-W53-6" . (Date newDay:2 month:1 year:2010) }       .
	{ #( 7 53 2009) "2009-W53-7" . (Date newDay:3 month:1 year:2010) }       .

	{ #( 1 1  1997) "1997-W01-1" . (Date newDay:30 month:12 year:1996) } .
    } do:[:eachPair |
	|dwy d1 d2 dayInWeek weekNr year|

	dwy := eachPair first.
	dayInWeek := dwy first.
	weekNr := dwy second.
	year := dwy third.
	d1 := Date newDayInWeek:dayInWeek week:weekNr year:year.

	d2 := eachPair second.
	self assert:(d1 = d2) description:'wrong: ',d1 printString, ' vs. ',d2 printString.
	self assert:(d1 weekInYear == weekNr).
	self assert:(d1 dayInWeek == dayInWeek).
    ]

    "
     self new test_05_weekDayConversion
    "
!

test_06_readingISO8601
    {
	{ '2004-W53-6'  . 'sat' . (Date newDay:1 month:1 year:2005) }   .
	{ '2004-W53-7'  . 'sun' . (Date newDay:2 month:1 year:2005) }   .
	{ '2005-W52-6'  . 'sat' . (Date newDay:31 month:12 year:2005) } .
	{ '2007-W01-1'  . 'mon' . (Date newDay:1 month:1 year:2007) }   .
	{ '2007-W52-7'  . 'sun' . (Date newDay:30 month:12 year:2007) } .

	{ '2008-W01-1'  . 'mon' . (Date newDay:31 month:12 year:2007) } .
	{ '2008-W01-2'  . 'tue' . (Date newDay:1 month:1 year:2008) }   .
	{ '2008-W52-7'  . 'sun' . (Date newDay:28 month:12 year:2008) } .

	{ '2009-W01-1'  . 'mon' . (Date newDay:29 month:12 year:2008) }     .
	{ '2009-W01-2'  . 'tue' . (Date newDay:30 month:12 year:2008) }     .
	{ '2009-W01-3'  . 'wed' . (Date newDay:31 month:12 year:2008) }     .
	{ '2009-W01-4'  . 'thu' . (Date newDay:1 month:1 year:2009) }       .

	{ '2009-W53-4'  . 'thu' . (Date newDay:31 month:12 year:2009) }     .
	{ '2009-W53-5'  . 'fri' . (Date newDay:1 month:1 year:2010) }       .
	{ '2009-W53-6'  . 'sat' . (Date newDay:2 month:1 year:2010) }       .
	{ '2009-W53-7'  . 'sun' . (Date newDay:3 month:1 year:2010) }       .
    } do:[:eachTriple |
	|input expected expectedDayName got gotName|

	input := eachTriple first.
	expectedDayName := eachTriple second.
	expected := eachTriple third.
	got := (Timestamp readIso8601FormatFrom:input onError:nil) asDate.
	self assert:(got = expected) description:'wrong: ',input.
	gotName := got abbreviatedDayNameForLanguage:#en.
	self assert:gotName = expectedDayName description:'expected: ',expectedDayName asString,' got: ',gotName asString.
    ]

    "
     self new test_06_calenderWeek_fails
    "
!

test_07_readingISO8601
    "tests reading into a 'natural' timestamp - that is if there was a TZ info,
     that will be printed. If not, it will remain a local timestamp.
     Presenting timestamps this way is not usually a good idea, except for GUI
     (but not for data exchange)"

    {
     { '1995-02-20T13:11:06.123'   . '1995-02-20 13:11:06.123' } .
     { '1995-02-20T13:11:06'       . '1995-02-20 13:11:06' } .
     { '1995-02T13:11:06'          . '1995-02-01 13:11:06' } .
     { '1995T13:11:06'             . '1995-01-01 13:11:06' } .
     { '1995T13:11'                . '1995-01-01 13:11:00' } .
     { '1995T13:11.5'              . '1995-01-01 13:11:30' } .
     { '1995T13:11,5'              . '1995-01-01 13:11:30' } .
     { '1995T13'                   . '1995-01-01 13:00:00' } .
     { '1995T13.25'                . '1995-01-01 13:15:00' } .
     { '1995T13.333333'            . '1995-01-01 13:19:59.999' } .
     { '1995'                      . '1995-01-01 00:00:00' } .
     { '1995-02'                   . '1995-02-01 00:00:00' } .
     { '19950204'                  . '1995-02-04 00:00:00' } .

     "/ day in year
     { '1995-001'                  . '1995-01-01 00:00:00' } .
     { '1995-035'                  . '1995-02-04 00:00:00' } .
     { '1995035'                   . '1995-02-04 00:00:00' } .

     { '1997-01-01'                . '1997-01-01 00:00:00' } .
     "/ week and weekday
     { '1997-W01'                  . '1996-12-30 00:00:00' } .
     { '1997W01'                   . '1996-12-30 00:00:00' } .
     { '1997W01-1'                 . '1996-12-30 00:00:00' } .
     { '1997W011'                  . '1996-12-30 00:00:00' } .
     { '1997W01'                   . '1996-12-30 00:00:00' } .
     { '1997W01-2'                 . '1996-12-31 00:00:00' } .
     { '1997-W01-2'                . '1996-12-31 00:00:00' } .
     { '1997W012'                  . '1996-12-31 00:00:00' } .
     { '2014W40'                   . '2014-09-29 00:00:00' } .
     { '2014W44-4'                 . '2014-10-30 00:00:00' } .
     { '2014W01'                   . '2013-12-30 00:00:00' } .
     { '2014W01-1'                 . '2013-12-30 00:00:00' } .
     { '2014W01-2'                 . '2013-12-31 00:00:00' } .
     { '2014W01-3'                 . '2014-01-01 00:00:00' } .

     { '1995-02-20 13:11'          . '1995-02-20 13:11:00' } .
     { '1995-02-20 1311'           . '1995-02-20 13:11:00' } .
     { '1995-02-20 13'             . '1995-02-20 13:00:00' } .
     { '1995-02-20 235959'         . '1995-02-20 23:59:59' } .
     { '19950220 235959'           . '1995-02-20 23:59:59' } .
     { '19950220 23:59:59.9942'    . '1995-02-20 23:59:59.994' } .
     { '19950220 235959.9942'      . '1995-02-20 23:59:59.994' } .

     "/ local vs. UTC
     { '1995-02-20 13:11:06'       . '1995-02-20 13:11:06' } .
     { '1995-02-20 13:11:06Z'      . '1995-02-20 13:11:06Z' } .
     { '1995-02-20 13:11:06+01'    . '1995-02-20 13:11:06+01' } .
     { '1995-02-20 13:11:06+01:00' . '1995-02-20 13:11:06+01' } .
     { '1995-02-20 13:11:06+01:30' . '1995-02-20 13:11:06+01:30' } .
     { '1995-02-20 13:11:06+0130'  . '1995-02-20 13:11:06+01:30' } .
     { '1995-02-20 13:11:06-01'    . '1995-02-20 13:11:06-01' } .
     { '1995-02-20 13:11:06-01:00' . '1995-02-20 13:11:06-01' } .
     { '1995-02-20 13:11:06-01:30' . '1995-02-20 13:11:06-01:30' } .
     { '1995-02-20 13:11:06-0130'  . '1995-02-20 13:11:06-01:30' } .

     "/ 24 is allowed with ISO, and is 00:00 of the next day:
     { '1995-02-20 24:00:00'       . '1995-02-21 00:00:00' } .
    } do:[:eachPair |
	|s1 t expected got|

	s1 := eachPair first.
	t := Timestamp readIso8601FormatFrom:s1.
	expected := eachPair second.
	got := t asString.
	self assert:(got = expected) description:'expected: ',expected,' got:',got.
    ].

    "
     self new test_07_readingISO8601
    "
!

test_07b_readingISO8601UTC
    "tests reading into an utc timestamp"

    {
     { '1995-02-20T13:11:06.123'   . '1995-02-20 13:11:06.123Z' } .
     { '1995-02-20T13:11:06'       . '1995-02-20 13:11:06Z' } .
     { '1995-02T13:11:06'          . '1995-02-01 13:11:06Z' } .
     { '1995T13:11:06'             . '1995-01-01 13:11:06Z' } .
     { '1995T13:11'                . '1995-01-01 13:11:00Z' } .
     { '1995T13:11.5'              . '1995-01-01 13:11:30Z' } .
     { '1995T13:11,5'              . '1995-01-01 13:11:30Z' } .
     { '1995T13'                   . '1995-01-01 13:00:00Z' } .
     { '1995T13.25'                . '1995-01-01 13:15:00Z' } .
     { '1995T13.333333'            . '1995-01-01 13:19:59.999Z' } .
     { '1995'                      . '1995-01-01 00:00:00Z' } .
     { '1995-02'                   . '1995-02-01 00:00:00Z' } .
     { '19950204'                  . '1995-02-04 00:00:00Z' } .

     "/ day in year
     { '1995-001'                  . '1995-01-01 00:00:00Z' } .
     { '1995-035'                  . '1995-02-04 00:00:00Z' } .
     { '1995035'                   . '1995-02-04 00:00:00Z' } .

     { '1997-01-01'                . '1997-01-01 00:00:00Z' } .
     "/ week and weekday
     { '1997-W01'                  . '1996-12-30 00:00:00Z' } .
     { '1997W01'                   . '1996-12-30 00:00:00Z' } .
     { '1997W01-1'                 . '1996-12-30 00:00:00Z' } .
     { '1997W011'                  . '1996-12-30 00:00:00Z' } .
     { '1997W01'                   . '1996-12-30 00:00:00Z' } .
     { '1997W01-2'                 . '1996-12-31 00:00:00Z' } .
     { '1997-W01-2'                . '1996-12-31 00:00:00Z' } .
     { '1997W012'                  . '1996-12-31 00:00:00Z' } .
     { '2014W40'                   . '2014-09-29 00:00:00Z' } .
     { '2014W44-4'                 . '2014-10-30 00:00:00Z' } .
     { '2014W01'                   . '2013-12-30 00:00:00Z' } .
     { '2014W01-1'                 . '2013-12-30 00:00:00Z' } .
     { '2014W01-2'                 . '2013-12-31 00:00:00Z' } .
     { '2014W01-3'                 . '2014-01-01 00:00:00Z' } .

     { '1995-02-20 13:11'          . '1995-02-20 13:11:00Z' } .
     { '1995-02-20 1311'           . '1995-02-20 13:11:00Z' } .
     { '1995-02-20 13'             . '1995-02-20 13:00:00Z' } .
     { '1995-02-20 235959'         . '1995-02-20 23:59:59Z' } .
     { '19950220 235959'           . '1995-02-20 23:59:59Z' } .
     { '19950220 23:59:59.9942'    . '1995-02-20 23:59:59.994Z' } .
     { '19950220 235959.9942'      . '1995-02-20 23:59:59.994Z' } .

     "/ local vs. UTC
     { '1995-02-20 13:11:06'       . '1995-02-20 13:11:06Z' } .
     { '1995-02-20 13:11:06Z'      . '1995-02-20 13:11:06Z' } .
     { '1995-02-20 13:11:06+01'    . '1995-02-20 12:11:06Z' } .      "/ notice the changed time here!!!!!!
     { '1995-02-20 13:11:06+01:00' . '1995-02-20 12:11:06Z' } .      "/ notice the changed time here!!!!!!
     { '1995-02-20 13:11:06+01:30' . '1995-02-20 11:41:06Z' } .      "/ notice the changed time here!!!!!!
     { '1995-02-20 13:11:06+0130'  . '1995-02-20 11:41:06Z' } .      "/ notice the changed time here!!!!!!
     { '1995-02-20 13:11:06-01'    . '1995-02-20 14:11:06Z' } .
     { '1995-02-20 13:11:06-01:00' . '1995-02-20 14:11:06Z' } .
     { '1995-02-20 13:11:06-01:30' . '1995-02-20 14:41:06Z' } .
     { '1995-02-20 13:11:06-0130'  . '1995-02-20 14:41:06Z' } .

     "/ 24 is allowed with ISO, and is 00:00 of the next day:
     { '1995-02-20 24:00:00'       . '1995-02-21 00:00:00Z' } .
    } do:[:eachPair |
	|s1 t expected got|

	s1 := eachPair first.
	t := UtcTimestamp readIso8601FormatFrom:s1.
	expected := eachPair second.
	got := t asString.
	self assert:(got = expected) description:'expected: ',expected,' got:',got.
    ].

    "
     self new test_07_readingISO8601
    "
!

test_08_readingISO8601_date
    "/ the old ISO8601Builder tests moved to here

    | ts reader |

    reader := Timestamp::TimestampISO8601Builder.

    ts := UtcTimestamp
	 year: 2005 month: 6 day: 15
	 hour: 0 minute: 0 second: 0 millisecond: 0.

    "Test common dates"
    self assert: ts = (reader read: '20050615' withClass:UtcTimestamp).
    self assert: ts = (reader read: '2005-06-15'  withClass:UtcTimestamp).
    self assert: ts = (reader read: '05-06-15'  withClass:UtcTimestamp).
    self assert: ts = (reader read: '05-0615'  withClass:UtcTimestamp). "/ Is this correct?
    self assert: ts = (reader read: ':50615'  withClass:UtcTimestamp). "/ Should not happen and should not appear after 2009
    self assert: ts = (reader read: '200506-15'  withClass:UtcTimestamp). "/ Is this corect?
    self assert: ts = (reader read: '105-06-15'  withClass:UtcTimestamp). "/ Should not happen

    "Test week numbers"
    self assert: ts = (reader read: '05W243'  withClass:UtcTimestamp).
    self assert: ts = (reader read: '2005W24-3'  withClass:UtcTimestamp).

    "Test day numbers"
    self assert: ts = (reader read: '2005-166'  withClass:UtcTimestamp).

    ts := UtcTimestamp year: 2004 month: 12 day: 31 hour: 0 minute: 0 second: 0 millisecond: 0.
    self assert: ts = (reader read: '2004-366'  withClass:UtcTimestamp).

    ts := UtcTimestamp year: 2005 month: 12 day: 31 hour: 0 minute: 0 second: 0 millisecond: 0.
    self assert: ts = (reader read: '2005-365'  withClass:UtcTimestamp).

    "Test february"
    ts := UtcTimestamp year: 2000 month: 2 day: 28 hour: 0 minute: 0 second: 0 millisecond: 0.
    self assert: ts = (reader read: '20000228'  withClass:UtcTimestamp).

    ts := UtcTimestamp year: 2000 month: 2 day: 29 hour: 0 minute: 0 second: 0 millisecond: 0.
    self assert: ts = (reader read: '20000229'  withClass:UtcTimestamp).

    "
     self new test_08_readingISO8601
    "
!

test_09_readingISO8601_edge
    "/ the old ISO8601Builder tests moved to here

    | ts reader |

    reader := Timestamp::TimestampISO8601Builder.

    self should: [reader read: '20050229' withClass:UtcTimestamp] raise:ConversionError.
    self should: [reader read: '20050029' withClass:UtcTimestamp] raise:ConversionError.
    self should: [reader read: '20050332' withClass:UtcTimestamp] raise:ConversionError.
    self should: [reader read: '2005-366' withClass:UtcTimestamp] raise:ConversionError.

    ts := UtcTimestamp year: 2005 month: 1 day: 1 hour: 0 minute: 0 second: 0 millisecond: 0.
    self assert: ts = (reader read: '20041231T22-0200' withClass:UtcTimestamp).

    ts := UtcTimestamp year: 2004 month: 12 day: 31 hour: 22 minute: 0 second: 0 millisecond: 0.
    self assert: ts = (reader read: '20050101T0000+0200' withClass:UtcTimestamp).

    "
     self new test_08_readingISO8601
    "
!

test_10_readingISO8601_time
    "/ the old ISO8601Builder tests moved to here

    | ts reader |

    reader := Timestamp::TimestampISO8601Builder.

    ts := UtcTimestamp  year: 2005 month: 6 day: 15 hour: 17 minute: 37 second: 0 millisecond: 0.
    self assert: ts = (reader read: '2005-06-15 17:37' withClass:UtcTimestamp).
    self assert: ts = (reader read: '20050615T1737' withClass:UtcTimestamp).
    self assert: ts = (reader read: '05-0615T17:3700' withClass:UtcTimestamp).

    ts := UtcTimestamp  year: 2005 month: 6 day: 15 hour: 17 minute: 37 second: 0 millisecond: 30.
    self assert: ts = (reader read: '05-0615T17:3700.03' withClass:UtcTimestamp).
    self assert: ts = (reader read: '2005-06-15T17:37:00.0305486-00:00' withClass:UtcTimestamp).

    "
     self new test_10_readingISO8601_time
    "
!

test_11_readingISO8601_timezone
    "/ the old ISO8601Builder tests moved to here

    | ts reader |

    reader := Timestamp::TimestampISO8601Builder.

    ts := UtcTimestamp
	 year: 2005 month: 6 day: 15
	 hour: 17 minute: 37 second: 0 millisecond: 0.

    self assert: ts = (reader read: '2005-06-15T17:37Z' withClass:UtcTimestamp).
    self assert: ts = (reader read: '2005-06-15T17:37+0000' withClass:UtcTimestamp).
    self assert: ts = (reader read: '2005-06-15T17:37-00:00' withClass:UtcTimestamp).
    self assert: ts = (reader read: '2005-06-15T15:37:00-0200' withClass:UtcTimestamp).
    self assert: ts = (reader read: '2005-06-15T19:37:00+0200'withClass:UtcTimestamp).

    "
     self new test_11_readingISO8601_timezone
    "
!

test_12_dateQueries
    |d1 d2 d3|

    d1 := Date newDay:1 month:2 year:1940.
    d2 := Date newDay:1 month:2 year:1941.
    self assert:(d2 - d1) = 366.

    d1 := Date newDay:1 month:2 year:1840.
    d2 := Date newDay:1 month:2 year:1841.
    self assert:(d2 - d1) = 366.
    self assert:(d1 addDays:366) = d2.

    Date leapYear:1540.
    d1 := Date newDay:1 month:2 year:1540.
    d2 := Date newDay:1 month:2 year:1541.
    self assert:(d2 - d1) = 366.

    d1 := Date newDay:1 year:1901.
    self assert:(d1 day = 1).
    self assert:(d1 month = 1).
    self assert:(d1 year = 1901).

    "/ 1900 was NOT a leap year
    self assert:(Date leapYear:1900) not.
    "/ 2000 was a leap year
    self assert:(Date leapYear:2000).

    d2 := d1 subtractDays:365.
    self assert:(d2 day = 1).
    self assert:(d2 month = 1).
    self assert:(d2 year = 1900).

    d3 := d2 subtractDays:365.
    self assert:(d3 day = 1).
    self assert:(d3 month = 1).
    self assert:(d3 year = 1899).

    d1 := Date newDay:1 month:2 year:2540.
    d2 := Date newDay:1 month:2 year:2541.
    self assert:(d2 - d1) = 366.


    "
     self new test_12_dateQueries
    "
!

test_13_timestampQueries
    |d1 d2 local utc|

    d1 := UtcTimestamp newDay:1 month:1 year:2000.
    d2 := UtcTimestamp newDay:1 month:1 year:2001.
    self assert:(d2 - d1) days = 366.

    d1 := UtcTimestamp newDay:2 month:1 year:1940.
    d2 := UtcTimestamp newDay:2 month:1 year:1941.
    self assert:d1 asDate year = 1940.
    self assert:d2 asDate year = 1941.
    self assert:d1 asDate month = 1.
    self assert:d2 asDate month = 1.
    self assert:d1 asDate day = 2.
    self assert:d2 asDate day = 2.

    self assert:d1 asDate isLeapYear.
    self assert:d2 asDate isLeapYear not.
    self assert:(d2 - d1) days = 366.

    d1 := UtcTimestamp newDay:1 month:1 year:1840.
    d2 := UtcTimestamp newDay:1 month:1 year:1841.
    self assert:d1 asDate isLeapYear.
    self assert:d2 asDate isLeapYear not.
    self assert:(d2 - d1) days = 366.

    self assert:(d1 addDays:366) = d2.

    d1 := UtcTimestamp newDay:1 month:1 year:1540.
    d2 := UtcTimestamp newDay:1 month:1 year:1541.
    self assert:d1 asDate isLeapYear.
    self assert:d2 asDate isLeapYear not.
    self assert:(d2 - d1) days = 366.

    d1 := Timestamp newDay:1 month:1 year:1540.
    d2 := Timestamp newDay:1 month:1 year:1541.
    self assert:d1 asDate isLeapYear.
    self assert:d2 asDate isLeapYear not.
    self assert:(d2 - d1) days = 366.

    d1 := Timestamp newDay:1 month:1 year:2038.
    d2 := Timestamp newDay:1 month:1 year:2039.
    self assert:d1 asDate isLeapYear not.
    self assert:d2 asDate isLeapYear not.
    self assert:(d2 - d1) days = 365.

    d1 := Timestamp newDay:1 month:1 year:2540.
    d2 := Timestamp newDay:1 month:1 year:2541.
    self assert:d1 asDate isLeapYear.
    self assert:d2 asDate isLeapYear not.
    self assert:(d2 - d1) days = 366.

    d1 := Timestamp newDay:1 month:1 year:3540.
    d2 := Timestamp newDay:1 month:1 year:3541.
    self assert:d1 asDate isLeapYear.
    self assert:d2 asDate isLeapYear not.
    self assert:(d2 - d1) days = 366.

    d1 := Timestamp newDay:1 month:1 year:1969.
    d2 := Timestamp newDay:1 month:1 year:1970.   
    self assert:d1 asDate isLeapYear not.
    self assert:d2 asDate isLeapYear not.
    self assert:(d2 - d1) days = 365.

    d1 := Timestamp newDay:1 month:1 year:1600.
    d2 := Timestamp newDay:1 month:1 year:1601.   
    self assert:d1 asDate isLeapYear.
    self assert:d2 asDate isLeapYear not.
    self assert:(d2 - d1) days = 366.

    d1 := Timestamp newDay:1 month:1 year:1969.
    d2 := Timestamp newDay:1 month:1 year:1970.
    self assert:d1 asDate isLeapYear not.
    self assert:d2 asDate isLeapYear not.
    self assert:(d2 - d1) days = 365.

    d1 := Timestamp newDay:1 month:1 year:1600.
    d2 := Timestamp newDay:1 month:1 year:1601.
    self assert:d1 asDate isLeapYear.
    self assert:d2 asDate isLeapYear not.
    self assert:(d2 - d1) days = 366.

    "/ local time vs. utc time
    local := Timestamp newDay:1 month:1 year:1940.
    utc := UtcTimestamp newDay:1 month:1 year:1940.
    self assert:(local asUtcTimestamp - utc asUtcTimestamp) asSeconds = local utcOffset.

    "/ tz time vs. utc time
    utc := Timestamp readFrom:'20000102T123000Z'.
    local := Timestamp readFrom:'20000102T123000+02'.
    self assert:(utc - local) asSeconds = 7200.

    "/ tz time vs. utc time
    utc := UtcTimestamp readFrom:'20000102T123000Z'.
    local := UtcTimestamp readFrom:'20000102T123000-02'.
    self assert:(utc - local) asSeconds = -7200.

    "
     self new test_13_timestampQueries
    "
!

test_14_arithmetic
    |t1 t2 t3 s|

    t1 := UtcTimestamp newDay:1 month:1 year:2000.
    t2 := t1 addDays:1.
    self assert:(t2 - t1) days = 1.

    t2 := t1 addHours:1.
    self assert:(t2 - t1) hours = 1.

    t2 := t1 addSeconds:1.
    self assert:(t2 - t1) seconds = 1.

    t1 := UtcTimestamp readFrom:'20000102T133045Z'.
    t2 := t1 addDays:1.
    self assert:(t2 printString = '2000-01-03 13:30:45Z').

    t1 := Timestamp readFrom:'20000102T133045+01'.
    t2 := t1 addDays:1.
    self assert:(t2 printString = '2000-01-03 13:30:45+01').

    t1 := UtcTimestamp readFrom:'20000102T133045Z'.
    t2 := Timestamp readFrom:'20000102T133045Z'.
    self assert:(t1 = t2).

    t2 := Timestamp readFrom:'20000102T143045+01'.
    self assert:(t1 = t2).

    t2 := Timestamp readFrom:'20000102T123045-01'.
    self assert:(t1 = t2).

    t2 := Timestamp readFrom:'20000102T123045'.     "/ a local one
    s := t2 storeString.
    t3 := Timestamp readFrom:s.

    self assert:(t2 = t3).

    t1 := TZTimestamp readFrom:'20000102T133045Z'.
    self assert:(t1 printString = '2000-01-02 13:30:45+00').
    t1 := UtcTimestamp readFrom:'20000102T133045Z'.
    self assert:(t1 printString = '2000-01-02 13:30:45Z').

    "
     self new test_14_arithmetic
    "
!

test_15_misc
    #( 1700  1800  1900  2100  2200 ) do:[:y |
	self assert:(Date leapYear:y) not
    ].
    #( 1600  2000 2400 ) do:[:y |
	self assert:(Date leapYear:y)
    ].

    "
     self new test_15_misc
    "
!

test_16_readingOtherFormats
    | ts |

    "/ european format
    ts := Timestamp readFrom: '16-09-2013 00:42:35' readStream.

    self assert: ts day = 16.
    self assert: ts month = 9.
    self assert: ts year = 2013.
    self assert: ts hours = 0.
    self assert: ts minutes = 42.
    self assert: ts seconds = 35.

    "/ us format
    ts := Timestamp readFrom: '11/21/2013 00:42:35' readStream.

    self assert: ts day = 21.
    self assert: ts month = 11.
    self assert: ts year = 2013.
    self assert: ts hours = 0.
    self assert: ts minutes = 42.
    self assert: ts seconds = 35.

    "
     self new test_16_readingOtherFormats
    "
! !

!TimeAndDateTest class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

