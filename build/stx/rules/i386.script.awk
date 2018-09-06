# $Header: /cvs/stx/stx/rules/i386.script.awk,v 1.2 1999-12-01 10:53:26 cg Exp $
#
# awk assembler output processing.
# this little awk script removes a nonsense
# code sequence, which results from the asm-method entry
# the code:
#       jmp __x_label
#       [optional #NO_APP / .text / .align]
#   __x_label:
#
# is removed from the assembler code.
# This is mostly done for more compact code - less for speed.
# (the saving is roughly 6% in libbasic2)
#
# The above code sequence only appears in +optSpace compiled code;
# therefore, this script is only used if compiling for space 
# (OPTSPACE_O_RULE)
#

BEGIN   {
	    VERBOSE=0

	    STATE=0
	    KEEP=0
	    NBUFFER=0
	    SKIP=0
	    JUMPSREMOVED=0
	}

END     {
	    printf "# %d useless entry jumps eliminated\n",JUMPSREMOVED
	}

/ jmp __x.*/ {
	    if (STATE == 0) {
		STATE=1
		LABEL=$2
		if (VERBOSE==1) printf "# got a jump label=%s\n",LABEL
		KEEP=1
	    } else {
		KEEP=0
	    }
	}

/.data/ {
	    if (STATE == 1) {
		if (VERBOSE==1) printf "# got .data\n"
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/^#NO_APP$/ {
	    if (STATE == 1) {
		STATE=2
		if (VERBOSE==1) printf "# got NO_APP\n"
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/^.text$/ {
	    if ((STATE == 2) || (STATE == 1)) {
		STATE=3
		if (VERBOSE==1) printf "# got .text\n"
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/.align 4/ {
	    if ((STATE == 2) || (STATE == 1) || (STATE == 3)) {
		STATE=4
		if (VERBOSE==1) printf "# got .align\n"
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/^.*:/ {
	    if ((STATE == 4) || (STATE == 3) || (STATE == 2) || (STATE == 1)) {
		if (VERBOSE==1) printf "# label %s\n",$1
		if ($1 == LABEL":") {
		    if (VERBOSE==1) printf "# got jump target %s\n",LABEL
		    JUMPSREMOVED++
		    NBUFFER=0
		    KEEP=0
		    STATE=0
		    SKIP=1
		} else {
		    KEEP=0
		    STATE=0
		}
	    } else {
		KEEP=0
		STATE=0
	    }
	}

	{
	    if (KEEP == 1) {
		NBUFFER++
		BUFFER[NBUFFER]=$0
	    } else {
		IDX=1
		while (IDX <= NBUFFER) {
		    print BUFFER[IDX]
		    IDX++
		}
		NBUFFER=0
		if (SKIP == 0) print
		SKIP=0
	    }
	}

