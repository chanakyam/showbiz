var app = angular.module('showbiz', ['ui.bootstrap']);

app.factory('ShowbizHomePageService', function ($http) {
	return {		

		getChannelPictures: function (category, count, skip) {
			return $http.get('/api/latestnews/channel?c=' + category + '&l=' + count + '&skip=' + skip).then(function (result) {
				// return result.data.rows;
				return result.data.articles;
			});
		},		
		getImages: function (category, count, skip) {
			return $http.get('/api/imageGallery/channel?c=' + category + '&l=' + count + '&skip=' + skip).then(function (result) {
				// return result.data.rows;
				return result.data.articles;
			});
		},
		getVideo: function (category, count, skip) {
			return $http.get('/api/videos/channel?c=' + category + '&l=' + count + '&skip=' + skip).then(function (result) {
				// return result.data.rows;
				return result.data.articles;
			});

		}		
	};
});

app.controller('ShowbizHome', function ($scope, ShowbizHomePageService) {
  //the clean and simple way
   $scope.latestVideos     = ShowbizHomePageService.getVideo('full_composite_article',3,0);
   $scope.popularVideos    = ShowbizHomePageService.getVideo('full_composite_article',6,3);
   $scope.latestNews 	   = ShowbizHomePageService.getChannelPictures('media_content',7,0);
   $scope.imageGallery     = ShowbizHomePageService.getImages('image_gallery_view',6,0);
   $scope.latestVideosData = ShowbizHomePageService.getVideo('full_composite_article',6,0);	
   $scope.currentYear 	   = (new Date).getFullYear();
});