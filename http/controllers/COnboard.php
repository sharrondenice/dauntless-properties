<?php

/**
 * @access public
 * @author Sharron Denice
 * @package controllers
 */
final class COnboard extends BaseController {

	/**
	 * 
	 * Function to get onboard metadata
	 * 
	 * @since 1.0.0
	 * @access public
	 * @return array
	 * @ReturnType array
	 */
	public function getMetadata() {
		$data = array();
		
		try{
		    session_start();
		
		    $type       = new Type();
		    $admin      = new Admin();
		    $agent      = new Agent();
		    $g_agent    = new GeneralAgent();
		
		    $admins     = $admin->getAll();
		    $agents     = $agent->getAll();
		    $g_agents   = $g_agent->getAll();
		
		    $exclude = array();
		
		    if ($_SESSION['type_id'] == ESharedType::Admin)
		    {
		        $data['users'] = array_merge($admins['users'], $agents['users'], $g_agents['users']);
		        $exclude = array(ESharedType::Employee,ESharedType::Dependent,ESharedType::User);
		
		        $admin_response = $admin->getResponse();
		        $agent_response = $agent->getResponse();
		        $g_agent_response = $g_agent->getResponse();
		        $this->response['sql'][] = array_merge($admin_response['sql'], $agent_response['sql'], $g_agent_response['sql']);
		    }
		    else if ($_SESSION['type_id'] == ESharedType::GeneralAgent)
		    {
		        $data['users'] = array_merge($agents['users'], $g_agents['users']);
		        $exclude = array(ESharedType::Admin,ESharedType::GeneralAgent,ESharedType::Employee,ESharedType::Dependent,ESharedType::User);
		
		        $agent_response = $agent->getResponse();
		        $g_agent_response = $g_agent->getResponse();
		        $this->response['sql'][] = array_merge($agent_response['sql'], $g_agent_response['sql']);
		    }
		    else
		    {
		        $data['users'] = $agents['users'];
		        $exclude = array(ESharedType::Admin,ESharedType::GeneralAgent,ESharedType::Agent,ESharedType::Employee,ESharedType::Dependent,ESharedType::User);
		
		        $agent_response = $agent->getResponse();
		        $this->response['sql'][] = $agent_response['sql'];
		    }
		
		    $data['types'] = $type->getAll(EOwnerType::User, null, $exclude);
		
		    $type_response = $type->getResponse();
		    $this->response['sql'][] = $type_response['sql'];
		
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
	 * 
	 * Function to add a record
	 * 
	 * @since 1.0.0
	 * 
	 * 
	 * 
	 * @internal param $permissions
	 * @internal param $status
	 * @internal param $onboard_type
	 * @internal param $profile_type
	 * @internal param $none
	 * @access public
	 * @param int status
	 * @param string object_type
	 * @param int profile_type
	 * @param string[] params
	 * @return string[]
	 * @ParamType status int
	 * @ParamType object_type char
	 * @ParamType profile_type int
	 * @ParamType params string[]
	 * @ReturnType string[]
	 */
	public function createRecord($status = null, $object_type = null, $profile_type = null, array $params = array()) {
		session_start();
		
		$granter_id        = TSP_Helper::arrGetVal($_POST, 'granter_id', $params['granter_id']);
		$type              = TSP_Helper::arrGetVal($_POST, 'type_id', $params['type_id']);
		$email             = TSP_Helper::arrGetVal($_POST, 'email', $params['email']);
		$type_description  = TSP_Helper::arrGetVal($_POST, 'type_description', $params['type_description']);
		
		$access_key        = TSP_Helper::genKey(18, false);
		
		if (empty($granter_id ) || $granter_id  == 'undefined')
		    $granter_id  = $_SESSION['_id'];
		
		$data = array(
		    'access_key'    => $access_key,
		    'granter_id'    => $granter_id,
		    'email'         => $email,
		    'type_id'          => $type
		);
		
		$onboard = new Onboard();
		$ID = $onboard->add($data);
		
		$data['onboard_id'] = $ID;
		
		$this->response = $onboard->getResponse();
		
		if (empty($ID))
		   $this->response['error'] = array(
                'title' => 'Error Occurred',
                'message' => 'Onboard was not created. Please contact system administrator.',
                'type' => 'error',
            );

		else
		{
		   $this->response['success'] = array(
                'title' => 'Success',
                'message' => 'Data successfully retrieved.',
                'type' => 'success',
            );
		
		    $params['email'] = $email;
		    $params['access_key'] = $access_key;
		    $params['template'] = 'onboard';
		    $params['subject'] = 'Invitation to Register at Enroll 123';
		
		    System::notifyCustomer($params);
		}
		
		ActvityHelper::log($_SESSION['_id'], "CREATE: {$onboard->getName()} {$onboard->getAccessKey()} #{$ID}", $this->response);
		
		return $data;
	}

	/**
	 * 
	 * Function to update a record
	 * 
	 * @since 1.0.0
	 * 
	 * 
	 * 
	 * @internal param $none
	 * @access public
	 * @param string[] params
	 * @return array
	 * @ParamType params string[]
	 * @ReturnType array
	 */
	public function updateRecord(array $params = array()) {
		session_start();
		
		$ID                = TSP_Helper::arrGetVal($_POST, '_id', $params['_id']);
		$granter_id        = TSP_Helper::arrGetVal($_POST, 'granter_id', $params['granter_id']);
		$type              = TSP_Helper::arrGetVal($_POST, 'type_id', $params['type_id']);
		$email             = TSP_Helper::arrGetVal($_POST, 'email', $params['email']);
		
		$data = array(
		    '_id'            => $ID,
		    'granter_id'    => $granter_id,
		    'email'         => $email,
		    'type_id'          => $type
		);
		
		$onboard = new Onboard();
		$onboard_found = $onboard->getByID($ID);
		
		$this->response = $onboard->getResponse();
		
		if (!empty($onboard_found))
		{
		    $onboard->add($data);
		
		    $this->response = $onboard->getResponse();
		
		    $this->response['success'] = array(
                'title' => 'Success',
                'message' => 'Data successfully retrieved.',
                'type' => 'success',
            );
		
		    ActvityHelper::log($_SESSION['_id'], "UPDATE: {$onboard->getName()} {$onboard->getAccessKey()} #{$ID}", $this->response);
		}
		else
		   $this->response['error'] = array(
                'title' => 'Error Occurred',
                'message' => 'Unable to update record. Please contact system administration.',
                'type' => 'error',
            );

		
		return $data;
	}

	/**
	 * 
	 * Function to delete a record
	 * 
	 * @since 1.0.0
	 * @access public
	 * @return array
	 * @ReturnType array
	 */
	public function deleteRecord() {
		session_start();
		
		$ID = TSP_Helper::arrGetVal($_POST, '_id');
		
		$onboard = new Onboard();
		$onboard->delete($ID);
		
		$status = new Status();
		$data = $status->getStatusByOwnerType($onboard->getOwnerType(), $onboard->statuses['deleted']);
		
		$onboard_response = $onboard->getResponse();
		$status_response = $status->getResponse();
		
		$this->response['sql'][] = array_merge($onboard_response['sql'], $status_response['sql']);
		
		$this->response['success'] = array(
                'title' => 'Success',
                'message' => 'Data successfully retrieved.',
                'type' => 'success',
            );
		
		ActvityHelper::log($_SESSION['_id'], "DELETE: {$onboard->getName()} {$onboard->getAccessKey()} #{$ID}", $this->response);
		
		return $data;
	}

	/**
	 * 
	 * Function to deactivate a record
	 * 
	 * @since 1.0.0
	 * @access public
	 * @return array
	 * @ReturnType array
	 */
	public function deactivateRecord() {
		session_start();
		
		$ID = TSP_Helper::arrGetVal($_POST, '_id');
		
		$onboard = new Onboard();
		$onboard->deactivate($ID);
		
		$status = new Status();
		$data = $status->getStatusByOwnerType($onboard->getOwnerType(), $onboard->statuses['disabled']);
		
		$onboard_response = $onboard->getResponse();
		$status_response = $status->getResponse();
		
		$this->response['sql'][] = array_merge($onboard_response['sql'], $status_response['sql']);
		
		$this->response['success'] = array(
                'title' => 'Success',
                'message' => 'Data successfully retrieved.',
                'type' => 'success',
            );
		
		ActvityHelper::log($_SESSION['_id'], "DEACTIVATE: {$onboard->getName()} {$onboard->getAccessKey()} #{$ID}", $this->response);
		
		return $data;
	}

	/**
	 * 
	 * Function to activate a record
	 * 
	 * @since 1.0.0
	 * @access public
	 * @return array
	 * @ReturnType array
	 */
	public function activateRecord() {
		session_start();
		
		$ID = TSP_Helper::arrGetVal($_POST, '_id');
		
		$onboard = new Onboard();
		$onboard->activate($ID);
		
		$status = new Status();
		$data = $status->getStatusByOwnerType($onboard->getOwnerType(), $onboard->statuses['active']);
		
		$onboard_response = $onboard->getResponse();
		$status_response = $status->getResponse();
		
		$this->response['sql'][] = array_merge($onboard_response['sql'], $status_response['sql']);
		
		$this->response['success'] = array(
                'title' => 'Success',
                'message' => 'Data successfully retrieved.',
                'type' => 'success',
            );
		
		ActvityHelper::log($_SESSION['_id'], "ACTIVATE: {$onboard->getName()} {$onboard->getAccessKey()} #{$ID}", $this->response);
		
		return $data;
	}

	/**
	 * 
	 * Function to onboard given access_key
	 * 
	 * @since 1.0.0
	 * @access public
	 * @param string access_key
	 * @return array
	 * @ParamType access_key string
	 * @ReturnType array
	 */
	public function validate($access_key) {
		session_start();
		
		$this->response['success']  = array();
		
		if (!empty($access_key))
		{
		    $onboard = new Onboard();
		    $onboard->setAccessKey($access_key);
		    $onboard_record = $onboard->getUnregisteredOnboard();
		    $ID = $onboard_record['_id'];
		
		    $this->response = $onboard->getResponse();
		
		    if (!empty($onboard_record))
		    {
		        $data['email'] = $onboard_record['email'];
		        $this->response['success'] = array(
                    'title' => 'Success',
                    'message' => 'Data successfully retrieved.',
                    'type' => 'success',
                );
		
		        ActvityHelper::log($_SESSION['_id'], "VALIDATE: {$onboard->getName()} {$onboard->getAccessKey()} #{$ID}", $this->response);
		    }
		}
		
		// If the access_key was not valid for the user to the login screen
		if (empty($this->response['success']))
		{
            $this->response['error'] = array(
                'title' => 'Error Occurred',
                'message' => 'Access key is not valid. Please try again.',
                'type' => 'error',
            );
		    $this->response['access_granted'] = false;
		}
		
		return $data;
	}
}
?>