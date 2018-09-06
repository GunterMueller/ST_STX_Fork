/* Copyright (c) 1999  Cygnus Solutions
Written by Anthony Green <green@cygnus.com>

This file is part of Mauve.

Mauve is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.

Mauve is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mauve; see the file COPYING.  If not, write to
the Free Software Foundation, 59 Temple Place - Suite 330,
Boston, MA 02111-1307, USA.  */
package gnu.testlet;

public interface config {

    public static final String cpInstallDir = "@CP_INSTALL_DIR@";
    public static final String autoCompile = "yes";
    public static final String testJava = "java";
    public static final String ecjJar = "/usr/share/java/eclipse-ecj.jar";
    public static final String emmaString = "_auto_detect_emma_";
    public static final String srcdir = "/home/m/NetBeansProjects/MauveRunner/src";
    public static final String builddir = "/home/m/NetBeansProjects/MauveRunner/build";
    public static final String tmpdir = "/home/m/tmp";
    public static final String pathSeparator = ":";
    public static final String separator = "/";
    public static final String mailHost = "localhost";

    public abstract String getCpInstallDir();

    public abstract String getAutoCompile();

    public abstract String getTestJava();

    public abstract String getEcjJar();

    public abstract String getEmmaString();

    public abstract String getSourceDirectory();

    public abstract String getBuildDirectory();

    public abstract String getTempDirectory();

    public abstract String getPathSeparator();

    public abstract String getSeparator();

    public abstract String getMailHost();
}
