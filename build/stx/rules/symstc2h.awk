# $Header: /cvs/stx/stx/rules/symstc2h.awk,v 1.3 1999-12-01 10:53:39 cg Exp $
#
# This awk script converts a symbols.stc file to a symbols.h file
#
# Notice: no longer used; this is now done by a shell script
# contained in the stdRules make-include.
#

BEGIN           { print "char *__symbols[] = {" }
# avoid gsub() ... not understood by all awks.
# { gsub(/\\/, "\\\\"); printf "\"%s\",\n", $0 }
$0 == "\\\\"    { print "\"\\\\\\\\\","; next }
		{ print "\"" $0 "\"," }
END             { print "0 };" }
