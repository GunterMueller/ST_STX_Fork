"
 Copyright (c) 2007-2010 Jan Vrany
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
"{ Package: 'stx:libsvn' }"

"{ NameSpace: SVN }"

Dialog subclass:#CredentialsDialog
	instanceVariableNames:'savePasswordHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-UI-Dialogs'
!

!CredentialsDialog class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany
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

!CredentialsDialog class methodsFor:'interface specs'!

contentSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::CredentialsDialog andSelector:#dialogSpec
     SVN::CredentialsDialog new openInterface:#dialogSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: dialogSpec
        window: 
       (WindowSpec
          label: 'Dialog'
          name: 'Dialog'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 424 345)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Username:'
              name: 'UsernameLabel'
              layout: (LayoutFrame 0 0 -34 0.5 100 0 -14 0.5)
              translateLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'Username'
              layout: (LayoutFrame 110 0 -40 0.5 -5 1 -15 0.5)
              model: usernameAspect
              immediateAccept: true
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: true
              acceptOnPointerLeave: false
            )
           (LabelSpec
              label: 'Password:'
              name: 'PasswordLabel'
              layout: (LayoutFrame 0 0 0 0.5 100 0 25 0.5)
              translateLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'Password'
              layout: (LayoutFrame 110 0 -5 0.5 -5 1 20 0.5)
              model: passwordAspect
              type: password
              immediateAccept: true
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: true
              acceptOnPointerLeave: false
            )
           (CheckBoxSpec
              label: 'Save password'
              name: 'SavePassword'
              layout: (LayoutFrame 110 0 25 0.5 -5 1 55 0.5)
              model: savePasswordHolder
              translateLabel: true
            )
           )
         
        )
      )

    "Created: / 21-10-2008 / 12:37:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CredentialsDialog class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!CredentialsDialog methodsFor:'accessing'!

savePassword
    "return the value in 'savePasswordHolder'"

    ^ self savePasswordHolder value

    "Created: / 03-10-2008 / 14:39:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

savePassword: newValue
    "set the value in 'savePasswordHolder'"

    self savePasswordHolder value: newValue

    "Created: / 03-10-2008 / 14:39:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CredentialsDialog methodsFor:'accessing - defaults'!

defaultModel
    "Superclass SVN::Dialog says that I am responsible to implement this method"
    
    ^Credentials new

    "Created: / 03-10-2008 / 14:58:09 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

defaultTitle
    "Superclass SVN::Dialog says that I am responsible to implement this method"
    
    ^'Credentials'

    "Created: / 03-10-2008 / 13:58:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CredentialsDialog methodsFor:'aspects'!

passwordAspect

    ^(AspectAdaptor forAspect: #password)
        subjectChannel: self modelHolder

    "Created: / 03-10-2008 / 14:56:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

savePasswordHolder
    "return/create the valueHolder 'savePasswordHolder'"

    savePasswordHolder isNil ifTrue:[
        savePasswordHolder := ValueHolder with:true "defaultValue here".
    ].
    ^ savePasswordHolder

    "Created: / 03-10-2008 / 14:39:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

usernameAspect

    ^(AspectAdaptor forAspect: #username)
        subjectChannel: self modelHolder;
        onChangeSend: #usernameChanged to: self;
        yourself

    "Created: / 03-10-2008 / 14:56:31 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CredentialsDialog methodsFor:'change & update'!

usernameChanged
    self acceptEnabled:(self usernameAspect value isNilOrEmptyCollection not)
! !

!CredentialsDialog methodsFor:'hooks'!

commonPostOpen

    self usernameChanged

    "Created: / 03-10-2008 / 17:57:32 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CredentialsDialog class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__CredentialsDialog.st 363 2011-08-08 13:49:48Z vranyj1 §'
! !
