(function() {
    'use strict';

    var env = {};

    // Import variables if present (from env.js)
    if(window){
        Object.assign(env, window.__env);
    }

    var module = angular.module('proApp.core', [
        'ngSanitize',
        'ui.router',
        'ui.bootstrap',
        'ui.select',
        'ngAnimate',
        'ngStorage',
        'textAngular',
        'angular.filter',
        'moment-picker',
        'FBAngular' // full screen
    ]);

    module.constant('__env', env);

    // route provider
    appConfig.$inject = ['__env', '$stateProvider', '$urlRouterProvider', 'momentPickerProvider'];
    function appConfig(__env, $stateProvider, $urlRouterProvider, momentPickerProvider) {

        var data = localStorage.getItem(__env.cookie_prefix + '.settings');
        var settings = {};

        if (data !== undefined && data !== null)
        {
            data = JSON.parse(data);
            angular.forEach(data, function(pvalue, pkey){
                if (pvalue == "true")
                    pvalue = true;
                else if (pvalue == "false")
                    pvalue = false;

                settings[pkey] = pvalue;
            });
        }

        // Configure the date picker for the app
        momentPickerProvider.options({
            locale: settings['lang_code'] ? settings['lang_code'] : 'en',
            format: settings['date_format'] ? settings['date_format']  : 'MM/DD/YYYY',
            keyboard: true,
            setOnSelect: true,
            hoursFormat: settings['hours_format'] ? settings['hours_format'] : 'hh:[00]',
            minutesStep: settings['mins_interval'] ? parseInt(settings['mins_interval']) : 30,
        });

        // Configure default routing for the app
        $stateProvider
            .state('app', {
                url: '/app',
                abstract: true,
                templateUrl: 'app/modules/core/templates/app.html'
            })
            .state('logout', {
                url: '/logout',
                controller: 'LogoutCtrl',
                templateUrl: 'app/modules/core/templates/blank.html'
            });

        $urlRouterProvider.otherwise(function ($injector) {

            if ((__env.debug && __env.verbose))
                console.log('At Route Config...');

            // check to see if this is a new installation
            // if it is begin install process, if not go to the default page
            var installed = localStorage.getItem(__env.cookie_prefix + '.installed');
            var $state = $injector.get('$state');

            // if installed attempt to display the dashboard
            if (installed == "true" || installed == true)
            {
                $state.go('app.properties');
            }
            else // else go to the install screen
            {
                $state.go('install');
            }
        });
    }

    module.config(appConfig);
})();
