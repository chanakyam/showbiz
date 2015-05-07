-module(tnc_page_handler).
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
		{<<"text/html">>, welcome}	
	], Req, State}.

terminate(_Reason, _Req, _State) ->
	ok.

%% API
welcome(Req, State) ->
	Url = "http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=8&format=long",
	% io:format("movies url: ~p~n",[Url]),
	{ok, "200", _, Response_mlb} = ibrowse:send_req(Url,[],get,[],[]),
	ResponseParams_mlb = jsx:decode(list_to_binary(Response_mlb)),	
	[Params] = proplists:get_value(<<"articles">>, ResponseParams_mlb),

	% Latest_News_Url = "http://api.contentapi.ws/news?channel=entertainment_film&skip=0&format=short&limit=4",
	Latest_News_Url = "http://contentapi.ws:5984/contentapi_text_maxcdn/_design/yb_entertainment_film/_view/by_id_title_desc_thumb_date?descending=true&limit=4",
	{ok, "200", _, Response_Latest_News} = ibrowse:send_req(Latest_News_Url,[],get,[],[]),
	ResponseParams_Latest_News = jsx:decode(list_to_binary(Response_Latest_News)),	
	LatestNewsParams = proplists:get_value(<<"rows">>, ResponseParams_Latest_News),

	Popular_Videos_Url = "http://api.contentapi.ws/videos?channel=world_news&skip=3&format=short&limit=4",
	% io:format("movies url: ~p~n",[Url]),
	{ok, "200", _, Response_Popular_Videos} = ibrowse:send_req(Popular_Videos_Url,[],get,[],[]),
	ResponseParams_Popular_Videos = jsx:decode(list_to_binary(Response_Popular_Videos)),	
	PopularVideosParams = proplists:get_value(<<"articles">>, ResponseParams_Popular_Videos),
		
	{ok, Body} = tnc_dtl:render([{<<"videoParam">>,Params},{<<"latestnews">>,LatestNewsParams},{<<"popularvideos">>,PopularVideosParams}]),
    {Body, Req, State}.