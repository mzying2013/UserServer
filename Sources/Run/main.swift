import App




var arguments = CommandLine.arguments
arguments.append(contentsOf: ["--hostname","127.0.0.1","--port","8181"])

try app(.detect(arguments: arguments)).run()
