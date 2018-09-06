"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
              All Rights Reserved

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

ApplicationModel subclass:#DiffCodeView2DemoApp
	instanceVariableNames:'view'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-CodeView'
!

!DiffCodeView2DemoApp class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
              All Rights Reserved

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

!DiffCodeView2DemoApp class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::DiffCodeView2DemoApp andSelector:#windowSpec
     Tools::DiffCodeView2DemoApp new openInterface:#windowSpec
     Tools::DiffCodeView2DemoApp open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'DiffCodeView2 Demo App'
          name: 'DiffCodeView2 Demo App'
          min: (Point 0 0)
          bounds: (Rectangle 0 0 748 375)
        )
        component: 
       (SpecCollection
          collection: (
           (NonScrollableArbitraryComponentSpec
              name: 'DiffCodeView2'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              component: diffCodeView2
            )
           )
         
        )
      )
! !

!DiffCodeView2DemoApp methodsFor:'accessing'!

text1

    ^
'
Line 1
Where is the difference?
Line 3
Line 4
Line 5
Some text to delete
'

    "Modified: / 22-06-2010 / 22:25:20 / Jakub <zelenja7@fel.cvut.cz>"
    "Created: / 01-08-2010 / 20:34:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

text2

    ^
'
Line 1
Here is the difference!!
Line 3
Line 3.5
Line 5
'

    "Created: / 06-03-2010 / 10:39:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-06-2010 / 22:25:20 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 16-03-2012 / 16:16:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DiffCodeView2DemoApp methodsFor:'accessing - views'!

diffCodeView2

    view := Diff2CodeView2 new.

"/    view text1: self text1 text2: self text2.
    ^view

    "Created: / 06-03-2010 / 10:38:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-03-2012 / 13:17:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DiffCodeView2DemoApp methodsFor:'hooks'!

commonPostOpen

    [ Delay waitForSeconds: 1.
    view text1: self text1 text2: self text2
    ] fork

    "Modified: / 08-07-2010 / 15:27:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DiffCodeView2DemoApp class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Tools__DiffCodeView2DemoApp.st,v 1.3 2014-02-05 18:58:40 cg Exp $'
!

version_SVN
    ^ '$Id: Tools__DiffCodeView2DemoApp.st,v 1.3 2014-02-05 18:58:40 cg Exp $'
! !

