import "arguments" as arguments
import "minigrace" as minigrace
import "sys" as sys
import "unicode" as unicode
import "util" as util
import "lexer" as lexer
import "ast" as ast
import "parser" as parser
import "genc" as genc
import "genjs" as genjs
import "genjson" as genjson
import "buildinfo" as buildinfo
import "mgcollections" as mgcollections
import "interactive" as interactive
import "identifierresolution" as identifierresolution
import "mirrors" as mirrors

def args = arguments.parseArgs(sys.argv)
def versionNumber = "0.0.8"

if(args.help) then {
    def exe = sys.argv.at(1)
    print "Usage: {exe} [OPTION]... [FILE]"
    print "Compile, process, or run a Grace source file or standard input."
    print ""
    print "Modes:"
    print "  --make           Compile FILE to a native executable"
    print "  --run            Compile FILE and execute the program [default]"
    print "  --source         Compile FILE to source, but no further"
    print "  --dynamic-module Compile FILE as a dynamic module (experimental!)"
    print "  --interactive    Launch interactive read-eval-print interpreter"
    print ""
    print "Options:"
    print "  --verbose        Give more detailed output"
    print "  --target TGT     Choose a non-default compilation target TGT"
    print "                   Use --target help to list supported targets."
    print "  -o OFILE         Output to OFILE instead of default"
    print "  -j N             Spawn at most N concurrent subprocesses"
    print "  --help           This text"
    print "  --module         Override default module name (derived from FILE)"
    print "  --no-recurse     Do not compile imported modules"
    print "  --stdout         Output to standard output rather than a file"
    print "  --version        Print version information"
    print ""
    print "By default, {exe} FILE will compile and execute FILE."
    print "More detailed usage information is in the <doc/usage> file in the source tree."

} elseif (args.version)then {
    
    print("minigrace {versionNumber}.{buildinfo.gitgeneration}")
    print("git revision " ++ buildinfo.gitrevision)
    print("<http://ecs.vuw.ac.nz/~mwh/minigrace/>")
}
else {
    minigrace.compile(args.inFile) withTarget(args.target) withModule(args.modnamev) mode(args.runmodev) build(args.buildtypev)
}


// def targets = ["lex", "parse", "grace", "processed-ast",
//     "imports", "c", "js"]

// if (util.target == "help") then {
//     print("Valid targets:")
//     for (targets) do {t->
//         print("  {t}")
//     }
//     sys.exit(0)
// }

// if (util.interactive) then {
//     interactive.startRepl
//     sys.exit(0)
// }

// var tokens := lexer.Lexer.new.lexfile(util.infile)
// if (util.target == "lex") then {
//     // Print the lexed tokens and quit.
//     for (tokens) do { v ->
//         print(v.kind ++ ": " ++ v.value)
//         if (util.verbosity > 30) then {
//             print("  [line: {v.line} position: {v.linePos} indent: {v.indent}]")
//         }
//     }
//     sys.exit(0)
// }

// // JSON wants to keep hold of the last token in the file
// if (util.target == "json") then {
//     if (tokens.size > 0) then {
//         genjson.saveToken(tokens.last)
//     }
// }

// var values := parser.parse(tokens)

// if (util.target == "parse") then {
//     // Parse mode pretty-prints the source's AST and quits.
//     for (values) do { v ->
//         print(v.pretty(0))
//     }
//     sys.exit(0)
// }
// if (util.target == "grace") then {
//     for (values) do { v ->
//         print(v.toGrace(0))
//     }
//     sys.exit(0)
// }
// if (util.target == "c") then {
//     genc.processImports(values)
// }
// if (util.target == "js") then {
//     genjs.processDialect(values)
// }
// if (util.target == "json") then {
//     genjs.processDialect(values)
// }
// if (util.extensions.contains("Plugin")) then {
//     mirrors.loadDynamicModule(util.extensions.get("Plugin")).processAST(values)
// }
// values := identifierresolution.resolve(values)
// if (util.target == "processed-ast") then {
//     for (values) do { v ->
//         print(v.pretty(0))
//     }
//     sys.exit(0)
// }
// if (util.target == "imports") then {
//     def imps = mgcollections.set.new
//     def vis = object {
//         inherits ast.baseVisitor
//         method visitImport(o) -> Boolean {
//             imps.add(o.value.value)
//         }
//     }
//     for (values) do {v->
//         v.accept(vis)
//     }
//     for (imps) do {im->
//         print(im)
//     }
//     sys.exit(0)
// }

// // Perform the actual compilation
// match(util.target)
//     case { "c" ->
//         genc.compile(values, util.outfile, util.modname, util.runmode,
//             util.buildtype)
//     }
//     case { "js" ->
//         genjs.compile(values, util.outfile, util.modname, util.runmode,
//             util.buildtype, util.gracelibPath)
//     }
//     case { "json" ->
//         genjson.generate(values, util.outfile)
//     }
//     case { _ ->
//         io.error.write("minigrace: no such target '" ++ util.target ++ "'\n")
//         sys.exit(1)
//     }
