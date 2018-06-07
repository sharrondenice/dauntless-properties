(function() {
	'use strict';


	angular.module('proApp.properties')
        .controller('PropertiesCtrl', PropertiesController)
	;

    var current_record = -1;

    PropertiesController.$inject = ['$scope', '$sce', '$state', '$rootScope', '__env', '$injector', '$modal', 'SweetAlert', 'tspCookies', 'tspArray', 'tspDataPreloader', 'tspResourceHelper', 'tspRestService', 'tspSerialize', 'tspGrouper', 'tspUploader', '$stateParams'];
    function PropertiesController ($scope, $sce, $state, $rootScope, __env, $injector, $modal, SweetAlert, tspCookies, tspArray, tspDataPreloader, tspResourceHelper, tspRestService, tspSerialize, tspGrouper, tspUploader, $stateParams) {

        $scope.postdata = {}; // we will store all of our form data in this object
        $scope.metadata = {}; // we will store all of our form data in this object
        $scope.optiondata = {}; // we will store all of our form optiondata in this object

        $scope.records = [];
        $scope.show_headers = true;
        $scope.headers = [
            {skipped: false, title: '',                 key: '',                        type: 'select',     sort: false, width: '1%'},
            {skipped: false, title: '',                 key: '',                        type: 'action',     sort: false, width: '1%'},
            {skipped: false, title: '',                 key: '',                        type: 'default',    sort: false, width: '10%'},
            {skipped: false, title: '',                 key: 'image',                   type: 'default',    sort: false, width: '12%'},
            {skipped: false, title: 'Description',      key: 'title',                   type: 'default',    sort: true,  width: ''},
            {skipped: false, title: 'Availability',     key: 'start_time',              type: 'default',    sort: true,  width: '20%'}
        ];

        // start state params
        $scope.title = $scope.lang.objects.properties.title;
        $scope.object = $scope.lang.objects.properties.object;
        $scope.objects = $scope.lang.objects.properties.objects;
        $scope.action = $scope.lang.objects.properties.action;
        $scope.type = $scope.lang.objects.properties.type;
        $scope.route = $scope.lang.objects.properties.route;
        $scope.routes = $scope.lang.objects.properties.routes;
        $scope.instructions = $scope.lang.objects.properties.instructions;
        // end state params

        $scope.createEmptyRecord = function(){
            $rootScope.loadingData = tspDataPreloader.show();

            var result = tspRestService.query({object: 'property', action: 'empty', id: 0}, tspSerialize.data({
                user_id: tspCookies.get('user_id'),
                lang_code: $scope.app.locale.lang_code,
                current_company_id: tspCookies.get('preferences.current_company_id')
            }));
            tspResourceHelper.process(result,  false,
                function(data){
                    $scope.postdata = data;
                    $rootScope.loadingData = tspDataPreloader.hide();
                },
                function(){
                    $scope.postdata = null;
                    $rootScope.loadingData = tspDataPreloader.hide();
                }
            );
        }
        $scope.loadOptionData = function(){
        }
        $scope.loadMetaData = function(){
            $scope.loadOptionData();
        }

        // Used by forms to retrieve and/or submit data to server
        $scope.update = function(){

            if ((__env.debug && __env.verbose))
            {
                console.log('Sending data...');
                console.log($scope.postdata);
            }

            $scope.submitButtonText = $scope.lang.labels.buttons.delay;

            var result = tspRestService.query({object: 'property', action: 'update'}, tspSerialize.data($scope.postdata, true));
            tspResourceHelper.process(result, true,
                function(data){

                    if ((__env.debug && __env.verbose))
                    {
                        console.log('Property Updated...');
                        console.log(data);
                    }

                    // if ID set redirect to show new property
                    if (data._id !== undefined && data._id !== null)
                    {
                        $rootScope.loadingDataText = $scope.lang.sentences.update_property;
                        $rootScope.loadingData = tspDataPreloader.show();
                        $rootScope.loadingData = tspDataPreloader.hide(true);
                        location.reload();
                    }
                    else
                    {
                    }
                },
                function(){
                    $scope.submitButtonText = $scope.lang.labels.buttons.validate_create;
                }
            );
        }
        $scope.create = function(){

            if ((__env.debug && __env.verbose))
            {
                console.log('Sending data...');
                console.log($scope.postdata);
            }

            $scope.submitButtonText = $scope.lang.labels.buttons.delay;

            var result = tspRestService.query({object: 'property', action: 'create'}, tspSerialize.data($scope.postdata, true));
            tspResourceHelper.process(result, true,
                function(data){

                    if ((__env.debug && __env.verbose))
                    {
                        console.log('Property Created...');
                        console.log(data);
                    }

                    // if ID set redirect to show new property
                    if (data._id !== undefined && data._id !== null)
                    {
                        $rootScope.loadingDataText = $scope.lang.sentences.register_property;
                        $rootScope.loadingData = tspDataPreloader.show();
                        $rootScope.loadingData = tspDataPreloader.hide(true);
                        location.reload();
                    }
                    else
                    {
                    }

                },
                function(){
                    $scope.submitButtonText = $scope.lang.labels.buttons.validate_create;
                }
            );
        }
        $scope.load = function(){
            if ((__env.debug && __env.verbose))
                console.log('Loading ' + $scope.object + ' Data...');

            $rootScope.loadingData = tspDataPreloader.show();

            var result = tspRestService.query({object: 'property', action: 'list', id: 0}, tspSerialize.data({
                user_id: tspCookies.get('user_id'),
                lang_code: $scope.app.locale.lang_code,
                current_company_id: tspCookies.get('preferences.current_company_id')
            }));
            tspResourceHelper.process(result,  false,
                function(data){
                    $scope.postdata = data;
                    //$scope.postdata = tspArray.pad(data, 100);

                    // init
                    $rootScope.initWizard($scope.postdata);

                    if (current_record != -1)
                        $rootScope.quickView($scope.type, -1, current_record);

                    $rootScope.loadingData = tspDataPreloader.hide();
                },
                function(){
                    $scope.postdata = null;
                    $scope.records = [];

                    $rootScope.initWizard([]);

                    $rootScope.loadingData = tspDataPreloader.hide();
                }
            );
        }

        // Required by All controllers that use DataWizardController
        $rootScope.$on('load.' + $state.current.name, function(event, data){
            $scope.load();
        });
        $rootScope.$on('view.' + $state.current.name, function(event, data){
            $scope.postdata = data;
            $scope.loadMetaData();
        });
        $rootScope.$on('create.' + $state.current.name, function(event, data){
            $scope.createEmptyRecord();
            $scope.loadOptionData();
        });
        $rootScope.$on('records.' + $state.current.name, function(event, data){
            if (data.length == 0)
                $scope.postdata = {}; // Empty records for bad search
           $scope.records = data;
        });

        $scope.load();
    }

})();

