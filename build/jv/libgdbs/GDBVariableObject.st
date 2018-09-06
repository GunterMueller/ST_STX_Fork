"{ Encoding: utf8 }"

"
jv:libgdbs - GNU Debugger Interface Library
Copyright (C) 2015-now Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'jv:libgdbs' }"

"{ NameSpace: Smalltalk }"

GDBDebuggerObject subclass:#GDBVariableObject
	instanceVariableNames:'parent name exp path thread frame value type numchild has_more
		children changed inScope visualizer dynamic'
	classVariableNames:'GdbDefaultVisualizer'
	poolDictionaries:''
	category:'GDB-Core'
!

!GDBVariableObject class methodsFor:'documentation'!

copyright
"
jv:libgdbs - GNU Debugger Interface Library
Copyright (C) 2015-now Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!GDBVariableObject class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    GdbDefaultVisualizer := 'gdb.default_visualizer'

    "Modified: / 04-06-2018 / 15:48:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBVariableObject class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!GDBVariableObject class methodsFor:'accessing - GDB value descriptors'!

description
    ^ (super description)
        define:#name as:String;
        define:#numchild as:Integer;
        define:#value as:String;
        define:#type as:String;
        define:#'thread-id' as:Integer;
        define:#has_more as:Boolean;
        define:#dynamic as:Boolean;
        define:#displayhint as:String;
        yourself

    "Created: / 16-09-2014 / 23:59:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-02-2015 / 17:10:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBVariableObject methodsFor:'accessing'!

