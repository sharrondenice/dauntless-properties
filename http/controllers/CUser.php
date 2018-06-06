<?php

/**
 * @access public
 * @author Sharron Denice
 * @package controllers
 */
class CUser extends BaseController {

	/**
	 * 
	 * Function to get record metadata
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
		
		    $type = new Type();
		    $status = new Status();
		    $state = new State();
		    $country = new Country();
		    $product = new Product();
		    $company = new Company();
		
		    $data['types'] = $type->getAll(EOwnerType::User);
		    $data['dependent_types'] = $type->getAll(EOwnerType::Dependent);
		    $data['statuses'] = $status->getAll(EOwnerType::User);
		    $data['countries'] = $country->getAll();
		    $data['states'] = $state->getAll();
		    $data['products'] = $product->getAll();
		    $data['companies'] = $company->getAll();
		
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
	 * Function to get the current logged in user's info
	 * 
	 * @since 1.0.0
	 * 
	 * 
	 * 
	 * @internal param $none
	 * @access public
	 * @return array
	 * @ReturnType array
	 */
	public function getCurrentUser() {
		$data = array();
		
		session_start();
		
		$current_user_found = false;

        $token = TSP_Helper::arrGetVal($_POST, 'token', "");
        $username = "";

        if (empty($username))
        {
            list($username, $null) = preg_split("/\?\?/", base64_decode($token));
            //$username = TSP_Helper::openDecrypt(System::getCookieSalt(), $token, TSP_Config::get('app.checksums.secret_key'));

            if (TSP_Config::get('app.debug'))
                TSP_Log::info("Token: " . $username);
        }
        if (empty($username))
        {
            $username = TSP_Helper::cookieGet('username', TSP_Settings::$cookie_prefix);
            $username = TSP_Helper::openDecrypt(System::getCookieSalt(), $username, TSP_Config::get('app.checksums.secret_key'));

            if (TSP_Config::get('app.debug'))
                TSP_Log::info("Cookie: " . $username);
        }
        if (empty($username))
        {
            $username = $_SESSION['username'];

            if (TSP_Config::get('app.debug'))
                TSP_Log::info("Session: " . $username);
        }

		if (!empty($username))
		{
		    $user = new User();
		    $user_found = $user->getUserByUsername($username);
		
		    //$permission = new Permission();
		    //$permission->getPermissionsByID($user_found['_id']);
		
		    if (count($user_found) > 0)
		    {
		        $data['current_user'] = array(
		            '_id'           => $user_found['_id'],
		            'status_id'     => $user_found['status_id'],
		            'type_id'       => $user_found['type_id'],
		            'username'      => $user_found['username'],
		            'email'         => $user_found['email'],
		            'first_name'    => $user_found['first_name'],
		            'last_name'     => $user_found['last_name'],
		            'photo'         => System::getGravatarURL($user_found['email']),
                    // @TODO: Get User preferences when finished with UI
                    'preferences'   => array(
                        'current_company_id'    => 1,
                    )
		        );
		
		        $current_user_found = true;
		    }
		}

		if (!$current_user_found)
		{
		    $data['current_user'] = array(
		        '_id'           => null,
		        'status_id'     => null,
		        'type_id'       => null,
		        'username'      => null,
		        'email'         => null,
		        'first_name'    => null,
		        'last_name'     => null,
		        'photo'         => null,
		        'permissions'   => null,
		    );
		
		   $this->response['error'] = array(
                'title' => 'Error Occurred',
                'message' => 'Login required.',
                'type' => 'error',
            );

		    $this->response['access_granted'] = false;
		}
		else
		   $this->response['success'] = array(
                'title' => 'Success',
                'message' => 'Data successfully retrieved.',
                'type' => 'success',
            );
		
		return $data;
	}

