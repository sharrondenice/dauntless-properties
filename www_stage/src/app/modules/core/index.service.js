(function() {
    'use strict';

    angular.module('proApp.core.services', [
        'ngSanitize',
        'ui.router',
        'ui.bootstrap',
        'ngAnimate',
        'ngStorage',
        'ngResource',
        'FBAngular',
        'ng-sweet-alert'
    ])
    .factory('$exceptionHandler', exceptionHandler)
    .factory('jQuery', jQueryService)
    .factory('isMobile', isMobileFactory)
    .factory('tspApp', tspApp)
    .factory('tspString', tspString)
    .factory('tspArray', tspArray)
    .factory('tspDate', tspDate)
    .factory('tspGrouper', tspGrouper)
    .factory('tspSerialize', tspSerialize)
    .factory('tspValidate', tspValidate)
    .factory('tspResourceHelper', tspResourceHelper)
    .factory('tspJqueryService', tspJqueryService)
    .factory('tspHttpService', tspHttpService)
    .factory('tspRestService', tspRestService)
    .factory('tspAppPreloader', tspAppPreloader)
    .factory('tspDataPreloader', tspDataPreloader)
    .factory('tspCookies', tspCookies)
    .factory('tspUploader', tspUploader)
    .filter('tspFilterType', tspFilterType)
    .filter('tspFilterTruncate', tspFilterTruncate)
    .filter('tspFilterPhone', tspFilterPhone)
    .filter('tspFilterPrettyNull', tspFilterPrettyNull)
    .filter('tspFilterSeconds', tspFilterSeconds)
    .filter('tspFilterYesNo', tspFilterYesNo)
;

    jQueryService.$inject = ['$window'];
    function jQueryService($window) {
        return $window.jQuery; // assumes jQuery has already been loaded on the page
    }

    exceptionHandler.$inject = ['$log', '$window'];
    function exceptionHandler($log, $window ) {
        return function (exception, cause) {
            var errors = $window.JSON.parse($window.localStorage.getItem('sing-2-angular-errors')) || {};
            errors[new Date().getTime()] = arguments;
            $window.localStorage.setItem('sing-2-angular-errors', $window.JSON.stringify(errors));
            $log.error.apply($log, arguments);
            //$window.alert('check errors');
        };
    }

    var isMobile = {
        Android: function() {
            return navigator.userAgent.match(/Android/i);
        },
        BlackBerry: function() {
            return navigator.userAgent.match(/BlackBerry/i);
        },
        iOS: function() {
            return navigator.userAgent.match(/iPhone|iPad|iPod/i);
        },
        Opera: function() {
            return navigator.userAgent.match(/Opera Mini/i);
        },
        Windows: function() {
            return navigator.userAgent.match(/IEMobile/i);
        },
        any: function() {
            return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
        }

    };
    isMobileFactory.$inject = [];
    function isMobileFactory() {
        return isMobile;
    }

    tspApp.$inject = [];
    function tspApp(){

        // tasks to run on app startup
        var run = function(){
            jQuery(document).ajaxStart(function() {
                jQuery(document.body).css({'cursor' : 'wait'});
            }).ajaxStop(function() {
                jQuery(document.body).css({'cursor' : 'default'});
            });
        }

        return{
            run: run
        };
    }

    tspString.$inject = [];
    function tspString(){
        // Capitalize the first letter of a word
        var ucFirst = function(str){
            return str.charAt(0).toUpperCase() + str.slice(1);
        }

        return{
            ucFirst: ucFirst
        };
    }

    tspDate.$inject = [];
    function tspDate(){
        var toString = function(secs, format){
            var date = new Date(secs);
            return date;
        }

        return{
            toString: toString
        };
    }

    tspArray.$inject = [];
    function tspArray(){
        var pad = function(data, cnt){
            var length = data.length;

            // create random data (uses `track by $index` in html for duplicacy)
            for(var i = length; i < cnt; i++) {
                var rand = Math.floor(Math.random()*length);
                data.push(data[rand]);
            }

            return data;
        }
        var isEmpty = function(data){
            return (!data || data == undefined || data == null || data.length == 0 ||
                data === undefined || data === null)
        }
        var getIDs = function(data, key){
            var keys = [];

            angular.forEach(data, function(arr, pos){
                if (arr[key] !== undefined && arr[key] !== null)
                    keys.push(arr[key]);
            });

            return keys;
        }

        return{
            pad:        pad,
            isEmpty:    isEmpty,
            getIDs:     getIDs
        };
    }

    tspUploader.$inject = ['$injector'];
    function tspUploader($injector){
        var init = function(optionData, paramName, route, lang){

            //Apply methods for dropzone
            //Visit http://www.dropzonejs.com/#dropzone-methods for more methods
            optionData.dzMethods = {};

            //Set options for dropzone
            //Visit http://www.dropzonejs.com/#configuration-options for more options
            optionData.dzOptions = {
                url:            __env.api  + route,
                paramName:      paramName,
                maxFilesize:    1,
                dictDefaultMessage: lang.words.dropzone_msg,
                acceptedFiles:  'image/jpeg, image/jpg, image/png, image/gif, image/ico, ' +
                'audio/mp3, audio/m4a, audio/ogg, audio/wav, ' +
                'video/mp4, video/mov, video/wmv, video/avi, video/mpg, video/ogv, video/3gp, video/3g2, ' +
                'application/pdf, application/doc, application/docx, application/ppt, ' +
                'application/pptx, application/pps, application/ppsx, application/odt, ' +
                'application/xls, application/xlsx, application/psd',
                addRemoveLinks: true,
                clickable:      true,
                headers: {
                    'Authorization': null,
                    'Cache-Control': null,
                    'X-Requested-With': null
                }
            };
            
            //Handle events for dropzone
            //Visit http://www.dropzonejs.com/#events for more events
            optionData.dzCallbacks = {
                'sending' : (optionData.sending !== undefined) ? optionData.sending : function(){}, // Params: file, xhr, formData
                'addedfile' : (optionData.added !== undefined) ? optionData.added : function(){}, // Params: file
                'removedfile' : (optionData.remove !== undefined) ? optionData.remove : function(){}, // Params: file
                'success' : (optionData.success !== undefined) ? optionData.success : function(){} // Params: file, xhr
            };
        }

        return{
            init: init
        };
    }

    tspGrouper.$inject = [];
    function tspGrouper(){
        var main = function(list, item){
            var parent = "";

            angular.forEach(list, function(child){
                if (child._id == item.parent_id)
                    parent = child.title;
            });

            return parent;
        }
        var timezone = function(list, item){
            var parent = "";

            angular.forEach(list, function(country, tag){
                if (tag == item.tag)
                    parent = country;
            });

            return parent;
        }

        return{
            main: main,
            timezone: timezone
        };
    }

    tspCookies.$inject = ['$injector'];
    function tspCookies($injector){
        var prefix = __env.cookie_prefix;

        var get = function(key){
            var value = null;

            switch(key){
                case 'user_id': case 'token':
                    value = localStorage.getItem(prefix + '.' + key);
                    break;
                case 'preferences': case 'settings':
                    value = localStorage.getItem(prefix + '.' + key);
                    value = JSON.parse(value);
                    break;
                default:
                    var kArr = key.split(".");

                    var data = localStorage.getItem(prefix + '.' + kArr[0]);

                    if (data !== undefined && data !== null)
                    {
                        data = JSON.parse(data);
                        angular.forEach(data, function(pvalue, pkey){

                            if (pkey == kArr[1])
                            {
                                if (pvalue == "true")
                                    pvalue = true;
                                else if (pvalue == "false")
                                    pvalue = false;

                                value = pvalue;
                            }
                        });
                    }
                    break;
            }

            if ((__env.debug && __env.verbose))
                console.log('Getting cookie: ' + key + ' Value: ' + value);

            if (value === undefined || !value || value === "")
                return null;
            else
                return value;
        }
        var set = function(key, value){

            switch(key){
                case 'user_id': case 'token':
                    localStorage.setItem(prefix + '.' + key, value);
                    break;
                case 'preferences': case 'settings':
                    localStorage.setItem(prefix + '.' + key, JSON.stringify(value, null));
                    break;
                default:

                    var kArr = key.split(".");

                    var data = localStorage.getItem(prefix + '.' + kArr[0]);

                    if (data !== undefined && data !== null)
                    {
                        data = JSON.parse(data);
                        data[kArr[1]] = value;

                        localStorage.setItem(prefix + '.' + kArr[0], JSON.stringify(data, null));
                    }
                    else
                    {
                        data = [];
                        data[kArr[1]] = value;
                        localStorage.setItem(prefix + '.' + kArr[0], JSON.stringify(data, null));
                    }
                    break;
            }

            if ((__env.debug && __env.verbose))
                console.log('Setting cookie: ' + key + ' Value: ' + value);
        }
        var del = function(key){
            if ((__env.debug && __env.verbose))
                console.log('Deleting cookie: ' + key);

            localStorage.removeItem(prefix + '.' + key);
        }
        var clr = function(){
            if ((__env.debug && __env.verbose))
                console.log('Deleting ALL cookies');

            localStorage.removeItem(prefix + '.' + 'user_id');
            localStorage.removeItem(prefix + '.' + 'token');
            localStorage.removeItem(prefix + '.' + 'settings');
            localStorage.removeItem(prefix + '.' + 'preferences');
        }

        return{
            get:    get,
            set:    set,
            del:    del,
            clr:    clr
        };
    }

    tspSerialize.$inject = [];
    function tspSerialize(){
        /**
         * Function to convert a JSON object to key/value pairs
         *
         * @since 1.0.0
         *
         * @param object obj - the object to convert
         * @param bool complex_obj - whether the object is complex
         *
         * @return string str - the key/value string
         */
        var data = function(obj, complex_obj){
            var str = "";

            if (complex_obj)
            {
                var jsonData = angular.toJson(obj);
                var objectToSerialize = {'data': jsonData};
                str = jQuery.param(objectToSerialize);
            }
            else
            {
                angular.forEach(obj, function(value, key) {
                    str += key + "=" + value + "&";
                });
            }

            return str;
        }

        return{
            data: data
        };
    }

    tspValidate.$inject = [];
    function tspValidate(){
        /**
         * Function to determine if username valid
         *
         * @since 1.0.0
         *
         * @param string username - the username
         *
         * @return bool - is the username valid
         */
        var username = function(username){
            var USERNAME_REGEXP = /^([a-zA-Z0-9_\.-]){5,25}$/;

            if (USERNAME_REGEXP.test(username) && username !== undefined)
                return true;
            else
                return false;
        }

        /**
         * Function to determine if email valid
         *
         * @since 1.0.0
         *
         * @param string email - the email
         *
         * @return bool - is the email valid
         */
        var email = function(email){
            var EMAIL_REGEXP = /^[_a-z0-9]+(\.[_a-z0-9]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/;

            if (EMAIL_REGEXP.test(email) && email !== undefined)
                return true;
            else
                return false;
        }

        return{
            username: username,
            email: email
        };
    }

    tspAppPreloader.$inject = ['__env', '$injector', 'tspCookies'];
    function tspAppPreloader(__env, $injector, tspCookies){
        var show = function(){
            if ((__env.debug && __env.verbose))
                console.log('Show App Preloader...');

            return true;
        }
        var hide = function(force){

            // If not forcing removal of preloader
            // and configuration not loaded or user token not set
            // let the preloader remain
            if (!force && !tspCookies.get('token'))
            {
                if ((__env.debug && __env.verbose))
                    console.log('Deny Removal of App Preloader...');

                return true;
            }
            else
            {
                if ((__env.debug && __env.verbose))
                    console.log('Hide App Preloader...');

                return false;
            }
        }

        return{
            show: show,
            hide: hide
        };
    }

    tspDataPreloader.$inject = ['__env', '$injector', 'tspCookies'];
    function tspDataPreloader(__env, $injector, tspCookies){
        var show = function(){
            if ((__env.debug && __env.verbose))
                console.log('Show Data Preloader...');

            return true;
        }
        var hide = function(force){

            // If not forcing removal of preloader
            // and configuration not loaded or user token not set
            // let the preloader remain
            if (!force && !tspCookies.get('token'))
            {
                if ((__env.debug && __env.verbose))
                    console.log('Deny Removal of App Preloader...');

                return true;
            }
            else
            {
                if ((__env.debug && __env.verbose))
                    console.log('Hide App Preloader...');

                return false;
            }
        }

        return{
            show: show,
            hide: hide
        };
    }

    tspResourceHelper.$inject = ['__env', '$injector', '$window', '$state', 'SweetAlert'];
    function tspResourceHelper(__env, $injector, $window, $state, SweetAlert){

        function processResult(result, show_alerts, successFunc, failFunc){
            // process results
            if (result === undefined || result == null)
            {
                if (!(__env.debug && __env.verbose))
                {
                    console.log('Bad response');
                    console.log(result);
                }

                failFunc();

                if (show_alerts)
                    SweetAlert.alert("Unknown error occurred. Please contact your system administrator.", {title: "Error occurred", type: "error"});
            }
            else if (result.response === undefined || result.response == null)
            {
                if (!(__env.debug && __env.verbose))
                {
                    console.log('Bad response with no response');
                    console.log(result);
                }

                failFunc();

                if (show_alerts)
                    SweetAlert.alert("Unknown error occurred. Please contact your system administrator.", {title: "Error occurred", type: "error"});
            }
            else if (result.response.success !== undefined && result.response.success != null)
            {
                if (!(__env.debug && __env.verbose))
                {
                    console.log('Success response');
                    console.log(result);
                }

                successFunc(result.data);

                if (show_alerts)
                    SweetAlert.alert(result.response.success.message, {title: result.response.success.title, type: result.response.success.type});
            }
            else if (result.response.error !== undefined && result.response.error != null)
            {
                if (!(__env.debug && __env.verbose))
                {
                    console.log('Error response');
                    console.log(result);
                }

                failFunc();

                if (show_alerts)
                    SweetAlert.alert(result.response.error.message, {title: result.response.error.title, type: result.response.error.type});
            }
            else
            {
                if (!(__env.debug && __env.verbose))
                {
                    console.log('Other response');
                    console.log(result);
                }

                failFunc();

                if (show_alerts)
                    SweetAlert.alert('Sorry, looks like that info is invalid. Please check your info and try again.', {title: "Warning", type: "warning"});
            }
        }

        function redirectResult(result){
            // process results
            if (result.response === undefined || result.response == null)
            {
                if ((__env.debug && __env.verbose))
                {
                    console.log('Bad response');
                    console.log(result);
                }
            }
            // if access_granted flag used, redirect user to the appropriate area
            else if (result.response.access_granted !== undefined && result.response.access_granted != null)
            {
                if (result.response.access_granted) {

                    if (result.response.url !== undefined && result.response.url != null)
                    {
                        var url = result.response.url;

                        // @TODO: Determine if this works in app mode
                        // In order for cookies to set, the location HAS TO be redirected
                        // DO NOT REMOVE THIS CODE TO MAKE WORK FOR APP unless you determine
                        // a way to make it work for both app and web
                        setTimeout(function(){
                            $window.location.replace(url);
                        }, 1000);
                    }
                    else
                        $state.go('app.properties');
                }
                else{
                    if (result.response.url !== undefined && result.response.url != null)
                    {
                        var url = result.response.url;
                        var path = result.response.path; // for apps

                        // @TODO: Determine how to make this work for app mode (NOT MOBILE MODE)
                        // In order for cookies to set, the location HAS TO be redirected
                        // DO NOT REMOVE THIS CODE TO MAKE WORK FOR APP unless you determine
                        // a way to make it work for both app and web
                        var app_mode = false;

                        setTimeout(function(){
                            if (!app_mode)
                                $window.location.replace(url);
                            else
                                $state.go(path);
                        }, 1000);
                    }
                    else
                        $state.go('login');
                }
            }
            else
            {
                if ((__env.debug && __env.verbose))
                {
                    console.log('Access permissions not restricted.');
                }
            }
        }

        return{
            process: function(resource, show_alerts, successFunc, failFunc){

                var success = false;

                if (resource)
                {
                    var promise;

                    if (resource.$promise !== undefined && resource.$promise != null)
                    {
                        promise = resource.$promise;
                        promise.then(function(result){
                            processResult(result, show_alerts, successFunc, failFunc);
                        });
                    }
                    else
                    {
                        promise = resource;
                        promise.success(function(result){
                            processResult(result, show_alerts, successFunc, failFunc);
                        });
                        promise.error(function (result) {
                            processResult(result, show_alerts, successFunc, failFunc);
                        });
                    }
                }
                else{
                    if ((__env.debug && __env.verbose))
                    {
                        console.log('Bad resource');
                        console.log(resource);
                    }

                    failFunc();

                    if (show_alerts)
                        SweetAlert.alert('Sorry, looks like that info is invalid. Please check your info and try again.', {title: "Warning", type: "warning"});
                }

                return success;
            },
            handle: function (resource, show_alerts, successFunc, failFunc){
                processResult(resource, show_alerts, successFunc, failFunc);
            },
            redirect: function(resource){
                if (resource)
                {
                    var promise;

                    if (resource.$promise !== undefined && resource.$promise != null)
                    {
                        promise = resource.$promise;

                        promise.then(function(result){
                            redirectResult(result);
                        });
                    }
                    else
                    {
                        promise = resource;
                        promise.success(function(result){
                            redirectResult(result);
                        });
                        promise.error(function (result) {
                            redirectResult(result);
                        });
                    }
                }
                else{
                    if ((__env.debug && __env.verbose))
                    {
                        console.log('Bad resource');
                        console.log(resource);
                    }
                }
            }
        }
    }

    tspJqueryService.$inject = ['$window'];
    function tspJqueryService($window) {
        return $window.jQuery; // assumes jQuery has already been loaded on the page
    }

    tspRestService.$inject = ['$rootScope', '__env', '$injector', '$resource'];
    function tspRestService($rootScope, __env, $injector, $resource){

        function errorHandler(response) {
            if (response.status == -1)
            {
                var alert = {
                    pos: 'topRight',
                    model: 'fade',
                    type: 'danger',
                    msg: 'Warning: No server connection!',
                }
                $rootScope.$emit("createAlert", alert);
            }
        }

        var api = __env.api + '/:object/:action/:id';

        var tspRestService = $resource(api, {object: '@object', action: '@action', id: '@id'}, {
            query: {
                method: 'POST', //override from GET
                isArray: false, //override from true
                headers: {'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8'},
                interceptor: {responseError: errorHandler}
            }
        });

        return tspRestService;
    }

    tspHttpService.$inject = ['__env', '$injector', '$http'];
    function tspHttpService(__env, $injector, $http){

        return {
            send: function(route, data){
                var api = __env.api + route;

                if ((__env.debug && __env.verbose))
                    console.log('Sending data to ' + api);

                return $http({
                    method: 'POST',
                    url: api,
                    data: data,
                    headers: {'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8'}
                });
            }
        }
    }

    tspFilterType.$inject = ['$injector'];
    function tspFilterType($injector){
        if ((__env.debug && __env.verbose))
        {
            console.log('Filtering...');
        }

        return function(items,owners,code){
            if ((__env.debug && __env.verbose))
            {
                console.log('Filter Input: ');
                console.log(items);
                console.log(owners);
                console.log(code);
            }

            var owner = "";
            var results = {};

            angular.forEach(owners, function(data) {
                if (data.code == code) {
                    owner = data.owner;
                }
            });

            angular.forEach(items, function(data, index) {
                if (data.owner == owner) {
                    results.push(data);
                }
            });

            return results;
        }
    }

    tspFilterTruncate.$inject = ['$injector'];
    function tspFilterTruncate($injector){
        return function(string,len){
            if (string !== undefined && string !== null)
            {
                if (string.length > len)
                {
                    string = jQuery.trim(string).substring(0, len) + "...";
                }
            }
            return string;
        }
    }

    tspFilterPhone.$inject = ['$injector'];
    function tspFilterPhone($injector){
        return function(tel){
            if (!tel) { return ''; }

            var value = tel.toString().trim().replace(/^\+/, '');

            if (value.match(/[^0-9]/)){
                return tel;
            }

            var country, city, number;

            switch(value.length){
                case 10:
                    country = 1;
                    city = value.slice(0,3);
                    number = value.slice(3);
                    break;
                case 11:
                    country = value[0];
                    city = value.slice(1,4);
                    number = value.slice(4);
                    break;

                case 12:
                    country = value.slice(0,3);
                    city = value.slice(3,5);
                    number = value.slice(5);
                    break;
                default:
                    return tel;
            }

            if (country == 1)
                country = "";

            number = number.slice(0,3) + '-' + number.slice(3);

            return (country + ' (' + city + ') ' + number).trim();
        }
    }

    tspFilterPrettyNull.$inject = ['$injector'];
    function tspFilterPrettyNull($injector){
        return function(string){
            if (!string || string === undefined || string === null || string.length == 0) {
                 return "\
<table class='table'> \
    <tr> \
        <td align='center' class='empty-table'> \
            <em>No Data Found</em> \
        </td> \
    </tr> \
</table>" ;
            }
            else
                return string;
        }
    }

    tspFilterSeconds.$inject = ['__env', '$injector', '$filter'];
    function tspFilterSeconds(__env, $injector, $filter){
        return function(seconds, is_milliseconds){

            if (is_milliseconds)
                seconds = seconds / 1000;

            var hrs = Math.floor((seconds % 86400) / 3600);
            var mns = Math.floor(((seconds % 86400) % 3600) / 60);
            var scs = ((seconds % 86400) % 3600) % 60;

            return hrs + " Hours " + mns + " Minutes " + scs + " Seconds";
        };
    }

    tspFilterYesNo.$inject = ['$injector'];
    function tspFilterYesNo($injector){
        return function(string, affirm, deny){
            var value = ((!isNaN(parseInt(string)) && parseInt(string) == 1) || string == "true" || string == true) ? "<span class='success'>" + affirm + "</span>" : "<span class='danger'>" + deny + "</span>";
            return value;
        }
    }
})();
    
    