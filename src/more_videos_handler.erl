-module(more_videos_handler).
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
	% SkipItems = (PageNum-1) * ?NEWS_PER_PAGE,
	% {CategoryBinary, _} = cowboy_req:qs_val(<<"c">>, Req),
	% Category = binary_to_list(CategoryBinary),

	Url = "http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=3&format=long",
	% io:format("movies url: ~p~n",[Url]),
	{ok, "200", _, Response_mlb} = ibrowse:send_req(Url,[],get,[],[]),
	ResponseParams_mlb = jsx:decode(list_to_binary(Response_mlb)),	
	[Params] = proplists:get_value(<<"articles">>, ResponseParams_mlb),

	% Url_all_news = string:concat("http://api.contentapi.ws/videos?channel=movies&limit=16&skip=",integer_to_list(SkipItems)),
	Url_all_news = "http://api.contentapi.ws/videos?channel=world_news&limit=10&skip=0",	
	{ok, "200", _, Response} = ibrowse:send_req(Url_all_news,[],get,[],[]),
	ResponseParams = jsx:decode(list_to_binary(Response)),	
	ParamsAllNews = proplists:get_value(<<"articles">>, ResponseParams),

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

	% Latest_News_Url = "http://api.contentapi.ws/news?channel=entertainment_film&skip=0&format=short&limit=4",
	Latest_News_Url = "http://contentapi.ws:5984/contentapi_text_maxcdn/_design/yb_entertainment_film/_view/by_id_title_desc_thumb_date?descending=true&limit=12",
	{ok, "200", _, Response_Latest_News} = ibrowse:send_req(Latest_News_Url,[],get,[],[]),
	ResponseParams_Latest_News = jsx:decode(list_to_binary(Response_Latest_News)),	
	LatestNewsParams = proplists:get_value(<<"rows">>, ResponseParams_Latest_News),

	{ok, Body} = more_videos_dtl:render([{<<"videoParam">>,Params},{<<"allnews">>,ParamsAllNews},{<<"music">>,MusicParams},{<<"latestnews">>,LatestNewsParams}]),
    {Body, Req, State}.



