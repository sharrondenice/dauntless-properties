(function() {
    'use strict';

    var module = angular.module('proApp.users', [
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
            .state('app.contacts', {
                url: '/contacts',
                templateUrl: 'app/modules/core/templates/data-wizard-viewer.html',
                controller: 'UsersCtrl'
            })
            .state('app.contacts-professionals', {
                url: '/contacts/professionals',
                templateUrl: 'app/modules/core/templates/data-wizard-viewer.html',
                controller: 'UsersCtrl'
            })
            .state('app.contacts-clients', {
                url: '/contacts/clients',
                templateUrl: 'app/modules/core/templates/data-wizard-viewer.html',
                controller: 'UsersCtrl'
            })
            .state('app.contacts-colleagues', {
                url: '/contacts/colleagues',
                templateUrl: 'app/modules/core/templates/data-wizard-viewer.html',
                controller: 'UsersCtrl'
            })
            .state('app.contacts-assistants', {
                url: '/contacts/assistants',
                templateUrl: 'app/modules/core/templates/data-wizard-viewer.html',
                controller: 'UsersCtrl'
            })
            .state('app.contacts-resources', {
                url: '/contacts/resources',
                templateUrl: 'app/modules/core/templates/data-wizard-viewer.html',
                controller: 'UsersCtrl'
            })
            .state('app.contacts-prospects', {
                url: '/contacts/prospects',
                templateUrl: 'app/modules/core/templates/data-wizard-viewer.html',
                controller: 'UsersCtrl'
            })
            .state('app.contacts-vendors', {
                url: '/contacts/vendors',
                templateUrl: 'app/modules/core/templates/data-wizard-viewer.html',
                controller: 'UsersCtrl'
            })
            .state('app.contacts-stakeholders', {
                url: '/contacts/stakeholders',
                templateUrl: 'app/modules/core/templates/data-wizard-viewer.html',
                controller: 'UsersCtrl'
            })
            .state('app.contacts-developers', {
                url: '/contacts/developers',
                templateUrl: 'app/modules/core/templates/data-wizard-viewer.html',
                controller: 'UsersCtrl'
            })
            .state('app.contacts-qas', {
                url: '/contacts/qas',
                templateUrl: 'app/modules/core/templates/data-wizard-viewer.html',
                controller: 'UsersCtrl'
            })
            .state('app.contacts-testers', {
                url: '/contacts/testers',
                templateUrl: 'app/modules/core/templates/data-wizard-viewer.html',
                controller: 'UsersCtrl'
            })
            .state('app.contacts-pos', {
                url: '/contacts/pos',
                templateUrl: 'app/modules/core/templates/data-wizard-viewer.html',
                controller: 'UsersCtrl'
            })
            .state('app.contacts-masters', {
                url: '/contacts/masters',
                templateUrl: 'app/modules/core/templates/data-wizard-viewer.html',
                controller: 'UsersCtrl'
            })
            .state('app.contacts-managers', {
                url: '/contacts/managers',
                templateUrl: 'app/modules/core/templates/data-wizard-viewer.html',
                controller: 'UsersCtrl'
            })
            .state('app.contacts-contractors', {
                url: '/contacts/contractors',
                templateUrl: 'app/modules/core/templates/data-wizard-viewer.html',
                controller: 'UsersCtrl'
            });
    }

    module.config(appConfig);
})();