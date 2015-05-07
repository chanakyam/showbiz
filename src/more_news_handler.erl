-module(more_news_handler).
-include("includes.hrl").
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
	% {PageBinary, _} = cowboy_req:qs_val(<<"p">>, Req),
	% PageNum = list_to_integer(binary_to_list(PageBinary)),
	% SkipItems = (PageNum-1) * ?LATEST_NEWS_PER_PAGE,
	% {CategoryBinary, _} = cowboy_req:qs_val(<<"c">>, Req),
	% Category = binary_to_list(CategoryBinary),
	Url = "http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=4&format=long",
	% io:format("movies url: ~p~n",[Url]),
	{ok, "200", _, Response_mlb} = ibrowse:send_req(Url,[],get,[],[]),
	ResponseParams_mlb = jsx:decode(list_to_binary(Response_mlb)),	
	[Params] = proplists:get_value(<<"articles">>, ResponseParams_mlb),

	% Url_all_news = string:concat("http://api.contentapi.ws/news?channel=entertainment_film&limit=12&skip=",integer_to_list(SkipItems)),
	% Url_all_news = "http://api.contentapi.ws/news?channel=entertainment_film&limit=12&skip=0",
	Url_all_news = "http://contentapi.ws:5984/contentapi_text_maxcdn/_design/yb_entertainment_film/_view/full_composite_article?descending=true&limit=12",
	
	{ok, "200", _, Response} = ibrowse:send_req(Url_all_news,[],get,[],[]),
	ResponseParams = jsx:decode(list_to_binary(Response)),	
	ParamsAllNews = proplists:get_value(<<"rows">>, ResponseParams),

	% Gallery_Url = "http://api.contentapi.ws/news?channel=image_galleries&limit=4&skip=0&format=short",
	% % io:format("gallery url: ~p~n",[Gallery_Url]),
	% {ok, "200", _, Response_Gallery} = ibrowse:send_req(Gallery_Url,[],get,[],[]),
	% ResponseParams_Gallery = jsx:decode(list_to_binary(Response_Gallery)),	
	% GalleryParams = proplists:get_value(<<"articles">>, ResponseParams_Gallery),

	% Music_Url = "http://api.contentapi.ws/news?channel=entertainment_music&limit=4&skip=0&format=short",
	Music_Url = "http://contentapi.ws:5984/contentapi_text_maxcdn/_design/yb_entertainment_music/_view/long?descending=true&limit=4&skip=0",
	% io:format("gallery url: ~p~n",[Gallery_Url]),
	{ok, "200", _, Response_Music} = ibrowse:send_req(Music_Url,[],get,[],[]),
	ResponseParams_Music = jsx:decode(list_to_binary(Response_Music)),	
	MusicParams = proplists:get_value(<<"rows">>, ResponseParams_Music),

	Popular_Videos_Url = "http://api.contentapi.ws/videos?channel=world_news&skip=3&format=short&limit=10",
	% io:format("movies url: ~p~n",[Url]),
	{ok, "200", _, Response_Popular_Videos} = ibrowse:send_req(Popular_Videos_Url,[],get,[],[]),
	ResponseParams_Popular_Videos = jsx:decode(list_to_binary(Response_Popular_Videos)),	
	PopularVideosParams = proplists:get_value(<<"articles">>, ResponseParams_Popular_Videos),

	{ok, Body} = more_news_dtl:render([{<<"videoParam">>,Params},{<<"allnews">>,ParamsAllNews},{<<"music">>,MusicParams},{<<"popularvideos">>,PopularVideosParams}]),
    {Body, Req, State}.



