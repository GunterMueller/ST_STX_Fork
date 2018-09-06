"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

SmaCCParser subclass:#CParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmaCC-Example Parsers'
!


!CParser class methodsFor:'generated-accessing'!

scannerClass
	^SmaCC::CScanner

    "Modified: / 18-11-2008 / 13:47:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CParser class methodsFor:'generated-comments'!

parserDefinitionComment

	"%id <TYPE_NAME> <IDENTIFIER> <CONSTANT> ;

translation_unit
        : external_declaration
        | translation_unit external_declaration
        ;

primary_expression
        : <IDENTIFIER>
        | <CONSTANT>
        | <STRING_LITERAL>
        | ""("" expression "")""
        ;

postfix_expression
        : primary_expression
        | postfix_expression <LEFT_BLOCK> expression <RIGHT_BLOCK>
        | postfix_expression ""("" "")""
        | postfix_expression ""("" argument_expression_list "")""
        | postfix_expression ""."" <IDENTIFIER>
        | postfix_expression ""->"" <IDENTIFIER>
        | postfix_expression ""++""
        | postfix_expression ""--""
        ;

argument_expression_list
        : assignment_expression
        | argument_expression_list "","" assignment_expression
        ;

unary_expression
        : postfix_expression
        | ""++"" unary_expression
        | ""--"" unary_expression
        | unary_operator cast_expression
        | ""sizeof"" unary_expression
        | ""sizeof"" ""("" type_name "")""
        ;

unary_operator
        : ""&""
        | ""*""
        | ""+""
        | ""-""
        | ""~""
        | ""!!""
        ;

cast_expression
        : unary_expression
        | ""("" type_name "")"" cast_expression
        ;

multiplicative_expression
        : cast_expression
        | multiplicative_expression ""*"" cast_expression
        | multiplicative_expression ""/"" cast_expression
        | multiplicative_expression ""%"" cast_expression
        ;

additive_expression
        : multiplicative_expression
        | additive_expression ""+"" multiplicative_expression
        | additive_expression ""-"" multiplicative_expression
        ;

shift_expression
        : additive_expression
        | shift_expression ""<<"" additive_expression
        | shift_expression "">>"" additive_expression
        ;

relational_expression
        : shift_expression
        | relational_expression ""<"" shift_expression
        | relational_expression "">"" shift_expression
        | relational_expression ""<="" shift_expression
        | relational_expression "">="" shift_expression
        ;

equality_expression
        : relational_expression
        | equality_expression ""=="" relational_expression
        | equality_expression ""!!="" relational_expression
        ;

and_expression
        : equality_expression
        | and_expression ""&"" equality_expression
        ;

exclusive_or_expression
        : and_expression
        | exclusive_or_expression ""^"" and_expression
        ;

inclusive_or_expression
        : exclusive_or_expression
        | inclusive_or_expression ""|"" exclusive_or_expression
        ;

logical_and_expression
        : inclusive_or_expression
        | logical_and_expression ""&&"" inclusive_or_expression
        ;

logical_or_expression
        : logical_and_expression
        | logical_or_expression ""||"" logical_and_expression
        ;

conditional_expression
        : logical_or_expression
        | logical_or_expression ""?"" expression "":"" conditional_expression
        ;

assignment_expression
        : conditional_expression
        | unary_expression assignment_operator assignment_expression
        ;

assignment_operator
        : ""=""
        | ""*=""
        | ""/=""
        | ""%=""
        | ""+=""
        | ""-=""
        | ""<<=""
        | "">>=""
        | ""&=""
        | ""^=""
        | ""|=""
        ;

expression
        : assignment_expression
        | expression "","" assignment_expression
        ;

constant_expression
        : conditional_expression
        ;

declaration
        : declaration_specifiers "";""
        | declaration_specifiers init_declarator_list "";""
        ;

declaration_specifiers
        : storage_class_specifier
        | storage_class_specifier declaration_specifiers
        | type_specifier
        | type_specifier declaration_specifiers
        | type_qualifier
        | type_qualifier declaration_specifiers
        ;

init_declarator_list
        : init_declarator
        | init_declarator_list "","" init_declarator
        ;

init_declarator
        : declarator
        | declarator ""="" initializer
        ;

storage_class_specifier
        : ""typedef""
        | ""extern""
        | ""static""
        | ""auto""
        | ""register""
        ;

type_specifier
        : ""void""
        | ""char""
        | ""short""
        | ""int""
        | ""long""
        | ""float""
        | ""double""
        | ""signed""
        | ""unsigned""
        | struct_or_union_specifier
        | enum_specifier
        | <TYPE_NAME>
        ;

struct_or_union_specifier
        : struct_or_union <IDENTIFIER> <LEFT_BRACE> struct_declaration_list <RIGHT_BRACE> {self addTypeName: '2' value. self reduceFor: nodes}
        | struct_or_union <LEFT_BRACE> struct_declaration_list <RIGHT_BRACE>
        | struct_or_union <IDENTIFIER> {self addTypeName: '2' value. self reduceFor: nodes}
        ;

struct_or_union
        : ""struct""
        | ""union""
        ;

struct_declaration_list
        : struct_declaration
        | struct_declaration_list struct_declaration
        ;

struct_declaration
        : specifier_qualifier_list struct_declarator_list "";""
        ;

specifier_qualifier_list
        : type_specifier specifier_qualifier_list
        | type_specifier
        | type_qualifier specifier_qualifier_list
        | type_qualifier
        ;

struct_declarator_list
        : struct_declarator
        | struct_declarator_list "","" struct_declarator
        ;

struct_declarator
        : declarator
        | "":"" constant_expression
        | declarator "":"" constant_expression
        ;

enum_specifier
        : ""enum"" <LEFT_BRACE> enumerator_list <RIGHT_BRACE>
        | ""enum"" <IDENTIFIER> <LEFT_BRACE> enumerator_list <RIGHT_BRACE>  {self addTypeName: '2' value. self reduceFor: nodes}
        | ""enum"" <IDENTIFIER>  {self addTypeName: '2' value. self reduceFor: nodes}
        ;

enumerator_list
        : enumerator
        | enumerator_list "","" enumerator
        ;

enumerator
        : <IDENTIFIER>
        | <IDENTIFIER> ""="" constant_expression
        ;

type_qualifier
        : ""const""
        | ""volatile""
        ;

declarator
        : pointer direct_declarator
        | direct_declarator
        ;

direct_declarator
        : <IDENTIFIER>
        | ""("" declarator "")""
        | direct_declarator <LEFT_BLOCK> constant_expression <RIGHT_BLOCK>
        | direct_declarator <LEFT_BLOCK> <RIGHT_BLOCK>
        | direct_declarator ""("" parameter_type_list "")""
        | direct_declarator ""("" identifier_list "")""
        | direct_declarator ""("" "")""
        ;

pointer
        : ""*""
        | ""*"" type_qualifier_list
        | ""*"" pointer
        | ""*"" type_qualifier_list pointer
        ;

type_qualifier_list
        : type_qualifier
        | type_qualifier_list type_qualifier
        ;


parameter_type_list
        : parameter_list
        | parameter_list "","" <ELLIPSIS>
        ;

parameter_list
        : parameter_declaration
        | parameter_list "","" parameter_declaration
        ;

parameter_declaration
        : declaration_specifiers declarator
        | declaration_specifiers abstract_declarator
        | declaration_specifiers
        ;

identifier_list
        : <IDENTIFIER>
        | identifier_list "","" <IDENTIFIER>
        ;

type_name
        : specifier_qualifier_list
        | specifier_qualifier_list abstract_declarator
        ;

abstract_declarator
        : pointer
        | direct_abstract_declarator
        | pointer direct_abstract_declarator
        ;

direct_abstract_declarator
        : ""("" abstract_declarator "")""
        | <LEFT_BLOCK> <RIGHT_BLOCK>
        | <LEFT_BLOCK> constant_expression <RIGHT_BLOCK>
        | direct_abstract_declarator <LEFT_BLOCK> <RIGHT_BLOCK>
        | direct_abstract_declarator <LEFT_BLOCK> constant_expression <RIGHT_BLOCK>
        | ""("" "")""
        | ""("" parameter_type_list "")""
        | direct_abstract_declarator ""("" "")""
        | direct_abstract_declarator ""("" parameter_type_list "")""
        ;

initializer
        : assignment_expression
        | <LEFT_BRACE> initializer_list <RIGHT_BRACE>
        | <LEFT_BRACE> initializer_list "","" <RIGHT_BRACE>
        ;

initializer_list
        : initializer
        | initializer_list "","" initializer
        ;

statement
        : labeled_statement
        | compound_statement
        | expression_statement
        | selection_statement
        | iteration_statement
        | jump_statement
        ;

labeled_statement
        : <IDENTIFIER> "":"" statement
        | ""case"" constant_expression "":"" statement
        | ""default"" "":"" statement
        ;

compound_statement
        : <LEFT_BRACE> <RIGHT_BRACE>
        | <LEFT_BRACE> statement_list <RIGHT_BRACE>
        | <LEFT_BRACE> declaration_list <RIGHT_BRACE>
        | <LEFT_BRACE> declaration_list statement_list <RIGHT_BRACE>
        ;

declaration_list
        : declaration
        | declaration_list declaration
        ;

statement_list
        : statement
        | statement_list statement
        ;

expression_statement
        : "";""
        | expression "";""
        ;

selection_statement
        : ""if"" ""("" expression "")"" statement
        | ""if"" ""("" expression "")"" statement ""else"" statement
        | ""switch"" ""("" expression "")"" statement
        ;

iteration_statement
        : ""while"" ""("" expression "")"" statement
        | ""do"" statement ""while"" ""("" expression "")"" "";""
        | ""for"" ""("" expression_statement expression_statement "")"" statement
        | ""for"" ""("" expression_statement expression_statement expression "")"" statement
        ;

jump_statement
        : ""goto"" <IDENTIFIER> "";""
        | ""continue"" "";""
        | ""break"" "";""
        | ""return"" "";""
        | ""return"" expression "";""
        ;

external_declaration
        : function_definition
        | declaration
        ;

function_definition
        : declaration_specifiers declarator declaration_list compound_statement
        | declaration_specifiers declarator compound_statement
        | declarator declaration_list compound_statement
        | declarator compound_statement
        ;
"

    "Modified: / 18-11-2008 / 13:47:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

symbolComment

	"