	/**
	 * Function to get user info for the current user
	 * @since 1.0.0
	 * @internal param $none
	 * @access public
	 * @return array
	 * @ReturnType array
	 */
	public function getCurrentUserInfo() {
		session_start();
		
		$username = TSP_Helper::cookieGet('username', TSP_Settings::$cookie_prefix);
		$username = TSP_Helper::openDecrypt(System::getCookieSalt(), $username, TSP_Config::get('app.checksums.secret_key'));
		
		if (empty($username))
		    $username = $_SESSION['username'];
		
		$user = new User();
		$data['user'] = $user->getActiveUserByUsername($username);
		
		$profile = new Profile();
		
		$data['user']['profile'] = $profile->getDefaultProfile($user->getOwnerType(), $user->getID());
		
		if (!empty($data['user']['profile']))
		{
		    $data['user']['default_profile'] = ESharedType::Work;
		    //$data['user']['default_profile'] = $data['user']['profile']['type_id'];
		}
		else
		    $data['user']['default_profile'] = ESharedType::Work;
		
		$data['user']['profile']['21'] = $profile->getProfileByOwner($user->getOwnerType(), $user->getID(), ESharedType::Work);
		$data['user']['profile']['22'] = $profile->getProfileByOwner($user->getOwnerType(), $user->getID(), ESharedType::Home);
		$data['user']['profile']['23'] = $profile->getProfileByOwner($user->getOwnerType(), $user->getID(), ESharedType::Other);
		
		$data['user']['photo'] = System::getGravatarURL($data['user']['profile']['email']);
		
		$data['user']['counts']['admins']       = $user->getDownlineCount($user->getID(), ESharedType::Admin);
		$data['user']['counts']['gas']          = $user->getDownlineCount($user->getID(), ESharedType::GeneralAgent);
		$data['user']['counts']['agents']       = $user->getDownlineCount($user->getID(), ESharedType::Agent);
		$data['user']['counts']['clients']      = $user->getDownlineCount($user->getID(), ESharedType::Client);
		$data['user']['counts']['employees']    = $user->getDownlineCount($user->getID(), ESharedType::Employee);
		
		$state = new State();
		$country = new Country();
		
		$data['countries'] = $country->getAll();
		$data['states'] = $state->getAll();
		
		$user_response = $user->getResponse();
		$profile_response = $profile->getResponse();
		$state_response = $state->getResponse();
		$country_response = $country->getResponse();
		
		$this->response['sql'][] = array_merge($user_response['sql'], $profile_response['sql'], $state_response['sql'], $country_response['sql']);
		
		$this->response['success'] = array(
                'title' => 'Success',
                'message' => 'Data successfully retrieved.',
                'type' => 'success',
            );
		
		return $data;
	}

	/**
	 * Function to get user info given ID
	 * @since 1.0.0
	 * @internal param $none
	 * @access public
	 * @param int type
	 * @param int id
	 * @return array
	 * @ParamType type int
	 * @ParamType id int
	 * @ReturnType array
	 */
	public function getUserInfoByID($type, $id) {
		session_start();
		
		$user = new User();
		$data['user'] = $user->getUserByID($id);
		
		$profile = new Profile();
		
		$data['user']['profile'] = $profile->getDefaultProfile($user->getOwnerType(), $user->getID());
		
		if (!empty($data['user']['profile']))
		{
		    $data['user']['default_profile'] = ESharedType::Work;
		    //$data['user']['default_profile'] = $data['user']['profile']['type_id'];
		}
		else
		    $data['user']['default_profile'] = ESharedType::Work;
		
		$data['user']['profile']['21'] = $profile->getProfileByOwner($user->getOwnerType(), $user->getID(), ESharedType::Work);
		$data['user']['profile']['22'] = $profile->getProfileByOwner($user->getOwnerType(), $user->getID(), ESharedType::Home);
		$data['user']['profile']['23'] = $profile->getProfileByOwner($user->getOwnerType(), $user->getID(), ESharedType::Other);
		
		$data['user']['photo'] = System::getGravatarURL($data['user']['profile']['email']);
		
		$data['user']['counts']['admins']       = $user->getDownlineCount($user->getID(), ESharedType::Admin);
		$data['user']['counts']['gas']          = $user->getDownlineCount($user->getID(), ESharedType::GeneralAgent);
		$data['user']['counts']['agents']       = $user->getDownlineCount($user->getID(), ESharedType::Agent);
		$data['user']['counts']['clients']      = $user->getDownlineCount($user->getID(), ESharedType::Client);
		$data['user']['counts']['employees']    = $user->getDownlineCount($user->getID(), ESharedType::Employee);
		
		$user_type = ESharedType::User;
		
		if (!empty($user->objectTypes[$type]))
		    $user_type = $user->objectTypes[$type];
		
		if ($user_type == ESharedType::Client)
		{
		    $client = new Client($user->getID());
		    $data['user']['client_products'] = $client->getProducts();
		}
		else if ($user_type == ESharedType::Employee)
		{
		    $employee = new Employee($user->getID());
		    $data['user']['employee_products'] = $employee->getProducts();
		    $data['user']['employee_dependents'] = $employee->getDependents();
		}
		
		$state = new State();
		$country = new Country();
		
		$data['countries'] = $country->getAll();
		$data['states'] = $state->getAll();
		
		$user_response = $user->getResponse();
		$profile_response = $profile->getResponse();
		$state_response = $state->getResponse();
		$country_response = $country->getResponse();
		
		$this->response['sql'][] = array_merge($user_response['sql'], $profile_response['sql'], $state_response['sql'], $country_response['sql']);
		
		$this->response['success'] = array(
                'title' => 'Success',
                'message' => 'Data successfully retrieved.',
                'type' => 'success',
            );
		
		return $data;
	}

