"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010
"
"{ Package: 'stx:libjava' }"

"{ NameSpace: Smalltalk }"

Object subclass:#JavaDecompiler
	instanceVariableNames:'code pc javaMethod outStream classToCompileFor isStaticMethod
		lastConstIndex lastConstant accessedInstvars modifiedInstvars
		accessedStaticVars modifiedStaticVars sentMessages'
	classVariableNames:'DecoderTable'
	poolDictionaries:''
	category:'Languages-Java-Support-Decompiling'
!

!JavaDecompiler class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010

"
!

examples
"

                                                                        [exBegin]
    |m|

    m := JAVA::java::lang::Object compiledMethodAt:#'toString()Ljava/lang/String;'.
    JavaDecompiler decompile:m to:Transcript.
                                                                        [exEnd]



                                                                        [exBegin]
    |m|

    m := JAVA::java::lang::Object compiledMethodAt:#'toString()Ljava/lang/String;'.
    JavaDecompiler decompile:m to:nil.
                                                                        [exEnd]

"

! !

!JavaDecompiler class methodsFor:'initialization'!

initialize
    DecoderTable := #(
        (nop)                                   "/ 0
        (aconst_null)                           "/ 1
        (iconst_m1)                             "/ 2
        (iconst_0)                              "/ 3
        (iconst_1)                              "/ 4
        (iconst_2)                              "/ 5
        (iconst_3)                              "/ 6
        (iconst_4)                              "/ 7
        (iconst_5)                              "/ 8
        (lconst_0)                              "/ 9
        
        (lconst_1)                              "/ 10
        (fconst_0)                              "/ 11
        (fconst_1)                              "/ 12
        (fconst_2)                              "/ 13
        (dconst_0)                              "/ 14
        (dconst_1)                              "/ 15
        (bipush signedByte)                     "/ 16
        (sipush signedShort)                    "/ 17
        (ldc1 constIndexByte remember_ldc1)              "/ 18
        (ldc2 constIndexShort remember_ldc2)             "/ 19

        (ldc2w constIndexShort remember_ldc2w)            "/ 20
        (iload localIndexByte)                  "/ 21
        (lload localIndexByte)                  "/ 22
        (fload localIndexByte)                  "/ 23
        (dload localIndexByte)                  "/ 24
        (aload localIndexByte)                  "/ 25
        (iload_0)                               "/ 26
        (iload_1)                               "/ 27
        (iload_2)                               "/ 28
        (iload_3)                               "/ 29

        (lload_0)                               "/ 30
        (lload_1)                               "/ 31
        (lload_2)                               "/ 32
        (lload_3)                               "/ 33
        (fload_0)                               "/ 34
        (fload_1)                               "/ 35
        (fload_2)                               "/ 36
        (fload_3)                               "/ 37
        (dload_0)                               "/ 38
        (dload_1)                               "/ 39

        (dload_2)                               "/ 40
        (dload_3)                               "/ 41
        (aload_0)                               "/ 42
        (aload_1)                               "/ 43
        (aload_2)                               "/ 44
        (aload_3)                               "/ 45
        (iaload)                                "/ 46
        (laload)                                "/ 47
        (faload)                                "/ 48
        (daload)                                "/ 49

        (aaload)                                "/ 50
        (baload)                                "/ 51
        (caload)                                "/ 52
        (saload)                                "/ 53
        (istore localIndexByte)                 "/ 54
        (lstore localIndexByte)                 "/ 55
        (fstore localIndexByte)                 "/ 56
        (dstore localIndexByte)                 "/ 57
        (astore localIndexByte)                 "/ 58
        (istore_0)                              "/ 59

        (istore_1)                              "/ 60
        (istore_2)                              "/ 61
        (istore_3)                              "/ 62
        (lstore_0)                              "/ 63
        (lstore_1)                              "/ 64
        (lstore_2)                              "/ 65
        (lstore_3)                              "/ 66
        (fstore_0)                              "/ 67
        (fstore_1)                              "/ 68
        (fstore_2)                              "/ 69

        (fstore_3)                              "/ 70
        (dstore_0)                              "/ 71
        (dstore_1)                              "/ 72
        (dstore_2)                              "/ 73
        (dstore_3)                              "/ 74
        (astore_0)                              "/ 75
        (astore_1)                              "/ 76
        (astore_2)                              "/ 77
        (astore_3)                              "/ 78
        (iastore)                               "/ 79

        (lastore)                               "/ 80
        (fastore)                               "/ 81
        (dastore)                               "/ 82
        (aastore)                               "/ 83
        (bastore)                               "/ 84
        (castore)                               "/ 85
        (sastore)                               "/ 86
        (pop)                                   "/ 87
        (pop2)                                  "/ 88
        (dup)                                   "/ 89

        (dup_x1)                                "/ 90
        (dup_x2)                                "/ 91
        (dup2)                                  "/ 92
        (dup2_x1)                               "/ 93
        (dup2_x2)                               "/ 94
        (swap)                                  "/ 95
        (iadd)                                  "/ 96
        (ladd)                                  "/ 97
        (fadd)                                  "/ 98
        (dadd)                                  "/ 99

        (isub)                                  "/ 100
        (lsub)                                  "/ 101
        (fsub)                                  "/ 102
        (dsub)                                  "/ 103
        (imul)                                  "/ 104
        (lmul)                                  "/ 105
        (fmul)                                  "/ 106
        (dmul)                                  "/ 107
        (idiv)                                  "/ 108
        (ldiv)                                  "/ 109

        (fdiv)                                  "/ 110
        (ddiv)                                  "/ 111