1. ""^""
2. ""|""
3. ""==""
4. ""!!=""
5. ""&&""
6. "">""
7. ""<=""
8. "">=""
9. ""||""
10. ""%=""
11. ""+=""
12. ""*=""
13. ""/=""
14. "">>""
15. ""?""
16. "":""
17. ""=""
18. ""<""
19. ""-=""
20. ""--""
21. "",""
22. ""->""
23. ""++""
24. ""sizeof""
25. ""(""
26. "")""
27. "".""
28. ""&""
29. ""/""
30. ""%""
31. ""~""
32. ""!!""
33. ""<<""
34. ""*""
35. ""+""
36. ""-""
37. ""<<=""
38. ""case""
39. ""default""
40. ""const""
41. ""volatile""
42. ""if""
43. ""struct""
44. ""union""
45. ""enum""
46. ""else""
47. ""continue""
48. ""break""
49. ""for""
50. ""goto""
51. ""signed""
52. ""switch""
53. ""while""
54. ""do""
55. ""unsigned""
56. ""return""
57. ""typedef""
58. ""extern""
59. ""|=""
60. "";""
61. ""static""
62. "">>=""
63. ""&=""
64. ""^=""
65. ""auto""
66. ""long""
67. ""float""
68. ""short""
69. ""int""
70. ""double""
71. ""register""
72. ""void""
73. ""char""
74. <ELLIPSIS>
75. <comment>
76. <IDENTIFIER>
77. <CONSTANT>
78. <STRING_LITERAL>
79. <LEFT_BLOCK>
80. <RIGHT_BLOCK>
81. <LEFT_BRACE>
82. <RIGHT_BRACE>
83. <whitespace>
84. postfix_expression
85. primary_expression
86. argument_expression_list
87. assignment_expression
88. unary_expression
89. unary_operator
90. cast_expression
91. type_name
92. multiplicative_expression
93. additive_expression
94. shift_expression
95. relational_expression
96. equality_expression
97. and_expression
98. expression
99. inclusive_or_expression
100. logical_and_expression
101. logical_or_expression
102. conditional_expression
103. assignment_operator
104. constant_expression
105. declaration_specifiers
106. init_declarator_list
107. declaration
108. storage_class_specifier
109. type_specifier
110. type_qualifier
111. init_declarator
112. declarator
113. external_declaration
114. struct_or_union_specifier
115. enum_specifier
116. struct_or_union
117. B e g i n
118. struct_declaration_list
119. exclusive_or_expression
120. struct_declaration
121. specifier_qualifier_list
122. struct_declarator_list
123. struct_declarator
124. enumerator_list
125. enumerator
126. pointer
127. direct_declarator
128. parameter_type_list
129. identifier_list
130. type_qualifier_list
131. parameter_list
132. <TYPE_NAME>
133. parameter_declaration
134. abstract_declarator
135. direct_abstract_declarator
136. initializer_list
137. labeled_statement
138. compound_statement
139. expression_statement
140. selection_statement
141. iteration_statement
142. jump_statement
143. statement
144. statement_list
145. declaration_list
146. function_definition
147. E O F
148. error
149. translation_unit
150. initializer
"

    "Created: / 18-11-2008 / 13:47:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CParser class methodsFor:'generated-starting states'!

startingStateFortranslation_unit
	^1

    "Modified: / 18-11-2008 / 13:47:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CParser methodsFor:'accessing'!

parserDefinitionComment

        "%id <TYPE_NAME> <IDENTIFIER> <CONSTANT> ;

translation_unit
        : external_declaration
        | translation_unit external_declaration
        ;

primary_expression
        : <IDENTIFIER>
        | <CONSTANT>
        | <STRING_LITERAL>
        | ""("" expression "")""
        ;

postfix_expression
        : primary_expression
        | postfix_expression <LEFT_BLOCK> expression <RIGHT_BLOCK>
        | postfix_expression ""("" "")""
        | postfix_expression ""("" argument_expression_list "")""
        | postfix_expression ""."" <IDENTIFIER>
        | postfix_expression ""->"" <IDENTIFIER>
        | postfix_expression ""++""
        | postfix_expression ""--""
        ;

argument_expression_list
        : assignment_expression
        | argument_expression_list "","" assignment_expression
        ;

unary_expression
        : postfix_expression
        | ""++"" unary_expression
        | ""--"" unary_expression
        | unary_operator cast_expression
        | ""sizeof"" unary_expression
        | ""sizeof"" ""("" type_name "")""
        ;

unary_operator
        : ""&""
        | ""*""
        | ""+""
        | ""-""
        | ""~""
        | ""!!!!""
        ;

cast_expression
        : unary_expression
        | ""("" type_name "")"" cast_expression
        ;

multiplicative_expression
        : cast_expression
        | multiplicative_expression ""*"" cast_expression
        | multiplicative_expression ""/"" cast_expression
        | multiplicative_expression ""%"" cast_expression
        ;

additive_expression
        : multiplicative_expression
        | additive_expression ""+"" multiplicative_expression
        | additive_expression ""-"" multiplicative_expression
        ;

shift_expression
        : additive_expression
        | shift_expression ""<<"" additive_expression
        | shift_expression "">>"" additive_expression
        ;

relational_expression
        : shift_expression
        | relational_expression ""<"" shift_expression
        | relational_expression "">"" shift_expression
        | relational_expression ""<="" shift_expression
        | relational_expression "">="" shift_expression
        ;

equality_expression
        : relational_expression
        | equality_expression ""=="" relational_expression
        | equality_expression ""!!!!="" relational_expression
        ;

and_expression
        : equality_expression
        | and_expression ""&"" equality_expression
        ;

exclusive_or_expression
        : and_expression
        | exclusive_or_expression ""^"" and_expression
        ;

inclusive_or_expression
        : exclusive_or_expression
        | inclusive_or_expression ""|"" exclusive_or_expression
        ;

logical_and_expression
        : inclusive_or_expression
        | logical_and_expression ""&&"" inclusive_or_expression
        ;

logical_or_expression
        : logical_and_expression
        | logical_or_expression ""||"" logical_and_expression
        ;

conditional_expression
        : logical_or_expression
        | logical_or_expression ""?"" expression "":"" conditional_expression
        ;

assignment_expression
        : conditional_expression
        | unary_expression assignment_operator assignment_expression
        ;

assignment_operator
        : ""=""
        | ""*=""
        | ""/=""
        | ""%=""
        | ""+=""
        | ""-=""
        | ""<<=""
        | "">>=""
        | ""&=""
        | ""^=""
        | ""|=""
        ;

expression
        : assignment_expression
        | expression "","" assignment_expression
        ;

constant_expression
        : conditional_expression
        ;

declaration
        : declaration_specifiers "";""
        | declaration_specifiers init_declarator_list "";""
        ;

declaration_specifiers
        : storage_class_specifier
        | storage_class_specifier declaration_specifiers
        | type_specifier
        | type_specifier declaration_specifiers
        | type_qualifier
        | type_qualifier declaration_specifiers
        ;

init_declarator_list
        : init_declarator
        | init_declarator_list "","" init_declarator
        ;

init_declarator
        : declarator
        | declarator ""="" initializer
        ;

storage_class_specifier
        : ""typedef""
        | ""extern""
        | ""static""
        | ""auto""
        | ""register""
        ;

type_specifier
        : ""void""
        | ""char""
        | ""short""
        | ""int""
        | ""long""
        | ""float""
        | ""double""
        | ""signed""
        | ""unsigned""
        | struct_or_union_specifier
        | enum_specifier
        | <TYPE_NAME>
        ;

struct_or_union_specifier
        : struct_or_union <IDENTIFIER> <LEFT_BRACE> struct_declaration_list <RIGHT_BRACE> {self addTypeName: '2' value. self reduceFor: nodes}
        | struct_or_union <LEFT_BRACE> struct_declaration_list <RIGHT_BRACE>
        | struct_or_union <IDENTIFIER> {self addTypeName: '2' value. self reduceFor: nodes}
        ;

struct_or_union
        : ""struct""
        | ""union""
        ;

struct_declaration_list
        : struct_declaration
        | struct_declaration_list struct_declaration
        ;

struct_declaration
        : specifier_qualifier_list struct_declarator_list "";""
        ;

specifier_qualifier_list
        : type_specifier specifier_qualifier_list
        | type_specifier
        | type_qualifier specifier_qualifier_list
        | type_qualifier
        ;

struct_declarator_list
        : struct_declarator
        | struct_declarator_list "","" struct_declarator
        ;

struct_declarator
        : declarator
        | "":"" constant_expression
        | declarator "":"" constant_expression
        ;

enum_specifier
        : ""enum"" <LEFT_BRACE> enumerator_list <RIGHT_BRACE>
        | ""enum"" <IDENTIFIER> <LEFT_BRACE> enumerator_list <RIGHT_BRACE>  {self addTypeName: '2' value. self reduceFor: nodes}
        | ""enum"" <IDENTIFIER>  {self addTypeName: '2' value. self reduceFor: nodes}
        ;

enumerator_list
        : enumerator
        | enumerator_list "","" enumerator
        ;

enumerator
        : <IDENTIFIER>
        | <IDENTIFIER> ""="" constant_expression
        ;

type_qualifier
        : ""const""
        | ""volatile""
        ;

declarator
        : pointer direct_declarator
        | direct_declarator
        ;

direct_declarator
        : <IDENTIFIER>
        | ""("" declarator "")""
        | direct_declarator <LEFT_BLOCK> constant_expression <RIGHT_BLOCK>
        | direct_declarator <LEFT_BLOCK> <RIGHT_BLOCK>
        | direct_declarator ""("" parameter_type_list "")""
        | direct_declarator ""("" identifier_list "")""
        | direct_declarator ""("" "")""
        ;

pointer
        : ""*""
        | ""*"" type_qualifier_list
        | ""*"" pointer
        | ""*"" type_qualifier_list pointer
        ;

type_qualifier_list
        : type_qualifier
        | type_qualifier_list type_qualifier
        ;


parameter_type_list
        : parameter_list
        | parameter_list "","" <ELLIPSIS>
        ;

parameter_list
        : parameter_declaration
        | parameter_list "","" parameter_declaration
        ;

parameter_declaration
        : declaration_specifiers declarator
        | declaration_specifiers abstract_declarator
        | declaration_specifiers
        ;

identifier_list
        : <IDENTIFIER>
        | identifier_list "","" <IDENTIFIER>
        ;

type_name
        : specifier_qualifier_list
        | specifier_qualifier_list abstract_declarator
        ;

abstract_declarator
        : pointer
        | direct_abstract_declarator
        | pointer direct_abstract_declarator
        ;

direct_abstract_declarator
        : ""("" abstract_declarator "")""
        | <LEFT_BLOCK> <RIGHT_BLOCK>
        | <LEFT_BLOCK> constant_expression <RIGHT_BLOCK>
        | direct_abstract_declarator <LEFT_BLOCK> <RIGHT_BLOCK>
        | direct_abstract_declarator <LEFT_BLOCK> constant_expression <RIGHT_BLOCK>
        | ""("" "")""
        | ""("" parameter_type_list "")""
        | direct_abstract_declarator ""("" "")""
        | direct_abstract_declarator ""("" parameter_type_list "")""
        ;

initializer
        : assignment_expression
        | <LEFT_BRACE> initializer_list <RIGHT_BRACE>
        | <LEFT_BRACE> initializer_list "","" <RIGHT_BRACE>
        ;

initializer_list
        : initializer
        | initializer_list "","" initializer
        ;

statement
        : labeled_statement
        | compound_statement
        | expression_statement
        | selection_statement
        | iteration_statement
        | jump_statement
        ;

labeled_statement
        : <IDENTIFIER> "":"" statement
        | ""case"" constant_expression "":"" statement
        | ""default"" "":"" statement
        ;

compound_statement
        : <LEFT_BRACE> <RIGHT_BRACE>
        | <LEFT_BRACE> statement_list <RIGHT_BRACE>
        | <LEFT_BRACE> declaration_list <RIGHT_BRACE>
        | <LEFT_BRACE> declaration_list statement_list <RIGHT_BRACE>
        ;

declaration_list
        : declaration
        | declaration_list declaration
        ;

statement_list
        : statement
        | statement_list statement
        ;

expression_statement
        : "";""
        | expression "";""
        ;

selection_statement
        : ""if"" ""("" expression "")"" statement
        | ""if"" ""("" expression "")"" statement ""else"" statement
        | ""switch"" ""("" expression "")"" statement
        ;

iteration_statement
        : ""while"" ""("" expression "")"" statement
        | ""do"" statement ""while"" ""("" expression "")"" "";""
        | ""for"" ""("" expression_statement expression_statement "")"" statement
        | ""for"" ""("" expression_statement expression_statement expression "")"" statement
        ;

jump_statement
        : ""goto"" <IDENTIFIER> "";""
        | ""continue"" "";""
        | ""break"" "";""
        | ""return"" "";""
        | ""return"" expression "";""
        ;

external_declaration
        : function_definition
        | declaration
        ;

function_definition
        : declaration_specifiers declarator declaration_list compound_statement
        | declaration_specifiers declarator compound_statement
        | declarator declaration_list compound_statement
        | declarator compound_statement
        ;

"
! !

!CParser methodsFor:'generated-reduction actions'!

reduceActionForenum_specifier2:nodes 
    self addTypeName:(nodes at:2) value.
    ^ self reduceFor:nodes

    "Modified: / 18-11-2008 / 13:47:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

