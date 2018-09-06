"
 COPYRIGHT (c) 1993 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview' }"

"{ NameSpace: Smalltalk }"

Object subclass:#WindowSensor
	instanceVariableNames:'eventSemaphore damage mouseAndKeyboard compressMotionEvents
		ignoreUserInput exposeEventSemaphore catchExpose gotExpose
		gotOtherEvent translateKeyboardEvents shiftDown ctrlDown metaDown
		altDown leftButtonDown middleButtonDown rightButtonDown
		eventListeners ignoreExposeEvents damageEventAccessLock
		userEventAccessLock gotCompose compose1 collectedMouseWheelMotion'
	classVariableNames:'ControlCEnabled ControlYEnabled ControlPeriodEnabled ComposeTable
		EventListeners MouseWheelThreshold MouseWheelScale'
	poolDictionaries:''
	category:'Interface-Support-UI'
!

!WindowSensor class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    Instances of this class keep track of events and damage areas for a group of 
    views. All incoming expose rectangles and events (from Workstation) are 
    collected here, until someone (usually the windowGroup process)
    gets a chance to handle them. 
    In contrast to ST-80 (which has one windowSensor per window), ST/X usually
    only assigns one sensor per windowGroup.
    (however, you could manually arrange for per view private sensors
     - at least, theoretically)

    When adding an expose rectangle, WindowSensor tries to merge the rectangle 
    with the list of existing damages to minimize redrawing.

    Processing of compose key sequences is done here; if a Compose
    key event arrives, the following 2 characters are used to search an
    entry in the composeTable, and are replaced by the character found there.
    For example, pressing Compose-a-` gives the french a-accent-grave character;
    pressing Compose-a-e gives the ae ligature.

    Beside the above, windowSensors provide facilities (hooks) to allow
    so-called 'eventListeners' to get the event before it is entered into
    the queue. There are 4 possible listening hooks available:

        global EventListener - get keybd/mouse/focus/enter-leave events for all views and all displays
        per-display eventListener - gets only keybd/mouse/focus/enter-leave events for one display (see GraphicsDevice)
        per-sensor eventListener - gets only keybd/mouse/focus/enter-leave events for this sensors windowGroup
        per-sensor keyboardListener - only gets keyboard events for this sensors windowGroup

    (actually, there are two more mechanisms, event delegation which allows
     delegation of key- and buttonEvents of a specific view,
     and per-windowGroup eventHooks)

    Global eventListeners are installed via a class method (addEventListener:) to
    the WindowSensor class; local listeners are installed via instance methods.
    A listener may return true to signal that it has handled the event and that the
    event should NOT be enqueued. 
    Likewise, if it returns false, the event is processed as usual 
    (i.e. enqueued and forwarded to the view's controller).
    If there are multiple listeners, all of them get a chance to process the event,
    but it will not be enqueued, if any returned true.

    The global listeners are called before any local listener, which are called
    before any keyboard listeners. 
    If any listener-group has eaten the event, later (local) listeners wont get the event.

    EventListeners have been added to allow the implementation of event recorders,
    screen savers or other spy functionality. 
    They also allow hooking up views which otherwise insist on doing things themself.

    Notice, that beside event listening, you can also define a delegate for
    a views keyboard and button events. 
    Read the documentation in WindowEvent for more info.

    NOTICE: in previous releases, only one listener was allowed, which was notified
    via #buttonPress/#buttonRelease ... invocations.
    We have changed this to allow multiple handlers, and also to pass the event to a single
    #handleEvent method.
    The old mechanism is kept for a while for backward compatibility, but will eventually
    vanish.

    [instance variables:]
        eventSemaphore          <Semaphore>     the semaphore to be signalled when an event
                                                (or damage) arrives

        damage                  <Collection>    collection of damage events

        mouseAndKeyboard        <Collection>    collection of user events

        compressMotionEvents    <Boolean>       if true, multiple motion events are
                                                compressed to one event. If false, each
                                                event is handled individual.
                                                (should be set to false when doing free-hand drawing)

        ignoreUserInput         <Boolean>       if true, key & button events are ignored
                                                (usually set to true by WindowGroup, while a
                                                 modalbox covers a view)

        shiftDown               <Boolean>       true while shift/meta/control-key is pressed
        metaDown                                (to support ST-80 style query: sensor shiftDown)
        ctrlDown
        altDown                                 (notice, that on most systems, alt and meta key is
                                                 the same, both reported as #Alt)

        exposeEventSemaphore    <Semaphore>     X-special: semaphore to be signalled when
                                                expose event arrives after a copyArea.

        catchExpose             <SetOfView>     if nonEMpty, the drawables which wait for
                                                an expose/noExpose event.  (after a copyArea)

        gotExpose               <SetOfView>     the set of drawables which got an expose/noExpose
                                                event.  (after a copyarea)

        gotOtherEvent           <SetOfView>     set of drawables which received if other events,
                                                while waiting for expose (after a copyarea).

        translateKeyboardEvents <Boolean>       if true, keyboard events are translated via
                                                the devices leyboardMap; if false, they
                                                are reported as raw-keys. Default is true.

        eventListener           <Object>        if non nil, this one will get all pointer
        OBSOLETE - will vanish                  and keyboard events for this sensors views first.
                                                If it returns true, the event is supposed to
                                                be already handled by the listener and not sent to
                                                the view. If false, the event is handled as usual.
                                                This allows applications to catch events for any of
                                                its views.

        keyboardListener        <Object>        if non nil, this one will get all keyboard events 
        OBSOLETE - will vanish                  for this sensors views first (but after the eventListener,
                                                if any).
                                                If it returns true, the event is supposed to
                                                be already handled by the listener and not sent to
                                                the view. If false, the event is handled as usual.
                                                This allows applications to catch events for any of
                                                its views.
                                                ApplicationModels can catch keyboard input with:
                                                    postOpenWith:aBuilder
                                                        aBuilder window sensor keyboardListener:self

        eventListeners          <Collection>    Collection of new event listeners.
                                                Each will be sent a #handleEvent: message.
                                                The event will not be enqueued, if any returns
                                                true.

        keyboardListeners       <Collection>    Collection of new event listeners.
                                                Each will be sent a #handleEvent: message.
                                                The event will not be enqueued, if any returns
                                                true.

        accessLock              <Semaphore>     controls access to the event queues

    [class variables:]

        ControlCEnabled         <Boolean>       if true (which is the default) Control-C
                                                will interrupt the process handling the
                                                view.
                                                For secure stand-alone applications,
                                                this can be set to false, in which case 
                                                Control-C does NOT interrupt the process.
                                                (actually, Control-C is wrong here; the actual
                                                 key is #UserInterrupt, which may be mapped onto
                                                 any key)

        ControlYEnabled         <Boolean>       if true (which is the default) Control-Y
                                                will raise the abortSignal in the process 
                                                handling the view.
                                                This can be used to abort a long operation
                                                (such as a long fileRead in the fileBrowser)
                                                without entering the debugger.
                                                (actually, Control-Y is wrong here; the actual
                                                 key is #UserAbort, which may be mapped onto
                                                 any key)

        EventListener           <Object>        if non nil, this one will get all pointer
        OBSOLETE - will vanish                  and keyboard events for ALL views first.
                                                If it returns true, the event is supposed to
                                                be already handled by the listener and not enqueued. 
                                                If false, the event is handled as usual.
                                                This allows overall event catchers to be
                                                installed for example to implement event
                                                recorders, active help managers etc.

        EventListeners          <Collection>    Collection of new event listeners.
                                                Each will be sent a #handleEvent: message.
                                                The event will not be enqueued, if any returns
                                                true.

        ComposeTable            <Array>         compose-key translation table


    [author:]
        Claus Gittinger

    [see also:]
        WindowGroup 
        WindowEvent KeyboardMap KeyboardForwarder EventListener
        GraphicsDevice DeviceWorkstation View
"
! !

!WindowSensor class methodsFor:'initialization'!

initialize
    "initialize the classes constants"

    ControlCEnabled := true.
    ControlYEnabled := true.
    ControlPeriodEnabled := true.

    ComposeTable isNil ifTrue:[
        self initializeComposeKeyTable
    ].

    MouseWheelScale := UserPreferences current mouseWheelScale.

    "
     WindowSensor initialize
    "

    "Modified: / 20.5.1998 / 14:01:52 / cg"
!

initializeComposeKeyTable
    "setup the composeKey table"

    ComposeTable := #(
        "/ format is:
        "/ ( key1 key2 <character or asciiValue> )
        "/
        ($+ $+ $#)         "/ number-sign
        ($A $A $@)         "/ at-sign

        ($( $- ${)         "/ left curly brace
        ($- $( ${)         "/ left curly brace
        ($) $- $})         "/ right curly brace
        ($- $) $})         "/ right curly brace

        ($!! $!! 16rA1)      "/ !!-inverted       
        ($| $c 16rA2)      "/ cent-sign 
        ($c $| 16rA2)      "/ cent-sign 
        ($| $S $$)         "/ dollar-sign
        ($S $| $$)         "/ dollar-sign
        ($= $L 16rA3)      "/ pound-sign     
        ($L $= 16rA3)      "/ pound-sign     
        ($= $C 16rA4)      "/ euro-sign (In ISO-8859-15 alias Latin9 alias Latin0)    
        ($C $= 16rA4)      "/ euro-sign (In ISO-8859-15 alias Latin9 alias Latin0)    
        ($= $Y 16rA5)      "/ yen-sign                               
        ($Y $= 16rA5)      "/ yen-sign        
        ($| $| 16rA6)      "/ broken vertical bar
        ($!! $^ 16rA6)      "/ broken vertical bar
        ($^ $!! 16rA6)      "/ broken vertical bar
        ($!! $s 16rA7)      "/ section-sign    
        ($s $!! 16rA7)      "/ section-sign    
        ($" $" 16rA8)      "/ diaresis
        ($O $C 16rA9)      "/ copyright                        
        ($C $O 16rA9)      "/ copyright                        
        ($o $c 16rA9)      "/ copyright                        
        ($c $o 16rA9)      "/ copyright                        
        ($< $< 16rAB)      "/ french <<-quotes 
        ($- $, 16rAC)      "/ logical not       
        ($, $- 16rAC)      "/ logical not       
        ($O $R 16rAE)      "/ registered       
        ($R $O 16rAE)      "/ registered                   
        ($^ $0 16rB0)      "/ degree sign      
        ($+ $- 16rB1)      "/ plus-minus       
        ($- $+ 16rB1)      "/ plus-minus       
        ($^ $2 16rB2)      "/ superscript-2    
        ($^ $3 16rB3)      "/ superscript-3    
        ($/ $u 16rB5)      "/ greek mu                        
        ($u $/ 16rB5)      "/ greek mu                        
        ($!! $p 16rB6)      "/ paragraph sign                        
        ($p $!! 16rB6)      "/ paragraph sign   
        ($^ $. 16rB7)      "/ middle dot       
        ($^ $1 16rB9)      "/ superscript-1    
        ($> $> 16rBB)      "/ french >> quotes 
        ($1 $4 16rBC)      "/ 1/4              
        ($1 $2 16rBD)      "/ 1/2              
        ($3 $4 16rBE)      "/ 3/4                          
        ($? $? 16rBF)      "/ ?-inverted       
        ($- $: 16rF7)      "/ divide           
        ($: $- 16rF7)      "/ divide           
        ($x $x 16rD7)      "/ multiply           
        ($, $" 16r201E)    "/ german opening quote
        ($< $" 16r201C)    "/ german closing quote
"/        ($- $- $. 16r2013) "/ slightly longer dash (double length) 
"/        ($- $- $- 16r2013) "/ longer dash (fourfold length) 

        "/ diacriticals: Compose diacrit character
        "/ grave

        ($A $` 16rC0)      "/ A-`              
        ($a $` 16rE0)      "/ a-`              
        ($E $` 16rC8)      "/ E-`              
        ($e $` 16rE8)      "/ e-`              
        ($I $` 16rCC)      "/ I-`              
        ($i $` 16rEC)      "/ i-`              
        ($O $` 16rD2)      "/ O-`              
        ($o $` 16rF2)      "/ o-`              
        ($U $` 16rD9)      "/ U-`              
        ($u $` 16rF9)      "/ u-`              

        ($` $A 16rC0)      "/ `-A              
        ($` $a 16rE0)      "/ `-a              
        ($` $E 16rC8)      "/ `-E              
        ($` $e 16rE8)      "/ `-e              
        ($` $I 16rCC)      "/ `-I              
        ($` $i 16rEC)      "/ `-i              
        ($` $O 16rD2)      "/ `-O              
        ($` $o 16rF2)      "/ `-o              
        ($` $U 16rD9)      "/ `-U              
        ($` $u 16rF9)      "/ `-u

        "/ acute
        ($A $' 16rC1)      "/ A-'             
        ($a $' 16rE1)      "/ a-'             
        ($E $' 16rC9)      "/ E-'            
        ($e $' 16rE9)      "/ e-'           
        ($I $' 16rCD)      "/ I-'          
        ($i $' 16rED)      "/ i-'         
        ($O $' 16rD3)      "/ O-'        
        ($o $' 16rF3)      "/ o-'       
        ($U $' 16rDA)      "/ U-'      
        ($u $' 16rFA)      "/ u-'     
        ($Y $' 16rDD)      "/ Y-'    
        ($y $' 16rFD)      "/ y-'           

        ($' $A 16rC1)      "/ '-A             
        ($' $a 16rE1)      "/ '-a             
        ($' $E 16rC9)      "/ '-E            
        ($' $e 16rE9)      "/ '-e           
        ($' $I 16rCD)      "/ '-I          
        ($' $i 16rED)      "/ '-i         
        ($' $O 16rD3)      "/ '-O        
        ($' $o 16rF3)      "/ '-o       
        ($' $U 16rDA)      "/ '-U      
        ($' $u 16rFA)      "/ '-u     
        ($' $Y 16rDD)      "/ '-Y    
        ($' $y 16rFD)      "/ '-y   

        "/ circumflex
        ($A $^ 16rC2)      "/ A-^              
        ($a $^ 16rE2)      "/ a-^             
        ($E $^ 16rCA)      "/ E-^            
        ($e $^ 16rEA)      "/ e-^           
        ($I $^ 16rCE)      "/ I-^          
        ($i $^ 16rEE)      "/ i-^         
        ($O $^ 16rD4)      "/ O-^        
        ($o $^ 16rF4)      "/ o-^       
        ($U $^ 16rDB)      "/ U-^      
        ($u $^ 16rFB)      "/ u-^     

        ($^ $A 16rC2)      "/ ^-A              
        ($^ $a 16rE2)      "/ ^-a             
        ($^ $E 16rCA)      "/ ^-E            
        ($^ $e 16rEA)      "/ ^-e           
        ($^ $I 16rCE)      "/ ^-I          
        ($^ $i 16rEE)      "/ ^-i         
        ($^ $O 16rD4)      "/ ^-O        
        ($^ $o 16rF4)      "/ ^-o       
        ($^ $U 16rDB)      "/ ^-U      
        ($^ $u 16rFB)      "/ ^-u     

        "/ tilde
        ($A $~ 16rC3)      "/ A-~              
        ($a $~ 16rE3)      "/ a-~             
        ($O $~ 16rD5)      "/ O-~            
        ($o $~ 16rF5)      "/ o-~           
        ($N $~ 16rD1)      "/ N-~      
        ($n $~ 16rF1)      "/ n-~         

        ($~ $A 16rC3)      "/ ~-A              
        ($~ $a 16rE3)      "/ ~-a             
        ($~ $O 16rD5)      "/ ~-O            
        ($~ $o 16rF5)      "/ ~-o           
        ($~ $N 16rD1)      "/ ~-N      
        ($~ $n 16rF1)      "/ ~-n         

        "/ ring above
        ($a $* 16rE5)      "/ a-*              
        ($A $* 16rC5)      "/ A-*             

        ($* $a 16rE5)      "/ *-a              
        ($* $A 16rC5)      "/ *-A             

        "/ cedille
        ($C $, 16rC7)      "/ C-,              
        ($c $, 16rE7)      "/ c-,             

        ($, $C 16rC7)      "/ ,-C              
        ($, $c 16rE7)      "/ ,-c             

        "/ dieresis
        ($A $" 16rC4)      "/ A-"              
        ($a $" 16rE4)      "/ a-"             
        ($E $" 16rCB)      "/ E-"            
        ($e $" 16rEB)      "/ e-"           
        ($I $" 16rCF)      "/ I-"          
        ($i $" 16rEF)      "/ i-"         
        ($O $" 16rD6)      "/ O-"        
        ($o $" 16rF6)      "/ o-"       
        ($U $" 16rDC)      "/ U-"      
        ($u $" 16rFC)      "/ u-"     
        ($y $" 16rFF)      "/ y-"    
        ($Y $" 16r178)     "/ Y-"    

        ($" $A 16rC4)      "/ "-A             
        ($" $a 16rE4)      "/ "-a             
        ($" $E 16rCB)      "/ "-E            
        ($" $e 16rEB)      "/ "-e           
        ($" $I 16rCF)      "/ "-I          
        ($" $i 16rEF)      "/ "-i         
        ($" $O 16rD6)      "/ "-O        
        ($" $o 16rF6)      "/ "-o       
        ($" $U 16rDC)      "/ "-U      
        ($" $u 16rFC)      "/ "-u     
        ($" $y 16rFF)      "/ "-y    
        ($" $Y 16r178)     "/ Y-"    

        "/ slashed
        ($o $/ 16rF8)      "/ o-/        
        ($O $/ 16rD8)      "/ O-/    

        ($/ $o 16rF8)      "/ /-o                                     
        ($/ $O 16rD8)      "/ /-O  

        "/ ligatures
        ($s $s 16rDF)      "/ german sz        
        ($a $e 16rE6)      "/ (french) ae     
        ($A $E 16rC6)      "/ (french) AE

        "/ latin2 (much more needed here):                                        

        ($A $, 16r104)     "/ A-,
        ($a $, 16r105)     "/ a-,
        ($E $, 16r118)     "/ E-,
        ($e $, 16r119)     "/ e-,

        ($C $' 16r106)     "/ C-'
        ($c $' 16r107)     "/ c-'

        ($a $- 16r101)     "/ a--   (macron - line above)
        ($A $- 16r100)     "/ A--   (line above)
        ($E $- 16r112)     "/ E--   (line above)
        ($e $- 16r113)     "/ e--   (line above)

        ($D $- 16r110)     "/ D--   (strikeout)
        ($d $- 16r111)     "/ d--   (strikeout)

        ($C $. 16r10A)     "/ C-.   (dot above)
        ($c $. 16r10B)     "/ c-.   (dot above)
        ($E $. 16r116)     "/ E-.   (dot above)
        ($e $. 16r117)     "/ e-.   (dot above)
        ($G $. 16r120)     "/ G-.   (dot above)
        ($g $. 16r121)     "/ g-.   (dot above)
        ($I $. 16r130)     "/ I-.   (dot above)
        ($i $. 16r131)     "/ i-.   (missing dot above !!)
        ($Z $. 16r17B)     "/ z-.   (dot above)
        ($z $. 16r17C)     "/ z-.   (dot above)

        ($L $. 16r13F)     "/ L-.   (dot after)
        ($l $. 16r140)     "/ l-.   (dot after)

        ($C $^ 16r108)     "/ C-^   (circonflex above)
        ($c $^ 16r109)     "/ c-^
        ($G $^ 16r11C)     "/ G-^   
        ($g $^ 16r11D)     "/ g-^                                
        ($H $^ 16r124)     "/ H-^                                     
        ($h $^ 16r125)     "/ h-^
        ($J $^ 16r134)     "/ J-^   
        ($j $^ 16r135)     "/ j-^
        ($S $^ 16r15C)     "/ S-^ 
        ($s $^ 16r15D)     "/ s-^

        ($A $u 16r102)     "/ A-u    breve
        ($a $u 16r103)     "/ a-u  
        ($E $u 16r114)     "/ E-u  
        ($e $u 16r115)     "/ e-u  
        ($G $u 16r11E)     "/ G-u  
        ($g $u 16r11F)     "/ g-u  
        ($I $u 16r12C)     "/ I-u  
        ($i $u 16r12D)     "/ i-u  
        ($L $u 16r13D)     "/ L-u  
        ($l $u 16r13E)     "/ l-u  
        ($O $u 16r14E)     "/ O-u  
        ($o $u 16r14F)     "/ o-u  
        ($R $u 16r158)     "/ R-u  
        ($r $u 16r159)     "/ r-u  
        ($T $u 16r164)     "/ T-u  
        ($t $u 16r165)     "/ t-u  
        ($U $u 16r16C)     "/ U-u  
        ($u $u 16r16D)     "/ u-u  
        ($Z $u 16r17D)     "/ Z-u  
        ($z $u 16r17E)     "/ z-u  

        ($A $v 16r1CD)     "/ A-v   caron 
        ($a $v 16r1CE)     "/ a-v  
        ($C $v 16r10C)     "/ C-v  
        ($c $v 16r10D)     "/ c-v  
        ($D $v 16r10E)     "/ D-v  
        ($d $v 16r10F)     "/ d-v  
        ($E $v 16r11A)     "/ E-v  
        ($e $v 16r11B)     "/ e-v  
        ($G $v 16r1E6)     "/ G-v  
        ($g $v 16r1E7)     "/ g-v  
        ($I $v 16r1CF)     "/ I-v  
        ($i $v 16r1D0)     "/ i-v  
        ($K $v 16r1E8)     "/ K-v  
        ($k $v 16r1E9)     "/ k-v  
        ($L $v 16r13D)     "/ L-v  
        ($l $v 16r13E)     "/ l-v  
        ($N $v 16r147)     "/ N-v  
        ($n $v 16r148)     "/ n-v  
        ($O $v 16r1D1)     "/ O-v  
        ($o $v 16r1D2)     "/ o-v  
        ($R $v 16r158)     "/ R-v  
        ($r $v 16r159)     "/ r-v  
        ($S $v 16r160)     "/ S-v  
        ($s $v 16r161)     "/ s-v  
        ($T $v 16r164)     "/ T-v  
        ($t $v 16r165)     "/ t-v  
        ($U $v 16r1D3)     "/ U-v  
        ($u $v 16r1D4)     "/ u-v  
        ($Z $v 16r17D)     "/ Z-v  
        ($z $v 16r17E)     "/ z-v  

        ($O $E 16r152)      "/ (french) OE
        ($o $e 16r153)      "/ (french) oe     

        ($L $J 16r1C7)      "/ (dutch) LJ     
        ($L $j 16r1C8)      "/ (dutch) Lj     
        ($l $j 16r1C9)      "/ (dutch) lj

        ($N $J 16r1CA)      "/  NJ     
        ($N $j 16r1CB)      "/  Nj     
        ($n $j 16r1CC)      "/  nj
    ).

    ComposeTable := ComposeTable 
                        collect:[:eachRow | 
                            eachRow collect:[:charOrCode | charOrCode asCharacter]].

    "                                   
     WindowSensor initializeComposeKeyTable              
    "                    

    "Created: 22.4.1996 / 14:06:43 / cg"
    "Modified: 24.4.1996 / 16:37:08 / cg"
!

mouseWheelScale
    "if set, mouse wheel motions are scaled by this number"

    ^ MouseWheelScale ? 1
!

mouseWheelScale:aNumber
    "if set, mouse wheel motions are scaled by this number"

    MouseWheelScale := aNumber
!

mouseWheelThreshold
    "if set, mouse wheel motions are only reported if the scaled amount is above this"

    ^ 10 / MouseWheelScale
! !

!WindowSensor class methodsFor:'instance creation'!

new
    "return a new initialized instance"

    ^ self basicNew initialize

    "Modified: 22.4.1996 / 16:19:40 / cg"
! !

!WindowSensor class methodsFor:'accessing'!

addEventListener:aListener
    "add a global eventListener (with new protocol - #handleEvent:)
     This one gets a chance to intercept all events for ANY sensor
     (i.e. any view on any device).
     - see documentation for what this can be used for"

    EventListeners isNil ifTrue:[
        EventListeners := OrderedCollection new:2
    ].
    (EventListeners includesIdentical:aListener) ifFalse:[
        EventListeners add:aListener
    ]
!

composeTable
    "return the compose-key table.
     Entries consist of 3-element arrays each, where
     the first two entries (of each entry) are the raw characters,
     and the third is the resulting composed-key"

    ^ ComposeTable
!

composeTable:aTable
    "set the compose-key table.
     Entries consist of 3-element arrays each, where
     the first two entries (of each entry) are the raw characters,
     and the third is the resulting composed-key"

    ComposeTable := aTable
!

controlCEnabled:aBoolean
    "enable/disable Control-C processing. 
     If enabled, pressing CNTL-C in a view will interrupt it and bring
     its process into the debugger (actually raising a UserInterrupt signal).
     Otherwise, CNTL-C is sent to the view like any other key.
     The default is true (enabled).
     Be very careful - only disable CNTL-C handling for well-debugged
     applications ... however, even if disabled, there still is the CNTL-C
     key on the startup (x)-terminal window (which can also be disabled).
    "

    ControlCEnabled := aBoolean

    "Modified: / 29.10.1997 / 15:48:29 / cg"
!

controlPeriodEnabled:aBoolean
    "enable/disable Control-. processing. 
     If enabled, pressing CNTL-. is handled like UserInterrupt and will usually interrupt it.
     Notice, that this flag only controls the translation of CTRL-. to CTRL-C;
     UserInterrupts may still be disabled by other flags.
    "

    ControlPeriodEnabled := aBoolean

    "Modified: / 29.10.1997 / 15:48:29 / cg"
!

eventListeners
    ^ EventListeners 
!

removeEventListener:aListener
    "remove a global eventListener (with new protocol - #handleEvent:)
     - see documentation for what this can be used for"

    EventListeners notNil ifTrue:[
        EventListeners removeIdentical:aListener ifAbsent:nil.
        EventListeners := EventListeners asNilIfEmpty.
    ].
! !

!WindowSensor class methodsFor:'event processing'!

postViewCreateNotification:aView
    "invoked right before a new view is created.
     Notify listeners and allow for the origin/extent to be
     changed. (For example, recorder/playback applications may
     want to make certain that the playback view is at the same
     position - or record any origin changes to translate later
     synthetic events)."

    | ev|

"/    "/ backward compatibility ... will vanish
"/    EventListener notNil ifTrue:[
"/        EventListener postCreateView:aView.
"/    ].
"/
    "/ new protocol
    EventListeners size > 0 ifTrue:[
        ev := WindowEvent postViewCreateNotification:aView.
        EventListeners copy do:[:aListener |
            aListener processEvent:ev
        ]
    ].

    "Modified: / 29-06-2011 / 18:56:05 / cg"
!

preViewCreateNotification:aView
    "invoked right before a new view is created.
     Notify listeners and allow for the origin/extent to be
     changed. (For example, recorder/playback applications may
     want to make certain that the playback view is at the same
     position - or record any origin changes to translate later
     synthetic events)."

    |ret ev|

"/    "/ backward compatibility ... will vanish
"/    EventListener notNil ifTrue:[
"/        ret := EventListener preCreateView:aView origin:aView origin.
"/        ret isPoint ifTrue:[
"/            aView setOrigin:ret
"/        ]
"/    ].
"/
    "/ new protocol
    EventListeners size > 0 ifTrue:[
        ev := WindowEvent preViewCreateNotification:aView.
        EventListeners copy do:[:aListener |
            aListener processEvent:ev
        ]
    ].

    "Modified: / 29-06-2011 / 18:54:57 / cg"
! !

!WindowSensor class methodsFor:'queries'!

cursorPoint
    "ST-80 compatibility: 
     return the position of the cursor on the current display."

    ^ Screen current pointerPosition

    "
     WindowSensor cursorPoint
    "
! !

!WindowSensor methodsFor:'Compatibility-ST80'!

blueButtonPressed
    "ST-80 compatibility: return true, if the right mouse button is pressed.
     You should no use it in 'normal' applications.
     Instead, keep track of the buttons state in your views or controllers
     button-event methods."

    ^ rightButtonDown
!

eventQuit:event
    "ST-80 compatibility:
     push an event for terminating the topViews application"

    ^ self pushEvent:(WindowEvent
                             for:nil
                             type:#quit)

    "Modified: 3.3.1997 / 20:15:00 / cg"
!

redButtonPressed
    "ST-80 compatibility: return true, if the left mouse button is pressed.
     You should no use it in 'normal' applications.
     Instead, keep track of the buttons state in your views or controllers
     button-event methods."

    ^ leftButtonDown
!

yellowButtonPressed
    "ST-80 compatibility: return true, if the middle mouse button is pressed.
     You should no use it in 'normal' applications.
     Instead, keep track of the buttons state in your views or controllers
     button-event methods."

    ^ middleButtonDown
! !

!WindowSensor methodsFor:'accessing'!

addEventListener:aListener
    "add a local eventListener (with new protocol - #processEvent:)
     This one gets a chance to intercept all events for this sensor
     (i.e. for this windowGroup).
     - see documentation for what this can be used for"

    eventListeners isNil ifTrue:[
        eventListeners := OrderedCollection new:2
    ].
    (eventListeners includesIdentical:aListener) ifFalse:[
        eventListeners add:aListener
    ]
!

compressMotionEvents:aBoolean
    "turn on/off motion event compression.
     Normally, motion event compression is enabled; however, 
     applications which want to follow every motion 
     (i.e. paint-like applications) may want to get them all)"

    compressMotionEvents := aBoolean

    "Modified: / 6.6.1998 / 21:12:57 / cg"
!

eventSemaphore
    "return the semaphore used to signal event arrival"

    ^ eventSemaphore
!

eventSemaphore:aSemaphore
    "set the semaphore used to signal event arrival"

    eventSemaphore := aSemaphore
!

ignoreExposeEvents:aBoolean
    "turn on/off expose event ignoring"

    ignoreExposeEvents := aBoolean

    "Created: / 21.5.1996 / 18:21:18 / cg"
    "Modified: / 6.6.1998 / 21:13:14 / cg"
!

ignoreUserInput
    "return true, if user events are currently ignored"

    ^ ignoreUserInput

    "Modified: / 6.6.1998 / 21:13:50 / cg"
!

ignoreUserInput:aBoolean
    "turn on/off ignoring of user events processing.
     This can be used to avoid having events queued for a master-view,
     while a modal dialog is open for it."

    ignoreUserInput := aBoolean

    "Modified: / 6.6.1998 / 21:14:25 / cg"
!

removeAllEventListeners
    "remove all local eventListeners"

    eventListeners := nil
!

removeEventListener:aListener
    "remove a local eventListener (with new protocol - #processEvent:)
     - see documentation for what this can be used for"

    eventListeners notNil ifTrue:[
        eventListeners removeIdentical:aListener ifAbsent:nil
    ].


! !

!WindowSensor methodsFor:'accessing-private'!

criticalDamageEventQueueAccess:aBlock
    "perform some action which needs synchronized (exclusive)
     access to the damage event queue. 
     (i.e. protected by a critical region)"

    self criticalEventQueueAccess:damageEventAccessLock do:aBlock.
!

criticalEventQueueAccess:whichLock do:aBlock
    "perform some action which needs synchronized (exclusive)
     access to one of the event queues. 
     (i.e. protected by a critical region)"

    |wasBlocked p|

    p := Processor activeProcess.
    wasBlocked := p blockInterrupts.

    [
        whichLock critical:aBlock
    ] on:Error do:[:ex|
        ('WindowSensor [Warning]: Error in eventQ handling ignored: ' , ex description) errorPrintCR.
        "/ thisContext fullPrintAll.
        "/ whichLock printCR.
        ex return.
    ] ensure:[
        wasBlocked ifFalse:[
            p unblockInterrupts.
        ]
    ]

    "Created: / 06-06-1998 / 21:04:02 / cg"
    "Modified: / 14-10-1998 / 17:17:05 / cg"
    "Modified: / 31-01-2017 / 16:53:08 / stefan"
!

criticalUserEventQueueAccess:aBlock
    "perform some action which needs synchronized (exclusive)
     access to the user event queue. 
     (i.e. protected by a critical region)"

    self criticalEventQueueAccess:userEventAccessLock do:aBlock.
!

damageEventAccessLock
    "return the semaphore which controls access to the damage event queue.
     This should probably not be exposed to the public,
     so be prepared that this method may vanish."

    ^ damageEventAccessLock

    "Created: / 6.6.1998 / 21:06:14 / cg"
    "Modified: / 6.6.1998 / 21:16:49 / cg"
!

userEventAccessLock
    "return the semaphore which controls access to the mouse and keyboard event queue.
     This should probably not be exposed to the public,
     so be prepared that this method may vanish."

    ^ userEventAccessLock

    "Created: / 6.6.1998 / 21:05:56 / cg"
    "Modified: / 6.6.1998 / 21:16:57 / cg"
! !

!WindowSensor methodsFor:'event flushing'!

compressKeyPressEventsWithKey:aKey
    "count and remove multiple pending keyPress events for the
     same key, aKey. This is currently used in TextViews to compress
     multiple cursorUp/cursorDown events and do the scroll in one
     operation. (to avoid run-after-cursor on slow displays)"

    |n ev evKey|

    n := 0.
    ev := self pendingEvent.

    [ev notNil and:[ev isKeyEvent]] whileTrue:[
        evKey := ev key.
        (evKey == aKey) ifTrue:[
            ev isKeyReleaseEvent ifFalse:[
                n := n + 1.
            ].
            self nextEvent.
            ev := self pendingEvent.
        ] ifFalse:[
            ev := nil
        ]
    ].
    ^ n

    "Modified: / 27.1.1998 / 14:15:00 / cg"
!

flushAllEvents
    damage := OrderedCollection new.
    mouseAndKeyboard := OrderedCollection new.
!

flushButtonEventsFor:aView
    "throw away all pending mouse button events for aView, 
     or any view, if the argument is nil." 

    self
        flushEventsFor:aView inQueue:mouseAndKeyboard 
        where:[:event | event isButtonEvent]
!

flushEventsFor:aView
    "throw away all events for aView, 
     or any view, if the argument is nil."

    self flushExposeEventsFor:aView.
    self flushUserEventsFor:aView.
!

flushEventsFor:aViewOrNil inQueue:anEventQueue where:aCondition
    "throw away all pending damage events for aView, 
     for which aCondition returns true.
     Or any view for which aCondition returns true, if the argument is nil. 
     A helper for the various flush entries.
     Returns the last flushed event or nil."

    |lastFlushed whichLock|

    anEventQueue isNil ifTrue:[^ nil].

    whichLock := (anEventQueue == damage) ifTrue:[damageEventAccessLock] ifFalse:[userEventAccessLock].
    self 
        criticalEventQueueAccess:whichLock 
        do:[
            |nEvent "{ Class: SmallInteger }" 
             anEvent
             queue|

            queue := anEventQueue.
            nEvent := queue size.
            1 to:nEvent do:[:index |
                anEvent := queue at:index.
                anEvent notNil ifTrue:[
                    (aViewOrNil isNil or:[anEvent view == aViewOrNil]) ifTrue:[
                        (aCondition value:anEvent) ifTrue:[
                            lastFlushed := anEvent.
                            queue at:index put:nil.
                            anEvent isDamage ifTrue:[ anEvent view updateRegion:nil ].
                        ]
                    ]
                ]
            ].
        ].
    ^ lastFlushed

    "Modified: / 6.6.1998 / 21:10:22 / cg"
    "Created: / 6.6.1998 / 21:17:54 / cg"
!

flushEventsFor:aViewOrNil where:aBlock
    "throw away all events for aView, for which aBlock evaluates to true 
     or any view, if the argument is nil."

    self flushEventsFor:aViewOrNil inQueue:damage           where:aBlock.
    self flushEventsFor:aViewOrNil inQueue:mouseAndKeyboard where:aBlock.

    "Created: / 12.11.2001 / 19:27:07 / cg"
!

flushEventsFor:aViewOrNil withType:type
    "throw away all events for aView, 
     (or any view, if the argument is nil) which have a particular type."

    self flushEventsFor:aViewOrNil inQueue:damage where:[:event | event type==type].
    self flushEventsFor:aViewOrNil inQueue:mouseAndKeyboard where:[:event | event type==type].

    "Created: / 20.6.1998 / 16:41:35 / cg"
    "Modified: / 21.7.1998 / 18:16:11 / cg"
!

flushExposeEvents
    "throw away all pending expose events; this
     can be done after a full redraw (or in views, which are
     doing full redraws anly)"

    self flushEventsFor:nil inQueue:damage where:[:event | event isDamage].

    "Modified: / 6.6.1998 / 21:18:03 / cg"
!

flushExposeEventsFor:aView
    "throw away all pending expose events for aView, 
     or any view, if the argument is nil. 
     This can be done after a full redraw 
     (or in views, which are always doing full redraws -
      instead of drawing the clip-area only)"

    self flushEventsFor:aView inQueue:damage where:[:event | event isDamage].

    "Modified: / 6.6.1998 / 21:18:05 / cg"
!

flushKeyboard
    "ST-80 compatibility: throw away all pending keyboard events"

    self flushKeyboardFor:nil
!

flushKeyboardFor:aView
    "throw away all pending keyboard events for aView, 
     or any view, if the argument is nil." 

    self
        flushEventsFor:aView inQueue:mouseAndKeyboard 
        where:[:event | event isKeyEvent]

    "Modified: / 6.6.1998 / 21:18:08 / cg"
!

flushMotionEventsFor:aView
    "throw away all pending motion events for aView, 
     or for any view, if the argument is nil." 

    self
        flushEventsFor:aView inQueue:mouseAndKeyboard 
        where:[:event | event isButtonMotionEvent]

    "Modified: / 6.6.1998 / 21:18:10 / cg"
!

flushUserEvents
    "throw away all pending user events (i.e. key & button stuff)"

    self flushUserEventsFor:nil

    "Modified: / 20.6.1998 / 16:40:02 / cg"
!

flushUserEventsFor:aView
    "throw away all pending user events for aView (i.e. key & button stuff), 
     or for any view, if the argument is nil." 

    self
        flushEventsFor:aView inQueue:mouseAndKeyboard 
        where:[:event | event isUserEvent]

    "Modified: / 20.6.1998 / 16:40:09 / cg"
!

flushUserEventsFor:aView where:aBlock

    "throw away all pending user events (i.e. key & button stuff)
     for which aBlock returns true.
     For aView or for any view, if the argument is nil." 

    self
        flushEventsFor:aView inQueue:mouseAndKeyboard 
        where:aBlock
!

flushUserEventsFor:aView withType:type
    "throw away all pending user events with specified type for aView (i.e. key & button stuff), 
     or for any view, if the argument is nil." 

    self
        flushEventsFor:aView inQueue:mouseAndKeyboard 
        where:[:event | event type==type]

    "Modified: / 20.6.1998 / 16:40:09 / cg"
!

flushUserEventsFor:aView withType:type withArguments:args

    "throw away all pending user events with specified type for aView (i.e. key & button stuff), 
     or for any view, if the argument is nil." 

    self
        flushEventsFor:aView inQueue:mouseAndKeyboard 
        where:[:event | (type == event type)
                        and:[args = event arguments]]

    "Modified: / 20.6.1998 / 16:40:09 / cg"
!

lastMotionEventFor:aView
    "throw away all pending motion events for aView, 
     or for any view, if the argument is nil.
     Returns the very last (valid) motion event." 

    ^ self
        flushEventsFor:aView inQueue:mouseAndKeyboard 
        where:[:event | event isButtonMotionEvent]

    "Modified: / 6.6.1998 / 21:18:10 / cg"
! !

!WindowSensor methodsFor:'event processing'!

buttonMotion:buttonAndModifierState x:x y:y view:aView
    "mouse was moved - this is sent from the device (Display)"

    |ev ignoreIt buttonState|

    "/ update my idea of button and modifier state information
    self updateModifierStateFrom:buttonAndModifierState device:(aView graphicsDevice).

    "/ however, in the following, we are only interested in the buttons (i.e. mask out the modifiers)
    buttonState := buttonAndModifierState bitAnd:(aView device anyButtonStateMask).

    ignoreUserInput == true ifTrue:[
        ^ self
    ].

    compressMotionEvents ifTrue:[
        "
         merge with last motion
        "
        self criticalUserEventQueueAccess:[
            |idx args|

            idx := mouseAndKeyboard size.
            [idx > 0] whileTrue:[
                ev := mouseAndKeyboard at:idx.
                ev notNil ifTrue:[
                    ((ev type == #buttonMotion:x:y:) 
                    and:[(ev view == aView)
                    and:[(ev arguments at:1) == buttonState]]) ifTrue:[
                        "/ TODO: provide accessor in buttonMotionEvent
                        args isNil ifTrue:[
                            args := Array with:buttonState with:x with:y.
                        ].
                        ev arguments:args.
                        idx := 0.
                        ignoreIt := true
                    ]
                ].
                idx := idx - 1.
            ].
        ].
        ignoreIt == true ifTrue:[
            ^ self
        ]
    ].

    ev := WindowEvent buttonMotion:buttonState x:x y:y view:aView.
    ev hasShift:shiftDown ctrl:ctrlDown alt:altDown meta:metaDown
       button1:leftButtonDown button2:middleButtonDown button3:rightButtonDown.

    "/ any eventListener
    "/ (self notifyEventListenersAbout:ev) ifTrue:[^ self].
    self pushEvent:ev.

    "Modified: / 29-06-2011 / 18:45:59 / cg"
!

buttonMultiPress:button x:x y:y view:aView
    "mouse button was pressed - this is sent from the device (Display)"

    |ev|

    self button:button inView:aView state:true.

    ignoreUserInput == true ifTrue:[
        ^ self
    ].

    ev := WindowEvent buttonMultiPress:button x:x y:y view:aView.
    ev hasShift:shiftDown ctrl:ctrlDown alt:altDown meta:metaDown
       button1:leftButtonDown button2:middleButtonDown button3:rightButtonDown.

    "/ any eventListener
    "/ (self notifyEventListenersAbout:ev) ifTrue:[^ self].
    self pushEvent:ev.

    "Modified: / 29-06-2011 / 18:46:03 / cg"
!

buttonPress:button x:x y:y view:aView
    "mouse button was pressed - this is sent from the device (Display)"

    |ev|

    self button:button inView:aView state:true.

    ignoreUserInput == true ifTrue:[
        ^ self
    ].

    ev := WindowEvent buttonPress:button x:x y:y view:aView.
    ev hasShift:shiftDown ctrl:ctrlDown alt:altDown meta:metaDown
       button1:leftButtonDown button2:middleButtonDown button3:rightButtonDown.

    "/ any eventListener
    "/ (self notifyEventListenersAbout:ev) ifTrue:[^ self].
    self pushEvent:ev.

    "Modified: / 29-06-2011 / 18:46:07 / cg"
!

buttonRelease:button x:x y:y view:aView
    "mouse button was released- this is sent from the device (Display)"

    |ev|

    self button:button inView:aView state:false.

    ignoreUserInput == true ifTrue:[
        ^ self
    ].

    ev := WindowEvent buttonRelease:button x:x y:y view:aView.
    ev hasShift:shiftDown ctrl:ctrlDown alt:altDown meta:metaDown
       button1:leftButtonDown button2:middleButtonDown button3:rightButtonDown.

    "/ any eventListener
    "/ (self notifyEventListenersAbout:ev) ifTrue:[^ self].
    self pushEvent:ev.

    "Modified: / 29-06-2011 / 18:46:11 / cg"
!

clientMessage:type format:format eventData:data view:aView
    "some other process has sent data to a view.
     This is an X-specific event. (see copyDataEvent for win32 variant)"

    self pushEvent:(WindowEvent clientMessageEvent:type format:format eventData:data view:aView).

    "Created: / 4.4.1997 / 17:51:08 / cg"
    "Modified: / 21.5.1999 / 19:46:43 / cg"
!

configureX:x y:y width:w height:h view:aView
    "a views size or position has changed - this is sent from the device (Display)"

    aView superView notNil ifTrue:[
        "/ this is a configure event for a subView
        "/ I guess, this resulted from a resize of
        "/ myself (are there any windowManagers which resize subviews ?)
        "/ Therefore, ignore it here.
        "/ This also fixed problems due to late-arriving configure events,
        "/ in case of a resized view, which was resized before.
        "/ Without the return below, we need a flushConfigureEvents entry here,
        "/ to be invoked whenever a subview is resized / repositioned.

        "/ A kludge-workaround had to be added to children of
        "/ external top views - since the external view does not get any
        "/ events delivered, we must react upon changes of the
        "/ child. (sigh).
        aView superView isExternalTopView ifFalse:[
"/            'ignored configure for: ' print. aView class printCR.
            ^ self
        ]
    ].

    "/
    "/ remove any old configure event (WIN32 speedup)
    "/
    damage size ~~ 0 ifTrue:[
        damage keysAndValuesDo:[:idx :aDamage |
            (aDamage notNil 
            and:[aDamage type == #configureX:y:width:height:
            and:[aDamage view == aView]]) ifTrue:[
                damage at:idx put:nil.
            ].
        ]
    ].

    self pushDamageEvent:(WindowEvent configureX:x y:y width:w height:h view:aView).

    "Modified: / 29.4.1999 / 10:06:47 / cg"
!

copyDataEvent:parameter eventData:data view:aView
    "some other process has sent data to a view.
     This is a Win32-specific event. (see clientMessage for x-windows variant)"

    self pushEvent:(WindowEvent copyDataEvent:parameter eventData:data view:aView).
!

coveredBy:coveringSiblingView view:coveredView
    "aView was covered by one of its siblings - this is sent from the device (Display)"

    self pushDamageEvent:(WindowEvent coveredBy:coveringSiblingView view:coveredView)

    "Modified: 18.1.1997 / 14:18:32 / cg"
!

createWindow:view x:x y:y width:w height:h    
    "A window has been created in a view.
     This is a synthetic event, useful for some event recorders"

    self pushEvent:(WindowEvent createWindow:view x:x y:y width:w height:h).

    "Created: / 30-05-2011 / 19:01:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-06-2011 / 12:50:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-06-2011 / 18:46:15 / cg"
!

destroyedView:aView
    "view was destroyed (from window manager) - this is sent from the device (Display)"

    "at this time, the view is already gone; remove
     all pending events for this one ..."

    self flushEventsFor:aView.
    self pushDamageEvent:(WindowEvent destroyedView:aView).

    "Modified: 18.1.1997 / 14:18:19 / cg"
!

dropFiles:files view:view position:dropPositionOrNil handle:dropHandleOrNil
    self pushEvent:(WindowEvent dropFiles:files view:view position:dropPositionOrNil handle:dropHandleOrNil)
!

dropMessage:dropType data:dropValue view:targetView position:dropPositionOrNil handle:dropHandleOrNil
    self pushEvent:(WindowEvent dropMessage:dropType data:dropValue view:targetView position:dropPositionOrNil handle:dropHandleOrNil)
!

exposeX:left y:top width:width height:height view:aView
    "an expose event arrived - this is sent from the device (Display)"

    ignoreExposeEvents == true ifTrue:[
        'ignored expose' infoPrintCR.
        ^ self.
    ].
    self 
        addDamage:(Rectangle left:left top:top width:width height:height) 
        view:aView
        wakeup:true.

    "Modified: / 29-06-2011 / 18:29:47 / cg"
!

focusInView:aView
    "view got input focus - this is sent from the device (Display)"

    self pushEvent:(WindowEvent focusInView:aView).

    "Modified: / 29-06-2011 / 18:46:18 / cg"
!

focusOutView:aView
    "view lost input focus - this is sent from the device (Display)"

    self pushEvent:(WindowEvent focusOutView:aView).

    "Modified: / 29-06-2011 / 18:46:21 / cg"
!

graphicsExposeX:left y:top width:width height:height final:final view:aView
    "a graphic expose event arrived - this is sent from the device (Display)"

    "/ this is also a possible response to a scroll operation
    "/ (if an expose is pending)

    self addDamage:(Rectangle left:left top:top width:width height:height) view:aView wakeup:false.
    final ifTrue:[
        (catchExpose includes:aView) ifTrue:[
            gotExpose add:aView.
            exposeEventSemaphore notNil ifTrue:[
                exposeEventSemaphore signalForAll
            ]
        ] ifFalse:[
            'WSensor [warning]: got exposeEvent for non-catching view:' infoPrint. aView infoPrintCR
        ]
    ].

    "Modified: / 14.12.1999 / 20:55:38 / cg"
!

hotkeyWithId:aHotkeyId key:aKey view:aView
    "hotkey was pressed - this is sent from the device (Display)."

    |ev|

    ev := WindowEvent 
            hotkeyWithId:aHotkeyId
            rawKey:aKey
              view:aView.

    self pushEvent:ev.

    "Modified: / 04-10-2011 / 19:34:46 / cg"
!

keyPress:key x:x y:y view:aView
    "key was pressed - this is sent from the device (Display).
     beside the keyboard translation, CntlC processing is done here."

    <resource: #keyboard ( #Compose #DestroyView #DestroyTopView #FlushInput
                           #UserInterrupt #UserAbort #'CTRL.') >

    |xlatedKey keyWithModifier group process ev device|

    device := aView graphicsDevice.

    self key:key state:true. 
    "/ 'key: ' print. key storeString printCR.    

    "/ bail out of a popUpView with ctrl-shift-escape
    "/ (useful to avoid total lock of system with non-functioning grabbing popUpView)
    (key = #Escape) ifTrue:[
        (ctrlDown and:[shiftDown]) ifTrue:[
            device ungrabPointer.
            device ungrabKeyboard.
            ^ self
        ]
    ].

    keyWithModifier := device prependModifierToKey:key.

    translateKeyboardEvents ifTrue:[
        xlatedKey := device translateKey:key forView:aView.
    ] ifFalse:[
        xlatedKey := key.
    ].
    "/ xlatedKey printCR.

    "/ 'key: ' print. key storeString printCR.
    "/ 'xlatedKey: ' print. xlatedKey storeString printCR.    
    "/ 'keyWithModifier: ' print. keyWithModifier storeString printCR.    

    xlatedKey isNil ifTrue:[^ self].

    "/ a special hook, allowing a screen hardCopy.
    xlatedKey == #Hardcopy ifTrue:[
        (Transcript notNil and:[Transcript isStream not]) ifTrue:[
            [
                Transcript topView application
                    saveScreenImage:(Image fromView:(aView topView) "inset:0" grab:true) defaultName:'hardcopy'.
            ] forkAt:Processor userSchedulingPriority + 1.
        ].
        ^ self.
    ].

    (xlatedKey == #Compose) ifTrue:[
        gotCompose := true. compose1 := nil.
        ^ self
    ].
    gotCompose == true ifTrue:[
        compose1 isNil ifTrue:[
            (self isModifierKey:xlatedKey) ifFalse:[
                compose1 := xlatedKey. 
            ].
            ^ self
        ].
        (self isModifierKey:xlatedKey) ifFalse:[
            xlatedKey  := self compose:compose1 with:xlatedKey.
            compose1 := nil. gotCompose := false.
        ].
    ].

    (xlatedKey == #CmdCtrlV) ifTrue:[
        'Smalltalk/X ' errorPrint. 
        Smalltalk versionString errorPrint. ' of ' errorPrint.
        Smalltalk versionDate errorPrintCR.
        Smalltalk copyrightString errorPrintCR.
    ].

    (xlatedKey == #DestroyView) ifTrue:[
        aView closeRequest.
    ].
    (xlatedKey == #DestroyTopView) ifTrue:[
        aView topView closeRequest.
    ].

    (xlatedKey == #FlushInput) ifTrue:[
        "this removes any enqueued user events -
         helps, if you pressed DoIt too often, and want to flush those
        "
        self flushUserEvents.
        ^ self
    ].
    (ControlPeriodEnabled and:[ xlatedKey == #'Ctrl.']) ifTrue:[ xlatedKey := #UserInterrupt ].

    (((xlatedKey == #UserInterrupt) and:[ControlCEnabled])
    or:[((xlatedKey == #UserAbort) and:[ControlYEnabled])]) ifTrue:[
        "
         Special handling for 
            Ctrl-C: interrupt the underlying process.
         and:
            Ctrl-Y: raise abortSignal the underlying process.

         cannot halt here (this would stop the event-dispatcher),
         but instead interrupt the underlying process and have it
         perform the userInterrupt in the interrupt-method.
        "
        group := aView windowGroup.
        group notNil ifTrue:[
            process := group process.
            process isNil ifTrue:[
                process := group creatingProcess
            ].
            process notNil ifTrue:[
                (xlatedKey == #UserAbort) ifTrue:[
                    process interruptWith:[:where | AbortOperationRequest raise]
                ] ifFalse:[
                    process interruptWith:[:where | process userInterruptIn:where from:aView]
                ]
            ]
        ].
        ^ self
    ].

    ignoreUserInput == true ifTrue:[
        ^ self
    ].

    "/ 'shift: ' print. shiftDown printCR.
    "/ 'ctrl: ' print. ctrlDown printCR.
    ev := WindowEvent 
            keyPress:xlatedKey
            rawKey:keyWithModifier
            hasShift:shiftDown ctrl:ctrlDown alt:altDown meta:metaDown
            button1:leftButtonDown button2:middleButtonDown button3:rightButtonDown
            x:x y:y view:aView.

    "/ any eventListener
    "/ (self notifyEventListenersAbout:ev) ifTrue:[^ self].
    self pushEvent:ev.

    "Modified: / 04-10-2011 / 19:34:46 / cg"
!

keyRelease:key x:x y:y view:aView
    "key was released - this is sent from the device (Display)."

    |xlatedKey ev|

    self key:key state:false. 

    ignoreUserInput == true ifTrue:[
        ^ self
    ].
    translateKeyboardEvents ifTrue:[
        xlatedKey := aView graphicsDevice translateKey:key forView:aView.
    ] ifFalse:[
        xlatedKey := key.
    ].
    xlatedKey isNil ifTrue:[^ self].

    ev := WindowEvent
            keyRelease:xlatedKey
            rawKey:key
            hasShift:shiftDown ctrl:ctrlDown alt:altDown meta:metaDown
            button1:leftButtonDown button2:middleButtonDown button3:rightButtonDown
            x:x y:y view:aView.

    "/ any eventListener
    "/ (self notifyEventListenersAbout:ev) ifTrue:[^ self].
    self pushEvent:ev.

    "Modified: / 29-06-2011 / 18:46:46 / cg"
!

mappedView:aView
    "view was mapped (from window manager) - this is sent from the device (Display)"

    self flushExposeEventsFor:aView.
    self pushDamageEvent:(WindowEvent mappedView:aView).
!

mouseWheelMotion:state x:x y:y amount:amount deltaTime:dTime view:aView
    "mouse-wheel was turned - this is sent from the device (Display)"

    |ev affectedView windowGroup|

    "/ update my idea of button and modifier state information
    self updateModifierStateFrom:state device:(aView graphicsDevice).

    ignoreUserInput == true ifTrue:[
        ^ self
    ].

    "Do we really want the focusView here?
     We currently do it, because a unexpected (wrong) view may scroll, 
     when the mouse is over a scrollbar!! But horizontal scrolling on
     horizontal scrollbars does not work"

"/    windowGroup := aView windowGroup.
"/    windowGroup notNil ifTrue:[
"/        affectedView := windowGroup focusView.
"/    ].
    affectedView isNil ifTrue:[
        affectedView := aView
    ].

    ev := WindowEvent mouseWheelMotion:state x:x y:y amount:amount deltaTime:dTime view:affectedView.
    ev hasShift:shiftDown ctrl:ctrlDown alt:altDown meta:metaDown
       button1:leftButtonDown button2:middleButtonDown button3:rightButtonDown.

    "/ any eventListener
    "/ (self notifyEventListenersAbout:ev) ifTrue:[^ self].
    self pushEvent:ev.

    "Created: / 21-05-1999 / 13:05:18 / cg"
    "Modified: / 29-06-2011 / 18:46:54 / cg"
!

nativeWidgetCommand:command arguments:argVector view:aView
    "native widget action - this is sent from the device (Display).
     These are only delivered if native widgets are enabled under win32"

    self pushEvent:(WindowEvent nativeWidgetCommand:command arguments:argVector view:aView).

    "Modified: / 29-06-2011 / 18:31:20 / cg"
!

noExposeView:aView
    "an noexpose event arrived - this is sent from the device (Display)"

    (catchExpose includes:aView) ifFalse:[
        Logger info:'noExpose but not catching: %1' with:aView.
        ^ self.
    ].
    gotExpose add:aView.
    exposeEventSemaphore notNil ifTrue:[
        exposeEventSemaphore signalForAll
    ]

    "Modified: / 29-06-2011 / 18:31:54 / cg"
!

pasteFromClipBoard:something view:aView
    "a clipboard paste - this is handled like a user event"

    self pushEvent:(WindowEvent pasteFromClipBoard:something view:aView).

    "Modified: 18.1.1997 / 14:07:25 / cg"
    "Created: 13.2.1997 / 13:40:24 / cg"
!

pointerEnter:state x:x y:y view:aView
    "mouse cursor was moved into the view - this is sent from the device (Display)"

    |ev|

    "/ update my idea of shift/alt/ctrl pressed information
    self updateModifierStateFrom:state device:(aView graphicsDevice).

    ev := WindowEvent pointerEnter:state x:x y:y view:aView.
    ev hasShift:shiftDown ctrl:ctrlDown alt:altDown meta:metaDown
                          button1:leftButtonDown button2:middleButtonDown button3:rightButtonDown.

    "/ any eventListener
    "/ (self notifyEventListenersAbout:ev) ifTrue:[^ self].
    self pushEvent:ev.

    "Modified: / 29-06-2011 / 18:47:05 / cg"
!

pointerLeave:state view:aView
    "mouse cursor was moved out of the view - this is sent from the device (Display)"

    |ev|

    "/ update my idea of shift/alt/ctrl pressed information
    self updateModifierStateFrom:state device:(aView graphicsDevice).

    ev := WindowEvent pointerLeave:state view:aView.
    ev hasShift:shiftDown ctrl:ctrlDown alt:altDown meta:metaDown
                          button1:leftButtonDown button2:middleButtonDown button3:rightButtonDown.
    "/ any eventListener
    "/ (self notifyEventListenersAbout:ev) ifTrue:[^ self].
    self pushEvent:ev.

    "Modified: / 29-06-2011 / 18:47:09 / cg"
!

preViewCreateNotification:aView
    "invoked right before a new view is created.
     Notify listeners and allow for the origin/extent to be
     changed. (For example, recorder/playback applications may
     want to make certain that the playback view is at the same
     position - or record any origin changes to translate later
     synthetic events)."

    |ret|

    "/ be prepared that a listener removes itself while we iterate...
    EventListeners copy do:[:aListener |
        ret := EventListener preCreateView:aView origin:aView origin.
        ret isPoint ifTrue:[
            aView setOrigin:ret
        ]
    ]

    "Modified: / 29-06-2011 / 18:51:17 / cg"
!

propertyChange:aView property:propertyId state:aSymbol time:time
    "A window has been created in a view"

    self pushEvent:(WindowEvent propertyChange:aView property:propertyId state:aSymbol time:time).

    "Created: / 01-06-2011 / 13:35:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-06-2011 / 18:47:21 / cg"
!

saveAndTerminateView:aView
    "view should save & terminate (from window manager) - this is sent from the device (Display)"

    self flushEventsFor:aView.
    self pushEvent: "pushDamageEvent:"(WindowEvent saveAndTerminateView:aView)

    "Modified: 18.1.1997 / 14:17:37 / cg"
!

selectionClear:selectionID time:time view:aView
    "the selection owner has changed (someone else has the selection)"

    self pushEvent:(WindowEvent::SelectionClearEvent new 
                        for:aView 
                        type:#selectionClear: 
                        arguments:(Array with:selectionID))
!

terminateView:aView
    "view should terminate (from window manager) - this is sent from the device (Display)"

    |wg|

    self flushEventsFor:aView.

    ((wg := aView windowGroup) notNil
     and:[wg process isNil or:[wg process isDead]]) ifTrue:[
        'WindowSensor [warning]: destroying view for nil/dead windowGroup' infoPrintCR.
        aView topView terminate.
        ^ self
    ].
    "/ don't do it as damage - think of modalBox being open
    self pushEvent: "pushDamageEvent:" (WindowEvent terminateView:aView).

    "Modified: / 25.5.1999 / 15:52:20 / cg"
!

trayAction:command arguments:argVector view:aView
    "native widget action - this is sent from the device (Display)"

    |ev|

    ev := WindowEvent trayAction:command arguments:argVector view:aView.
    self pushEvent:ev.

    "Created: / 31-10-2007 / 01:22:08 / cg"
!

unmappedView:aView
    "view was unmapped (from window manager) - this is sent from the device (Display)"

    self flushExposeEventsFor:aView.
    self pushDamageEvent:(WindowEvent unmappedView:aView).

    "Modified: / 16.2.1998 / 13:20:37 / cg"
!

visibilityOf:aView changedTo:how
    "view was mapped (from window manager) - this is sent from the device (Display)"

    "/ self flushExposeEventsFor:aView.
    self pushDamageEvent:(WindowEvent visibilityOf:aView changedTo:how).

    "Created: / 23-01-2012 / 09:49:13 / cg"
! !

!WindowSensor methodsFor:'event processing-private'!

button:button inView:aView state:onOrOff
    "update the state of the xxxButtonDown flags"

    |physicalButton|

    physicalButton := aView graphicsDevice buttonTranslation keyAtValue:button ifAbsent:button.

    (physicalButton == 1) ifTrue:[
        leftButtonDown := onOrOff.
        ^ self
    ].
    (physicalButton == 2) ifTrue:[
        middleButtonDown := onOrOff.
        ^ self
    ].
    (physicalButton == 3) ifTrue:[
        rightButtonDown := onOrOff.
        ^ self
    ].

    "Modified: 21.10.1996 / 11:47:35 / cg"
!

compose:key1 with:key2
    "compose a 2-character sequence into a composed key"

    ComposeTable do:[:entry |
        ((key1 == (entry at:1)) and:[key2 == (entry at:2)]) ifTrue:[
            ^ entry at:3.
        ]
    ].
    "/
    "/ for illegal sequence, return 2nd key
    "/

    ^ key2
!

isModifierKey:key
    "return true if key is a modifier (Alt, Shift, Ctrl or Meta)"

    (key == #Shift
    or:[key == #'Shift_R' 
    or:[key == #'Shift_L']]) ifTrue:[
        ^ true
    ].
    (key == #Alt
    or:[key == #'Alt_R' or:[key == #'Alt_L']])  ifTrue:[
        ^ true
    ].
    (key == #Meta
    or:[key == #'Meta_R' or:[key == #'Meta_L']]) ifTrue:[
        ^ true
    ].
    (key == #Ctrl
    or:[key == #'Ctrl_R' or:[key == #'Ctrl_L']]) ifTrue:[
        ^ true
    ].
    (key == #Control
    or:[key == #'Control_R' or:[key == #'Control_L']]) ifTrue:[
        ^ true
    ].
    ^ false

    "Modified: / 22.8.1998 / 02:33:46 / cg"
!

key:key state:onOrOff
    "update the state of the shiftDown/metaDown and ctrlDown
     flags"

    (key == #Shift
    or:[key == #'Shift_R' 
    or:[key == #'Shift_L']]) ifTrue:[
        shiftDown := onOrOff.
        ^ self
    ].
    (key == #Alt
    or:[key == #'Alt_R' or:[key == #'Alt_L']])  ifTrue:[
        altDown := onOrOff.
        ^ self
    ].
    (key == #Meta
    or:[key == #'Meta_R' or:[key == #'Meta_L']]) ifTrue:[
        metaDown := onOrOff.
        ^ self
    ].
    (key == #Cmd) ifTrue:[
        metaDown := onOrOff.
        ^ self
    ].
    (key == #Menu) ifTrue:[
        metaDown := onOrOff.
        ^ self
    ].
    (key == #Ctrl
    or:[ key == #'Ctrl_R' or:[key == #'Ctrl_L'
    or:[ key == #Control
    or:[ key == #'Control_R' or:[key == #'Control_L']]]]]) ifTrue:[
        ctrlDown := onOrOff.
        ^ self
    ].

    "Modified: / 29-08-2013 / 16:29:32 / cg"
!

notifyEventArrival:anEventOrNil
    "an event arrived - if there is an eventSemaphore,
     signal it, to wake up any windowGroup process"

    |evView wgProcess|

    anEventOrNil notNil ifTrue:[
        evView := anEventOrNil view.
        (evView notNil and:[catchExpose includesIdentical:evView]) ifTrue:[
            "/ don't signal sema, if we are currently waiting for an expose
            "/ (confirmation of a scroll operation).
            "/ instead, remember that any event arrived for this view.
            gotOtherEvent add:evView.
            ^ self
        ].
    ].

    eventSemaphore notNil ifTrue:[
        "/ can get along with a single trigger;
        "/ because processEvents will read all events
        eventSemaphore signalOnce.

        "/ a little kludge:
        "/ if this is a mouse-click, AND more than one event is already in the queue
        "/ AND the windowGroup process is being debugged,
        "/ then raise the debugger.
        evView notNil ifTrue:[
            (anEventOrNil isButtonPressEvent 
            or:[ anEventOrNil isKeyPressEvent]) ifTrue:[
                mouseAndKeyboard size > 1 ifTrue:[
                    evView windowGroup notNil ifTrue:[
                        (wgProcess := evView windowGroup process) notNil ifTrue:[
                            wgProcess isDebugged ifTrue:[
                                "/ but not for debuggers inside debuggers
                                (evView topView isDebugView) ifFalse:[
                                    DebugView allInstances do:[:dbg |
                                        dbg inspectedProcess == wgProcess ifTrue:[
                                            dbg window topView raiseDeiconified
                                        ].    
                                    ].    
                                ].    
                            ].    
                        ].    
                    ].    
                ].        
            ].        
        ].        
    ]

    "Modified: 8.2.1997 / 12:01:48 / cg"
!

notifyEventListenersAbout:anEvent
    "notify all eventHandlers about an incoming event.
     If any returns true, it is assumed to be eaten by the handler and not
     enqueued (i.e. not passed to the windowGroup process)"

    |anyListenerReturnedTrue v|

    anyListenerReturnedTrue := false.

    "/ global listeners...
    EventListeners notNil ifTrue:[
        "/ be prepared that a listener removes itself while we iterate...
        EventListeners copy do:[:aListener |
            (aListener processEvent:anEvent) == true ifTrue:[
                 anyListenerReturnedTrue := true
            ]
        ]
    ].

    "/ per device listeners
    "/ KLUDGE: change this as soon as DeviceWorkstation creates WindowEvents.
    ((v := anEvent view) notNil and:[v device notNil]) ifTrue:[
        (v device notifyEventListenersAbout:anEvent) == true ifTrue:[
            anyListenerReturnedTrue := true
        ]
    ].

    "/ local listeners ...
    eventListeners notNil ifTrue:[
        "/ be prepared that a listener removes itself while we iterate...
        eventListeners copy do:[:aListener |
            "SV 2016-03-08: I got a nil listener - work around"
            (aListener notNil and:[(aListener processEvent:anEvent) == true]) ifTrue:[
                anyListenerReturnedTrue := true
            ]
        ]
    ].

    ^ anyListenerReturnedTrue.

    "Modified: / 29-06-2011 / 18:50:25 / cg"
!

setCtrlDown:aBoolean
    ctrlDown := aBoolean.
!

setShiftDown:aBoolean
    shiftDown := aBoolean.
!

updateModifierStatesFrom:anotherSensor
    "update the state of the shiftDown, metaDown and ctrlDown flags
     from another window sensor"

    shiftDown := anotherSensor shiftDown.
    altDown := anotherSensor altDown.
    metaDown := anotherSensor metaDown.
    ctrlDown := anotherSensor ctrlDown.
! !

!WindowSensor methodsFor:'event queue'!

addDamage:aRectangle view:aView
    "{ Pragma: +optSpeed }"

    "Add aRectangle to the damage list.
     Try to merge incoming rectangles with the existing damage rectangles.
     Incoming rectangles which are completely contained in any existing damage rect are ignored,
     any existing damage rectangle which is completely contained in the incoming rectangle
     is replaced."

    self addDamage:aRectangle view:aView wakeup:true

    "Modified: 28.5.1996 / 21:52:47 / cg"
!

addDamage:aRectangle view:aView wakeup:doWakeup
    "{ Pragma: +optSpeed }"

    "Add aRectangle to the damage list.
     Try to merge incoming rectangles with the existing damage rectangles.
     Incoming rectangles which are completely contained in any existing damage rect are ignored,
     any existing damage rectangle which is completely contained in the incoming rectangle
     is replaced."

    |didAddNewDamage|

    self criticalDamageEventQueueAccess:[
        didAddNewDamage := self basicAddDamage:aRectangle view:aView.
    ].
    didAddNewDamage ifTrue:[
        doWakeup ifTrue:[
            self notifyEventArrival:nil.
        ].
    ].

    "Created: / 28.5.1996 / 21:51:16 / cg"
    "Modified: / 6.6.1998 / 21:09:06 / cg"
!

basicAddDamage:newRectangle view:aView
    "{ Pragma: +optSpeed }"

    "Add newRectangle to the view's update region.
     Must be careful, if the damage queue contains an event pattern such as:
        damage  map     
     in this case, a new damage event is required to be added AFTER the map event,
     otherwise, the newRectangle will be processed in a state where the map has not yet been
     processed and the view thinks it can be ignored.
     In this case, the damage event is re-added at the end of the queue.
     Attention: this methid MUST be called in a critical region, controlling the damage queue access"

    |sz  "{ Class: SmallInteger }" 
     aDamageEvent oldDamageEvent oldDamageEventIndex anyOtherEventPending lastNilIndex
     ev "badGuy"|

    "/ NEWDAMAGE handling - experimental;
    "/ comment these lines if you encounter trouble.
    sz := damage size.
    (sz > 100) ifTrue:[
        damage := damage select:[:d | d notNil].
        sz := damage size.
    ].

    "/ find any other damage for this view,
    "/ and as a side effect, find the index of the last empty damage queue slot (nil index)
    oldDamageEventIndex := nil.
    anyOtherEventPending := false.
    1 to:sz do:[:idx |
        aDamageEvent := damage at:idx.
        aDamageEvent notNil ifTrue:[
            (aDamageEvent isDamageForView:aView) ifTrue:[
                oldDamageEvent := aDamageEvent.
                oldDamageEventIndex := idx.
            ] ifFalse:[
                anyOtherEventPending := true.
            ]
        ] ifFalse:[
            lastNilIndex := idx
        ].
    ].

    oldDamageEventIndex notNil ifTrue:[
        "/ there is already a damage for this view in the queue
        "/ (which will wake up the WG, if currently sleeping).
        "/ so all we have to do is to add the reactangle to the view's updateRegion.
        "/ However, if the view was unmapped, and there is
        "/ a mapped event AFTER the expose, we MUST perform the expose
        "/ after we have handled the mapped event.
        "/ (otherwise, the expose-rect would be added to the view's expose region,
        "/  and handed at a time when the view thinks it's still unmapped and therefore
        "/  ignore the exposes.)
        "/ Therefore, clear the old damage event and add a new one at the end,
        "/ so that the damages will be processed AFTER the mapEvent has been processed.
        anyOtherEventPending ifFalse:[
            ^ aView addUpdateRectangle:newRectangle.
        ].

        (oldDamageEventIndex > (sz-30)) ifTrue:[
            damage removeIndex:oldDamageEventIndex.
        ] ifFalse:[
            damage at:oldDamageEventIndex put:nil.
            (lastNilIndex notNil and:[lastNilIndex > (sz-30)]) ifTrue:[
                damage removeIndex:lastNilIndex.
            ].
        ].
        damage add:oldDamageEvent.
        aView addUpdateRectangle:newRectangle.
        ^ true
    ].

    (lastNilIndex notNil and:[lastNilIndex > (sz-30)]) ifTrue:[
        damage removeIndex:lastNilIndex.
    ].

    aView addUpdateRectangle:newRectangle.
    ev := WindowEvent newDamageFor:aView.
    damage add:ev.
    ^ true.

"/    |newEvent r fullRedraw aDamageEvent 
"/     nDamagesForView bounds areaOfIndividualRects thisRectangle
"/     mergedLeft mergedRight mergedTop mergedBottom
"/     sz                "{ Class: SmallInteger }"
"/     updateRegion oldDamageEvent oldDamageEventIndex anyOtherEventPending|
"/
"/    "Add newRectangle to the damage list.
"/     Try to merge incoming rectangles with the existing damage rectangles.
"/     Incoming rectangles which are completely contained in any existing damage rect are ignored,
"/     any existing damage rectangle which is completely contained in the incoming rectangle is replaced.
"/     Returns true, if a new event has been added to the queue, false if it was optimized away."
"/
"/    "/ OLDDAMAGE handling
"/    r := newRectangle.
"/    ((fullRedraw := aView redrawsFull) 
"/    or:[sz > 200]) ifTrue:[
"/        r := 0@0 corner:9999@9999.
"/        newEvent := WindowEvent damageFor:aView rectangle:r.
"/        damage add:newEvent.
"/
"/        "/ remove all other damages for this view ...
"/        1 to:sz do:[:idx |
"/            aDamageEvent := damage at:idx.
"/            aDamageEvent notNil ifTrue:[
"/                (aDamageEvent isDamageForView:aView) ifTrue:[
"/                    damage at:idx put:nil
"/                ]
"/            ].
"/        ].
"/
"/        ^ true
"/    ].
"/
"/    "/ remove other damages which are contained in this rectangle
"/
"/    nDamagesForView := 0.
"/    bounds := r.
"/    areaOfIndividualRects := r area.
"/    1 to:sz do:[:idx |
"/        aDamageEvent := damage at:idx.
"/        aDamageEvent notNil ifTrue:[
"/            (aDamageEvent isDamageForView:aView) ifTrue:[
"/                thisRectangle := aDamageEvent rectangle.
"/                (r contains:thisRectangle) ifTrue:[
"/                    "/ the new rectangle contains that old damage
"/                    damage at:idx put:nil
"/                ] ifFalse:[
"/                    "/ the old damage contains the new rectangle    
"/                    (thisRectangle contains:r) ifTrue:[
"/                        ^ false
"/                    ].
"/
"/                    "/ try to merge at left/right    
"/                    r top == thisRectangle top ifTrue:[
"/                        r height == thisRectangle height ifTrue:[
"/                            mergedLeft := (r left min:thisRectangle left).
"/                            mergedRight := (r right max:thisRectangle right).
"/
"/                            "/ only merge, if the merged area is not larger than 150% of the sum of the individual areas
"/                            (r width + thisRectangle width) * 1.5 > (mergedRight - mergedLeft) ifTrue:[
"/                                thisRectangle left:mergedLeft.
"/                                thisRectangle right:mergedRight.
"/                                ^ false
"/                            ].
"/                        ]
"/                    ] ifFalse:[
"/                        "/ try to merge at top/bottom    
"/                        r left == thisRectangle left ifTrue:[
"/                            r width == thisRectangle width ifTrue:[
"/                                mergedTop := (r top min:thisRectangle top).
"/                                mergedBottom := (r bottom max:thisRectangle bottom).
"/
"/                                "/ only merge, if the merged area is not larger than 150% of the sum of the individual areas
"/                                (r height + thisRectangle height) * 1.5 > (mergedBottom - mergedTop) ifTrue:[
"/                                    thisRectangle top:mergedTop.
"/                                    thisRectangle bottom:mergedBottom.
"/                                    ^ false
"/                                ].
"/                            ]
"/                        ]
"/                    ].
"/                    nDamagesForView := nDamagesForView + 1.
"/                    bounds := bounds merge:thisRectangle.
"/                    areaOfIndividualRects := areaOfIndividualRects + thisRectangle area.
"/                ]
"/            ]
"/        ].
"/    ].
"/
"/    "/ if there are many rectangles for this view,
"/    "/ or the bounding rectangles area is not too much
"/    "/ bigger, replace by a single rectangle
"/
"/    (nDamagesForView > 20
"/    or:[bounds notNil 
"/        and:[(areaOfIndividualRects * 1.5) > bounds area]])  ifTrue:[
"/
"/        "/ remove all other damages for this view ...
"/        1 to:sz do:[:idx |
"/            aDamageEvent := damage at:idx.
"/            aDamageEvent notNil ifTrue:[
"/                (aDamageEvent isDamageForView:aView) ifTrue:[
"/                    damage at:idx put:nil
"/                ]
"/            ].
"/        ].
"/
"/        r := bounds.
"/    ].
"/
"/    "/ add the new damage
"/    newEvent := WindowEvent damageFor:aView rectangle:r.
"/    damage add:newEvent.
"/
"/    ^ true.

    "Modified: / 20-01-2011 / 22:41:50 / cg"
!

basicPushEvent:anEvent
    "intenral basic event queueing"

    self criticalUserEventQueueAccess:[
        mouseAndKeyboard addLast:anEvent.
    ].
    self notifyEventArrival:anEvent

    "Created: / 18-09-1995 / 22:37:57 / claus"
    "Modified: / 29-06-2011 / 18:57:19 / cg"
!

nextDamage
    "retrieve the next damage (either expose or resize event)
     or nil, if there is none. Remove it from the queue."

    |d|

    damage size == 0 ifTrue:[^ nil].

    "
     be careful: events are inserted at higher prio ...
    "
    self criticalDamageEventQueueAccess:[
        |foundOne|

        foundOne := false.
        [foundOne] whileFalse:[
            damage size == 0 ifTrue:[
                foundOne := true
            ] ifFalse:[
                d := damage removeFirst.
                foundOne := d notNil.
            ]
        ]
    ].
    ^ d

    "Modified: / 6.6.1998 / 21:10:27 / cg"
!

nextDamageEventFor:aViewOrNil
    "retrieve the next damage event for aView (or any view if nil).
     Return if there are no damage events.
     Remove it from the queue."

    |theEvent|

    damage size == 0 ifTrue:[^ nil].

    "
     be careful: events are inserted at higher prio ...
    "
    self criticalDamageEventQueueAccess:[
        |anEvent idx damageSize firstNonNilIndex|

        idx := 1.
        damageSize := damage size.
        [idx <= damageSize] whileTrue:[
            anEvent := damage at:idx.
            anEvent notNil ifTrue:[
                firstNonNilIndex isNil ifTrue:[
                    firstNonNilIndex := idx
                ].
                (aViewOrNil isNil or:[anEvent view == aViewOrNil]) ifTrue:[
                    damage at:idx put:nil.
                    theEvent := anEvent.
                    idx := damageSize.
                ].
            ].
            idx := idx + 1.
        ].
        firstNonNilIndex isNil ifTrue:[
            damage removeAll
        ] ifFalse:[
            firstNonNilIndex ~~ 1 ifTrue:[
                damage removeFromIndex:1 toIndex:(firstNonNilIndex-1)
            ]
        ]
    ].

    ^ theEvent

    "Created: / 3.12.1998 / 13:41:49 / cg"
    "Modified: / 5.2.1999 / 20:58:20 / cg"
!

nextEvent
    "retrieve the next event or nil, if there is none.
     Remove it from the queue."

    |e|

    mouseAndKeyboard size == 0 ifTrue:[^ nil].

    "
     be careful: events are inserted at higher prio ...
    "
    self criticalUserEventQueueAccess:[
        |foundOne|

        foundOne := false.
        [foundOne] whileFalse:[
            mouseAndKeyboard size == 0 ifTrue:[
                foundOne := true
            ] ifFalse:[
                e := mouseAndKeyboard removeFirst.
                foundOne := e notNil.
            ]
        ]
    ].
    ^ e

    "Modified: / 6.6.1998 / 21:10:39 / cg"
!

nextExposeEventFor:aViewOrNil
    "retrieve the next expose event for aView (or any view if nil).
     Return if there are no expose events.
     Remove it from the queue."

    |theEvent|

    damage size == 0 ifTrue:[^ nil].

    "
     be careful: events are inserted at higher prio ...
    "
    self criticalDamageEventQueueAccess:[
        |firstNonNilIndex anEvent idx damageSize|

        idx := 1.
        damageSize := damage size.
        [idx <= damageSize] whileTrue:[
            anEvent := damage at:idx.
            anEvent notNil ifTrue:[
                firstNonNilIndex isNil ifTrue:[
                    firstNonNilIndex := idx
                ].
                
                anEvent isConfigureEvent ifTrue:[
                    (aViewOrNil isNil or:[anEvent view == aViewOrNil]) ifTrue:[
                        ^ nil
                    ]   
                ].

                anEvent isDamage ifTrue:[
                    (aViewOrNil isNil or:[anEvent view == aViewOrNil]) ifTrue:[
                        theEvent := anEvent.
                        damage at:idx put:nil.
                        idx := damageSize.
                    ]
                ].
            ].
            idx := idx + 1.
        ].

        firstNonNilIndex isNil ifTrue:[
            damage removeAll
        ] ifFalse:[
            firstNonNilIndex ~~ 1 ifTrue:[
                damage removeFromIndex:1 toIndex:(firstNonNilIndex-1)
            ]
        ].
    ].

    ^ theEvent

    "Created: / 21.5.1996 / 17:20:54 / cg"
    "Modified: / 5.2.1999 / 20:58:28 / cg"
!

pendingEvent
    "retrieve the next pending user (i.e. non-damage) event.
     Return nil, if there is none pending.
     Do not remove it from the queue."

    |e|

    mouseAndKeyboard size == 0 ifTrue:[^ nil].

    "
     be careful: events are inserted at higher prio ...
    "
    self criticalUserEventQueueAccess:[
        [e isNil] whileTrue:[
            mouseAndKeyboard size == 0 ifTrue:[^ nil].

            e := mouseAndKeyboard first.
            e isNil ifTrue:[
                mouseAndKeyboard removeFirst
            ].
        ]
    ].
    ^ e

    "Modified: / 6.6.1998 / 21:10:51 / cg"
!

pushDamageEvent:anEvent
    "put an event into the damage queue
     - this is not meant for public use"

    self criticalDamageEventQueueAccess:[
        damage addLast:anEvent.
    ].
    self notifyEventArrival:anEvent

    "Created: / 18.1.1997 / 14:16:45 / cg"
    "Modified: / 6.6.1998 / 21:10:56 / cg"
!

pushEvent:anEvent
    "put an event into the queue - this can also be sent by
     applications and allows simulation of events 
     (implementation of recorders & playback)
     or asynchronous communication between view applications
     (by sending arbitrary events, which leads to a message sent,
      when the target windowGroups process is rescheduled)."

    anEvent timeStamp isNil ifTrue:[
        anEvent timeStamp:Timestamp now.
    ].

    "/ inform all local and global eventListeners ?
    (self notifyEventListenersAbout:anEvent) ifTrue:[
        "/ event was eaten
        ^ self
    ].
    self basicPushEvent:anEvent.

    "
     |b|
     b := Button label:'test'.
     b action:[Transcript showCR:'hallo'].
     b open.
     (Delay forSeconds:5) wait.
     b sensor pushEvent:(WindowEvent pointerEnter:0 x:1 y:1 view:b).
     (Delay forSeconds:1) wait.
     b sensor pushEvent:(WindowEvent buttonPress:1 x:1 y:1 view:b).
     (Delay forSeconds:2) wait.
     b sensor pushEvent:(WindowEvent buttonRelease:1 x:1 y:1 view:b).
     (Delay forSeconds:1) wait.
     b sensor pushEvent:(WindowEvent pointerLeave:0 view:b).
    "

    "Created: / 18-09-1995 / 22:37:57 / claus"
    "Modified: / 29-06-2011 / 18:57:19 / cg"
! !

!WindowSensor methodsFor:'event simulation'!

enqueueMessage:selector for:someone arguments:argList
    "if such a message is already in the queue, ignore it.
     Otherwise push it as an event, to be handled when my thread is
     back in the event loop."
     
    self criticalUserEventQueueAccess:[
        (self hasUserEvent:selector for:someone withArguments:argList) ifFalse:[
            self pushUserEvent:selector for:someone withArguments:argList
        ].
    ].
!

forwardKeyEventsTo:aView
    "remove all keyboard events and send them to aViews sensor instead"

    1 to:mouseAndKeyboard size do:[:i |
        |anEvent|

        anEvent := mouseAndKeyboard at:i.
        anEvent notNil ifTrue:[
            anEvent isKeyEvent ifTrue:[
                anEvent view:aView.
                aView sensor pushEvent:anEvent.
                mouseAndKeyboard at:i put:nil
            ]
        ]
    ].

    "Modified: 18.1.1997 / 14:05:02 / cg"
!

pushAction:aBlock
    "enqueue an action into my event queue.
     The underlying window process will evaluate aBlock in its event loop
     (i.e. syncronously). Use this to present the result of an asyncronous background
     computation"

     self pushUserEvent:#value for:aBlock withArguments:#() 
!

pushUserEvent:aSelector for:aView
    "manually put an event into the queue - this allows
     simulation of events (implementation of recorders & playback)
     or asynchronous communication between view applications.
     The view will perform a method as specified by aSelector,
     when it performs event processing; this is different than sending
     this message directly, since the execution is done by the view's process,
     not by the current process (which is especially worthwhile, if that method 
     shows a modal box or similar)."

     self pushUserEvent:aSelector for:aView withArguments:#() 

    "Modified: 18.9.1995 / 22:40:12 / claus"
!

pushUserEvent:aSelector for:anyObject withArgument:argument
    "manually put an event into the queue - this allows
     simulation of events (implementation of recorders & playback)
     or asynchronous communication between view applications.
     anyObject will perform a method as specified by aSelector,
     when the windogroup dispatches this event. This is different than sending
     this message directly, since the execution is done by the view's process,
     not by the current process (which is especially worthwhile, if that method 
     shows a modal box or similar)."

    self pushUserEvent:aSelector for:anyObject withArguments:(Array with:argument).
!

pushUserEvent:aSelector for:anyObject withArguments:arguments
    "manually put an event into the queue - this allows
     simulation of events (implementation of recorders & playback)
     or asynchronous communication between view applications.
     anyObject will perform a method as specified by aSelector,
     when the windogroup dispatches this event. This is different than sending
     this message directly, since the execution is done by the view's process,
     not by the current process (which is especially worthwhile, if that method 
     shows a modal box or similar)."

    self pushEvent:(WindowEvent messageSend:anyObject selector:aSelector arguments:arguments).

    "
     |b|
     b := Button label:'test'.
     b open.
     (Delay forSeconds:5) wait.
     b sensor pushUserEvent:#fooBar for:b withArguments:#().
    "

    "
     |b|
     b := Button label:'test'.
     b open.
     (Delay forSeconds:3) wait.
     b sensor pushUserEvent:#disable for:b withArguments:#().
    "

    "Modified: 4.1.1997 / 13:53:01 / cg"
! !

!WindowSensor methodsFor:'initialization'!

initialize
    "initialize the event queues to empty"

    self initializeState.

    compressMotionEvents := translateKeyboardEvents := true.
    ignoreUserInput := false.

    "Modified: / 14.12.1999 / 21:15:03 / cg"
!

initializeState
    "initialize the event queues to empty"

    damageEventAccessLock := RecursionLock new.
    damageEventAccessLock name:'WSensor ev-q damageEventAccessLock'.
    userEventAccessLock := RecursionLock new.
    userEventAccessLock name:'WSensor ev-q userEventAccessLock'.

    damage := OrderedCollection new.
    mouseAndKeyboard := OrderedCollection new.

    gotExpose := IdentitySet new.
    catchExpose := IdentitySet new.
    gotOtherEvent := IdentitySet new.

    shiftDown := ctrlDown := altDown := metaDown := false.
    leftButtonDown := middleButtonDown := rightButtonDown := false.
    collectedMouseWheelMotion := 0.

    "Modified: / 30-07-2013 / 19:27:46 / cg"
!

reinitialize
    "called when an image is restarted;
     reinitialize the event queues to empty; leave other setup as-is"

    self initializeState.
! !

!WindowSensor methodsFor:'others'!

updateModifierStateFrom:stateIn device:aDevice
    "this updates the modifier key-states.
     Called privately when pointer enters a view."

    |state|

    "/ Prevents wrong behavior in the following scenario:
    "/    ctrl is pressed in a view
    "/    pointer is moved out of view
    "/    ctrl is released
    "/    pointer moved back into view
    "/    popup-menu still thinks that ctrl is pressed"
    "/ state := aDevice buttonStates.
    state := stateIn.

    shiftDown := (state bitAnd:(aDevice shiftModifierMask)) ~~ 0.
    ctrlDown := (state bitAnd:(aDevice ctrlModifierMask)) ~~ 0.
    metaDown := (state bitAnd:(aDevice metaModifierMask)) ~~ 0.
    altDown := (state bitAnd:(aDevice altModifierMask)) ~~ 0.

"/Transcript show:'meta:'; showCR:metaDown.
"/Transcript show:'alt:'; showCR:altDown.

    leftButtonDown := (state bitAnd:(aDevice leftButtonStateMask)) ~~ 0.
    middleButtonDown := (state bitAnd:(aDevice middleButtonStateMask)) ~~ 0.
    rightButtonDown := (state bitAnd:(aDevice rightButtonStateMask)) ~~ 0.

    "Created: / 27.2.1996 / 14:54:38 / cg"
    "Modified: / 8.9.1998 / 15:11:44 / cg"
! !

!WindowSensor methodsFor:'queries-event queue'!

damageCount 
    "return the number of pending damage events (i.e. expose or resize)"

    ^ damage size

    "Modified: / 2.4.1997 / 14:14:01 / cg"
    "Created: / 5.4.1998 / 11:35:04 / cg"
!

eventPending
    "return true, if either damage or events are pending"

    mouseAndKeyboard size ~~ 0 ifTrue:[^ true].
    ^ damage size ~~ 0
!

hasButtonEventFor:aView 
    "return true, if any button events are pending.
     If the argument, aView is nil, the information is regarding any
     view (i.e. is there a button event for any of my views);
     otherwise, the information is regarding that specific view."

    (self hasButtonMotionEventFor:aView) ifTrue:[^ true].
    (self hasButtonPressEventFor:aView) ifTrue:[^ true].
    ^ (self hasButtonReleaseEventFor:aView)

    "Created: 1.11.1996 / 17:02:23 / cg"
    "Modified: 1.11.1996 / 17:12:03 / cg"
!

hasButtonMotionEventFor:aView 
    "return true, if any buttonMotion events are pending.
     If the argument, aView is nil, the information is regarding any
     view (i.e. is there a motion event for any of my views);
     otherwise, the information is regarding that specific view."

    ^ self hasEvent:#buttonMotion:x:y: orPendingDeviceEvent:#buttonMotion for:aView

    "Created: 1.11.1996 / 17:04:01 / cg"
!

hasButtonPressEventFor:aView 
    "return true, if any buttonPress events are pending.
     If the argument, aView is nil, the information is regarding any
     view (i.e. is there a buttonPress event for any of my views);
     otherwise, the information is regarding that specific view."

    ^ self hasEvent:#buttonPress:x:y: orPendingDeviceEvent:#buttonPress for:aView

    "Created: 1.11.1996 / 17:05:10 / cg"
    "Modified: 1.11.1996 / 17:11:09 / cg"
!

hasButtonReleaseEventFor:aView 
    "return true, if any buttonRelease events are pending.
     If the argument, aView is nil, the information is regarding any
     view (i.e. is there a buttonrelease event for any of my views);
     otherwise, the information is regarding that specific view."

    ^ self hasEvent:#buttonRelease:x:y: orPendingDeviceEvent:#buttonRelease for:aView

    "Created: 1.11.1996 / 17:05:26 / cg"
    "Modified: 1.11.1996 / 17:11:18 / cg"
!

hasConfigureEventFor:aView 
    "return true, if any resize/position events are pending.
     If the argument, aView is nil, the information is regarding any
     view (i.e. is there a configure event for any of my views);
     otherwise, the information is regarding that specific view."

    ^ self hasEvent:#configureX:y:width:height: orPendingDeviceEvent:#structureNotify for:aView

    "Modified: 1.11.1996 / 17:11:27 / cg"
!

hasDamage 
    "return true, if any damage events (i.e. expose or resize) are pending.
     Since this is often invoked by ST-80 classes to poll the sensor,
     a yield is done here to avoid a busy wait blocking other processes."

    Processor yield.
    ^ damage size ~~ 0

    "Modified: 2.4.1997 / 14:14:01 / cg"
!

hasDamageFor:aViewOrNil 
    "return true, if any damage events (i.e. expose or resize)
     are pending for aViewOrNil. If nil, returns true if any damage is 
     pending for this windowGroup."

    damage size ~~ 0 ifTrue:[
        damage do:[:aDamage |
            aDamage notNil ifTrue:[
                (aViewOrNil isNil or:[aDamage view == aViewOrNil]) ifTrue:[^ true]
            ].
        ]
    ].
    ^ false

    "Modified: 21.5.1996 / 17:15:09 / cg"
!

hasEvent:type for:aReceiverOrNil
    "return true, if a specific event is pending in my queues.
     Type is the type of event, dType the corresponding device event.
     If the argument, aReceiverOrNil is nil, the information is regarding any
     view (i.e. is there an event for any of my views);
     otherwise, the information is regarding to that specific view."

    mouseAndKeyboard size ~~ 0 ifTrue:[
        (self hasUserEvent:type for:aReceiverOrNil) ifTrue:[^ true].
    ].
    damage size ~~ 0 ifTrue:[
        damage do:[:anEvent |
            anEvent notNil ifTrue:[
                (aReceiverOrNil isNil or:[anEvent receiver == aReceiverOrNil]) ifTrue:[
                    (type isNil or:[anEvent type == type]) ifTrue:[^ true].
                ]
            ].
        ]
    ].
    ^ false

    "Created: / 10.6.1998 / 17:33:46 / cg"
    "Modified: / 18.6.1998 / 09:29:18 / cg"
!

hasEvent:type for:aView withArguments:argsOrNil 
    "return true, if a specific event is pending in my queues.
     Type is the type of event, args are the arguments.
     If the argument, aView is nil, the information is regarding any
     view (i.e. is there an event for any of my views);
     otherwise, the information is regarding to that specific view."

    |args|

    args := argsOrNil ? #().
    ^ self
        hasEvent:type 
        for:aView 
        withMatchingArguments:[:evArgs | evArgs = args]
!

hasEvent:type for:aReceiverOrNil withMatchingArguments:argMatchBlock 
    "return true, if a matching event is pending in my queues.
     Type is the type of event, matchBlock is a block which gets the event args
     and should return true.
     If the argument, aReceiverOrNil is nil, the information is regarding any
     view (i.e. is there an event for any of my views);
     otherwise, the information is regarding to that specific view.
     If the type-argument is nil, any event matches, otherwise only events with
     that type are matched."

    mouseAndKeyboard size ~~ 0 ifTrue:[
        mouseAndKeyboard do:[:anEvent |
            anEvent notNil ifTrue:[
                (aReceiverOrNil isNil or:[anEvent receiver == aReceiverOrNil]) ifTrue:[
                    (type isNil or:[anEvent type == type]) ifTrue:[
                        (argMatchBlock value:anEvent arguments) ifTrue:[
                            ^ true
                        ].
                    ]
                ]
            ].
        ]
    ].
    damage size ~~ 0 ifTrue:[
        damage do:[:anEvent |
            anEvent notNil ifTrue:[
                (aReceiverOrNil isNil or:[anEvent receiver == aReceiverOrNil]) ifTrue:[
                    (type isNil or:[anEvent type == type]) ifTrue:[
                        (argMatchBlock value:anEvent arguments) ifTrue:[
                            ^ true
                        ]
                    ].
                ]
            ].
        ]
    ].
    ^ false

    "Modified: 1.11.1996 / 17:11:47 / cg"
    "Created: 4.1.1997 / 14:00:29 / cg"
!

hasEvent:type orPendingDeviceEvent:dType for:aView
    "return true, if a specific event is pending in a queue
     or in the devices event queue.
     Type is the type of event, dType the corresponding device event.
     If the argument, aView is nil, the information is regarding any
     view (i.e. is there an event for any of my views);
     otherwise, the information is regarding to that specific view."

    |device|

    "/ look in my queues
    (self hasEvent:type for:aView) ifTrue:[^ true].

    aView notNil ifTrue:[
        (device := aView graphicsDevice) notNil ifTrue:[
            "/ ask the device if it has something pending
            ^ device eventPending:dType for:aView id
        ].
    ].
    ^ false

    "Modified: / 10.6.1998 / 17:34:51 / cg"
!

hasEvents 
    "return true, if any mouse/keyboard events are pending"

    mouseAndKeyboard size ~~ 0 ifTrue:[^ true].
    ^ damage size ~~ 0

    "Modified: / 5.2.1999 / 22:30:23 / cg"
!

hasExposeEventFor:aViewOrNil 
    "return true, if any exposure events are pending for aView.
     If aViewOrNil is nil, return true if any exposure event for any view
     in my windowGroup is pending"

    damage size ~~ 0 ifTrue:[
        damage do:[:aDamage |
            aDamage notNil ifTrue:[
                aDamage isDamage ifTrue:[
                    (aViewOrNil isNil or:[aDamage view == aViewOrNil]) ifTrue:[^ true].
                ]
            ].
        ]
    ].
    ^ false

    "Modified: 21.5.1996 / 17:13:09 / cg"
    "Created: 1.11.1996 / 17:05:41 / cg"
!

hasKeyEventFor:aViewOrNil 
    "return true, if any key (press or release) events are pending.
     If the argument, aView is nil, the information is regarding any
     view (i.e. is there a key event for any of my views);
     otherwise, the information is regarding that specific view."

    (self hasKeyPressEventFor:aViewOrNil) ifTrue:[^ true].
    ^ self hasKeyReleaseEventFor:aViewOrNil

    "Created: 1.11.1996 / 17:08:03 / cg"
    "Modified: 1.11.1996 / 17:11:55 / cg"
!

hasKeyPressEventFor:aViewOrNil 
    "return true, if any keyPress events are pending.
     If the argument, aView is nil, the information is regarding any
     view (i.e. is there a keyPress event for any of my views);
     otherwise, the information is regarding that specific view."

    ^ self hasEvent:#keyPress:x:y: orPendingDeviceEvent:#keyPress for:aViewOrNil

    "Created: 1.11.1996 / 17:05:58 / cg"
    "Modified: 1.11.1996 / 17:12:10 / cg"
!

hasKeyReleaseEventFor:aViewOrNil 
    "return true, if any keyRelease events are pending.
     If the argument, aView is nil, the information is regarding any
     view (i.e. is there a keyRelease event for any of my views);
     otherwise, the information is regarding that specific view."

    ^ self hasEvent:#keyRelease:x:y: orPendingDeviceEvent:#keyRelease for:aViewOrNil

    "Created: 1.11.1996 / 17:06:34 / cg"
    "Modified: 1.11.1996 / 17:12:15 / cg"
!

hasUserEvent:type for:aReceiverOrNil
    "return true, if a specific event is pending in my user event queue.
     Type is the type of event, dType the corresponding device event.
     If the argument, aReceiverOrNil is nil, the information is regarding any
     view (i.e. is there an event for any of my views);
     otherwise, the information is regarding to that specific view."

    mouseAndKeyboard size ~~ 0 ifTrue:[
        mouseAndKeyboard do:[:anEvent |
            anEvent notNil ifTrue:[
                (aReceiverOrNil isNil or:[anEvent receiver == aReceiverOrNil]) ifTrue:[
                    (type isNil or:[anEvent type == type]) ifTrue:[^ true].
                ]
            ].
        ]
    ].
    ^ false

    "Created: / 17.6.1998 / 12:55:54 / cg"
    "Modified: / 18.6.1998 / 08:57:00 / cg"
!

hasUserEvent:type for:aView withArguments:argsOrNil 
    "return true, if a specific user event (non damage) is pending in my queues.
     Type is the type of event, args are the arguments.
     If the argument, aView is nil, the information is regarding any
     view (i.e. is there an event for any of my views);
     otherwise, the information is regarding to that specific view."

    |args|

    args := argsOrNil ? #().
    ^ self
        hasUserEvent:type 
        for:aView 
        withMatchingArguments:[:evArgs | evArgs = args]
!

hasUserEvent:type for:aReceiverOrNil withMatchingArguments:argMatchBlock
    "return true, if a specific event is pending in my user event queue.
     Type is the type of event, dType the corresponding device event.
     If the argument, aReceiverOrNil is nil, the information is regarding any
     view (i.e. is there an event for any of my views);
     otherwise, the information is regarding to that specific view."

    mouseAndKeyboard size ~~ 0 ifTrue:[
        mouseAndKeyboard do:[:anEvent |
            anEvent notNil ifTrue:[
                (aReceiverOrNil isNil or:[anEvent receiver == aReceiverOrNil]) ifTrue:[
                    (type isNil or:[anEvent type == type]) ifTrue:[
                        (argMatchBlock value:anEvent arguments) ifTrue:[
                            ^ true
                        ].
                    ].
                ]
            ].
        ]
    ].
    ^ false

    "Created: / 17.6.1998 / 12:55:54 / cg"
    "Modified: / 18.6.1998 / 08:57:00 / cg"
!

hasUserEventFor:aView 
    "return true, if any user event (i.e. key or button events) are pending.
     If the argument, aView is nil, the information is regarding any
     view (i.e. is there a user event for any of my views);
     otherwise, the information is regarding that specific view."

    (self hasKeyEventFor:aView) ifTrue:[^ true].
    ^ (self hasButtonEventFor:aView)

    "Created: 1.11.1996 / 17:08:50 / cg"
    "Modified: 1.11.1996 / 17:12:21 / cg"
!

hasUserEvents 
    "return true, if any mouse/keyboard events are pending"

    ^ mouseAndKeyboard size ~~ 0

    "Created: / 5.2.1999 / 22:29:11 / cg"
!

motionEventPending 
    "return true, if any buttonMotion events are pending."

    ^ self hasButtonMotionEventFor:nil

    "Created: 24.3.1996 / 20:09:55 / cg"
    "Modified: 1.11.1996 / 17:04:43 / cg"
!

userEventCount 
    "return the number of pending user events"

    ^ mouseAndKeyboard size

    "Modified: / 21.7.1998 / 18:52:19 / cg"
    "Created: / 21.7.1998 / 19:36:04 / cg"
! !

!WindowSensor methodsFor:'queries-key & button state'!

altDown
    "return true, if the meta key is currently pressed.
     Notice, that some keyboards don't have an alt key;
     it is better to use 'sensor metaDown or:[sensor altDown]'."

    ^ altDown
!

anyButtonPressed
    "ST-80 compatibility: return true, if any mouse button is pressed.
     You should no use it in 'normal' applications.
     Instead, keep track of the buttons state in your views or controllers
     button-event methods."

    ^ leftButtonDown or:[middleButtonDown or:[rightButtonDown]]

    "Modified: 21.10.1996 / 11:37:31 / cg"
!

anyModifierKeyDown
    "return true, if any modifier key is currently pressed."

    ^ shiftDown or:[ctrlDown or:[altDown or:[metaDown]]]
!

ctrlDown
    "return true, if any CTRL key is currently pressed."

    ^ ctrlDown
!

leftButtonPressed
    "return true, if the left mouse button is pressed.
     This has been added to support ST-80 style button polling;
     however, you should no use it in 'normal' applications.
     Instead, keep track of the buttons state in your views or controllers
     button-event methods."

    ^ leftButtonDown
!

metaDown
    "return true, if the meta key is currently pressed.
     Notice, that most keyboards don't have a meta key;
     it is better to use 'sensor metaDown or:[sensor altDown]'."

    ^ metaDown
!

middleButtonPressed
    "return true, if the middle mouse button is pressed.
     This has been added to support ST-80 style button polling;
     however, you should no use it in 'normal' applications.
     Instead, keep track of the buttons state in your views or controllers
     button-event methods."

    ^ middleButtonDown
!

rightButtonPressed
    "return true, if the right mouse button is pressed.
     This has been added to support ST-80 style button polling;
     however, you should no use it in 'normal' applications.
     Instead, keep track of the buttons state in your views or controllers
     button-event methods."

    ^ rightButtonDown
!

shiftDown
    "return true, if any shift key is currently pressed."

    ^ shiftDown
! !

!WindowSensor methodsFor:'queries-pointer'!

cursorPoint
    "ST-80 compatibility: 
     return the position of the mouse pointer on the current display
     (in screen coordinates)"

     ^ self class cursorPoint
!

globalOrigin 
    "ST-80 compatibility: 
     don't know what we should return here ...
     ... at least the PD program which uses it works when we return 0@0."

     ^ 0@0
!

mousePoint
    "ST-80 compatibility: 
     return the position of the mouse pointer on the current display
     (in screen coordinates)"

     ^ self cursorPoint
! !

!WindowSensor methodsFor:'special'!

catchExposeFor:aView
    "start catching noExpose events (must be done BEFORE a bitblt,
     to prepare for the exposeEventSemaphore to be signalled when 
     the noExpose event arrives)."

"/ we never come here - this is already checked by the sender
"/    aView device scrollsAsynchronous ifFalse:[
"/        ^ self
"/    ].

    (catchExpose includes:aView) ifTrue:[
        Logger warning:'already catching (for %1)' with:aView.
        Delay waitForMilliseconds:100.
        (catchExpose includes:aView) ifTrue:[
            Logger warning:'still catching after 100ms (for %1)' with:aView.
            "/ wake the other one
            gotExpose add:aView.
            exposeEventSemaphore notNil ifTrue:[
                exposeEventSemaphore signalForAll.
            ].
            Delay waitForMilliseconds:100.
        ].
    ].

    [
        gotOtherEvent remove:aView ifAbsent:nil.
        gotExpose remove:aView ifAbsent:nil.
        exposeEventSemaphore isNil ifTrue:[
            exposeEventSemaphore := Semaphore new name:'WSensor exposeSema'.
        ].
        catchExpose add:aView.
    ] valueUninterruptably.

    "Modified: / 14.12.1999 / 20:59:16 / cg"
!

pollForActivity
    <resource: #obsolete>
    "ST-80 compatibility: wait for some activity (i.e. poll for an event) "

    "/ should add a buttonStateChangeSemaphore and wait on this ...
"/    Delay waitForSeconds:0.01.
    Processor yield.

    "Modified: 12.2.1997 / 12:46:09 / cg"
!

waitButton
    <resource: #obsolete>
    "ST-80 compatibility: wait until any mouse button is pressed.
     Do not use this in your applications; polling the sensor is
     bad style."

    [self anyButtonPressed] whileFalse:[
        self pollForActivity
    ].

    "Modified: 10.2.1997 / 13:30:38 / cg"
!

waitClickButton
    <resource: #obsolete>
    "ST-80 compatibility: wait until any mouse button is pressed & released again.
     Do not use this in your applications; polling the sensor is
     bad style."

    self waitButton.
    ^self waitNoButton

    "Created: 10.2.1997 / 13:31:09 / cg"
!

waitForExposeFor:aView
    "wait until a graphicsExpose or a noExpose arrives (after a bitblt).
     This may be too X-specific, and things may change in this area
     in future versions. (or the new device may simulate the arrival of
     such an event)"

    |blocked lostExpose viewsDevice stopPoll endPollTime pollDelay pollDelay2
     exposeSema|

    viewsDevice := aView graphicsDevice.

"/ we never come here - this is already checked by the sender
"/    viewsDevice scrollsAsynchronous ifFalse:[
"/        gotExpose remove:aView ifAbsent:nil.
"/        catchExpose remove:aView ifAbsent:nil.
"/        ^ self
"/    ].
    (exposeSema := exposeEventSemaphore) isNil ifTrue:[
        Logger warning:'expose wait, but no catchExpose done before: %1' with:aView.
        gotExpose remove:aView ifAbsent:nil.
        catchExpose remove:aView ifAbsent:nil.
        ^ self
    ].

    blocked := true.
    [
        viewsDevice flush.

        viewsDevice isWindowsPlatform ifTrue:[
            "/ since this is definitely a local display,
            "/ there is no need for a long timeOut
            "/ (it should arrive fast)
            pollDelay := 50.
            pollDelay2 := 50.
        ] ifFalse:[
            pollDelay := 3000.
            pollDelay2 := 1000.
        ].

        Processor activeProcessIsSystemProcess ifTrue:[
            endPollTime := Timestamp now addMilliseconds:pollDelay.
            stopPoll := false.

            "/
            "/ cannot really suspend, if its a systemProcess
            "/ must poll for the event
            "/
            [(gotExpose includes:aView) or:[stopPoll]] whileFalse:[
                (viewsDevice exposeEventPendingFor:aView id withSync:true) ifTrue:[
                    viewsDevice dispatchExposeEventFor:aView id.
                ].
                stopPoll := Timestamp now > endPollTime.
                Processor yield.
            ]
        ] ifFalse:[
            lostExpose := 1.
            "
              block interrupt here, to resolve race between
              testing gotExpose and the semaphore, which is woken up
              with #signalForAll.
            "
            blocked := OperatingSystem blockInterrupts.
            [ (gotExpose includes:aView) or:[lostExpose > 2] ] whileFalse:[
                "
                 just in case we have a (network or software) problem ...
                 explanation: it may happen, that an expose event is totally
                 lost - for example, if the network breaks down.
                 To not block forever, we wait with a timeout, to get out of here
                 if the event does not arrive after a few seconds.
                "
                exposeSema isNil ifTrue:[
                    lostExpose := 999.
                ].
                (exposeSema waitWithTimeoutMs:(pollDelay2 * lostExpose)) isNil ifTrue:[
                    viewsDevice flush.         "/ we are paranoid
                    lostExpose := lostExpose + 1.
                ].
            ].
            (gotExpose includes:aView) ifFalse:[
                Logger warning:'lost expose event: %1' with:aView.
            ] ifTrue:[
"/                lostExpose > 1 ifTrue:[
"/                    ('WindowSensor [info]: late expose event (' , aView printString , ')') infoPrintCR.
"/                ]
            ]
        ].
    ] ensure:[
        gotExpose remove:aView ifAbsent:nil.
        catchExpose remove:aView ifAbsent:nil.
        catchExpose isEmpty ifTrue:[
            exposeEventSemaphore := nil
        ].
        gotOtherEvent remove:aView ifAbsent:nil.
        blocked ifFalse:[
            OperatingSystem unblockInterrupts.
        ].

        "/
        "/ other incoming events have been ignored during the wait.
        "/ Now handle those ...
        "/  
        eventSemaphore notNil ifTrue:[
            eventSemaphore signalOnce.
        ].
    ].

    "Modified: / 20-02-1997 / 09:24:31 / stefan"
    "Modified: / 19-07-2006 / 20:03:42 / cg"
!

waitNoButton
    <resource: #obsolete>
    "ST-80 compatibility: wait until no mouse button is pressed.
     Do not use this in your applications; polling the sensor is
     bad style."

    [self anyButtonPressed] whileTrue:[
        self pollForActivity
    ].

    "Modified: 10.2.1997 / 13:30:43 / cg"
! !

!WindowSensor class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


WindowSensor initialize!
