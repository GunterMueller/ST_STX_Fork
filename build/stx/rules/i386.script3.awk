# $Header: /cvs/stx/stx/rules/i386.script3.awk,v 1.2 1999-12-01 10:53:28 cg Exp $
#
# awk assembler output processing.
# this little awk script rewrites the stack-check sequence
# which results from the asm-inline stack-check
# by a slightly faster code sequence.
# the code:
#       #APP
#       movl %esp,%eax
#       #NO_APP
#       cmpl %eax,___stackBottom__
#
# is replaced by:
#       cmpl %esp,___stackBottom__
#

BEGIN   {
	    VERBOSE=0

	    STATE=0
	    KEEP=0
	    NBUFFER=0
	    SKIP=0
	    MOVESELIMINATED=0
	}

END     {
	    printf "# %d moves eliminated\n",MOVESELIMINATED
	}

/#APP/ {
	    if (STATE == 0) {
		STATE=1
		if (VERBOSE==1) printf "# got a #APP\n"
		KEEP=1
		SKIP=1
	    } else {
		KEEP=0
	    }
	}

/movl %esp,%eax/ {
	    if (STATE == 1) {
		STATE=2
		if (VERBOSE==1) printf "# got move\n"
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/#NO_APP/ {
	    if (STATE == 2) {
		STATE=3
		if (VERBOSE==1) printf "# got a #NO_APP\n"
		KEEP=1
		SKIP=1
	    } else {
		KEEP=0
	    }
	}

/cmpl %eax,___stackBottom__/ {
	    if (STATE == 3) {
		if (VERBOSE==1) printf "# cmpl\n"
		printf " cmpl %%esp,___stackBottom__\n"
		MOVESELIMINATED++
		NBUFFER=0
		KEEP=0
		STATE=0
		SKIP=1
	    } else {
		if (VERBOSE==1) printf "# got cmpl in wrong state\n"
		KEEP=0
		STATE=0
	    }
	}

	{
	    if (KEEP == 1) {
		if (SKIP == 0) {
		    NBUFFER++
		    BUFFER[NBUFFER]=$0
		}
	    } else {
		IDX=1
		while (IDX <= NBUFFER) {
		    print BUFFER[IDX]
		    IDX++
		}
		NBUFFER=0
		if (SKIP == 0) print
	    }
	    SKIP=0
	    if (KEEP != 1) {
		if (VERBOSE==1) printf "# reset state for:%s\n", $0
		STATE=0
	    }
	    KEEP=0
	}