	/**
	 * 
	 * Function to create a record
	 * 
	 * @since 1.0.0
	 * 
	 * 
	 * 
	 * 
	 * 
	 * 
	 * @internal param $none
	 * @access public
	 * @param int type
	 * @param string[] params
	 * @return array
	 * @ParamType type int
	 * @ParamType params string[]
	 * @ReturnType array
	 */
	public function addRecord($type, array $params = array()) {
		$user = new User();
		
		$user_type = ESharedType::User;
		
		if (!empty($user->objectTypes[$type]))
		    $user_type = $user->objectTypes[$type];
		
		$data = $this->createRecord(ESharedStatus::UserActive, $user_type, ESharedType::Work, $_POST);
		
		return $data;
	}

	/**
	 * Function to add a record
	 * @since 1.0.0
	 * @internal param $none
	 * @access public
	 * @param int status
	 * @param string object_type
	 * @param int profile_type
	 * @param string[] params
	 * @return array
	 * @ParamType status int
	 * @ParamType object_type char
	 * @ParamType profile_type int
	 * @ParamType params string[]
	 * @ReturnType array
	 */
	public function createRecord($status = null, $object_type = null, $profile_type = null, array $params = array()) {
		session_start();
		
		$granter_id        = TSP_Helper::arrGetVal($_POST, 'granter_id', $params['granter_id']);
		$parent_id         = TSP_Helper::arrGetVal($_POST, 'parent_id', $params['parent_id']);
		$company_id        = TSP_Helper::arrGetVal($_POST, 'company_id', $params['company_id']);
		$email             = TSP_Helper::arrGetVal($_POST, 'email', $params['email']);
		$username          = TSP_Helper::arrGetVal($_POST, 'username', $params['username']);
		$first_name        = TSP_Helper::arrGetVal($_POST, 'first_name', $params['first_name']);
		$last_name         = TSP_Helper::arrGetVal($_POST, 'last_name', $params['last_name']);
		$company           = TSP_Helper::arrGetVal($_POST, 'company', $params['company']);
		$title             = TSP_Helper::arrGetVal($_POST, 'title', $params['title']);
		$password          = TSP_Helper::arrGetVal($_POST, 'password', $params['password']);
		$password2         = TSP_Helper::arrGetVal($_POST, 'password2', $params['password2']);
		$bio               = TSP_Helper::arrGetVal($_POST, 'bio', $params['bio']);
		$dob               = TSP_Helper::arrGetVal($_POST, 'dob', $params['dob']);
		$client_products   = TSP_Helper::arrGetVal($_POST, 'client_products', $params['client_products']);
		$employee_products = TSP_Helper::arrGetVal($_POST, 'employee_products', $params['employee_products']);
		$employee_dependents = TSP_Helper::arrGetVal($_POST, 'employee_dependents', $params['employee_dependents']);
		
		if (empty($parent_id ) || $parent_id  == 'undefined')
		    $parent_id  = $_SESSION['_id'];
		if (empty($company_id) || $company_id == 'undefined')
		    $company_id = 'null';
		
		if ((empty($parent_id) ||  $parent_id  == 'null') && !empty($granter_id) && $granter_id != 'undefined')
		    $parent_id  = $granter_id;
		
		if ($object_type == ESharedType::Employee)
		{
		    $username = strtolower($first_name).strtolower($last_name).'-'.strtolower(TSP_Helper::genKey(3,false));
		    $password = TSP_Helper::genKey(18, false);
		    $password2 = $password;
		}
		
		$user = new User();
		$user_found = $user->getUserByUsername($username);
		
		$profile = new Profile();
		$profile_found = $profile->getProfileByEmail($email);
		
		$user_response = $user->getResponse();
		$profile_response = $profile->getResponse();
		
		$this->response['sql'][] = $user_response['sql'];
		$this->response['sql'][] = $profile_response['sql'];
		
		if (!empty($username) && !empty($password) && !empty($password2))
		{
		    if ($password == $password2)
		    {
		        if (((isset($user_found) && count($user_found) == 0) &&
		                (isset($profile_found) && count($profile_found) == 0)) ||
		            (empty($user_found) && empty($profile_found)))
		        {
		            $hash = new PasswordHash(8, true);
		            $password = $hash->HashPassword( $password );
		
		            $data = array(
		                'parent_id'         => $parent_id,
		                'company_id'        => $company_id,
		                'status_id'         => $status,
		                'type_id'           => $object_type,
		                'username'          => $username,
		                'first_name'        => $first_name,
		                'last_name'         => $last_name,
		                'password'          => $password
                    );
		
		            $user_id = $user->add($data);
		            $data['user_id'] = $user_id;
		
		            $user_response = $user->getResponse();
		            $this->response['sql'][] = $user_response['sql'];
		
		            if (!empty($user_id))
		            {
		                $data = array(
		                    'email'     => $email,
		                    'type_id'   => $profile_type,
		                    'default'   => 1,
		                    'owner'     => $user->getOwnerType(),
		                    'owner_id'  => $user_id,
		                );
		                $profile->add($data);
		
		                $profile_response = $profile->getResponse();
		                $this->response['sql'][] = $profile_response['sql'];
		
		                if (!empty($client_products))
		                {
		                    $client = new Client($user_id);
		                    $client->addProducts($client_products);
		
		                    $client_response = $client->getResponse();
		                    $this->response['sql'][] = $client_response['sql'];
		                }
		                else if (!empty($employee_products))
		                {
		                    $employee = new Employee($user_id);
		                    $employee->addProducts($employee_products);
		                    $employee->addDependents($employee_dependents);
		
		                    $employee_response = $employee->getResponse();
		                    $this->response['sql'][] = $employee_response['sql'];
		                }
		
		                if ($object_type != ESharedType::Employee)
		                {
		                    $params['template'] = 'register';
		                    $params['subject'] = 'Welcome to Enroll 123';
		    
		                    System::notifyCustomer($params);
		                }

                        $this->response['success'] = array(
                            'title' => 'Success',
                            'message' => $user->getName() . ' added successfully.',
                            'type' => 'success',
                        );
		            }
		            else
		            {
		               $this->response['error'] = array(
                            'title' => 'Error Occurred',
                            'message' => 'User account was not created. Please contact system administrator.',
                            'type' => 'error',
                        );
		            }
		        }
		        else
		        {
		            $username_found = false;
		            $email_found = false;
		
		            if ((isset($profile_found) && count($profile_found) > 0) || !empty($profile_found))
		                $email_found = true;
		
		            if ((isset($user_found) && count($user_found) > 0) || !empty($user_found))
		                $username_found = true;
		
		            if ($email_found && $username_found)
		               $this->response['error'] = array(
                            'title' => 'Error Occurred',
                            'message' => 'The email and/or username entered exists. Please update the user\'s record.',
                            'type' => 'error',
                        );

		            elseif (!$email_found && $username_found)
		               $this->response['error'] = array(
                            'title' => 'Error Occurred',
                            'message' => 'The username entered exists. Please update the user\'s record.',
                            'type' => 'error',
                       );

		            elseif ($email_found && !$username_found)
		               $this->response['error'] = array(
                            'title' => 'Error Occurred',
                            'message' => 'The email entered exists. Please update the user\'s record.',
                            'type' => 'error',
                        );

		            elseif (!$email_found && !$username_found)
		               $this->response['error'] = array(
                            'title' => 'Error Occurred',
                            'message' => 'An unknown error occurred during saving. Please contact your system administrator or try again at a later time.',
                            'type' => 'error',
                        );

		        }
		    }
		    else
		       $this->response['error'] = array(
                'title' => 'Error Occurred',
                'message' => 'Passwords don\'t match.',
                'type' => 'error',
            );

		}
		elseif (empty($username))
		{
		   $this->response['error'] = array(
                'title' => 'Error Occurred',
                'message' => 'Username field was empty.',
                'type' => 'error',
            );

		}
		elseif (empty($password))
		{
		   $this->response['error'] = array(
                'title' => 'Error Occurred',
                'message' => 'Password field was empty.',
                'type' => 'error',
            );

		}
		elseif (empty($password2))
		{
		   $this->response['error'] = array(
                'title' => 'Error Occurred',
                'message' => 'You need to confirm the password.',
                'type' => 'error',
            );

		}
		
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
		$parent_id          = TSP_Helper::arrGetVal($_POST, 'parent_id', $params['parent_id']);
		$company_id        = TSP_Helper::arrGetVal($_POST, 'company_id', $params['company_id']);
		$company             = TSP_Helper::arrGetVal($_POST, 'company', $params['company']);
		$title             = TSP_Helper::arrGetVal($_POST, 'title', $params['title']);
		$first_name        = TSP_Helper::arrGetVal($_POST, 'first_name', $params['first_name']);
		$last_name         = TSP_Helper::arrGetVal($_POST, 'last_name', $params['last_name']);
		$password          = TSP_Helper::arrGetVal($_POST, 'password', $params['password']);
		$password2         = TSP_Helper::arrGetVal($_POST, 'password2', $params['password2']);
		$bio               = TSP_Helper::arrGetVal($_POST, 'bio', $params['bio']);
		$default_profile   = TSP_Helper::arrGetVal($_POST, 'default_profile', $params['default_profile']);
		$username          = TSP_Helper::arrGetVal($_POST, 'username', $params['username']);
		
		$short_form        = TSP_Helper::arrGetVal($_POST, 'short_form', $params['short_form']);
		
		// Short Form Details
		$parent_id          = TSP_Helper::arrGetVal($_POST, 'parent_id', $params['parent_id']);
		$status            = TSP_Helper::arrGetVal($_POST, 'status_id', $params['status_id']);
		$type              = TSP_Helper::arrGetVal($_POST, 'type_id', $params['type_id']);
		$email             = TSP_Helper::arrGetVal($_POST, 'email', $params['email']);
		
		if (empty($parent_id ) || $parent_id  == 'undefined')
		    $parent_id  = 'null';
		if (empty($company_id) || $company_id == 'undefined')
		    $company_id = 'null';
		if (empty($short_form) || $short_form == 'undefined')
		    $short_form = false;
		if (empty($default_profile) || $default_profile == 'undefined')
		    $default_profile = ESharedType::Work;
		
		if (!empty($username))
		{
		    if ($password == $password2)
		    {
		        if (!empty($password))
		        {
		            $hash = new PasswordHash(8, true);
		            $password = $hash->HashPassword( $password );
		        }
		
		        $user = new User();
		
		        $user_found = array();
		        $user_found = $user->getByID($ID);
		
		        $this->response = $user->getResponse();
		
		        $username_exists = false;
		
		        // If the username changed make sure it doesn't already exist
		        if ($user->getUsername() != $username)
		        {
		            $find_user = new User();
		            $record_found = $find_user->getUserByUsername($username);
		
		            if (!empty($record_found))
		                $username_exists = true;
		        }
		
		        if ($username_exists)
		        {
		           $this->response['error'] = array(
                        'title' => 'Error Occurred',
                        'message' => 'The username entered exists. Please update the user\'s record.',
                        'type' => 'error',
                    );

		        }
		        else if (!$username_exists && !empty($user_found))
		        {
		
		            $profile = new Profile();
		
		            $user_data = array(
		                '_id'                => $user->getID(),
		                'parent_id'         => $parent_id ,
		                'company_id'        => $company_id,
		                'first_name'        => $first_name,
		                'last_name'         => $last_name,
		                'username'          => $username,
		                'company'             => $company,
		                'title'             => $title,
		                'bio'               => $bio,
		            );
		
		            if (!empty($password))
		                $user_data['password'] = $password;
		
		            if ($short_form)
		            {
		                $user_data = array(
		                    '_id'                => $user->getID(),
		                    'parent_id'         => $parent_id ,
		                    'status_id'            => $status,
		                    'type_id'              => $type,
		                    'first_name'        => $first_name,
		                    'last_name'         => $last_name,
		                    'username'          => $username,
		                );
		            }
		
		            $user->update($user_data);
		
		            if ($short_form)
		            {
		                $profile_data = array(
		                    'email'             => $email,
		                );
		
		                $profile->updateOwnerDefaultProfile($user->getOwnerType(), $user->getID(), $profile_data);
		            }
		            else
		            {
		                // Make no profiles default
		                $profile_data = array(
		                    'default'             => 0,
		                );
		
		                $profile->updateProfileByOwner($user->getOwnerType(), $user->getID(), $profile_data);
		
		                // Make a profile default given the profile type
		                $profile_data = array(
		                    'default'             => 1,
		                );
		
		                $profile->updateProfileByType($user->getOwnerType(), $user->getID(), $default_profile, $profile_data);
		            }
		
		            if (!$short_form)
		            {
		                $existing_profile = $profile->getDefaultProfile($user->getOwnerType(),  $user->getID());
		
		                // If the user chose a default profile that isn't saved create an empty profile
		                if (empty($existing_profile))
		                {
		                    $params = array(
		                        'default'           => 1,
		                    );
		                    $this->updateProfile($default_profile, $params);
		                }
		            }
		
		            ActvityHelper::log($_SESSION['_id'], "UPDATE: {$profile->getName()} #{$user->getID()} ({$user->getUsername()})", $this->response);
		
		            // If the status of the user account change send an activation email
		            if ($user_found['status_id'] != $status)
		            {
		                if ($status == ESharedStatus::User_active)
		                {
		                    $params['template'] = 'activate';
		                    $params['subject'] = 'Enroll 123 Account Successfully Activated';
		
		                    System::notifyCustomer($params);
		                }
		            }
		
		            $user_response = $user->getResponse();
		            $profile_response = $profile->getResponse();
		
		            $this->response['sql'][] = array_merge($user_response['sql'], $profile_response['sql']);
                    $this->response['success'] = array(
                        'title' => 'Success',
                        'message' => $user->getName() . ' updated successfully.',
                        'type' => 'success',
                    );
		        }
		        else
		           $this->response['error'] = array(
                'title' => 'Error Occurred',
                'message' => 'Unable to update record. Please contact system administration.',
                'type' => 'error',
            );

		    }
		    else
		       $this->response['error'] = array(
                'title' => 'Error Occurred',
                'message' => 'Passwords don\'t match.',
                'type' => 'error',
            );

		}
		elseif (empty($username))
		{
		   $this->response['error'] = array(
                'title' => 'Error Occurred',
                'message' => 'Username field was empty.',
                'type' => 'error',
            );

		}
		
		if (isset($this->response['success']) && !empty($this->response['success']) && !empty($status))
		{
		    $user = new User();
		    $record_status = new Status();
		    $data = $record_status->getStatusByOwnerType($user->getOwnerType(), $status);
		}
		
		return $data;
	}

