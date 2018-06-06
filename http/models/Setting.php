<?php

/**
 * @access public
 * @author Sharron Denice
 * @package models
 */
class Setting extends BaseModel {
	/**
	 * @AttributeType string
	 */
	private $owner;
	/**
	 * @AttributeType int
	 */
	private $owner_id;
    /**
     * @AttributeType int
     */
    private $responsible_company_id;
    /**
     * @AttributeType boolean
     */
    private $is_global;
    /**
     * @AttributeType string
     */
    private $setting_name;
    /**
     * @AttributeType string
     */
    private $setting_value;

	/**
	 * @access public
	 * @param int id
	 * @ParamType id int
	 */
	public function __construct($id = null) {
		try{
		    parent::__construct($id);
		
		    $this->ownerType   = EOwnerType::Setting;
		    $this->name         = 'Setting';
		    $this->route        = 'setting';
		    $this->table        = 'system_settings';
		
		    $this->dataFields  = array(
		        'owner',
		        'owner_id',
                'responsible_company_id',
                'is_global',
                'setting_name',
                'setting_value'
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
		if (isset($data['owner']))
		    $this->setOwner($data['owner']);
        if (isset($data['owner_id']))
            $this->setOwnerID($data['owner_id']);
        if (isset($data['is_global']))
            $this->setIsGlobal($data['is_global']);
        if (isset($data['responsible_company_id']))
            $this->setResponsibleCompanyID($data['responsible_company_id']);
 		if (isset($data['setting_name']))
		    $this->setSettingName($data['setting_name']);
        if (isset($data['setting_value']))
            $this->setSettingValue($data['setting_value']);

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
		        $owner = EOwnerType::Setting;
		
		    $sql = "SELECT `c`.*
		            FROM `system_settings` as `c` 
		            ORDER BY `c`.`_id`";


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

                $data[$index]['metadata'] = array(
                    'location' => array(
                        'address1'  => $data[$index]['address1'],
                        'address2'  => $data[$index]['address2'],
                        'city'      => $data[$index]['city'],
                        'state'     => array_map('utf8_encode', $this_state),
                        'country'   => array_map('utf8_encode', $this_country),
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
     * Function to get list of all settings by company
     * @access public
     * @param int $company_id
     * @return array
     * @ParamType $company_id int
     * @ReturnType array
     */
    public function getAllByCompany($company_id) {
        $data = array();

        try{
            session_start();

            if (empty($owner))
                $owner = EOwnerType::Setting;

            $sql = "SELECT `c`.*
		            FROM `system_settings` as `c`
		            WHERE `c`.`responsible_company_id` = '{$company_id}'
		            ORDER BY `c`.`_id`";


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

                $data[$index]['metadata'] = array(
                    'location' => array(
                        'address1'  => $data[$index]['address1'],
                        'address2'  => $data[$index]['address2'],
                        'city'      => $data[$index]['city'],
                        'state'     => array_map('utf8_encode', (array)$this_state),
                        'country'   => array_map('utf8_encode', (array)$this_country),
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
     * Function to get list of all settigns by users
     * @access public
     * @param int $user_id
     * @return array
     * @ParamType $user_id int
     * @ReturnType array
     */
    public function getAllByUser($user_id) {
        $data = array();

        try{
            session_start();

            if (empty($owner))
                $owner = EOwnerType::Setting;

            $sql = "SELECT `c`.*
		            FROM `system_settings` as `c`
		            WHERE `c`.`user_id` = '{$user_id}'
		            ORDER BY `c`.`_id`";


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

                $data[$index]['metadata'] = array(
                    'location' => array(
                        'address1'  => $data[$index]['address1'],
                        'address2'  => $data[$index]['address2'],
                        'city'      => $data[$index]['city'],
                        'state'     => array_map('utf8_encode', (array)$this_state),
                        'country'   => array_map('utf8_encode', (array)$this_country),
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
	 * @param string owner
	 * @ParamType owner string
	 */
	public function setOwner($owner) {
		$this->owner = $owner;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getOwner() {
		return $this->owner;
	}
    /**
     * @access public
     * @param string owner_id
     * @ParamType owner string
     */
    public function setOwnerID($owner_id) {
        $this->owner_id = $owner_id;
    }

    /**
     * @access public
     * @return string
     * @ReturnType string
     */
    public function getOwnerID() {
        return $this->owner_id;
    }
    /**
     * @access public
     * @param boolean $is_global
     * @ParamType $is_global boolean
     */
    public function setIsGlobal($is_global) {
        $this->is_global = $is_global;
    }

    /**
     * @access public
     * @return boolean
     * @ReturnType boolean
     */
    public function getIsGlobal() {
        return $this->is_global;
    }
    /**
     * @access public
     * @param string $setting_name
     * @ParamType $setting_name string
     */
    public function setSettingName($setting_name) {
        $this->setting_name = $setting_name;
    }

    /**
     * @access public
     * @return string
     * @ReturnType string
     */
    public function getSettingName() {
        return $this->setting_name;
    }
    /**
     * @access public
     * @param string $setting_value
     * @ParamType $setting_value string
     */
    public function setSettingValue($setting_value) {
        $this->setting_value = $setting_value;
    }

    /**
     * @access public
     * @return string
     * @ReturnType string
     */
    public function getSettingValue() {
        return $this->setting_value;
    }
    /**
     * @access public
     * @param int $responsible_company_id
     * @ParamType $responsible_company_id int
     */
    public function setResponsibleCompanyID($responsible_company_id) {
        $this->responsible_company_id = $responsible_company_id;
    }

    /**
     * @access public
     * @return string
     * @ReturnType string
     */
    public function getResponsibleCompanyID() {
        return $this->responsible_company_id;
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