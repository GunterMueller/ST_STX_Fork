#!/bin/sh
# use --debug as arg to debug failed test cases

../../../projects/smalltalk/stx -I --noInfoPrint --noBanner --ignoreHalt --abortOnInternalError --abortOnMessageSendError $* --execute SelfTest.st
