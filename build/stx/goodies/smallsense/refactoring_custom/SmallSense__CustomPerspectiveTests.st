"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:goodies/smallsense/refactoring_custom' }"

"{ NameSpace: SmallSense }"

Smalltalk::TestCase subclass:#CustomPerspectiveTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Tests'
!

!CustomPerspectiveTests class methodsFor:'documentation'!

copyright
"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!CustomPerspectiveTests methodsFor:'tests'!

test_all_perspectives_false_as_default
    | perspective |

    perspective := CustomPerspective new.

    self deny: perspective isClassCategoryPerspective.
    self deny: perspective isClassPerspective.
    self deny: perspective isCodeViewPerspective.
    self deny: perspective isInstanceVariablePerspective.
    self deny: perspective isMethodPerspective.
    self deny: perspective isNamespacePerspective.
    self deny: perspective isPackagePerspective.
    self deny: perspective isProtocolPerspective.

    "Created: / 14-10-2014 / 11:47:29 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_class_category_perspective
    |perspective|

    perspective := CustomPerspective classCategoryPerspective.
    self assert:perspective isClassCategoryPerspective.
    self deny:perspective isClassPerspective.
    self deny:perspective isCodeViewPerspective.
    self deny:perspective isInstanceVariablePerspective.
    self deny:perspective isMethodPerspective.
    self deny:perspective isNamespacePerspective.
    self deny:perspective isPackagePerspective.
    self deny:perspective isProtocolPerspective.

    "Created: / 14-10-2014 / 11:49:35 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_class_perspective
    |perspective|

    perspective := CustomPerspective classPerspective.
    self deny:perspective isClassCategoryPerspective.
    self assert:perspective isClassPerspective.
    self deny:perspective isCodeViewPerspective.
    self deny:perspective isInstanceVariablePerspective.
    self deny:perspective isMethodPerspective.
    self deny:perspective isNamespacePerspective.
    self deny:perspective isPackagePerspective.
    self deny:perspective isProtocolPerspective.

    "Created: / 14-10-2014 / 11:50:33 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_code_view_perspective
    | perspective |

    perspective := CustomPerspective codeViewPerspective.

    self deny: perspective isClassCategoryPerspective.
    self deny: perspective isClassPerspective.
    self assert: perspective isCodeViewPerspective.
    self deny: perspective isInstanceVariablePerspective.
    self deny: perspective isMethodPerspective.
    self deny: perspective isNamespacePerspective.
    self deny: perspective isPackagePerspective.
    self deny: perspective isProtocolPerspective.

    "Created: / 14-10-2014 / 11:51:21 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_instance_variable_perspective
    | perspective |

    perspective := CustomPerspective instanceVariablePerspective.

    self deny: perspective isClassCategoryPerspective.
    self deny: perspective isClassPerspective.
    self deny: perspective isCodeViewPerspective.
    self assert: perspective isInstanceVariablePerspective.
    self deny: perspective isMethodPerspective.
    self deny: perspective isNamespacePerspective.
    self deny: perspective isPackagePerspective.
    self deny: perspective isProtocolPerspective.

    "Created: / 14-10-2014 / 11:54:12 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_is_abstract

    self assert: CustomPerspective isAbstract.

    "Created: / 14-10-2014 / 11:57:32 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_method_variable_perspective
    | perspective |

    perspective := CustomPerspective methodPerspective.

    self deny: perspective isClassCategoryPerspective.
    self deny: perspective isClassPerspective.
    self deny: perspective isCodeViewPerspective.
    self deny: perspective isInstanceVariablePerspective.
    self assert: perspective isMethodPerspective.
    self deny: perspective isNamespacePerspective.
    self deny: perspective isPackagePerspective.
    self deny: perspective isProtocolPerspective.

    "Created: / 14-10-2014 / 11:54:41 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_namespace_perspective
    | perspective |

    perspective := CustomPerspective namespacePerspective.

    self deny: perspective isClassCategoryPerspective.
    self deny: perspective isClassPerspective.
    self deny: perspective isCodeViewPerspective.
    self deny: perspective isInstanceVariablePerspective.
    self deny: perspective isMethodPerspective.
    self assert: perspective isNamespacePerspective.
    self deny: perspective isPackagePerspective.
    self deny: perspective isProtocolPerspective.

    "Created: / 14-10-2014 / 11:55:40 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_package_perspective
    | perspective |

    perspective := CustomPerspective packagePerspective.

    self deny: perspective isClassCategoryPerspective.
    self deny: perspective isClassPerspective.
    self deny: perspective isCodeViewPerspective.
    self deny: perspective isInstanceVariablePerspective.
    self deny: perspective isMethodPerspective.
    self deny: perspective isNamespacePerspective.
    self assert: perspective isPackagePerspective.
    self deny: perspective isProtocolPerspective.

    "Created: / 14-10-2014 / 11:56:15 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_protocol_perspective
    | perspective |

    perspective := CustomPerspective protocolPerspective.

    self deny: perspective isClassCategoryPerspective.
    self deny: perspective isClassPerspective.
    self deny: perspective isCodeViewPerspective.
    self deny: perspective isInstanceVariablePerspective.
    self deny: perspective isMethodPerspective.
    self deny: perspective isNamespacePerspective.
    self deny: perspective isPackagePerspective.
    self assert: perspective isProtocolPerspective.

    "Created: / 14-10-2014 / 11:56:46 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_singleton
    | perspective_01 perspective_02 |

    perspective_01 := CustomPerspective new.
    perspective_02 := CustomPerspective new.

    self assert: perspective_01 == perspective_02.

    CustomPerspective flushSingleton.
    perspective_02 := CustomPerspective new.

    self deny: perspective_01 == perspective_02.

    "Created: / 14-10-2014 / 12:01:47 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

