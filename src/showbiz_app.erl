-module(showbiz_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
	Dispatch = cowboy_router:compile([
        {'_',[
                 {"/", home_page_handler, []},
                 {"/api/latestnews/channel", channel_latest_news_handler, []},
                 {"/api/imageGallery/channel", channel_gallery_handler, []},
                 % {"/api/latestinterviews/channel", channel_latestinterviews_handler, []},
                 % {"/api/latestinterviewslist/channel",channel_latestinterviews_list_handler,[]},
                 {"/music", photo_gallery_handler, []},
                 {"/api/videos/channel", feed_videos_handler, []},
                 {"/api/interviews/count", interviews_count_handler, []},
                 {"/termsandconditions", tnc_page_handler, []},
                 {"/more", more_handler, []},
                 {"/video", video_handler, []},
                 {"/more_news", more_news_handler, []},
                 {"/more_videos", more_videos_handler, []},
                 {"/api/news/count", news_count_handler, []},
                 {"/api/videos/count", videos_count_handler, []},
                 {"/interviews/:id", interviews_handler, []},
                 {"/moreinterviews", all_interviews_handler, []},
                 {"/api/news/limit_skip", news_limit_skip_handler, []},                          

                
                           
                %%
                %% Release Routes
                %%
                {"/css/[...]", cowboy_static, {priv_dir, showbiz, "static/css"}},
                {"/images/[...]", cowboy_static, {priv_dir, showbiz, "static/images"}},
                {"/js/[...]", cowboy_static, {priv_dir, showbiz, "static/js"}},
                {"/fonts/[...]", cowboy_static, {priv_dir, showbiz, "static/fonts"}}
                % %%
                %% Dev Routes
                %%
                 % {"/css/[...]", cowboy_static, {dir, "priv/static/css"}},
                 % {"/images/[...]", cowboy_static, {dir, "priv/static/images"}},
                 % {"/js/[...]", cowboy_static, {dir,"priv/static/js"}},
                 % {"/fonts/[...]", cowboy_static, {dir, "priv/static/fonts"}}
         ]}      
    ]),    

    {ok, _} = cowboy:start_http(http,100, [{port, 10003}],[{env, [{dispatch, Dispatch}]}
              ]),

    showbiz_sup:start_link().

stop(_State) ->
    ok.