reduceActionForenum_specifier3:nodes 
    self addTypeName:(nodes at:2) value.
    ^ self reduceFor:nodes

    "Modified: / 18-11-2008 / 13:47:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

reduceActionForstruct_or_union_specifier1:nodes 
    self addTypeName:(nodes at:2) value.
    ^ self reduceFor:nodes

    "Modified: / 18-11-2008 / 13:47:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

reduceActionForstruct_or_union_specifier3:nodes 
    self addTypeName:(nodes at:2) value.
    ^ self reduceFor:nodes

    "Modified: / 18-11-2008 / 13:47:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CParser methodsFor:'generated-tables'!

reduceTable
	^#(
#(84 1 #reduceFor:)
#(84 4 #reduceFor:)
#(84 3 #reduceFor:)
#(84 4 #reduceFor:)
#(84 3 #reduceFor:)
#(84 3 #reduceFor:)
#(84 2 #reduceFor:)
#(84 2 #reduceFor:)
#(85 1 #reduceFor:)
#(85 1 #reduceFor:)
#(85 1 #reduceFor:)
#(85 3 #reduceFor:)
#(86 1 #reduceFor:)
#(86 3 #reduceFor:)
#(87 1 #reduceFor:)
#(87 3 #reduceFor:)
#(88 1 #reduceFor:)
#(88 2 #reduceFor:)
#(88 2 #reduceFor:)
#(88 2 #reduceFor:)
#(88 2 #reduceFor:)
#(88 4 #reduceFor:)
#(89 1 #reduceFor:)
#(89 1 #reduceFor:)
#(89 1 #reduceFor:)
#(89 1 #reduceFor:)
#(89 1 #reduceFor:)
#(89 1 #reduceFor:)
#(90 1 #reduceFor:)
#(90 4 #reduceFor:)
#(91 1 #reduceFor:)
#(91 2 #reduceFor:)
#(92 1 #reduceFor:)
#(92 3 #reduceFor:)
#(92 3 #reduceFor:)
#(92 3 #reduceFor:)
#(93 1 #reduceFor:)
#(93 3 #reduceFor:)
#(93 3 #reduceFor:)
#(94 1 #reduceFor:)
#(94 3 #reduceFor:)
#(94 3 #reduceFor:)
#(95 1 #reduceFor:)
#(95 3 #reduceFor:)
#(95 3 #reduceFor:)
#(95 3 #reduceFor:)
#(95 3 #reduceFor:)
#(96 1 #reduceFor:)
#(96 3 #reduceFor:)
#(96 3 #reduceFor:)
#(97 1 #reduceFor:)
#(97 3 #reduceFor:)
#(98 1 #reduceFor:)
#(98 3 #reduceFor:)
#(99 1 #reduceFor:)
#(99 3 #reduceFor:)
#(100 1 #reduceFor:)
#(100 3 #reduceFor:)
#(101 1 #reduceFor:)
#(101 3 #reduceFor:)
#(102 1 #reduceFor:)
#(102 5 #reduceFor:)
#(103 1 #reduceFor:)
#(103 1 #reduceFor:)
#(103 1 #reduceFor:)
#(103 1 #reduceFor:)
#(103 1 #reduceFor:)
#(103 1 #reduceFor:)
#(103 1 #reduceFor:)
#(103 1 #reduceFor:)
#(103 1 #reduceFor:)
#(103 1 #reduceFor:)
#(103 1 #reduceFor:)
#(104 1 #reduceFor:)
#(105 1 #reduceFor:)
#(105 2 #reduceFor:)
#(105 1 #reduceFor:)
#(105 2 #reduceFor:)
#(105 1 #reduceFor:)
#(105 2 #reduceFor:)
#(106 1 #reduceFor:)
#(106 3 #reduceFor:)
#(107 2 #reduceFor:)
#(107 3 #reduceFor:)
#(108 1 #reduceFor:)
#(108 1 #reduceFor:)
#(108 1 #reduceFor:)
#(108 1 #reduceFor:)
#(108 1 #reduceFor:)
#(109 1 #reduceFor:)
#(109 1 #reduceFor:)
#(109 1 #reduceFor:)
#(109 1 #reduceFor:)
#(109 1 #reduceFor:)
#(109 1 #reduceFor:)
#(109 1 #reduceFor:)
#(109 1 #reduceFor:)
#(109 1 #reduceFor:)
#(109 1 #reduceFor:)
#(109 1 #reduceFor:)
#(109 1 #reduceFor:)
#(110 1 #reduceFor:)
#(110 1 #reduceFor:)
#(111 1 #reduceFor:)
#(111 3 #reduceFor:)
#(112 2 #reduceFor:)
#(112 1 #reduceFor:)
#(113 1 #reduceFor:)
#(113 1 #reduceFor:)
#(114 5 #'reduceActionForstruct_or_union_specifier1:')
#(114 4 #reduceFor:)
#(114 2 #'reduceActionForstruct_or_union_specifier3:')
#(115 4 #reduceFor:)
#(115 5 #'reduceActionForenum_specifier2:')
#(115 2 #'reduceActionForenum_specifier3:')
#(116 1 #reduceFor:)
#(116 1 #reduceFor:)
#(117 1 #reduceFor:)
#(118 1 #reduceFor:)
#(118 2 #reduceFor:)
#(119 1 #reduceFor:)
#(119 3 #reduceFor:)
#(120 3 #reduceFor:)
#(121 2 #reduceFor:)
#(121 1 #reduceFor:)
#(121 2 #reduceFor:)
#(121 1 #reduceFor:)
#(122 1 #reduceFor:)
#(122 3 #reduceFor:)
#(123 1 #reduceFor:)
#(123 2 #reduceFor:)
#(123 3 #reduceFor:)
#(124 1 #reduceFor:)
#(124 3 #reduceFor:)
#(125 1 #reduceFor:)
#(125 3 #reduceFor:)
#(126 1 #reduceFor:)
#(126 2 #reduceFor:)
#(126 2 #reduceFor:)
#(126 3 #reduceFor:)
#(127 1 #reduceFor:)
#(127 3 #reduceFor:)
#(127 4 #reduceFor:)
#(127 3 #reduceFor:)
#(127 4 #reduceFor:)
#(127 4 #reduceFor:)
#(127 3 #reduceFor:)
#(128 1 #reduceFor:)
#(128 3 #reduceFor:)
#(129 1 #reduceFor:)
#(129 3 #reduceFor:)
#(130 1 #reduceFor:)
#(130 2 #reduceFor:)
#(131 1 #reduceFor:)
#(131 3 #reduceFor:)
#(133 2 #reduceFor:)
#(133 2 #reduceFor:)
#(133 1 #reduceFor:)
#(134 1 #reduceFor:)
#(134 1 #reduceFor:)
#(134 2 #reduceFor:)
#(135 3 #reduceFor:)
#(135 2 #reduceFor:)
#(135 3 #reduceFor:)
#(135 3 #reduceFor:)
#(135 4 #reduceFor:)
#(135 2 #reduceFor:)
#(135 3 #reduceFor:)
#(135 3 #reduceFor:)
#(135 4 #reduceFor:)
#(136 1 #reduceFor:)
#(136 3 #reduceFor:)
#(137 3 #reduceFor:)
#(137 4 #reduceFor:)
#(137 3 #reduceFor:)
#(138 2 #reduceFor:)
#(138 3 #reduceFor:)
#(138 3 #reduceFor:)
#(138 4 #reduceFor:)
#(139 1 #reduceFor:)
#(139 2 #reduceFor:)
#(140 5 #reduceFor:)
#(140 7 #reduceFor:)
#(140 5 #reduceFor:)
#(141 5 #reduceFor:)
#(141 7 #reduceFor:)
#(141 6 #reduceFor:)
#(141 7 #reduceFor:)
#(142 3 #reduceFor:)
#(142 2 #reduceFor:)
#(142 2 #reduceFor:)
#(142 2 #reduceFor:)
#(142 3 #reduceFor:)
#(143 1 #reduceFor:)
#(143 1 #reduceFor:)
#(143 1 #reduceFor:)
#(143 1 #reduceFor:)
#(143 1 #reduceFor:)
#(143 1 #reduceFor:)
#(144 1 #reduceFor:)
#(144 2 #reduceFor:)
#(145 1 #reduceFor:)
#(145 2 #reduceFor:)
#(146 4 #reduceFor:)
#(146 3 #reduceFor:)
#(146 3 #reduceFor:)
#(146 2 #reduceFor:)
#(149 1 #reduceFor:)
#(149 2 #reduceFor:)
#(150 1 #reduceFor:)
#(150 3 #reduceFor:)
#(150 4 #reduceFor:)
)

    "Modified: / 18-11-2008 / 13:47:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

transitionTable
	^#(
