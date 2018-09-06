# This file contans a default build configuration. It is created automatically
# when `rake` is called for the very first time. You may still override values
# on command line, i.e., 
#
#     rake PROJECT=some-other-project 
#
# This file SHOULD NOT be checked in a repository. 
#
unless defined? PROJECT; PROJECT='stx:jv-branch'; end
unless defined? BUILD_TARGET; BUILD_TARGET = 'x86_64-pc-linux-gnu'; end
