(function() {
	'use strict';


	angular.module('proApp.users')
        .controller('UsersCtrl', UsersController)
        .controller('UsersRecordsCtrl', UsersRecordsController)
        .controller('PageProfileCtrl', PageProfileController)
	;

    var current_record = -1;

    UsersController.$inject = ['$scope', '$sce', '$state', '$rootScope', '__env', '$injector', '$modal', 'SweetAlert', 'tspCookies', 'tspArray', 'tspDataPreloader', 'tspResourceHelper', 'tspRestService', 'tspSerialize', 'tspGrouper', 'tspUploader', '$stateParams'];
    function UsersController ($scope, $sce, $state, $rootScope, __env, $injector, $modal, SweetAlert, tspCookies, tspArray, tspDataPreloader, tspResourceHelper, tspRestService, tspSerialize, tspGrouper, tspUploader, $stateParams) {

        $scope.postdata = {}; // we will store all of our form data in this object
        $scope.metadata = {}; // we will store all of our form data in this object
        $scope.optiondata = {}; // we will store all of our form optiondata in this object

        $scope.records = [];
        $scope.show_headers = true;
        $scope.headers = [
            {skipped: false, title: '',             key: '',                type: 'select',     sort: false,   width: '1%'},
            {skipped: false, title: '',             key: '',                type: 'action',     sort: false,   width: '1%'},
            {skipped: false, title: 'Status',       key: 'status.title',    type: 'default',    sort: true,    width: '10%'},
            {skipped: false, title: 'Type',         key: 'type.title',      type: 'default',    sort: true,    width: '11%'},
            {skipped: false, title: 'Name',         key: 'title',           type: 'default',    sort: true,    width: ''},
            {skipped: false, title: 'Company',      key: 'company.title',   type: 'default',    sort: true,    width: ''},
            {skipped: false, title: 'Responsible',  key: 'parent.title',    type: 'default',    sort: true,    width: ''},
        ];

        var state = $state.current.name.replace("app.contacts-", "");
        state = state.replace("app.", "");

        // start state params
        $scope.title = $scope.lang.objects.users[state].title;
        $scope.object = $scope.lang.objects.users[state].object;
        $scope.objects = $scope.lang.objects.users[state].objects;
        $scope.action = $scope.lang.objects.users[state].action;
        $scope.type = $scope.lang.objects.users[state].type;
        $scope.route = $scope.lang.objects.users[state].route;
        $scope.routes = $scope.lang.objects.users[state].routes;
        $scope.instructions = $scope.lang.objects.users[state].instructions;
        // end state params

        // Helper methods
        $scope.createEmptyRecord = function(){
            $rootScope.loadingData = tspDataPreloader.show();

            var result = tspRestService.query({object: 'new', action: 'user', id: 0}, tspSerialize.data({
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
            $rootScope.loadingData = tspDataPreloader.show();

            var result = tspRestService.query({object: 'demo', action: 'companies', id: 0}, tspSerialize.data({
                user_id: tspCookies.get('user_id'),
                lang_code: $scope.app.locale.lang_code,
                current_company_id: tspCookies.get('preferences.current_company_id')
            }));
            tspResourceHelper.process(result,  false,
                function(data){
                    $scope.optiondata.companies = data;
                    $rootScope.loadingData = tspDataPreloader.hide();
                },
                function(){
                    $scope.optiondata.companies = [];
                    $rootScope.loadingData = tspDataPreloader.hide();
                }
            );

            var result = tspRestService.query({object: 'demo', action: 'professions', id: 0}, tspSerialize.data({
                user_id: tspCookies.get('user_id'),
                lang_code: $scope.app.locale.lang_code,
                current_company_id: tspCookies.get('preferences.current_company_id')
            }));
            tspResourceHelper.process(result,  false,
                function(data){
                    $scope.optiondata.professions = data;
                    $rootScope.loadingData = tspDataPreloader.hide();
                },
                function(){
                    $scope.optiondata.professions = [];
                    $rootScope.loadingData = tspDataPreloader.hide();
                }
            );
        }
        $scope.loadMetaData = function(){
            $scope.loadOptionData();

            $rootScope.loadingData = tspDataPreloader.show();

            var result = tspRestService.query({object: 'demo', action: 'projects', id: 0}, tspSerialize.data({
                user_id: tspCookies.get('user_id'),
                other_id: $scope.postdata._id,
                other_id_key: 'client_user_id',
                lang_code: $scope.app.locale.lang_code,
                current_company_id: tspCookies.get('preferences.current_company_id')
            }));
            tspResourceHelper.process(result,  false,
                function(data){
                    $scope.metadata.projects = data;
                    $rootScope.$emit('records-load.app.projects', $scope.metadata.projects);

                    $rootScope.loadingData = tspDataPreloader.hide();
                },
                function(){
                    $scope.metadata.projects = [];
                    $rootScope.$emit('records-load.app.projects', $scope.metadata.projects);

                    $rootScope.loadingData = tspDataPreloader.hide();
                }
            );

            var result = tspRestService.query({object: 'demo', action: 'projects_work', id: 0}, tspSerialize.data({
                user_id: tspCookies.get('user_id'),
                other_id: $scope.postdata._id,
                other_id_key: 'responsible_user_id',
                lang_code: $scope.app.locale.lang_code,
                current_company_id: tspCookies.get('preferences.current_company_id')
            }));
            tspResourceHelper.process(result,  false,
                function(data){
                    $scope.metadata.work = data;
                    $rootScope.$emit('records-load.app.work', $scope.metadata.work);

                    $rootScope.loadingData = tspDataPreloader.hide();
                },
                function(){
                    $scope.metadata.work = [];
                    $rootScope.$emit('records-load.app.work', $scope.metadata.work);

                    $rootScope.loadingData = tspDataPreloader.hide();
                }
            );

            var result = tspRestService.query({object: 'demo', action: 'projects_activities', id: 0}, tspSerialize.data({
                user_id: tspCookies.get('user_id'),
                other_id: $scope.postdata._id,
                other_id_key: 'client_user_id',
                lang_code: $scope.app.locale.lang_code,
                current_company_id: tspCookies.get('preferences.current_company_id')
            }));
            tspResourceHelper.process(result,  false,
                function(data){
                    $scope.metadata.activities = data;
                    $rootScope.$emit('records-load.app.activities', $scope.metadata.activities);

                    $rootScope.loadingData = tspDataPreloader.hide();
                },
                function(){
                    $scope.metadata.activities = [];
                    $rootScope.$emit('records-load.app.activities', $scope.metadata.activities);

                    $rootScope.loadingData = tspDataPreloader.hide();
                }
            );

            var result = tspRestService.query({object: 'demo', action: 'projects_contracts', id: 0}, tspSerialize.data({
                user_id: tspCookies.get('user_id'),
                other_id: $scope.postdata._id,
                other_id_key: 'client_user_id',
                lang_code: $scope.app.locale.lang_code,
                current_company_id: tspCookies.get('preferences.current_company_id')
            }));
            tspResourceHelper.process(result,  false,
                function(data){
                    $scope.metadata.contracts = data;
                    $rootScope.$emit('records-load.app.contracts', $scope.metadata.contracts);

                    $rootScope.loadingData = tspDataPreloader.hide();
                },
                function(){
                    $scope.metadata.contracts = [];
                    $rootScope.$emit('records-load.app.contracts', $scope.metadata.contracts);

                    $rootScope.loadingData = tspDataPreloader.hide();
                }
            );

            var result = tspRestService.query({object: 'demo', action: 'projects_statements', id: 0}, tspSerialize.data({
                user_id: tspCookies.get('user_id'),
                type_id: 130,
                other_id: $scope.postdata._id,
                other_id_key: 'client_user_id',
                lang_code: $scope.app.locale.lang_code,
                current_company_id: tspCookies.get('preferences.current_company_id')
            }));
            tspResourceHelper.process(result,  false,
                function(data){
                    $scope.metadata.invoices = data;
                    $rootScope.$emit('records-load.app.invoices', $scope.metadata.invoices);

                    $rootScope.loadingData = tspDataPreloader.hide();
                },
                function(){
                    $scope.metadata.invoices = [];
                    $rootScope.$emit('records-load.app.invoices', $scope.metadata.invoices);

                    $rootScope.loadingData = tspDataPreloader.hide();
                }
            );

            var result = tspRestService.query({object: 'demo', action: 'projects_statements', id: 0}, tspSerialize.data({
                user_id: tspCookies.get('user_id'),
                type_id: 131,
                other_id: $scope.postdata._id,
                other_id_key: 'client_user_id',
                lang_code: $scope.app.locale.lang_code,
                current_company_id: tspCookies.get('preferences.current_company_id')
            }));
            tspResourceHelper.process(result,  false,
                function(data){
                    $scope.metadata.proposals = data;
                    $rootScope.$emit('records-load.app.proposals', $scope.metadata.proposals);

                    $rootScope.loadingData = tspDataPreloader.hide();
                },
                function(){
                    $scope.metadata.proposals = [];
                    $rootScope.$emit('records-load.app.proposals', $scope.metadata.proposals);

                    $rootScope.loadingData = tspDataPreloader.hide();
                }
            );

            var result = tspRestService.query({object: 'demo', action: 'system_activities', id: 0}, tspSerialize.data({
                user_id: tspCookies.get('user_id'),
                owner: 'U',
                owner_id: $scope.postdata._id,
                 lang_code: $scope.app.locale.lang_code,
                current_company_id: tspCookies.get('preferences.current_company_id')
            }));
            tspResourceHelper.process(result,  false,
                function(data){
                    $scope.metadata.activities = data;
                    $rootScope.$emit('records-load.app.activities', $scope.metadata.activities);

                    $rootScope.loadingData = tspDataPreloader.hide();
                },
                function(){
                    $scope.metadata.activities = [];
                    $rootScope.$emit('records-load.app.activities', $scope.metadata.activities);

                    $rootScope.loadingData = tspDataPreloader.hide();
                }
            );

            var result = tspRestService.query({object: 'demo', action: 'shared_comments', id: 0}, tspSerialize.data({
                user_id: tspCookies.get('user_id'),
                owner: 'U',
                owner_id: $scope.postdata._id,
                 lang_code: $scope.app.locale.lang_code,
                current_company_id: tspCookies.get('preferences.current_company_id')
            }));
            tspResourceHelper.process(result,  false,
                function(data){
                    $scope.metadata.comments = data;
                    $rootScope.$emit('records-load.app.comments', $scope.metadata.comments);

                    $rootScope.loadingData = tspDataPreloader.hide();
                },
                function(){
                    $scope.metadata.comments = [];
                    $rootScope.$emit('records-load.app.comments', $scope.metadata.comments);

                    $rootScope.loadingData = tspDataPreloader.hide();
                }
            );
        }
        $scope.professionGroup = function(item){
            return tspGrouper.main($scope.metadata.professions, item);
        };

        // Used by forms to retrieve and/or submit data to server
        $scope.update = function(){
            console.log($scope.postdata);
        }
        $scope.create = function(){
            console.log($scope.postdata);
        }
        $scope.load = function(){
            if ((__env.debug && __env.verbose))
                console.log('Loading ' + $scope.object + ' Data...');

            $rootScope.loadingData = tspDataPreloader.show();

            $scope.type_id = null;

            // @TODO: This logic should be on the server, NOT in the UI
            switch ($scope.type)
            {
                case 'professionals': $scope.type_id = 20; break;
                case 'clients': $scope.type_id = 21; break;
                case 'colleagues': $scope.type_id = 22; break;
                case 'assistants': $scope.type_id = 23; break;
                case 'resources': $scope.type_id = 24; break;
                case 'prospects': $scope.type_id = 25; break;
                case 'vendors': $scope.type_id = 26; break;
                case 'stakeholders': $scope.type_id = 27; break;
                case 'developers': $scope.type_id = 28; break;
                case 'qas': $scope.type_id = 29; break;
                case 'testers': $scope.type_id = 30; break;
                case 'pos': $scope.type_id = 31; break;
                case 'masters': $scope.type_id = 32; break;
                case 'managers': $scope.type_id = 33; break;
                case 'contractors': $scope.type_id = 34; break;
            }

            var result = tspRestService.query({object: 'demo', action: 'users', id: 0}, tspSerialize.data({
                user_id: tspCookies.get('user_id'),
                type_id: $scope.type_id,
                lang_code: $scope.app.locale.lang_code,
                current_company_id: tspCookies.get('preferences.current_company_id')
            }));
            tspResourceHelper.process(result,  false,
                function(data){
                    $scope.postdata = data;

                    //$scope.postdata = tspArray.pad(data, 25);

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

    UsersRecordsController.$inject = ['$scope', '$sce', '$state', '$rootScope', '__env', '$injector', '$modal', 'SweetAlert', 'tspCookies', 'tspArray', 'tspDataPreloader', 'tspResourceHelper', 'tspRestService', 'tspSerialize', 'tspGrouper', 'tspUploader', '$stateParams'];
    function UsersRecordsController ($scope, $sce, $state, $rootScope, __env, $injector, $modal, SweetAlert, tspCookies, tspArray, tspDataPreloader, tspResourceHelper, tspRestService, tspSerialize, tspGrouper, tspUploader, $stateParams) {

        $scope.type = 'users';

        $scope.records = [];
        $scope.show_headers = true;
        $scope.headers = [
            {skipped: true, title: '',             key: '',                type: 'select',     sort: false,   width: '1%'},
            {skipped: true, title: '',             key: '',                type: 'action',     sort: false,   width: '1%'},
            {skipped: false, title: 'Status',       key: 'status.title',    type: 'default',    sort: true,    width: '10%'},
            {skipped: false, title: 'Type',         key: 'type.title',      type: 'default',    sort: true,    width: '11%'},
            {skipped: false, title: 'Name',         key: 'title',           type: 'default',    sort: true,    width: ''},
            {skipped: false, title: 'Company',      key: 'company.title',   type: 'default',    sort: true,    width: ''},
            {skipped: false, title: 'Responsible',  key: 'parent.title',    type: 'default',    sort: true,    width: ''},
        ];

        $rootScope.$on('record-view.app.' + $scope.type, function(event, id){
            $state.go("app." + $scope.type).then(function(){
                current_record = id;
            });
        });
        $rootScope.$on('records-load.app.' + $scope.type, function(event, data){
            $scope.records = data;
        });
    }

    // profile page controller
    PageProfileController.$inject = ['$scope'];
    function PageProfileController($scope) {
        $scope.linedata = {
            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Nov', 'Dec'],
            series: [
                {
                    data: [50, 80, 100, 90, 120, 50, 80, 56, 135, 75, 148]
                }
            ]
        };

        $scope.lineopts = {
            axisY: {
                offset: 25,
                labelOffset: {
                    y: 5
                },

            },
            axisX: {
                showGrid: false,
                labelOffset: {
                    x: 10
                }
            }
        }

    }

})();

