:- module(server,
          [ go/0
          ]).

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_files)).
:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).
:- use_module('prolog/todos').

go :-
    server(8636).

server(Port) :-
    http_server(http_dispatch, [port(Port)]).

http:location(assets, '/static', []).
user:file_search_path(static_files, web).

:- http_handler(/, todo, []).
:- http_handler(root(todo), add_todo, [methods([post])]).
:- http_handler(root(remove), remove_todo, [methods([post])]).
:- http_handler(assets('.'), serve_files, [prefix]).

todo(_Request) :-
    findall(TodoItem, to_do(TodoItem), TodoItems),
    reply_html_page(
       [title('Prolog TODO exercise')],
       [h1('TODO'),
        \html_requires(stylesheets),
        \todo_entry,
        ul([\todo_list(TodoItems)])]).

todo_entry -->
    html(form([method(post), action(todo)], [
        input([type(text), name('fresh_todo')], []),
        button([type(submit)], ['todo'])
    ])).

todo_list([]) -->
    html([]).
todo_list([Item|Rest]) -->
    html(li([\remove_item(Item)])),
    todo_list(Rest).

remove_item(Item) -->
    html(form([method(post), action(remove)], [
        input([type(hidden), name('stale_todo'), value(Item)], []),
        Item,
        button([type(submit)], ['⛌'])
    ])).

add_todo(Request) :-
    http_parameters(Request, [fresh_todo(TODO, [string])]),
    assert(to_do(TODO)),
    todo(Request).

remove_todo(Request) :-
    http_parameters(Request, [stale_todo(TODO, [string])]),
    retractall(to_do(TODO)),
    todo(Request).

serve_files(Request) :-
    http_reply_from_files(static_files('.'), [], Request).
serve_files(Request) :-
    http_404([], Request).

:- html_resource(stylesheets, [virtual(true), requires([assets('basic.css')])]).