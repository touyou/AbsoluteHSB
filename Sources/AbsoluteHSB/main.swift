import AbsoluteHSBKit

let arguments = CommandLine.arguments

guard let subcommand = arguments.dropFirst().first else {
    fatalError("Error: Indeclear arguments")
}

let path = arguments.dropFirst().dropFirst().first

switch subcommand {
case "help":
    let documents = """
    This is code converting tool. It changes UIColor initializer to HSB mode.

    $ [command] help: Dump this help
    $ [command] dump \\(path): Dump rewrote code
    $ [command] rewrite \\(path): Overwrite original code
    """
    print(documents)
case "dump":
    guard let path = path else {
        fatalError("Error: Indeclear file path")
    }

    let target = Target(path: path)
    let result = try target.detect()
    print(result)
case "rewrite":
    guard let path = path else {
        fatalError("Error: Indeclear file path")
    }

    let target = Target(path: path)
    try target.rewrite()
default:
    fatalError("Error: Indeclear arguments")
}