"/        (imod)                                  "/ 112     "/ obsolete
        (irem)                                  "/ 112
"/        (lmod)                                  "/ 113     "/ obsolete
        (lrem)                                  "/ 113
"/        (fmod)                                  "/ 114     "/ obsolete
        (frem)                                  "/ 114
"/        (dmod)                                  "/ 115     "/ obsolete
        (drem)                                  "/ 115
        (ineg)                                  "/ 116
        (lneg)                                  "/ 117
        (fneg)                                  "/ 118
        (dneg)                                  "/ 119

        (ishl)                                  "/ 120
        (lshl)                                  "/ 121
        (ishr)                                  "/ 122
        (lshr)                                  "/ 123
        (iushr)                                 "/ 124
        (lushr)                                 "/ 125
        (iand)                                  "/ 126
        (land)                                  "/ 127
        (ior)                                   "/ 128
        (lor)                                   "/ 129

        (ixor)                                  "/ 130
        (lxor)                                  "/ 131
        (iinc localIndexByte signedByte)        "/ 132
        (i2l)                                   "/ 133
        (i2f)                                   "/ 134
        (i2d)                                   "/ 135
        (l2i)                                   "/ 136    
        (l2f)                                   "/ 137
        (l2d)                                   "/ 138
        (f2i)                                   "/ 139

        (f2l)                                   "/ 140
        (f2d)                                   "/ 141
        (d2i)                                   "/ 142
        (d2l)                                   "/ 143
        (d2f)                                   "/ 144
        (int2byte)                              "/ 145
        (int2char)                              "/ 146
        (int2short)                             "/ 147
        (lcmp)                                  "/ 148
        (fcmpl)                                 "/ 149

        (fcmpg)                                 "/ 150
        (dcmpl)                                 "/ 151
        (dcmpg)                                 "/ 152
        (ifeq signedBranchShort)                "/ 153
        (ifne signedBranchShort)                "/ 154
        (iflt signedBranchShort)                "/ 155
        (ifge signedBranchShort)                "/ 156
        (ifgt signedBranchShort)                "/ 157
        (ifle signedBranchShort)                "/ 158
        (if_icmpeq signedBranchShort)           "/ 159

        (if_icmpne signedBranchShort)           "/ 160
        (if_icmplt signedBranchShort)           "/ 161
        (if_icmpge signedBranchShort)           "/ 162
        (if_icmpgt signedBranchShort)           "/ 163
        (if_icmple signedBranchShort)           "/ 164
        (if_acmpeq signedBranchShort)           "/ 165
        (if_acmpne signedBranchShort)           "/ 166
        (goto signedBranchShort)                "/ 167
        (jsr signedBranchShort)                 "/ 168
        (ret localIndexByte)                    "/ 169

        (tableswitch tableSwitchBytes)          "/ 170
        (lookupswitch lookupSwitchBytes)        "/ 171
        (ireturn)                               "/ 172
        (lreturn)                               "/ 173
        (freturn)                               "/ 174
        (dreturn)                               "/ 175
        (areturn)                               "/ 176
        (return)                                "/ 177
        (getstatic constIndexShort remember_getstatic)               "/ 178
        (putstatic constIndexShort remember_putstatic)               "/ 179

        (getfield constIndexShort remember_getfield)                 "/ 180
        (putfield constIndexShort remember_putfield)                 "/ 181
        (invokevirtual constIndexShort remember_invokevirtual)       "/ 182
        (invokenonvirtual constIndexShort remember_invokenonvirtual) "/ 183
        (invokestatic constIndexShort remember_invokestatic)         "/ 184
        (invokeinterface constIndexShort nargsByte reservedByte remember_invokeinterface)          "/ 185
        (newfromname)                           "/ 186
        (new constIndexShort remember_new)      "/ 187
        (newarray arrayTypeByte)                "/ 188
        (anewarray constIndexShort)             "/ 189

        (arraylength)                           "/ 190
        (athrow remember_athrow)                "/ 191
        (checkcast constIndexShort)             "/ 192
        (instanceof constIndexShort)            "/ 193
        (monitorenter)                          "/ 194
        (monitorexit)                           "/ 195
