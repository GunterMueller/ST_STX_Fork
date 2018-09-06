"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

AbstractExamples subclass:#Examples1
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Cairo-Examples'
!


!Examples1 methodsFor:'examples'!

example01: cr <example: '01 - arc'>
| xc yc radius angle1 angle2 |

xc := 128.
yc := 128.
radius := 100.
angle1 := 45 * (Float pi / 180).
angle2 := 180 * (Float pi / 180).

cr sourceR: 1.0 G: 1.0 B: 1.0.
cr lineWidth: 10.
cr arcX: xc y: yc radius: radius from: angle1 to: angle2.
cr stroke.

    "Created: / 26-02-2016 / 21:53:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

example21: cr <example: '21 - Display PNG from file'>
| png |

png := Cairo::Surface newPNGWithFile: (Smalltalk getBitmapFileName:'circle1.png' forPackage:#'stx:goodies/libcairo') pathName.

cr sourceR: 1 G: 1 B: 1.
cr rectangleX: 0 y: 0 width: 32 height: 32.
cr fill.

cr sourceR: 0 G: 0 B: 0.
cr rectangleX: 32 y: 32 width: 32 height: 32.
cr fill.

cr sourceSurface: png x: 0 y: 0.
cr paint.

    "Created: / 28-02-2016 / 07:56:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

example22: cr <example: '22 - Rectangles - fill and stroke'>
"
Shows how stroke,fill and lineWidth plays together
"
cr lineWidth: 1.
cr sourceR: 0 G: 0 B: 0.
cr moveToX: 1   y: 15.
cr lineToX: 130 y: 15.
cr moveToX: 15  y: 1.
cr lineToX: 15  y: 130.
cr moveToX: 1   y: 115.
cr lineToX: 130 y: 115.
cr moveToX: 115 y: 1.
cr lineToX: 115 y: 130.
cr stroke.

cr lineWidth: 10.
cr sourceR: 1 G: 0 B: 0.
cr rectangleX: 15 y: 15 width: 100 height: 100.
cr stroke.

cr sourceR: 0 G: 0 B: 1.
cr rectangleX: 15 y: 65 width: 50 height: 50.
cr fill.

    "Created: / 28-02-2016 / 15:09:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-03-2016 / 21:10:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

example24: cr <example: '24 - Transparency'>
"
Shows half-transparent rounded rectangle over a
black-n-white checker board. Rounded corners are
antialiased for better look.
"
| black white x y w h r pi |

"Display s checker board"
black := Color black.
white := Color white.
cr lineWidth:0.
1 to: 8 do:[:x |
    1 to: 8 do:[:y |  
        cr source: ((x + y) even ifTrue:[ black ] ifFalse:[ white ]).
        cr rectangleX: ((x - 1) * 32) + 1
                    y: ((y - 1) * 32) + 1
                width: 32 
               height: 32.        
        cr fill.
    ]
].

"Show 50% transparent blue rectangle with 25% transparent
 red border. First, create the path:"
x := 16.
y := 16.
w := 32 * 7.
h := 32 * 7.
r := 8.
pi := Float pi.
"top-left arc"
cr arcX: x + r     y: y + r     radius: r from:         pi to: (3/2) * pi.
" top-right arc"
cr arcX: x + w - r y: y + r     radius: r from: (3/2) * pi to: 0.0.
"bottom-right arc"
cr arcX: x + w - r y: y + h - r radius: r from: 0.0        to: (1/2) * pi.
"bottom-left atc"
cr arcX: x + r     y: y + h - r radius: r from: (1/2) * pi to:         pi.
cr closePath.

"Show the border"
cr lineWidth: 10.  
cr sourceR: 1 G: 0 B: 0 A: 0.75.
cr strokeAndPreserve.
cr sourceR: 0 G: 0 B: 1 A: 0.5.
cr fill.

    "Created: / 29-02-2016 / 18:45:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

example25: cr <example: '25 - Linear Gradient 1'>
"
This shows a linear gradient
"
| gradient |

gradient := Cairo::Pattern linearFromX: 32 y: 32 toX: (32*6) y: (32*6).
gradient addColor: (Color redByte:191 greenByte: 217 blueByte: 224)
           stopAt: 0.0.
gradient addColor: (Color redByte:2 greenByte: 96 blueByte: 122)
           stopAt: 1.0.
cr source: (Color redByte:2 greenByte: 96 blueByte: 122).
cr lineWidth: 3.
cr rectangleX: 16  y: 16 width: (32*7)  height: (32*7).
cr strokeAndPreserve.
cr source: gradient.
cr fill.

    "Created: / 21-03-2016 / 22:27:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

example26: cr <example: '26 - Linear Gradient 2'>
"
Color stops in gradient patterns may have alpha as well!!
This shows a linear gradient with first stop being %80 
opaque.
"
| black white gradient |

"Display s checker board"
black := Color black.
white := Color white.
cr lineWidth:0.
1 to: 8 do:[:x |
    1 to: 8 do:[:y |  
        cr source: ((x + y) even ifTrue:[ black ] ifFalse:[ white ]).
        cr rectangleX: ((x - 1) * 32) + 1
                    y: ((y - 1) * 32) + 1
                width: 32 
               height: 32.        
        cr fill.
    ]
].

gradient := Cairo::Pattern linearFromX: 16 y: 32 * 4 toX: (32*8) - 16 y: 32*4.
gradient addColor: ((Color redByte:191 greenByte: 217 blueByte: 224) alpha: 0.80)
           stopAt: 0.0.
gradient addColor: ((Color redByte:2 greenByte: 96 blueByte: 122) alpha: 1.0)
           stopAt: 1.0.
cr source: (Color redByte:2 greenByte: 96 blueByte: 122).
cr lineWidth: 3.
cr rectangleX: 16  y: 16 width: (32*7)  height: (32*7).
cr strokeAndPreserve.
cr source: gradient.
cr fill.

    "Created: / 21-03-2016 / 22:25:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 22-03-2016 / 16:13:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

example27: cr <example: '27 - Text as path'>
"
Shows text rendered with black outline and filled
with 80% opaque gradient.
"
| text extents gradient |
text := 'cairo graphics'.
cr font: 'Helvetica' slant: Cairo::FontSlant CAIRO_FONT_SLANT_NORMAL weight: Cairo::FontWeight CAIRO_FONT_WEIGHT_NORMAL.
cr fontSize: 100.
extents := cr textExtents: text.
cr moveToX: 10 y: extents height + 10.
cr rotate: 0.3.
cr textToPath: text.
cr source: Color black.
cr strokeAndPreserve.
gradient := Cairo::Pattern linearFromX: 10 y: 0 toX: extents width + 10 y: 0.
gradient addColor: ((Color red:95.294117647058826 green:60.0 blue:7.8431372549019605) alpha: 0.8)
           stopAt: 0.
gradient addColor: ((Color red:95.294117647058826 green:60.0 blue:7.8431372549019605) darker alpha: 0.6)
           stopAt: 1.
cr source: gradient.
cr fill.

    "Created: / 22-03-2016 / 16:16:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Examples1 methodsFor:'private'!

performTest
    self performTestDrawingView: view

    "Created: / 26-02-2016 / 22:01:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-03-2016 / 10:59:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

performTestDrawingView: aView
    | cr |
    cr := Cairo::GraphicsContext onSurface: aView cairoSurface.
    view transformation notNil ifTrue:[ 
        cr scale: view transformation scale.
        cr translate: view transformation translation.
    ].
    [
        self perform:testSelector sunitAsSymbol with:cr.
    ] ensure:[ 
        cr release
    ].

    "Created: / 01-03-2016 / 10:57:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Examples1 methodsFor:'utilities - wiki'!

writeMarkdownOutputOn: aStream
    | name base |

    name := self name.
    base := self screenshotFilename.
    aStream nextPutAll: 'Output'; cr; cr.
    aStream nextPutAll: '| '.
    #(windows linux) do:[:os |
        self writeMarkdownLinkTo: ('%1_%2_100.png' bindWith: base with: os) text: ('%2' bindWith: name with: os capitalized) on: aStream.
        aStream space.
        aStream nextPut: $(.
        self writeMarkdownLinkTo: ('%1_%2_800.png' bindWith: base with: os) text: '800%' on: aStream.
        aStream nextPut: $).
        aStream nextPutAll: ' | '.
    ].
    aStream cr; cr.
    self writeMarkdownLinkTo: ('%1_windows_100.png' bindWith: base) text: name inline: true on: aStream.
    aStream cr; cr.

    "Created: / 01-03-2016 / 22:12:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-03-2016 / 22:29:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Examples1 class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