	/**
	 * Function to update a users products
	 * @since 1.0.0
	 * @internal param $none
	 * @access public
	 * @param string[] params
	 * @return array
	 * @ParamType params string[]
	 * @ReturnType array
	 */
	public function updateProducts(array $params = array()) {
		session_start();
		
		$ID   = TSP_Helper::arrGetVal($_POST, '_id', $params['_id']);
		$client_products   = TSP_Helper::arrGetVal($_POST, 'client_products', $params['client_products']);
		$employee_products = TSP_Helper::arrGetVal($_POST, 'employee_products', $params['employee_products']);
		
		if (!empty($client_products))
		{
		    $client = new Client($ID);
		    $client->updateProducts($client_products);
		
		    $client_response = $client->getResponse();
		    $this->response['sql'][] = $client_response['sql'];

            $this->response['success'] = array(
                'title' => 'Success',
                'message' => $client->getName() . ' updated successfully.',
                'type' => 'success',
            );

		    ActvityHelper::log($_SESSION['_id'], "UPDATE PRODUCTS: For client with ID #{$ID}", $this->response);
		}
		else if (!empty($employee_products))
		{
		    $employee = new Employee($ID);
		    $employee->updateProducts($employee_products);
		
		    $employee_response = $employee->getResponse();
		    $this->response['sql'][] = $employee_response['sql'];

            $this->response['success'] = array(
                'title' => 'Success',
                'message' => $employee->getName() . ' updated successfully.',
                'type' => 'success',
            );

		    ActvityHelper::log($_SESSION['_id'], "UPDATE PRODUCTS: For employee with ID #{$ID}", $this->response);
		}
	}

