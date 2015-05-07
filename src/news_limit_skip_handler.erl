-module(news_limit_skip_handler).
-author("chanakyam@koderoom.com").

-export([init/3]).

-export([content_types_provided/2]).
-export([welcome/2]).
-export([terminate/3]).

%% Init
init(_Transport, _Req, []) ->
	{upgrade, protocol, cowboy_rest}.

%% Callbacks
content_types_provided(Req, State) ->
	{[		
		{<<"application/json">>, welcome}	
	], Req, State}.

terminate(_Reason, _Req, _State) ->
	ok.

%% API
welcome(Req, State) ->
	{Skip, _ } = cowboy_req:qs_val(<<"skip">>, Req),
	{Limit, _ } = cowboy_req:qs_val(<<"limit">>, Req),
	
	Url = showbiz_util:more_news_limit_skip(binary_to_list(Limit), binary_to_list(Skip)),
	% io:format("news_limit_skip ~p ~n ",[Url]),
	{ok, "200", _, Response} = ibrowse:send_req(Url,[],get,[],[]),
	Res = string:sub_string(Response, 1, string:len(Response) -1 ),
	Body = list_to_binary(Res),
	{Body, Req, State}. 