#[1 0 9 0 25 0 13 0 34 0 17 0 40 0 21 0 41 0 25 0 43 0 29 0 44 0 33 0 45 0 37 0 51 0 41 0 55 0 45 0 57 0 49 0 58 0 53 0 61 0 57 0 65 0 61 0 66 0 65 0 67 0 69 0 68 0 73 0 69 0 77 0 70 0 81 0 71 0 85 0 72 0 89 0 73 0 93 0 76 0 97 0 105 0 101 0 107 0 105 0 108 0 109 0 109 0 113 0 110 0 117 0 112 0 121 0 113 0 125 0 114 0 129 0 115 0 133 0 116 0 137 0 126 0 141 0 127 0 145 0 132 0 149 0 146 0 153 0 149]
#[1 0 9 0 25 0 13 0 34 0 93 0 76 0 157 0 112 0 137 0 126 0 141 0 127]
#[1 2 38 0 21 2 38 0 25 2 38 0 26 0 13 0 34 0 17 0 40 0 21 0 41 2 38 0 76 2 38 0 79 0 161 0 110 0 165 0 126 0 169 0 130]
#[0 1 154 0 16 0 21 0 25 0 26 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 79 0 132]
#[0 1 158 0 16 0 21 0 25 0 26 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 79 0 132]
#[0 1 210 0 76 0 81]
#[0 1 214 0 76 0 81]
#[1 0 173 0 76 0 177 0 81]
#[0 1 134 0 16 0 21 0 25 0 26 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 79 0 132]
#[0 1 138 0 16 0 21 0 25 0 26 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 79 0 132]
#[0 1 86 0 21 0 25 0 26 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 79 0 132]
#[0 1 90 0 21 0 25 0 26 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 79 0 132]
#[0 1 94 0 21 0 25 0 26 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 79 0 132]
#[0 1 98 0 21 0 25 0 26 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 79 0 132]
#[0 1 122 0 16 0 21 0 25 0 26 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 79 0 132]
#[0 1 126 0 16 0 21 0 25 0 26 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 79 0 132]
#[0 1 114 0 16 0 21 0 25 0 26 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 79 0 132]
#[0 1 118 0 16 0 21 0 25 0 26 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 79 0 132]
#[0 1 130 0 16 0 21 0 25 0 26 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 79 0 132]
#[0 1 102 0 21 0 25 0 26 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 79 0 132]
#[0 1 106 0 16 0 21 0 25 0 26 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 79 0 132]
#[0 1 110 0 16 0 21 0 25 0 26 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 79 0 132]
#[0 2 54 0 16 0 17 0 21 0 25 0 26 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 79 0 81 0 132]
#[1 0 9 0 25 0 13 0 34 0 181 0 60 0 93 0 76 0 185 0 106 0 189 0 111 0 193 0 112 0 137 0 126 0 141 0 127]
#[0 1 182 0 25 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 132 0 147]
#[1 1 46 0 21 1 46 0 25 1 46 0 26 1 46 0 34 0 17 0 40 0 21 0 41 0 25 0 43 0 29 0 44 0 33 0 45 0 37 0 51 0 41 0 55 0 45 0 57 0 49 0 58 1 46 0 60 0 53 0 61 0 57 0 65 0 61 0 66 0 65 0 67 0 69 0 68 0 73 0 69 0 77 0 70 0 81 0 71 0 85 0 72 0 89 0 73 1 46 0 76 1 46 0 79 0 197 0 105 0 105 0 108 0 109 0 109 0 113 0 110 0 125 0 114 0 129 0 115 0 133 0 116 0 145 0 132]
#[1 1 54 0 21 1 54 0 25 1 54 0 26 1 54 0 34 0 17 0 40 0 21 0 41 0 25 0 43 0 29 0 44 0 33 0 45 0 37 0 51 0 41 0 55 0 45 0 57 0 49 0 58 1 54 0 60 0 53 0 61 0 57 0 65 0 61 0 66 0 65 0 67 0 69 0 68 0 73 0 69 0 77 0 70 0 81 0 71 0 85 0 72 0 89 0 73 1 54 0 76 1 54 0 79 0 201 0 105 0 105 0 108 0 109 0 109 0 113 0 110 0 125 0 114 0 129 0 115 0 133 0 116 0 145 0 132]
#[1 1 62 0 21 1 62 0 25 1 62 0 26 1 62 0 34 0 17 0 40 0 21 0 41 0 25 0 43 0 29 0 44 0 33 0 45 0 37 0 51 0 41 0 55 0 45 0 57 0 49 0 58 1 62 0 60 0 53 0 61 0 57 0 65 0 61 0 66 0 65 0 67 0 69 0 68 0 73 0 69 0 77 0 70 0 81 0 71 0 85 0 72 0 89 0 73 1 62 0 76 1 62 0 79 0 205 0 105 0 105 0 108 0 109 0 109 0 113 0 110 0 125 0 114 0 129 0 115 0 133 0 116 0 145 0 132]
#[1 0 17 0 40 0 21 0 41 0 25 0 43 0 29 0 44 0 33 0 45 0 37 0 51 0 41 0 55 0 45 0 57 0 49 0 58 0 53 0 61 0 57 0 65 0 61 0 66 0 65 0 67 0 69 0 68 0 73 0 69 0 77 0 70 0 81 0 71 0 85 0 72 0 89 0 73 0 209 0 81 0 213 0 105 0 217 0 107 0 105 0 108 0 109 0 109 0 113 0 110 0 125 0 114 0 129 0 115 0 133 0 116 0 145 0 132 0 221 0 138 0 225 0 145]
#[0 3 66 0 25 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 132 0 147]
#[0 1 142 0 16 0 21 0 25 0 26 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 79 0 132]
#[0 1 146 0 16 0 21 0 25 0 26 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 79 0 132]
#[1 0 229 0 76 0 233 0 81]
#[1 0 9 0 25 0 93 0 76 0 237 0 127]
#[1 1 174 0 16 1 174 0 17 1 174 0 21 0 241 0 25 1 174 0 26 1 174 0 40 1 174 0 41 1 174 0 43 1 174 0 44 1 174 0 45 1 174 0 51 1 174 0 55 1 174 0 57 1 174 0 58 1 174 0 60 1 174 0 61 1 174 0 65 1 174 0 66 1 174 0 67 1 174 0 68 1 174 0 69 1 174 0 70 1 174 0 71 1 174 0 72 1 174 0 73 0 245 0 79 1 174 0 81 1 174 0 132]
#[0 1 150 0 16 0 21 0 25 0 26 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 79 0 132]
#[0 1 178 0 25 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 132 0 147]
#[1 0 9 0 25 0 13 0 34 0 17 0 40 0 21 0 41 0 25 0 43 0 29 0 44 0 33 0 45 0 37 0 51 0 41 0 55 0 45 0 57 0 49 0 58 0 53 0 61 0 57 0 65 0 61 0 66 0 65 0 67 0 69 0 68 0 73 0 69 0 77 0 70 0 81 0 71 0 85 0 72 0 89 0 73 0 93 0 76 0 97 0 105 0 101 0 107 0 105 0 108 0 109 0 109 0 113 0 110 0 117 0 112 0 249 0 113 0 125 0 114 0 129 0 115 0 133 0 116 0 137 0 126 0 141 0 127 0 145 0 132 0 149 0 146 0 0 0 147]
#[0 0 253 0 26]
#[0 2 98 0 21 0 25 0 26 0 34 0 40 0 41 0 76 0 79]
#[0 2 46 0 21 0 25 0 26 0 76 0 79]
#[1 2 42 0 21 2 42 0 25 2 42 0 26 0 13 0 34 0 17 0 40 0 21 0 41 2 42 0 76 2 42 0 79 1 1 0 110 1 5 0 126]
#[1 1 206 0 16 1 206 0 21 1 206 0 25 1 206 0 26 1 206 0 34 1 206 0 40 1 206 0 41 1 206 0 43 1 206 0 44 1 206 0 45 1 206 0 51 1 206 0 55 1 206 0 57 1 206 0 58 1 206 0 60 1 206 0 61 1 206 0 65 1 206 0 66 1 206 0 67 1 206 0 68 1 206 0 69 1 206 0 70 1 206 0 71 1 206 0 72 1 206 0 73 1 206 0 76 1 206 0 79 1 9 0 81 1 206 0 132]
#[1 1 13 0 76 1 17 0 124 1 21 0 125]
#[0 1 78 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 77 0 78 0 81 0 82 0 132 0 147]
#[1 1 25 0 21 1 29 0 60]
#[0 1 70 0 21 0 60]
#[1 1 33 0 17 1 162 0 21 0 17 0 40 0 21 0 41 0 25 0 43 0 29 0 44 0 33 0 45 0 37 0 51 0 41 0 55 0 45 0 57 0 49 0 58 1 162 0 60 0 53 0 61 0 57 0 65 0 61 0 66 0 65 0 67 0 69 0 68 0 73 0 69 0 77 0 70 0 81 0 71 0 85 0 72 0 89 0 73 0 209 0 81 0 213 0 105 0 217 0 107 0 105 0 108 0 109 0 109 0 113 0 110 0 125 0 114 0 129 0 115 0 133 0 116 0 145 0 132 1 37 0 138 1 41 0 145]
#[0 1 50 0 21 0 25 0 26 0 34 0 60 0 76 0 79]
#[0 1 58 0 21 0 25 0 26 0 34 0 60 0 76 0 79]
#[0 1 66 0 21 0 25 0 26 0 34 0 60 0 76 0 79]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 1 85 0 38 1 89 0 39 0 17 0 40 0 21 0 41 1 93 0 42 0 25 0 43 0 29 0 44 0 33 0 45 1 97 0 47 1 101 0 48 1 105 0 49 1 109 0 50 0 37 0 51 1 113 0 52 1 117 0 53 1 121 0 54 0 41 0 55 1 125 0 56 0 45 0 57 0 49 0 58 1 129 0 60 0 53 0 61 0 57 0 65 0 61 0 66 0 65 0 67 0 69 0 68 0 73 0 69 0 77 0 70 0 81 0 71 0 85 0 72 0 89 0 73 1 133 0 76 1 137 0 77 1 141 0 78 0 209 0 81 1 145 0 82 1 149 0 84 1 153 0 85 1 157 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 197 0 98 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 0 213 0 105 0 217 0 107 0 105 0 108 0 109 0 109 0 113 0 110 0 125 0 114 0 129 0 115 0 133 0 116 1 217 0 119 0 145 0 132 1 221 0 137 1 225 0 138 1 229 0 139 1 233 0 140 1 237 0 141 1 241 0 142 1 245 0 143 1 249 0 144 1 253 0 145]
#[1 0 9 0 25 0 13 0 34 0 181 0 60 0 93 0 76 0 185 0 106 0 189 0 111 2 1 0 112 0 137 0 126 0 141 0 127]
#[0 3 42 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 77 0 78 0 81 0 82 0 132]
#[0 3 62 0 25 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 132 0 147]
#[1 0 17 0 40 0 21 0 41 0 25 0 43 0 29 0 44 0 33 0 45 0 37 0 51 0 41 0 55 0 45 0 57 0 49 0 58 0 53 0 61 0 57 0 65 0 61 0 66 0 65 0 67 0 69 0 68 0 73 0 69 0 77 0 70 0 81 0 71 0 85 0 72 0 89 0 73 0 209 0 81 0 213 0 105 2 5 0 107 0 105 0 108 0 109 0 109 0 113 0 110 0 125 0 114 0 129 0 115 0 133 0 116 0 145 0 132 2 9 0 138]
#[1 1 194 0 16 1 194 0 21 1 194 0 25 1 194 0 26 1 194 0 34 1 194 0 40 1 194 0 41 1 194 0 43 1 194 0 44 1 194 0 45 1 194 0 51 1 194 0 55 1 194 0 57 1 194 0 58 1 194 0 60 1 194 0 61 1 194 0 65 1 194 0 66 1 194 0 67 1 194 0 68 1 194 0 69 1 194 0 70 1 194 0 71 1 194 0 72 1 194 0 73 1 194 0 76 1 194 0 79 2 13 0 81 1 194 0 132]
#[1 0 17 0 40 0 21 0 41 0 25 0 43 0 29 0 44 0 33 0 45 0 37 0 51 0 41 0 55 0 61 0 66 0 65 0 67 0 69 0 68 0 73 0 69 0 77 0 70 0 85 0 72 0 89 0 73 2 17 0 109 2 21 0 110 0 125 0 114 0 129 0 115 0 133 0 116 2 25 0 118 2 29 0 120 2 33 0 121 0 145 0 132]
#[1 1 170 0 16 1 170 0 17 1 170 0 21 0 241 0 25 1 170 0 26 1 170 0 40 1 170 0 41 1 170 0 43 1 170 0 44 1 170 0 45 1 170 0 51 1 170 0 55 1 170 0 57 1 170 0 58 1 170 0 60 1 170 0 61 1 170 0 65 1 170 0 66 1 170 0 67 1 170 0 68 1 170 0 69 1 170 0 70 1 170 0 71 1 170 0 72 1 170 0 73 0 245 0 79 1 170 0 81 1 170 0 132]
#[1 2 37 0 26 0 17 0 40 0 21 0 41 0 25 0 43 0 29 0 44 0 33 0 45 0 37 0 51 0 41 0 55 0 45 0 57 0 49 0 58 0 53 0 61 0 57 0 65 0 61 0 66 0 65 0 67 0 69 0 68 0 73 0 69 0 77 0 70 0 81 0 71 0 85 0 72 0 89 0 73 2 41 0 76 2 45 0 105 0 105 0 108 0 109 0 109 0 113 0 110 0 125 0 114 0 129 0 115 0 133 0 116 2 49 0 128 2 53 0 129 2 57 0 131 0 145 0 132 2 61 0 133]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 2 69 0 80 1 149 0 84 1 153 0 85 2 73 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 201 0 99 1 205 0 100 1 209 0 101 2 77 0 102 2 81 0 104 1 217 0 119]
#[0 3 70 0 25 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 132 0 147]
#[0 2 58 0 16 0 17 0 21 0 25 0 26 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 79 0 81 0 132]
#[0 2 102 0 21 0 25 0 26 0 34 0 40 0 41 0 76 0 79]
#[0 2 50 0 21 0 25 0 26 0 76 0 79]
#[1 1 13 0 76 2 85 0 124 1 21 0 125]
#[1 2 89 0 17 2 30 0 21 2 30 0 82]
#[1 2 93 0 21 2 97 0 82]
#[0 2 22 0 21 0 82]
#[1 0 9 0 25 0 13 0 34 0 93 0 76 2 101 0 111 2 1 0 112 0 137 0 126 0 141 0 127]
#[0 1 82 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 77 0 78 0 81 0 82 0 132 0 147]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 2 105 0 81 1 149 0 84 1 153 0 85 2 109 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 1 217 0 119 2 113 0 150]
#[0 3 54 0 25 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 132 0 147]
#[1 0 17 0 40 0 21 0 41 0 25 0 43 0 29 0 44 0 33 0 45 0 37 0 51 0 41 0 55 0 45 0 57 0 49 0 58 0 53 0 61 0 57 0 65 0 61 0 66 0 65 0 67 0 69 0 68 0 73 0 69 0 77 0 70 0 81 0 71 0 85 0 72 0 89 0 73 0 209 0 81 0 213 0 105 2 5 0 107 0 105 0 108 0 109 0 109 0 113 0 110 0 125 0 114 0 129 0 115 0 133 0 116 0 145 0 132 2 117 0 138]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 2 121 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 2 125 0 88 1 165 0 89]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 2 121 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 2 129 0 88 1 165 0 89]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 2 133 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 2 137 0 88 1 165 0 89]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 0 17 0 40 0 21 0 41 0 25 0 43 0 29 0 44 0 33 0 45 0 37 0 51 0 41 0 55 0 61 0 66 0 65 0 67 0 69 0 68 0 73 0 69 0 77 0 70 0 85 0 72 0 89 0 73 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 1 157 0 87 1 161 0 88 1 165 0 89 1 169 0 90 2 141 0 91 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 2 145 0 98 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 2 17 0 109 2 21 0 110 0 125 0 114 0 129 0 115 0 133 0 116 1 217 0 119 2 149 0 121 0 145 0 132]
#[0 0 94 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 76 0 77 0 78]
#[0 0 110 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 76 0 77 0 78]
#[0 0 114 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 76 0 77 0 78]
#[0 0 98 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 76 0 77 0 78]
#[0 0 102 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 76 0 77 0 78]
#[0 0 106 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 76 0 77 0 78]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 2 73 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 201 0 99 1 205 0 100 1 209 0 101 2 77 0 102 2 153 0 104 1 217 0 119]
#[0 2 157 0 16]
#[0 2 161 0 25]
#[0 2 165 0 60]
#[0 2 169 0 60]
#[0 2 173 0 25]
#[0 2 177 0 76]
#[0 2 181 0 25]
#[0 2 185 0 25]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 1 85 0 38 1 89 0 39 1 93 0 42 1 97 0 47 1 101 0 48 1 105 0 49 1 109 0 50 1 113 0 52 1 117 0 53 1 121 0 54 1 125 0 56 1 129 0 60 1 133 0 76 1 137 0 77 1 141 0 78 0 209 0 81 1 149 0 84 1 153 0 85 1 157 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 197 0 98 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 1 217 0 119 1 221 0 137 1 225 0 138 1 229 0 139 1 233 0 140 1 237 0 141 1 241 0 142 2 189 0 143]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 193 0 60 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 1 157 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 2 197 0 98 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 1 217 0 119]
#[0 2 210 0 20 0 23 0 24 0 25 0 26 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 42 0 46 0 47 0 48 0 49 0 50 0 52 0 53 0 54 0 56 0 60 0 76 0 77 0 78 0 81 0 82]
#[1 0 38 0 1 0 38 0 2 0 38 0 3 0 38 0 4 0 38 0 5 0 38 0 6 0 38 0 7 0 38 0 8 0 38 0 9 0 38 0 10 0 38 0 11 0 38 0 12 0 38 0 13 0 38 0 14 0 38 0 15 2 201 0 16 0 38 0 17 0 38 0 18 0 38 0 19 0 38 0 20 0 38 0 21 0 38 0 22 0 38 0 23 0 38 0 25 0 38 0 27 0 38 0 28 0 38 0 29 0 38 0 30 0 38 0 33 0 38 0 34 0 38 0 35 0 38 0 36 0 38 0 37 0 38 0 59 0 38 0 60 0 38 0 62 0 38 0 63 0 38 0 64 0 38 0 79]
#[0 0 42 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 23 0 25 0 26 0 27 0 28 0 29 0 30 0 33 0 34 0 35 0 36 0 37 0 59 0 60 0 62 0 63 0 64 0 79 0 80 0 82]
#[0 0 46 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 23 0 25 0 26 0 27 0 28 0 29 0 30 0 33 0 34 0 35 0 36 0 37 0 59 0 60 0 62 0 63 0 64 0 79 0 80 0 82]
#[0 2 194 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 77 0 78 0 81 0 82 0 132 0 147]
#[1 0 70 0 1 0 70 0 2 0 70 0 3 0 70 0 4 0 70 0 5 0 70 0 6 0 70 0 7 0 70 0 8 0 70 0 9 0 70 0 10 0 70 0 11 0 70 0 12 0 70 0 13 0 70 0 14 0 70 0 15 0 70 0 16 0 70 0 17 0 70 0 18 0 70 0 19 2 205 0 20 0 70 0 21 2 209 0 22 2 213 0 23 2 217 0 25 0 70 0 26 2 221 0 27 0 70 0 28 0 70 0 29 0 70 0 30 0 70 0 33 0 70 0 34 0 70 0 35 0 70 0 36 0 70 0 37 0 70 0 59 0 70 0 60 0 70 0 62 0 70 0 63 0 70 0 64 2 225 0 79 0 70 0 80 0 70 0 82]
#[0 0 6 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 23 0 25 0 26 0 27 0 28 0 29 0 30 0 33 0 34 0 35 0 36 0 37 0 59 0 60 0 62 0 63 0 64 0 79 0 80 0 82]
#[0 0 214 0 16 0 21 0 26 0 60 0 80]
#[1 0 118 0 1 0 118 0 2 0 118 0 3 0 118 0 4 0 118 0 5 0 118 0 6 0 118 0 7 0 118 0 8 0 118 0 9 2 229 0 10 2 233 0 11 2 237 0 12 2 241 0 13 0 118 0 14 0 118 0 15 0 118 0 16 2 245 0 17 0 118 0 18 2 249 0 19 0 118 0 21 0 118 0 26 0 118 0 28 0 118 0 29 0 118 0 30 0 118 0 33 0 118 0 34 0 118 0 35 0 118 0 36 2 253 0 37 3 1 0 59 0 118 0 60 3 5 0 62 3 9 0 63 3 13 0 64 0 118 0 80 0 118 0 82 3 17 0 103]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 2 73 0 88 1 165 0 89 3 21 0 90]
#[0 0 134 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 14 0 15 0 16 0 18 0 21 0 26 0 28 0 29 0 30 0 33 0 34 0 35 0 36 0 60 0 80 0 82]
#[1 0 150 0 1 0 150 0 2 0 150 0 3 0 150 0 4 0 150 0 5 0 150 0 6 0 150 0 7 0 150 0 8 0 150 0 9 0 150 0 14 0 150 0 15 0 150 0 16 0 150 0 18 0 150 0 21 0 150 0 26 0 150 0 28 3 25 0 29 3 29 0 30 0 150 0 33 3 33 0 34 0 150 0 35 0 150 0 36 0 150 0 60 0 150 0 80 0 150 0 82]
#[1 0 162 0 1 0 162 0 2 0 162 0 3 0 162 0 4 0 162 0 5 0 162 0 6 0 162 0 7 0 162 0 8 0 162 0 9 0 162 0 14 0 162 0 15 0 162 0 16 0 162 0 18 0 162 0 21 0 162 0 26 0 162 0 28 0 162 0 33 3 37 0 35 3 41 0 36 0 162 0 60 0 162 0 80 0 162 0 82]
#[1 0 174 0 1 0 174 0 2 0 174 0 3 0 174 0 4 0 174 0 5 0 174 0 6 0 174 0 7 0 174 0 8 0 174 0 9 3 45 0 14 0 174 0 15 0 174 0 16 0 174 0 18 0 174 0 21 0 174 0 26 0 174 0 28 3 49 0 33 0 174 0 60 0 174 0 80 0 174 0 82]
#[1 0 194 0 1 0 194 0 2 0 194 0 3 0 194 0 4 0 194 0 5 3 53 0 6 3 57 0 7 3 61 0 8 0 194 0 9 0 194 0 15 0 194 0 16 3 65 0 18 0 194 0 21 0 194 0 26 0 194 0 28 0 194 0 60 0 194 0 80 0 194 0 82]
#[1 0 206 0 1 0 206 0 2 3 69 0 3 3 73 0 4 0 206 0 5 0 206 0 9 0 206 0 15 0 206 0 16 0 206 0 21 0 206 0 26 0 206 0 28 0 206 0 60 0 206 0 80 0 206 0 82]
#[1 1 230 0 1 1 230 0 2 1 230 0 5 1 230 0 9 1 230 0 15 1 230 0 16 1 230 0 21 1 230 0 26 3 77 0 28 1 230 0 60 1 230 0 80 1 230 0 82]
#[1 3 81 0 21 3 85 0 60]
#[1 3 89 0 2 0 230 0 5 0 230 0 9 0 230 0 15 0 230 0 16 0 230 0 21 0 230 0 26 0 230 0 60 0 230 0 80 0 230 0 82]
#[1 3 93 0 5 0 238 0 9 0 238 0 15 0 238 0 16 0 238 0 21 0 238 0 26 0 238 0 60 0 238 0 80 0 238 0 82]
#[1 3 97 0 9 3 101 0 15 0 246 0 16 0 246 0 21 0 246 0 26 0 246 0 60 0 246 0 80 0 246 0 82]
#[0 0 62 0 16 0 21 0 26 0 60 0 80 0 82]
#[1 3 105 0 1 0 222 0 2 0 222 0 5 0 222 0 9 0 222 0 15 0 222 0 16 0 222 0 21 0 222 0 26 0 222 0 60 0 222 0 80 0 222 0 82]
#[0 3 10 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 42 0 46 0 47 0 48 0 49 0 50 0 52 0 53 0 54 0 56 0 60 0 76 0 77 0 78 0 81 0 82]
#[0 3 14 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 42 0 46 0 47 0 48 0 49 0 50 0 52 0 53 0 54 0 56 0 60 0 76 0 77 0 78 0 81 0 82]
#[0 3 18 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 42 0 46 0 47 0 48 0 49 0 50 0 52 0 53 0 54 0 56 0 60 0 76 0 77 0 78 0 81 0 82]
#[0 3 22 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 42 0 46 0 47 0 48 0 49 0 50 0 52 0 53 0 54 0 56 0 60 0 76 0 77 0 78 0 81 0 82]
#[0 3 26 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 42 0 46 0 47 0 48 0 49 0 50 0 52 0 53 0 54 0 56 0 60 0 76 0 77 0 78 0 81 0 82]
#[0 3 30 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 42 0 46 0 47 0 48 0 49 0 50 0 52 0 53 0 54 0 56 0 60 0 76 0 77 0 78 0 81 0 82]
#[0 3 34 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 42 0 47 0 48 0 49 0 50 0 52 0 53 0 54 0 56 0 60 0 76 0 77 0 78 0 81 0 82]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 1 85 0 38 1 89 0 39 1 93 0 42 1 97 0 47 1 101 0 48 1 105 0 49 1 109 0 50 1 113 0 52 1 117 0 53 1 121 0 54 1 125 0 56 1 129 0 60 1 133 0 76 1 137 0 77 1 141 0 78 0 209 0 81 3 109 0 82 1 149 0 84 1 153 0 85 1 157 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 197 0 98 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 1 217 0 119 1 221 0 137 1 225 0 138 1 229 0 139 1 233 0 140 1 237 0 141 1 241 0 142 3 113 0 143]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 1 85 0 38 1 89 0 39 0 17 0 40 0 21 0 41 1 93 0 42 0 25 0 43 0 29 0 44 0 33 0 45 1 97 0 47 1 101 0 48 1 105 0 49 1 109 0 50 0 37 0 51 1 113 0 52 1 117 0 53 1 121 0 54 0 41 0 55 1 125 0 56 0 45 0 57 0 49 0 58 1 129 0 60 0 53 0 61 0 57 0 65 0 61 0 66 0 65 0 67 0 69 0 68 0 73 0 69 0 77 0 70 0 81 0 71 0 85 0 72 0 89 0 73 1 133 0 76 1 137 0 77 1 141 0 78 0 209 0 81 3 117 0 82 1 149 0 84 1 153 0 85 1 157 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 197 0 98 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 0 213 0 105 2 5 0 107 0 105 0 108 0 109 0 109 0 113 0 110 0 125 0 114 0 129 0 115 0 133 0 116 1 217 0 119 0 145 0 132 1 221 0 137 1 225 0 138 1 229 0 139 1 233 0 140 1 237 0 141 1 241 0 142 1 245 0 143 3 121 0 144]
#[1 1 33 0 17 1 162 0 21 1 162 0 60]
#[0 3 46 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 77 0 78 0 81 0 82 0 132]
#[0 3 58 0 25 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 132 0 147]
#[1 0 17 0 40 0 21 0 41 0 25 0 43 0 29 0 44 0 33 0 45 0 37 0 51 0 41 0 55 0 61 0 66 0 65 0 67 0 69 0 68 0 73 0 69 0 77 0 70 0 85 0 72 0 89 0 73 2 17 0 109 2 21 0 110 0 125 0 114 0 129 0 115 0 133 0 116 3 125 0 118 2 29 0 120 2 33 0 121 0 145 0 132]
#[1 1 246 0 16 1 246 0 25 1 246 0 26 1 246 0 34 0 17 0 40 0 21 0 41 0 25 0 43 0 29 0 44 0 33 0 45 0 37 0 51 0 41 0 55 0 61 0 66 0 65 0 67 0 69 0 68 0 73 0 69 0 77 0 70 0 85 0 72 0 89 0 73 1 246 0 76 1 246 0 79 2 17 0 109 2 21 0 110 0 125 0 114 0 129 0 115 0 133 0 116 3 129 0 121 0 145 0 132]
#[1 1 254 0 16 1 254 0 25 1 254 0 26 1 254 0 34 0 17 0 40 0 21 0 41 0 25 0 43 0 29 0 44 0 33 0 45 0 37 0 51 0 41 0 55 0 61 0 66 0 65 0 67 0 69 0 68 0 73 0 69 0 77 0 70 0 85 0 72 0 89 0 73 1 254 0 76 1 254 0 79 2 17 0 109 2 21 0 110 0 125 0 114 0 129 0 115 0 133 0 116 3 133 0 121 0 145 0 132]
#[1 0 17 0 40 0 21 0 41 0 25 0 43 0 29 0 44 0 33 0 45 0 37 0 51 0 41 0 55 0 61 0 66 0 65 0 67 0 69 0 68 0 73 0 69 0 77 0 70 0 85 0 72 0 89 0 73 3 137 0 82 2 17 0 109 2 21 0 110 0 125 0 114 0 129 0 115 0 133 0 116 3 141 0 120 2 33 0 121 0 145 0 132]
#[0 1 222 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 66 0 67 0 68 0 69 0 70 0 72 0 73 0 82 0 132]
#[1 3 145 0 16 0 9 0 25 0 13 0 34 0 93 0 76 3 149 0 112 3 153 0 122 3 157 0 123 0 137 0 126 0 141 0 127]
#[0 2 78 0 16 0 17 0 21 0 25 0 26 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 79 0 81 0 132]
#[0 2 90 0 21 0 26]
#[1 2 122 0 21 3 161 0 25 2 122 0 26 0 13 0 34 0 93 0 76 3 165 0 79 3 169 0 112 3 173 0 126 0 141 0 127 3 177 0 134 3 181 0 135]
#[0 3 185 0 26]
#[1 3 189 0 21 3 193 0 26]
#[1 3 197 0 21 2 82 0 26]
#[0 2 106 0 21 0 26]
#[0 0 38 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 23 0 25 0 26 0 27 0 28 0 29 0 30 0 33 0 34 0 35 0 36 0 37 0 59 0 60 0 62 0 63 0 64 0 79 0 80 0 82]
#[0 2 66 0 16 0 17 0 21 0 25 0 26 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 79 0 81 0 132]
#[0 0 118 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 21 0 26 0 28 0 29 0 30 0 33 0 34 0 35 0 36 0 37 0 59 0 60 0 62 0 63 0 64 0 80 0 82]
#[0 1 42 0 16 0 21 0 60 0 80 0 82]
#[0 3 201 0 80]
#[1 2 93 0 21 3 205 0 82]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 2 73 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 201 0 99 1 205 0 100 1 209 0 101 2 77 0 102 3 209 0 104 1 217 0 119]
#[1 1 13 0 76 3 213 0 125]
#[0 1 198 0 16 0 21 0 25 0 26 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 79 0 132]
#[0 1 74 0 21 0 60]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 2 105 0 81 1 149 0 84 1 153 0 85 2 109 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 1 217 0 119 3 217 0 136 3 221 0 150]
#[0 3 74 0 21 0 60 0 82]
#[0 1 166 0 21 0 60]
#[0 3 50 0 25 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 132 0 147]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 1 157 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 2 145 0 98 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 1 217 0 119]
#[0 0 78 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 21 0 26 0 28 0 29 0 30 0 33 0 34 0 35 0 36 0 37 0 59 0 60 0 62 0 63 0 64 0 80 0 82]
#[0 0 74 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 21 0 26 0 28 0 29 0 30 0 33 0 34 0 35 0 36 0 37 0 59 0 60 0 62 0 63 0 64 0 80 0 82]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 0 17 0 40 0 21 0 41 0 25 0 43 0 29 0 44 0 33 0 45 0 37 0 51 0 41 0 55 0 61 0 66 0 65 0 67 0 69 0 68 0 73 0 69 0 77 0 70 0 85 0 72 0 89 0 73 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 1 157 0 87 1 161 0 88 1 165 0 89 1 169 0 90 3 225 0 91 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 2 145 0 98 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 2 17 0 109 2 21 0 110 0 125 0 114 0 129 0 115 0 133 0 116 1 217 0 119 2 149 0 121 0 145 0 132]
#[0 0 86 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 21 0 26 0 28 0 29 0 30 0 33 0 34 0 35 0 36 0 37 0 59 0 60 0 62 0 63 0 64 0 80 0 82]
#[0 3 229 0 26]
#[1 3 81 0 21 3 233 0 26]
#[1 3 237 0 25 0 126 0 26 0 13 0 34 3 165 0 79 3 241 0 126 3 245 0 134 3 181 0 135]
#[0 3 249 0 16]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 1 85 0 38 1 89 0 39 1 93 0 42 1 97 0 47 1 101 0 48 1 105 0 49 1 109 0 50 1 113 0 52 1 117 0 53 1 121 0 54 1 125 0 56 1 129 0 60 1 133 0 76 1 137 0 77 1 141 0 78 0 209 0 81 1 149 0 84 1 153 0 85 1 157 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 197 0 98 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 1 217 0 119 1 221 0 137 1 225 0 138 1 229 0 139 1 233 0 140 1 237 0 141 1 241 0 142 3 253 0 143]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 1 157 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 4 1 0 98 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 1 217 0 119]
#[0 2 250 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 42 0 46 0 47 0 48 0 49 0 50 0 52 0 53 0 54 0 56 0 60 0 76 0 77 0 78 0 81 0 82]
#[0 2 254 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 42 0 46 0 47 0 48 0 49 0 50 0 52 0 53 0 54 0 56 0 60 0 76 0 77 0 78 0 81 0 82]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 1 129 0 60 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 1 157 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 197 0 98 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 1 217 0 119 4 5 0 139]
#[0 4 9 0 60]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 1 157 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 4 13 0 98 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 1 217 0 119]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 1 157 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 4 17 0 98 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 1 217 0 119]
#[0 4 21 0 53]
#[0 3 2 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 42 0 46 0 47 0 48 0 49 0 50 0 52 0 53 0 54 0 56 0 60 0 76 0 77 0 78 0 81 0 82]
#[1 3 81 0 21 4 25 0 60]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 1 85 0 38 1 89 0 39 1 93 0 42 1 97 0 47 1 101 0 48 1 105 0 49 1 109 0 50 1 113 0 52 1 117 0 53 1 121 0 54 1 125 0 56 1 129 0 60 1 133 0 76 1 137 0 77 1 141 0 78 0 209 0 81 1 149 0 84 1 153 0 85 1 157 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 197 0 98 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 1 217 0 119 1 221 0 137 1 225 0 138 1 229 0 139 1 233 0 140 1 237 0 141 1 241 0 142 4 29 0 143]
#[0 0 34 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 23 0 25 0 26 0 27 0 28 0 29 0 30 0 33 0 34 0 35 0 36 0 37 0 59 0 60 0 62 0 63 0 64 0 79 0 80 0 82]
#[0 4 33 0 76]
#[0 0 30 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 23 0 25 0 26 0 27 0 28 0 29 0 30 0 33 0 34 0 35 0 36 0 37 0 59 0 60 0 62 0 63 0 64 0 79 0 80 0 82]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 4 37 0 26 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 4 41 0 86 4 45 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 1 217 0 119]
#[0 4 49 0 76]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 1 157 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 4 53 0 98 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 1 217 0 119]
#[0 1 10 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 76 0 77 0 78]
#[0 1 14 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 76 0 77 0 78]
#[0 1 2 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 76 0 77 0 78]
#[0 1 6 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 76 0 77 0 78]
#[0 0 254 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 76 0 77 0 78]
#[0 1 18 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 76 0 77 0 78]
#[0 1 22 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 76 0 77 0 78]
#[0 1 38 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 76 0 77 0 78]
#[0 1 26 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 76 0 77 0 78]
#[0 1 30 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 76 0 77 0 78]
#[0 1 34 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 76 0 77 0 78]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 4 57 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 1 217 0 119]
#[0 0 82 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 21 0 26 0 28 0 29 0 30 0 33 0 34 0 35 0 36 0 37 0 59 0 60 0 62 0 63 0 64 0 80 0 82]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 2 73 0 88 1 165 0 89 4 61 0 90]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 2 73 0 88 1 165 0 89 4 65 0 90]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 2 73 0 88 1 165 0 89 4 69 0 90]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 2 73 0 88 1 165 0 89 1 169 0 90 4 73 0 92]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 2 73 0 88 1 165 0 89 1 169 0 90 4 77 0 92]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 2 73 0 88 1 165 0 89 1 169 0 90 1 173 0 92 4 81 0 93]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 2 73 0 88 1 165 0 89 1 169 0 90 1 173 0 92 4 85 0 93]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 2 73 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 4 89 0 94]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 2 73 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 4 93 0 94]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 2 73 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 4 97 0 94]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 2 73 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 4 101 0 94]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 2 73 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 4 105 0 95]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 2 73 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 4 109 0 95]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 2 73 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 4 113 0 96]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 4 117 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 1 217 0 119]
#[0 2 214 0 20 0 23 0 24 0 25 0 26 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 42 0 46 0 47 0 48 0 49 0 50 0 52 0 53 0 54 0 56 0 60 0 76 0 77 0 78 0 81 0 82]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 2 73 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 4 121 0 119]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 2 73 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 4 125 0 99 1 217 0 119]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 2 73 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 201 0 99 4 129 0 100 1 217 0 119]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 1 157 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 4 133 0 98 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 1 217 0 119]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 2 73 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 4 137 0 97]
#[0 2 198 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 77 0 78 0 81 0 82 0 132 0 147]
#[0 3 38 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 42 0 47 0 48 0 49 0 50 0 52 0 53 0 54 0 56 0 60 0 76 0 77 0 78 0 81 0 82]
#[0 2 202 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 77 0 78 0 81 0 82 0 132 0 147]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 1 85 0 38 1 89 0 39 1 93 0 42 1 97 0 47 1 101 0 48 1 105 0 49 1 109 0 50 1 113 0 52 1 117 0 53 1 121 0 54 1 125 0 56 1 129 0 60 1 133 0 76 1 137 0 77 1 141 0 78 0 209 0 81 4 141 0 82 1 149 0 84 1 153 0 85 1 157 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 197 0 98 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 1 217 0 119 1 221 0 137 1 225 0 138 1 229 0 139 1 233 0 140 1 237 0 141 1 241 0 142 3 113 0 143]
#[1 0 17 0 40 0 21 0 41 0 25 0 43 0 29 0 44 0 33 0 45 0 37 0 51 0 41 0 55 0 61 0 66 0 65 0 67 0 69 0 68 0 73 0 69 0 77 0 70 0 85 0 72 0 89 0 73 4 145 0 82 2 17 0 109 2 21 0 110 0 125 0 114 0 129 0 115 0 133 0 116 3 141 0 120 2 33 0 121 0 145 0 132]
#[0 1 242 0 16 0 25 0 26 0 34 0 76 0 79]
#[0 1 250 0 16 0 25 0 26 0 34 0 76 0 79]
#[0 1 190 0 16 0 21 0 25 0 26 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 79 0 132]
#[0 1 226 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 66 0 67 0 68 0 69 0 70 0 72 0 73 0 82 0 132]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 2 73 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 201 0 99 1 205 0 100 1 209 0 101 2 77 0 102 4 149 0 104 1 217 0 119]
#[1 4 153 0 16 2 10 0 21 2 10 0 60]
#[1 4 157 0 21 4 161 0 60]
#[0 2 2 0 21 0 60]
#[1 3 161 0 25 4 165 0 26 0 13 0 34 0 17 0 40 0 21 0 41 0 25 0 43 0 29 0 44 0 33 0 45 0 37 0 51 0 41 0 55 0 45 0 57 0 49 0 58 0 53 0 61 0 57 0 65 0 61 0 66 0 65 0 67 0 69 0 68 0 73 0 69 0 77 0 70 0 81 0 71 0 85 0 72 0 89 0 73 0 93 0 76 3 165 0 79 2 45 0 105 0 105 0 108 0 109 0 109 0 113 0 110 0 157 0 112 0 125 0 114 0 129 0 115 0 133 0 116 3 173 0 126 0 141 0 127 4 169 0 128 2 57 0 131 0 145 0 132 2 61 0 133 4 173 0 134 3 181 0 135]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 4 177 0 80 1 149 0 84 1 153 0 85 2 73 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 201 0 99 1 205 0 100 1 209 0 101 2 77 0 102 4 181 0 104 1 217 0 119]
#[0 2 114 0 21 0 26]
#[1 2 126 0 21 3 161 0 25 2 126 0 26 0 93 0 76 3 165 0 79 0 237 0 127 4 185 0 135]
#[0 2 118 0 21 0 26]
#[1 2 130 0 21 4 189 0 25 2 130 0 26 4 193 0 79]
#[0 2 70 0 16 0 17 0 21 0 25 0 26 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 79 0 81 0 132]
#[0 4 197 0 76]
#[0 2 74 0 16 0 17 0 21 0 25 0 26 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 79 0 81 0 132]
#[1 0 17 0 40 0 21 0 41 0 25 0 43 0 29 0 44 0 33 0 45 0 37 0 51 0 41 0 55 0 45 0 57 0 49 0 58 0 53 0 61 0 57 0 65 0 61 0 66 0 65 0 67 0 69 0 68 0 73 0 69 0 77 0 70 0 81 0 71 0 85 0 72 0 89 0 73 4 201 0 74 2 45 0 105 0 105 0 108 0 109 0 109 0 113 0 110 0 125 0 114 0 129 0 115 0 133 0 116 0 145 0 132 4 205 0 133]
#[0 2 62 0 16 0 17 0 21 0 25 0 26 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 79 0 81 0 132]
#[0 1 202 0 16 0 21 0 25 0 26 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 79 0 132]
#[0 2 34 0 21 0 82]
#[0 2 26 0 21 0 82]
#[1 4 209 0 21 4 213 0 82]
#[0 2 174 0 21 0 82]
#[0 4 217 0 26]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 2 73 0 88 1 165 0 89 4 221 0 90]
#[0 0 50 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 23 0 25 0 26 0 27 0 28 0 29 0 30 0 33 0 34 0 35 0 36 0 37 0 59 0 60 0 62 0 63 0 64 0 79 0 80 0 82]
#[1 3 237 0 25 4 165 0 26 0 13 0 34 0 17 0 40 0 21 0 41 0 25 0 43 0 29 0 44 0 33 0 45 0 37 0 51 0 41 0 55 0 45 0 57 0 49 0 58 0 53 0 61 0 57 0 65 0 61 0 66 0 65 0 67 0 69 0 68 0 73 0 69 0 77 0 70 0 81 0 71 0 85 0 72 0 89 0 73 3 165 0 79 2 45 0 105 0 105 0 108 0 109 0 109 0 113 0 110 0 125 0 114 0 129 0 115 0 133 0 116 3 241 0 126 4 169 0 128 2 57 0 131 0 145 0 132 2 61 0 133 4 173 0 134 3 181 0 135]
#[1 3 237 0 25 2 126 0 26 3 165 0 79 4 185 0 135]
#[0 0 130 0 26]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 1 85 0 38 1 89 0 39 1 93 0 42 1 97 0 47 1 101 0 48 1 105 0 49 1 109 0 50 1 113 0 52 1 117 0 53 1 121 0 54 1 125 0 56 1 129 0 60 1 133 0 76 1 137 0 77 1 141 0 78 0 209 0 81 1 149 0 84 1 153 0 85 1 157 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 197 0 98 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 1 217 0 119 1 221 0 137 1 225 0 138 1 229 0 139 1 233 0 140 1 237 0 141 1 241 0 142 4 225 0 143]
#[0 2 190 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 42 0 46 0 47 0 48 0 49 0 50 0 52 0 53 0 54 0 56 0 60 0 76 0 77 0 78 0 81 0 82]
#[1 3 81 0 21 4 229 0 26]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 1 129 0 60 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 1 157 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 197 0 98 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 1 217 0 119 4 233 0 139]
#[0 2 246 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 42 0 46 0 47 0 48 0 49 0 50 0 52 0 53 0 54 0 56 0 60 0 76 0 77 0 78 0 81 0 82]
#[1 3 81 0 21 4 237 0 26]
#[1 3 81 0 21 4 241 0 26]
#[0 4 245 0 25]
#[0 3 6 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 42 0 46 0 47 0 48 0 49 0 50 0 52 0 53 0 54 0 56 0 60 0 76 0 77 0 78 0 81 0 82]
#[0 2 182 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 42 0 46 0 47 0 48 0 49 0 50 0 52 0 53 0 54 0 56 0 60 0 76 0 77 0 78 0 81 0 82]
#[0 0 26 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 23 0 25 0 26 0 27 0 28 0 29 0 30 0 33 0 34 0 35 0 36 0 37 0 59 0 60 0 62 0 63 0 64 0 79 0 80 0 82]
#[0 0 14 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 23 0 25 0 26 0 27 0 28 0 29 0 30 0 33 0 34 0 35 0 36 0 37 0 59 0 60 0 62 0 63 0 64 0 79 0 80 0 82]
#[1 4 249 0 21 4 253 0 26]
#[0 0 54 0 21 0 26]
#[0 0 22 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 23 0 25 0 26 0 27 0 28 0 29 0 30 0 33 0 34 0 35 0 36 0 37 0 59 0 60 0 62 0 63 0 64 0 79 0 80 0 82]
#[1 3 81 0 21 5 1 0 80]
#[0 0 66 0 16 0 21 0 26 0 60 0 80 0 82]
#[0 0 142 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 14 0 15 0 16 0 18 0 21 0 26 0 28 0 29 0 30 0 33 0 34 0 35 0 36 0 60 0 80 0 82]
#[0 0 146 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 14 0 15 0 16 0 18 0 21 0 26 0 28 0 29 0 30 0 33 0 34 0 35 0 36 0 60 0 80 0 82]
#[0 0 138 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 14 0 15 0 16 0 18 0 21 0 26 0 28 0 29 0 30 0 33 0 34 0 35 0 36 0 60 0 80 0 82]
#[1 0 154 0 1 0 154 0 2 0 154 0 3 0 154 0 4 0 154 0 5 0 154 0 6 0 154 0 7 0 154 0 8 0 154 0 9 0 154 0 14 0 154 0 15 0 154 0 16 0 154 0 18 0 154 0 21 0 154 0 26 0 154 0 28 3 25 0 29 3 29 0 30 0 154 0 33 3 33 0 34 0 154 0 35 0 154 0 36 0 154 0 60 0 154 0 80 0 154 0 82]
#[1 0 158 0 1 0 158 0 2 0 158 0 3 0 158 0 4 0 158 0 5 0 158 0 6 0 158 0 7 0 158 0 8 0 158 0 9 0 158 0 14 0 158 0 15 0 158 0 16 0 158 0 18 0 158 0 21 0 158 0 26 0 158 0 28 3 25 0 29 3 29 0 30 0 158 0 33 3 33 0 34 0 158 0 35 0 158 0 36 0 158 0 60 0 158 0 80 0 158 0 82]
#[1 0 170 0 1 0 170 0 2 0 170 0 3 0 170 0 4 0 170 0 5 0 170 0 6 0 170 0 7 0 170 0 8 0 170 0 9 0 170 0 14 0 170 0 15 0 170 0 16 0 170 0 18 0 170 0 21 0 170 0 26 0 170 0 28 0 170 0 33 3 37 0 35 3 41 0 36 0 170 0 60 0 170 0 80 0 170 0 82]
#[1 0 166 0 1 0 166 0 2 0 166 0 3 0 166 0 4 0 166 0 5 0 166 0 6 0 166 0 7 0 166 0 8 0 166 0 9 0 166 0 14 0 166 0 15 0 166 0 16 0 166 0 18 0 166 0 21 0 166 0 26 0 166 0 28 0 166 0 33 3 37 0 35 3 41 0 36 0 166 0 60 0 166 0 80 0 166 0 82]
#[1 0 182 0 1 0 182 0 2 0 182 0 3 0 182 0 4 0 182 0 5 0 182 0 6 0 182 0 7 0 182 0 8 0 182 0 9 3 45 0 14 0 182 0 15 0 182 0 16 0 182 0 18 0 182 0 21 0 182 0 26 0 182 0 28 3 49 0 33 0 182 0 60 0 182 0 80 0 182 0 82]
#[1 0 186 0 1 0 186 0 2 0 186 0 3 0 186 0 4 0 186 0 5 0 186 0 6 0 186 0 7 0 186 0 8 0 186 0 9 3 45 0 14 0 186 0 15 0 186 0 16 0 186 0 18 0 186 0 21 0 186 0 26 0 186 0 28 3 49 0 33 0 186 0 60 0 186 0 80 0 186 0 82]
#[1 0 190 0 1 0 190 0 2 0 190 0 3 0 190 0 4 0 190 0 5 0 190 0 6 0 190 0 7 0 190 0 8 0 190 0 9 3 45 0 14 0 190 0 15 0 190 0 16 0 190 0 18 0 190 0 21 0 190 0 26 0 190 0 28 3 49 0 33 0 190 0 60 0 190 0 80 0 190 0 82]
#[1 0 178 0 1 0 178 0 2 0 178 0 3 0 178 0 4 0 178 0 5 0 178 0 6 0 178 0 7 0 178 0 8 0 178 0 9 3 45 0 14 0 178 0 15 0 178 0 16 0 178 0 18 0 178 0 21 0 178 0 26 0 178 0 28 3 49 0 33 0 178 0 60 0 178 0 80 0 178 0 82]
#[1 0 198 0 1 0 198 0 2 0 198 0 3 0 198 0 4 0 198 0 5 3 53 0 6 3 57 0 7 3 61 0 8 0 198 0 9 0 198 0 15 0 198 0 16 3 65 0 18 0 198 0 21 0 198 0 26 0 198 0 28 0 198 0 60 0 198 0 80 0 198 0 82]
#[1 0 202 0 1 0 202 0 2 0 202 0 3 0 202 0 4 0 202 0 5 3 53 0 6 3 57 0 7 3 61 0 8 0 202 0 9 0 202 0 15 0 202 0 16 3 65 0 18 0 202 0 21 0 202 0 26 0 202 0 28 0 202 0 60 0 202 0 80 0 202 0 82]
#[1 0 210 0 1 0 210 0 2 3 69 0 3 3 73 0 4 0 210 0 5 0 210 0 9 0 210 0 15 0 210 0 16 0 210 0 21 0 210 0 26 0 210 0 28 0 210 0 60 0 210 0 80 0 210 0 82]
#[0 0 218 0 16 0 21 0 26 0 60 0 80]
#[1 3 105 0 1 0 226 0 2 0 226 0 5 0 226 0 9 0 226 0 15 0 226 0 16 0 226 0 21 0 226 0 26 0 226 0 60 0 226 0 80 0 226 0 82]
#[1 3 89 0 2 0 234 0 5 0 234 0 9 0 234 0 15 0 234 0 16 0 234 0 21 0 234 0 26 0 234 0 60 0 234 0 80 0 234 0 82]
#[1 3 93 0 5 0 242 0 9 0 242 0 15 0 242 0 16 0 242 0 21 0 242 0 26 0 242 0 60 0 242 0 80 0 242 0 82]
#[1 5 5 0 16 3 81 0 21]
#[1 1 234 0 1 1 234 0 2 1 234 0 5 1 234 0 9 1 234 0 15 1 234 0 16 1 234 0 21 1 234 0 26 3 77 0 28 1 234 0 60 1 234 0 80 1 234 0 82]
#[0 2 206 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 77 0 78 0 81 0 82 0 132 0 147]
#[0 1 186 0 16 0 21 0 25 0 26 0 34 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 57 0 58 0 60 0 61 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 76 0 79 0 132]
#[0 2 14 0 21 0 60]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 2 73 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 201 0 99 1 205 0 100 1 209 0 101 2 77 0 102 5 9 0 104 1 217 0 119]
#[1 3 145 0 16 0 9 0 25 0 13 0 34 0 93 0 76 3 149 0 112 5 13 0 123 0 137 0 126 0 141 0 127]
#[0 1 238 0 40 0 41 0 43 0 44 0 45 0 51 0 55 0 66 0 67 0 68 0 69 0 70 0 72 0 73 0 82 0 132]
#[0 2 158 0 21 0 25 0 26 0 79]
#[0 5 17 0 26]
#[0 5 21 0 26]
#[0 2 142 0 21 0 25 0 26 0 79]
#[0 5 25 0 80]
#[1 2 134 0 21 4 189 0 25 2 134 0 26 4 193 0 79]
#[1 5 29 0 26 0 17 0 40 0 21 0 41 0 25 0 43 0 29 0 44 0 33 0 45 0 37 0 51 0 41 0 55 0 45 0 57 0 49 0 58 0 53 0 61 0 57 0 65 0 61 0 66 0 65 0 67 0 69 0 68 0 73 0 69 0 77 0 70 0 81 0 71 0 85 0 72 0 89 0 73 2 45 0 105 0 105 0 108 0 109 0 109 0 113 0 110 0 125 0 114 0 129 0 115 0 133 0 116 5 33 0 128 2 57 0 131 0 145 0 132 2 61 0 133]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 5 37 0 80 1 149 0 84 1 153 0 85 2 73 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 201 0 99 1 205 0 100 1 209 0 101 2 77 0 102 5 41 0 104 1 217 0 119]
#[0 2 94 0 21 0 26]
#[0 2 86 0 26]
#[0 2 110 0 21 0 26]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 2 105 0 81 5 45 0 82 1 149 0 84 1 153 0 85 2 109 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 1 217 0 119 5 49 0 150]
#[0 3 78 0 21 0 60 0 82]
#[0 0 90 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 21 0 26 0 28 0 29 0 30 0 33 0 34 0 35 0 36 0 37 0 59 0 60 0 62 0 63 0 64 0 80 0 82]
#[0 0 122 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 21 0 26 0 28 0 29 0 30 0 33 0 34 0 35 0 36 0 37 0 59 0 60 0 62 0 63 0 64 0 80 0 82]
#[0 2 186 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 42 0 46 0 47 0 48 0 49 0 50 0 52 0 53 0 54 0 56 0 60 0 76 0 77 0 78 0 81 0 82]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 1 85 0 38 1 89 0 39 1 93 0 42 1 97 0 47 1 101 0 48 1 105 0 49 1 109 0 50 1 113 0 52 1 117 0 53 1 121 0 54 1 125 0 56 1 129 0 60 1 133 0 76 1 137 0 77 1 141 0 78 0 209 0 81 1 149 0 84 1 153 0 85 1 157 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 197 0 98 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 1 217 0 119 1 221 0 137 1 225 0 138 1 229 0 139 1 233 0 140 1 237 0 141 1 241 0 142 5 53 0 143]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 5 57 0 26 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 1 157 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 5 61 0 98 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 1 217 0 119]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 1 85 0 38 1 89 0 39 1 93 0 42 1 97 0 47 1 101 0 48 1 105 0 49 1 109 0 50 1 113 0 52 1 117 0 53 1 121 0 54 1 125 0 56 1 129 0 60 1 133 0 76 1 137 0 77 1 141 0 78 0 209 0 81 1 149 0 84 1 153 0 85 1 157 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 197 0 98 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 1 217 0 119 1 221 0 137 1 225 0 138 1 229 0 139 1 233 0 140 1 237 0 141 1 241 0 142 5 65 0 143]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 1 85 0 38 1 89 0 39 1 93 0 42 1 97 0 47 1 101 0 48 1 105 0 49 1 109 0 50 1 113 0 52 1 117 0 53 1 121 0 54 1 125 0 56 1 129 0 60 1 133 0 76 1 137 0 77 1 141 0 78 0 209 0 81 1 149 0 84 1 153 0 85 1 157 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 197 0 98 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 1 217 0 119 1 221 0 137 1 225 0 138 1 229 0 139 1 233 0 140 1 237 0 141 1 241 0 142 5 69 0 143]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 1 157 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 5 73 0 98 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 1 217 0 119]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 5 77 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 1 217 0 119]
#[0 0 18 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 23 0 25 0 26 0 27 0 28 0 29 0 30 0 33 0 34 0 35 0 36 0 37 0 59 0 60 0 62 0 63 0 64 0 79 0 80 0 82]
#[0 0 10 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 23 0 25 0 26 0 27 0 28 0 29 0 30 0 33 0 34 0 35 0 36 0 37 0 59 0 60 0 62 0 63 0 64 0 79 0 80 0 82]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 2 65 0 76 1 137 0 77 1 141 0 78 1 149 0 84 1 153 0 85 2 73 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 201 0 99 1 205 0 100 1 209 0 101 5 81 0 102 1 217 0 119]
#[0 2 18 0 21 0 60]
#[0 2 6 0 21 0 60]
#[0 2 162 0 21 0 25 0 26 0 79]
#[0 2 138 0 21 0 25 0 26 0 79]
#[0 2 146 0 21 0 25 0 26 0 79]
#[0 2 166 0 21 0 25 0 26 0 79]
#[0 5 85 0 26]
#[0 2 150 0 21 0 25 0 26 0 79]
#[0 5 89 0 80]
#[0 3 82 0 21 0 60 0 82]
#[0 2 178 0 21 0 82]
#[1 2 218 0 20 2 218 0 23 2 218 0 24 2 218 0 25 2 218 0 28 2 218 0 31 2 218 0 32 2 218 0 34 2 218 0 35 2 218 0 36 2 218 0 38 2 218 0 39 2 218 0 42 5 93 0 46 2 218 0 47 2 218 0 48 2 218 0 49 2 218 0 50 2 218 0 52 2 218 0 53 2 218 0 54 2 218 0 56 2 218 0 60 2 218 0 76 2 218 0 77 2 218 0 78 2 218 0 81 2 218 0 82]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 1 85 0 38 1 89 0 39 1 93 0 42 1 97 0 47 1 101 0 48 1 105 0 49 1 109 0 50 1 113 0 52 1 117 0 53 1 121 0 54 1 125 0 56 1 129 0 60 1 133 0 76 1 137 0 77 1 141 0 78 0 209 0 81 1 149 0 84 1 153 0 85 1 157 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 197 0 98 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 1 217 0 119 1 221 0 137 1 225 0 138 1 229 0 139 1 233 0 140 1 237 0 141 1 241 0 142 5 97 0 143]
#[1 3 81 0 21 5 101 0 26]
#[0 2 226 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 42 0 46 0 47 0 48 0 49 0 50 0 52 0 53 0 54 0 56 0 60 0 76 0 77 0 78 0 81 0 82]
#[0 2 230 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 42 0 46 0 47 0 48 0 49 0 50 0 52 0 53 0 54 0 56 0 60 0 76 0 77 0 78 0 81 0 82]
#[1 3 81 0 21 5 105 0 26]
#[0 0 58 0 21 0 26]
#[0 0 250 0 16 0 21 0 26 0 60 0 80 0 82]
#[0 2 170 0 21 0 25 0 26 0 79]
#[0 2 154 0 21 0 25 0 26 0 79]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 1 85 0 38 1 89 0 39 1 93 0 42 1 97 0 47 1 101 0 48 1 105 0 49 1 109 0 50 1 113 0 52 1 117 0 53 1 121 0 54 1 125 0 56 1 129 0 60 1 133 0 76 1 137 0 77 1 141 0 78 0 209 0 81 1 149 0 84 1 153 0 85 1 157 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 197 0 98 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 1 217 0 119 1 221 0 137 1 225 0 138 1 229 0 139 1 233 0 140 1 237 0 141 1 241 0 142 5 109 0 143]
#[0 2 238 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 42 0 46 0 47 0 48 0 49 0 50 0 52 0 53 0 54 0 56 0 60 0 76 0 77 0 78 0 81 0 82]
#[1 1 45 0 20 1 49 0 23 1 53 0 24 1 57 0 25 1 61 0 28 1 65 0 31 1 69 0 32 1 73 0 34 1 77 0 35 1 81 0 36 1 85 0 38 1 89 0 39 1 93 0 42 1 97 0 47 1 101 0 48 1 105 0 49 1 109 0 50 1 113 0 52 1 117 0 53 1 121 0 54 1 125 0 56 1 129 0 60 1 133 0 76 1 137 0 77 1 141 0 78 0 209 0 81 1 149 0 84 1 153 0 85 1 157 0 87 1 161 0 88 1 165 0 89 1 169 0 90 1 173 0 92 1 177 0 93 1 181 0 94 1 185 0 95 1 189 0 96 1 193 0 97 1 197 0 98 1 201 0 99 1 205 0 100 1 209 0 101 1 213 0 102 1 217 0 119 1 221 0 137 1 225 0 138 1 229 0 139 1 233 0 140 1 237 0 141 1 241 0 142 5 113 0 143]
#[0 5 117 0 60]
#[0 2 222 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 42 0 46 0 47 0 48 0 49 0 50 0 52 0 53 0 54 0 56 0 60 0 76 0 77 0 78 0 81 0 82]
#[0 2 242 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 42 0 46 0 47 0 48 0 49 0 50 0 52 0 53 0 54 0 56 0 60 0 76 0 77 0 78 0 81 0 82]
#[0 2 234 0 20 0 23 0 24 0 25 0 28 0 31 0 32 0 34 0 35 0 36 0 38 0 39 0 42 0 46 0 47 0 48 0 49 0 50 0 52 0 53 0 54 0 56 0 60 0 76 0 77 0 78 0 81 0 82]
)

    "Modified: / 18-11-2008 / 13:47:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CParser methodsFor:'public'!

addTypeName: aString 
	scanner addTypeName: aString
! !

!CParser class methodsFor:'documentation'!

version
    ^ '$Id$'
! !

