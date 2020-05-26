:- module(server,
          [ go/0
          ]).

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/html_write)).

go :-
    server(8636).

server(Port) :-
    http_server(http_dispatch, [port(Port)]).

:- http_handler(/, todo, []).

todo(_Request) :-
    reply_html_page(
       [title('Prolog TODO exercise')],
       [h1('TODO'),
        ul([li(['Prolog Web Exercise']),
            li(['Class assignment'])])]).
   