"/        (verifystack)                           "/ 196 obsolete (Alpha release)
        (wide)                                  "/ 196
        (multianewarray constIndexShort dimensionsByte) "/ 197

        (ifnull    signedBranchShort)           "/ 198
        (ifnonnull signedBranchShort)           "/ 199

        (#'goto_w' signedBranchLong)            "/ 200
        (#'jsr_w' signedBranchShort)            "/ 201

        (breakpoint)                            "/ 202

        nil                                     "/ 203
        nil                                     "/ 204
        nil                                     "/ 205
        nil                                     "/ 206
        nil                                     "/ 207
        nil                                     "/ 208
        (#'ret_w' signedBranchShort)            "/ 209
                                         
        nil                                     "/ 210
        nil                                     "/ 211
        nil                                     "/ 212
        nil                                     "/ 213
        nil                                     "/ 214
        nil                                     "/ 215
        nil                                     "/ 216
        nil                                     "/ 217
        nil                                     "/ 218
        nil                                     "/ 219

        nil                                     "/ 220
        nil                                     "/ 221
        nil                                     "/ 222
        nil                                     "/ 223
        nil                                     "/ 224
        nil                                     "/ 225
        nil                                     "/ 226
        nil                                     "/ 227
        nil                                     "/ 228
        nil                                     "/ 229
                                    
        nil                                     "/ 230
        nil                                     "/ 231
        nil                                     "/ 232
        nil                                     "/ 233
        nil                                     "/ 234
        nil                                     "/ 235
        nil                                     "/ 236
        nil                                     "/ 237
        nil                                     "/ 238
        nil                                     "/ 239

        nil                                     "/ 240
        nil                                     "/ 241
        nil                                     "/ 242
        nil                                     "/ 243
        nil                                     "/ 244
        nil                                     "/ 245
        nil                                     "/ 246
        nil                                     "/ 247
        nil                                     "/ 248
        nil                                     "/ 249
                                              
        nil                                     "/ 250
        nil                                     "/ 251
        nil                                     "/ 252
        nil                                     "/ 253
        nil                                     "/ 254
        (invokenonvirtual_d constIndexShort)    "/ 255 special - dummy invokenonvirtual
    )

    "
     JavaDecompiler initialize
    "

    "Modified: / 16.11.1998 / 15:55:49 / cg"
! !

!JavaDecompiler class methodsFor:'accessing'!

instructionTable
    ^ DecoderTable
! !

!JavaDecompiler class methodsFor:'class definition generation'!

definitionOf:aJavaClass on:s
    |pckgName needCR fields staticFields superClass
     interfaces staticMethods nonStaticMethods
     accessAttributeStyle codeStyle classNameStyle methodNameStyle|

    accessAttributeStyle := Java prettyPrintStyle at:#accessAttribute.
    codeStyle := Java prettyPrintStyle at:#code.
    classNameStyle := Java prettyPrintStyle at:#className.
    methodNameStyle := Java prettyPrintStyle at:#className.

    pckgName := aJavaClass package.
    pckgName ~= 'java' ifTrue:[
        s nextPutAll:'package ' , ((pckgName copyFrom: 6) copyReplaceAll:$/ with:$.).
        s nextPutAll:';'; cr; cr.

    ].

    needCR := false.
    s emphasis:accessAttributeStyle.

    aJavaClass isPublic ifTrue:[
       s nextPutAll:'public '.
       needCR := true.
    ].
    aJavaClass isAbstract ifTrue:[
       s nextPutAll:'abstract '.
       needCR := true.
    ].
    aJavaClass isFinal ifTrue:[
       s nextPutAll:'final '.
       needCR := true.
    ].
    s emphasis:codeStyle.

    needCR ifTrue:[
        s cr
    ].
    aJavaClass isInterface ifTrue:[
       s nextPutAll:'interface '.
    ] ifFalse:[
       s nextPutAll:'class '.
    ].
    s emphasis:classNameStyle; 
      nextPutAll:aJavaClass lastName; 
      emphasis:codeStyle; 
      space.
    superClass := aJavaClass superclass.

    (superClass ~~ (JavaVM classNamed:'java/lang/Object')
    and:[superClass isJavaClass]) ifTrue:[
        s nextPutAll:'extends '.
        s emphasis:classNameStyle.
        (superClass package ~= 'java/lang' 
        and:[superClass package ~= pckgName]) ifTrue:[
            s nextPutAll:(superClass displayString). 
        ] ifFalse:[
            s nextPutAll:(superClass lastName).
        ].
        s emphasis:codeStyle.
        s space.
    ].

    (interfaces := aJavaClass interfaces) size > 0 ifTrue:[
        (aJavaClass isInterface
        and:[interfaces size == 1]) ifTrue:[
            s nextPutAll:'extends '.
        ] ifFalse:[
            s nextPutAll:'implements '.
        ].
        interfaces keysAndValuesDo:[:nr :if |
            |nameString|

            nr ~~ 1 ifTrue:[
                s nextPutAll:', '.
            ].
            s emphasis:classNameStyle.
            (if package ~= 'java/lang' 
            and:[if package ~= pckgName]) ifTrue:[
                if isJavaClass ifFalse:[
                    "/ ought to be an unresolved class ...
                    nameString := if fullName copyReplaceAll:$/ with:$.
                ] ifTrue:[
                    nameString := if displayString
                ].
            ] ifFalse:[
                nameString := if lastName
            ].
            s nextPutAll:nameString.
            s emphasis:codeStyle.
        ].
        s space.
    ].

    s nextPutAll:'{'; cr.

    needCR := false.
    staticFields := aJavaClass staticFields.
    staticFields size > 0 ifTrue:[
        needCR := true.

        staticFields do:[:aField |
            |type v|

            s nextPutAll:'    '.
            s emphasis:accessAttributeStyle.
            aField isSynthetic ifTrue:[
                s nextPutAll: '/*SYNTHETIC*/ '.
            ].
            aField isPublic ifTrue:[
                s nextPutAll:'public '.
            ] ifFalse:[
                aField isPrivate ifTrue:[
                    s nextPutAll:'private '.
                ] ifFalse:[
                    aField isProtected ifTrue:[
                        s nextPutAll:'protected '.
                    ]
                ]
            ].
            s nextPutAll:'static '.
            aField isFinal ifTrue:[
                s nextPutAll:'final '.
            ].
            aField isVolatile ifTrue:[
                s nextPutAll:'volatile '.
            ].
            s emphasis:codeStyle.

            (((type := aField type) startsWith:pckgName) 
            or:[type startsWith:(pckgName copyReplaceAll:$/ with:$.)]) ifTrue:[
                type := type copyFrom:(pckgName size + 1 + 1).
            ] ifFalse:[
                (type startsWith:'java.lang.') ifTrue:[
                    type := type copyFrom:(11).
                ]
            ].
            type := type copy replaceAll:$/ with:$..
            s nextPutAll:type; space;
              nextPutAll:aField name.

            (v := aField constantValue) notNil ifTrue:[
                s nextPutAll:' = '; nextPutAll:v displayString.
            ].

            s nextPutAll:';'; cr.
            needCR := true.
        ].
    ].


    fields := aJavaClass fields.
    fields size > 0 ifTrue:[
        needCR ifTrue:[
            s cr
        ].
        needCR := true.

        fields do:[:aField |
            |type v|

            s nextPutAll:'    '.
            s emphasis:accessAttributeStyle.
            aField isPublic ifTrue:[
                s nextPutAll:'public '.
            ] ifFalse:[
                aField isPrivate ifTrue:[
                    s nextPutAll:'private '.
                ] ifFalse:[
                    aField isProtected ifTrue:[
                        s nextPutAll:'protected '.
                    ]
                ]
            ].
            aField isFinal ifTrue:[
                s nextPutAll:'final '.
            ].
            aField isTransient ifTrue:[
                s nextPutAll:'transient '.
            ].
            aField isVolatile ifTrue:[
                s nextPutAll:'volatile '.
            ].
            s emphasis:codeStyle.

            (((type := aField type) startsWith:pckgName) 
            or:[type startsWith:(pckgName copyReplaceAll:$/ with:$.)]) ifTrue:[
                type := type copyFrom:(pckgName size + 1 + 1).
            ].
            type := type copy replaceAll:$/ with:$..
            s nextPutAll:type; space;
              nextPutAll:aField name.

            (v := aField constantValue) notNil ifTrue:[
                s nextPutAll:' = '; nextPutAll:v displayString.
            ].
            s nextPutAll:';'; cr.
        ].
    ].

    aJavaClass methodDictionary size > 0 ifTrue:[
        needCR ifTrue:[
            s cr.
            needCR := false.
        ].

        staticMethods := OrderedCollection new.
        nonStaticMethods := OrderedCollection new.
        "/
        "/ static methods first ...
        "/
        aJavaClass methodDictionary do:[:aMethod |
            aMethod isJavaMethod ifTrue:[
            |m|

            m := aMethod.
            m isWrapped ifTrue:[
                m := m originalMethod
            ].
            m isStatic ifTrue:[
                staticMethods add:m.
            ] ifFalse:[
                nonStaticMethods add:m.
            ]
        ].

        staticMethods notEmpty ifTrue:[
            staticMethods sort:[:a :b | a name < b name].
            staticMethods do:[:aMethod |
                "JV@2011-12-14: method dictionary may contain non-Java methods
                (proxies, for instance)"
                aMethod isJavaMethod ifTrue:[
                    self methodDefinitionOf:aMethod inPackage:pckgName on:s.
                ]
            ].
            s cr.
        ].

        "/
        "/ instance methods ...
        "/
        nonStaticMethods notEmpty ifTrue:[
            nonStaticMethods sort:[:a :b | a name < b name].
            nonStaticMethods do:[:aMethod |
                "JV@2011-12-14: method dictionary may contain non-Java methods
                 (proxies, for instance)"
                aMethod isJavaMethod ifTrue:[
                    self methodDefinitionOf:aMethod inPackage:pckgName on:s.
                ]
            ].
        ].
        ]
    ].

    s nextPutAll:'}'; cr.

    "Created: / 22-03-1997 / 14:29:37 / cg"
    "Modified: / 05-12-1998 / 15:58:37 / cg"
    "Modified: / 21-10-2011 / 13:40:44 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 31-03-2012 / 00:36:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodDefinitionOf: m inPackage: pckgName on: s 
    | aMethod nm  specComponents  accessAttributeStyle  codeStyle  methodNameStyle |

    aMethod := m.
    m isWrapped ifTrue: [
        aMethod := m originalMethod
    ].
    accessAttributeStyle := Java prettyPrintStyle at: #accessAttribute.
    codeStyle := Java prettyPrintStyle at: #code.
    methodNameStyle := Java prettyPrintStyle at: #methodName.
    s nextPutAll: '    '.
    s emphasis: accessAttributeStyle.
    aMethod isSynthetic ifTrue:[
        s nextPutAll: '/*SYNTHETIC*/ '.
    ].
    aMethod isPublic ifTrue: [
        s nextPutAll: 'public '.
    ] ifFalse: [
        aMethod isProtected ifTrue: [
            s nextPutAll: 'protected '.
        ] ifFalse: [ s nextPutAll: 'private '. ]
    ].
    aMethod isFinal ifTrue: [
        s nextPutAll: 'final '.
    ].
    aMethod isStatic ifTrue: [
        s nextPutAll: 'static '.
    ].
    aMethod isNative ifTrue: [
        s nextPutAll: 'native '.
    ].
    aMethod isSynchronized ifTrue: [
        s nextPutAll: 'synchronized '.
    ].
    s emphasis: codeStyle.
    (nm := aMethod name) = '<init>' ifTrue: [
        nm := aMethod javaClass lastName.
    ].
    specComponents := JavaMethod 
                specComponentsWithArgsFromSignature: (aMethod instVarNamed:#descriptor)
                withName: nm
                in: (aMethod javaClass package).
    s nextPutAll: (specComponents at: 1).
    s space.
    s emphasis: methodNameStyle.
    s nextPutAll: (specComponents at: 2).
    s emphasis: codeStyle.
    s nextPutAll: ' ('.
    s nextPutAll: (specComponents at: 3).
    s nextPutAll: ')'.
    aMethod exceptionTable size > 0 ifTrue: [
        s nextPutAll: ' throws '.
        aMethod exceptionTable 
            keysAndValuesDo: [
                :index :aClassRef | 
                | nm |

                nm := aClassRef name.
                (nm startsWith: pckgName) ifTrue: [
                    nm := nm copyFrom: pckgName size + 2
                ] ifFalse: [
                    (nm startsWith: 'java/lang') ifTrue: [
                        nm := nm copyFrom: 'java/lang' size + 2.
                    ].
                ].
                index ~~ 1 ifTrue: [ s nextPutAll: ', ' ].
                s nextPutAll: (nm copyReplaceAll: $/ with: $.)
            ]
    ].
    s
        nextPutAll: ';';
        cr.

    "Created: / 01-08-1997 / 12:24:11 / cg"
    "Modified: / 14-11-1998 / 00:03:09 / cg"
    "Modified: / 04-06-2011 / 17:18:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (format): / 30-03-2012 / 19:52:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaDecompiler class methodsFor:'decompiling'!

decompile:aJavaMethod
    self decompile:aJavaMethod to:Transcript
!

decompile:aJavaMethod to:aStream
    self new decompile:aJavaMethod to:aStream
! !

!JavaDecompiler methodsFor:'decompiling'!

decompile:aJavaMethod to:aStream
    |who endPC|

    outStream := aStream.

    isStaticMethod := aJavaMethod isStatic.

    who := aJavaMethod who.
    who notNil ifTrue:[
        classToCompileFor := who methodClass.
        outStream notNil ifTrue:[
            outStream cr.
"/            outStream showCR:'decompiling ' , classToCompileFor name , '>>' , (who methodSelector) , ':'.
            outStream showCR:'decompiling ' , aJavaMethod displayString , ':'.
            isStaticMethod ifTrue:[
                outStream show:'static method'.
            ].
            outStream cr.
            outStream cr.
        ]
    ].

    javaMethod := aJavaMethod.
    code := aJavaMethod javaByteCode.
    endPC := code size.
    endPC == 0 ifTrue:[
        outStream notNil ifTrue:[
            javaMethod isNative ifTrue:[
                outStream nextPutAll:'// native method'; cr
            ] ifFalse:[
                outStream nextPutAll:'{}  // no bytecode'; cr
            ].
        ].
        ^ self
    ].

    self enumerateInstructions.

    "Modified: / 9.11.1999 / 15:33:20 / cg"
!

enumerateInstructions
    |endPC insn spec op wide|

    wide := false.
    pc := 1.
    endPC := code size.
    [pc <= endPC] whileTrue:[
        insn := code at:pc.
        pc := pc + 1.

        spec := DecoderTable at:(insn + 1).
        spec isNil ifTrue:[
            op := '** invalid opcode: ', insn printString, ' **'
        ] ifFalse:[
            op := spec at:1
        ].

        outStream notNil ifTrue:[
            outStream 
                show:((pc - 1 - 1) printStringPaddedTo:4); 
                show:' '.
            outStream
                show:(wide ifTrue:[op , '(w)'] ifFalse:[op]).
            outStream
                show:' '.
        ].

        op == #wide ifTrue:[
            wide := true.
        ] ifFalse:[
            self instructionHookPC:(pc-1) op:op spec:spec.

            spec notNil ifTrue:[
                spec from:2 to:spec size do:[:what |
                    wide ifTrue:[
                        self perform:(what , '_wide') asSymbol.
                    ] ifFalse:[
                        self perform:what
                    ]
                ].
            ].
            wide := false.
        ].

        outStream notNil ifTrue:[
            outStream cr.
        ]
    ]

    "Created: / 9.11.1999 / 15:32:49 / cg"
    "Modified: / 9.11.1999 / 15:36:22 / cg"
!

instructionHookPC:pc op:op spec:spec

    "Created: / 9.11.1999 / 15:35:19 / cg"
! !

!JavaDecompiler methodsFor:'operand decoding'!

arrayTypeByte
    |index type|

    index := code at:pc.
    pc := pc + 1.

    type := #('T_ARRAY' 'invalid2' 'invalid3' 'T_BOOLEAN'
              'T_CHAR'  'T_FLOAT'  'T_DOUBLE'  'T_BYTE' 
              'T_SHORT' 'T_INT'    'T_LONG' ) at:index ifAbsent:['invalid' , index printString].

    outStream notNil ifTrue:[
        outStream
            show:index; 
            show:' [';
            show:type;
            show:']'
    ]

    "Created: / 16.11.1998 / 15:41:47 / cg"
    "Modified: / 16.11.1998 / 15:43:27 / cg"
!

constIndexByte
    lastConstIndex := code at:pc.
    pc := pc + 1.

    lastConstant := javaMethod constantPool at:lastConstIndex ifAbsent:nil.

    outStream notNil ifTrue:[
        outStream
            show:lastConstIndex; 
            show:' ['; 
            show:(lastConstant ? '??') displayString; 
            show:'] '
    ]

    "Created: / 16.11.1998 / 15:42:56 / cg"
    "Modified: / 16.11.1998 / 15:58:52 / cg"
!

constIndexShort
    |s|

    lastConstIndex := code wordAt:pc MSB:true.
    pc := pc + 2.

    lastConstant := javaMethod constantPool at:lastConstIndex ifAbsent:nil.
    outStream notNil ifTrue:[
        s := (lastConstant ? '??') displayString.
        s isString ifTrue:[
            s bitsPerCharacter > 8 ifTrue:[
                s := '...a 2-byte string...'
            ]
        ].
        outStream
            show:lastConstIndex; 
            show:' ['; 
            show:s; 
            show:'] '
    ]

    "Created: / 16.4.1996 / 15:00:04 / cg"
    "Modified: / 16.11.1998 / 15:59:23 / cg"
!

dimensionsByte
    outStream notNil ifTrue:[
        outStream show:' dims= '. 
    ].
    self unsignedByte

    "Modified: / 9.11.1999 / 15:46:06 / cg"
!

localIndexByte
    |index|

    index := code at:pc.
    pc := pc + 1.

    outStream notNil ifTrue:[
        outStream
            show:index; 
            show:' '
    ]

    "Created: / 16.4.1996 / 15:00:04 / cg"
    "Modified: / 16.11.1998 / 15:43:55 / cg"
!

localIndexByte_wide
    |index|

    index := code wordAt:pc MSB:true.
    pc := pc + 2.

    outStream notNil ifTrue:[
        outStream
            show:index; 
            show:' '
    ]

    "Created: / 4.8.1997 / 19:02:09 / cg"
    "Modified: / 16.11.1998 / 15:44:02 / cg"
!

lookupSwitchBytes
    |defaultOffset delta nPairs match pc0|

    pc0 := pc-1.  "/ i.e. the pc of the tableSwitch op

    [(pc-1) \\ 4 ~~ 0] whileTrue:[
        pc := pc + 1
    ].

    defaultOffset := code signedDoubleWordAt:pc MSB:true.
    pc := pc + 4.
    nPairs := code signedDoubleWordAt:pc MSB:true.
    pc := pc + 4.

    outStream notNil ifTrue:[
        outStream show:'n='; show:nPairs; cr.
    ].

    nPairs timesRepeat:[
        match := code signedDoubleWordAt:pc MSB:true.
        pc := pc + 4.
        delta := code signedDoubleWordAt:pc MSB:true.
        pc := pc + 4.
        outStream notNil ifTrue:[
            outStream show:'    '; 
                      show:match;
                      show:' -> ';
                      show:delta;
                      show:' [';
                      show:(pc0 - 1 + delta);
                      show:']';
                      cr.
        ]
    ].

    outStream notNil ifTrue:[
        outStream show:'    '; 
                  show:'default';
                  show:' -> ';
                  show:defaultOffset;
                  show:' [';
                  show:(pc0 - 1 + defaultOffset);
                  show:']'.
    ]

    "Modified: / 9.11.1999 / 15:45:50 / cg"
!

nargsByte
    |byte|

    byte := code byteAt:pc.
    pc := pc + 1.

    outStream notNil ifTrue:[
        outStream
            show:byte 
    ]

    "Created: / 16.4.1996 / 15:00:04 / cg"
    "Modified: / 16.11.1998 / 15:44:34 / cg"
!

reservedByte
    |byte|

    byte := code byteAt:pc.
    pc := pc + 1.

    outStream notNil ifTrue:[
        outStream
            show:byte 
    ]

    "Created: / 16.4.1996 / 15:00:04 / cg"
    "Modified: / 16.11.1998 / 15:44:42 / cg"
!

signedBranchShort
    |index|

    index := code signedWordAt:pc MSB:true.

    outStream notNil ifTrue:[
        outStream
            show:index; 
            show:' ['; 
            show:(pc - 1 + index - 1); 
            show:']'.
    ].

    pc := pc + 2.

    "Created: / 16.4.1996 / 15:00:04 / cg"
    "Modified: / 16.11.1998 / 15:44:51 / cg"
!

signedByte
    |byte|

    byte := code signedByteAt:pc.
    pc := pc + 1.

    outStream notNil ifTrue:[
        outStream
            show:byte 
    ]

    "Created: / 16.4.1996 / 15:00:04 / cg"
    "Modified: / 16.11.1998 / 15:44:58 / cg"
!

signedByte_wide
    self signedShort

    "Created: / 13.1.1998 / 23:56:36 / cg"
!

signedShort
    |word|

    word := code signedWordAt:pc MSB:true.
    pc := pc + 2.

    outStream notNil ifTrue:[
        outStream
            show:word 
    ]

    "Created: / 16.4.1996 / 15:00:04 / cg"
    "Modified: / 16.11.1998 / 15:45:06 / cg"
!

tableSwitchBytes
    |defaultOffset delta low high pc0|

    pc0 := pc-1.  "/ i.e. the pc of the tableSwitch op

    [(pc-1) \\ 4 ~~ 0] whileTrue:[
        pc := pc + 1
    ].

    defaultOffset := code signedDoubleWordAt:pc MSB:true.
    pc := pc + 4.
    low := code signedDoubleWordAt:pc MSB:true.
    pc := pc + 4.
    high := code signedDoubleWordAt:pc MSB:true.
    pc := pc + 4.

    outStream notNil ifTrue:[
        outStream cr.
    ].

    low to:high do:[:switchValue |
        delta := code signedDoubleWordAt:pc MSB:true.
        pc := pc + 4.
        outStream notNil ifTrue:[
            outStream show:'    '; 
                      show:switchValue;
                      show:' -> ';
                      show:delta;
                      show:' [';
                      show:(pc0 - 1 + delta);
                      show:']';
                      cr.
        ].
    ].

    outStream notNil ifTrue:[
        outStream show:'    '; 
                  show:'default';
                  show:' -> ';
                  show:defaultOffset;
                  show:' [';
                  show:(pc0 - 1 + defaultOffset);
                  show:']'.
    ]

    "Modified: / 9.11.1999 / 15:44:36 / cg"
!

unsignedByte
    |byte|

    byte := code byteAt:pc.
    pc := pc + 1.

    outStream notNil ifTrue:[
        outStream
            show:byte 
    ]

    "Created: / 16.4.1996 / 15:00:04 / cg"
    "Modified: / 16.11.1998 / 15:45:33 / cg"
! !

!JavaDecompiler methodsFor:'private'!

popType:type
    (type == #long) ifTrue:[
        ^ self popLong
    ].
    type == #double ifTrue:[
        ^ self popDouble
    ].
    ^ self popStack

    "Created: 16.8.1997 / 03:14:11 / cg"