	/**
	 * Function to update an employee's dependents
	 * @since 1.0.0
	 * @internal param $none
	 * @access public
	 * @param string[] params
	 * @return array
	 * @ParamType params string[]
	 * @ReturnType array
	 */
	public function updateDependents(array $params = array()) {
		session_start();
		
		$ID   = TSP_Helper::arrGetVal($_POST, '_id', $params['_id']);
		$employee_dependents = TSP_Helper::arrGetVal($_POST, 'employee_dependents', $params['employee_dependents']);
		
		if (!empty($employee_dependents))
		{
		    $employee = new Employee($ID);
		    $employee->updateDependents($employee_dependents);
		
		    $employee_response = $employee->getResponse();
		    $this->response['sql'][] = $employee_response['sql'];

            $this->response['success'] = array(
                'title' => 'Success',
                'message' => $employee->getName() . ' updated successfully.',
                'type' => 'success',
            );

		    ActvityHelper::log($_SESSION['_id'], "UPDATE DEPENDENTS: For employee with ID #{$ID}", $this->response);
		}
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
		
		$user = new User();
		$user->delete($ID);
		
		$status = new Status();
		$data = $status->getStatusByOwnerType($user->getOwnerType(), $user->statuses['deleted']);
		
		$user_response = $user->getResponse();
		$status_response = $status->getResponse();
		
		$this->response['sql'][] = array_merge($user_response['sql'], $status_response['sql']);
		
		$this->response['success'] = array(
                'title' => 'Success',
                'message' => 'Data successfully retrieved.',
                'type' => 'success',
            );
		
		ActvityHelper::log($_SESSION['_id'], "DELETE: {$user->getName()} {$user->getUsername()} #{$ID}", $this->response);
		
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
		
		$user = new User();
		$user->deactivate($ID);
		
		$status = new Status();
		$data = $status->getStatusByOwnerType($user->getOwnerType(), $user->statuses['disabled']);
		
		$user_response = $user->getResponse();
		$status_response = $status->getResponse();
		
		$this->response['sql'][] = array_merge($user_response['sql'], $status_response['sql']);
		
		$this->response['success'] = array(
                'title' => 'Success',
                'message' => 'Data successfully retrieved.',
                'type' => 'success',
            );
		
		ActvityHelper::log($_SESSION['_id'], "DEACTIVATE: {$user->getName()} {$user->getUsername()} #{$ID}", $this->response);
		
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
		
		$user = new User();
		$user->activate($ID);
		
		$status = new Status();
		$data = $status->getStatusByOwnerType($user->getOwnerType(), $user->statuses['active']);
		
		$user_response = $user->getResponse();
		$status_response = $status->getResponse();
		
		$this->response['sql'][] = array_merge($user_response['sql'], $status_response['sql']);
		
		$this->response['success'] = array(
                'title' => 'Success',
                'message' => 'Data successfully retrieved.',
                'type' => 'success',
            );
		
		ActvityHelper::log($_SESSION['_id'], "ACTIVATE: {$user->getName()} {$user->getUsername()} #{$ID}", $this->response);
		
		return $data;
	}

