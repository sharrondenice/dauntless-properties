(function() {
    'use strict';

    var module = angular.module('proApp.reservations', [
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
            .state('app.reservations', {
                url: '/reservations',
                templateUrl: 'app/modules/core/templates/data-wizard-viewer.html',
                controller: 'ReservationsCtrl'
            })
            .state('app.reservations-create', {
                url: '/reservations/:view/:property_id',
                templateUrl: 'app/modules/core/templates/data-wizard-viewer.html',
                controller: 'ReservationsCtrl'
            });
    }

    module.config(appConfig);
})();