children
    self isValid ifFalse:[ ^ #() ].
    children isNil ifTrue:[ 
        (self isValid and:[has_more or:[ numchild isNil or:[numchild > 0]]]) ifTrue:[
            | result |

            result := debugger send: (GDBMI_var_list_children arguments: (Array with: '--all-values' with: name)).
            children := (result propertyAt: #children) ? #().
            children do:[:each | each setDebugger: debugger; setParent: self ].
            numchild := children size.
        ] ifFalse:[ 
            children := #().
        ].
    ].
    ^ children

    "Created: / 27-01-2018 / 22:53:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-06-2018 / 10:57:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

expression
    "Return the expression in target language to access the value (asDtring)
     The expression is relative to it's direct parent (if any),

     For example, consider

         typedef struct _point {
            int x;
            int y;
         } point;
         ...
         point p1 = { 10, 20 };

     and consider a variable object `o` that represents `y` member of point 
     `p1`. Then:

        o path '/ -> 'p1.y'

    while

        p expression '/ -> 'y'
    "

    ^ exp

    "Created: / 28-01-2018 / 21:36:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 05-02-2018 / 21:16:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

frame
    "If a variable object is bound to a specific thread and frame,
     returns that frame (as `GDBFrame`). Otherwise, return `nil`."

    parent notNil ifTrue:[ 
        self assert: frame isNil.
        ^ parent frame
    ].
    ^ frame.

    "Created: / 13-02-2018 / 21:25:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-02-2018 / 09:30:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

id
    "Returns the GDB ID (name) of the variable object. This is
    used in commands to identify a variable object instance."

    ^ name

    "Created: / 28-01-2018 / 21:35:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

index
    "Return the index of receiver within parent's children
     or `nil` if receiver is not a child varobj."

    parent isNil ifTrue:[ ^ nil ].
    ^ parent children indexOf: self.

    "Created: / 04-06-2018 / 15:01:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parent
    ^ parent
!

path
    "Return (absolute) expression in target language to access the value 
     (asDtring).

     For example, consider

         typedef struct _point {
            int x;
            int y;
         } point;
         ...
         point p1 = { 10, 20 };

     and consider a variable object `o` that represents `y` member of point 
     `p1`. Then:

        o path '/ -> 'p1.y'

    while

        p expression '/ -> 'y'

    "

    "/ Raise an error early when #path is requested for a child of dynamic
    "/ varobj. Thie is not supported by GDB.
    "/ 
    "/ Although GDB should report an error [1], dur to a bug it report
    "/ either wrong (nonsense) value or crashes. A patch has been send
    "/ to the upstream [2], but meanwhile, check here as well in case someone
    "/ uses this with older / not yet patches version of GDB.
    "/ 
    "/ [1]: https://sourceware.org/gdb/onlinedocs/gdb/GDB_002fMI-Variable-Objects.html
    "/ [2]: https://sourceware.org/ml/gdb-patches/2018-06/msg00058.html
    "/ 
    (parent notNil and:[parent isDynamic]) ifTrue:[ 
        GDBError raiseErrorString: 'Invalid varobj, #path is not supported for children of a dynamic varobjs'.
        ^ self
    ].

    path isNil ifTrue:[ 
        | result |

        result := debugger send: (GDBMI_var_info_path_expression arguments: (Array with: name)).
        path := result propertyAt: #'path_expr'.
    ].
    ^ path

    "Created: / 05-02-2018 / 21:16:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-06-2018 / 16:31:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 04-06-2018 / 14:19:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

thread
    "
    If a variable object is bound to a specific thread, returns
    that thread (as GDBThread). Otherwise, `nil` is returned.
    "
    | threadId |
    thread isInteger ifTrue:[ 
        threadId := thread.
        thread := debugger threadForId: threadId.
    ].
    ^ thread

    "Created: / 04-02-2018 / 21:35:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2018 / 18:38:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

type
    ^ type
!

value
    changed value. "/ to force update if necessary
    self isValid ifFalse:[ ^ self class classResources string: '<invalid>' ].
    self inScope ifFalse:[ ^ self class classResources string: '<out-of-scope>' ].
    ^ value

    "Modified: / 12-02-2018 / 22:00:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

valueFormatted: aGDBOutputFormat
    "Return the value formatted using given format (as String)

    Supported formats are:
        * FormatSignedDecimal
        * FormatHexadecimal
        * FormatOctal
        * FormatPaddedHexadecimal

    To get the value in 'natural' format use plain #value 
    rather than #valueFormatted:
    "

    | format result |

    aGDBOutputFormat == FormatBinary ifTrue:[ 
        format := 'binary'
    ] ifFalse:[aGDBOutputFormat == FormatSignedDecimal ifTrue:[ 
        format := 'decimal'
    ] ifFalse:[aGDBOutputFormat == FormatHexadecimal ifTrue:[ 
        format := 'hexadecimal'
    ] ifFalse:[aGDBOutputFormat == FormatOctal ifTrue:[ 
        format := 'octal'
    ] ifFalse:[aGDBOutputFormat == FormatPaddedHexadecimal ifTrue:[ 
        format := 'zero-hexadecimal'
    ] ifFalse:[ 
        GDBError raiseErrorString: 'Unsupported format: ', aGDBOutputFormat displayString  
    ]]]]].

    "/ If pretty printing in MI is enabled, GDB seems to ignore the -f arguments. To work arround
    "/ this, reset the visualizer to None, print the value and then set it back to default.
    "/ Pretty ugly, sigh.
    ^ [
        debugger isPrettyPrintingEnabled ifTrue:[ 
            debugger send: (GDBMI_var_set_visualizer arguments: (Array with: name with: 'None')) andWait: false.
        ].
        result := debugger send: (GDBMI_var_evaluate_expression arguments: (Array with: '-f' with: format with: name)).
        result value
    ] ensure:[ 
        debugger isPrettyPrintingEnabled ifTrue:[ 
            debugger send: (GDBMI_var_set_visualizer arguments: (Array with: name with: 'gdb.default_visualizer')) andWait: false.
        ].
    ].

    "Created: / 05-02-2018 / 23:34:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-02-2018 / 14:04:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 07-02-2018 / 16:03:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visualizer
    "Return the current visualizer used for the variable object.

     See https://sourceware.org/gdb/onlinedocs/gdb/GDB_002fMI-Variable-Objects.html
    "
    debugger isPrettyPrintingEnabled ifFalse:[ 
        ^ 'None' 
    ].
    visualizer isNil ifTrue:[
        ^ GdbDefaultVisualizer
    ].
    ^ visualizer

    "Created: / 13-02-2018 / 23:18:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-06-2018 / 15:48:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visualizer: aString
    "Set a visualizer for the variable object. `aString` is the 
     visualizer to use. The special value ‘None’ means to disable 
     any visualizer in use.

     If not ‘None’, `aString` must be a Python expression. This expression 
     must evaluate to a callable object which accepts a single argument.

     See https://sourceware.org/gdb/onlinedocs/gdb/GDB_002fMI-Variable-Objects.html
    "
    |result |

    self assert: (debugger isPrettyPrintingEnabled or:[ aString = 'None' ]).
    self visualizer = aString ifTrue:[ 
        "/ Already set, no need to do anything.    
        ^ self 
    ].
    result := debugger send: (GDBMI_var_set_visualizer arguments: (Array with: name with: aString)) andWait: true.
    result isDone ifTrue:[ 
        visualizer := aString.
        "/ Since we have changed the visualizer, children 
        "/ may have changed too. Delete them and recreate 
        "/ them on demand (see #children)
        numchild := nil.
        children notNil ifTrue:[ 
            children do:[:child | child release ].
            children := nil.  
        ].
    ].

    "Created: / 13-02-2018 / 23:20:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-02-2018 / 15:44:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBVariableObject methodsFor:'copying'!

duplicate
    "Create and returns a duplicate of the receiver, representing
     the same value. Other than that the returned duplicate is completely 
     independent"

    | dup |

    "/ For children of non-dynamic varobjs duplication is done
    "/ by evaluating its "path" (a fully rooted expression) and 
    "/ returning the new varobj.
    "/ 
    "/ For children of **dynamic** varobjs, this is however more tricky.
    "/ They have no "path". Thus, we first duplicate the parent and then 
    "/ return child of the just duplicated parent at corresponding index.
    (self parent isNil or:[ self parent isDynamic not ]) ifTrue:[ 
        "/ Easy, evaluate path expression...
        dup := debugger evaluate: self path in: self frame
    ] ifFalse:[
        | dupParent |

        dupParent := self parent duplicate.
        dup := dupParent children at: self index.
    ].
    "/ Make sure the duplicate has the same visualizer
    debugger isPrettyPrintingEnabled ifTrue:[ 
        self visualizer ~= GdbDefaultVisualizer ifTrue:[ 
            dup visualizer: self visualizer
        ].
    ].
    ^ dup

    "Created: / 13-02-2018 / 22:17:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-06-2018 / 15:50:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBVariableObject methodsFor:'displaying'!

displayOn: aStream
    self displayOn: aStream indent: 0

    "Created: / 28-01-2018 / 21:40:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

displayOn: aStream indent: anInteger
    aStream next: anInteger * 4 put: Character space.
    aStream nextPutAll: exp; space; nextPut: $=; space.
    self hasChildren ifTrue:[ 
        aStream nextPut:${; cr.
        self children do:[:each | 
            each displayOn: aStream indent: anInteger + 1.
            aStream cr.
        ].
        aStream next: anInteger * 4 put: Character space; nextPut:$}.
    ] ifFalse: [ 
        aStream nextPutAll: value
    ].

    "Created: / 28-01-2018 / 21:42:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBVariableObject methodsFor:'finalization'!

executor
    ^ GDBVariableObjectExecutor new 
            setDebugger: debugger;
            setId: name;
            yourself

    "Created: / 28-01-2018 / 23:27:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

finalizationLobby
    self assert: debugger notNil.
    ^ debugger finalizationRegistry.

    "Created: / 28-01-2018 / 23:21:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBVariableObject methodsFor:'initialization & release'!

initialize
    "Invoked when a new instance is created."

    super initialize.
    inScope := true.
    dynamic := false.
    has_more := true.

    "Modified: / 04-06-2018 / 10:55:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

release
    "Releases the variable object and all its children. Once released, 
     the variable object is invalid (i.e., `#isValid` would return `false`) 
     and should not be used anymore."

    self release: true

    "Created: / 04-02-2018 / 23:21:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-02-2018 / 09:37:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

release: delete
    "Releases the variable object and all its children. If 
     `delete` is `true`, send `-var-delete`."

    self assert: debugger notNil.
    self assert: (delete not or:[ parent isNil ]) description: 'Only top-level objects can be deleted (for now)'.

    "/ Release all children first, but not not 'delete' them 
    "/ in GDB (will be done later)
    children notEmptyOrNil ifTrue:[ 
        children do: [ :child | child release:false ].
    ].
    children := nil.
    changed := [ changed := false. true ]. 

    "/ Now 'delete' the variable and all its children
    "/ in GDB
    delete ifTrue:[ 
        self unregisterForFinalization.
        debugger isConnected ifTrue:[
            debugger send: (GDBMI_var_delete arguments: (Array with: name))
        ].
    ].

    "/ Finally, clear the debugger instvar (it's tested in
    "/ `#isValid`
    debugger := nil.

    "Created: / 13-02-2018 / 09:36:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-02-2018 / 23:42:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"

!

setDebugger: aGDBDebugger
    super setDebugger: aGDBDebugger.
    aGDBDebugger notNil ifTrue:[
        changed := GDBTransientDataHolder debugger: debugger factory: [ self updateChanged ].
    ].

    "Created: / 01-02-2018 / 09:29:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setExpression: aString
    exp := aString

    "Created: / 28-01-2018 / 21:39:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setFrame: aGDBBrame
    frame := aGDBBrame

    "Created: / 15-02-2018 / 09:29:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setFrameId: aString
    frame := aString

    "Created: / 13-02-2018 / 21:24:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setParent: variableObjectOrNil
    self assert: (variableObjectOrNil isNil or:[ variableObjectOrNil isKindOf: self class ]).
    self assert: debugger notNil.
    parent := variableObjectOrNil

    "Created: / 27-01-2018 / 22:54:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-02-2018 / 22:02:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

thread_id: anInteger
    thread := anInteger

    "Created: / 04-02-2018 / 21:25:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


!GDBVariableObject methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPutAll:'('.
    value printOn: aStream.
    aStream nextPutAll:')'.

    "Created: / 13-06-2017 / 17:03:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBVariableObject methodsFor:'queries'!

hasChanged
    ^ changed value

    "Created: / 30-01-2018 / 00:27:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-02-2018 / 22:16:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasChildren
    self isValid ifFalse:[ ^ false ].
    numchild isNil ifTrue:[
        children := nil.
        ^ self children notEmptyOrNil
    ].
    ^ numchild > 0

    "Created: / 27-01-2018 / 22:47:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-02-2018 / 13:40:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBVariableObject methodsFor:'testing'!

inScope
   changed value. "/ to force update if necessary
    ^ inScope

    "Created: / 12-02-2018 / 21:56:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isDynamic
    "Return true, if this varobj is a dynamic varobj, false otherwise"

    ^ dynamic

    "Created: / 01-06-2018 / 16:29:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isValid
    changed value. "/ to force update if necessary
    ^ debugger notNil

    "Created: / 04-02-2018 / 21:33:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2018 / 22:28:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parentIsDynamic
    ^ parent notNil and:[ parent parentIsDynamic or: [ parent isDynamic ] ]

    "Created: / 01-09-2018 / 22:52:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-09-2018 / 11:32:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBVariableObject methodsFor:'updating'!

updateChanged
    "Check for updates and update all changed variables accordingly."

    debugger isNil ifTrue:[ 
        changed := false.
        ^ false.
    ].
    (self thread notNil and:[ self thread isValid not]) ifTrue:[ 
        self release.
        ^ true
    ].

    parent notNil ifTrue:[ 
        parent updateChanged
    ] ifFalse:[
        | result changelist |

        result := debugger send: (GDBMI_var_update arguments: (Array with: '--all-values' with: name)).
        changelist := result propertyAt: #changelist.
        self updateChanged: changelist.        
    ].
    ^ false

    "Created: / 30-01-2018 / 01:08:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2018 / 23:09:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateChanged: changelist
    | change |

    changelist isEmptyOrNil ifTrue:[ ^ self ].
    change := changelist detect: [ :each | each id = self id ] ifNone:[nil].
    change notNil ifTrue:[ 
        value := change value.
        inScope := change inScope.
        inScope = 'invalid' ifTrue:[ 
            self release.
            ^ self.
        ].
        changed value: true.
        changelist remove: change.
        changelist isEmptyOrNil ifTrue:[ ^ self ].
    ] ifFalse:[ 
        changed value: false.
    ].
    children notEmptyOrNil ifTrue:[ 
        children do: [ :each | each updateChanged: changelist ]
    ].

    "Created: / 30-01-2018 / 01:09:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2018 / 22:29:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBVariableObject class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


GDBVariableObject initialize!
