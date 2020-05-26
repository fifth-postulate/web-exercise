:- module(server,
          [ go/0
          ]).

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/html_write)).
:- use_module('prolog/todos').

go :-
    server(8636).

server(Port) :-
    http_server(http_dispatch, [port(Port)]).

:- http_handler(/, todo, []).

todo(_Request) :-
    findall(TodoItem, to_do(TodoItem), TodoItems),
    reply_html_page(
       [title('Prolog TODO exercise')],
       [h1('TODO'),
        ul([\todo_list(TodoItems)])]).

todo_list([]) -->
    html([]).
todo_list([Item|Rest]) -->
    html(li([Item])),
    todo_list(Rest).
   