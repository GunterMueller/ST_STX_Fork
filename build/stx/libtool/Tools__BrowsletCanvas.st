"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

ApplicationModel subclass:#BrowsletCanvas
	instanceVariableNames:'browsletHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-Browslets'
!

!BrowsletCanvas class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
! !

!BrowsletCanvas class methodsFor:'image specs'!

closeBrowsletIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self closeBrowsletIcon inspect
     ImageEditor openOnClass:self andSelector:#closeBrowsletIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'Tools::NewSystemBrowser class closeBrowsletIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 1 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'
O?1@A,@C @FLLX91!!>FC0XOA!!>FN\X01 @G@@6@FO?0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

hideBrowsletIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self hideBrowsletIcon inspect
     ImageEditor openOnClass:self andSelector:#hideBrowsletIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'Tools::NewSystemBrowser class hideBrowsletIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 1 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'
O?1@A,@C @FL@X<A#<FO<X?1#<FO@X0A @G@@6@FO?0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

popupBrowsletIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self popupBrowsletIcon inspect
     ImageEditor openOnClass:self andSelector:#popupBrowsletIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'BrowsletCanvas class popupBrowsletIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 1 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'
O?1@A,@C @F@@X?1#?FG8X_!! <FC0XFA XG@@6@FO?0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

showBrowsletIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self showBrowsletIcon inspect
     ImageEditor openOnClass:self andSelector:#showBrowsletIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'Tools::NewSystemBrowser class showBrowsletIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 1 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'
O?1@A,@C @F@LXC1 ?FO<X?1 ?F@<X@1 @G@@6@FO?0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
! !

!BrowsletCanvas class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:BrowsletCanvas andSelector:#windowSpec
     BrowsletCanvas new openInterface:#windowSpec
     BrowsletCanvas open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Browslet Canvas'
          name: 'Browslet Canvas'
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (TransparentBoxSpec
              name: 'Box'
              layout: (LayoutFrame 0 0 0 0 0 1 20 0)
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'popupBrowsletIcon'
                    name: 'Button1'
                    layout: (LayoutFrame 0 0 0 0 20 0 0 1)
                    level: 0
                    hasCharacterOrientedLabel: false
                    translateLabel: true
                    model: popupAction
                  )
                 (ActionButtonSpec
                    label: 'closeBrowsletIcon'
                    name: 'CloseButton'
                    layout: (LayoutFrame -20 1 0 0 0 1 0 1)
                    level: 0
                    hasCharacterOrientedLabel: false
                    translateLabel: true
                    model: closeAction
                  )
                 (LinkButtonSpec
                    label: '...'
                    name: 'Browslet'
                    layout: (LayoutFrame 25 0 0 0 -25 1 0 1)
                    translateLabel: true
                    adjust: left
                    model: popupAction
                  )
                 )
               
              )
            )
           (SubCanvasSpec
              name: 'Browslet'
              layout: (LayoutFrame 0 0 20 0 0 1 0 1)
              hasHorizontalScrollBar: false
              hasVerticalScrollBar: false
              clientHolder: browsletHolder
              createNewBuilder: false
            )
           )
         
        )
      )

    "Modified: / 04-10-2010 / 23:36:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BrowsletCanvas methodsFor:'actions'!

closeAction
    <resource: #uiCallback>

    | topApp |
    topApp := self masterApplication.
    topApp 
        ifNil:[self closeRequest] 
        ifNotNil:[topApp showPlugin: false]

    "Modified: / 04-10-2010 / 18:39:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

popupAction
    <resource: #uiCallback>

    | menu |
    menu := Menu new.
    (Browslet all asSortedCollection:[:a :b|a label < b label]) do:
        [ :browslet | | item |
        menu addItem:
            (MenuItem 
                    label: browslet label
                    itemValue: [ self show: browslet ])].
    menu showAtPointer.

    "Modified: / 04-10-2010 / 23:02:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BrowsletCanvas methodsFor:'aspects'!

browsletHolder
    "return/create the 'browsletHolder' value holder (automatically generated)"

    browsletHolder isNil ifTrue:[
        browsletHolder := ValueHolder new.
    ].
    ^ browsletHolder
! !

!BrowsletCanvas methodsFor:'private'!

show: browsletClass

    self browsletHolder value: browsletClass new

    "Created: / 04-10-2010 / 23:03:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BrowsletCanvas class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Tools__BrowsletCanvas.st,v 1.4 2014-05-23 08:17:51 stefan Exp $'
!

version_SVN
    ^ '$Id: Tools__BrowsletCanvas.st,v 1.4 2014-05-23 08:17:51 stefan Exp $'
! !

