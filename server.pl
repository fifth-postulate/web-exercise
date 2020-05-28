:- module(server,
          [ go/0
          ]).

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_parameters)).
:- use_module('prolog/todos').

go :-
    server(8636).

server(Port) :-
    http_server(http_dispatch, [port(Port)]).

:- http_handler(/, todo, []).
:- http_handler(root('todo'), post_todo, [methods([post])]).

todo(_Request) :-
    findall(TodoItem, to_do(TodoItem), TodoItems),
    reply_html_page(
       [title('Prolog TODO exercise')],
       [h1('TODO'),
        \todo_entry,
        ul([\todo_list(TodoItems)])]).

todo_entry -->
    html(form([method(post), action(todo)], [
        input([input(text), name('fresh_todo')], []),
        button([type(submit)], ['todo'])
    ])).

todo_list([]) -->
    html([]).
todo_list([Item|Rest]) -->
    html(li([Item])),
    todo_list(Rest).

post_todo(Request) :-
    http_parameters(Request, [fresh_todo(TODO, [string])]),
    assert(to_do(TODO)),
    todo(Request).
