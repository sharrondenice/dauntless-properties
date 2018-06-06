<?php
    /**
     * Enroll123 Processor
     *
     * @package		Enroll123
     * @filename	driver.php
     * @version		1.0.2
     * @author		Sharron Denice, The Software People (www.thesoftwarepeople.com)
     * @copyright	Copyright 2016 RS Agency Services (www.rsagencyservices.com). All rights reserved
     * @license		APACHE v2.0 (http://www.apache.org/licenses/LICENSE-2.0)
     * @brief		Driver to test functionality
     *
     */
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Credentials: true');
    header('Access-Control-Allow-Methods: GET,POST,OPTIONS,DELETE,PUT');
    header('Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With');

    date_default_timezone_set('America/Chicago');

    require_once "autoload.php";

    if (empty($_REQUEST))
    {
        ?>
<html>
<head>Testing CDemo</head>
<body>
<form action="http://192.168.1.154:3000/demo/0/0" type="POST">
    <p>Testing <input type="text" id="testing" name="testing" value="1"></p>
    <p>Object <input type="text" id="object" name="object" value=""></p>
    <p>Record ID <input type="text" id="id" name="id" value=""></p>
    <p>Current Company ID <input type="text" id="current_company_id" name="current_company_id" value="1"></p>
    <p>User ID <input type="text" id="user_id" name="user_id" value="1"></p>
    <p>Action <input type="text" id="action" name="action"></p>
    <p>System Only <select type="text" id="system_only" name="system_only"><option value="false">False</option>
            <option value="true">True</option></select></p>
    <p>User Only <select type="text" id="user_only" name="user_only"><option value="false">False</option>
            <option value="true">True</option></select></p>
    <p>Other ID <input type="text" id="other_id" name="other_id"></p>
    <p>Other ID Key <select type="text" id="other_id_key" name="other_id_key">
            <option value=""></option>
            <option value="client_user_id">client_user_id</option>
            <option value="company_id">company_id</option>
            <option value="deliverable_id">deliverable_id</option>
            <option value="fixed_in_release_id">fixed_in_release_id</option>
            <option value="fixed_in_release_id|found_in_release_id">fixed_in_release_id|found_in_release_id</option>
            <option value="found_in_release_id">found_in_release_id</option>
            <option value="owner_id">owner_id</option>
            <option value="project_id">project_id</option>
            <option value="responsible_user_id">responsible_user_id</option>
            <option value="responsible_company_id">responsible_company_id</option>
            <option value="statement_id">statement_id</option>
            <option value="type_id">type_id</option>
            <option value="user_id">user_id</option>
            <option value="worklog_id">worklog_id</option>
        </select></p>
    <p>Type ID <input type="text" id="type_id" name="type_id"></p>
    <p>Owner <input type="text" id="owner" name="owner"></p>
    <p>Owner ID <input type="text" id="owner_id" name="owner_id"></p>
    <p>Country Code <input type="text" id="country_code" name="country_code"></p>
    <p>Lang Code <input type="text" id="lang_code" name="lang_code"></p>
    <p><button type="submit">Submit</button></p>
</form>
</body>
</html>
<?php
    }
    else
    {
        $action = $_REQUEST['action'];

        if ($action == 'tosecs')
            convertDateToSeconds($_REQUEST['date']);

        if ($action == 'tomsecs')
            convertDateToMilliSeconds($_REQUEST['date']);

        if ($action == 'genpass')
            generateHashPassword($_REQUEST['password']);

    }

    function convertToInt($val){
        echo floatVal($val);
    }

    function convertDateToMilliSeconds($date)
    {
        echo strtotime($date) * 1000;
    }

    function convertDateToSeconds($date)
    {
        echo strtotime($date);
    }

    function mimicClientSideCall(){
        $url = 'https://api.thesoftwarepeople.com/pro/driver.php';
        $result = TSP_Helper::getCurlResults($url, "", array(), false, array(), true);

        print_r($result);
    }

    function getCookies(){
        $decrypted = array();

        $decrypted['username'] = TSP_Helper::cookieGet('username', TSP_Settings::$cookie_prefix);
        $decrypted['username'] = TSP_Helper::openDecrypt(System::getCookieSalt(), $decrypted['username'], TSP_Config::get('app.checksums.secret_key'));

        echo json_encode($decrypted);
    }

    function testSession(){
        // Starting session
        session_start();

        if ($_REQUEST['type'] == 'set'){
            // Storing session data
            $_SESSION['first_name'] = "Sharron";
            $_SESSION['last_name'] = "Denice";

            TSP_Helper::cookieSet(
                'first_name',
                TSP_Helper::openEncrypt(System::getCookieSalt(), $_SESSION['first_name'], TSP_Config::get('app.checksums.secret_key')),
                TSP_Settings::$cookie_prefix,
                (PROTOCOL == 'https' ? true : false),
                (ONE_DAY * 7)
            );

            TSP_Helper::cookieSet(
                'last_name',
                TSP_Helper::openEncrypt(System::getCookieSalt(), $_SESSION['last_name'], TSP_Config::get('app.checksums.secret_key')),
                TSP_Settings::$cookie_prefix,
                (PROTOCOL == 'https' ? true : false),
                (ONE_DAY * 7)
            );

            header('Location: ' . TSP_Config::get('app.domain_uri') . "/driver.php?type=get");
        }
        else if ($_REQUEST['type'] == 'get')
        {
            $decrypted = array();

            $decrypted['first_name'] = TSP_Helper::cookieGet('first_name', TSP_Settings::$cookie_prefix);
            $decrypted['first_name'] = TSP_Helper::openDecrypt(System::getCookieSalt(), $decrypted['first_name'], TSP_Config::get('app.checksums.secret_key'));

            $decrypted['last_name'] = TSP_Helper::cookieGet('last_name', TSP_Settings::$cookie_prefix);
            $decrypted['last_name'] = TSP_Helper::openDecrypt(System::getCookieSalt(), $decrypted['last_name'], TSP_Config::get('app.checksums.secret_key'));

            var_dump($_COOKIE, $_SESSION, $decrypted);
        }
        else if ($_REQUEST['type'] == 'del'){
            session_unset();
            session_destroy();

            TSP_Helper::cookieDelete(TSP_Settings::$cookie_prefix, true);

            header('Location: ' . TSP_Config::get('app.domain_uri') . "/driver.php?type=get");
        }
    }

    function installDatabase()
    {
        $params = array(
            'dbhost' => 'localhost',
            'dbname' => 'thesoft7_sdenice_enroll',
            'dbuser' => 'root',
            'dbpass' => 'Th3B35tB3t!',
        );

        $data = System::installDatabase($params);

        print_r($data);
    }

    function createUser()
    {
        $params = array(
            'first_name'    => 'Sharron',
            'last_name'     => 'Allen',
            'username'      => 'sharrondenice',
            'email'         => 'webmaster@sharrondenice.com',
            'password'      => 'I@m:)H3@1thy$W153',
        );

        $user = new Admin();

        $data = $user->add($params);

        print_r($user->response);
        print_r($data);

    }

    function generateHashPassword($password){
        $hash = new PasswordHash(8, true);
        $password = $hash->HashPassword( $password );

        echo $password;
    }

    function convertType()
    {
        $type = 'U';

        $etype = new EOwnerType();
        $etype->setValue($type);

        echo $etype->getValue();
    }

    function testStateClass()
    {
        $state = new State();
        $state_data = $state->getStateByID(40);

        $current_state = $state->toArray();

        print_r($current_state);
    }
