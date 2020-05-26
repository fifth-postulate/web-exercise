:- module(server,
          [ go/0
          ]).

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).

go :-
    server(8636).

server(Port) :-
    http_server(http_dispatch, [port(Port)]).

:- http_handler(/, hello, []).

hello(_Request) :-
    format('Content-type: text/plain~n~n'),
    format('Hello World!~n').