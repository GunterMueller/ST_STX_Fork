"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.


    Package info:
       NAME     REGEX
       AUTHOR   vbykov@cam.org (Vassili Bykov)
       URL      (none)
       FUNCTION Regular Expression Matcher
       KEYWORDS regular expression, regex, regexp, validation, tools
       ST-VERSIONS      VisualWorks 1.0, VisualWorks 2.0, VisualWorks 2.5
       PREREQUISITES    (none)
       CONFLICTS        (none known)
       DISTRIBUTION     world
       VERSION  1.0
       DATE     08-Aug-96

SUMMARY

        A regular expression matcher similar in functionality to 
        Perl's regular expressions.

        File in and see `documentation' protocol in RxParser class.

        Does not modify system classes and methods.

                                Vassili Bykov
"
"{ Package: 'stx:goodies/regex' }"

"{ NameSpace: Regex }"

Object subclass:#RxParser
	instanceVariableNames:'input lookahead'
	classVariableNames:'CompilationErrorSignal MatchErrorSignal RegexErrorSignal
		SyntaxErrorSignal BackslashConstants BackslashSpecials
		ExceptionObjects'
	poolDictionaries:''
	category:'Regex-Syntax'
!

RxParser comment:'||| This is a part of the Regular Expression Matcher package, (c) Vassili Bykov, 1996.
||| Refer to `documentation'' protocol of RxParser class for details.

Regular expression parser. Translates a regular expression read from a stream into a parse tree. (''accessing'' protocol). The tree can later be passed to a matcher initialization method.  All other classes in this category implement the tree. Refer to their comments for any details.

Instance variables:
	input           <Stream> A stream with the regular expression being parsed.
	lookahead       <Character> Self-evident.
'
!

!RxParser class methodsFor:'documentation'!

copyright
"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.


    Package info:
       NAME     REGEX
       AUTHOR   vbykov@cam.org (Vassili Bykov)
       URL      (none)
       FUNCTION Regular Expression Matcher
       KEYWORDS regular expression, regex, regexp, validation, tools
       ST-VERSIONS      VisualWorks 1.0, VisualWorks 2.0, VisualWorks 2.5
       PREREQUISITES    (none)
       CONFLICTS        (none known)
       DISTRIBUTION     world
       VERSION  1.0
       DATE     08-Aug-96

SUMMARY

        A regular expression matcher similar in functionality to 
        Perl's regular expressions.

        File in and see `documentation' protocol in RxParser class.

        Does not modify system classes and methods.

                                Vassili Bykov
"

    "Created: 3.6.1997 / 10:55:59 / cg"
!

documentation
"
    A regular expression matcher similar in functionality to 
    Perl's regular expressions.

    See the `documentation-manual' protocol in RxParser class.

    Does not modify system classes and methods.

                            Vassili Bykov
"

    "Created: 3.6.1997 / 10:56:20 / cg"
! !

!RxParser class methodsFor:'Signal constants'!

compilationErrorSignal
	"Raised by the specific matcher's builder if an error is
	encountered while building.."

	^ExceptionObjects at: #compilationErrorSignal
!