! !

!JavaDecompiler methodsFor:'statistics'!

remember_athrow

    "Created: / 16.11.1998 / 19:37:32 / cg"
!

remember_getfield
    |fieldRef|

    fieldRef := lastConstant.
    "/ ....

    "Created: / 16.11.1998 / 16:07:58 / cg"
!

remember_getstatic
    |fieldRef|

    fieldRef := lastConstant.
    "/ ....

    "Created: / 16.11.1998 / 16:08:06 / cg"
!

remember_invokeinterface
    |mthdRef|

    mthdRef := lastConstant.
    "/ ....

    "Created: / 16.11.1998 / 16:07:29 / cg"
!

remember_invokenonvirtual
    |mthdRef|

    mthdRef := lastConstant.
    "/ ....

    "Created: / 16.11.1998 / 16:06:49 / cg"
!

remember_invokestatic
    |mthdRef|

    mthdRef := lastConstant.
    "/ ....

    "Created: / 16.11.1998 / 16:06:40 / cg"
!

remember_invokevirtual
    |mthdRef|

    mthdRef := lastConstant.
    "/ ....

    "Created: / 16.11.1998 / 16:06:32 / cg"
!

remember_ldc1
    |what|

    what := lastConstant.
    "/ ....

    "Created: / 16.11.1998 / 16:07:12 / cg"
!

remember_ldc2
    |what|

    what := lastConstant.
    "/ ....

    "Created: / 16.11.1998 / 16:07:19 / cg"
!

remember_ldc2w
    |what|

    what := lastConstant.
    "/ ....

    "Created: / 16.11.1998 / 16:07:20 / cg"
!

remember_new
    |class|

    class := lastConstant.

    "Created: / 16.11.1998 / 15:59:43 / cg"
    "Modified: / 16.11.1998 / 16:12:27 / cg"
!

remember_putfield
    |fieldRef|

    fieldRef := lastConstant.
    "/ ....

    "Created: / 16.11.1998 / 16:08:00 / cg"
!

remember_putstatic
    |fieldRef|

    fieldRef := lastConstant.
    "/ ....

    "Created: / 16.11.1998 / 16:08:04 / cg"
! !

!JavaDecompiler class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'

! !


JavaDecompiler initialize!
