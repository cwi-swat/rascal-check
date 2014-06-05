module tests::RascalInformation

import IO;
import Set;
import ValueIO;
import String;
import util::Maybe;
import util::FileSystem;
import util::Monitor;
import List;

import analysis::m3::Core;
import analysis::m3::Registry;
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

private bool done(loc f) {
  event("<f>");
  return true;
}

@Memo
M3 getRascalM3() {
  init();
  fs =  [ f | sp <- { p + "src" | p <- projects}, loc f <- find(sp, "java") ];
  startJob("Analyzing Java files", size(fs));
  m3s = { createM3FromFile(f) | f <- fs, done(f) };
  result = composeJavaM3(|rascal:///|, m3s);
  registerProject(|rascal:///|, result);
  return result;
}
  
@memo
set[Declaration] getRascalAdts() 
  = { createAstFromFile(f, true) | init(), d <- projects, loc f <- find(d, "java"), bprintln(f) };

