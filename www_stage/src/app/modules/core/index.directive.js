(function() {
    'use strict';

    angular.module('proApp.core.directives', [
        'ngSanitize',
        'ui.router',
        'ui.bootstrap',
        'ngAnimate',
        'ngStorage',
        'FBAngular'
    ])
        .directive('toggleNavMin', toggleNavMin)
        .directive('collapseNavAccordion', collapseNavAccordion)
        .directive('toggleOffCanvas', toggleOffCanvas)
        .directive('highlightActive', highlightActive)
        .directive('uiCheckbox', uiCheckbox)
        .directive('customScrollbar', customScrollbar)
        .directive('customPage', customPage)
        .directive('inputGroupNoBorder', inputGroupNoBorder)
        .directive('inputGroupTransparent', inputGroupNoBorder)
        .directive('ajaxLoad', ajaxLoad)
        .directive('snProgressAnimate', snProgressAnimate)
        .directive('animateNumber', animateNumber)
        .directive('checkAll', checkAll)
        .directive('tspSocialWidget', tspSocialWidget)
        .directive('tspObjectWidget', tspObjectWidget)
        .directive('tspWidget', tspWidget)
        .directive('tspSortableWidget', tspSortableWidget)
        .directive('tspFieldWidget', tspFieldWidget)
        .directive('tspFormWidget', tspFormWidget)
        .directive('tspTableWidget', tspTableWidget)
        .directive('tspPanelWidget', tspPanelWidget)
        .directive('tspPanelContainer', tspPanelContainer)
        .directive('tspI18n', tspI18n)
        .directive('tspFormat', tspFormat)
        .directive('tspLineItem', tspLineItem)
    ;

    tspSocialWidget.$inject = [];
    function tspSocialWidget() {

        return {
            restrict: 'E',
            scope: {
                label:         '@',
                locale:        '@',
                lang:          '=', // pass in scope.lang if necessary
                placeVal:      '@',
                fieldData:     '=',
                fieldKey:      '@',
                optionData:    '=',
                filterBy:      '=',
                isRequired:    '='
            },
            templateUrl: 'app/modules/core/templates/social-widget.html',
            link: function(scope, el, attrs) {

                scope.addSMAccount = function(){
                    var account_obj = {};   // Create an object
                    account_obj.username = ''; // Add values, etc.
                    account_obj.title = 'Social Media';
                    account_obj.type_id = 0;

                    scope.fieldData[scope.fieldKey].push(account_obj);
                }

                scope.removeSMAccount = function(){
                    if (scope.fieldData[scope.fieldKey].length > 1)
                        scope.fieldData[scope.fieldKey].pop();
                }

                scope.setSMAccount = function(pos,label,id){
                    scope.fieldData[scope.fieldKey][pos].username = '';
                    scope.fieldData[scope.fieldKey][pos].title = label;
                    scope.fieldData[scope.fieldKey][pos].type_id = id;
                }
            }
        }
    }

    tspObjectWidget.$inject = ['$modal'];
    function tspObjectWidget($modal) {

        return {
            restrict: 'E',
            scope: {
                type:               '@', // the field type
                label:              '@',
                info:               '@',
                lang:               '=', // pass in scope.lang if necessary
                locale:             '@', // for dates and currency
                prefix:             '@',
                suffix:             '@',
                placeVal:           '@',
                placeValData1:      '@',
                placeValData2:      '@',
                placeValData3:      '@',
                placeValData4:      '@',
                fieldData:          '=',
                fieldKey:           '@',
                owner:              '@',
                optionData:         '=',
                optionData1:        '=',
                optionData2:        '=',
                optionData3:        '=',
                optionData4:        '=',
                filterBy:           '=',
                filterByData1:      '=',
                filterByData2:      '=',
                filterByData3:      '=',
                filterByData4:      '=',
                groupBy:            '=',
                isRequired:         '=',

                idKey:              '@',
                titleKey:           '@',
                descKey:            '@',
                showAdd:            '=',
                add:                '&onAdd',
                edit:               '&onEdit',
                toggle:             '&onToggle',
                delete:             '&onDelete',
                update:             '&onChange'
            },
            templateUrl: 'app/modules/core/templates/object-widget.html',
            link: function(scope, el, attrs) {

                if (scope.idKey === undefined || scope.idKey == null || scope.idKey == '')
                    scope.idKey = '_id';
                if (scope.titleKey === undefined || scope.titleKey == null || scope.titleKey == '')
                    scope.titleKey = 'title';
                if (scope.descKey === undefined || scope.descKey == null || scope.descKey == '')
                    scope.descKey = 'description';

                scope.loadObject = function(owner, action, data, lang) {

                    var modalCtrl = "";
                    var object = "";
                    var routes = "";
                    var size = "md";

                    switch(owner)
                    {
                        case 'C':
                            object = "Company";
                            routes = "companies";
                            break;
                        case 'AO':
                            object = "Profession";
                            routes = "professions";
                            break;
                        case 'M':
                            object = "Event";
                            routes = "events";
                            break;
                        default:
                            break;
                    }

                    $modal.open({
                        templateUrl: 'app/modules/core/templates/object-modal.html',
                        size: size,
                        controller: "ModalCtrl",
                        resolve: {
                            lang: function(){
                                return lang;
                            },
                            postdata: function(){
                                return data;
                            },
                            action: function() {
                                return action;
                            },
                            object: function() {
                                return object;
                            },
                            routes: function() {
                                return routes;
                            },
                        }
                    });

                };
                scope.addObject = function(obj, input){
                    var new_obj = {};   // Create an object
                    // Do not add other objects here as it will distort the object-widget

                    if (obj !== undefined && obj !== null)
                        new_obj = obj;

                    if (input !== undefined && input !== null)
                    {
                        var elem_str = jQuery('#' + input).val();
                        var elem_arr = elem_str.split(',');

                        angular.forEach(elem_arr, function(title){
                            scope.fieldData[scope.fieldKey].push({
                                title: title
                            });
                        });

                        jQuery('#' + input).val("");
                    }
                    else
                        scope.fieldData[scope.fieldKey].push(new_obj);
                }
                scope.removeObject = function(pos, remove_all){

                    if (remove_all === undefined || remove_all === null)
                        remove_all = false;

                    if (pos !== undefined && pos !== null && scope.fieldData[scope.fieldKey].length > 1)
                    {
                        scope.fieldData[scope.fieldKey].splice(pos, 1);
                    }
                    else
                    {
                        if (remove_all || scope.fieldData[scope.fieldKey].length > 1)
                            scope.fieldData[scope.fieldKey].pop();
                    }
                }

                scope.updateControlOnCallback = function(obj, key){
                    scope.toggle({
                        successFunc: function(data){
                            obj[key] = data;
                        },
                        failFunc: function(){
                            obj[key] = "";
                        }
                    });
                }
            }
        }
    }

    tspTableWidget.$inject = ['tspDate'];
    function tspTableWidget(tspDate) {

        return {
            restrict: 'E',
            scope: {
                type:           '@', // the field type
                lang:           '=', // pass in scope.lang if necessary
                isRequired:     '=', // is the field required

                index:          '=', // $index of ng-repeat
                filterBy:       '=', // used in conjunction with ng-repeat
                orderBy:        '=', // used in conjunction with ng-repeat
                fieldData:      '=', // the record of ng-repeat
                fieldKey:       '@', // the index of record - record[fieldKey]
                placeVal:       '@', // the placeholder value of the field, usually used for selects and other dropdowns
                pattern:        '@', // used for ng-pattern
                prefix:         '@', // Text to display before title listings

                recordId:       '@', // the ID of the record
                label:          '@', // the label for the field for <label> tag
                suffix:         '@', // sub label, usually placed below some label or title
                optionData:     '=', // array of data used to populate selects or to store data values
                showAvatar:     '=', // show the fields avatar
                hideLabel:      '=', // hide the fields <label>
                showAdd:        '=', // show the add button (to add new record)
                showTitle:      '=', // avatar type: show the name of the user
                mobileHeader:   '=',
                showDesc:       '=', // avatar type: show the name of the user
                isFeatured:     '=', // avatar type: is the logo featured
                isPhoto:        '=', // avatar type: is the photo for profile
                isLogo:         '=', // avatar type: is the logo for company
                isThumbnail:    '=', // avatar type: is the image a thumbnail
                isHighlighted:  '=', // default type: highlight text
                numRows:        '@', // textarea: the number of rows of the text area
                idKey:          '@', // select: the default ID key for option data - defaults to _id
                titleKey:       '@', // select: the default title key for option data - defaults to title
                descKey:        '@', // select: the default description key for option data - defaults to description

                fileType:       '@',
                fileExt:        '@',
                locale:         '@', // for dates and currency
                format:         '@', // for dates
                formatHours:    '@', // for dates
                intervalMins:   '@', // for dates
                owner:          '@', // used for module windows to determine the type of record to add
                add:            '&onAdd',
                edit:           '&onEdit',
                toggle:         '&onToggle',
                delete:         '&onDelete',
                update:         '&onChange'

            },
            templateUrl: 'app/modules/core/templates/table-widget.html',
            link: function(scope, el, attrs) {

                if (scope.idKey === undefined || scope.idKey == null || scope.idKey == '')
                    scope.idKey = '_id';
                if (scope.titleKey === undefined || scope.titleKey == null || scope.titleKey == '')
                    scope.titleKey = 'title';
                if (scope.descKey === undefined || scope.descKey == null || scope.descKey == '')
                    scope.descKey = 'description';

                if (scope.locale === undefined || scope.locale == null || scope.locale == '')
                    scope.locale = 'en';
                if (scope.format === undefined || scope.format == null || scope.format == '')
                    scope.format = 'MM/DD/YYYY hh:mm A';
                if (scope.formatHours === undefined || scope.formatHours == null || scope.formatHours == '')
                    scope.formatHours = 'hh:[00]';
                if (scope.intervalMins === undefined || scope.intervalMins == null || scope.intervalMins == '')
                    scope.intervalMins = 30;

                scope.dateToString = function(secs, format){
                    return tspDate.toString(secs, format);
                }
            }
        }
    }

    tspFieldWidget.$inject = ['tspDate'];
    function tspFieldWidget(tspDate) {

        return {
            restrict: 'E',
            scope: {
                type:               '@', // the field type
                lang:               '=', // pass in scope.lang if necessary
                isRequired:         '=', // is the field required
                isReadonly:         '=',

                index:              '=', // $index of ng-repeat
                filterBy:           '=', // used in conjunction with ng-repeat
                orderBy:            '=', // used in conjunction with ng-repeat
                fieldData:          '=', // the record of ng-repeat
                fieldKey:           '@', // the index of record - record[fieldKey]
                placeVal:           '@', // the placeholder value of the field, usually used for selects and other dropdowns
                pattern:            '@', // used for ng-pattern
                prefix:             '@', // Text to display before title listings

                recordId:           '@', // the ID of the record
                label:              '@', // the label for the field for <label> tag
                suffix:             '@', // sub label, usually placed below some label or title
                optionData:         '=', // array of data used to populate selects or to store data values
                //showAvatar:       '=', // show the fields avatar
                hideLabel:          '=', // show the fields <label>
                showAdd:            '=', // show the add button (to add new record)
                showTitle:          '=', // avatar type: show the name of the user
                showDesc:           '=', // avatar type: show the name of the user
                //isHighlighted:    '=', // default type: highlight text
                numRows:            '@', // textarea: the number of rows of the text area
                idKey:              '@', // select: the default ID key for option data - defaults to _id
                titleKey:           '@', // select: the default title key for option data - defaults to title
                descKey:            '@', // select: the default description key for option data - defaults to description

                sliderType:         '@', // percent, amount or default, slider type
                sliderMinValue:     '@', // slider type
                sliderMaxValue:     '@', // slider type
                sliderStepValue:    '@', // slider type
                sliderOrientation:  '@', // slider type

                dzOptions:           '=', //dropzone options
                dzCallbacks:         '=', //dropzone callbacks
                dzMethods:           '=', //dropzone methods

                decimalPlaces:      '@', // tsp-format type

                locale:             '@', // for dates and currency
                format:             '@', // for dates
                formatHours:        '@', // for dates
                intervalMins:       '@', // for dates
                minDate:            '=',
                maxDate:            '=',

                owner:              '@', // used for module windows to determine the type of record to add
                add:                '&onAdd',
                edit:               '&onEdit',
                toggle:             '&onToggle',
                delete:             '&onDelete',
                update:             '&onChange'
            },
            templateUrl: 'app/modules/core/templates/field-widget.html',
            link: function(scope, el, attrs) {

                if (scope.decimalPlaces === undefined || scope.decimalPlaces == null || scope.decimalPlaces == "")
                    scope.decimalPlaces = 0;

                if (scope.idKey === undefined || scope.idKey == null || scope.idKey == '')
                    scope.idKey = '_id';
                if (scope.titleKey === undefined || scope.titleKey == null || scope.titleKey == '')
                    scope.titleKey = 'title';
                if (scope.descKey === undefined || scope.descKey == null || scope.descKey == '')
                    scope.descKey = 'description';

                if (scope.locale === undefined || scope.locale == null || scope.locale == '')
                    scope.locale = 'en';
                if (scope.format === undefined || scope.format == null || scope.format == '')
                    scope.format = 'MM/DD/YYYY hh:mm A';
                if (scope.formatHours === undefined || scope.formatHours == null || scope.formatHours == '')
                    scope.formatHours = 'hh:[00]';
                if (scope.intervalMins === undefined || scope.intervalMins == null || scope.intervalMins == '')
                    scope.intervalMins = 30;

                scope.initSlider = function(sliderType){
                    el.find( '#tsp-slider' ).slider({
                        min: parseInt(scope.sliderMinValue),
                        max: parseInt(scope.sliderMaxValue),
                        step: parseInt(scope.sliderStepValue),
                        value: parseInt(scope.fieldData[scope.fieldKey]),
                        orientation: scope.sliderOrientation,
                        slide: function( event, ui ) {
                            scope.styleSlider(ui.value, sliderType);
                        }
                    });

                    scope.styleSlider(el.find( '#tsp-slider' ).slider( "value" ), sliderType);

                }
                scope.styleSlider = function(val, type){

                    if (val > 60)
                    {
                        el.find( "#tsp-slider-value" ).addClass('text-success');
                        el.find( "#tsp-slider-value" ).removeClass('text-danger');
                    }
                    else
                    {
                        el.find( "#tsp-slider-value" ).addClass('text-danger');
                        el.find( "#tsp-slider-value" ).removeClass('text-success');
                    }

                    if (type == 'percent')
                    {
                        scope.fieldData[scope.fieldKey] = val + '%';
                    }
                    else if (type == 'amount')
                    {
                        scope.fieldData[scope.fieldKey] = val + '.00';
                    }
                    else
                    {
                        scope.fieldData[scope.fieldKey] = val;
                    }

                }
                scope.updateControlOnCallback = function(obj, key){
                    scope.toggle({
                        successFunc: function(data){
                            obj[key] = data;
                        },
                        failFunc: function(){
                            obj[key] = "";
                        }
                    });
                }

                scope.dateToString = function(secs, format){
                    return tspDate.toString(secs, format);
                }
            }
        }
    }

    tspSortableWidget.$inject = [];
    function tspSortableWidget() {

        return {
            restrict: 'A',
            link: function(scope, el, attrs) {
                // Because of the remove button the user will need to click on it to remove an element
                // check on clicks
                el.click(function(e){
                    var i = 1;
                    angular.forEach(el.find('.tsp-order'), function (item){
                        var angItem = angular.element(item);
                        angItem.val(i);
                        i++;
                    });
                });
                el.sortable({
                    handle: '.tsp-draggable',
                    connectWith: '.tsp-connect-list',
                    placeholder: "tsp-sortable-placeholder",
                    forcePlaceholderSize: true,
                    opacity: 0.8,
                    update: function( event, ui ) {

                        var i = 1;
                        angular.forEach(el.find('.tsp-order'), function (item){
                            var angItem = angular.element(item);
                            angItem.val(i);
                            i++;
                        });

                        //var list = el.sortable( "toArray" );
                        //console.log("List: " + window.JSON.stringify(list));
                    }
                }).disableSelection();
            }
        }
    }

    tspWidget.$inject = [];
    function tspWidget() {

        return {
            restrict: 'E',
            scope: {
                type:        '@',
                lang:        '=', // pass in scope.lang if necessary
                position:    '@',
                text:        '@',
                icon:        '@',
                badge:       '@',
                widgetClass: '@'
            },
            templateUrl: 'app/modules/core/templates/widget.html',
            link: function(scope, el, attrs) {
            }
        }
    }

    tspFormWidget.$inject = [];
    function tspFormWidget() {

        return {
            restrict: 'E',
            transclude: true,
            scope: {
                btnLabel:       '=',
                busyLabel:      '=',
                func:           '&onSubmit'
            },
            templateUrl: 'app/modules/core/templates/form-widget.html',
            link: function(scope, el, attrs) {
            }
        }

    }

    tspPanelWidget.$inject = [];
    function tspPanelWidget() {

        return {
            restrict: 'E',
            transclude: true,
            scope: {
                title:          '@',
                isOpen:         '@'
            },
            templateUrl: 'app/modules/core/templates/panel-widget.html',
            link: function(scope, el, attrs) {
            }
        }

    }

    tspPanelContainer.$inject = [];
    function tspPanelContainer() {

        return {
            restrict: 'E',
            transclude: true,
            templateUrl: 'app/modules/core/templates/panel-container.html',
            link: function(scope, el, attrs) {
            }
        }

    }

    toggleNavMin.$inject = ['$rootScope'];
    function toggleNavMin ($rootScope) {

        return function(scope, el, attrs) {
            var app = $('#app');

            $rootScope.$watch('isMobile', function() {
                if($rootScope.isMobile)
                    app.removeClass('nav-min');
            });

            el.on('touchstart click', function(e) {
                if(!$rootScope.isMobile) {
                    app.toggleClass('nav-min');
                    $rootScope.$broadcast('nav.reset'); // dispatch event downwards notifying the event registerar.
                    $rootScope.$broadcast('chartist.update');	// event register by chartist directive
                }
                e.preventDefault();
            });
        }

    }

    collapseNavAccordion.$inject = ['__env'];
    function collapseNavAccordion(__env){
        return {
            restrict: 'A',
            link: function(scope, el, attrs) {
                var lists = el.find('ul').parent('li'),	// target li which has sub ul
                    a = lists.children('a'),
                    listsRest = el.children('ul').children('li').not(lists),
                    aRest = listsRest.children('a'),
                    app = $('#app'),
                    stopClick = 0;


                a.on('touchstart click', function(e) {
                    if(e.timeStamp - stopClick > 300) {
                        // disable click if nav is in mini-style || horizontal nav
                        if(app.hasClass('nav-min') && window.innerWidth > __env.mobile_width) return;

                        var self = $(this),
                            parent = self.parent('li');
                        a.not(self).next('ul').slideUp();
                        self.next('ul').slideToggle();

                        // hide/show open class
                        lists.not(parent).removeClass('open');
                        parent.toggleClass('open');

                        stopClick = e.timeStamp;
                    }
                    e.preventDefault();
                });

                // slide up nested nav when clicked on arest
                aRest.on('touchstart click', function() {
                    var parent = aRest.parent('li');
                    lists.not(parent).removeClass('open').find('ul').slideUp();
                });

                // reset nav when navigation in mini mode
                scope.$on('nav.reset', function(e) {	// for use in toggleNavMin directive
                    a.next('ul').removeAttr('style');
                    lists.removeClass('open');
                    e.preventDefault();
                });

            }
        }
    }

    // Toggle off-canvas nav in mobile browser
    toggleOffCanvas.$inject = ['$rootScope'];
    function toggleOffCanvas($rootScope) {
        return {
            restrict: 'A',
            link: function(scope, el, attrs) {
                el.on('touchstart click', function() {
                    $('#app').toggleClass('on-canvas');
                });
            }
        }

    }

    // highlight active nav
    highlightActive.$inject = ['$location'];
    function highlightActive($location) {
        return {
            restrict: 'A',
            link: function(scope, el, attrs) {
                var links = el.find('a'),
                    path = function() {return $location.path()},
                    highlightActive = function(links, path) {
                        var path = '#' + path;
                        angular.forEach(links, function(link) {
                            var link = angular.element(link),
                                li = link.parent('li'),
                                href = link.attr('href');

                            if(li.hasClass('active'))
                                li.removeClass('active');
                            if(path.indexOf(href) == 0)
                                li.addClass('active');

                            //console.log(path, href,  path.indexOf(href));
                        });
                    };

                highlightActive(links, $location.path());
                scope.$watch(path, function(newVal, oldVal) {
                    if(newVal == oldVal) return;
                    highlightActive(links, $location.path());
                });
            }
        }

    }

    uiCheckbox.$inject = [];
    function uiCheckbox(){
        return {
            restrict: 'A',
            link: function(scope, el, attrs) {

                el.children().on('touchstart click', function(e) {
                    if(el.hasClass('checked')) {
                        el.removeClass('checked');
                        el.children().removeAttr('checked');
                    }
                    else {
                        el.addClass('checked');
                        el.children().attr('checked', true);
                    }
                    e.stopPropagation();

                });
            }
        }
    }

    customScrollbar.$inject = ['$interval'];
    function customScrollbar($interval){
        return {
            restrict: 'A',
            link: function(scope, el, attrs) {
                // if(!scope.$isMobile) // not initialize for mobile
                // {
                el.perfectScrollbar({
                    suppressScrollX: true
                });

                var scrollHeight = el[0].scrollHeight;
                var clientHeight =  el[0].clientHeight;

                $interval(function() {
                    if(scrollHeight != el[0].scrollHeight &&
                        clientHeight != el[0].clientHeight &&
                        el[0].scrollHeight >= el[0].clientHeight)
                    {
                        scrollHeight = el[0].scrollHeight;
                        clientHeight = clientHeight;
                        el.perfectScrollbar('update');
                    }
                }, 60);

                // }

            }
        }
    }

    customPage.$inject = ['$injector'];
    function customPage($injector){
        return {
            restrict: 'A',
            controller: ['$scope', '$element', '$location', '$rootScope', 'tspDataPreloader', 'tspAppPreloader', function($scope, $element, $location, $rootScope, tspDataPreloader, tspAppPreloader) {
                var path = function() {return $location.path()};
                var addBg = function(path) {

                    $element.removeClass('body-full');

                    switch(path) {
                        case '/404': case '/login' :
                        case '/register' : case '/forgot-pass' :
                        case '/lock-screen' : case '/install' :
                        $element.addClass('body-full');
                        // @TODO I dont like this code here as it is out of place
                        // force removal of preloader for pages
                        $rootScope.loadingApp = tspAppPreloader.hide(true);
                        break;
                        default:
                            // I dont like this code here as it is out of place
                            // hide the preloader in this stage as it is one of the last directives that gets run
                            $rootScope.loadingApp = tspAppPreloader.hide();
                            $rootScope.loadingData = tspDataPreloader.hide();
                            $rootScope.loadingAppText = "";
                            $rootScope.loadingDataText = "";
                            break;
                    }

                };

                addBg($location.path());

                $scope.$watch(path, function(newVal, oldVal) {
                    if(angular.equals(newVal, oldVal)) return;
                    addBg($location.path());
                });

            }]
        }
    }

    // Handle transparent input groups focus
    inputGroupNoBorder.$inject = ['jQuery'];
    function inputGroupNoBorder(jQuery){
        return {
            restrict: 'C',
            link: function(scope, el, attrs) {
                jQuery(el).find('.input-group-addon + .form-control').on('blur focus', function(e){
                    jQuery(this).parents('.input-group')[e.type==='focus' ? 'addClass' : 'removeClass']('focus');
                });
            }
        }
    }

    // Handle transparent input groups focus
    inputGroupTransparent.$inject = ['jQuery'];
    function inputGroupTransparent(jQuery){
        return {
            restrict: 'C',
            link: function(scope, el, attrs) {
                jQuery(el).find('.input-group-addon + .form-control').on('blur focus', function(e){
                    jQuery(this).parents('.input-group')[e.type==='focus' ? 'addClass' : 'removeClass']('focus');
                });
            }
        }
    }

    // Ajax Load micro-plugin
    ajaxLoad.$inject = ['jQuery', '$window'];
    function ajaxLoad(jQuery, $window){
        return {
            restrict: 'A',
            link: function(scope, el, attrs) {
                el.on('click change', function(e){
                    var $this = jQuery(this),
                        $target = jQuery($this.data('ajax-target'));
                    if ($target.length > 0 ){
                        e = jQuery.Event('ajax-load:start', {originalEvent: e});
                        $this.trigger(e);

                        !e.isDefaultPrevented() && $target.load($this.data('ajax-load'), function(){
                            $this.trigger('ajax-load:end');
                        });
                    }
                    return false;
                });

                /**
                 * Change to loading state if loading text present
                 */
                if (attrs.loadingText){
                    el.on('ajax-load:start', function () {
                        $el.button('loading');
                    });
                    el.on('ajax-load:end', function () {
                        $el.button('reset');
                    });
                }

                jQuery($window.document).on('click', '[data-toggle^=button]', function (e) {
                    return jQuery(e.target).find('input').data('ajax-trigger') !== 'change';
                });
            }
        }
    }

    // Animate Progress Bars
    snProgressAnimate.$inject = ['$timeout'];
    function snProgressAnimate($timeout){
        return {
            link: function(scope, el, attrs) {
                var value = el.data('value'),
                    $bar = el.find('.progress-bar');
                $bar.css('opacity', 0);
                $timeout(function(){
                    $bar.css({
                        transition: 'none',
                        width: 0,
                        opacity: 1
                    });
                    $timeout(function(){
                        $bar.css('transition', '').css('width', value + '%');
                    });
                });
            }
        }
    }

    // Animate Number jQuery plugin customized wrapper
    animateNumber.$inject = ['jQuery'];
    function animateNumber(jQuery){
        return {
            link: function(scope, el, attrs) {
                el.animateNumber({
                    number: el.text().replace(/ /gi, ''),
                    numberStep: jQuery.animateNumber.numberStepFactories.separator(' '),
                    easing: 'easeInQuad'
                }, 1000);
            }
        }
    }

    checkAll.$inject = ['jQuery'];
    function checkAll(jQuery){
        return {
            restrict: 'A',
            link: function(scope, el, attrs) {
                el.on('click', function() {
                    el.closest('table').find('input[type=checkbox]')
                        .not(this).prop('checked', jQuery(this).prop('checked'));
                });
            }
        }
    }

    body.$inject = [];
    function body () {
        return {
            restrict: 'E',
            link: function(scope, el, attrs) {
                // prevent unwanted navigation
                el.on('click', 'a[href=#]', function(e) {
                    e.preventDefault();
                });
            }
        }
    }

    tspI18n.$inject = ['__env', '$injector', 'lang', 'tspCookies'];
    function tspI18n(__env, $injector, lang, tspCookies) {

        return {
            restrict: 'A',
            link: function(scope, el, attrs) {
                var lang_code = tspCookies.get('preferences.lang_code');

                if (lang_code === undefined || lang_code === null)
                    lang_code = 'en';

                var data = lang[lang_code]
                var key = attrs.tspI18n;

                try {
                    el.html(eval("data." + key));
                }
                catch(err) {
                    if ((__env.debug && __env.verbose))
                        console.log('Error: ' + err.message);
                }

            }
        }
    }

    tspFormat.$inject = ['$compile','$filter'];
    function tspFormat($compile,$filter){
        return {
            restrict: 'A',
            require: 'ngModel', // require the ngModel directive
            link: function(scope, el, attrs, ctrl) {
                if (!ctrl) return;

                ctrl.$formatters.unshift(function (a) {
                    if (attrs.tspFormat.match(/^number\:/))
                    {
                        var places = attrs.tspFormat.replace("number:", "");
                        return $filter('number')(ctrl.$modelValue, parseInt(places));
                    }
                    else if (attrs.tspFormat.match(/^currency\:/))
                    {
                        var symb_places = attrs.tspFormat.replace("currency:", "");
                        var data = symb_places.split(':');

                        return $filter('currency')(ctrl.$modelValue, data[0], parseInt(data[1]));
                    }
                    else
                        return $filter(attrs.tspFormat)(ctrl.$modelValue);
                });

                el.bind('blur', function(event) {
                    var plainNumber = el.val().replace(/[^\d|\-+|\.+]/g, '');
                    if (attrs.tspFormat.match(/^number\:/))
                    {
                        var places = attrs.tspFormat.replace("number:", "");
                        el.val($filter('number')(plainNumber, parseInt(places)));
                    }
                    else if (attrs.tspFormat.match(/^currency\:/))
                    {
                        var symb_places = attrs.tspFormat.replace("currency:", "");
                        var data = symb_places.split(':');

                        el.val($filter('currency')(plainNumber, data[0], parseInt(data[1])));
                    }
                    else
                        el.val($filter(attrs.tspFormat)(plainNumber));
                });
            }
        };
    }

    tspLineItem.$inject = ['__env', '$injector', '$compile', '$filter', '$parse'];
    function tspLineItem(__env, $injector, $compile, $filter, $parse){
        return {
            restrict: 'E',
            scope:{
                line:        '='
            },
            link: function(scope, el, attrs) {

                var priceKey = 'price';
                var salesKey = 'sale_price';
                var feeKey = 'one_time_fee';

                var priceOverrideKey = 'price_override';
                var salesOverrideKey = 'sale_price_override';
                var feeOverrideKey = 'one_time_fee_override';

                var elems = [
                    {amount: priceKey,  override: priceOverrideKey},
                    {amount: salesKey,  override: salesOverrideKey},
                    {amount: feeKey,    override: feeOverrideKey}
                ];
                
                angular.forEach(elems, function(elem){

                    el.find('input#' + elem.amount).removeClass('text-success');
                    el.find('input#' + elem.amount).removeClass('text-danger');
                    el.find('input#' + elem.amount).removeClass('text-line-through');

                    el.find('input#' + elem.amount).on('change', function(e){
                        if ((__env.debug && __env.verbose))
                            console.log('Line Item Changed');

                        angular.forEach(elems, function(elem){

                            if (!isNaN(scope.line[elem.override]) && parseFloat(scope.line[elem.override]) > parseFloat(scope.line[elem.amount])) {
                                el.find('input#' + elem.amount).removeClass('text-success');
                                el.find('input#' + elem.amount).addClass('text-danger');
                            }
                            else if (!isNaN(scope.line[elem.override]) && parseFloat(scope.line[elem.override]) < parseFloat(scope.line[elem.amount])){
                                el.find('input#' + elem.amount).removeClass('text-danger');
                                el.find('input#' + elem.amount).addClass('text-success');
                            }
                            else{
                                el.find('input#' + elem.amount).removeClass('text-success');
                                el.find('input#' + elem.amount).removeClass('text-danger');
                            }
                        });

                        // if the sale price is set then strike out the regular price
                        if (!isNaN(scope.line[salesKey]) && parseFloat(scope.line[salesKey]) > 0){
                            el.find('input#' + priceKey).addClass('text-line-through');
                        }
                        else if (!isNaN(scope.line[salesKey])){
                            el.find('input#' + priceKey).removeClass('text-line-through');
                        }
                    });

                    if (typeof scope.line[elem.amount] == 'string')
                        scope.line[elem.amount] = scope.line[elem.amount].replace(',','');

                    if (!isNaN(scope.line[elem.override]) && parseFloat(scope.line[elem.override]) > 0){
                        if (parseFloat(scope.line[elem.override]) > parseFloat(scope.line[elem.amount]))
                        {
                            el.find('input#' + elem.amount).removeClass('text-success');
                            el.find('input#' + elem.amount).addClass('text-danger');
                        }
                        else if (parseFloat(scope.line[elem.override]) < parseFloat(scope.line[elem.amount]))
                        {
                            el.find('input#' + elem.amount).removeClass('text-danger');
                            el.find('input#' + elem.amount).addClass('text-success');
                        }
                        else
                        {
                            el.find('input#' + elem.amount).removeClass('text-success');
                            el.find('input#' + elem.amount).removeClass('text-danger');
                        }
                    }
                });

                // if the sale price is set then strike out the regular price
                if (!isNaN(scope.line[salesKey]) && parseFloat(scope.line[salesKey]) > 0){
                    el.find('input#' + priceKey).addClass('text-line-through');
                }
                else if (!isNaN(scope.line[salesKey])){
                    el.find('input#' + priceKey).removeClass('text-line-through');
                }
            }
        };
    }
})();






