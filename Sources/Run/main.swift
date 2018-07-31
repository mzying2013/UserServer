import App


#if DEBUG
var arguments = CommandLine.arguments
arguments.append(contentsOf: ["--hostname","127.0.0.1","--port","8181"])

#else

try app(.detect()).run()

#endif


