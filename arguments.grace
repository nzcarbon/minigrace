// This module defines the command line arguments that the compiler can
// receive, as well as parsing utilities.

// The valid compilation targets.
def Target is public = "c" | "js"

// All of the command line arguments in a single object.
type Args is public = {
    target -> Target
}

// A group of methods that validate each argument input.
def check = object {
    method targetuntitled(t : String) {
        if((t != "c") && (t != "js")) then {
            Exception.raise "Invalid target {t}"
        }
    }
}

// Builds new argument objects with existing defaults.
class arguments.new -> Args is confidential {
    var help is public := false
    var target is public := "c"
    var verbose is public := false
    var interactive is public := false

    var gracelibPathv is public := false;

    def inFiles is public = []
    var out is public := ""

    var runmodev := "make"
    var buildtypev := "run"
    var noexecv := false
    var modnamev := "stdin_minigrace"

}

// Parses a list of command line arguments into an object.
method parseArgs(args : List<String>) -> Args {
    def a = arguments.new

    var count := 0;
    forArgs(args) do { arg, on ->
        on.flag "help" shortHand "h" do {
            a.help := true
        }
        on.option "target" shortHand "t" do { tgt ->
            a.target := check.targetuntitled(tgt)
        }  
        on.option "outfile" shortHand "o" do { out ->
            a.out := out
        }
        on.flag "verbose" shortHand "v" do {
            a.verbose := true
        }

        on.flag "interactive" shortHand "i" do {
            a.interactive := true
        }

        on.option "gracelib" shortHand "gl" do{ libp ->
            a.gracelibPathv := libp;
        }

        on.flag "dynamic-module" do { 
            a.runmodev := "make";
            a.noexecv := true;
            a.buildtypev := "bc";
        }

        on.option "--module" do { m ->
            a.modnamev := m
        }

        on.flag "version" do { 


        }

        if(arg.at(1) != "-") then {
            a.inFiles.push(arg)
        }
    }
}

// Abstracts the looping function above.
method forArgs(args : List<String>) do(block) is confidential {
    var i := 2
    var ran := false
    def size = args.size

    def on = object {
        method option(name : String) shortHand(sh : String) do(block') {
            def arg = args.at(i)
            if((arg == "--{name}") || (arg == "-{sh}")) then {
                if(args.size == i) then {
                    Exception.raise "Missing value for option {name}"
                }

                i := i + 1
                block'.apply(args.at(i))
                ran := true
            }
        }

        method option(name : String) do(block') {
            option(name) shortHand("") do(block')
        }

        method flag(name : String) shortHand(sh : String) do(block') {
            def arg = args.at(i)
            if((arg == "--{name}") || (arg == "-{sh}")) then {
                block.apply
                ran := true
            }
        }

        method flag(name : String) do(block') {
            flag(name) shortHand("") do(block')
        }
    }

    while { i < size } do {
        def arg = args.at(i)

        ran := false
        block.apply(arg, on)

        if((arg.at(1) == "-") && ran.not) then {
            Exception.raise("Unrecognised argument {arg}")
        }

        i := i + 1
    }
}

//def rg = arguments.new
//var t:= rg.parseArgs(["-h","-t","c","-o","of","-v"])