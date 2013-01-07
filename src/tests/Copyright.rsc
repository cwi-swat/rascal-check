module tests::Copyright

import tests::RascalInformation;
import util::FileSystem;
import IO;
import tests::UnitTestAdditions;
import List;

private str copyright = "/*******************************************************************************
                        ' * Copyright (c) 2009-2011 CWI
                        ' * All rights reserved. This program and the accompanying materials
                        ' * are made available under the terms of the Eclipse Public License v1.0
                        ' * which accompanies this distribution, and is available at
                        ' * http://www.eclipse.org/legal/epl-v10.html
                        ' *******************************************************************************/";
 
private set[str] words = { w | /<w:[A-Za-z]+>/ := copyright };
                            
public test bool rascalFilesCopyright() {
    fs = getRascalResources();
    noheader = [ l | /file(l) := fs, l.extension == "java" || l.extension == "rsc", 
                   !all(w <- words, /<w>/ <- intercalate("\n", take(10, readFileLines(l)))) ];
    
    for (l <- noheader) {
      println("no copyright header in <l>");
    }
    
    return noheader == [];                   
}