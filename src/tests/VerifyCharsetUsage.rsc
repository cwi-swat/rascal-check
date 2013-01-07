module tests::VerifyCharsetUsage

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


public test bool checkGetCharsetIsCalled() {
	Resource dt = getRascalResources();
	getInputStreamCalls = { f | <f,t> <- dt@calls, entity([_*, method("getInputStream",_,_)]) := t};
	getCharsetCalls = { f | <f,t> <- dt@calls, entity([_*, method("getCharSet",_,_)]) := t};
	notCalledTogether = getInputStreamCalls - getCharsetCalls;
	callsToCharset = { f | <f,t> <- dt@calls, entity([_*, class("Charset"),_]) := t};
	notCalledTogether = notCalledTogether - callsToCharset; // remove some correct methods
	locations = invert(dt@methods);
	notCalledTogether = { c | c <- notCalledTogether, /(encod|charset|utf)/ := toLowerCase(readFile(getOneFrom(locations[c])))};
	println(size(notCalledTogether));
	return assertIsEmpty(notCalledTogether, "getInputStream and getCharset should always be called near each other");	
}