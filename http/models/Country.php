<?php

/**
 * @access public
 * @author Sharron Denice
 * @package models
 */
class Country extends BaseModel {
	/**
	 * @AttributeType string
	 */
	private $country;
	/**
	 * @AttributeType string
	 */
	private $codeA3;
	/**
	 * @AttributeType string
	 */
	private $codeN3;
	/**
	 * @AttributeType string
	 */
	private $region;
	/**
	 * @AttributeType double
	 */
	private $lat;
	/**
	 * @AttributeType double
	 */
	private $lon;

	/**
	 * @access public
	 * @param int id
	 * @ParamType id int
	 */
	public function __construct($id = null) {
		try{
		    parent::__construct($id);
		
		    $this->ownerType   = null;
		    $this->name         = 'Country';
		    $this->route        = 'country';
		    $this->table        = 'locale_countries';
		
		    $this->statuses     = array();
		
		    $this->dataFields  = array(
		        '_id',
		        'code_A3',
		        'code_N3',
		        'region',
		        'type_id',
		        'lat',
		        'long',
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
		if (isset($data['country']))
		    $this->setCountry($data['country']);
		if (isset($data['code_A3']))
		    $this->setCodeA3($data['code_A3']);
		if (isset($data['code_N3']))
		    $this->setCodeN3($data['code_N3']);
		if (isset($data['region']))
		    $this->setRegion($data['region']);
		if (isset($data['lat']))
		    $this->setLat($data['lat']);
		if (isset($data['lon']))
		    $this->setLon($data['lon']);
		
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
		
		if (!TSP_Config::get('app.misc.show_countries') && !empty(TSP_Config::get('app.misc.default_country')))
		{
		    $default_country = TSP_Config::get('app.misc.default_country');
		
		    $sql = "SELECT `c`.*, `d`.title FROM `{$this->table}` as `c` 
		            INNER JOIN `locale_countries_descriptions` as `d` ON `c`.`_id` = `d`.`_id`
		            WHERE `c`._id = '{$default_country}'
		            ORDER BY `d`.title";
		}
		else
		{
		    $sql = "SELECT `c`.*, `d`.title FROM `{$this->table}` as `c` 
		            INNER JOIN `locale_countries_descriptions` as `d` ON `c`.`_id` = `d`.`_id`
		            ORDER BY `d`.title";
		}
		
		if (TSP_Config::get('app.debug'))
		    $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		$result = $this->conn->RunQuery($sql);
		while( $row = $this->conn->FetchHash($result)){
		    $data[] = array_map('utf8_encode', $row);
		}
		
		return $data;
	}

	/**
	 * @access public
	 * @param string country
	 * @ParamType country string
	 */
	public function setCountry($country) {
		$this->country = $country;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getCountry() {
		return $this->country;
	}

	/**
	 * @access public
	 * @param string codeA3
	 * @ParamType codeA3 string
	 */
	public function setCodeA3($codeA3) {
		$this->codeA3 = $codeA3;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getCodeA3() {
		return $this->codeA3;
	}

	/**
	 * @access public
	 * @param string codeN3
	 * @ParamType codeN3 string
	 */
	public function setCodeN3($codeN3) {
		$this->codeN3 = $codeN3;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getCodeN3() {
		return $this->codeN3;
	}

	/**
	 * @access public
	 * @param string region
	 * @ParamType region string
	 */
	public function setRegion($region) {
		$this->region = $region;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getRegion() {
		return $this->region;
	}

	/**
	 * @access public
	 * @param double lat
	 * @ParamType lat double
	 */
	public function setLat($lat) {
		$this->lat = $lat;
	}

	/**
	 * @access public
	 * @return double
	 * @ReturnType double
	 */
	public function getLat() {
		return $this->lat;
	}

	/**
	 * @access public
	 * @param double lon
	 * @ParamType lon double
	 */
	public function setLon($lon) {
		$this->lon = $lon;
	}

	/**
	 * @access public
	 * @return double
	 * @ReturnType double
	 */
	public function getLon() {
		return $this->lon;
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
		    $sql_count = "SELECT COUNT(*) as `count FROM {$this->table}
		                    WHERE`status_id` != '{$this->statuses['deleted']}";
		}
		else
		{
		    // @TODO set sql for records within the offset and range that the user can see
		    $sql = "SELECT * FROM {$this->table}
		                    WHERE`status_id` != '{$this->statuses['deleted']}'  
		                    ORDER BY `c`.`title` LIMIT $offset, $page_size";
		    // @TODO set sql_count for the number of all records that the user can see
		    $sql_count = "SELECT COUNT(*) as `count FROM {$this->table}
		                    WHERE`status_id` != '{$this->statuses['deleted']}";
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

    /**
     * Function to get record with metadata by ID
     * @access public
     * @param string ID
     * @return array
     * @ParamType ID string
     * @ReturnType array
     */
    public function getCountryByID($ID) {
        $sql = "SELECT d.*, s.* FROM `locale_countries_descriptions` as `d` INNER JOIN `locale_countries` as `s` ON `s`.`_id` = `d`.`_id` WHERE `s`.`_id` = '{$ID}'";

        if (TSP_Config::get('app.debug'))
            $this->response['sql'][] = array('stmt' => $sql, 'params' => null);

        $result = $this->conn->RunQuery($sql);
        $data = $this->conn->FetchHash($result);

        if (!empty($data))
            $this->set($data);

        return $data;
    }
}
?>