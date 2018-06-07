(function() {
	'use strict';


	angular.module('proApp.pages')
        .controller('InstallCtrl', InstallController)
        .controller('LoginCtrl', LoginController)
        .controller('RegisterCtrl', RegisterController)
	;

    LoginController.$inject = ['$scope', '$state', '$rootScope', '__env', '$injector', 'tspCookies', 'tspAppPreloader', 'tspResourceHelper', 'tspRestService', 'tspSerialize'];
    function LoginController ($scope, $state, $rootScope, __env, $injector, tspCookies, tspAppPreloader, tspResourceHelper, tspRestService, tspSerialize) {
        // we will store all of our form data in this object
        $scope.postdata = null;
        $scope.submitButtonText = $scope.lang.labels.buttons.login;

        $scope.timerDelay = 5000;
        $scope.domain = document.location.origin;

        $scope.loginUser = function(){

            $scope.submitButtonText = $scope.lang.labels.buttons.delay;

            var result = tspRestService.query({object: 'user', action: 'login'}, tspSerialize.data($scope.postdata));
            tspResourceHelper.process(result,  true,
                function(data){

                    if ((__env.debug && __env.verbose))
                    {
                        console.log('Login Successful...');
                        console.log(data);
                    }

                    // Set local token if available, if not unset it and redirect to login
                    if (data.token !== undefined && data.token !== null &&
                        data.current_user !== undefined && data.current_user !== null)
                    {
                        // @TODO: Determine a way to expire localStorage tokens
                        if (data.token_expires !== undefined && data.token_expires !== null)
                        {
                            tspCookies.set('token', data.token);
                        }
                        else
                        {
                            tspCookies.set('token', data.token);
                        }

                        $scope.app.current_user = data.current_user;

                        tspCookies.set('user_id', $scope.app.current_user._id);
                        tspCookies.set('preferences', $scope.app.current_user.preferences);

                        if ((__env.debug && __env.verbose))
                            console.log('Token Valid...');

                        $rootScope.loadingAppText = $scope.lang.sentences.login;
                        $rootScope.loadingApp = tspAppPreloader.show();
                        $rootScope.first_run = true;
                        $rootScope.initApp();

                        $scope.submitButtonText = $scope.lang.labels.buttons.login;
                    }
                    else
                    {
                        tspCookies.clr();
                        $state.go('login');
                    }
                },
                function(){
                    $scope.submitButtonText = $scope.lang.labels.buttons.login;
                }
            );
        }

        // @TODO: When registering new users on the server always copy over non-global settings from the current company to the users
        // settings
        $rootScope.loadingApp = tspAppPreloader.hide(true);
    }

    RegisterController.$inject = ['$scope', '$state', '$rootScope', '__env', '$injector', '$location', 'tspCookies', 'tspAppPreloader', 'tspResourceHelper', 'tspRestService', 'tspSerialize'];
    function RegisterController ($scope, $state, $rootScope, __env, $injector, $location, tspCookies, tspAppPreloader, tspResourceHelper, tspRestService, tspSerialize) {
        // we will store all of our form data in this object
        $scope.postdata = null;
        $scope.submitButtonText = $scope.lang.labels.buttons.register;

        $scope.timerDelay = 5000;
        $scope.domain = document.location.origin;

        $scope.registerUser = function(){

            $scope.submitButtonText = $scope.lang.labels.buttons.delay;

            var result = tspRestService.query({object: 'user', action: 'register'}, tspSerialize.data($scope.postdata));
            tspResourceHelper.process(result,  true,
                function(data){

                    if ((__env.debug && __env.verbose))
                    {
                        console.log('Registration Complete...');
                        console.log(data);
                    }

                    $rootScope.loadingAppText = $scope.lang.sentences.register;
                    $rootScope.loadingApp = tspAppPreloader.show();
                    $rootScope.loadingApp = tspAppPreloader.hide(true);

                    $scope.submitButtonText = $scope.lang.labels.buttons.register;

                    $state.go('login');
                },
                function(){
                    $scope.submitButtonText = $scope.lang.labels.buttons.register;
                }
            );
        }

        // @TODO: When registering new users on the server always copy over non-global settings from the current company to the users
        // settings
        $rootScope.loadingApp = tspAppPreloader.hide(true);
    }

    InstallController.$inject = ['$scope', '$state', '$rootScope', '$timeout', '$http', '__env', '$injector', '$location', 'tspCookies', 'tspAppPreloader', 'tspResourceHelper', 'tspRestService', 'tspSerialize'];
    function InstallController ($scope, $state, $rootScope, $timeout, $http, __env, $injector, $location, tspCookies, tspAppPreloader, tspResourceHelper, tspRestService, tspSerialize) {
        // we will store all of our form data in this object
        $scope.postdata = {
            progress: {
                database: 0,
                account: 0,
            }
        };

        $scope.final_page = 2;

        $scope.databaseDelay = 25;
        $scope.accountDelay = 25;
        $scope.domain = document.location.origin;
        $scope.domain.replace(/\/$/, '');

        $scope.domain_path = window.location.pathname;
        $scope.domain += $scope.domain_path;
        $scope.domain.replace(/\/$/, '');

        function setStatusBar(type, value)
        {
            jQuery('#progress-' + type + ' .progress-bar').attr('style', 'width: ' + value + '% !important').attr('aria-valuenow', value);
            jQuery('#progress-' + type + '-number').text(value);
        }

        function resetStatusBars()
        {
            if ((__env.debug && __env.verbose))
                console.log("Resetting status bars...");

            $scope.postdata.progress.database = 0;
            $scope.postdata.progress.account = 0;

            setStatusBar('database', 0);
            setStatusBar('account', 0);

            jQuery('.install-complete').css('display', 'none');
        }

        function disableNavButtons(status)
        {
            if ((__env.debug && __env.verbose))
                console.log("Setting nav buttons to "  + status + "...");

            if (status || status == 'true')
            {
                jQuery('.pager .previous').addClass('disabled');
                jQuery('.pager .next').addClass('disabled');
            }
            else
            {
                jQuery('.pager .previous').removeClass('disabled');
                jQuery('.pager .next').removeClass('disabled');
            }
        }

        function beginInstall()
        {
            resetStatusBars();

            disableNavButtons(true);

            $scope.installDatabase();
        }

        function completeInstall()
        {
            jQuery('.install-complete').css('display', 'block');
            localStorage.setItem(__env.cookie_prefix + '.installed', "true");

            disableNavButtons(false);
        }

        function counter(type)
        {
            if (type == 'database')
            {
                $scope.postdata.progress.database += 1;

                setStatusBar('database', $scope.postdata.progress.database);

                if ((__env.debug && __env.verbose))
                    console.log('Timer (Database): ' + $scope.postdata.progress.database);

                if ($scope.postdata.progress.database < 100)
                {
                    $timeout(function(){}, $scope.databaseDelay, false).then(function() {
                        counter('database');
                    });
                }
                else
                {
                    $scope.createUserAccount();
                }
            }
            else if (type == 'account')
            {
                $scope.postdata.progress.account += 1;

                setStatusBar('account', $scope.postdata.progress.account);

                if ((__env.debug && __env.verbose))
                    console.log('Timer (Account): ' + $scope.postdata.progress.account);

                if ($scope.postdata.progress.account < 100)
                {
                    $timeout(function(){}, $scope.accountDelay, false).then(function() {
                        counter('account');
                    });
                }
                else
                    completeInstall();
            }
        }

        $scope.installDatabase = function(){

            $timeout(counter('database'), $scope.databaseDelay, false);

            var result = tspRestService.query({object: 'system', action: 'install'}, tspSerialize.data($scope.postdata));
            tspResourceHelper.process(result, false,
                function(data){

                    if ((__env.debug && __env.verbose))
                    {
                        console.log('Install Complete...');
                        console.log(data);
                    }

                    // DO NOT SHOW ALERT ON SUCCESS
                    // Start counter instead
                    //SweetAlert.success('Credentials accepted. ' + $scope.object + ' created.', {title: "Record Updated"});


                    // Set the .installed file for the installation
                    // If the user creation portion fails, the user can still register an account manually
                    $http({
                        method: 'POST',
                        url: 'install.php',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8'}
                    })
                    .success(function (result) { })
                    .error(function (data, status) { });
                },
                function(){
                    $scope.finished = true;
                }
            );
        }

        $scope.createUserAccount = function(){

            var result = tspRestService.query({object: 'user', action: 'create', id: 'admins'}, tspSerialize.data($scope.postdata));
            tspResourceHelper.process(result,  true,
                function(data){

                    if ((__env.debug && __env.verbose))
                    {
                        console.log('Install Complete...');
                        console.log(data);
                    }

                    // DO NOT SHOW ALERT ON SUCCESS
                    // Start counter instead
                    //SweetAlert.success('Credentials accepted. ' + $scope.object + ' created.', {title: "Record Updated"});

                    $timeout(counter('account'), $scope.accountDelay, false);
                },
                function(){
                    $scope.finished = true;
                }
            );
        }

        $scope.previousPage = function(){
            var current = $scope.postdata.page;
            var previous = parseInt($scope.postdata.page) - 1;

            if ((__env.debug && __env.verbose))
                console.log("Current Page = " + $scope.postdata.page + " Final Page = " + $scope.final_page);

            if (previous > 0){
                jQuery('#tab' + current).removeClass('active');
                jQuery('#tab' + previous).addClass('active');

                jQuery('.install-complete').css('display', 'none');
                jQuery('.progress-stats').css('display', 'none');
            }
        }

        $scope.nextPage = function(){
            var tab_id = jQuery('.tab-pane.active').attr('id');
            var id_num = tab_id.match(/tab(\d+)/);

            $scope.postdata.page = id_num[1];

            if ((__env.debug && __env.verbose))
                console.log("Current Page = " + $scope.postdata.page + " Final Page = " + $scope.final_page);

            var current = $scope.postdata.page;
            var next = parseInt($scope.postdata.page) + 1;

            if ($scope.postdata.page == $scope.final_page)
            {
                if ($scope.app.debug)
                    console.log($scope.postdata);

                var $activeTab = jQuery('.tab-pane.active');
                var $form = $activeTab.find('form');

                // validate form in casa there is form
                if ($form.length){
                    if ( $form.parsley().validate() ) {
                        if (next <= $scope.final_page + 2)
                        {
                            jQuery('#tab' + current).removeClass('active');
                            jQuery('#tab' + next).addClass('active');
                        }

                        jQuery('.progress-stats').css('display', 'block');
                        beginInstall();
                    }
                }
            }
            else {
                if (next <= $scope.final_page + 2)
                {
                    jQuery('#tab' + current).removeClass('active');
                    jQuery('#tab' + next).addClass('active');

                    jQuery('.install-complete').css('display', 'none');
                    jQuery('.progress-stats').css('display', 'none');
                }
            }
        }

        jQuery('.install-complete').css('display', 'none');
        jQuery('.progress-stats').css('display', 'none');
        $rootScope.loadingApp = tspAppPreloader.hide(true);
    }

})();