	/**
	 * 
	 * Function to authorize a user
	 * 
	 * @since 1.0.0
	 * 
	 * 
	 * 
	 * @internal param $none
	 * @access public
	 * @param string[] params
	 * @return void
	 * @ParamType params string[]
	 * @ReturnType void
	 */
	public function auth(array $params = array()) {
		session_start();
		
		$login_successful = true;

        $token = TSP_Helper::arrGetVal($_POST, 'token', $params['token']);
        $username = "";

		if (empty($username))
        {
            list($username, $null) = preg_split("/\?\?/", base64_decode($token));
            //$username = TSP_Helper::openDecrypt(System::getCookieSalt(), $token, TSP_Config::get('app.checksums.secret_key'));
        }
        if (empty($username))
        {
            $username = TSP_Helper::cookieGet('username', TSP_Settings::$cookie_prefix);
            $username = TSP_Helper::openDecrypt(System::getCookieSalt(), $username, TSP_Config::get('app.checksums.secret_key'));
        }
        if (empty($username))
        {
            $username = $_SESSION['username'];
        }

        if (!empty($username))
        {
            $user = new User();
            $user_found = $user->getUserByUsername($username);

            if (count($user_found) == 0)
            {
                $this->response['error'] = array(
                    'title' => 'Error Occurred',
                    'message' => 'Username doesn\'t match current session.',
                    'type' => 'error',
                );

                $this->response['access_granted'] = false;
                $login_successful = false;
            }
        }
		else
		{
		   $this->response['error'] = array(
                'title' => 'Error Occurred',
                'message' => 'Login required.',
                'type' => 'error',
            );

		    $this->response['access_granted'] = false;
		    $login_successful = false;
		}
		
		if ($login_successful)
		{
		   $this->response['success'] = array(
                'title' => 'Success',
                'message' => 'Data successfully retrieved.',
                'type' => 'success',
            );
		    $this->response['message'] = "Login successful";
		}
	}

