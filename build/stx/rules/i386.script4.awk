# $Header: /cvs/stx/stx/rules/i386.script4.awk,v 1.2 1999-12-01 10:53:29 cg Exp $
#
# awk assembler output processing.
# this little awk script rewrites the setjmp sequence
# which results from the asm-inline setjmp
# to a slightly faster code sequence (eliminating a conditional branch).
# the code:
#       xorl %eax,%eax
#       0:
#       testl %eax,%eax
#       je label
#
# is replaced by:
#       xorl %eax,%eax
#       j label
#       0:
#       testl %eax,%eax
#       je label
#

BEGIN   {
	    VERBOSE=0

	    STATE=0
	    KEEP=0
	    NBUFFER=0
	    SKIP=0
	    TESTSELIMINATED=0
	}

END     {
	    printf "# %d tests eliminated\n",TESTSELIMINATED
	}

/xorl *%eax, %eax/ {
	    if (STATE == 0) {
		STATE=1
		if (VERBOSE==1) printf "# got a #APP\n"
		KEEP=1
	    } else {
		KEEP=0
	    }
	}

/ *0: *$/ {
	    if (STATE == 1) {
		STATE=2
		if (VERBOSE==1) printf "# got 0:\n"
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/testl %eax,%eax/ {
	    if (STATE == 2) {
		STATE=3
		if (VERBOSE==1) printf "# got move\n"
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/je L.*/ {
	    if (STATE == 3) {
		if (VERBOSE==1) printf "# label %s\n",$2
		printf " xorl %%eax,%%eax\n"
		printf " jmp %s\n",$2
		printf "0:\n"
		printf " testl %%eax,%%eax\n"
		printf " je %s\n",$2
		TESTSELIMINATED++
		NBUFFER=0
		KEEP=0
		STATE=0
		SKIP=1
	    } else {
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