initializeExceptions
        "self initializeExceptions"

        | parentSignal |
        ExceptionObjects := (Dictionary new: 4).
        ExceptionObjects
                at: #regexErrorSignal
                put: (parentSignal := Error newSignal
                        notifierString: 'Regex error - ';
                        nameClass: self message: #regexErrorSignal);

                at: #syntaxErrorSignal
                put: (parentSignal newSignal
                        notifierString: 'Regex syntax error - ';
                        nameClass: self message: #syntaxErrorSignal);

                at: #compilationErrorSignal
                put: (parentSignal newSignal
                        notifierString: 'Regex compilation error - ';
                        nameClass: self message: #compilationErrorSignal);

                at: #matchErrorSignal
                put: (parentSignal newSignal
                        notifierString: 'Regex matching error - ';
                        nameClass: self message: #matchErrorSignal)
!

matchErrorSignal
	"To signal errors encountered while matching."

	^ExceptionObjects at: #matchErrorSignal
!

regexErrorSignal
	"Parent of the other three signals, to catch them all if needed."

	^ExceptionObjects at: #regexErrorSignal
!

syntaxErrorSignal
	"Raised within the recursive descent when a syntax error
	is encountered."

	^ExceptionObjects at: #syntaxErrorSignal
! !

!RxParser class methodsFor:'class initialization'!

initialize
	"self initialize"

	self
		initializeExceptions;
		initializeBackslashConstants;
		initializeBackslashSpecials
!

initializeBackslashConstants
        "self initializeBackslashConstants"

        (BackslashConstants := Dictionary new)
                at: $e put: Character esc;
                at: $n put: Character lf;
                at: $r put: Character cr;
                at: $f put: Character newPage;
                at: $t put: Character tab.

        (Smalltalk isSmalltalkX) ifTrue:[
            BackslashConstants at:$r put: Character return
        ]
!

initializeBackslashSpecials
	"Keys are characters that normally follow a \, the values are
	associations of classes and initialization selectors on the instance side
	of the classes."
	"self initializeBackslashSpecials"

	(BackslashSpecials := Dictionary new)
		at: $w put: (Association key: RxsPredicate value: #beWordConstituent);
		at: $W put: (Association key: RxsPredicate value: #beNotWordConstituent);
		at: $s put: (Association key: RxsPredicate value: #beSpace);
		at: $S put: (Association key: RxsPredicate value: #beNotSpace);
		at: $d put: (Association key: RxsPredicate value: #beDigit);
		at: $D put: (Association key: RxsPredicate value: #beNotDigit);
		at: $b put: (Association key: RxsContextCondition value: #beWordBoundary);
		at: $B put: (Association key: RxsContextCondition value: #beNonWordBoundary);
		at: $< put: (Association key: RxsContextCondition value: #beBeginningOfWord);
		at: $> put: (Association key: RxsContextCondition value: #beEndOfWord)
! !

!RxParser class methodsFor:'documentation-manual'!

a_introduction
"
A regular expression is a template specifying a class of strings. A
regular expression matcher is a tool that determines whether a string
belongs to a class specified by a regular expression.  This is a
common task of a user input validation code, and the use of regular
expressions can GREATLY simplify and speed up development of such
code.  As an example, here is how to verify that a string is a valid
hexadecimal number in Smalltalk notation, using this matcher package:

        aString matchesRegex: '16r[[:xdigit:]]+'

(Coding the same ``the hard way'' is an exercise to a curious reader).

This matcher is offered to the Smalltalk community in hope it will be
useful. It is free in terms of money, and to a large extent--in terms
of rights of use. Refer to `Boring Stuff' section for legalese.

The 'What's new in this release' section describes the functionality
introduced in 1.1 release.

The `Syntax' section explains the recognized syntax of regular
expressions.

The `Usage' section explains matcher capabilities that go beyond what
String>>matchesRegex: method offers.

The `Implementation notes' sections says a few words about what is
under the hood.

Happy hacking,

--Vassili Bykov
<vassili@objectpeople.com> <vassili@magma.ca>

August 6, 1996
April 4, 1999
"

        self error: 'comment only'
!

b_whatsNewInThisRelease
"
VERSION 1.1     (October 1999)

  Regular expression syntax corrections and enhancements:

  1. Backslash escapes similar to those in Perl are allowed in patterns:

          \w      any word constituent character (equivalent to [a-zA-Z0-9_])
          \W      any character but a word constituent (equivalent to [^a-xA-Z0-9_]
          \d      a digit (same as [0-9])
          \D      anything but a digit
          \s      a whitespace character
          \S      anything but a whitespace character
          \b      an empty string at a word boundary
          \B      an empty string not at a word boundary
          \<      an empty string at the beginning of a word
          \>      an empty string at the end of a word

  For example, '\w+' is now a valid expression matching any word.

  2. The following backslash escapes are also allowed in character sets
  (between square brackets):

          \w, \W, \d, \D, \s, and \S.

  3. The following grep(1)-compatible named character classes are
  recognized in character sets as well:

          [:alnum:]
          [:alpha:]
          [:blank:]
          [:cntrl:]
          [:digit:]
          [:graph:]
          [:lower:]
          [:print:]
          [:punct:]
          [:space:]
          [:upper:]
          [:xdigit:]

  For example, the following patterns are equivalent:

          '[[:alnum:]]+' '\w+'  '[\w]+' '[a-zA-Z0-9_]+'

  4. Some non-printable characters can be represented in regular
  expressions using a common backslash notation:

          \t      tab (Character tab)
          \n      newline (Character lf)
          \r      carriage return (Character cr)
          \f      form feed (Character newPage)
          \e      escape (Character esc)

  5. A dot is correctly interpreted as 'any character but a newline'
  instead of 'anything but whitespace'.

  6. Case-insensitive matching.
    The easiest access to it are new messages in CharacterArray:
     #asRegexIgnoringCase, #matchesRegexIgnoringCase:, #prefixMatchesRegexIgnoringCase:.

  7. The matcher (an instance of RxMatcher, the result of
  String>>asRegex) now provides a collection-like interface to matches
  in a particular string or on a particular stream, as well as
  substitution protocol. The interface includes the following messages:

          matchesIn: aString
          matchesIn: aString collect: aBlock
          matchesIn: aString do: aBlock

          matchesOnStream: aStream
          matchesOnStream: aStream collect: aBlock
          matchesOnStream: aStream do: aBlock

          copy: aString translatingMatchesUsing: aBlock
          copy: aString replacingMatchesWith: replacementString

          copyStream: aStream to: writeStream translatingMatchesUsing: aBlock
          copyStream: aStream to: writeStream replacingMatchesWith: aString

  Examples:

          '\w+' asRegex matchesIn: 'now is the time'

  returns an OrderedCollection containing four strings: 'now', 'is',
  'the', and 'time'.

          '\<t\w+' asRegexIgnoringCase
                  copy: 'now is the Time'
                  translatingMatchesUsing: [:match | match asUppercase]

  returns 'now is THE TIME' (the regular expression matches words
  beginning with either an uppercase or a lowercase T).

ACKNOWLEDGEMENTS

  Since the first release of the matcher, thanks to the input from
  several fellow Smalltalkers, I became convinced a native Smalltalk
  regular expression matcher was worth the effort to keep it alive. For
  the advice and encouragement that made this release possible, I want
  to thank:

          Felix Hack
          Eliot Miranda
          Robb Shecter
          David N. Smith
          Francis Wolinski

  and anyone whom I haven't yet met or heard from, but who agrees this
  has not been a complete waste of time.

--Vassili Bykov
October 3, 1999
"

        self error: 'comment only'
!

c_syntax
"

SYNTAX

  [You can select and `print it' examples in this method. Just don't
  forget to cancel the changes.]

  The simplest regular expression is a single character.  It matches
  exactly that character. A sequence of characters matches a string with
  exactly the same sequence of characters:

          'a' matchesRegex: 'a'                   -- true
          'foobar' matchesRegex: 'foobar'         -- true
          'blorple' matchesRegex: 'foobar'        -- false

  The above paragraph introduced a primitive regular expression (a
  character), and an operator (sequencing). Operators are applied to
  regular expressions to produce more complex regular expressions.
  Sequencing (placing expressions one after another) as an operator is,
  in a certain sense, `invisible'--yet it is arguably the most common.

  A more `visible' operator is Kleene closure, more often simply
  referred to as `a star'.  A regular expression followed by an asterisk
  matches any number (including 0) of matches of the original
  expression. For example:

          'ab' matchesRegex: 'a*b'                                -- true
          'aaaaab' matchesRegex: 'a*b'            -- true
          'b' matchesRegex: 'a*b'                         -- true
          'aac' matchesRegex: 'a*b'                       -- false: b does not match

  A star's precedence is higher than that of sequencing. A star applies
  to the shortest possible subexpression that precedes it. For example,
  'ab*' means `a followed by zero or more occurrences of b', not `zero
  or more occurrences of ab':

          'abbb' matchesRegex: 'ab*'                      -- true
          'abab' matchesRegex: 'ab*'                      -- false

  To actually make a regex matching `zero or more occurrences of ab',
  `ab' is enclosed in parentheses:

          'abab' matchesRegex: '(ab)*'                    -- true
          'abcab' matchesRegex: '(ab)*'           -- false: c spoils the fun

  Two other operators similar to `*' are `+' and `?'. `+' (positive
  closure, or simply `plus') matches one or more occurrences of the
  original expression. `?' (`optional') matches zero or one, but never
  more, occurrences.

          'ac' matchesRegex: 'ab*c'                       -- true
          'ac' matchesRegex: 'ab+c'                       -- false: need at least one b
          'abbc' matchesRegex: 'ab+c'                     -- true
          'abbc' matchesRegex: 'ab?c'                     -- false: too many b's

  As we have seen, characters `*', `+', `?', `(', and `)' have special
  meaning in regular expressions. If one of them is to be used
  literally, it should be quoted: preceded with a backslash. (Thus,
  backslash is also a special character, and needs to be quoted for a
  literal match--as well as any other special character described
  further).

          'ab*' matchesRegex: 'ab*'                       -- false: star in the right string is special
          'ab*' matchesRegex: 'ab\*'                      -- true
          'a\c' matchesRegex: 'a\\c'                      -- true

  The last operator is `|' meaning `or'. It is placed between two
  regular expressions, and the resulting expression matches if one of
  the expressions matches. It has the lowest possible precedence (lower
  than sequencing). For example, `ab*|ba*' means `a followed by any
  number of b's, or b followed by any number of a's':

          'abb' matchesRegex: 'ab*|ba*'           -- true
          'baa' matchesRegex: 'ab*|ba*'           -- true
          'baab' matchesRegex: 'ab*|ba*'          -- false

  A slightly more complex example is the following expression, matching the
  name of any of the Lisp-style `car', `cdr', `caar', `cadr',
  ... functions:

          c(a|d)+r

  It is possible to write an expression matching an empty string, for
  example: `a|'.  However, it is an error to apply `*', `+', or `?' to
  such expressions: `(a|)*' is an invalid expression.

  So far, we have used only characters as the 'smallest' components of
  regular expressions. There are other, more `interesting', components.

  A character set is a string of characters enclosed in square
  brackets. It matches any single character if it appears between the
  brackets. For example, `[01]' matches either `0' or `1':

          '0' matchesRegex: '[01]'                                -- true
          '3' matchesRegex: '[01]'                                -- false
          '11' matchesRegex: '[01]'                               -- false: a set matches only one character

  Using plus operator, we can build the following binary number
  recognizer:

          '10010100' matchesRegex: '[01]+'                -- true
          '10001210' matchesRegex: '[01]+'                -- false

  If the first character after the opening bracket is `^', the set is
  inverted: it matches any single character *not* appearing between the
  brackets:

          '0' matchesRegex: '[^01]'                               -- false
          '3' matchesRegex: '[^01]'                               -- true

  For convenience, a set may include ranges: pairs of characters
  separated with `-'. This is equivalent to listing all characters
  between them: `[0-9]' is the same as `[0123456789]'.

  Special characters within a set are `^', `-', and `]' that closes the
  set. Below are the examples of how to literally use them in a set:

          [01^]           -- put the caret anywhere except the beginning
          [01-]           -- put the dash as the last character
          []01]           -- put the closing bracket as the first character
          [^]01]                  (thus, empty and universal sets cannot be specified)

  Regular expressions can also include the following backquote escapes
  to refer to popular classes of characters:

          \w      any word constituent character (same as [a-zA-Z0-9_])
          \W      any character but a word constituent
          \d      a digit (same as [0-9])
          \D      anything but a digit
          \s      a whitespace character
          \S      anything but a whitespace character

  These escapes are also allowed in character classes: '[\w+-]' means
  'any character that is either a word constituent, or a plus, or a
  minus'.

  Character classes can also include the following grep(1)-compatible
  elements to refer to:

          [:alnum:]               any alphanumeric, i.e., a word constituent, character
          [:alpha:]               any alphabetic character
          [:blank:]               space or tab.
          [:cntrl:]               any control character. In this version, it means any character which code is < 32.
          [:digit:]               any decimal digit.
          [:graph:]               any graphical character. In this version, this mean any character with the code >= 32.
          [:lower:]               any lowercase character
          [:print:]               any printable character. In this version, this is the same as [:cntrl:]
          [:punct:]               any punctuation character.
          [:space:]               any whitespace character.
          [:upper:]               any uppercase character.
          [:xdigit:]              any hexadecimal character.

  Note that these elements are components of the character classes,
  i.e. they have to be enclosed in an extra set of square brackets to
  form a valid regular expression.  For example, a non-empty string of
  digits would be represented as '[[:digit:]]+'.

  The above primitive expressions and operators are common to many
  implementations of regular expressions. The next primitive expression
  is unique to this Smalltalk implementation.

  A sequence of characters between colons is treated as a unary selector
  which is supposed to be understood by Characters. A character matches
  such an expression if it answers true to a message with that
  selector. This allows a more readable and efficient way of specifying
  character classes. For example, `[0-9]' is equivalent to `:isDigit:',
  but the latter is more efficient. Analogously to character sets,
  character classes can be negated: `:^isDigit:' matches a Character
  that answers false to #isDigit, and is therefore equivalent to
  `[^0-9]'.

  As an example, so far we have seen the following equivalent ways to
  write a regular expression that matches a non-empty string of digits:

          '[0-9]+'
          '\d+'
          '[\d]+'
          '[[:digit::]+'
          :isDigit:+'

  The last group of special primitive expressions includes:

          .       matching any character except a newline;
          ^       matching an empty string at the beginning of a line;
          $       matching an empty string at the end of a line.
          \b      an empty string at a word boundary
          \B      an empty string not at a word boundary
          \<      an empty string at the beginning of a word
          \>      an empty string at the end of a word

          'axyzb' matchesRegex: 'a.+b'            -- true
          'ax zb' matchesRegex: 'a.+b'                    -- false (space is not matched by `.')

  Again, all the above three characters are special and should be quoted
  to be matched literally.

          \.      to match the character '.'

EXAMPLES

  As the introductions said, a great use for regular expressions is user
  input validation. Following are a few examples of regular expressions
  that might be handy in checking input entered by the user in an input
  field. Try them out by entering something between the quotes and
  print-iting. (Also, try to imagine Smalltalk code that each validation
  would require if coded by hand).  Most example expressions could have
  been written in alternative ways.

  Checking if aString may represent a nonnegative integer number:

          '' matchesRegex: ':isDigit:+'
  or
          '' matchesRegex: '[0-9]+'
  or
          '' matchesRegex: '\d+'

  Checking if aString may represent an integer number with an optional
  sign in front:

          '' matchesRegex: '(\+|-)?\d+'

  Checking if aString is a fixed-point number, with at least one digit
  is required after a dot:

          '' matchesRegex: '(\+|-)?\d+(\.\d+)?'

  The same, but allow notation like `123.':

          '' matchesRegex: '(\+|-)?\d+(\.\d*)?'

  Recognizer for a string that might be a name: one word with first
  capital letter, no blanks, no digits.  More traditional:

          '' matchesRegex: '[A-Z][A-Za-z]*'

  more Smalltalkish:

          '' matchesRegex: ':isUppercase::isAlphabetic:*'

  A date in format MMM DD, YYYY with any number of spaces in between, in
  XX century:

          '' matchesRegex: '(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[ ]+(\d\d?)[ ]*,[ ]*19(\d\d)'

  Note parentheses around some components of the expression above. As
  `Usage' section shows, they will allow us to obtain the actual strings
  that have matched them (i.e. month name, day number, and year number).

  For dessert, coming back to numbers: here is a recognizer for a
  general number format: anything like 999, or 999.999, or -999.999e+21.

          '' matchesRegex: '(\+|-)?\d+(\.\d*)?((e|E)(\+|-)?\d+)?'

"

        self error: 'comment only'

    "Modified (comment): / 18-07-2011 / 15:18:16 / cg"
!

d_usage
"
The preceding section covered the syntax of regular expressions. It
used the simplest possible interface to the matcher: sending
#matchesRegex: message to the sample string, with regular expression
string as the argument.  This section explains hairier ways of using
the matcher.

PREFIX MATCHING AND CASE-INSENSITIVE MATCHING

A CharacterArray (an EsString in VA) also understands these messages:

        #prefixMatchesRegex: regexString
        #matchesRegexIgnoringCase: regexString
        #prefixMatchesRegexIgnoringCase: regexString

#prefixMatchesRegex: is just like #matchesRegex, except that the whole
receiver is not expected to match the regular expression passed as the
argument; matching just a prefix of it is enough.  For example:

        'abcde' matchesRegex: '(a|b)+'          -- false
        'abcde' prefixMatchesRegex: '(a|b)+'    -- true

The last two messages are case-insensitive versions of matching.

ENUMERATION INTERFACE

  An application can be interested in all matches of a certain regular
  expression within a String.  The matches are accessible using a
  protocol modelled after the familiar Collection-like enumeration
  protocol:

          #regex: regexString matchesDo: aBlock

  Evaluates a one-argument <aBlock> for every match of the regular
  expression within the receiver string.

          #regex: regexString matchesCollect: aBlock

  Evaluates a one-argument <aBlock> for every match of the regular
  expression within the receiver string. Collects results of evaluations
  and anwers them as a SequenceableCollection.

          #allRegexMatches: regexString

  Returns a collection of all matches (substrings of the receiver
  string) of the regular expression.  It is an equivalent of <aString
  regex: regexString matchesCollect: [:each | each]>.

          REPLACEMENT AND TRANSLATION

  It is possible to replace all matches of a regular expression with a
  certain string using the message:

          #copyWithRegex: regexString matchesReplacedWith: aString

  For example:

          'ab cd ab' copyWithRegex: '(a|b)+' matchesReplacedWith: 'foo'

  A more general substitution is match translation:

          #copyWithRegex: regexString matchesTranslatedUsing: aBlock

  This message evaluates a block passing it each match of the regular
  expression in the receiver string and answers a copy of the receiver
  with the block results spliced into it in place of the respective
  matches.  For example:

          'ab cd ab' copyWithRegex: '(a|b)+' matchesTranslatedUsing: [:each | each asUppercase]

  All messages of enumeration and replacement protocols perform a
  case-sensitive match.  Case-insensitive versions are not provided as
  part of a CharacterArray protocol.  Instead, they are accessible using
  the lower-level matching interface.

LOWER-LEVEL INTERFACE

  Internally, #matchesRegex: works as follows:

  1. A fresh instance of RxParser is created, and the regular expression
  string is passed to it, yielding the expression's syntax tree.

  2. The syntax tree is passed as an initialization parameter to an
  instance of RxMatcher. The instance sets up some data structure that
  will work as a recognizer for the regular expression described by the
  tree.

  3. The original string is passed to the matcher, and the matcher
  checks for a match.

THE MATCHER

  If you repeatedly match a number of strings against the same regular
  expression using one of the messages defined in CharacterArray, the
  regular expression string is parsed and a matcher is created anew for
  every match.  You can avoid this overhead by building a matcher for
  the regular expression, and then reusing the matcher over and over
  again. You can, for example, create a matcher at a class or instance
  initialization stage, and store it in a variable for future use.

  You can create a matcher using one of the following methods:

          - Sending #forString:ignoreCase: message to RxMatcher class, with
  the regular expression string and a Boolean indicating whether case is
  ignored as arguments.

          - Sending #forString: message.  It is equivalent to <... forString:
  regexString ignoreCase: false>.

  A more convenient way is using one of the two matcher-created messages
  understood by CharacterArray.

          - <regexString asRegex> is equivalent to <RxMatcher forString:
  regexString>.

          - <regexString asRegexIgnoringCase> is equivalent to <RxMatcher
  forString: regexString ignoreCase: true>.

  Here are four examples of creating a matcher:

          hexRecognizer := RxMatcher forString: '16r[0-9A-Fa-f]+'
          hexRecognizer := RxMatcher forString: '16r[0-9A-Fa-f]+' ignoreCase: false
          hexRecognizer := '16r[0-9A-Fa-f]+' asRegex
          hexRecognizer := '16r[0-9A-F]+' asRegexIgnoringCase

MATCHING

  The matcher understands these messages (all of them return true to
  indicate successful match or search, and false otherwise):

  matches: aString

          True if the whole target string (aString) matches.

  matchesPrefix: aString

          True if some prefix of the string (not necessarily the whole
          string) matches.

  search: aString

          Search the string for the first occurrence of a matching
          substring. (Note that the first two methods only try matching from
          the very beginning of the string). Using the above example with a
          matcher for `a+', this method would answer success given a string
          `baaa', while the previous two would fail.

  matchesStream: aStream
  matchesStreamPrefix: aStream
  searchStream: aStream

          Respective analogs of the first three methods, taking input from a
          stream instead of a string. The stream must be positionable and
          peekable.

  All these methods answer a boolean indicating success. The matcher
  also stores the outcome of the last match attempt and can report it:

  lastResult

          Answers a Boolean -- the outcome of the most recent match
          attempt. If no matches were attempted, the answer is unspecified.

SUBEXPRESSION MATCHES

  After a successful match attempt, you can query the specifics of which
  part of the original string has matched which part of the whole
  expression.

  A subexpression is a parenthesized part of a regular expression, or
  the whole expression. When a regular expression is compiled, its
  subexpressions are assigned indices starting from 1, depth-first,
  left-to-right. For example, `((ab)+(c|d))?ef' includes the following
  subexpressions with these indices:

          1:      ((ab)+(c|d))?ef
          2:      (ab)+(c|d)
          3:      ab
          4:      c|d

  After a successful match, the matcher can report what part of the
  original string matched what subexpression. It understands these
  messages:

  subexpressionCount

          Answers the total number of subexpressions: the highest value that
          can be used as a subexpression index with this matcher. This value
          is available immediately after initialization and never changes.

  subexpression: anIndex

          An index must be a valid subexpression index, and this message
          must be sent only after a successful match attempt. The method
          answers a substring of the original string the corresponding
          subexpression has matched to.

  subBeginning: anIndex
  subEnd: anIndex

          Answer positions within the original string or stream where the
          match of a subexpression with the given index has started and
          ended, respectively.

  This facility provides a convenient way of extracting parts of input
  strings of complex format. For example, the following piece of code
  uses the 'MMM DD, YYYY' date format recognizer example from the
  `Syntax' section to convert a date to a three-element array with year,
  month, and day strings (you can select and evaluate it right here):

          | matcher |
          matcher := RxMatcher new initializeFromString: '(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[ ]+(:isDigit::isDigit:?)[ ]*,[ ]*19(:isDigit::isDigit:)'.
          (matcher matches: 'Aug 6, 1996')
                  ifTrue:
                          [Array
                                  with: (matcher subexpression: 4)
                                  with: (matcher subexpression: 2)
                                  with: (matcher subexpression: 3)]
                  ifFalse: ['no match']

  (should answer ` #('96' 'Aug' '6')').

ENUMERATION AND REPLACEMENT

  The enumeration and replacement protocols exposed in CharacterArray
  are actually implemented by the mather.  The following messages are
  understood:

          #matchesIn: aString
          #matchesIn: aString do: aBlock
          #matchesIn: aString collect: aBlock
          #copy: aString replacingMatchesWith: replacementString
          #copy: aString translatingMatchesUsing: aBlock

          #matchesOnStream: aStream
          #matchesOnStream: aStream do: aBlock
          #matchesOnStream: aStream collect: aBlock
          #copy: sourceStream to: targetStream replacingMatchesWith: replacementString
          #copy: sourceStream to: targetStream translatingMatchesWith: aBlock

ERROR HANDLING

  Exception signaling objects (Signals in VisualWorks, Exceptions in VisualAge) are
  accessible through RxParser class protocol. To handle possible errors, use
  the protocol described below to obtain the exception objects and use the
  protocol of the native Smalltalk implementation to handle them.

  If a syntax error is detected while parsing expression,
  RxParser>>syntaxErrorSignal is raised/signaled.

  If an error is detected while building a matcher,
  RxParser>>compilationErrorSignal is raised/signaled.

  If an error is detected while matching (for example, if a bad selector
  was specified using `:<selector>:' syntax, or because of the matcher's
  internal error), RxParser>>matchErrorSignal is raised

  RxParser>>regexErrorSignal is the parent of all three.  Since any of
  the three signals can be raised within a call to #matchesRegex:, it is
  handy if you want to catch them all.

  For example:

  VisualWorks / SmalltalkX:

          RxParser regexErrorSignal
                  handle: [:ex | ex returnWith: nil]
                  do: ['abc' matchesRegex: '))garbage[']

  VisualAge:

          ['abc' matchesRegex: '))garbage[']
                  when: RxParser regexErrorSignal
                  do: [:signal | signal exitWith: nil]

"

        self error: 'comment only'
!

e_implementationNotes
"
        Version:                1.1
        Released:               October 1999
        Mail to:                Vassili Bykov <vassili@magma.ca>, <vassili@objectpeople.com>
        Flames to:              /dev/null

WHAT IS ADDED

  The matcher includes classes in two categories:
          VB-Regex-Syntax
          VB-Regex-Matcher
  and a few CharacterArray methods in `VB-regex' protocol.  No system
  classes or methods are modified.

WHAT TO LOOK AT FIRST

  String>>matchesRegex: -- in 90% cases this method is all you need to access the package.

  RxParser --   accepts a string or a stream of characters with a regular
                expression, and produces a syntax tree corresponding to the
                expression. The tree is made of instances of Rxs<whatever> classes.

  RxMatcher --  accepts a syntax tree of a regular expression built by
                the parser and compiles it into a matcher: a structure made of
                instances of Rxm<whatever> classes. The RxMatcher instance can test
                whether a string or a positionable stream of characters matches the
                original regular expression, or search a string or a stream for
                substrings matching the expression. After a match is found, the
                matcher can report a specific string that matched the whole
                expression, or any parenthesized subexpression of it.

  All other classes support the above functionality and are used by
  RxParser, RxMatcher, or both.

CAVEATS

  The matcher is similar in spirit, but NOT in the design--let alone the
  code--to the original Henry Spencer's regular expression
  implementation in C.  The focus is on simplicity, not on efficiency.
  I didn't optimize or profile anything.  I may in future--or I may not:
  I do this in my spare time and I don't promise anything.

  The matcher passes H. Spencer's test suite (see 'test suite'
  protocol), with quite a few extra tests added, so chances are good
  there are not too many bugs.  But watch out anyway.

EXTENSIONS, FUTURE, ETC.

  With the existing separation between the parser, the syntax tree, and
  the matcher, it is easy to extend the system with other matchers based
  on other algorithms. In fact, I have a DFA-based matcher right now,
  but I don't feel it is good enough to include it here.  I might add
  automata-based matchers later, but again I don't promise anything.

HOW TO REACH ME

  As of today (October 3, 1999), you can contact me at
  <vassili@objectpeople.com>. If this doesn't work, look around
  comp.lang.smalltalk and comp.lang.lisp.
"

        self error: 'comment only'
!

f_boringStuff
"
The Regular Expression Matcher (``The Software'')
is Copyright (C) 1996, 1999 Vassili Bykov.
It is provided to the Smalltalk community in hope it will be useful.

1. This license applies to the package as a whole, as well as to any
   component of it. By performing any of the activities described
   below, you accept the terms of this agreement.

2. The software is provided free of charge, and ``as is'', in hope
   that it will be useful, with ABSOLUTELY NO WARRANTY. The entire
   risk and all responsibility for the use of the software is with
   you.  Under no circumstances the author may be held responsible for
   loss of data, loss of profit, or any other damage resulting
   directly or indirectly from the use of the software, even if the
   damage is caused by defects in the software.

3. You may use this software in any applications you build.

4. You may distribute this software provided that the software
   documentation and copyright notices are included and intact.

5. You may create and distribute modified versions of the software,
   such as ports to other Smalltalk dialects or derived work, provided
   that:

   a. any modified version is expressly marked as such and is not
   misrepresented as the original software;

   b. credit is given to the original software in the source code and
   documentation of the derived work;

   c. the copyright notice at the top of this document accompanies
   copyright notices of any modified version.  "

        self error: 'comment only'
! !

!RxParser class methodsFor:'exception signaling'!

doHandlingMessageNotUnderstood: aBlock
        "MNU should be trapped and resignaled as a match error in a few places in the matcher.
        This method factors out this dialect-dependent code to make porting easier."

        ^ MessageNotUnderstood
                handle:
                        [:ex | self signalMatchException: 'invalid predicate selector'
"/ this code loops!!
"/                                ex restartDo:
"/                                        [self signalMatchException: 'invalid predicate selector']
                ]  do: aBlock
!

signalCompilationException: errorString

	^self compilationErrorSignal raiseWith: errorString
!

signalMatchException: errorString

	^self matchErrorSignal raiseWith: errorString
!

signalSyntaxException: errorString

        ^self syntaxErrorSignal raiseErrorString: errorString
! !

!RxParser class methodsFor:'preferences'!

preferredMatcherClass
	"The matcher to use. For now just one is available, but in
	principle this determines the matchers built implicitly,
	such as by String>>asRegex, or String>>matchesRegex:.
	This might seem a bit strange place for this preference, but
	Parser is still more or less `central' thing in the whole package."

	^RxMatcher
! !

!RxParser class methodsFor:'queries'!

backslashConstants
    ^ BackslashConstants
! !

!RxParser class methodsFor:'utilities'!

parse: aString
	"Parse the argument and return the result (the parse tree).
	In case of a syntax error, the corresponding exception is signaled."

	^self new parse: aString
!

safelyParse: aString
        "Parse the argument and return the result (the parse tree).
        In case of a syntax error, return nil.
        Exception handling here is dialect-dependent."

        ^self syntaxErrorSignal
                handle: [:ex | ex returnWith: nil]
                do: [self new parse: aString]
! !

!RxParser methodsFor:'accessing'!

parse: aString
	"Parse input from a string <aString>.
	On success, answers an RxsRegex -- parse tree root.
	On error, raises `RxParser syntaxErrorSignal' with the current
	input stream position as the parameter."

	^self parseStream: (ReadStream on: aString)
!

parseStream: aStream
	"Parse an input from a character stream <aStream>.
	On success, answers an RxsRegex -- parse tree root.
	On error, raises `RxParser syntaxErrorSignal' with the current
	input stream position as the parameter."

	| tree |
	input := aStream.
	lookahead := nil.
	self match: nil.
	tree := self regex.
	self match: #epsilon.
	^tree
! !

!RxParser methodsFor:'private'!

buildSetFrom: atomicRanges
    "Accept a collection of atomic range descriptions. 
    Each description is either a single character, 
    or a two-element array with (inclusive) beginning and end 
    of the range. Answer a set representing all the characters 
    combined. (Will also merge overlapping ranges)."

    | chars |
    chars := Set new: 256.
    atomicRanges do: [:range |
        range isImmediate
            ifTrue: [chars add: range]
            ifFalse:[ 
                | first last |
                
"/                first := range first asInteger.
"/                last := range last asInteger.
"/                first > last ifTrue: [self signalParseError: ' bad character range'].
"/                first to: last do: [:charCode | 
"/                        chars add: charCode asCharacter]
                first := range first.
                last := range last.
                first > last ifTrue: [self signalParseError: ' bad character range'].
                first to: last do: [:char | chars add: char]
            ]
    ].
    ^chars

    "Modified (format): / 21-06-2017 / 13:32:17 / cg"
!

characterSetFrom: setSpec
	"<setSpec> is what goes between the brackets in a charset regex
	(a String). Make a string containing all characters the spec specifies.
	Spec is never empty."

	| negated spec |
	spec := ReadStream on: setSpec.
	spec peek = $^
		ifTrue: 	[negated := true.
				spec next]
		ifFalse:	[negated := false].
	^RxsCharSet new
		initializeElements: (RxCharSetParser on: spec) parse
		negated: negated
!

ifSpecial: aCharacter then: aBlock
	"If the character is such that it defines a special node when follows a $\,
	then create that node and evaluate aBlock with the node as the parameter.
	Otherwise just return."

	| classAndSelector |
	classAndSelector := BackslashSpecials at: aCharacter ifAbsent: [^self].
	^aBlock value: (classAndSelector key new perform: classAndSelector value)
!

inputUpTo: aCharacter errorMessage: aString
        "Accumulate input stream until <aCharacter> is encountered
        and answer the accumulated chars as String, not including
        <aCharacter>. Signal error if end of stream is encountered,
        passing <aString> as the error description."

        | accumulator |
        accumulator := CharacterWriteStream on: (String new: 20).
        [lookahead ~= aCharacter and: [lookahead ~= #epsilon]]
                whileTrue:
                        [accumulator nextPut: lookahead.
                        self next].
        lookahead = #epsilon ifTrue: [self signalParseError: aString].
        ^accumulator contents
!

inputUpTo: aCharacter nestedOn: anotherCharacter errorMessage: aString 
        "Accumulate input stream until <aCharacter> is encountered
        and answer the accumulated chars as String, not including
        <aCharacter>. Signal error if end of stream is encountered,
        passing <aString> as the error description."

        | accumulator nestLevel|
        accumulator := CharacterWriteStream on: (String new: 20).
        nestLevel := 0.
        [lookahead ~= aCharacter or: [nestLevel > 0]] whileTrue:[ 
                        #epsilon = lookahead ifTrue: [self signalParseError: aString].
                        (lookahead == $\) ifTrue:[
                            self next.
                            #epsilon = lookahead ifTrue: [self signalParseError: aString].
                            ((lookahead == $]) or:[lookahead == $[ ]) ifTrue:[
                                accumulator nextPut: lookahead.
                            ] ifFalse:[
                                accumulator nextPut: $\.
                                accumulator nextPut: lookahead.
                            ].
                        ] ifFalse:[
                            accumulator nextPut: lookahead.
                            lookahead = anotherCharacter ifTrue: [nestLevel := nestLevel + 1].
                            lookahead = aCharacter ifTrue: [nestLevel := nestLevel - 1].
                        ].
                        self next].
        ^accumulator contents
!

match: aCharacter
	"<aCharacter> MUST match the current lookeahead.
	If this is the case, advance the input. Otherwise, blow up."

	aCharacter ~= lookahead 
		ifTrue: [^self signalParseError].       "does not return"
	self next
!

next
	"Advance the input storing the just read character
	as the lookahead."

	input atEnd
		ifTrue: [lookahead := #epsilon]
		ifFalse: [lookahead := input next]
!

parseRange: specStream
        "Parse a stream of what goes between the range brackets to produce
        a collection of `atomic ranges': either individual characters
        or two-element (first, last) arrays.
        The parsing below is in LR spirit: a stack accumulates terminals 
        seen so far as either characters or two-element arrays (for ranges). 
        When a dash was seen and was not yet matched, the stack top 
        is a non-terminal #dash."

        | stack |
        stack := OrderedCollection new.
        [specStream atEnd] whileFalse:
                [ | inputChar |
                inputChar := specStream next.
                inputChar ~= $- 
                        ifTrue:  
                                [(stack isEmpty or: [stack last ~~ #dash])
                                        ifTrue: [stack add: inputChar]
                                        ifFalse: 
                                                [stack removeLast.
                                                stack add: 
                                                        (Array with: stack removeLast with: inputChar)]]
                        ifFalse:
                                [stack isEmpty
                                        ifTrue: [stack add: inputChar]
                                        ifFalse: 
                                                [(stack last ~~ #dash and: [stack last isImmediate])
                                                ifTrue: [stack add: #dash]
                                                ifFalse: [self signalParseError: ' bad range syntax']]]].
        (stack isEmpty not and: [stack last == #dash])
                ifTrue:         "We just saw a literal minus"
                        [stack removeLast.
                        stack add: $-].
        ^stack

    "Modified: / 30-07-2013 / 19:32:25 / cg"
!

signalParseError

	self class signalSyntaxException: 'Regex syntax error'
!

signalParseError: aString

	self class signalSyntaxException: aString
! !

!RxParser methodsFor:'recursive descent'!

atom
        "An atom is one of a lot of possibilities, see below."

        | atom |
        (lookahead = #epsilon 
                        or: [lookahead == $| 
                        or: [lookahead == $)
                        or: [lookahead == $* 
                        or: [lookahead == $+ 
                        or: [lookahead == $?
                        or: [lookahead == ${ 
        ]]]]]])
                ifTrue: [^RxsEpsilon new].
        lookahead == $( ifTrue: 
                        ["<atom> ::= '(' <regex> ')' "

                        self match: $(.
                        atom := self regex.
                        self match: $).
                        ^atom].
        lookahead == $[ ifTrue: 
                        ["<atom> ::= '[' <characterSet> ']' "

                        self match: $[.
                        atom := self characterSet.
                        self match: $].
                        ^atom].
        lookahead == $: ifTrue: 
                        ["<atom> ::= ':' <messagePredicate> ':' "

                        self match: $:.
                        atom := self messagePredicate.
                        self match: $:.
                        ^atom].
        lookahead == $. ifTrue: 
                        ["any non-whitespace character"

                        self next.
                        ^RxsContextCondition new beAny].
        lookahead == $^ ifTrue: 
                        ["beginning of line condition"

                        self next.
                        ^RxsContextCondition new beBeginningOfLine].
        lookahead == $$ ifTrue: 
                        ["end of line condition"

                        self next.
                        ^RxsContextCondition new beEndOfLine].
        lookahead == $\ ifTrue: 
                        ["<atom> ::= '\' <character>"
                        self next.
                        lookahead = #epsilon ifTrue: 
                                [self signalParseError: 'bad quotation'].
                        (BackslashConstants includesKey: lookahead) ifTrue:
                                [atom := RxsCharacter with: (BackslashConstants at: lookahead).
                                self next.
                                ^atom].
                        self ifSpecial: lookahead
                                then: [:node | self next. ^node]].
        "If passed through the above, the following is a regular character."
        atom := RxsCharacter with: lookahead.
        self next.
        ^atom
!

branch
        "<branch> ::= e | <piece> <branch>"

        | piece branch |
        piece := self piece.
        (lookahead = #epsilon or: [lookahead == $| or: [lookahead == $) ]])
                ifTrue: [branch := nil]
                ifFalse: [branch := self branch].
        ^RxsBranch new 
                initializePiece: piece 
                branch: branch
!

characterClass
	"Match a character class specification: a selector (presumably
	understood by a Character) enclosed in :'s ."

	| spec negated |
	spec := (self inputUpTo: $: errorMessage: ' no terminating ":"').
	negated := false.
	spec first = $^ ifTrue:
		[negated := true.
		spec := spec copyFrom: 2 to: spec size].
	^RxsCharClass new 
		initializeSelector: spec asSymbol
		negated: negated
!

characterSet
        "Match a range of characters: something between `[' and `]'.
        Opening bracked has already been seen, and closing should
        not be consumed as well. Set spec is as usual for
        sets in regexes."

        | spec errorMessage |
        errorMessage := ' no terminating "]"'.
        spec := self inputUpTo: $] nestedOn: $[ errorMessage: errorMessage.
        (spec isEmpty or: [spec = '^']) ifTrue: "This ']' was literal."
                [self next.
                spec := spec, ']', (self inputUpTo: $] nestedOn: $[ errorMessage: errorMessage)].
        ^self characterSetFrom: spec

        "
         'abc'   matchesRegex: '[\[]*'   
         'xx[xx' matchesRegex: '[\[]*' 
         '[xx'   matchesRegex: '[\[]*' 
         'xx['   matchesRegex: '[\[]*' 
         '['     matchesRegex: '[\[]*'  
         '[[['   matchesRegex: '[\[]*'  
         '['     matchesRegex: '[\]]*' 
         ']'     matchesRegex: '[\]]*' 
         ' '     matchesRegex: '\d'   
         'd'     matchesRegex: '\d'  
         '[[]]'  matchesRegex: '[\[\]]*'  
        "
!

messagePredicate
	"Match a message predicate specification: a selector (presumably
	understood by a Character) enclosed in :'s ."

	| spec negated |
	spec := (self inputUpTo: $: errorMessage: ' no terminating ":"').
	negated := false.
	spec first = $^ ifTrue:
		[negated := true.
		spec := spec copyFrom: 2 to: spec size].
	^RxsMessagePredicate new 
		initializeSelector: spec asSymbol
		negated: negated
!

number
        "A number is just that"

        | n |

        ((lookahead = #epsilon) or:[lookahead isDigit not]) ifTrue:[
            self signalParseError: 'number expected'.
        ].

        n := 0.
        [ lookahead ~= #epsilon and:[ lookahead isDigit ] ] whileTrue:[
            n := (n*10) + lookahead digitValue.
            self next.
        ].
        ^ n

        "
         'a' matchesRegex: 'a{3}'     
         'aa' matchesRegex: 'a{3}'                 
         'aaa' matchesRegex: 'a{3}'                
         'aaaa' matchesRegex: 'a{3}'               
         'aaaa' matchesRegex: '(a)(a)(a)(a)'       
         '11 12 13 ' matchesRegex: '([0-9]+ ){2,4}'  
         '11 12 13 ' matchesRegex: '([0-9]+ )([0-9]+ )([0-9]+ )'  
         'a' matchesRegex: 'a{3'     
        "
!

piece
        "<piece> ::= <atom> | <atom>* | <atom>+ | <atom>?"

        | atom errorMessage min max|
        errorMessage := ' nullable closure'.
        atom := self atom.
        lookahead == $* ifTrue: 
                [self next.
                atom isNullable ifTrue: [self signalParseError: errorMessage].
                ^RxsPiece new initializeStarAtom: atom].
        lookahead == $+ ifTrue: 
                [self next.
                atom isNullable ifTrue: [self signalParseError: errorMessage].
                ^RxsPiece new initializePlusAtom: atom].
        lookahead == $? ifTrue: 
                [self next.
                atom isNullable ifTrue: [self signalParseError: errorMessage].
                ^RxsPiece new initializeOptionalAtom: atom].

        "/ cg: added
        lookahead == ${ ifTrue:[ 
            self next.
            atom isNullable ifTrue: [self signalParseError: errorMessage].
            lookahead == $, ifFalse:[
                min := self number.
            ].
            lookahead == $, ifTrue:[
                self next.
                lookahead ~~ $} ifTrue:[                
                    max := self number.
                ].
                "otherwise max is nil - that means unlimited repetitions"
            ] ifFalse:[
                max := min.
            ].
            lookahead == $} ifFalse:[
                self signalParseError: '"}" expected'
            ].
            (min isNil and:[max isNil]) ifTrue:[
                self signalParseError: 'empty repetition count'
            ].
            self next.
            ^RxsPiece new initializeAtom: atom min: min max: max.
        ].
        ^RxsPiece new initializeAtom: atom
!

regex
        "<regex> ::= e | <branch> `|' <regex>"

        | branch regex |
        branch := self branch.
        (lookahead = #epsilon or: [lookahead == $)])
                ifTrue: [regex := nil]
                ifFalse: 
                        [self match: $|.
                        regex := self regex].
        ^RxsRegex new initializeBranch: branch regex: regex
! !

!RxParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxParser.st,v 1.31 2017-06-21 18:51:59 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxParser.st,v 1.31 2017-06-21 18:51:59 cg Exp $'
! !


RxParser initialize!
