<?php

/**
 * @access public
 * @author Sharron Denice
 * @package models
 */
class State extends BaseModel {
	/**
	 * @AttributeType string
	 */
	private $code;
	/**
	 * @AttributeType string
	 */
	private $state;
	/**
	 * @AttributeType string
	 */
	private $countryCode;

	/**
	 * @access public
	 * @param int id
	 * @ParamType id int
	 */
	public function __construct($id = null) {
		try{
		    parent::__construct($id);
		
		    $this->ownerType   = null;
		    $this->name         = 'State';
		    $this->route        = 'state';
		    $this->table        = 'locale_states';
		
		    $this->statuses     = array();
		
		    $this->dataFields  = array(
		        'state',
		    );
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
	 * Function to set the object given an array of data
	 * @access public
	 * @param string[] data
	 * @return void
	 * @ParamType data string[]
	 * @ReturnType void
	 */
	public function set(array &$data) {
		if (isset($data['code']))
		    $this->setCode($data['code']);
		if (isset($data['state']))
		    $this->setState($data['state']);
		if (isset($data['country_code']))
		    $this->setCountryCode($data['country_code']);
		
		if (isset($data['_id']))
		    $this->setID($data['_id']);
		if (isset($data['date_created']))
		    $this->setDateCreated($data['date_created']);
		if (isset($data['date_last_updated']))
		    $this->setDateLastUpdated($data['date_last_updated']);
	}

	/**
	 * Function to get list of all pending users
	 * @access public
	 * @param string owner
	 * @param int type
	 * @param int[] exclude
	 * @return array
	 * @ParamType owner string
	 * @ParamType type int
	 * @ParamType exclude int[]
	 * @ReturnType array
	 */
	public function getAll($owner = null, $type = null, array $exclude = array()) {
		$data = array();
		
		$sql = "SELECT `s`.*, `d`.`title` FROM `locale_states` as `s` INNER JOIN `locale_states_descriptions` as `d` ON `d`.`_id` = `s`.`_id`";
		
		if (TSP_Config::get('app.debug'))
		    $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		$result = $this->conn->RunQuery($sql);
		while( $row = $this->conn->FetchHash( $result)){
		    $data[] = array_map('utf8_encode', $row);
		}
		
		return $data;
	}

    /**
     * Function to get list of all pending users
     * @access public
     * @param string country_code
     * @return array
     * @ParamType country_code string
     * @ReturnType array
     */
    public function getAllByCountryCode($country_code) {
        $data = array();

        $sql = "SELECT `s`.*, `d`.`title` FROM `locale_states` as `s` INNER JOIN `locale_states_descriptions` as `d` ON `d`.`_id` = `s`.`_id` WHERE `s`.`country_code` = '{$country_code}'";

        if (TSP_Config::get('app.debug'))
            $this->response['sql'][] = array('stmt' => $sql, 'params' => null);

        $result = $this->conn->RunQuery($sql);
        while( $row = $this->conn->FetchHash( $result)){
            $data[] = array_map('utf8_encode', $row);
        }

        return $data;
    }

	/**
	 * Function to get record with metadata by ID
	 * @access public
	 * @param int ID
	 * @return array
	 * @ParamType ID int
	 * @ReturnType array
	 */
	public function getStateByID($ID) {
		$sql = "SELECT d.*, s.* FROM `locale_states_descriptions` as `d` INNER JOIN `locale_states` as `s` ON `s`.`_id` = `d`.`_id` WHERE `s`.`_id` = '{$ID}'";
		
		if (TSP_Config::get('app.debug'))
		    $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		$result = $this->conn->RunQuery($sql);
		$data = $this->conn->FetchHash($result);
		
		if (!empty($data))
		    $this->set($data);
		
		return $data;
	}

	/**
	 * @access public
	 * @param string code
	 * @ParamType code string
	 */
	public function setCode($code) {
		$this->code = $code;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getCode() {
		return $this->code;
	}

	/**
	 * @access public
	 * @param string state
	 * @ParamType state string
	 */
	public function setState($state) {
		$this->state = $state;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getState() {
		return $this->state;
	}

	/**
	 * @access public
	 * @param string countryCode
	 * @ParamType countryCode string
	 */
	public function setCountryCode($countryCode) {
		$this->countryCode = $countryCode;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getCountryCode() {
		return $this->countryCode;
	}

	/**
	 * Function to get list records
	 * @access public
	 * @param int current_page
	 * @param int page_size
	 * @param string owner
	 * @param int type
	 * @param int[] exclude
	 * @return array
	 * @ParamType current_page int
	 * @ParamType page_size int
	 * @ParamType owner string
	 * @ParamType type int
	 * @ParamType exclude int[]
	 * @ReturnType array
	 */
	public function getAllWithOffset($current_page, $page_size, $owner = null, $type = null, array $exclude = array()) {
		// @TODO set default owner if null
		// @TODO set default type if null
		
		$offset = ($current_page - 1) * $page_size;
		
		 if ($_SESSION['type_id'] == ESharedType::Admin)
		{
		    // @TODO set sql for records within the offset and range
		    $sql = "SELECT * FROM {$this->table}
		                    WHERE`status_id` != '{$this->statuses['deleted']}'  
		                    ORDER BY `c`.`title` LIMIT $offset, $page_size";
		
		    // @TODO set sql_count for the number of all records
		    $sql_count = "SELECT COUNT(*) as `count` FROM {$this->table}
		                    WHERE `status_id` != '{$this->statuses['deleted']}'";
		}
		else
		{
		    // @TODO set sql for records within the offset and range that the user can see
		    $sql = "SELECT * FROM {$this->table}
		                    WHERE`status_id` != '{$this->statuses['deleted']}'  
		                    ORDER BY `c`.`title` LIMIT $offset, $page_size";
		    // @TODO set sql_count for the number of all records that the user can see
		    $sql_count = "SELECT COUNT(*) as `count` FROM {$this->table}
		                    WHERE `status_id` != '{$this->statuses['deleted']}'";
		}
		
		$data['records'] = $this->getBySQL($sql);
		        
		$result = $this->conn->RunQuery($sql_count);
		$response = $this->conn->FetchHash($result);
		        
		$data['item_size'] = $response['count'];
		        
		$data['display_size'] = (($current_page - 1) * $page_size) + count($data['users']);
		        
		$data['number_pages'] = 1;
		        
		if ($data['item_size'] > $page_size)
		    $data['number_pages'] = ceil($data['item_size'] / $page_size);
	}
}
?>