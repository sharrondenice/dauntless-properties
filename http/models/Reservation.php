<?php

/**
 * @access public
 * @author Sharron Denice
 * @package models
 */
class Reservation extends BaseModel {
	/**
	 * @AttributeType string
	 */
	private $description;
    /**
     * @AttributeType date
     */
    private $start_time;
    /**
     * @AttributeType date
     */
    private $end_time;
    /**
     * @AttributeType int
     */
    private $property_id;
    /**
     * @AttributeType Property
     */
    private $property;
    /**
     * @AttributeType int
     */
    private $responsible_user_id;
    /**
     * @AttributeType User
     */
    private $user;

	/**
	 * @access public
	 * @param int id
	 * @ParamType id int
	 */
	public function __construct($id = null) {
		try{
		    parent::__construct($id);
		
		    $this->ownerType   = EOwnerType::Reservation;
		    $this->name         = 'Reservation';
		    $this->route        = 'reservation';
		    $this->table        = 'properties_reservations';
		
		    $this->dataFields  = array(
		        'responsible_user_id',
		        'property_id',
		        'description',
                'start_time',
                'end_time'
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
		if (isset($data['user_id']))
		    $this->setUserID($data['user_id']);
        if (isset($data['start_time']))
            $this->setStartTime($data['start_time']);
        if (isset($data['end_time']))
            $this->setEndTime($data['end_time']);
        if (isset($data['property_id']))
            $this->setPropertyID($data['image']);
 		if (isset($data['description']))
		    $this->setDescription($data['description']);
		
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
		
		try{
		    session_start();
		
		    if (empty($owner))
		        $owner = EOwnerType::Reservation;
		
		    $sql = "SELECT `c`.*, `p`.`title`, `p`.`description`
		            FROM `{$this->table}` as `c` 
		            INNER JOIN `properties` as `p` ON `c`.`property_id` = `p`.`_id` 
		            WHERE `p`.`owner` = '{$owner}'
		            ORDER BY `c`.`start_time`";

		    if (TSP_Config::get('app.debug'))
		        $this->response['sql'][] = array('stmt' => $sql, 'params' => null);

		    $result = $this->conn->RunQuery($sql);
		    while( $row = $this->conn->FetchHash($result)){
		        $data[] = array_map('utf8_encode', $row);
		    }

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
	 * @access public
	 * @param models.Property property
	 * @ParamType profile models.Property
	 */
	public function setProperty(array $property) {
		$this->property = $property;
	}

	/**
	 * @access public
	 * @return models.Property
	 * @ReturnType models.Property
	 */
	public function getProperty() {
		return $this->property;
	}


    /**
     * @access public
     * @param models.User user
     * @ParamType profile models.User
     */
    public function setUser(array $user) {
        $this->user = $user;
    }

    /**
     * @access public
     * @return models.User
     * @ReturnType models.User
     */
    public function getUser() {
        return $this->user;
    }

	/**
	 * @access public
	 * @param int $user_id
	 * @ParamType $user_id int
	 */
	public function setUserID($user_id) {
		$this->responsible_user_id = $user_id;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getUserID() {
		return $this->responsible_user_id;
	}
    /**
     * @access public
     * @param int $property_id
     * @ParamType $property_id int
     */
    public function setPropertyID($property_id) {
        $this->property_id = $property_id;
    }

    /**
     * @access public
     * @return int
     * @ReturnType int
     */
    public function getPropertyID() {
        return $this->property_id;
    }
    /**
     * @access public
     * @param date start
     * @ParamType start date
     */
    public function setStartTime($start) {
        $this->start_time = $start;
    }

    /**
     * @access public
     * @return date
     * @ReturnType date
     */
    public function getStartTime() {
        return $this->start_time;
    }
    /**
     * @access public
     * @param date end
     * @ParamType end date
     */
    public function setEndTime($end) {
        $this->end_time = $end;
    }

    /**
     * @access public
     * @return date
     * @ReturnType date
     */
    public function getEndTime() {
        return $this->end_time;
    }

	/**
	 * @access public
	 * @param string description
	 * @ParamType description string
	 */
	public function setDescription($description) {
		$this->description = $description;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getDescription() {
		return $this->description;
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
		                    ORDER BY `c`.`title` LIMIT $offset, $page_size";
		
		    // @TODO set sql_count for the number of all records
		    $sql_count = "SELECT COUNT(*) as `count` FROM {$this->table}";
		}
		else
		{
		    // @TODO set sql for records within the offset and range that the user can see
		    $sql = "SELECT * FROM {$this->table}
		                    ORDER BY `c`.`title` LIMIT $offset, $page_size";
		    // @TODO set sql_count for the number of all records that the user can see
		    $sql_count = "SELECT COUNT(*) as `count` FROM {$this->table}";
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