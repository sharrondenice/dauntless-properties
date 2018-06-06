<?php

/**
 * @access public
 * @author Sharron Denice
 * @package controllers
 */
final class CProperty extends BaseController {

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
		session_start();
		
		$state = new State();
		$country = new Country();
		
		$data['countries'] = $country->getAll();
		$data['states'] = $state->getAll();
		
		$this->response['success'] = array(
                'title' => 'Success',
                'message' => 'Data successfully retrieved.',
                'type' => 'success',
        );
		
		return $data;
	}

    /**
     *
     * Function to get empty record data
     *
     * @since 1.0.0
     * @access public
     * @return array
     * @ReturnType array
     */
    public function getEmptydata() {
        session_start();

        $data = array(
            'metadata'                  => array(
                'location'  => array(
                    'address1'  => null,
                    'address2'  => null,
                    'city'      => null,
                    'state_id'  => null,
                    'state'     => array(
                        'country_code' => null
                    )
                )
            )
        );

        $this->response['success'] = array(
            'title' => 'Success',
            'message' => 'Data successfully retrieved.',
            'type' => 'success',
        );

        return $data;
    }

	/**
	 * Function to get property info given ID
	 * @since 1.0.0
	 * @internal param $none
	 * @access public
	 * @param int id
	 * @return array
	 * @ParamType id int
	 * @ReturnType array
	 */
	public function getPropertyInfoByID($id) {
		session_start();
		
		$property = new Property();
        $property_data = $property->getByID($id);
		$ID = $property_data['_id']; // store ID so profile doesn't overwrite ID

		$profile = new Profile();
		
		$profile_data = $profile->getDefaultProfile($property->getOwnerType(), $property->getID());
		
		$data = array_merge($property_data, $profile_data);
		$data['_id'] = $ID; // restore company ID

		$company_response = $property->getResponse();
		$profile_response = $profile->getResponse();
		
		$this->response['sql'][] = array_merge($company_response['sql'], $profile_response['sql']);
		
		$this->response['success'] = array(
                'title' => 'Success',
                'message' => 'Data successfully retrieved.',
                'type' => 'success',
            );
		
		return $data;
	}

	/**
	 * Function to create a record
	 * @since 1.0.0
	 * @access public
	 * @param int status
	 * @param int object_type
	 * @param int profile_type
	 * @param string[] params
	 * @return array
	 * @ParamType status int
	 * @ParamType object_type int
	 * @ParamType profile_type int
	 * @ParamType params string[]
	 * @ReturnType array
	 */
	public function createRecord($status = null, $object_type = null, $profile_type = null, array $params = array()) {
		session_start();

		$meta_data         = TSP_Helper::arrGetVal($_POST, 'metadata', $params['metadata']);
		$title             = TSP_Helper::arrGetVal($_POST, 'title', $params['title']);
		$description       = TSP_Helper::arrGetVal($_POST, 'description', $params['description']);
        $start_time        = TSP_Helper::arrGetVal($_POST, 'start_time', $params['start_time']);
        $end_time          = TSP_Helper::arrGetVal($_POST, 'end_time', $params['end_time']);
        $image             = TSP_Helper::arrGetVal($_POST, 'image', $params['image']);

		$data = array(
            'title'             => $title,
            'description'       => $description,
            'start_time'        => $start_time,
            'end_time'          => $end_time,
            'image'             => $image,
		);

		$profile_data = array(
		    'address1' => $meta_data->location->address1,
		    'address2' => $meta_data->location->address2,
		    'city' => $meta_data->location->city,
		    'state_id' => $meta_data->location->state_id
        );
		
		$property = new Property();
		$property->setTitle($title);

		$ID = $property->add($data);
		
		$this->response = $property->getResponse();
		
		$data['_id'] = $ID;
		
		if (!empty($ID))
		{
            $this->response['success'] = array(
                'title' => 'Success',
                'message' => $property->getTitle() . ' added successfully.',
                'type' => 'success',
            );

		    $profile = new Profile();
		
		    $existing_profile = $profile->getProfileByOwner($property->getOwnerType(), $ID, ESharedType::Work);
		
		    $profile_data['owner'] = $property->getOwnerType();
		    $profile_data['owner_id'] = $ID;
		    $profile_data['type_id'] = ESharedType::Work;


		    if (empty($existing_profile))
		    {
		        $profile_data['is_default'] = 1;
		        $profile->add($profile_data);
		    }
		    else
		    {
		        $profile_data['_id'] = $existing_profile['_id'];
		        $profile->update($profile_data);
		    }

            $property_response = $property->getResponse();
		    $profile_response = $profile->getResponse();
		
		    $this->response['sql'][] = array_merge($property_response['sql'], $profile_response['sql']);

		    $this->response['success'] = array(
                'title' => 'Success',
                'message' => 'Data successfully added.',
                'type' => 'success',
            );
		}
		else
		{
            $this->response['error'] = array(
                'title' => 'Error',
                'message' => $property->getTitle() . ' account was not created. Please contact system administrator.',
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
	 * @access public
	 * @param string[] params
	 * @return array
	 * @ParamType params string[]
	 * @ReturnType array
	 */
	public function updateRecord(array $params = array()) {
		session_start();

        $meta_data         = TSP_Helper::arrGetVal($_POST, 'metadata', $params['metadata']);
		$ID                = TSP_Helper::arrGetVal($_POST, '_id', $params['_id']);
		$title             = TSP_Helper::arrGetVal($_POST, 'title', $params['title']);
		$description       = TSP_Helper::arrGetVal($_POST, 'description', $params['description']);
        $start_time        = TSP_Helper::arrGetVal($_POST, 'start_time', $params['start_time']);
        $end_time          = TSP_Helper::arrGetVal($_POST, 'end_time', $params['end_time']);
        $image             = TSP_Helper::arrGetVal($_POST, 'image', $params['image']);

		$data = array(
		    '_id'            => $ID,
		    'title'          => $title,
		    'description'       => $description,
		    'start_time'        => $start_time,
		    'end_time'          => $end_time,
            'image'             => $image,
		);

        $profile_data = array(
            'address1'  => $meta_data->location->address1,
            'address2'  => $meta_data->location->address2,
            'city'      => $meta_data->location->city,
            'state_id'  => $meta_data->location->state_id
        );

		$property = new Property();
        $property->setTitle($title);

        $property_found = $property->getByID($ID);
		
		$this->response = $property->getResponse();
		
		if (!empty($property_found))
		{
            $property->update($data);

            $profile = new Profile();

            $existing_profile = $profile->getProfileByOwner($property->getOwnerType(), $ID, ESharedType::Work);

            $profile_data['owner'] = $property->getOwnerType();
            $profile_data['owner_id'] = $ID;
            $profile_data['type_id'] = ESharedType::Work;

            if (!empty($profile_data['state']))
                $profile_data['state_id'] = $profile_data['state']->ID;


            if (empty($existing_profile))
            {
                $profile_data['is_default'] = 1;
                $profile->add($profile_data);
            }
            else
            {
                $profile_data['_id'] = $existing_profile['_id'];
                $profile->update($profile_data);
            }
		
		    $this->response = $property->getResponse();

            $this->response['success'] = array(
                'title' => 'Success',
                'message' => $property->getTitle() . ' updated successfully.',
                'type' => 'success',
            );
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

        $property = new Property();
        $property->delete($ID);

        $profile = new Profile();
        $profiles = $profile->getProfilesByOwner(EOwnerType::Property, $ID);

        foreach ($profiles as $a_profile){
            $profile->delete($a_profile['_id']);
        }

        $data = $property->getResponse();

		$this->response['sql'][] = array_merge($data['sql']);
		
		$this->response['success'] = array(
                'title' => 'Success',
                'message' => 'Data successfully deleted.',
                'type' => 'success',
            );
		

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
        return array();
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
        return array();
    }
}
?>