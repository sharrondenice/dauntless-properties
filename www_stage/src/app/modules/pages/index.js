(function() {
    'use strict';

    var module = angular.module('proApp.pages', [
        'ngSanitize',
        'ui.router',
        'ui.bootstrap',
        'ui.select',
        'ngAnimate',
        'ngStorage',
        'textAngular',
        'angular.filter'
    ]);

    appConfig.$inject = ['$stateProvider', '$urlRouterProvider'];
    function appConfig($stateProvider, $urlRouterProvider) {
        $stateProvider
            .state('install', {
                url: '/install',
                templateUrl: 'app/modules/pages/templates/install.html',
                controller: 'InstallCtrl'
            })
            .state('404', {
                url: '/404',
                templateUrl: 'app/modules/pages/templates/404.html'
            })
            .state('forgot-pass', {
                url: '/forgot-pass',
                templateUrl: 'app/modules/pages/templates/forgot-pass.html'
            })
            .state('lock-screen', {
                url: '/lock-screen',
                templateUrl: 'app/modules/pages/templates/lock-screen.html'
            })
            .state('login', {
                url: '/login',
                controller: 'LoginCtrl',
                templateUrl: 'app/modules/pages/templates/login.html'
            })
            .state('register', {
                url: '/register',
                controller: 'RegisterCtrl',
                templateUrl: 'app/modules/pages/templates/register.html'
            });
    }

    module.config(appConfig);
})();