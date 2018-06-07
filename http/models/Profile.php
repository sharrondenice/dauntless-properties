<?php

/**
 * @access public
 * @author Sharron Denice
 * @package models
 */
class Profile extends BaseModel {
	/**
	 * @AttributeType models.Type
	 */
	private $type;
	/**
	 * @AttributeType boolean
	 */
	private $is_default;
	/**
	 * @AttributeType models.EOwnerType
	 */
	private $owner;
	/**
	 * @AttributeType int
	 */
	private $ownerID;
	/**
	 * @AttributeType string
	 */
	private $email;
	/**
	 * @AttributeType string
	 */
	private $address1;
	/**
	 * @AttributeType string
	 */
	private $address2;
	/**
	 * @AttributeType string
	 */
	private $city;
	/**
	 * @AttributeType models.State
	 */
	private $state;
	/**
	 * @AttributeType string
	 */
	private $zipCode;
	/**
	 * @AttributeType string
	 */
	private $phone1;
	/**
	 * @AttributeType string
	 */
	private $phone2;
	/**
	 * @AttributeType string
	 */
	private $fax;
	/**
	 * @AttributeType string
	 */
	private $url;

	/**
	 * @access public
	 * @param int id
	 * @ParamType id int
	 */
	public function __construct($id = null) {
		try{
		    parent::__construct($id);
		
		    $this->ownerType   = EOwnerType::Profile;
		    $this->name         = 'Profile';
		    $this->route        = 'profile';
		    $this->table        = 'shared_profiles';
		
		    $this->statuses     = array();
		
		    $this->dataFields  = array(
		        'type_id','owner','owner_id','is_default','email','address1','address2',
		        'city','state_id','zip','phone1','phone2','fax', 'url'
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
		if (isset($data['type_id']))
		{
		    $type = new Type();
		    $type->getByID($data['type_id']);
		    $this->setType($type);
		}
		if (isset($data['owner']))
		{
		    $type = new EOwnerType();
		    $type->setValue($data['owner']);
		    $this->setOwner($type);
		}
		if (isset($data['owner_id']))
		    $this->setOwnerID($data['owner_id']);
		if (isset($data['is_default']))
		    $this->setDefault($data['is_default']);
		if (isset($data['email']))
		    $this->setEmail($data['email']);
		if (isset($data['address1']))
		    $this->setAddress1($data['address1']);
		if (isset($data['address2']))
		    $this->setAddress2($data['address2']);
		if (isset($data['city']))
		    $this->setCity($data['city']);
		if (isset($data['state_id']))
		{
		    $state = new State();
		    $state->getStateByID($data['state_id']);
		    $this->setState($state);
		
		    $data['state'] = $state->toArray();
		}
		if (isset($data['zip']))
		    $this->setZipCode($data['zip']);
		if (isset($data['phone1']))
		    $this->setPhone1($data['phone1']);
		if (isset($data['phone2']))
		    $this->setPhone2($data['phone2']);
		if (isset($data['fax']))
		    $this->setFax($data['fax']);
		if (isset($data['url']))
		    $this->setUrl($data['url']);
		
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
		
		$sql = "SELECT * FROM `{$this->table}` ORDER BY `date_created`";
		
		if (TSP_Config::get('app.debug'))
		    $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		$result = $this->conn->RunQuery($sql);
		while( $row = $this->conn->FetchHash( $result)){
		    $data[] = array_map('utf8_encode', $row);
		}
		
		return $data;
	}

	/**
	 * 
	 * Function to get a default profile
	 * 
	 * @since 1.0.0
	 * @access public
	 * @param string owner_type
	 * @param int owner_id
	 * @return array
	 * @ParamType owner_type string
	 * @ParamType owner_id int
	 * @ReturnType array
	 */
	public function getDefaultProfile($owner_type, $owner_id) {
		$sql = "SELECT * FROM `{$this->table}` WHERE `owner` = '{$owner_type}' AND `owner_id` = '{$owner_id}' AND `is_default` = 1";
		
		if (TSP_Config::get('app.debug'))
		    $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		$result = $this->conn->RunQuery($sql);
		$data = $this->conn->FetchHash($result);
		
		 if (!empty($data))
		{
		    $this->set($data);
		
		    if (empty($data['state']))
		    {
		        $data['state'] = array(
		            'code' => '',
		            'state' => '',
		            'country' => ''
		        );
		    }
		}
		
		return $data;
	}

	/**
	 * 
	 * Function to get a profile
	 * 
	 * @since 1.0.0
	 * @access public
	 * @param string email
	 * @return array
	 * @ParamType email string
	 * @ReturnType array
	 */
	public function getProfileByEmail($email) {
		$sql = "SELECT * FROM `{$this->table}` WHERE `email` = '{$email}'";
		
		if (TSP_Config::get('app.debug'))
		    $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		$result = $this->conn->RunQuery($sql);
		$data = $this->conn->FetchHash($result);
		
		 if (!empty($data))
		{
		    $this->set($data);
		
		    if (empty($data['state']))
		    {
		        $data['state'] = array(
		            'code' => '',
		            'state' => '',
		            'country' => ''
		        );
		    }
		}
		
		return $data;
	}

	/**
	 * 
	 * Function to get a profile
	 * 
	 * @since 1.0.0
	 * @access public
	 * @param string owner_type
	 * @param int owner_id
	 * @param string profile_type
	 * @return array
	 * @ParamType owner_type string
	 * @ParamType owner_id int
	 * @ParamType profile_type string
	 * @ReturnType array
	 */
	public function getProfileByOwner($owner_type, $owner_id, $profile_type) {
		$sql = "SELECT * FROM `shared_profiles` WHERE `owner` = '{$owner_type}' AND `owner_id` = '{$owner_id}' AND `type_id` = '{$profile_type}'";
		
		if (TSP_Config::get('app.debug'))
		    $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		$result = $this->conn->RunQuery($sql);
		$data = $this->conn->FetchHash($result);
		
		 if (!empty($data))
		{
		    $this->set($data);
		
		    if (empty($data['state']))
		    {
		        $data['state'] = array(
		            'code' => '',
		            'state' => '',
		            'country' => ''
		        );
		    }
		}
		
		return $data;
	}


    /**
     *
     * Function to get a profile by owner
     *
     * @since 1.0.0
     * @access public
     * @param string owner_type
     * @param int owner_id
     * @return array
     * @ParamType owner_type string
     * @ParamType owner_id int
     * @ReturnType array
     */
    public function getProfilesByOwner($owner_type, $owner_id) {
        $sql = "SELECT * FROM `shared_profiles` WHERE `owner` = '{$owner_type}' AND `owner_id` = '{$owner_id}'";

        if (TSP_Config::get('app.debug'))
            $this->response['sql'][] = array('stmt' => $sql, 'params' => null);

        $result = $this->conn->RunQuery($sql);
        while( $row = $this->conn->FetchHash( $result)){
            $data[] = array_map('utf8_encode', $row);
        }

        return $data;
    }

	/**
	 * 
	 * Function to update an owner's default profile
	 * 
	 * @since 1.0.0
	 * @access public
	 * @param string owner_type
	 * @param int owner_id
	 * @param string[] data
	 * @return void
	 * @ParamType owner_type string
	 * @ParamType owner_id int
	 * @ParamType data string[]
	 * @ReturnType void
	 */
	public function updateOwnerDefaultProfile($owner_type, $owner_id, array $data) {
		$values = "";
		
		foreach ($data as $key => $value)
		{
		    if (!in_array($key, $this->dataFields))
		        continue;
		    else if ($value == 'null' || $value == 'undefined')
		        continue;
		
		    $values .= "`{$key}` = '{$value}', ";
		}
		
		// Save Profile into the database
		$sql = "UPDATE `{$this->table}` SET 
		                            {$values}
		                            `date_last_updated` = NOW() WHERE `is_default` = '1' AND `owner` = '{$owner_type}' AND `owner_id` = '{$owner_id}'";
		
		if (TSP_Config::get('app.debug'))
		    $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		$this->conn->RunQuery($sql);
	}

	/**
	 * 
	 * Function to update an owner's profile
	 * 
	 * @since 1.0.0
	 * @access public
	 * @param string owner_type
	 * @param int owner_id
	 * @param string[] data
	 * @return void
	 * @ParamType owner_type string
	 * @ParamType owner_id int
	 * @ParamType data string[]
	 * @ReturnType void
	 */
	public function updateProfileByOwner($owner_type, $owner_id, array $data) {
		$values = "";
		
		foreach ($data as $key => $value)
		{
		    if (!in_array($key, $this->dataFields))
		        continue;
		    else if ($value == 'null' || $value == 'undefined')
		        continue;
		
		    $values .= "`{$key}` = '{$value}', ";
		}
		
		// Save Profile into the database
		$sql = "UPDATE `{$this->table}` SET 
		                            {$values}
		                            `date_last_updated` = NOW() WHERE `owner` = '{$owner_type}' AND `owner_id` = '{$owner_id}'";
		
		if (TSP_Config::get('app.debug'))
		    $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		$this->conn->RunQuery($sql);
	}

	/**
	 * 
	 * Function to update an owner's profile
	 * 
	 * @since 1.0.0
	 * @access public
	 * @param string owner_type
	 * @param int owner_id
	 * @param string profile_type
	 * @param string[] data
	 * @return void
	 * @ParamType owner_type string
	 * @ParamType owner_id int
	 * @ParamType profile_type string
	 * @ParamType data string[]
	 * @ReturnType void
	 */
	public function updateProfileByType($owner_type, $owner_id, $profile_type, array $data) {
		$values = "";
		
		foreach ($data as $key => $value)
		{
		    if (!in_array($key, $this->dataFields))
		        continue;
		    else if ($value == 'null' || $value == 'undefined')
		        continue;
		
		    $values .= "`{$key}` = '{$value}', ";
		}
		
		// Save Profile into the database
		$sql = "UPDATE `{$this->table}` SET 
		                            {$values}
		                            `date_last_updated` = NOW() WHERE `type_id` = '{$profile_type}' AND `owner` = '{$owner_type}' AND `owner_id` = '{$owner_id}'";
		
		if (TSP_Config::get('app.debug'))
		    $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		$this->conn->RunQuery($sql);
	}

	/**
	 * @access public
	 * @param models.Type type
	 * @ParamType type models.Type
	 */
	public function setType(Type $type) {
		$this->type = $type;
	}

	/**
	 * @access public
	 * @return models.Type
	 * @ReturnType models.Type
	 */
	public function getType() {
		return $this->type;
	}

	/**
	 * @access public
	 * @param boolean default
	 * @ParamType default boolean
	 */
	public function setDefault($default) {
		$this->default = $default;
	}

	/**
	 * @access public
	 * @return boolean
	 * @ReturnType boolean
	 */
	public function isDefault() {
		return $this->default;
	}

	/**
	 * @access public
	 * @param models.EOwnerType owner
	 * @ParamType owner models.EOwnerType
	 */
	public function setOwner(EOwnerType $owner) {
		$this->owner = $owner;
	}

	/**
	 * @access public
	 * @return models.EOwnerType
	 * @ReturnType models.EOwnerType
	 */
	public function getOwner() {
		return $this->owner;
	}

	/**
	 * @access public
	 * @param int ownerID
	 * @ParamType ownerID int
	 */
	public function setOwnerID($ownerID) {
		$this->ownerID = $ownerID;
	}

	/**
	 * @access public
	 * @return int
	 * @ReturnType int
	 */
	public function getOwnerID() {
		return $this->ownerID;
	}

	/**
	 * @access public
	 * @param string email
	 * @ParamType email string
	 */
	public function setEmail($email) {
		$this->email = $email;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getEmail() {
		return $this->email;
	}

	/**
	 * @access public
	 * @param string address1
	 * @ParamType address1 string
	 */
	public function setAddress1($address1) {
		$this->address1 = $address1;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getAddress1() {
		return $this->address1;
	}

	/**
	 * @access public
	 * @param string address2
	 * @ParamType address2 string
	 */
	public function setAddress2($address2) {
		$this->address2 = $address2;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getAddress2() {
		return $this->address2;
	}

	/**
	 * @access public
	 * @param string city
	 * @ParamType city string
	 */
	public function setCity($city) {
		$this->city = $city;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getCity() {
		return $this->city;
	}

	/**
	 * @access public
	 * @param models.State state
	 * @ParamType state models.State
	 */
	public function setState(State $state) {
		$this->state = $state;
	}

	/**
	 * @access public
	 * @return models.State
	 * @ReturnType models.State
	 */
	public function getState() {
		return $this->state;
	}

	/**
	 * @access public
	 * @param string zipCode
	 * @ParamType zipCode string
	 */
	public function setZipCode($zipCode) {
		$this->zipCode = $zipCode;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getZipCode() {
		return $this->zipCode;
	}

	/**
	 * @access public
	 * @param string phone1
	 * @ParamType phone1 string
	 */
	public function setPhone1($phone1) {
		$this->phone1 = $phone1;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getPhone1() {
		return $this->phone1;
	}

	/**
	 * @access public
	 * @param string phone2
	 * @ParamType phone2 string
	 */
	public function setPhone2($phone2) {
		$this->phone2 = $phone2;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getPhone2() {
		return $this->phone2;
	}

	/**
	 * @access public
	 * @param string fax
	 * @ParamType fax string
	 */
	public function setFax($fax) {
		$this->fax = $fax;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getFax() {
		return $this->fax;
	}

	/**
	 * @access public
	 * @param string url
	 * @ParamType url string
	 */
	public function setUrl($url) {
		$this->url = $url;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getUrl() {
		return $this->url;
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