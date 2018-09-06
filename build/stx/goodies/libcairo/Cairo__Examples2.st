"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

AbstractExamples subclass:#Examples2
	instanceVariableNames:'cairoify'
	classVariableNames:''
	poolDictionaries:''
	category:'Cairo-Examples'
!


!Examples2 methodsFor:'examples'!

example01a: gc <example: '01a - Rectangles'>
"
Shows how stroke,fill and lineWidth plays together. Here
CairoGraphicsContext produces slightly different output
than DeviceGraphicsContext. Making CairoGraphicsContext
to produce same output is difficult as, expecially when there's
some scaling involved, DeviceGraphicsContext does a wierd job.
At the same time one may argue that cairo does it correctly,
so here we stick with Cairo's way...
"
gc lineWidth: 1.
gc paint: Color black.
gc displayLineFromX: 1   y: 15  toX: 130 y: 15.
gc displayLineFromX: 15  y: 1   toX: 15  y: 130.
gc displayLineFromX: 1   y: 115 toX: 130 y: 115.
gc displayLineFromX: 115 y: 1   toX: 115 y: 130.


gc lineWidth: 10.
gc paint: Color red.
gc displayRectangleX: 15 y: 15 width: 100 height: 100.

gc paint: Color blue.
gc fillRectangleX: 15 y: 65 width: 50 height: 50.

    "Created: / 28-02-2016 / 15:43:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 02-03-2016 / 21:26:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

example01b: gc <example: '01b - Rectangles'>
"
Shows how stroke,fill and lineWidth plays together. 
Same as example 01a but with 1pixel wide lines
"
gc lineWidth: 1.
gc paint: Color black.
gc displayLineFromX: 1   y: 15  toX: 130 y: 15.
gc displayLineFromX: 15  y: 1   toX: 15  y: 130.
gc displayLineFromX: 1   y: 115 toX: 130 y: 115.
gc displayLineFromX: 115 y: 1   toX: 115 y: 130.


gc lineWidth: 1.
gc paint: Color red.
gc displayRectangleX: 15 y: 15 width: 100 height: 100.

gc paint: Color blue.
gc fillRectangleX: 15 y: 65 width: 50 height: 50.

    "Created: / 28-02-2016 / 15:44:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 02-03-2016 / 21:27:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

example02: gc <example: '02 - Rectangles (rounded)'>
"
Display rounded rectangles. Try to zoom it to 800%, 
you'll a number of artefacts when displayed using 
native GC.
"
gc lineWidth: 10.
gc paint: Color red.
gc displayRoundRectangleX: 10 y: 10 width: gc width - 20 height: gc height - 20
   wCorner: 30 hCorner: 30.
gc paint: Color blue lighter.
gc fillRoundRectangleX: 10 y: 10 rounded width: gc width - 20 height: (gc height - 20) rounded
   wCorner: 30 hCorner: 30.
gc paint: Color black.
gc lineWidth: 1.
gc displayLineFromX: 1 y: (gc height / 2) rounded toX: gc width y: (gc height / 2) rounded.

    "Created: / 27-02-2016 / 09:04:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 02-03-2016 / 21:28:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

example03: gc <example: '03 - PNG with alpha'>
"
Shows a PNG image with alpha over a pattern
(black and white rectangles). As the PNG has
alpha, the pattern should be visible 'underneath'
"
| image |

gc paint: Color white.
gc fillRectangleX:1 y:1 width: 32 height: 32.

gc paint: Color black.
gc fillRectangleX:33 y:33 width: 32 height: 32.

image := Image fromFile: 'square1.png' inPackage: 'stx:goodies/libcairo'.
image displayOn: gc x: 1 y: 1.

    "Created: / 27-02-2016 / 16:14:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-02-2016 / 14:50:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 02-03-2016 / 21:30:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

example04: gc <example: '04 - PNG with alpha II'>
"
Shows a another PNG image with alpha over a pattern.
"     
| image |

gc paint: Color white.
gc fillRectangleX:1 y:1 width: 32 height: 32.

gc paint: Color black.
gc fillRectangleX:33 y:33 width: 32 height: 32.

image := Image fromFile: 'circle1.png' inPackage: 'stx:goodies/libcairo'.
image displayOn: gc x: 1 y: 1.

    "Created: / 28-02-2016 / 14:49:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 02-03-2016 / 21:30:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

example05: gc <example: '05 - Checkerboard'>
"
Display a 8x8 checker board.
Try to zoom it to 800%, you'll see that native GC
(DeviceGraphicsContext) does the scaling wrong:
the corners of squares do not quote touch. Indeed,
Cairo does it right.
"
| black white |

black := Color black.
white := Color white.

1 to: 8 do:[:x |
    1 to: 8 do:[:y |  
        gc paint: ((x + y) even ifTrue:[ black ] ifFalse:[ white ]).
        gc fillRectangleX: ((x - 1) * 32) + 1
                        y: ((y - 1) * 32) + 1
                    width: 32 height: 32.        
    ]
].

    "Created: / 28-02-2016 / 15:06:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 29-02-2016 / 18:42:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

example06: gc <example: '06 - Transparency'>
"
Shows half-transparent rounded rectangle over a
black-n-white checker board. Rounded corners are
antialiased for better look.
"
| black white |

black := Color black.
white := Color white.

