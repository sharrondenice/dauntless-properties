<?php

/**
 * @access protected
 * @author Sharron Denice
 * @package models.base
 */
class User extends BaseModel {
	/**
	 * @AttributeType int
	 */
	private $parentID;
	/**
	 * @AttributeType models.Profession
	 */
	private $profession;
	/**
	 * @AttributeType models.Permission
	 */
	private $permission;
	/**
	 * @AttributeType models.Profile[]
	 */
	private $profile;
	/**
	 * @AttributeType models.Company
	 */
	private $company;
	/**
	 * @AttributeType models.Status
	 */
	private $status;
	/**
	 * @AttributeType models.Type
	 */
	private $type;
	/**
	 * @AttributeType string
	 */
	private $username;
	/**
	 * @AttributeType string
	 */
	private $password;
	/**
	 * @AttributeType string
	 */
	private $title;
	/**
	 * @AttributeType string
	 */
	private $firstName;
	/**
	 * @AttributeType string
	 */
	private $lastName;
	/**
	 * @AttributeType string
	 */
	private $bio;
	/**
	 * @AttributeType int
	 */
	private $dob;
	/**
	 * @AttributeType int
	 */
	private $dateCreated;
	/**
	 * @AttributeType int
	 */
	private $dateLastUpdated;

	/**
	 * @access public
	 * @param int id
	 * @ParamType id int
	 */
	public function __construct($id = null) {
		try{
		
		    parent::__construct($id);
		
		    $this->ownerType   = EOwnerType::User;
		    $this->name         = 'User';
		    $this->route        = 'user';
		    $this->table        = 'users';
		
		    $type = new Type();
		    $type->getByID(ESharedType::User);
		    $this->setType($type);
		
		    $this->statuses     = array(
		        'active'    => ESharedStatus::UserActive,
		        'disabled'  => ESharedStatus::UserDisabled,
		    );
		
		    $this->dataFields  = array(
		        'parent_id',
		        'company_id',
		        'permission_id',
		        'status_id',
		        'type_id',
		        'username',
		        'password',
		        'company',
		        'title',
		        'first_name',
		        'last_name',
		        'bio',
		        'dob',
		    );
		
		    $this->objectTypes   = array(
		        'admins'            => ESharedType::Admin,
		        'general_agents'    => ESharedType::GeneralAgent,
		        'agents'            => ESharedType::Agent,
		        'clients'           => ESharedType::Client,
		        'employees'         => ESharedType::Employee,
		        'dependents'         => ESharedType::Dependent
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
		if (isset($data['parent_id']))
		    $this->setParentID($data['parent_id']);
		if (isset($data['profession_id']))
		{
		    //$profession = new Profession();
		    //$profession->getByID($data['profession_id']);
		    //$this->setProfession($profession);
		}
		if (isset($data['company_id']))
		{
		    $company = new Company();
		    $company->getByID($data['company_id']);
		    $this->setCompany($company);
		}
		if (isset($data['permission_id']))
		{
		    $permission = new Permission();
		    $permission->getByID($data['permission_id']);
		    $this->setPermission($permission);
		}
		if (isset($data['status_id']))
		{
		    $status = new Status();
		    $status->getByID($data['status_id']);
		    $this->setStatus($status);
		}
		if (isset($data['type_id']))
		{
		    $type = new Type();
		    $type->getByID($data['type_id']);
		    $this->setType($type);
		}
		if (isset($data['username']))
		    $this->setUsername($data['username']);
		if (isset($data['password']))
		    $this->setPassword($data['password']);
		if (isset($data['title']))
		    $this->setTitle($data['title']);
		if (isset($data['first_name']))
		    $this->setFirstName($data['first_name']);
		if (isset($data['last_name']))
		    $this->setLastName($data['last_name']);
		if (isset($data['bio']))
		    $this->setBio($data['bio']);
		if (isset($data['dob']))
		    $this->setDob($data['dob']);
		
		if (isset($data['_id']))
		    $this->setID($data['_id']);
		if (isset($data['date_created']))
		    $this->setDateCreated($data['date_created']);
		if (isset($data['date_last_updated']))
		    $this->setDateLastUpdated($data['date_last_updated']);
	}

	/**
	 * Function to get active user given ID
	 * @access public
	 * @param int id
	 * @return array
	 * @ParamType id int
	 * @ReturnType array
	 */
	public function getActiveUserByID($id) {
		$data = array();
		
		try{
		    session_start();
		
		    $sql = "SELECT u.*, p.email, t._id as type FROM `users` as `u` 
		            INNER JOIN `shared_types` as `t` ON `t`.`_id` = `u`.`type_id` 
		            INNER JOIN `shared_profiles` as `p` ON `p`.`owner_id` = `u`.`_id` 
		            WHERE `u`.`_id` = '{$id}' AND `u`.`status_id` = '{$this->statuses['active']}'";
		
		    if (TSP_Config::get('app.debug'))
		        $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		    $result = $this->conn->RunQuery($sql);
		    $data = $this->conn->FetchHash($result);
		
		    if (!empty($data))
		        $this->set($data);
		
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
	 * Function to get active user given username
	 * @access public
	 * @param string username
	 * @return array
	 * @ParamType username string
	 * @ReturnType array
	 */
	public function getActiveUserByUsername($username) {
		$data = array();
		
		try{
		    session_start();
		
		    $sql = "SELECT u.*, p.*, t._id as type FROM `users` as `u` 
		            INNER JOIN `shared_types` as `t` ON `t`.`_id` = `u`.`type_id` 
		            INNER JOIN `shared_profiles` as `p` ON `p`.`owner_id` = `u`.`_id` 
		            WHERE `u`.`username` = '{$username}' AND `u`.`status_id` = '{$this->statuses['active']}' AND `p`.owner = 'U' AND `p`.is_default = 1";
		
		    if (TSP_Config::get('app.debug'))
		        $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		    $result = $this->conn->RunQuery($sql);
		    $data = $this->conn->FetchHash($result);
		
		    if (!empty($data))
		        $this->set($data);
		
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
	 * Function to get list of all reocrds given owner type and share type
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
		        $owner = $this->ownerType;
		    if (empty($type))
		        $type = ESharedType::Admin;

            $sql = "SELECT `u`.*, CONCAT_WS(' ', `first_name`, `last_name`) AS `title`, `p`.`email`, `t`.`title` as `type_description`, `s`.`background`, `s`.`foreground`
		            FROM `users` as `u` 
		            INNER JOIN `shared_profiles` as `p` ON `u`.`_id` = `p`.`owner_id` 
		            INNER JOIN `shared_types` as `t` ON `u`.`type_id` = `t`.`_id` 
		            INNER JOIN `shared_statuses` as `s` ON `u`.`status_id` = `s`.`_id` 
		            WHERE `p`.`is_default` = 1 AND `p`.`owner` = '{$owner}' AND `u`.`status_id` != '{$this->statuses['deleted']}' 
		            AND `u`.`type_id` = 20 ORDER BY `u`.`last_name`";

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
	 * Function to list users given a user type
	 * @access public
	 * @param int type
	 * @return array
	 * @ParamType type int
	 * @ReturnType array
	 */
	public function getAllWithUserType($type) {
		return $this->getAll(null, $type);
	}

	/**
	 * @access public
	 * @param int id
	 * @param string[] ref_children
	 * @return array
	 * @ParamType id int
	 * @ParamType ref_children string[]
	 * @ReturnType array
	 */
	public function getDescendants($id, array &$children = array()) {
		try{
		    session_start();
		
		    $sql = "SELECT `_id`, `type_id` FROM {$this->getTable()} WHERE `parent_id` = '{$id}'";
		
		    if (TSP_Config::get('app.debug'))
		        $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		    $result = $this->conn->RunQuery($sql);
		    while( $row = $this->conn->FetchHash($result)){
		        $row = array_map('utf8_encode', $row);
		
		        $children[] = $row;
		
		        if (!empty($row['_id']))
		            $this->getDescendants($row['_id'], $children);
		    }
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
		
		return $children;
	}

	/**
	 * Function to get downline count
	 * @access public
	 * @param int user_id
	 * @param int type_id
	 * @return array
	 * @ParamType user_id int
	 * @ParamType type_id int
	 * @ReturnType array
	 */
	public function getDownlineCount($user_id, $type_id) {
		$sql = "SELECT COUNT(*) as count FROM `{$this->table}` WHERE `parent_id` = '{$user_id}' AND `type_id` = {$type_id}";
		
		if (TSP_Config::get('app.debug'))
		    $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		$result = $this->conn->RunQuery($sql);
		$count = $this->conn->FetchHash($result);
		
		return $count['count'];
	}

	/**
	 * Function to get active user given username
	 * @access public
	 * @param int id
	 * @return array
	 * @ParamType id int
	 * @ReturnType array
	 */
	public function getUserByID($id) {
		$data = array();
		
		try{
		    session_start();
		
		    $sql = "SELECT u.*, p.email, t._id as type FROM `users` as `u` 
		            INNER JOIN `shared_types` as `t` ON `t`.`_id` = `u`.`type_id` 
		            INNER JOIN `shared_profiles` as `p` ON `p`.`owner_id` = `u`.`_id` 
		            WHERE `u`.`_id` = '{$id}' AND `u`.`status_id` != '{$this->statuses['deleted']}'";
		
		    if (TSP_Config::get('app.debug'))
		        $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		    $result = $this->conn->RunQuery($sql);
		    $data = $this->conn->FetchHash($result);
		
		    if (!empty($data))
		        $this->set($data);
		
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
	 * Function to get active user given email
	 * @access public
	 * @param string email
	 * @return array
	 * @ParamType email string
	 * @ReturnType array
	 */
	public function getUserByEmail($email) {
		$data = array();
		
		try{
		    $sql = "SELECT u.*, p.email, t._id as type FROM `users` as `u` 
		            INNER JOIN `shared_types` as `t` ON `t`.`_id` = `u`.`type_id` 
		            INNER JOIN `shared_profiles` as `p` ON `p`.`owner_id` = `u`.`_id` 
		            WHERE `p`.`email` = '{$email}' AND `u`.`status_id` != '{$this->statuses['deleted']}'";
		
		    if (TSP_Config::get('app.debug'))
		        $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		    $result = $this->conn->RunQuery($sql);
		    $data = $this->conn->FetchHash($result);
		
		    if (!empty($data))
		        $this->set($data);
		
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
	 * Function to get active user given username
	 * @access public
	 * @param string username
	 * @return array
	 * @ParamType username string
	 * @ReturnType array
	 */
	public function getUserByUsername($username) {
		$data = array();
		
		try{
		    session_start();
		
		    $sql = "SELECT u.*, p.email, t._id as type FROM `users` as `u` 
		            INNER JOIN `shared_types` as `t` ON `t`.`_id` = `u`.`type_id` 
		            INNER JOIN `shared_profiles` as `p` ON `p`.`owner_id` = `u`.`_id` 
		            WHERE `u`.`username` = '{$username}' AND `u`.`status_id` != '{$this->statuses['deleted']}' AND `p`.owner = 'U' AND `p`.is_default = 1";
		
		    if (TSP_Config::get('app.debug'))
		        $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		    $result = $this->conn->RunQuery($sql);
		    $data = $this->conn->FetchHash($result);
		
		    if (!empty($data))
		        $this->set($data);
		
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
	 * Function to get user count given type
	 * @access public
	 * @param int type
	 * @return int
	 * @ParamType type int
	 * @ReturnType int
	 */
	public function getUserCount($type = null) {
		$count = 0;
		
		try{
		    if (empty($type))
		        $type = $this->type->getID();
		
		    $sql = "SELECT COUNT(*) as count FROM `{$this->table}` WHERE `type_id` = '{$type}' AND `status_id` != '{$this->statuses['deleted']}' ";
		    
		    if (TSP_Config::get('app.debug'))
		        $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		    
		    $result = $this->conn->RunQuery($sql);
		    $result_count = $this->conn->FetchHash($result);
		    
		    $count = $result_count['count'];
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
		
		return $count;
	}

	/**
	 * Function to get record by SQL
	 * @access protected
	 * @param string sql
	 * @return array
	 * @ParamType sql string
	 * @ReturnType array
	 */
	protected function getUsersBySQL($sql) {
		$users = array();
		
		if (TSP_Config::get('app.debug'))
		    $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		$result = $this->conn->RunQuery($sql);
		while( $row = $this->conn->FetchHash($result)){
		
		    // if the parent ID is set then load the upline user's name
		    if ($row['parent_id'] != -1 && !empty($row['parent_id']))
		    {
		        $row['parent_id'] = intval($row['parent_id']);
		
		        $sql = "SELECT `first_name`, `last_name` FROM `{$this->table}` WHERE `status_id` != '{$this->statuses['deleted']}' AND `_id` = '{$row['parent_id']}'";
		
		        if (TSP_Config::get('app.debug'))
		            $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		        $result1 = $this->conn->RunQuery($sql);
		        $arent = $this->conn->FetchHash($result1);
		
		        if (!empty($arent))
		            $row['parent_name'] = $arent['last_name'] . ", " . $arent['first_name'];
		    }
		    // if parent ID is set and its null then set to default name
		    else if (empty($row['parent_id']))
		        $row['parent_name'] = 'No Upline';
		
		    $users[] = array_map('utf8_encode', $row);
		}
		
		return $users;
	}

	/**
	 * Function to get all users where parent_id is set to owner_id
	 * @access public
	 * @param int user_id
	 * @return array
	 * @ParamType user_id int
	 * @ReturnType array
	 */
	public function getUsersByParentID($user_id) {
		$data = array();
		
		$sql = "SELECT * FROM `{$this->table}` WHERE `parent_id` = '{$user_id}' AND `status_id` != '{$this->statuses['deleted']}'";
		
		if (TSP_Config::get('app.debug'))
		    $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		$result = $this->conn->RunQuery($sql);
		while( $row = $this->conn->FetchHash($result)){
		    $data[] = array_map('utf8_encode', $row);
		}
		
		return $data;
	}

	/**
	 * Function to get the upline users given a user type
	 * @access public
	 * @param int type
	 * @return array
	 * @ParamType type int
	 * @ReturnType array
	 */
	public function getUplineTypes($type) {
		$data = array();
		
		if ($type == ESharedType::Admin)
		   $data = array(ESharedType::Admin);
		else if ($type == ESharedType::GeneralAgent)
		   $data = array(ESharedType::Admin);
		else if ($type == ESharedType::Agent)
		   $data = array(ESharedType::GeneralAgent);
		else if ($type == ESharedType::Client)
		   $data = array(ESharedType::GeneralAgent, ESharedType::Agent);
		else if ($type == ESharedType::Employee)
		   $data = array(ESharedType::Client);
		else if ($type == ESharedType::Dependent)
		   $data = array(ESharedType::Client);
		
		return $data;
	}

	/**
	 * @access public
	 * @param string[] children
	 * @param int type_id
	 * @return array
	 * @ParamType children string[]
	 * @ParamType type_id int
	 * @ReturnType array
	 */
	public function parseDescendantsByType(array $children, $type_id) {
		$data = array();
		
		foreach ($children as $pos => $child)
		{
		    if ($child['type_id'] == $type_id)
		        $data[] = $child['_id'];
		}
		
		return $data;
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

    /**
     * @access public
     * @param int ID
     * @return array
     * @ParamType ID int
     * @ReturnType array
     */
    public function getByID($ID) {
        $data = array();

        try{
            $sql = "SELECT *, CONCAT_WS(' ', `first_name`, `last_name`) AS `title` FROM `{$this->table}` WHERE `_id` = '{$ID}'";

            if (TSP_Config::get('app.debug'))
                $this->response['sql'][] = array('stmt' => $sql, 'params' => null);

            $result = $this->conn->RunQuery($sql);
            $data = $this->conn->FetchHash($result);

            if (!empty($data))
                $this->set($data);

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
	 * @param int parentID
	 * @ParamType parentID int
	 */
	public function setParentID($parentID) {
		$this->parentID = $parentID;
	}

	/**
	 * @access public
	 * @return int
	 * @ReturnType int
	 */
	public function getParentID() {
		return $this->parentID;
	}

	/**
	 * @access public
	 * @param models.Profession profession
	 * @ParamType profession models.Profession
	 */
	public function setProfession(Profession $profession) {
		$this->profession = $profession;
	}

	/**
	 * @access public
	 * @return models.Profession
	 * @ReturnType models.Profession
	 */
	public function getProfession() {
		return $this->profession;
	}

	/**
	 * @access public
	 * @param models.Permission permission
	 * @ParamType permission models.Permission
	 */
	public function setPermission(Permission $permission) {
		$this->permission = $permission;
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
	 * @param models.Company company
	 * @ParamType company models.Company
	 */
	public function setCompany(Company $company) {
		$this->company = $company;
	}

	/**
	 * @access public
	 * @return models.Company
	 * @ReturnType models.Company
	 */
	public function getCompany() {
		return $this->company;
	}

	/**
	 * @access public
	 * @param models.Status status
	 * @ParamType status models.Status
	 */
	public function setStatus(Status $status) {
		$this->status = $status;
	}

	/**
	 * @access public
	 * @return models.Status
	 * @ReturnType models.Status
	 */
	public function getStatus() {
		return $this->status;
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
	 * @param string username
	 * @ParamType username string
	 */
	public function setUsername($username) {
		$this->username = $username;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getUsername() {
		return $this->username;
	}

	/**
	 * @access public
	 * @param string password
	 * @ParamType password string
	 */
	public function setPassword($password) {
		$this->password = $password;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getPassword() {
		return $this->password;
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
	 * @param string firstName
	 * @ParamType firstName string
	 */
	public function setFirstName($firstName) {
		$this->firstName = $firstName;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getFirstName() {
		return $this->firstName;
	}

	/**
	 * @access public
	 * @param string lastName
	 * @ParamType lastName string
	 */
	public function setLastName($lastName) {
		$this->lastName = $lastName;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getLastName() {
		return $this->lastName;
	}

	/**
	 * @access public
	 * @param string bio
	 * @ParamType bio string
	 */
	public function setBio($bio) {
		$this->bio = $bio;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getBio() {
		return $this->bio;
	}

	/**
	 * @access public
	 * @param int dob
	 * @ParamType dob int
	 */
	public function setDob($dob) {
		$this->dob = $dob;
	}

	/**
	 * @access public
	 * @return int
	 * @ReturnType int
	 */
	public function getDob() {
		return $this->dob;
	}

	/**
	 * @access public
	 * @param int dateCreated
	 * @ParamType dateCreated int
	 */
	public function setDateCreated($dateCreated) {
		$this->dateCreated = $dateCreated;
	}

	/**
	 * @access public
	 * @return int
	 * @ReturnType int
	 */
	public function getDateCreated() {
		return $this->dateCreated;
	}

	/**
	 * @access public
	 * @param int dateLastUpdated
	 * @ParamType dateLastUpdated int
	 */
	public function setDateLastUpdated($dateLastUpdated) {
		$this->dateLastUpdated = $dateLastUpdated;
	}

	/**
	 * @access public
	 * @return int
	 * @ReturnType int
	 */
	public function getDateLastUpdated() {
		return $this->dateLastUpdated;
	}
}
?>