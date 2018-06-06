<?php


/**
 * @access public
 * @author Sharron Denice
 * @package enroll_123
 */
class System {
    protected $conn = null;
    public $response = null;

    /**
     * Constructor
     *
     * @since 1.0.0
     *
     * @param none
     *
     * @return none
     */
    function __construct($auto_connect = false)
    {
        try{
            if ($auto_connect)
                $this->conn = new TSP_Database('database');
            $this->response = array();
        } catch (Exception $e){
            if (TSP_Config::get('app.debug'))
                $this->response['admin_error'][] = $e->getMessage();

           $this->response['error'] = array(
                'title' => 'Error Occurred',
                'message' => 'Unknown error (100) occurred. Please contact your system administrator or try again at a later time.',
                'type' => 'error',
            );

        }
    }

    /**
     * Method to set the database connection
     *
     * @since 1.0.0
     *
     * @param string $key - the database key name
     * @param bool $select_db - connect to a database or not
     *
     * @return none
     */
    private function setConnection($key, $select_db)
    {
        $this->conn = new TSP_Database($key, $select_db);
    }

    private function importSQL($dbhost, $dbname, $dbuser, $dbpass, $filename){

        // Connect to MySQL server
        $connection = mysqli_connect($dbhost, $dbuser, $dbpass, $dbname);

        if (mysqli_connect_errno())
            return false;

        // Temporary variable, used to store current query
        $templine = '';

        // Read in entire file
        $fp = fopen($filename, 'r');

        // Loop through each line
        while (($line = fgets($fp)) !== false) {
            // Skip it if it's a comment
            if (substr($line, 0, 2) == '--' || $line == '')
                continue;

            // Add this line to the current segment
            $templine .= $line;

            // If it has a semicolon at the end, it's the end of the query
            if (substr(trim($line), -1, 1) == ';') {
                // Perform the query
                if(!mysqli_query($connection, $templine)){
                    //print('Error performing query \'<strong>' . $templine . '\': ' . mysqli_error($connection) . '<br /><br />');
                }
                // Reset temp variable to empty
                $templine = '';
            }
        }
        mysqli_close($connection);
        fclose($fp);

        return true;
    }
    /**
     * Method to get the mind archetype
     *
     * @since 1.0.0
     *
     * @param array $params - array of values if not using form
     *
     * @return array $data
     */
    public function installDatabase($params = array())
    {
        $data = array();

        $sql = '';

        try{
            $dbhost     = TSP_Helper::arrGetVal($_POST, 'dbhost', $params['dbhost']);
            $dbname     = TSP_Helper::arrGetVal($_POST, 'dbname', $params['dbname']);
            $dbuser     = TSP_Helper::arrGetVal($_POST, 'dbuser', $params['dbuser']);
            $dbpass     = TSP_Helper::arrGetVal($_POST, 'dbpass', $params['dbpass']);

            // Create config file
            $blank_config_file = "<?php
            
define('DB_HOST', '');
define('DB_NAME', '');
define('DB_USER', '');
define('DB_PASS', '');
";
            $config_file = "<?php
            
define('DB_HOST', '".$dbhost."');
define('DB_NAME', '".$dbname."');
define('DB_USER', '".$dbuser."');
define('DB_PASS', '".$dbpass."');
";
            file_put_contents(ABSPATH . 'config.db.php', $config_file);

            $sql_stmnts = file_get_contents(ABSPATH . "sql/database.sql");
            $sql_stmnts = preg_replace('/DB_NAME/', $dbname, $sql_stmnts);

            $code = TSP_Helper::genKey(8, false);
            file_put_contents(ABSPATH . "sql/database-{$code}.sql", $sql_stmnts);

            //$command='mysql -h' .$dbhost .' -u' .$dbuser .' -p' .$dbpass .' < ' .ABSPATH . "sql/database-{$code}.sql";
            //exec($command, $output, $imported);

            $imported = $this->importSQL($dbhost, $dbname, $dbuser, $dbpass, ABSPATH . "sql/database-{$code}.sql");

            if($imported)
            {
                $this->response['success'] = array(
                    'title' => 'Database Successfully setup.',
                    'message' => 'Import file <b>' . ABSPATH . 'sql/database-live.sql</b> successfully imported to database <b>' . $dbname . '</b>',
                    'type' => 'success',
                );

                include_once ABSPATH . 'config.db.php';
            }
            else
            {
                $this->response['error'] = array(
                    'title' => 'An error occurred during database setup.',
                    'message' => 'Please check your credentials and try again or contact your system administrator for support.',
                    'type' => 'error',
                );

                file_put_contents(ABSPATH . 'config.db.php', $blank_config_file);

                include_once ABSPATH . 'config.db.php';

                $this->conn = new TSP_Database('database');
            }

        } catch (Exception $e){
            if (TSP_Config::get('app.debug'))
            {
                $this->response['sql'][] = array('stmt' => $sql);
                $this->response['admin_error'][] = $e->getMessage();
            }

            file_put_contents(ABSPATH . 'config.db.php', $blank_config_file);
            include_once ABSPATH . 'config.db.php';

            $this->response['error'] = array(
                'title' => 'Error Occurred',
                'message' => 'Please contact your system administrator or try again at a later time.',
                'type' => 'error',
            );

        }

        return $data;
    }

