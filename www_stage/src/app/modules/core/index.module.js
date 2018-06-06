(function() {
'use strict';

    angular
        .module('proApp.core')
        .controller('AppCtrl', AppController)
        .controller('HeadCtrl', HeadController)
        .controller('NavCtrl', NavController)
        .controller('DatePickerCtrl', DatePickerController)
        .controller('TypeAheadCtrl', TypeAheadController)
        .controller('UISelectCtrl', UISelectController)
        .controller('DataWizardCtrl', DataWizardController)
        .controller('AlertCtrl', AlertController)
        .controller('LogoutCtrl', LogoutController)
        .controller('ModalCtrl', ModalController)
        ;

    LogoutController.$inject = ['$window', '$scope', '$rootScope', '__env', '$injector', '$state', '$localStorage', 'tspCookies', 'tspAppPreloader', 'tspApp', 'tspResourceHelper', 'tspRestService', 'tspSerialize'];
    function LogoutController($window, $scope, $rootScope, __env, $injector, $state, $localStorage, tspCookies, tspAppPreloader, tspApp, tspResourceHelper, tspRestService, tspSerialize) {
        if ((__env.debug && __env.verbose))
            console.log('Logging Out...');

        $rootScope.loadingAppText = $scope.lang.sentences.log_out;
        $rootScope.loadingApp = tspAppPreloader.show();
        $rootScope.config_loaded = false;
        tspCookies.clr();

        setTimeout(function(){
            $state.go('login');
        }, 3000);
    }

    AppController.$inject = ['lang', '$window', '$scope', '$rootScope', '__env', '$injector', '$state', '$localStorage', 'tspCookies', 'tspAppPreloader', 'tspApp', 'tspResourceHelper', 'tspRestService', 'tspSerialize', 'tspGrouper'];
    function AppController(lang, $window, $scope, $rootScope, __env, $injector, $state, $localStorage, tspCookies, tspAppPreloader, tspApp, tspResourceHelper, tspRestService, tspSerialize, tspGrouper) {
        $rootScope.loadingAppText = "";
        $rootScope.loadingDataText = "";

        $rootScope.loadingApp = tspAppPreloader.show();

        if ((__env.debug && __env.verbose))
            console.log('At App Controller...');

        $rootScope.first_run = false;

        // @TODO: Load default application settings
        $scope.app = __env;
        $scope.config = __env;

        var lang_code = tspCookies.get('preferences.lang_code');

        if (lang_code === undefined || lang_code === null)
            lang_code = 'en';

        $scope.lang = lang[lang_code];

        $scope.app.current_user = {
            preferences: {
                default_page_size: 0,
                theme: 0,
                current_company_id: 0
            },
            _id: 0
        };
        $scope.app.session = {};
        $scope.app.shared = {};
        $scope.app.settings = {};

        $rootScope.config = __env;
        $rootScope.config_loaded = false;

        $rootScope.getTimeZoneCountry = function (item) {
            return $scope.shared.timezone_countries[item.tag] + ' Time Zone';
        };

        $rootScope.timeZoneGroup = function(item){
            return tspGrouper.timezone($scope.app.shared.timezone.countries, item);
        }

        $rootScope.categoryGroup = function(item){
            return tspGrouper.main($scope.app.shared.taxonomies, item);
        };

        $rootScope.safeApply = function(fn) {
            var phase = this.$root.$$phase;
            if(phase == '$apply' || phase == '$digest') {
                if(fn && (typeof(fn) === 'function')) {
                    fn();
                }
            } else {
                this.$apply(fn);
            }
        };

        $rootScope.initApp = function(){

            if ((__env.debug && __env.verbose))
                console.log('Initializing App...');

            $rootScope.loadingAppText = "";
            $rootScope.loadingDataText = "";

            $rootScope.loadingApp = tspAppPreloader.show();

            // @TODO: Get initial metadata information for app
            // @TODO: Update this information as it changes throughout the site
            var result = tspRestService.query({object: 'system', action: 'init', id: 0}, tspSerialize.data({
                user_id: tspCookies.get('user_id'),
                show_countries: tspCookies.get('settings.show_countries'),
                country_code: $scope.app.locale.default_country,
                lang_code: $scope.app.locale.lang_code,
                current_company_id: tspCookies.get('preferences.current_company_id')
            }));
            tspResourceHelper.process(result,  false,
                function(data){
                    $scope.app.current_user = data.current_user; //users

                    // DO NOT remove this if statement when live. If you remove it it will bring back the server
                    // changes and disregard the cookie changes each time and since we cant save to
                    // server currently we need to leave this to keep session changes
                    if ($rootScope.first_run)
                    {
                        if ((__env.debug && __env.verbose))
                            console.log('First Run...');

                        tspCookies.set('user_id', $scope.app.current_user._id);
                        tspCookies.set('preferences', $scope.app.current_user.preferences);
                        tspCookies.set('settings', data.system_settings);
                    }

                    $scope.lang = lang[$scope.app.current_user.preferences.lang_code];

                    $rootScope.themeActive = tspCookies.get('preferences.theme');
                    $rootScope.numPerPage = tspCookies.get('preferences.default_page_size');
                    $rootScope.isLayoutHorizontal = tspCookies.get('preferences.layout_horizontal');
                    $rootScope.isLeftMenuCollapsed = tspCookies.get('preferences.left_menu_collapsed');

                    $scope.app.shared.countries = data.countries; //countries
                    $scope.app.shared.states = data.states; //states
                    $scope.app.shared.types = data.types; //shared_types
                    $scope.app.settings = data.system_settings;

                    $rootScope.config_loaded = true;
                    if ((__env.debug && __env.verbose))
                        console.log('Initialization Complete.');

                    $rootScope.loadingApp = tspAppPreloader.hide();
                    
                    $rootScope.$emit("load." + $state.current.name, {});

                    if ($rootScope.first_run)
                        $state.go('app.properties');

                    $rootScope.first_run = false;
                },
                function(){

                }
            );
        };

        $rootScope.validateSession = function(){

            $scope.$state = $state;

            if (angular.isDefined($localStorage.state)){
                $scope.app.state = $localStorage.state;
            } else {
                $localStorage.state = $scope.app.state;
            }

            if ((__env.debug && __env.verbose))
                console.log('Validating Session with Token #' + tspCookies.get('token'));

            // check to see if this is a new installation
            // if it is begin install process, if not go to the default page
            var installed = localStorage.getItem(__env.cookie_prefix + '.installed');
            var $state = $injector.get('$state');

            // if installed attempt to display the dashboard
            if (installed == "true" || installed == true)
            {
                var result = tspRestService.query({object: 'user', action: 'auth', id: 0}, tspSerialize.data({
                    token: tspCookies.get('token')
                }));
                tspResourceHelper.process(result,  false,
                    function(data){
                        if ((__env.debug && __env.verbose))
                            console.log('User Authorized...');

                        var result = tspRestService.query({object: 'user', action: 'current'}, tspSerialize.data({
                            token: tspCookies.get('token')
                        }));
                        tspResourceHelper.process(result,  false,
                            function(data){

                                if ((__env.debug && __env.verbose))
                                {
                                    console.log('Updating Current User...')
                                    console.log(data);
                                }

                                $scope.app.current_user = data.current_user;
                                $rootScope.initApp();
                            },
                            function(){
                                tspCookies.clr();
                                $state.go('login');
                            }
                        );
                    },
                    function(){
                        if ((__env.debug && __env.verbose))
                            console.log('User NOT Authorized...');

                        tspCookies.clr();
                        $state.go('login');
                    }
                );
            }
            else // else go to the install screen
            {
                $state.go('install');
            }

            tspApp.run();
        }

        /*jshint validthis: true */
        var vm = this;
        vm.title = $scope.config.appTitle;


        var mm = $window.matchMedia('(max-width: ' + $scope.config.mobile_width + 'px)');
        mm.addListener(function(m) {
            $rootScope.safeApply(function() {
                $rootScope.isMobile = (m.matches) ? true : false;
            });
        });

        $rootScope.isMobile = mm.matches ? true: false;

        $scope.validateSession();
    }

    HeadController.$inject = ['__env', '$injector', '$state', '$scope', '$rootScope', 'tspCookies', 'tspAppPreloader', 'SweetAlert', 'Fullscreen'];
    function HeadController(__env, $injector, $state, $scope, $rootScope, tspCookies, tspAppPreloader, SweetAlert, Fullscreen){
        $scope.app.current_user.preferences.current_company_id = tspCookies.get('preferences.current_company_id');
        $scope.app.current_company_id = tspCookies.get('preferences.current_company_id');

        $scope.toggleSidebar = function() {
            $scope.sidebarOpen = $scope.sidebarOpen ? false : true;
        }

        $scope.fullScreen = function() {
            if (Fullscreen.isEnabled())
                Fullscreen.cancel();
            else
                Fullscreen.all()
        };

        $scope.onCompanyChange = function(id) {
            if ((__env.debug && __env.verbose))
                console.log('Setting current_company_id to ' + id);

            // @TODO: Update user preference on server IF they have permission to change their default company
            tspCookies.set('preferences.current_company_id', id);
            $scope.app.current_user.preferences.current_company_id = id;
            $scope.app.current_company_id = id;
            $rootScope.initApp();

            $state.go('app.properties');
        }

        $scope.getDefaultCompanyID = function(){
            return tspCookies.get('preferences.current_company_id');
        }

        $scope.logoutUser = function(){

            SweetAlert.confirm($scope.lang.sentences.confirm.logout,
                {
                    title : $scope.lang.sentences.confirm.title,
                    showCancelButton: true
                }).then(
                function(proceed){
                    if (proceed)
                    {
                        if ((__env.debug && __env.verbose))
                            console.log('Logging Out...');

                        $rootScope.loadingAppText = $scope.lang.sentences.logout;
                        $rootScope.loadingApp = tspAppPreloader.show();
                        $rootScope.config_loaded = false;
                        tspCookies.clr();
                        console.clear();

                        setTimeout(function(){
                            $state.go('login');
                        }, 3000);
                    }
                }
            );
        }

        // watch for changes in horizontal nav
        $rootScope.$watch('isMobile', function() {
            if($rootScope.isMobile) {
                // Dont touch this if in horizontal mode regardless of mobility
                if (!$rootScope.isLayoutHorizontal)
                    $scope.isLeftMenuCollapsed = true;
            }
            else{
                // Dont touch this if in horizontal mode regardless of mobility
                if (!$rootScope.isLayoutHorizontal)
                    $scope.isLeftMenuCollapsed = tspCookies.get('preferences.left_menu_collapsed');
            }

        });
    }

    NavController.$inject = ['$scope', '$rootScope', '__env', '$injector', 'tspCookies'];
    function NavController($scope, $rootScope, __env, $injector, tspCookies) {
        $rootScope.themeActive = tspCookies.get('preferences.theme');
        $rootScope.isLeftMenuCollapsed = tspCookies.get('preferences.left_menu_collapsed');
        $rootScope.isLayoutHorizontal = tspCookies.get('preferences.layout_horizontal');

        $rootScope.toggleLeftMenuNav = function() {
            // @TODO: Update user preference on server
            $rootScope.isLeftMenuCollapsed = !$rootScope.isLeftMenuCollapsed;
            tspCookies.set('preferences.left_menu_collapsed', $rootScope.isLeftMenuCollapsed);
        };

        $rootScope.changeLayout = function() {
            // @TODO: Update user preference on server
            $rootScope.isLeftMenuCollapsed = true;
            $rootScope.isLayoutHorizontal = !$rootScope.isLayoutHorizontal;
            tspCookies.set('preferences.layout_horizontal', $rootScope.isLayoutHorizontal);
        };

        $rootScope.onThemeChange = function(theme) {
            // @TODO: Update user preference on server
            $rootScope.themeActive = theme;
            tspCookies.set('preferences.theme', theme);
        };

        if (!$rootScope.isMobile && $rootScope.isLeftMenuCollapsed)
        {
            if ((__env.debug && __env.verbose))
                console.log('Manually adding class to body to collapse menu...');

            // Manually toggle menu if user preference is to collapse it
            // Some bug does not allow it to collapse on start-up and this fixes it
            jQuery('body').addClass('on-canvas nav-min');
        }
    }

    DatePickerController.$inject = ['$scope'];
    function DatePickerController($scope) {
        $scope.open = function($event) {
            $event.preventDefault();
            $event.stopPropagation();

            $scope.opened = true;
        };

    }

    TypeAheadController.$inject = ['$scope'];
    function TypeAheadController($scope) {

        $scope.selected = undefined;
        $scope.states = ['Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado', 'Connecticut', 'Delaware', 'Florida', 'Georgia',
            'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky', 'Louisiana', 'Maine', 'Maryland', 'Massachusetts', 'Michigan',
            'Minnesota', 'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada', 'New Hampshire', 'New Jersey', 'New Mexico', 'New York',
            'North Dakota', 'North Carolina', 'Ohio', 'Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island', 'South Carolina', 'South Dakota',
            'Tennessee', 'Texas', 'Utah', 'Vermont', 'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming'
        ];
    }

    UISelectController.$inject = ['$scope'];
    function UISelectController($scope) {
        $scope.person = {};
        // demo one
        $scope.people = [
            { name: 'Adam',      email: 'adam@mail.com'},
            { name: 'Amalie',    email: 'amalie@mail.com'},
            { name: 'Nicolás',   email: 'nicolas@mail.com'},
            { name: 'Wladimir',  email: 'wladimir@mail.com'},
            { name: 'Samantha',  email: 'samantha@mail.com'},
            { name: 'Estefanía', email: 'estefanía@mail.com'},
            { name: 'Natasha',   email: 'natasha@mail.com'},
            { name: 'Nicole',    email: 'nicole@mail.com'},
            { name: 'Adrian',    email: 'adrian@mail.com'}
        ];

        $scope.state = {};
        $scope.timezone = [
            {tag: 1, name: 'Alaska'},
            {tag: 1, name: 'Hawaii'},
            {tag: 2, name: 'California'},
            {tag: 2, name: 'Nevada'},
            {tag: 2, name: 'Oregon'},
            {tag: 2, name: 'Washington'},
            {tag: 3, name: 'Arizona'},
            {tag: 3, name: 'Colorado'},
            {tag: 3, name: 'Idaho'},
            {tag: 3, name: 'Montana'},
            {tag: 3, name: 'Nebraska'},
            {tag: 3, name: 'New Mexico'},
            {tag: 3, name: 'North Dakota'},
            {tag: 3, name: 'Utah'},
            {tag: 3, name: 'Wyoming'},
            {tag: 4, name: 'Alabama'},
            {tag: 4, name: 'Arkansas'},
            {tag: 4, name: 'Illinois'},
            {tag: 4, name: 'Iowa'},
            {tag: 4, name: 'Kansas'},
            {tag: 4, name: 'Kentucky'},
            {tag: 4, name: 'Louisiana'},
            {tag: 4, name: 'Minnesota'},
            {tag: 4, name: 'Mississippi'},
            {tag: 4, name: 'Missouri'},
        ];

        $scope.timezoneFn = function (item){
            switch(item.tag) {
                case 1: return 'Alaskan/Hawaiian Time Zone';
                case 2: return 'Pacific Time Zone';
                case 3: return 'Moutain Time Zone';
                case 4: return 'Central Time Zone';
            }

        };


        // Multiple Select
        $scope.availableColors = ['Red','Green','Blue','Yellow','Magenta','Maroon','Umbra','Turquoise', 'Array of Strings'];
        $scope.multipleDemo = {};
        $scope.multipleDemo.colors = ['Blue','Red', 'Array of Strings'];
        $scope.multipleDemo.selectedPeopleWithGroupBy = [$scope.people[8], $scope.people[0]];

        $scope.someGroupFn = function (item){
            if (item.name[0] >= 'A' && item.name[0] <= 'M')
                return 'From A - M';
            if (item.name[0] >= 'N' && item.name[0] <= 'Z')
                return 'From N - Z';
        };

    }

    DataWizardController.$inject = ['$scope', '$state', '$rootScope', '__env', '$injector', '$filter', 'tspCookies', 'SweetAlert', 'tspDataPreloader', 'tspResourceHelper', 'tspRestService', 'tspSerialize'];
    function DataWizardController ($scope, $state, $rootScope, __env, $injector, $filter, tspCookies, SweetAlert, tspDataPreloader, tspResourceHelper, tspRestService, tspSerialize) {
        $scope.submitButtonText = $scope.lang.labels.buttons.validate_create;

        $scope.timerDelay = 5000;
        $scope.domain = document.location.origin;

        $scope.items = []; // records stored here
        $scope.search = {
            'keywords': ''
        };
        $scope.filteredData = [];
        $scope.row = '';

        $scope.numPerPageOpts = [5, 10, 25, 50, 100];
        $rootScope.numPerPage = tspCookies.get('preferences.default_page_size');
        $scope.currentPage = 1;
        $scope.currentPageRecords = []; // data to hold per pagination
        $rootScope.loadingData = true;

        $scope.select = function(page) {
            var start = (page - 1)*$scope.numPerPage,
                end = start + $scope.numPerPage;

            if ($scope.filteredData !== undefined && $scope.filteredData != null)
            {
                $scope.currentPageRecords = $scope.filteredData.slice(start, end);
                $rootScope.$emit("records." + $state.current.name, $scope.currentPageRecords);
            }
        }
        $scope.onFilterChange = function() {
            $scope.select(1);
            $scope.currentPage = 1;
            $scope.row = '';
        }
        $scope.onNumPerPageChange = function(num) {
            // @TODO: Update user preference on server
            $rootScope.numPerPage = num;
            tspCookies.set('preferences.default_page_size', num);

            $scope.select(1);
            $scope.currentPage = 1;
        }
        $scope.onOrderChange = function() {
            $scope.select(1);
            $scope.currentPage = 1;
        }
        $scope.search = function() {
            $scope.filteredData = $filter('filter')($scope.items, $scope.search.keywords);
            $scope.onFilterChange();
        }
        $scope.searchRange = function() {

            if ($scope.search.start_time !== null && $scope.search.start_time !== undefined &&
                $scope.search.end_time !== null && $scope.search.end_time !== undefined)
            {
                var df = new Date($scope.search.start_time);
                var dt = new Date($scope.search.end_time);

                var result = [];

                for (var i=0; i<$scope.items.length; i++){
                    var tf = new Date($scope.items[i].start_time),
                        tt = new Date($scope.items[i].end_time);

                    if (df >= tf && dt <= tt)  {
                        result.push($scope.items[i]);
                    }
                }
                $scope.filteredData = result;
            }
            else
            {
                $scope.filteredData = $filter('filter')($scope.items, "");
            }

            $scope.onFilterChange();
        }

        $scope.order = function(rowName) {
            if($scope.row == rowName)
                return;
            $scope.row = rowName;
            $scope.filteredData = $filter('orderBy')($scope.items, rowName);
            $scope.onOrderChange();
        }

        // Step 0: ListView
        // Step 1: QuickView
        // Step 2: FormView
        // Step 3: CreateView
        // Step 4: IconView
        $scope.steps = [true, false, false, false, false]; // steps in this controller

        $scope.listView = function(){
            for(var i = 0; i < $scope.steps.length; i++) {
                $scope.steps[i] = false;
            }

            $rootScope.$emit("records." + $state.current.name, $scope.currentPageRecords);
            $scope.steps[0] = true;
        }
        $rootScope.quickView = function(type, pos, id){

            var state_type = "app." + type;

            if ((__env.debug && __env.verbose))
                console.log(state_type + " ?= " + $state.current.name + " Pos: " + pos + " ID #: " + id);

            if (state_type != $state.current.name)
            {
                $rootScope.$emit("record-view." + state_type, id);
            }
            else
            {
                for(var i = 0; i < $scope.steps.length; i++) {
                    $scope.steps[i] = false;
                }

                if (pos == -1)
                {
                    var new_pos = 0;

                    angular.forEach($scope.items, function(value, index){
                        if (value._id == id)
                            new_pos = index;
                    });

                    if ((__env.debug && __env.verbose))
                    {
                        console.log("Pos: " + pos + " ID #: " + new_pos);
                        console.log($scope.items);
                        console.log($scope.items[new_pos]);
                    }

                    $scope.curRec = new_pos;
                    $rootScope.$emit("view." + $state.current.name, $scope.items[new_pos]);
                }
                else
                {
                    $scope.curRec = pos;

                    $rootScope.$emit("view." + $state.current.name, $scope.items[pos]);
                }
                $scope.steps[1] = true;
            }
        }
        $scope.formView = function(pos, id, step){
            for(var i = 0; i < $scope.steps.length; i++) {
                $scope.steps[i] = false;
            }

            $scope.submitButtonText = $scope.lang.labels.buttons.validate_update;
            $scope.prevStep = step;
            $scope.curRec = pos;

            $rootScope.$emit("view." + $state.current.name, $scope.items[pos]);
            $scope.steps[2] = true;
        }
        // Pass in any data to the UI thats relevant to showing a new record
        $scope.createView = function(data){
            for(var i = 0; i < $scope.steps.length; i++) {
                $scope.steps[i] = false;
            }

            $scope.submitButtonText = $scope.lang.labels.buttons.validate_create;

            $rootScope.$emit("create." + $state.current.name, data);

            $scope.steps[3] = true;
        }
        $scope.iconView = function(){
            for(var i = 0; i < $scope.steps.length; i++) {
                $scope.steps[i] = false;
            }

            // show all records
            $rootScope.$emit("records." + $state.current.name, $scope.filteredData);
            $scope.steps[4] = true;
        }
        $scope.resetView = function() {
            $scope.steps = [true, false, false, false, false];
        }

        $scope.deleteRecord = function(pos, id, title){
            SweetAlert.confirm($scope.lang.fn_confirm_action(['delete', title]),
                {
                    title : $scope.lang.sentences.confirm.title,
                    showCancelButton: true
                }).then(
                function(proceed){
                    if ((__env.debug && __env.verbose))
                    {
                        console.log("Event: " + proceed);
                    }

                    if (proceed) {
                        var result = tspRestService.query({object: $scope.route, action: 'delete'}, tspSerialize.data({
                            _id: id,
                            token: tspCookies.get('token'),
                            lang_code: $scope.app.locale.lang_code,
                            current_company_id: tspCookies.get('preferences.current_company_id')
                        }));
                        tspResourceHelper.process(result,  false,
                            function(result){
                                location.reload();
                            },
                            function(){
                            }
                        );
                    }
                }
            );
        }
        $scope.toggleState = function(pos, id, title){

            var action = 'deactivate';

            var toggleID = '#toggle-' + id;

            if (jQuery(toggleID + ' i').hasClass('glyphicon-eye-open'))
                action = 'activate';

            SweetAlert.confirm($scope.lang.fn_confirm_action([action, title]),
                {
                    title : $scope.lang.sentences.confirm.title,
                    showCancelButton: true
                }).then(
                function(proceed){
                    if ((__env.debug && __env.verbose))
                    {
                        console.log("Event: " + proceed);
                    }
                    if (proceed){
                        var result = tspRestService.query({object: $scope.route, action: action}, tspSerialize.data({
                            _id: id,
                            token: tspCookies.get('token'),
                            lang_code: $scope.app.locale.lang_code,
                            current_company_id: tspCookies.get('preferences.current_company_id')
                        }));
                        tspResourceHelper.process(result,  false,
                            function(result){
                                $scope.items[pos].status = {
                                    _id: result.data._id,
                                    description: result.data.description,
                                    background: result.data.background,
                                    foreground: result.data.foreground
                                };

                                var toggleID = '#toggle-' + id;

                                if (action =='deactivate')
                                {
                                    jQuery(toggleID + ' i').removeClass("glyphicon-eye-close");
                                    jQuery(toggleID + ' i').addClass("glyphicon-eye-open");
                                    jQuery(toggleID + ' span').text('Activate');
                                }
                                else
                                {
                                    jQuery('#row-' + id).css('text-decoration', 'none');
                                    jQuery(toggleID + ' i').removeClass("glyphicon-eye-open");
                                    jQuery(toggleID + ' i').addClass("glyphicon-eye-close");
                                    jQuery(toggleID + ' span').text('Deactivate');
                                }
                            },
                            function(){
                            }
                        );
                    }
                }
            );
        }

        $rootScope.initWizard = function(data){
            if ((__env.debug && __env.verbose))
                console.log("Initializing Wizard...");

            $scope.currentPageRecords = []

            $scope.items = data;

            if ($scope.items.length > 0)
            {
                $scope.search();
                $scope.select(1);
            }

            $rootScope.loadingData = tspDataPreloader.hide();
        }
    }

    AlertController.$inject = ['$rootScope', '$scope', '$interval'];
    function AlertController($rootScope, $scope, $timeout) {
        $scope.positionModel = 'topRight'; //topLeft, BottomLeft, topRight, bottomRight;
        $scope.animModel = 'fade'; //fade, scale, flash, bouncyflip, genie

        $scope.warningAlert = false;

        $scope.alert = [];
        $scope.toasts = [];

        $scope.closeAlert = function() {
            $scope.alert.splice(0, 1);
        }
        $scope.closeToast = function(index) {
            $scope.toasts.splice(index, 1);
        }

        $rootScope.$on("createToast", function(event, data){
            $scope.positionModel = data.pos;

            $scope.toasts.push({
                anim: data.model,
                type: angular.lowercase(data.type),
                msg: data.msg
            });
        });
        $rootScope.$on("createAlert", function(event, data){

            if (!$scope.warningAlert)
            {
                $scope.positionModel = data.pos;

                $scope.alert.push({
                    anim: data.model,
                    type: angular.lowercase(data.type),
                    msg: data.msg
                });

                $scope.warningAlert = true;
            }
        });
    }

    ModalController.$inject = ['action', 'object', 'routes', 'postdata', 'lang', '$scope', '$state', '$rootScope', '__env', '$injector', '$modal', 'tspCookies', 'tspArray', 'tspDataPreloader', 'tspResourceHelper', 'tspRestService', 'tspSerialize', '$stateParams'];
    function ModalController (action, object, routes, postdata, lang, $scope, $state, $rootScope, __env, $injector, $modal, tspCookies, tspArray, tspDataPreloader, tspResourceHelper, tspRestService, tspSerialize, $stateParams) {

        $scope.action = action;
        $scope.object = object;
        $scope.routes = routes;
        $scope.postdata = postdata;
        $scope.lang = lang;
        $scope.isModal = true;

        $scope.closeModal = function() {
            $scope.$close();	// this method is associated with $modal scope which is this.
        };
    }
})();

