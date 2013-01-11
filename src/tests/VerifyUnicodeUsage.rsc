module tests::VerifyUnicodeUsage

import String;
import List;
import IO;
import Set;
import Relation;
import util::Resources;
import lang::java::jdt::Java;
import lang::java::jdt::JavaADT;
import lang::java::jdt::JDT;

import tests::RascalInformation;
import tests::UnitTestAdditions;

public test bool checkGetInputStreamIsAvoided() {
	Resource dt = getRascalResources();
	getInputStreamCalls = { f | <f,t> <- dt@calls, entity([_*, method("getInputStream",params,_)]) := t, size(params) > 0
		, entity([_*, package("rascalmpl"), package("tutor"), _*]) !:= f
		, entity([_*, package("rascalmpl"), package("uri"), _*]) !:= f
		, entity([_*, class(c), method("getInputStream",_,_),_*]) !:= f && !endsWith(c, "URIResolver")
		
		, entity([_*, class("Prelude"), method("readBinaryValueFile",_,_),_*]) !:= f
		, entity([_*, class("Prelude"), method("readFileBytes",_,_),_*]) !:= f
		, entity([_*, class("Prelude"), method("readTextValueFile",_,_),_*]) !:= f
		, entity([_*, class("Prelude"), method("md5HashFile",_,_),_*]) !:= f
		, entity([_*, class("Prelude"), method("writeFile",_,_),_*]) !:= f
		
		, entity([_*, class("Rascalify"), method("deserializeToDisk",_,_),_*]) !:= f
		, entity([_*, class("IO"), method("readTextATermFile",_,_),_*]) !:= f
	};
	return assertIsEmpty(getInputStreamCalls, "getInputStream should only be used for binary streams or when you want to do something very specific to the encoding, else use getCharacterReader");	
}