    /**
     * Method to notify a user
     *
     * @since 1.0.0
     *
     * @param array $params - required email, template, subject
     *
     */
    public static function notifyCustomer($params)
    {
        $template = "";

        $params = array_merge($params, $_POST);

        $params['company_name'] = COMPANY_NAME;
        $params['domain'] = TSP_Config::get('app.domain_uri');

        include ABSPATH . "/views/email/{$params['template']}.blade.php";

        $body = $template;

        $mail = new TSP_Mail(TSP_Settings::$admin_from_email, TSP_Settings::$admin_from_name, true);
        $mail->send($params['email'], $params['subject'], $body);
    }

    /**
     * Function to get a user's gravatar url
     *
     * @since 1.0.0
     *
     * @param string $email - The user's email
     *
     * @return string - gravatar URL
     */
    public static function getGravatarURL($email)
    {
        return "https://www.gravatar.com/avatar/" . md5( strtolower( trim( $email ) ) );
    }

    /**
     * Function to initialize apps default settings
     *
     * @since 1.0.0
     *
     * @param none
     *
     * @return array - data
     */
    public function init()
    {
        $data = array();

        $user_id            = TSP_Helper::arrGetVal($_POST, 'user_id', null);
        $show_countries     = TSP_Helper::arrGetVal($_POST, 'show_countries', null);
        $country_code       = TSP_Helper::arrGetVal($_POST, 'country_code', null);
        $lang_code          = TSP_Helper::arrGetVal($_POST, 'lang_code', null);
        $current_company_id = TSP_Helper::arrGetVal($_POST, 'current_company_id', null);

        try{
            $setting = new Setting();
            $system_settings = $setting->getAllByCompany($current_company_id);

            foreach ($system_settings as $preference){
                $value = $preference['setting_value'];

                if ($value == "true") $value = true;
                else if ($value == "false") $value = false;

                $data['system_settings'][$preference['setting_name']] = $value;
            }

            $user = new User();
            $data['current_user'] = $user->getUserByID($user_id);
            $preferences = $setting->getAllByUser($user_id);

            foreach ($preferences as $preference){
                $value = $preference['setting_value'];

                if ($value == "true") $value = true;
                else if ($value == "false") $value = false;

                $data['current_user']['preferences'][$preference['setting_name']] = $value;
            }

            $state = new State();
            $data['states'] = $state->getAll();

            $type = new Type();
            $data['types'] = $type->getAll();

            $country = new Country();
            $data['countries'] = $country->getAll();

            $this->response['success'] = array(
                'title' => 'Success',
                'message' => 'Data successfully retrieved.',
                'type' => 'success',
            );
        } catch (Exception $e){
            if (TSP_Config::get('app.debug'))
            {
                $this->response['admin_error'][] = $e->getMessage();
            }
            $this->response['error'] = array(
                'title' => 'Error Occurred',
                'message' => 'Unknown error (301) occurred. Please contact your system administrator or try again at a later time.',
                'type' => 'error',
            );
        }

        return $data;
    }

    /**
     * Function to get the site's cookie salt
     *
     * @since 1.0.0
     *
     * @param none
     *
     * @return string - cookie salt
     */
    public static function getCookieSalt()
    {
        $ip = @$_SERVER['REMOTE_ADDR'];
        $salt = TSP_Config::get('app.checksums.admin_key')."-".$ip;

        return $salt;
    }
}
?>