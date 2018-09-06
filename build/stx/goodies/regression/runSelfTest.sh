#!/bin/sh
# use --debug as arg to debug failed test cases

../../../stx/projects/smalltalk/stx --noInfoPrint --noBanner --exitOnInternalError --exitOnMessageSendError -I $* --execute SelfTestRunner.st
