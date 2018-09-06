# $Header: /cvs/stx/stx/rules/i386.script2.awk,v 1.2 1999-12-01 10:53:27 cg Exp $
#
# awk assembler output processing.
# this little awk script removes jumps to jumps
# which results from the asm-inline add/subtract code
#
# ---------------------
# the code:
#       jno 0f
#       call MKLARGEINT
#   0:
#   #NO_APP
#       jmp label
#
# is replaced by:
#       jno label
#       call MKLARGEINT
#       jmp label
#
# ---------------------
# and:
#       jno 0f
#       call MKLARGEINT
#       jmp 1f
#   0:
#       incl %eax
#   1:
#       jmp label
#
# is replaced by:
#       jo  0f
#       incl %eax
#       jmp label
#   0:  call MKLARGEINT
#       jmp label
#
# ----------------------

BEGIN   {
	    VERBOSE=0

	    STATE=0
	    KEEP=0
	    NBUFFER=0
	    SKIP=0
	    JUMPSTOJUMPS=0
	    CONDBRANCHRRELAX=0
	}

END     {
	    printf "# %d jnos to jumps eliminated; %d cond branches relaxed\n",JUMPSTOJUMPS,CONDBRANCHRELAX
	}

/ jno *0f/ {
	    if (STATE == 0) {
		STATE=1
		if (VERBOSE==1) printf "# got a jno\n"
		KEEP=1
	    } else {
		KEEP=0
	    }
	}

/call *MKLARGEINT/ {
	    if (STATE == 1) {
		STATE=2
		if (VERBOSE==1) printf "# got call MKLARGEINT\n"
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/ jmp *1f/ {
	    if (STATE == 2) {
		STATE=10
		if (VERBOSE==1) printf "# got a jno\n"
		KEEP=1
	    } else {
		KEEP=0
	    }
	}

/^[ \t]*$/ {
	    KEEP=1
	    SKIP=1
	}

/^#NO_APP$/ {
	    KEEP=1
	    SKIP=1
	}

/ *0: *$/ {
	    if (STATE == 2) {
		STATE=3
		if (VERBOSE==1) printf "# got 0:\n"
		KEEP=1
	    } else {
		if (STATE == 10) {
		    STATE=11
		    KEEP=1
		} else {
		    if (VERBOSE==1) printf "# got 0: in wrong state\n"
		    KEEP=0
		    STATE=0
		}
	    }
	}

/ *1: */ {
	    if (STATE==12) {
		STATE=13
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/incl *%eax/ {
	    if (STATE==11) {
		STATE=12
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/jmp L.*/ {
	    if (STATE == 3) {
		if (VERBOSE==1) printf "# label %s\n",$2
		printf " jno %s\n",$2
		printf " call MKLARGEINT\n"
		printf " jmp %s\n",$2
		JUMPSTOJUMPS++
		NBUFFER=0
		KEEP=0
		STATE=0
		SKIP=1
	    } else {
		if (STATE==13) {
		    printf " jo 0f\n"
		    printf " incl %%eax\n"
		    printf " jmp %s\n",$2
		    printf "0:\n"
		    printf " call MKLARGEINT\n"
		    printf " jmp %s\n",$2
		    CONDBRANCHRELAX++
		    NBUFFER=0
		    KEEP=0
		    STATE=0
		    SKIP=1
		} else {
		    if (VERBOSE==1) printf "# got label %s in wrong state %s\n",$2,STATE
		    KEEP=0
		    STATE=0
		}
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

