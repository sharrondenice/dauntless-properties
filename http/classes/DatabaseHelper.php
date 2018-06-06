<?php
    /**
     * Enrollment Processor
     *
     * @package		Enrollment
     * @filename	DatabaseHelper.php
     * @version		1.0.2
     * @author		Sharron Denice, The Software People (www.thesoftwarepeople.com)
     * @copyright	Copyright 2016 RS Agency Services (www.rsagencyservices.com). All rights reserved
     * @license		APACHE v2.0 (http://www.apache.org/licenses/LICENSE-2.0)
     * @brief		Database helper functionality
     *
     */	
     class DatabaseHelper{

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
        function __construct() 
        {
            try{
                $config = getRSABasicAzureSQLDBConfig(getConfigVal('SQLDBInstanceName'));
                $this->conn = new SQLDBConnector($config);
                $this->response = array();
            } catch (Exception $e){
                $this->response['sql'][] = array('stmt' => $sql, 'params' => $params);
                $this->response['admin_error'][] = $e->getMessage();
               $this->response['error'] = array(
                'title' => 'Error Occurred',
                'message' => 'Unknown error (600) occurred. Please contact your system administrator or try again at a later time.',
                'type' => 'error',
            );

            }
        }

    	/**
    	 * Method to execute sql file on database - ADMIN FUNCTION ONLY
    	 *
    	 * @since 1.0.0
    	 *
    	 * @param string $table  - the the name of the table to update
    	 * @param string $key  - the key for performing admin function
    	 *
    	 * @return array $data -  Array of info to be returned
    	 */
        public function executeSQL($table, $key)
        {
            $data = array();
    
            // This is a admin function
            if ($key != ADMIN_KEY)
                return $data;
            
            try{
                $sql_stmnts = file_get_contents(ABSPATH . "register/_sql/{$table}.sql");
                $sql_stmnts = explode("\n", $sql_stmnts);
                $count = 1;

                foreach ($sql_stmnts as $sql)
                {
                    $sql = trim($sql);

                    if (!empty($sql))
                    {
                        echo "$count. $sql<br>\n";
    
                        flush();
                        ob_flush();
                        
                        $count++;
                    }

                    if (!empty($sql))
                        $result = $this->conn->executeQueryAndGetStatementResult($sql);
                }
            } catch (Exception $e){
                $this->response['admin_error'][] = $e->getMessage();
               $this->response['error'] = array(
                'title' => 'Error Occurred',
                'message' => 'Unknown error (601) occurred. Please contact your system administrator or try again at a later time.',
                'type' => 'error',
            );

            }
    
            return $data;
        }
    }