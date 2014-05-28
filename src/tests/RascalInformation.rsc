module tests::RascalInformation

import IO;
import Set;
import ValueIO;
import String;
import util::Maybe;
import util::FileSystem;

import analysis::m3::Core;
import lang::java::m3::Core;
import lang::java::m3::AST;

// this is an Eclipse dependency which we should try to remove
import lang::java::jdt::Project;
    
private set[loc] projects = {|project://rascal/|, |project://rascal-eclipse|};

bool requireEmpty({}, str _) = true;
default bool requireEmpty(set[value] s, str message) {
  println("<for (e <- s) {><message>: <e>
          '<}>");
  return false;
}

bool init() {
  classPaths = { *classPathForProject(p) | p <- projects} + {|project://pdb.values/bin|};
  sourcePaths = { p + "src" | p <- projects};
  
  println("classpath: <classPaths>");
  println("sources: <sourcePaths>");
  
  setEnvironmentOptions(classPaths, sourcePaths);
  return true; 
}

bool isGenerated(loc l)
  = /lang.rascal.syntax.*\.java/ := l.path;
  
bool isInteresting(loc l) 
  = (l.extension == "java" || l.extension == "rsc")
  && !isGenerated(l);

@memo
set[loc] getRascalFiles() = {*find(d, isInteresting) | d <- projects};

@memo
M3 getRascalM3() {
  init();
  M3 result = m3(|rascal:///|);
  for (sp <- { p + "src" | p <- projects}) {
    result = composeJavaM3(|rascal:///|, { createM3FromFile(f) | loc f <- find(sp, "java"), bprintln(f) });
  }
  return result;
}
  
@memo
set[Declaration] getRascalAdts() 
  = { createAstFromFile(f, true) | init(), d <- projects, loc f <- find(d, "java"), bprintln(f) };

