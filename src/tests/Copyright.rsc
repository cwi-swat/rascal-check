module tests::Copyright

import tests::RascalInformation;
import List;
import IO;

str copyright = "/*******************************************************************************
                ' * Copyright (c) 2009-2013 CWI
                ' * All rights reserved. This program and the accompanying materials
                ' * are made available under the terms of the Eclipse Public License v1.0
                ' * which accompanies this distribution, and is available at
                ' * http://www.eclipse.org/legal/epl-v10.html
                ' *******************************************************************************/";
 
set[str] wordsInHeader = { w | /<w:[A-Za-z0-9]+>/ := copyright };
      
set[str] wordsInFileHeader(loc f) 
    = { w | /<w:[A-Za-z0-9]+>/ := intercalate("\n", take(10, readFileLines(f)))};
                    
bool checkFileCopyright(loc f) = wordsInHeader - wordsInFileHeader(f) == {};

test bool rascalFilesCopyright() 
  = requireEmpty({l | loc l <- getRascalFiles(), !checkFileCopyright(l)}, "No correct copyright header");
