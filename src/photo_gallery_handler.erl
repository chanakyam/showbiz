-module(photo_gallery_handler).

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
 	% {CategoryBinary, _} = cowboy_req:qs_val(<<"c">>, Req),
 	% Category = binary_to_list(CategoryBinary),
 	
	Url = "http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=5&format=long",
	% io:format("movies url: ~p~n",[Url]),
	{ok, "200", _, Response_mlb} = ibrowse:send_req(Url,[],get,[],[]),
	ResponseParams_mlb = jsx:decode(list_to_binary(Response_mlb)),	
	[Params] = proplists:get_value(<<"articles">>, ResponseParams_mlb),	

	% Url_all_news = "http://api.contentapi.ws/news?channel=entertainment_music&limit=16&skip=0",
	Url_all_news = "http://contentapi.ws:5984/contentapi_text_maxcdn/_design/yb_entertainment_music/_view/long?descending=true&limit=16&skip=0",
	{ok, "200", _, Response} = ibrowse:send_req(Url_all_news,[],get,[],[]),
	ResponseParams = jsx:decode(list_to_binary(Response)),	
	ParamsAllNews = proplists:get_value(<<"rows">>, ResponseParams),

	% Latest_News_Url = "http://api.contentapi.ws/news?channel=entertainment_film&skip=0&format=short&limit=4",
	Latest_News_Url = "http://contentapi.ws:5984/contentapi_text_maxcdn/_design/yb_entertainment_film/_view/full_composite_article?descending=true&limit=4",
	{ok, "200", _, Response_Latest_News} = ibrowse:send_req(Latest_News_Url,[],get,[],[]),
	ResponseParams_Latest_News = jsx:decode(list_to_binary(Response_Latest_News)),	
	LatestNewsParams = proplists:get_value(<<"rows">>, ResponseParams_Latest_News),

	Popular_Videos_Url = "http://api.contentapi.ws/videos?channel=world_news&skip=3&format=short&limit=12",
	% io:format("movies url: ~p~n",[Url]),
	{ok, "200", _, Response_Popular_Videos} = ibrowse:send_req(Popular_Videos_Url,[],get,[],[]),
	ResponseParams_Popular_Videos = jsx:decode(list_to_binary(Response_Popular_Videos)),	
	PopularVideosParams = proplists:get_value(<<"articles">>, ResponseParams_Popular_Videos),
 	
 	{ok, Body} = photo_gallery_dtl:render([{<<"videoParam">>,Params},{<<"allnews">>,ParamsAllNews},{<<"latestnews">>,LatestNewsParams},{<<"popularvideos">>,PopularVideosParams}]),
 		{Body, Req, State}.	