1 to: 8 do:[:x |
    1 to: 8 do:[:y |  
        gc paint: ((x + y) even ifTrue:[ black ] ifFalse:[ white ]).
        gc fillRectangleX: ((x - 1) * 32) + 1
                        y: ((y - 1) * 32) + 1
                    width: 32 height: 32.        
    ]
].
gc lineWidth: 10.
gc paint: (Color red alpha: 0.75).
gc displayRoundRectangleX: 16 y: 16 width: 32 * 7 height: 32 * 7
   wCorner: 16 hCorner: 16.
gc paint: (Color blue alpha: 0.50).
gc fillRoundRectangleX: 16 y: 16 width: 32 * 7 height: 32 * 7
   wCorner: 16 hCorner: 16.

    "Created: / 29-02-2016 / 18:38:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-02-2016 / 20:40:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

example07: gc <example: '07 - Mask - 1bit'>
"
Shows displaying lines and rectangles with
mask.
"
| mask |

mask := Image width:2 height:2 fromArray:#[2r10000000 
                                           2r01000000].      
gc paint: Color red.
gc mask: mask asImage.
gc lineWidth: 1.
gc displayLineFromX: 10 y: 10 toX: 90 y: 10.
gc displayLineFromX: 10 y: 10 toX: 10 y: 90.

mask := Image width:16 height:16 fromArray:#[2r11110000 2r11110000
                                             2r11110000 2r11110000
                                             2r11110000 2r11110000
                                             2r11110000 2r11110000
                                             2r00001111 2r00001111
                                             2r00001111 2r00001111
                                             2r00001111 2r00001111
                                             2r00001111 2r00001111
                                             2r11110000 2r11110000
                                             2r11110000 2r11110000
                                             2r11110000 2r11110000
                                             2r11110000 2r11110000
                                             2r00001111 2r00001111
                                             2r00001111 2r00001111
                                             2r00001111 2r00001111
                                             2r00001111 2r00001111].
gc paint: Color blue.
gc maskOrigin: 4@4.
gc mask: mask asImage.
gc fillRectangleX: 30 y: 30 width: 40 height: 40.

    "Created: / 07-03-2016 / 21:40:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-03-2016 / 21:42:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Examples2 methodsFor:'private'!

performTest
    cairoify := false.
    self performTestDrawingView: view.
    cairoify := true.
    self performTestDrawingView: view.
    cairoify := nil.

    "Created: / 26-02-2016 / 22:01:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-03-2016 / 13:06:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

performTestDrawingView: aView
    cairoify ifTrue:[ 
        | dGC cGC |

        view topView label: 'Cairo - ' , self name.    
        dGC := view instVarNamed: #gc.
        cGC := CairoGraphicsContext onDeviceGraphicsContext: dGC.
        [
            view instVarNamed: #gc put: cGC.    
            self perform: testSelector sunitAsSymbol with: aView.
        ] ensure:[ 
            view instVarNamed: #gc put: dGC.    
            cGC destroyCR.
        ].                  
    ] ifFalse:[ 
        view topView label: 'Native - ' , self name.    
        self perform: testSelector sunitAsSymbol with: aView.
    ].

    "Created: / 01-03-2016 / 13:03:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-03-2016 / 20:16:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Examples2 methodsFor:'utilities'!

screenshotFilename
    ^ super screenshotFilename 
            , (cairoify == true ifTrue:[ '_cairo' ] ifFalse:[ '_native' ]).

    "Created: / 01-03-2016 / 21:39:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeScreenshotsInDirectory:directory 
    cairoify := false.
    super writeScreenshotsInDirectory:directory.
    cairoify := true.
    super writeScreenshotsInDirectory:directory.
    cairoify := nil.

    "
     (Cairo::Examples2 selector: #example06:) writeScreenshotsInDirectory: '/tmp'
    "

    "Created: / 01-03-2016 / 13:11:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-03-2016 / 17:19:05 / jv"
    "Modified (comment): / 01-03-2016 / 21:48:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Examples2 methodsFor:'utilities - markdown'!

writeMarkdownOutputOn: aStream
    | name base |

    name := self name.
    base := super screenshotFilename."/ use super here so we wong get "_cairo" or "_native" suffix here
    aStream nextPutAll: 'Output'; cr; cr.
    aStream nextPutAll: '| '.
    #(windows linux) do:[:os |
        #(cairo native) do:[:type |
            self writeMarkdownLinkTo: ('%1_%2_%3_100.png' bindWith: base with: type with: os) text: ('%2, %3' bindWith: name with: os capitalized with: type capitalized) on: aStream.
            aStream space.
            aStream nextPut: $(.
            self writeMarkdownLinkTo: ('%1_%2_%3_800.png' bindWith: base with: type with: os) text: '800%' on: aStream.
            aStream nextPut: $).
            aStream nextPutAll: ' | '
        ]
    ].
    aStream cr; cr.                                                                                                                   
    self writeMarkdownLinkTo: ('%1_cairo_windows_100.png' bindWith: base) text: name , ' - Cairo' inline: true on: aStream.
    aStream space.
    self writeMarkdownLinkTo: ('%1_native_windows_100.png' bindWith: base) text: name, ' - Native'  inline: true on: aStream.
    aStream cr; cr.

    "Modified: / 02-03-2016 / 22:30:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Examples2 class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

