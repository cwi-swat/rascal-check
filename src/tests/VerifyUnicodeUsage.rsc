module tests::VerifyUnicodeUsage

import tests::RascalInformation;
import lang::java::m3::Core;


set[loc] exceptions = {

};

public test bool checkGetInputStreamIsAvoided() 
  = requireEmpty({ f | <f,t> <- getRascalM3@methodInvocation,
                 t.scheme == "java+method",
                 /getInputStream(.*)/ := t.path} - exceptions, 
                 "use getCharacterReader instead of getInputStream to avoid encoding problems");

// The old exceptions:        
		//, entity([_*, package("rascalmpl"), package("tutor"), _*]) !:= f
		//, entity([_*, package("rascalmpl"), package("uri"), _*]) !:= f
		//, entity([_*, class(c), method("getInputStream",_,_),_*]) !:= f && !endsWith(c, "URIResolver")
		//
		//, entity([_*, class("Prelude"), method("readBinaryValueFile",_,_),_*]) !:= f
		//, entity([_*, class("Prelude"), method("readFileBytes",_,_),_*]) !:= f
		//, entity([_*, class("Prelude"), method("readTextValueFile",_,_),_*]) !:= f
		//, entity([_*, class("Prelude"), method("md5HashFile",_,_),_*]) !:= f
		//, entity([_*, class("Prelude"), method("writeFile",_,_),_*]) !:= f
		//
		//, entity([_*, class("Rascalify"), method("deserializeToDisk",_,_),_*]) !:= f
		//, entity([_*, class("IO"), method("readTextATermFile",_,_),_*]) !:= f
