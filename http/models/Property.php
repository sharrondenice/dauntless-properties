<?php

/**
 * @access public
 * @author Sharron Denice
 * @package models
 */
class Property extends BaseModel {
	/**
	 * @AttributeType models.Profile[]
	 */
	private $profile;
	/**
	 * @AttributeType string
	 */
	private $title;
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
     * @AttributeType string
     */
    private $image;

	/**
	 * @access public
	 * @param int id
	 * @ParamType id int
	 */
	public function __construct($id = null) {
		try{
		    parent::__construct($id);
		
		    $this->ownerType   = EOwnerType::Property;
		    $this->name         = 'Property';
		    $this->route        = 'property';
		    $this->table        = 'properties';
		
		    $this->dataFields  = array(
		        'title',
		        'description',
                'start_time',
                'end_time',
                'image'
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
		if (isset($data['title']))
		    $this->setTitle($data['title']);
        if (isset($data['start_time']))
            $this->setStartTime($data['start_time']);
        if (isset($data['end_time']))
            $this->setEndTime($data['end_time']);
        if (isset($data['image']))
            $this->setImage($data['image']);
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
		        $owner = EOwnerType::Property;
		
		    $sql = "SELECT `c`.*, `p`.`address1`, `p`.`address2`, `p`.`city`, `p`.`state_id`
		            FROM `properties` as `c` 
		            INNER JOIN `shared_profiles` as `p` ON `c`.`_id` = `p`.`owner_id` 
		            WHERE `p`.`owner` = '{$owner}'
		            ORDER BY `c`.`title`";


		    if (TSP_Config::get('app.debug'))
		        $this->response['sql'][] = array('stmt' => $sql, 'params' => null);

            $state = new State();
            $country = new Country();

            $index = 0;

		    $result = $this->conn->RunQuery($sql);
		    while( $row = $this->conn->FetchHash($result)){
		        $data[$index] = array_map('utf8_encode', $row);

                $this_state = $state->getStateByID($data[$index]['state_id']);
                $this_country = $country->getCountryByID($this_state['country_code']);

                $datetime1 = new DateTime($data[$index]['start_time']);
                $datetime2 = new DateTime($data[$index]['end_time']);
                $interval = $datetime1->diff($datetime2);

                if ($interval->d > 0)
                    $data[$index]['interval'] = $interval->format('%R%a days');
                else
                    $data[$index]['interval'] = 'No Availability';

                $data[$index]['metadata'] = array(
                    'location' => array(
                        'address1'  => $data[$index]['address1'],
                        'address2'  => $data[$index]['address2'],
                        'city'      => $data[$index]['city'],
                        'state_id'  => $data[$index]['state_id'],
                        'state'     => is_array($this_state) ? array_map('utf8_encode', $this_state) : array(),
                        'country'   => is_array($this_country) ? array_map('utf8_encode', $this_country) : array(),
                    )
                );

                $index++;
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
	 * @param models.Profile[] profile
	 * @ParamType profile models.Profile[]
	 */
	public function setProfile(array $profile) {
		$this->profile = $profile;
	}

	/**
	 * @access public
	 * @return models.Profile[]
	 * @ReturnType models.Profile[]
	 */
	public function getProfile() {
		return $this->profile;
	}
	/**
	 * @access public
	 * @param string title
	 * @ParamType title string
	 */
	public function setTitle($title) {
		$this->title = $title;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getTitle() {
		return $this->title;
	}
    /**
     * @access public
     * @param string image
     * @ParamType image string
     */
    public function setImage($image) {
        $this->image = $image;
    }

    /**
     * @access public
     * @return string
     * @ReturnType string
     */
    public function getImage() {
        return $this->image;
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
}
?>