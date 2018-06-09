<?php
    /**
     * Enrollment Processor
     *
     * @package		Enrollment
     * @filename	routes.php
     * @version		1.0.0
     * @author		Sharron Denice, The Software People (www.thesoftwarepeople.com)
     * @copyright	Copyright 2016 RS Agency Services (www.rsagencyservices.com). All rights reserved
     * @license		APACHE v2.0 (http://www.apache.org/licenses/LICENSE-2.0)
     * @brief		Enrollment functionality
     *
     */	

     $routes = array(

         /* Property Controller */
         'property/empty'                                         => 'CProperty@getEmptydata',
         'property/metadata'                                      => 'CProperty@getMetadata',
         'property/create'                                        => 'CProperty@createRecord',
         'property/update'                                        => 'CProperty@updateRecord',
         'property/delete'                                        => 'CProperty@deleteRecord',
         'property/deactivate'                                    => 'CProperty@deactivateRecord',
         'property/activate'                                      => 'CProperty@activateRecord',
         'property/info/{ID}'                                     => 'CProperty@getPropertyInfoByID',

         /* Property Model */
         'property/page'                                          => 'Property@getAllWithOffset',
         'property/list'                                          => 'Property@getAll',

         /* Reservation Controller */
         'reservation/empty'                                         => 'CReservation@getEmptydata',
         'reservation/metadata'                                      => 'CReservation@getMetadata',
         'reservation/create'                                        => 'CReservation@createRecord',
         'reservation/update'                                        => 'CReservation@updateRecord',
         'reservation/delete'                                        => 'CReservation@deleteRecord',
         'reservation/deactivate'                                    => 'CReservation@deactivateRecord',
         'reservation/activate'                                      => 'CReservation@activateRecord',
         'reservation/info/{ID}'                                     => 'CReservation@getReservationInfoByID',

         /* Reservation Model */
         'reservation/page'                                          => 'Reservation@getAllWithOffset',
         'reservation/list'                                          => 'Reservation@getAll',

        /* System Class */
        'system/install'                                        => 'System@installDatabase',
         'system/init'                                          => 'System@init',

        /* User Controller */
        'user/current'                                          => 'CUser@getCurrentUser',
        'user/metadata'                                         => 'CUser@getMetadata',
        'user/create/{type}'                                    => 'CUser@addRecord',
        'user/update/products'                                  => 'CUser@updateProducts',
        'user/update/dependents'                                => 'CUser@updateDependents',
        'user/update'                                           => 'CUser@updateRecord',
        'user/delete'                                           => 'CUser@deleteRecord',
        'user/deactivate'                                       => 'CUser@deactivateRecord',
        'user/activate'                                         => 'CUser@activateRecord',
        'user/auth'                                             => 'CUser@auth',
        'user/login'                                            => 'CUser@login',
        'user/logout'                                           => 'CUser@logout',
        'user/register'                                         => 'CUser@register',
        'user/info/{type}/{ID}'                                 => 'CUser@getUserInfoByID',
        'user/info'                                             => 'CUser@getCurrentUserInfo',

        'user/profile/update/{type}/{ID}'                       => 'CUser@updateProfile',

        /* User Models */
        // pass in current_page and page_size
        'user/page/users'                                       => 'User@getAllWithOffset', // pass in current_page and page_size
        'user/page/admins'                                      => 'Admin@getAllWithOffset',
        'user/page/agents'                                      => 'Agent@getAllWithOffset',
        'user/page/general_agents'                              => 'GeneralAgent@getAllWithOffset',
        'user/page/clients'                                     => 'Client@getAllWithOffset',
        'user/page/employees'                                   => 'Employee@getAllWithOffset',

        'user/list/users'                                       => 'User@getAll',
        'user/list/admins'                                      => 'Admin@getAll',
        'user/list/agents'                                      => 'Agent@getAll',
        'user/list/general_agents'                              => 'GeneralAgent@getAll',
        'user/list/clients'                                     => 'Client@getAll',
        'user/list/employees'                                   => 'Employee@getAll',
        'user/list/{type}'                                      => 'User@getAllWithUserType',

        'user/count/users'                                      => 'User@getUserCount',
        'user/count/admins'                                     => 'Admin@getUserCount',
        'user/count/agents'                                     => 'Agent@getUserCount',
        'user/count/general_agents'                             => 'GeneralAgent@getUserCount',
        'user/count/clients'                                    => 'Client@getUserCount',
        'user/count/employees'                                  => 'Employee@getUserCount',

         /* Type Model */
         'type/list/types'                                      => 'Type@getAll',
     );