	/**
	 * 
	 * Function to login a user
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
	 * @ReturnType void
	 */
	public function login(array $params = array()) {
		session_start();

		$data = array();

		$username = TSP_Helper::arrGetVal($_POST, 'username', $params['username']);
		$password = TSP_Helper::arrGetVal($_POST, 'password', $params['password']);
		$remember = TSP_Helper::arrGetVal($_POST, 'remember', $params['remember']);

		// @TODO Handle processing languages
        $lang = CDemo::getLang(1);

        try{

            if (!empty($username) && !empty($password))
            {
                $user = new User();
                $current_user = $user->getUserByUsername($username);

                $this->response = $user->getResponse();

                $hash = new PasswordHash(8, true);

                if ($current_user['status_id'] != 1 )
                {
                    $this->response['error'] = array(
                        'title' => 'Error Occurred',
                        'message' => 'You do not have access. Please contact your administrator.',
                        'type' => 'error',
                    );
                }
                else if ($hash->CheckPassword($password, $current_user['password']))
                {
                    session_regenerate_id(true);
                    $_SESSION['session_id'] = session_id();
                    $_SESSION['_id'] = $current_user['_id'];
                    $_SESSION['username'] = $username;
                    $_SESSION['status_id'] = $current_user['status_id'];
                    $_SESSION['type_id'] = $current_user['type_id'];
                    $_SESSION['first_name'] = $current_user['first_name'];
                    $_SESSION['last_name'] = $current_user['last_name'];
                    $_SESSION['email'] = $current_user['email'];
                    $_SESSION['photo'] = System::getGravatarURL($current_user['email']);
                    $_SESSION['is_logged'] = true;
                    $_SESSION['remember'] = $remember;

                    // @TODO: Include IP inside of token and check it each time the token is passed back to the server
                    // if the token's IP doesn't match the incoming IP then deny the user access
                    $token = base64_encode($username."??".TSP_Config::get('app.checksums.secret_key'));
                    $token_expires = ONE_DAY;

                    // Set a cookie that expires in one week
                    if (TSP_Helper::toBool($remember))
                    {
                        $token_expires = ONE_DAY * 7;
                    }

                    $data = array(
                        'token'         => $token,
                        'token_expires' => $token_expires,
                        'current_user'  => $_SESSION
                    );

                    // @TODO: Get User preferences when finished with UI
                    $data['current_user']['preferences'] = array(
                        'current_company_id'    => 1,
                    );

                    // To avoid resending the form on refreshing
                    $this->response['success'] = array(
                        'title' => $lang['words']['welcome'] . " " . $current_user['first_name'],
                        'message' => $lang['words']['success_signin'],
                        'type' => 'success',
                    );

                    $this->response['first_name'] = $current_user['first_name'];
                    $this->response['access_granted'] = true;

                    ActvityHelper::log($current_user['_id'], "LOGIN: {$user->getName()} {$user->getUsername()} #{$current_user['_id']}", $this->response);
                }
                else
                    $this->response['error'] = array(
                        'title' => $lang['words']['error_occurred'],
                        'message' => $lang['words']['error_wrong_user'],
                        'type' => 'error',
                    );
            }
            elseif (empty($username))
            {
                $this->response['error'] = array(
                    'title' => $lang['words']['error_occurred'],
                    'message' => $lang['words']['error_username_empty'],
                    'type' => 'error',
                );

            }
            elseif (empty($password))
            {
                $this->response['error'] = array(
                    'title' => $lang['words']['error_occurred'],
                    'message' => $lang['words']['error_password_empty'],
                    'type' => 'error',
                );
            }

		} catch (Exception $e){
            if (TSP_Config::get('app.debug'))
            {
                $this->response['admin_error'][] = $e->getMessage();
            }
            $this->response['error'] = array(
                'title' => $lang['words']['error_occurred'],
                'message' => 'Unknown error (301) occurred. Please contact your system administrator or try again at a later time.',
                'type' => 'error',
            );
        }

		return $data;
	}

