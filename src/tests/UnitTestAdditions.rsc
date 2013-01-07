module tests::UnitTestAdditions

import IO;
import Set;
import lang::java::jdt::Java;
import lang::java::jdt::JDT;

public bool assertIsEmpty(set[Entity] ents, str message) {
	if (size(ents) == 0) {
		return true;
	}
	println(message);
	for (e <- ents) {
		println("\t" + readable(e));
	}
	return false;
} 