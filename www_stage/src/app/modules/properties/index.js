(function() {
    'use strict';

    var module = angular.module('proApp.properties', [
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
            .state('app.properties', {
                url: '/properties',
                templateUrl: 'app/modules/core/templates/property-wizard-viewer.html',
                controller: 'PropertiesCtrl'
            });
    }

    module.config(appConfig);
})();