#!/bin/sh
"C:/Program Files (x86)/Notepad++/notepad++.exe" -multiInst -ldiff -notabbar -nosession "$(cygpath -w "$*")"