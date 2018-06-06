<?php
/**
 * Enroll123 Processor
 *
 * @package		Enroll123
 * @filename	config.php
 * @version		1.0.0
 * @author		Sharron Denice, The Software People (www.thesoftwarepeople.com)
 * @copyright	Copyright 2017 The Software People (www.thesoftwarepeople.com). All rights reserved
 * @license		APACHE v2.0 (http://www.apache.org/licenses/LICENSE-2.0)
 * @brief		Configuration functionality
 *
 */

defineConstant('TESTING',                       true);
defineConstant('TESTER',                        '');

defineConstant('APP_NAME',                     'The Professional');
defineConstant('COMPANY_NAME',                 'Let A Pro Do It!');
defineConstant('DEFAULT_PAGE_SIZE',             25);
defineConstant('COMPANY_CODE',                 'LAPDI');

defineConstant('ABSPATH',                       dirname(__FILE__) . '/');
defineConstant('ROOTPATH',                      dirname(__FILE__) . '/');
defineConstant('IMAGESPATH',                    ABSPATH . 'assets/images');
defineConstant('UPLOADPATH',                    ROOTPATH . 'uploads');
defineConstant('SITEISLOCAL',                   isOnLocalHost());
defineConstant('ONE_DAY',                           time()+60*60*24);


// @TODO Figure out how to use timezones properly
defineINI('date.timezone',                      'America/Chicago');
defineINI('max_execution_time',                 300); //300 seconds = 5 minutes

$global_misc = array(
    'show_countries'        => true,
    'default_country'       => 'US',
    'valid_live_domains'    => array('api.letaprodoit.com'),
    'valid_debug_domains'   => array('localhost:2000','localhost:3000','192.168.1.154:2000', '192.168.1.154:3000',
                                    '127.0.0.1','::1','api.letaprodoit.com'),
    'engineers'             => array(
        '24.197.30.180', // Sharron Denice - Hotel
        '72.168.177.185', // Sharron Denice - Home
        '127.0.0.1', // localhost
        '::1', // localhost
    ),
);

require ABSPATH . 'config.db.php';

$global_databases = array(
    'live' => array(
        'database' => new TSP_DatabaseConn(DB_NAME, DB_USER, DB_PASS, DB_HOST),
    ),
    'test' => array(
        'database' => new TSP_DatabaseConn(DB_NAME, DB_USER, DB_PASS, DB_HOST),
    ),
);

$global_checksums = array(
    'admin_key' 	    => 'M5p34RlAMgjk',
    'secret_key'        => 'GCi1#3%a75TFrW5^',
);

$global_contacts = array(
    'default' 		    => new TSP_UserContact('Web','Master','webmaster@letaprodoit.com'),
    'admin' 		    => new TSP_UserContact('Sharron','Denice','sharron@letaprodoit.com'),
);


$protocol 	= "http";
$domain		= isset($_SERVER['HTTP_HOST']) ? $_SERVER['HTTP_HOST'] : "";

if (isset($_SERVER['HTTPS']) &&  $_SERVER['HTTPS'] == 'on')
    $protocol = "https";

defineConstant('PROTOCOL',   $protocol);

TSP_Settings::$live                 = false;
TSP_Settings::$live_payment         = false;
TSP_Settings::$debug                = true;

TSP_Settings::$file_debug           = './log-debug.log';
TSP_Settings::$file_error           = './log-error.log';

TSP_Settings::$admin_email          = "webmaster@letaprodoit.com";
TSP_Settings::$admin_name           = "Let A Pro Do It!";
TSP_Settings::$admin_from_email     = "no-reply@letaprodoit.com";
TSP_Settings::$admin_from_name      = "Let A Pro Do It!";
TSP_Settings::$admin_notify         = true;

TSP_Settings::$cookie_prefix        = "PRO-";

TSP_Settings::$domain               = $domain;
//TSP_Settings::$domain_uri           = PROTOCOL . "://{$domain}/pro";
TSP_Settings::$domain_uri           = PROTOCOL . "://{$domain}";

TSP_Settings::$smtp_live    = true;
TSP_Settings::$smtp_host    = "mail.letaprodoit.com";
TSP_Settings::$smtp_port    = 465;
TSP_Settings::$smtp_user    = "no-reply@letaprodoit.com";
TSP_Settings::$smtp_pass    = "C1+P5OI9#LMH93aj+M";