	/**
	 * 
	 * Function to update a user's profile
	 * 
	 * @since 1.0.0
	 * @access public
	 * @param int type
	 * @param int id
	 * @param string[] params
	 * @return void
	 * @ParamType type int
	 * @ParamType id int
	 * @ParamType params string[]
	 * @ReturnType void
	 */
	public function updateProfile($type, $id, array $params = array()) {
		session_start();
		
		$profile_data   = TSP_Helper::arrGetVal($_POST, null, $params);
		
		$user = new User();
		$user_data = $user->getUserByID($id);
		
		$profile = new Profile();
		
		$existing_profile = $profile->getProfileByOwner($user->getOwnerType(), $user_data['_id'], $type);
		
		$profile_data['owner'] = $user->getOwnerType();
		$profile_data['owner_id'] = $user_data['_id'];
		$profile_data['type_id'] = $type;
		
		if (!empty($profile_data['state']))
		    $profile_data['state_id'] = $profile_data['state']->ID;
		
		if (empty($existing_profile))
		{
		    $profile_data['default'] = 0;
		    $ID = $profile->add($profile_data);
		}
		else
		{
		    $profile_data['_id'] = $existing_profile['_id'];
		    $profile->update($profile_data);
		    $ID = $existing_profile['_id'];
		}
		
		$user_response = $user->getResponse();
		$profile_response = $profile->getResponse();
		
		$this->response['sql'][] = array_merge($user_response['sql'], $profile_response['sql']);
		
		$this->response['success'] = array(
                'title' => 'Success',
                'message' => 'Data successfully retrieved.',
                'type' => 'success',
        );
		
		ActvityHelper::log($_SESSION['_id'], "UPDATE: {$profile->getName()} {$profile->getEmail()} #{$ID}", $this->response);
	}

	/**
	 * 
	 * Function to register a user
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
	public function register(array $params = array()) {
		session_start();

        $data = $this->createRecord(ESharedStatus::UserActive, ESharedType::Client, ESharedType::Work, $params);

		return $data;
	}

	/**
	 * 
	 * Function to logout a user
	 * 
	 * @since 1.0.0
	 * @access public
	 * @return array
	 * @ReturnType array
	 */
	public function logout() {
		session_start();
		
		session_unset();
		session_destroy();
		
		TSP_Helper::cookieDelete(TSP_Settings::$cookie_prefix, true);

		$this->response['success'] = array(
			'title' => 'Success',
			'message' => 'Data successfully retrieved.',
			'type' => 'success',
        );
        $this->response['access_granted'] = false;
	}
}
?>