TSP_Settings::$contacts             = $global_contacts;
TSP_Settings::$checksums            = $global_checksums;
TSP_Settings::$misc                 = $global_misc;

if (TSP_Config::get('app.live'))
    TSP_Settings::$databases        = $global_databases['live'];
else
    TSP_Settings::$databases        = $global_databases['test'];


startConfiguration();

/**
 * Function to define constants safely
 * @return none
 */
function defineConstant($name, $value){
    if ( !defined($name) ){define($name, $value);}
}
/**
 * Function to define PHP INI values safely
 * @return none
 */
function defineINI($name, $value)
{
    if ( !ini_get($name) ){ini_set($name, $value);}
}
/**
 * Function to determine if we are on localhost
 * @return  boolean
 */
function isOnLocalHost(){

    if (array_key_exists('REMOTE_ADDR', $_SERVER))
        $localHostCheck = array_search($_SERVER['REMOTE_ADDR'], array("127.0.0.1","::1"));
    else
        $localHostCheck = true;

    return ($localHostCheck !== false);
}
/**
 * Function to get config values based on LIVE/TEST state
 * @return String
 */
function getConfigVal($key){
    global $global_authentication, $global_databases, $global_payments;

    if (TSP_Config::get('app.live'))
    {
        if (array_key_exists($key, $global_authentication['live']))
            return $global_authentication['live'][$key];
        else if (array_key_exists($key, $global_databases['live']))
            return $global_databases['live'][$key];
        else if (array_key_exists($key, $global_payments['live']))
            return $global_payments['live'][$key];
        else
            return null;
    }
    else
    {
        // by default assume that no test key is defined
        $test = 'test';
        $test_key_defined = false;

        // if a tester is defined then only use the TESTER
        // key for those configs that require it
        if (defined('TESTER'))
            $test_key_defined = true;

        if (array_key_exists($key, $global_authentication[$test]))
        {
            if ($test_key_defined)
                $test = 'test.' . TESTER;

            if (isset($global_authentication[$test]))
                return $global_authentication[$test][$key];
            else
                return null;
        }
        else if (!TSP_Config::get('app.live') && array_key_exists($key, $global_databases[$test]))
        {
            if ($test_key_defined)
                $test = 'test.' . TESTER;

            return $global_databases[$test][$key];
        }
        else if (!TSP_Config::get('app.live') && array_key_exists($key, $global_payments[$test]))
            return $global_payments[$test][$key];
        else
            return null;
    }
}
/**
 * Function to start configurating site
 * @return none
 */
function startConfiguration()
{
    // Before requiring the loader.php you have the option
    // to set the $testing variable to put the site partially
    // in test mode, no other components will be affected
    if (defined('TESTING') ||
        (defined('TESTING') && !defined('TESTER')) ||
        (isset($_REQUEST['tester']) && !empty($_REQUEST['tester'])) ||
        (isset($_COOKIE[TSP_Config::get('app.cookie_prefix') . 'tester']) && !empty($_COOKIE[TSP_Config::get('app.cookie_prefix') . 'tester'])))
    {
        TSP_Settings::$debug        = true;
        TSP_Settings::$live         = false;

        if (isset($tester))
            defineConstant('TESTER',        $tester);
        else if (isset($_REQUEST['tester']))
            defineConstant('TESTER',        $_REQUEST['tester']);
        else if (isset($_COOKIE['tester']))
            defineConstant('TESTER',        $_COOKIE[TSP_Config::get('app.cookie_prefix') . 'tester']);

        if (defined('TESTER') && isset($_REQUEST['tester']))
            setcookie(TSP_Config::get('app.cookie_prefix') . 'tester', $_REQUEST['tester']);
    }
    else
    {
        TSP_Settings::$debug        = false;
        TSP_Settings::$live         = true;
    }

    $ip = @$_SERVER['REMOTE_ADDR'];

    if (in_array($ip, TSP_Config::get('app.misc.engineers')))
        defineConstant('ENGINEER', true );

    if (TSP_Config::get('app.live'))
    {
        error_reporting( E_ALL ^ E_NOTICE );
        defineINI( 'display_errors',    false );
        defineINI( 'log_errors',        true );
        defineINI( 'error_log',         TSP_Config::get('app.file_error') );
    }//endif
    else
    {
        error_reporting( E_ALL ^ E_NOTICE );
        defineINI( 'display_errors',    true );
        defineINI( 'log_errors',        true );
        defineINI( 'error_log',         TSP_Config::get('app.file_error') );
    }
}