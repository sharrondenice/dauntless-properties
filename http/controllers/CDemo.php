<?php
/*/**
 * @access public
 * @author Sharron Denice
 * @package The Professional
 */
require_once "autoload.php";

class CDemo {

    public function getEmptyRecord($object)
    {
        $data = array();
        $full_path = TSP_Helper::arrGetVal($_SERVER, 'REQUEST_URI');

        // @TODO: With each company ID that comes in, confirms that the user has permissions to view it
        $current_company_id = TSP_Helper::arrGetVal($_REQUEST, 'current_company_id', null);
        $user_id = TSP_Helper::arrGetVal($_REQUEST, 'user_id', null);
        $testing = TSP_Helper::arrGetVal($_REQUEST, 'testing', null);

        try{

            switch ($object){
                case 'company':
                    $data = array(
                        'metadata'                  => array()
                    );

                    $data['metadata']['social_accounts'][] = array(
                        'username'  => "",
                        'title'     => "Social Media",
                        'type_id'   => "0"
                    );
                    $data['metadata']['pay'][] = array();
                    break;
                case 'event':
                    $data = array(
                        'client_user_id'            => null
                    );
                    break;
                // @TODO - Check to see if the statement number exists
                case 'deliverable':
                    $data = array(
                        'status_id'         => "70",
                        'type_id'           => "100",
                        'metadata'          => array()
                    );
                    $data['metadata']['attributes'][] = array(
                        'title' => ""
                    );
                    break;
                case 'discount':
                    $data = array(
                        'status_id'                 => "200",
                        'type_id'                   => "450"
                    );
                    break;
                case 'invoice':
                    $data = array(
                        'status_id'                 => "100",
                        'type_id'                   => "130",
                        'metadata'                  => array(
                        ),
                        'total_installments'        => 1,
                        'statement_no'              => 'SD-'.TSP_Helper::genKey(9,false, true, false)
                    );
                    $data['metadata']['line_items'][] = array();
                    break;
                case 'media':
                    $data = array(
                        'avatar'          => null
                    );
                    break;
                case 'mission':
                    $data = array(
                        'is_ready_to_bill'          => false
                    );
                    break;
                case 'post':
                    $data = array(
                        'status_id'                  => "140",
                        'type_id'                    => "230"
                    );
                    break;
                case 'product':
                    $data['releases'][] = array();
                    break;
                case 'profession':
                    $data = array(
                        'metadata'                  => array(
                            'responsibilities'      => null
                        )
                    );

                    $data['metadata']['missions'][] = array();
                    break;
                case 'project':
                    $data = array(
                        'metadata'                  => array()
                    );

                    $data['metadata']['missions'][] = array();
                    break;
                case 'proposal':
                    $data = array(
                        'status_id'                 => "101",
                        'type_id'                   => "131",
                        'metadata'                  => array(
                        ),
                        'total_installments'        => 1,
                        'statement_no'              => 'SD-'.TSP_Helper::genKey(9,false, true, false)
                    );
                    $data['metadata']['line_items'][] = array();
                    break;
                case 'release':
                    $data = array(
                        'project_id'                => null
                    );
                    break;
                case 'resource/company':
                    $data = array(
                        'project_id'                => null,
                        'type_id'                   => "24",
                        'metadata'                  => array()
                    );

                    $data['metadata']['social_accounts'][] = array(
                        'username'  => "",
                        'title'     => "Social Media",
                        'type_id'   => "0"
                    );
                    $data['metadata']['pay'][] = array();
                    break;
                case 'resource/user':
                    $data = array(
                        'project_id'                => null,
                        'type_id'                   => "24",
                        'metadata'                  => array()
                    );

                    $data['metadata']['social_accounts'][] = array(
                        'username'  => "",
                        'title'     => "Social Media",
                        'type_id'   => "0"
                    );
                    $data['metadata']['pay'][] = array();
                    break;
                case 'responsibility':
                    $data = array(
                        'profession_id'             => null
                    );
                    break;
                case 'sprint':
                    $data = array(
                        'is_planning_meeting_held'  => false,
                        'is_review_meeting_held'    => false,
                        'is_retro_meeting_held'     => false
                    );
                    break;
                case 'work':
                    $data = array(
                        'complete'                  => 0,
                        'status_id'                 => "40",
                        'type_id'                   => "160",
                        'category_type_id'          => "81",
                        'priority_id'               => "1",
                        'project_id'                => null,
                        'product_id'                => null,
                        'is_backlogged'             => false
                    );
                    break;
                case 'user':
                    $data = array(
                        'parent_id'                 => $user_id,
                        'metadata'                  => array()
                    );

                    $data['metadata']['social_accounts'][] = array(
                        'username'  => "",
                        'title'     => "Social Media",
                        'type_id'   => "0"
                    );
                    $data['metadata']['pay'][] = array();
                    break;
                default:
                    break;
            }

            $data['responsible_user_id'] = $user_id;
            $data['responsible_company_id'] = $current_company_id;

            if (!TSP_Helper::isEmpty($data))
            {
                $this->response['success'] = array(
                    'path'      => $full_path,
                    'title'     => 'Success',
                    'message'   => 'Data successfully retrieved.',
                    'type_id'   => 'success',
                );
            }
            else
            {
                $this->response['error'] = array(
                    'path'      => $full_path,
                    'title'     => 'Error Occurred',
                    'message'   => 'Unable to get empty record data for ' . $type,
                    'type_id'   => 'error',
                );
            }

        } catch (Exception $e){
            if (TSP_Config::get('app.debug'))
            {
                $this->response['admin_error'][] = $e->getMessage();
            }
            $this->response['error'] = array(
                'path'      => $full_path,
                'title'     => 'Error Occurred',
                'message'   => 'Unknown error (301) occurred. Please contact your system administrator or try again at a later time.',
                'type'      => 'error',
            );

        }

        // if an ID was given only return the first record
        if (TSP_Helper::toBool($testing))
            var_dump($data);

        return $data;
    }

    /**
     * Function to get the site's cookie salt
     *
     * @since 1.0.0
     *
     * @param string $object - the type of json file
     * @param string $id - the $owning type of a shared object
     *
     * @return array
     * @ReturnType array
     */
    public function getJSONData($object, $id)
    {
        $data = array();
        $full_path = TSP_Helper::arrGetVal($_SERVER, 'REQUEST_URI');

        // @TODO: With each company ID that comes in, confirms that the user has permissions to view it
        $current_company_id = TSP_Helper::arrGetVal($_REQUEST, 'current_company_id', null);
        $user_id = TSP_Helper::arrGetVal($_REQUEST, 'user_id', null);
        $testing = TSP_Helper::arrGetVal($_REQUEST, 'testing', null);

        $lang = CDemo::getLang($user_id);

        // @TODO: With each base company created create default settings
        // @TODO: With each user created create default settings

        if (TSP_Helper::toBool($testing) && TSP_Helper::isEmpty($object))
        {
            $new_object = TSP_Helper::arrGetVal($_REQUEST, 'object', null);

            if (TSP_Helper::isEmpty($object))
                $object = $new_object;
        }
        if (TSP_Helper::toBool($testing) && TSP_Helper::isEmpty($id))
        {
            $new_id = TSP_Helper::arrGetVal($_REQUEST, 'id', null);

            if (TSP_Helper::isEmpty($id))
                $id = $new_id;
        }

        try{
            $action = TSP_Helper::arrGetVal($_REQUEST, 'action', null);

            // @TODO Get initial app settings on login
            if ($action == 'get_app_defaults')
            {
                $return_data = array();
                $_REQUEST['action'] = null;

                $show_countries = TSP_Helper::arrGetVal($_REQUEST, 'show_countries', null);
                $user_id = TSP_Helper::arrGetVal($_REQUEST, 'user_id', null);

                if ($show_countries)
                {
                    $return_data['countries'] = CDemo::getCountries();
                    $return_data['states'] = CDemo::getStates();
                }
                else
                {
                    $country_code = TSP_Helper::arrGetVal($_REQUEST, 'country_code', null);
                    $return_data['countries'] = $this->getForeignData('locale_countries', $country_code, '_id');
                    $return_data['states'] = $this->getForeignData('locale_states', $country_code, 'country_code', null, true);
                }

                    $_REQUEST['country_code'] = null;

                $return_data['current_user'] = $this->getJSONData('users', $user_id);
                //$return_data['user_settings'] = $this->getForeignData('system_settings', $user_id, 'user_id', null, true);
                $system_settings = $this->getForeignData('system_settings', $current_company_id, 'responsible_company_id', null, true);

                if (!TSP_Helper::isEmpty($system_settings))
                {
                    foreach ($system_settings as $key => $value){
                        if ($value['setting_value'] == "true")
                            $return_data['system_settings'][$value['setting_name']] = true;
                        else if ($value['setting_value'] == "false")
                            $return_data['system_settings'][$value['setting_name']] = false;
                        else
                            $return_data['system_settings'][$value['setting_name']] = $value['setting_value'];
                    }
                }
                    $_REQUEST['action'] = 'get_base';

                $return_data['base_companies'] = $this->getJSONData('companies', null);

                    $_REQUEST['action'] = 'get_professionals';

                $return_data['professionals'] = $this->getJSONData('users', null);

                    $_REQUEST['action'] = null;

                $return_data['taxonomies'] = $this->getJSONData('shared_taxonomies', null);
                $return_data['types'] = $this->getJSONData('shared_types', null);
                $return_data['statuses'] = $this->getJSONData('shared_statuses', null);
                $return_data['priorities'] = $this->getJSONData('shared_priorities', null);
                $return_data['browser_types'] = $this->getJSONData('shared_browsers', null);
                $return_data['statuses'] = $this->getJSONData('shared_statuses', null);
                $return_data['system_types'] = $this->getJSONData('shared_systems', null);

                $return_data['timezones'] = array();
                $return_data['timezones'] = DateTimeZone::listIdentifiers(DateTimeZone::ALL);

                $cities = array();
                $countries = array();

                $tag = 0;
                foreach ($return_data['timezones'] as $index => $zone)
                {
                    list($country, $city) =  preg_split("/\//", $zone);

                    $city = preg_replace("/\_/", " ", $city);

                    if (!in_array($country, $countries))
                    {
                        $countries[$tag] = $country;
                        $cities[] = array('_id' => $zone, 'tag' => $tag, 'title' => $city);
                        $tag++;
                    }
                    else{
                        $ctag = array_search($country, $countries);
                        $cities[] = array('_id' => $zone, 'tag' => $ctag, 'title' => $city);
                    }
                }

                $return_data['timezone'] = array(
                    'countries' => $countries,
                    'cities'    => $cities
                );

                $data = $return_data;

                //var_dump($data);
            }
            else if ($action == 'generate_sku'){

                $data = "";

                $deliverable_id = TSP_Helper::arrGetVal($_REQUEST, 'other_id', null);
                $other_id_key = TSP_Helper::arrGetVal($_REQUEST, 'other_id_key', null);

                $system_settings = array();

                $system_settings_hash = $this->getForeignData('system_settings', $current_company_id, 'responsible_company_id', null, true);
                if (!TSP_Helper::isEmpty($system_settings_hash))
                {
                    foreach ($system_settings_hash as $key => $value){
                        if ($value['setting_value'] == "true")
                            $system_settings[$value['setting_name']] = true;
                        else if ($value['setting_value'] == "false")
                            $system_settings[$value['setting_name']] = false;
                        else
                            $system_settings[$value['setting_name']] = $value['setting_value'];
                    }
                }

                $sku = "";
                $company_name = "";
                $deliverable_name = "";
                $category_name = "";

                $settings = array();

                // Get prefixes
                $settings['sku_prefix_first'] = $system_settings['sku_prefix_first'];
                $settings['sku_prefix_second'] = $system_settings['sku_prefix_second'];
                $settings['sku_prefix_third'] = $system_settings['sku_prefix_third'];
                $settings['sku_prefix_last'] = $system_settings['sku_prefix_last'];

                // Get prefix settings
                $settings['sku_seperator'] = $system_settings['sku_seperator'];
                $settings['sku_autogen_max'] = $system_settings['sku_autogen_max'];
                $settings['sku_autogen_type'] = $system_settings['sku_autogen_type'];
                $settings['sku_company_max'] = $system_settings['sku_company_max'];
                $settings['sku_product_max'] = $system_settings['sku_product_max'];
                $settings['sku_category_max'] = $system_settings['sku_category_max'];

                // determine the product and category name as well as product id
                if (!empty($deliverable_id))
                {
                    // Generate the company name
                    $company_data = $this->getForeignData('companies', $current_company_id, '_id');
                    $long_name = $company_data['title'];
                    $comp_names = explode(" ", $long_name);
                    $company_name = $this->sliceName($comp_names,$settings['sku_company_max']);

                    // Generate the deliverable name
                    $product_data = $this->getForeignData('companies_deliverables', $deliverable_id, '_id');
                    $long_name = $product_data['title'];
                    $deliverable_names = explode(" ", $long_name);
                    $deliverable_name = $this->sliceName($deliverable_names,$settings['sku_product_max']);

                    // Generate the category name
                    $product_meta_data = $this->getForeignData('commerce_metadata', $product_data['metadata_id'], '_id');
                    $category_ids = $product_meta_data['category_ids'];
                    $ids = explode(",", $category_ids);

                    $cat_names = $this->getCategoryNames($ids);
                    $category_name = $this->sliceName($cat_names,$settings['sku_category_max']);

                    // Store the data in the data array
                    $data = array(
                        'deliverable_id' => $deliverable_id,
                        'deliverable_name' => $deliverable_name,
                        'company' => $company_name,
                        'category' => $category_name
                    );

                    // Generate product code prefixes
                    // First prefix
                    $sku = $this->generatePrefix($data, $settings['sku_prefix_first'], $settings['sku_autogen_max'], $settings['sku_autogen_type'], $settings['sku_seperator']);

                    // Second prefix
                    $sku .= $this->generatePrefix($data, $settings['sku_prefix_second'], $settings['sku_autogen_max'], $settings['sku_autogen_type'], $settings['sku_seperator']);

                    // Third prefix
                    $sku .= $this->generatePrefix($data, $settings['sku_prefix_third'], $settings['sku_autogen_max'], $settings['sku_autogen_type'], $settings['sku_seperator']);

                    // Last prefix
                    $sku .= $this->generatePrefix($data, $settings['sku_prefix_last'], $settings['sku_autogen_max'], $settings['sku_autogen_type'],'');

                    // if seperator found at the end of the code remove it
                    // this means the user wanted no last prefix
                    // convert seperator to a regular expression
                    $seperator_regex = preg_quote($settings['sku_seperator'], '/');
                    $seperator_regex .= "$"; //seperator at the end of the string

                    $sku = preg_replace("/".$seperator_regex."/", "", $sku);
                }//endif

                $data = $sku;
            }
            else if ($action == 'get_line_item_types'){

                $data = array(
                    array(
                        "obj" => array(
                            "deliverable_id"    => TSP_Helper::genKey(8,false,true,false),
                            "quantity"          => 1,
                        ),
                        "title" => "{$lang['words']['add']} {$lang['words']['deliverable']}"
                    ),
                    array(
                        "obj" => array(
                            "mission_id"        => TSP_Helper::genKey(8,false,true,false),
                            "quantity"          => 1,
                        ),
                        "title" => "{$lang['words']['add']} {$lang['words']['mission']}"
                    ),
                    array(
                        "obj" => array(
                            "null_id"           => TSP_Helper::genKey(8,false,true,false),
                            "quantity"          => 1,
                        ),
                        "title" => "{$lang['words']['add']} {$lang['words']['custom_item']}"
                    )
                );
            }
            else if ($action == 'update_prices'){
                $statement_id = TSP_Helper::arrGetVal($_REQUEST, 'statement_id', null);
                $deliverable_id = TSP_Helper::arrGetVal($_REQUEST, 'deliverable_id', null);
                $mission_id = TSP_Helper::arrGetVal($_REQUEST, 'mission_id', null);
                $attribute_id = TSP_Helper::arrGetVal($_REQUEST, 'attribute_id', null);
                $attribute_value_id = TSP_Helper::arrGetVal($_REQUEST, 'attribute_value_id', null);

                $variations = array();

                $conn = new TSP_Database('database');

                $sql = "SELECT * FROM `projects_statements_line_items` WHERE `statement_id` = {$statement_id}";

                if (!TSP_Helper::isEmpty($deliverable_id))
                {
                    $sql .= " AND `deliverable_id` = {$deliverable_id}";
                    if (!TSP_Helper::isEmpty($attribute_id) && !TSP_Helper::isEmpty($attribute_value_id))
                    {
                        $sql .= " AND `attribute_id` = {$attribute_id} AND `attribute_value_id` = {$attribute_value_id}";
                    }
                }
                else if (!TSP_Helper::isEmpty($mission_id))
                {
                    $sql .= " AND `mission_id` = {$mission_id}";
                }
                else{
                    $sql = "";
                }

                if (!TSP_Helper::isEmpty($sql))
                {
                    $sale_price = 0.00;
                    $price = 0.00;
                    $one_time_fee = 0.00;

                    $result = $conn->RunQuery($sql);
                    while ($row = $conn->FetchHash($result))
                    {
                        $row = array_map('utf8_encode', $row);

                        $sale_price += floatval($row['sale_price_override']);
                        $price += floatval($row['price_override']);
                        $one_time_fee += floatval($row['one_time_fee_override']);

                        $data = array(
                            'deliverable_id' => strval($deliverable_id) ? strval($deliverable_id) : null,
                            'mission_id' => strval($mission_id) ? strval($mission_id) : null,
                            'attribute_id' => strval($attribute_id) ? strval($attribute_id) : null,
                            'attribute_value_id' => strval($attribute_value_id) ? strval($attribute_value_id) : null,
                            'price' => floatval($price),
                            'price_override' => floatval($price),
                            'sale_price' => floatval($sale_price),
                            'sale_price_override' => floatval($sale_price),
                            'one_time_fee' => floatval($one_time_fee),
                            'one_time_fee_override' => floatval($one_time_fee),
                            'variations' => array(),
                            'variations_ids' => array()
                        );
                    }
                }

                // If the item is not in the statement currently get from repository
                if (TSP_Helper::isEmpty($data) && !TSP_Helper::isEmpty($sql))
                {
                    if (!TSP_Helper::isEmpty($deliverable_id))
                    {
                        if (!TSP_Helper::isEmpty($attribute_id) && !TSP_Helper::isEmpty($attribute_value_id))
                        {
                            $variations = array();

                            $sql = "SELECT `cd`._id as `_did`, `cm`.*, `st`.title as rate_title FROM  `companies_deliverables` as `cd`
  INNER JOIN `companies_deliverables_attributes` as `ca` ON `ca`._id = {$attribute_id}
  INNER JOIN `companies_deliverables_attributes_values` as `cv` ON `cv`._id = {$attribute_value_id}
  INNER JOIN `commerce_metadata` as `cm` ON `cm`._id =  `cv`.metadata_id
  INNER JOIN `shared_types` as `st` ON `st`._id =  `cm`.rate_type_id
WHERE `cd`._id = {$deliverable_id};
";
                            $sale_price = 0.00;
                            $price = 0.00;
                            $one_time_fee = 0.00;

                            $result = $conn->RunQuery($sql);
                            while( $row = $conn->FetchHash($result))
                            {
                                $row = array_map('utf8_encode', $row);

                                $price += (floatval($row['sale_price']) > 0) ? floatval($row['sale_price']) : floatval($row['price']);
                                $one_time_fee += floatval($row['one_time_fee']);

                                $variations[] = array(
                                    'deliverable_id' => strval($deliverable_id),
                                    'attribute_id' => strval($attribute_id),
                                    'attribute_value_id' => strval($attribute_value_id),
                                    'price' => floatval($row['price']),
                                    'price_override' => floatval($row['price']),
                                    'sale_price' => floatval($row['sale_price']),
                                    'sale_price_override' => floatval($row['sale_price']),
                                    'one_time_fee' => floatval($row['one_time_fee']),
                                    'one_time_fee_override' => floatval($row['one_time_fee'])
                                );
                            }

                            $data = array(
                                'deliverable_id' => strval($deliverable_id),
                                'attribute_id' => null,
                                'attribute_value_id' => null,
                                'price' => floatval($price),
                                'price_override' => floatval($price),
                                'sale_price' => 0.00,
                                'sale_price_override' => 0.00,
                                'one_time_fee' => floatval($one_time_fee),
                                'one_time_fee_override' => floatval($one_time_fee),
                                'variations' => $variations,
                                'variations_ids' => $this->getIDs($variations, 'attribute_value_id'),
                            );
                        }
                        else if (TSP_Helper::isEmpty($attribute_id) && TSP_Helper::isEmpty($attribute_value_id))
                        {
                            $sql = "SELECT `cm`.*, `st`.title as rate_title FROM  `companies_deliverables` as `cd`
  INNER JOIN `commerce_metadata` as `cm` ON `cm`._id =  `cd`.metadata_id
  INNER JOIN `shared_types` as `st` ON `st`._id =  `cm`.rate_type_id
WHERE `cd`._id = {$deliverable_id};
";
                            $result = $conn->RunQuery($sql);
                            $row = $conn->FetchHash($result);

                            if (!TSP_Helper::isEmpty($row))
                            {
                                $row = array_map('utf8_encode', $row);

                                $data = array(
                                    'deliverable_id' => strval($deliverable_id),
                                    'mission_id' => null,
                                    'attribute_id' => null,
                                    'attribute_value_id' => null,
                                    'price' => floatval($row['price']),
                                    'price_override' => floatval($row['price']),
                                    'sale_price' => floatval($row['sale_price']),
                                    'sale_price_override' => floatval($row['sale_price']),
                                    'one_time_fee' => floatval($row['one_time_fee']),
                                    'one_time_fee_override' => floatval($row['one_time_fee']),
                                    'variations' => array(),
                                    'variations_ids' => array()
                                );
                            }
                        }
                    }
                    else if (!TSP_Helper::isEmpty($mission_id))
                    {
                        $sql = "SELECT `pm`.*, `st`.title as rate_title FROM  `projects_missions` as `pm`
  INNER JOIN `shared_types` as `st` ON `st`._id =  `pm`.rate_type_id
WHERE `pm`._id = {$mission_id}";

                        $result = $conn->RunQuery($sql);
                        $row = $conn->FetchHash($result);

                        if(!TSP_Helper::isEmpty($row))
                        {
                            $row = array_map('utf8_encode', $row);

                            $data = array(
                                'deliverable_id' => null,
                                'mission_id' => strval($mission_id),
                                'attribute_id' => null,
                                'attribute_value_id' => null,
                                'price' => floatval($row['price']),
                                'price_override' => floatval($row['price']),
                                'sale_price' => 0.00,
                                'sale_price_override' => 0.00,
                                'one_time_fee' => 0.00,
                                'one_time_fee_override' => 0.00,
                                'variations' => array(),
                                'variations_ids' => array()
                            );
                        }
                    }
                }
                else if (!TSP_Helper::isEmpty($sql))
                {
                    // check to see if this item has variations and if so add them to the array
                    if (!TSP_Helper::isEmpty($deliverable_id))
                    {
                        $sql = "SELECT `ca`._id as `attribute_id`, `cm`.*, `st`.title as rate_title FROM  `companies_deliverables` as `cd`
  INNER JOIN `companies_deliverables_attributes` as `ca` ON `ca`.deliverable_id = {$deliverable_id}
  INNER JOIN `commerce_metadata` as `cm` ON `cm`._id =  `ca`.metadata_id
  INNER JOIN `shared_types` as `st` ON `st`._id =  `cm`.rate_type_id
WHERE `cd`._id = {$deliverable_id};
";
                        $result = $conn->RunQuery($sql);
                        while( $row = $conn->FetchHash($result))
                        {
                            $row = array_map('utf8_encode', $row);

                            $variations[] = array(
                                'deliverable_id' => strval($deliverable_id),
                                'attribute_id' => strval($row['attribute_id']),
                                'attribute_value_id' => null,
                                'price' => floatval($row['price']),
                                'price_override' => floatval($row['price']),
                                'sale_price' => floatval($row['sale_price']),
                                'sale_price_override' => floatval($row['sale_price']),
                                'one_time_fee' => floatval($row['one_time_fee']),
                                'one_time_fee_override' => floatval($row['one_time_fee'])
                            );
                        }

                        $data['variations'] = $variations;
                        $data['variations_ids'] = array();
                    }
                }
            }
            else if ($object == 'projects_statements_line_items')
            {
                $other_id = TSP_Helper::arrGetVal($_REQUEST, 'other_id', null);
                $other_id_key = TSP_Helper::arrGetVal($_REQUEST, 'other_id_key', null);

                $conn = new TSP_Database('database');

                $sql = "SELECT * FROM `projects_statements_line_items` WHERE `{$other_id_key}` = {$other_id}";
                $result = $conn->RunQuery($sql);

                $deliverables = array();
                $missions = array();
                $customs = array();

                while( $row = $conn->FetchHash($result)){
                    $row = array_map('utf8_encode', $row);

                    if (!TSP_Helper::isEmpty($row['deliverable_id']))
                    {
                        if (!TSP_Helper::isEmpty($row['attribute_id']) && !TSP_Helper::isEmpty($row['attribute_value_id']))
                        {
                            $variations = array();

                            $sql = "SELECT `li`._id as `_lid`, `li`.attribute_id, `li`.attribute_value_id, `cd`._id as `_did`, `cd`.title as `title`, `cd`.description as `description`, `ca`.title as `variant_title`, `cv`.title as `variant_description`, `cm`.*, `st`.title as rate_title FROM  `projects_statements_line_items` as `li`
  INNER JOIN `companies_deliverables` as `cd` ON `cd`._id =  `li`.deliverable_id
  INNER JOIN `companies_deliverables_attributes` as `ca` ON `ca`._id =  `li`.attribute_id
  INNER JOIN `companies_deliverables_attributes_values` as `cv` ON `cv`._id =  `li`.attribute_value_id
  INNER JOIN `commerce_metadata` as `cm` ON `cm`._id =  `cv`.metadata_id
  INNER JOIN `shared_types` as `st` ON `st`._id =  `cm`.rate_type_id
WHERE `li`.{$other_id_key} = {$other_id} AND `cd`._id = {$row['deliverable_id']} AND `li`.deliverable_id IS NOT NULL;
";
                            $title = "";
                            $description = "";
                            $rate_title = "";
                            $deliverable_id = "";
                            $sale_price = 0.00;
                            $price = 0.00;
                            $one_time_fee = 0.00;

                            $result_r = $conn->RunQuery($sql);
                            while( $row_r = $conn->FetchHash($result_r))
                            {
                                $row_r = array_map('utf8_encode', $row_r);

                                $deliverable_id = $row_r['_did'];
                                $title = $row_r['title'];
                                $description = $row_r['description'];
                                $rate_title = $row_r['rate_title'];

                                $price += (floatval($row_r['sale_price']) > 0) ? floatval($row_r['sale_price']) : floatval($row_r['price']);
                                $one_time_fee += floatval($row_r['one_time_fee']);

                                $variations[] = array(
                                    '_id' => strval($row_r['_lid']),
                                    'deliverable_id' => strval($deliverable_id),
                                    'attribute_id' => strval($row_r['attribute_id']),
                                    'attribute_value_id' => strval($row_r['attribute_value_id']),
                                    'title' => $row_r['variant_title'],
                                    'description' => $row_r['variant_description'],
                                    'price' => floatval($row_r['price']),
                                    'rate_title' => $row_r['rate_title'],
                                    'sku' => TSP_Helper::isEmpty($row_r['sku']) ? null : $row_r['sku'],
                                    'sale_price' => floatval($row_r['sale_price']),
                                    'one_time_fee' => floatval($row_r['one_time_fee'])
                                );
                            }

                            $deliverables[$row['deliverable_id']] = array(
                                'deliverable_id' => strval($deliverable_id),
                                'order' => intval($row['order']),
                                'quantity' => intval($row['quantity']),
                                'title' => $title,
                                'description' => $description,
                                'price' => floatval($price),
                                'price_override' => 0.00,
                                'rate_title' => $rate_title,
                                'sku' => null,
                                'sale_price' => 0.00,
                                'sale_price_override' => 0.00,
                                'one_time_fee' => floatval($one_time_fee),
                                'one_time_fee_override' => 0.00,
                                'variations' => $variations,
                                'variations_ids' => $this->getIDs($variations,'attribute_value_id'),
                            );
                        }
                        else if (TSP_Helper::isEmpty($row['attribute_id']) && TSP_Helper::isEmpty($row['attribute_value_id']))
                        {
                            $sql = "SELECT `cd`.title as `title`, `cd`.description as `description`, `cm`.*, `st`.title as rate_title FROM  `projects_statements_line_items` as `li`
  INNER JOIN `companies_deliverables` as `cd` ON `cd`._id =  `li`.deliverable_id
  INNER JOIN `commerce_metadata` as `cm` ON `cm`._id =  `cd`.metadata_id
  INNER JOIN `shared_types` as `st` ON `st`._id =  `cm`.rate_type_id
WHERE `li`.{$other_id_key} = {$other_id} AND `cd`._id = {$row['deliverable_id']} AND `li`.deliverable_id IS NOT NULL;
";
                            $result_r = $conn->RunQuery($sql);
                            while( $row_r = $conn->FetchHash($result_r))
                            {
                                $row_r = array_map('utf8_encode', $row_r);

                                $deliverables[$row['deliverable_id']] = array(
                                    '_id' => strval($row['_id']),
                                    'deliverable_id' => strval($row['deliverable_id']),
                                    'order' => intval($row['order']),
                                    'title' => $row_r['title'],
                                    'quantity' => intval($row['quantity']),
                                    'description' => $row_r['description'],
                                    'price' => floatval($row_r['price']),
                                    'price_override' => floatval($row['price_override']),
                                    'rate_title' => $row_r['rate_title'],
                                    'sku' => TSP_Helper::isEmpty($row_r['sku']) ? null : $row_r['sku'],
                                    'sale_price' => floatval($row_r['sale_price']),
                                    'sale_price_override' => floatval($row['sale_price_override']),
                                    'one_time_fee' => floatval($row_r['one_time_fee']),
                                    'one_time_fee_override' => floatval($row['one_time_fee_override']),
                                    'variations' => array(),
                                    'variations_ids' => array()
                                );
                            }

                        }
                    }
                    else if (!TSP_Helper::isEmpty($row['mission_id']))
                    {
                        $sql = "SELECT `li`.*, `pm`.title as `mission_title`, `pm`.description as `mission_description`, `pm`.price as `price`, `st`.title as rate_title FROM  `projects_statements_line_items` as `li`
  INNER JOIN `projects_missions` as `pm` ON `pm`._id = `li`.mission_id
  INNER JOIN `shared_types` as `st` ON `st`._id =  `pm`.rate_type_id
WHERE `li`.{$other_id_key} = {$other_id} AND `li`.mission_id IS NOT NULL";

                        $result_r = $conn->RunQuery($sql);
                        while( $row_r = $conn->FetchHash($result_r))
                        {
                            $row_r = array_map('utf8_encode', $row_r);

                            $missions[$row_r['_id']] = array(
                                '_id' => strval($row_r['_id']),
                                'mission_id' => strval($row_r['mission_id']),
                                'order' => intval($row_r['order']),
                                'quantity' => intval($row_r['quantity']),
                                'title' => $row_r['mission_title'],
                                'description' => $row_r['mission_description'],
                                'price' => floatval($row_r['price']),
                                'price_override' => floatval($row_r['price_override']),
                                'rate_title' => $row_r['rate_title'],
                                'sku' => null,
                                'sale_price' => 0.00,
                                'sale_price_override' => floatval($row_r['sale_price_override']),
                                'one_time_fee' => 0.00,
                                'one_time_fee_override' => floatval($row_r['one_time_fee_override'])
                            );
                        }
                    }
                    else if (TSP_Helper::isEmpty($row['mission_id']) && TSP_Helper::isEmpty($row['deliverable_id'])) {
                        $customs[] = array(
                            '_id' => strval($row['_id']),
                            'order' => intval($row['order']),
                            'quantity' => intval($row['quantity']),
                            'title' => $row['title'],
                            'description' => $row['description'],
                            'price' => floatval($row['price_override']),
                            'price_override' => floatval($row['price_override']),
                            'rate_title' => $this->getTypeTitle($row['rate_type_id']),
                            'sku' => TSP_Helper::isEmpty($row['sku']) ? null : $row['sku'],
                            'sale_price' => floatval($row['sale_price_override']),
                            'sale_price_override' => floatval($row['sale_price_override']),
                            'one_time_fee' => floatval($row['one_time_fee_override']),
                            'one_time_fee_override' => floatval($row['one_time_fee_override'])
                        );
                    }
                }

                foreach ($deliverables as $index => $value)
                {
                    $data[] = $value;
                }

                foreach ($missions as $index => $value)
                {
                    $data[] = $value;
                }

                foreach ($customs as $index => $value)
                {
                    $data[] = $value;
                }
            }
            else if ($object == 'companies_deliverables_attributes')
            {
                $other_id = TSP_Helper::arrGetVal($_REQUEST, 'other_id', null);
                $other_id_key = TSP_Helper::arrGetVal($_REQUEST, 'other_id_key', null);

                $conn = new TSP_Database('database');

                $attributes = array();

                $sql = "SELECT `ca`._id as `_aid`, `ca`.title as `title`, `ca`.description as `parent_description`, `cm`.*, `st`.title as rate_title FROM  `companies_deliverables_attributes` as `ca`
  INNER JOIN `commerce_metadata` as `cm` ON `cm`._id =  `ca`.metadata_id
  INNER JOIN `shared_types` as `st` ON `st`._id =  `cm`.rate_type_id
WHERE `ca`.{$other_id_key} = {$other_id}";
                if (TSP_Helper::isEmpty($other_id) || TSP_Helper::isEmpty($other_id_key))
                {
                    $sql = "SELECT `ca`._id as `_aid`, `ca`.title as `title`, `ca`.description as `parent_description`, `cm`.*, `st`.title as rate_title FROM  `companies_deliverables_attributes` as `ca`
  INNER JOIN `commerce_metadata` as `cm` ON `cm`._id =  `ca`.metadata_id
  INNER JOIN `shared_types` as `st` ON `st`._id =  `cm`.rate_type_id";
                }

                $result = $conn->RunQuery($sql);

                while( $row = $conn->FetchHash($result)){
                    $row = array_map('utf8_encode', $row);

                    $sql = "SELECT `cv`._id as `_avid`, `cv`.title as `title`, `cv`.description as `description`, `cm`.*, `st`.title as rate_title FROM  `companies_deliverables_attributes_values` as `cv`
  INNER JOIN `commerce_metadata` as `cm` ON `cm`._id =  `cv`.metadata_id
  INNER JOIN `shared_types` as `st` ON `st`._id =  `cm`.rate_type_id
WHERE `cv`.attribute_id = {$row['_aid']}";

                    $row['variations'] = array();
                    $row['variations_ids'] = array();
                    $row['sku'] = TSP_Helper::isEmpty($row['sku']) ? null : $row['sku'];

                    $result_r = $conn->RunQuery($sql);
                    while( $row_r = $conn->FetchHash($result_r)){
                        $row_r = array_map('utf8_encode', $row_r);
                        $row_r['sku'] = TSP_Helper::isEmpty($row_r['sku']) ? null : $row_r['sku'];
                        $row['variations'][] = $row_r;
                        array_push($row['variations_ids'], $row_r['_avid']);
                    }

                    $attributes[] = $row;
                }

                foreach ($attributes as $index => $value)
                {
                    $data[] = $value;
                }
            }
            else if ($object == 'companies_deliverables_attributes_values')
            {
                $other_id = TSP_Helper::arrGetVal($_REQUEST, 'other_id', null);
                $other_id_key = TSP_Helper::arrGetVal($_REQUEST, 'other_id_key', null);

                $conn = new TSP_Database('database');

                $attributes = array();

                $sql = "SELECT `cv`.attribute_id, `cv`._id as `_avid`, `cv`.title as `title`, `cv`.description as `parent_description`, `cm`.*, `st`.title as rate_title FROM  `companies_deliverables_attributes_values` as `cv`
  INNER JOIN `commerce_metadata` as `cm` ON `cm`._id =  `cv`.metadata_id
  INNER JOIN `shared_types` as `st` ON `st`._id =  `cm`.rate_type_id
  WHERE `ca`.{$other_id_key} = {$other_id}";
                if ($other_id_key == 'deliverable_id')
                {
                    $sql = "SELECT `cv`.attribute_id, `cv`._id as `_avid`, `cv`.title as `title`, `cv`.description as `parent_description`, `cm`.*, `st`.title as rate_title FROM  `companies_deliverables_attributes_values` as `cv`
  INNER JOIN `companies_deliverables_attributes` as `ca` ON `ca`._id =  `cv`.attribute_id
  INNER JOIN `commerce_metadata` as `cm` ON `cm`._id =  `ca`.metadata_id
  INNER JOIN `shared_types` as `st` ON `st`._id =  `cm`.rate_type_id
  WHERE `ca`.{$other_id_key} = {$other_id}";
                }
                else if (TSP_Helper::isEmpty($other_id) || TSP_Helper::isEmpty($other_id_key))
                {
                    $sql = "SELECT `cv`.attribute_id, `cv`._id as `_avid`, `cv`.title as `title`, `cv`.description as `parent_description`, `cm`.*, `st`.title as rate_title FROM  `companies_deliverables_attributes_values` as `cv`
  INNER JOIN `commerce_metadata` as `cm` ON `cm`._id =  `cv`.metadata_id
  INNER JOIN `shared_types` as `st` ON `st`._id =  `cm`.rate_type_id";
                }

                $result = $conn->RunQuery($sql);

                while( $row = $conn->FetchHash($result)){
                    $row = array_map('utf8_encode', $row);
                    $row['sku'] = TSP_Helper::isEmpty($row['sku']) ? null : $row['sku'];
                    $attributes[] = $row;
                }

                foreach ($attributes as $index => $value)
                {
                    $data[] = $value;
                }
            }
            else
            {
                $json_file = ABSPATH . "data/{$object}.json";

                if (file_exists($json_file))
                {
                    $contents = file_get_contents($json_file);
                    $data = json_decode($contents, true);
                    $type_id = TSP_Helper::arrGetVal($_REQUEST, 'type_id', null);
                    $owner = TSP_Helper::arrGetVal($_REQUEST, 'owner', null);
                    $owner_id = TSP_Helper::arrGetVal($_REQUEST, 'owner_id', null);
                    $country_code = TSP_Helper::arrGetVal($_REQUEST, 'country_code', null);
                    $lang_code = TSP_Helper::arrGetVal($_REQUEST, 'lang_code', null);
                    $action = TSP_Helper::arrGetVal($_REQUEST, 'action', null);

                    $other_id = TSP_Helper::arrGetVal($_REQUEST, 'other_id', null);
                    $other_id_key = TSP_Helper::arrGetVal($_REQUEST, 'other_id_key', null);

                    // @TODO: Remember to store settings in database for currency and config
                    if (!empty($country_code))
                        setlocale(LC_MONETARY, $lang_code);

                    if ($object == 'shared_media')
                    {
                        // overwrite shared_media
                        $data = $this->getMedia($owner_id, $owner, true);
                    }

                    foreach ($data as $index => $set)
                    {
                        // remove all records that the user user does not have access to
                        // or that does not belong to the current company
                        if (!$this->hasPermissions($object, $set, $current_company_id, $user_id, $id, $action,
                            $owner, $owner_id, $type_id, $country_code, $other_id, $other_id_key))
                        {
                            unset($data[$index]);
                            continue;
                        }

                        // @TODO: When launching the app we only display details based on the base company
                        // if a user is logging in we must establish which company it can see
                        // if a user has a null responsible_company_id that means they are admins and can
                        // view all base company records
                        // @TODO: Get user default settings
                        if (in_array($object, array('system_settings')))
                        {
                            $system_only  = TSP_Helper::arrGetVal($_REQUEST, 'system_only', null);
                            $user_only  = TSP_Helper::arrGetVal($_REQUEST, 'user_only', null);

                            if (TSP_Helper::toBool($system_only))
                            {
                                // If we are only viewing system preferences then remove user preferences
                                if (!TSP_Helper::isEmpty($set['user_id']))
                                {
                                    unset($data[$index]);
                                    continue;
                                }
                            }
                            else if (TSP_Helper::toBool($user_only))
                            {
                                // If we are only viewing user preferences then remove system preferences
                                if (!TSP_Helper::isEmpty($set['responsible_company_id']) || $set['user_id'] != $user_id)
                                {
                                    unset($data[$index]);
                                    continue;
                                }
                            }

                            $system_defaults = $this->getForeignData('system_settings_defaults', $set['setting_name'], 'setting_name');

                            if ($system_defaults['type'] == 'CALLBACK')
                            {
                                $params = array();

                                if ($system_defaults['options'] == 'CDemo::getWorkFlows')
                                {
                                    $params = array(
                                        'owner' => $system_defaults['setting_name'] == 'work_workflow_id' ? 'W' : 'AB',
                                        'current_company_id' => $current_company_id
                                    );
                                }

                                $system_defaults['options'] = call_user_func_array($system_defaults['options'], $params);
                                $system_defaults['type'] = 'SELECT';
                            }
                            else if ($system_defaults['type'] == 'SELECT')
                            {
                                $arr = explode(",", $system_defaults['options']);
                                $options = array();

                                foreach ($arr as $value){
                                    $value = trim($value);
                                    $options[] = array('_id' => $value, 'title' => $value);;
                                }
                                $system_defaults['options'] = $options;
                            }
                            else if (TSP_Helper::isEmpty($system_defaults))
                            {
                                unset($data[$index]);
                                continue;
                            }

                            $data[$index]['metadata'] = array(
                                'type' => strtolower($system_defaults['type']),
                                'options' =>  $system_defaults['options']
                            );
                        }
                        // @TODO: For all items that dont have a responsible_company_id use the referring project_id
                        // to determine if we can view the object
                        // @TODO Calculate totals for invoices and quotes
                        else if ($object == 'projects_statements')
                        {
                            // @TODO: Calculate totals
                            if ($data[$index]['status_id'] == 102)
                            {
                                $data[$index]['amount_due'] = money_format('%(#2n', 123);
                                $data[$index]['amount_paid'] = money_format('%(#2n', 123);
                            }
                            else
                            {
                                $data[$index]['amount_due'] = money_format('%(#2n', 123);
                                $data[$index]['amount_paid'] = money_format('%(#2n', 0);
                            }

                            $data[$index]['metadata']['payments'] = $this->getForeignData('commerce_payments', $data[$index]['_id'], 'owner_id', 'S', true);
                        }
                        else if ($object == 'professions')
                        {
                            $data[$index]['metadata'] = array();

                            $data[$index]['metadata']['responsibilities'] = $this->getForeignData('professions_responsibilities', $set['_id'], 'profession_id', null, true);
                            $data[$index]['metadata']['child_professions'] = $this->getForeignData('professions', $set['_id'], 'parent_id', null, true);

                            if (TSP_Helper::isEmpty($data[$index]['metadata']['responsibilities']))
                            {
                                $data[$index]['metadata']['responsibilities'][] = array();
                            }
                            if (TSP_Helper::isEmpty($data[$index]['metadata']['child_professions']))
                            {
                                $data[$index]['metadata']['child_professions'] = null;
                            }
                        }
                        else if ($object == 'projects')
                        {
                            $data[$index]['metadata'] = array();

                            $data[$index]['metadata']['missions'] = $this->getForeignData('projects_missions', $set['_id'], 'project_id', null, true);

                            if (TSP_Helper::isEmpty($data[$index]['metadata']['missions']))
                            {
                                $data[$index]['metadata']['missions'][] = array();
                            }
                        }

                        // @TODO: Get foreign data given a foreign key
                        foreach ($set as $key => $value)
                        {
                            if (preg_match("/_id$/", $key))
                            {
                                $data[$index][$key] = strval($set[$key]);
                            }
                            else if (preg_match("/^(is_|has_)/", $key))
                            {
                                $data[$index][$key] = ($value == 1) ? true : false;
                            }

                            if (preg_match("/_email$/", $key))
                            {
                                $new_key = preg_replace("/_email$/", "", $key);
                                $data[$index][$new_key."_avatar"] = array(
                                    'title'         => '',
                                    'description'   => '',
                                    'location'      => System::getGravatarURL($data[$index][$key])
                                );
                            }
                            else if (preg_match("/_type_id$/", $key ))
                            {
                                $new_key = preg_replace("/_type_id$/", "", $key);

                                if (array_key_exists($new_key, $set))
                                    $new_key .= "_info";

                                $data[$index][$new_key] = $this->getForeignData('shared_types', $value, '_id');

                            }
                            else if (preg_match("/_status_id$/", $key ))
                            {
                                $new_key = preg_replace("/_status_id$/", "", $key);

                                if (array_key_exists($new_key, $set))
                                    $new_key .= "_info";

                                $data[$index][$new_key] = $this->getForeignData('shared_statuses', $value, '_id');

                            }
                            else if (preg_match("/_release_id$/", $key ))
                            {
                                $new_key = preg_replace("/_release_id$/", "", $key);

                                if (array_key_exists($new_key, $set))
                                    $new_key .= "_info";

                                $data[$index][$new_key] = $this->getForeignData('projects_products_releases', $value, '_id');
                                $data[$index][$new_key]['product'] = $this->getForeignData('projects_products', $data[$index][$new_key]['product_id'], '_id');
                            }
                            else if (preg_match("/user_id$/", $key ))
                            {
                                $new_key = preg_replace("/_id$/", "", $key);

                                if (array_key_exists($new_key, $set))
                                    $new_key .= "_info";

                                $data[$index][$new_key] = $this->getForeignData('users', $value, '_id');
                                $data[$index][$new_key]['company'] = $this->getForeignData('companies', $data[$index][$new_key]['company_id'], '_id');
                                $data[$index][$new_key]['metadata'] = $this->getProfileData($value, 'U');

                                $settings = $this->getForeignData('system_settings', $value, 'user_id', null, true);

                                if (!TSP_Helper::isEmpty($settings))
                                {
                                    // Loop through settings and store them in the current user array
                                    foreach ($settings as $skey => $svalue)
                                    {
                                        if ($svalue['setting_value'] == "true")
                                            $data[$index][$new_key]['preferences'][$svalue['setting_name']] = true;
                                        else if ($svalue['setting_value'] == "false")
                                            $data[$index][$new_key]['preferences'][$svalue['setting_name']] = false;
                                        else
                                            $data[$index][$new_key]['preferences'][$svalue['setting_name']] = $svalue['setting_value'];

                                    }
                                }

                                $data[$index][$new_key]['metadata']['pay'] = $this->getUserPayRateData($value, $current_company_id);

                                if (TSP_Helper::isEmpty($data[$index][$new_key]['metadata']['pay']))
                                {
                                    $data[$index][$new_key]['metadata']['pay'][] = array(
                                        // Do not add objects here as it will distort the object-widget
                                    );
                                }

                                // @TODO: Nested info such as profiles and social media accounts need special cases
                                $data[$index][$new_key]['metadata']['social_accounts'] = $this->getSocialAccounts($value, 'U');
                            }
                            else if (preg_match("/company_id$/", $key ))
                            {
                                $new_key = preg_replace("/_id$/", "", $key);

                                if (array_key_exists($new_key, $set))
                                    $new_key .= "_info";

                                $data[$index][$new_key] = $this->getForeignData('companies', $value, '_id');
                                $data[$index][$new_key]['metadata'] = $this->getProfileData($value, 'C');

                                $data[$index][$new_key]['metadata']['pay'] = $this->getCompanyPayRateData($value, $current_company_id);

                                if (TSP_Helper::isEmpty($data[$index][$new_key]['metadata']['pay']))
                                {
                                    $data[$index][$new_key]['metadata']['pay'][] = array(
                                        // Do not add objects here as it will distort the object-widget
                                    );
                                }

                                // @TODO: Nested info such as profiles and social media accounts need special cases
                                $data[$index][$new_key]['metadata']['social_accounts'] = $this->getSocialAccounts($value, 'C');
                            }

                            else if (preg_match("/^_id$/", $key ))
                            {
                                if (in_array($object, array('locale_countries','locale_states')))
                                {
                                    $type_key = ($object == 'locale_countries') ? 'country' : 'state';

                                    $info = $this->getForeignData("{$object}_descriptions", $value, '_id');
                                    if (!TSP_Helper::isEmpty($info))
                                        $data[$index]['title'] = $info[$type_key];
                                }
                                else if (in_array($object, array('projects_products')))
                                {
                                    $data[$index]['releases'] = $this->getForeignData('projects_products_releases', $set['_id'], 'product_id', null, true);

                                    if (!TSP_Helper::isEmpty($data[$index]['releases']))
                                    {
                                        foreach ( $data[$index]['releases'] as $rindex => $release )
                                        {
                                            $status = $this->getForeignData('shared_statuses',$data[$index]['releases'][$rindex]['status_id'], '_id', null, true);
                                            $type = $this->getForeignData('shared_types', $data[$index]['releases'][$rindex]['type_id'], '_id', null, true);
                                            $data[$index]['releases'][$rindex]['status'] = $status[0];
                                            $data[$index]['releases'][$rindex]['type'] = $type[0];
                                        }
                                    }
                                    else
                                    {
                                        $data[$index]['releases'][] = array(
                                        );
                                    }
                                }
                                else if (in_array($object, array('users','companies')))
                                {
                                    $owner_key = ($object == 'users') ? 'U' : 'C';
                                    $data[$index]['metadata'] = $this->getProfileData($set['_id'], $owner_key);

                                    if ($object == 'users')
                                    {
                                        $settings = $this->getForeignData('system_settings', $set['_id'], 'user_id', null, true);

                                        if (!TSP_Helper::isEmpty($settings))
                                        {
                                            // Loop through settings and store them in the current user array
                                            foreach ($settings as $skey => $svalue)
                                            {
                                                if ($svalue['setting_value'] == "true")
                                                    $data[$index]['preferences'][$svalue['setting_name']] = true;
                                                else if ($svalue['setting_value'] == "false")
                                                    $data[$index]['preferences'][$svalue['setting_name']] = false;
                                                else
                                                    $data[$index]['preferences'][$svalue['setting_name']] = $svalue['setting_value'];
                                            }
                                        }

                                        // @TODO: When retrieving data, each record must have a title field for labeling
                                        $data[$index]['title'] = "{$set['last_name']}, {$set['first_name']}";

                                        $data[$index]['metadata']['pay'] = $this->getUserPayRateData($set['_id'], $current_company_id);

                                        if (TSP_Helper::isEmpty($data[$index]['metadata']['pay']))
                                        {
                                            $data[$index]['metadata']['pay'][] = array(
                                                // Do not add objects here as it will distort the object-widget
                                            );
                                        }
                                    }
                                    else if ($object == 'companies')
                                    {
                                        $data[$index]['metadata']['pay'] = $this->getCompanyPayRateData($set['_id'], $current_company_id);

                                        if (TSP_Helper::isEmpty($data[$index]['metadata']['pay']))
                                        {
                                            $data[$index]['metadata']['pay'][] = array(
                                                // Do not add objects here as it will distort the object-widget
                                            );
                                        }
                                    }

                                    // @TODO: Nested info such as profiles and social media accounts need special cases
                                    $data[$index]['metadata']['social_accounts'] = $this->getSocialAccounts($set['_id'], $owner_key);
                                }
                            }
                            else if (preg_match("/^description$/", $key ))
                            {
                                $conn = new TSP_Database('database');

                                $sql = "SELECT `description` FROM  `{$object}` WHERE `_id` = {$set['_id']}";
                                $result = $conn->RunQuery($sql);
                                $row = $conn->FetchHash($result);

                                if (!TSP_Helper::isEmpty($row))
                                {
                                    $row = array_map('utf8_encode', $row);

                                    $data[$index]['description'] = preg_replace("/\r\n/", "<br>", $row['description']);
                                    $data[$index]['description'] = preg_replace("/\n/", "<br>", $row['description']);
                                }
                            }
                            else if (preg_match("/^action_id$/", $key ))
                            {
                                $new_key = preg_replace("/_id$/", "", $key);

                                if (array_key_exists($new_key, $set))
                                    $new_key .= "_info";

                                $data[$index][$new_key] = $this->getForeignData('workflows_actions', $value, '_id');
                            }
                            else if (preg_match("/^attribute_id$/", $key ))
                            {
                                $new_key = preg_replace("/_id$/", "", $key);

                                if (array_key_exists($new_key, $set))
                                    $new_key .= "_info";

                                $data[$index][$new_key] = $this->getForeignData('companies_deliverables_attributes', $value, '_id');

                                if (!TSP_Helper::isEmpty($data[$index][$new_key]))
                                {
                                    $data[$index][$new_key]['metadata'] = $this->getForeignData('commerce_metadata', $data[$index][$new_key]['metadata_id'], '_id');

                                    if (!TSP_Helper::isEmpty($data[$index][$new_key]['metadata']))
                                    {
                                        $data[$index][$new_key]['metadata']['rate'] = $this->getForeignData('shared_types', $data[$index][$new_key]['metadata']['rate_type_id'], '_id');
                                    }
                                }
                            }
                            else if (preg_match("/^attribute_value_id$/", $key ))
                            {
                                $new_key = preg_replace("/_id$/", "", $key);

                                if (array_key_exists($new_key, $set))
                                    $new_key .= "_info";

                                $data[$index][$new_key] = $this->getForeignData('companies_deliverables_attributes_values', $value, '_id');

                                if (!TSP_Helper::isEmpty($data[$index][$new_key]))
                                {
                                    $data[$index][$new_key]['metadata'] = $this->getForeignData('commerce_metadata', $data[$index][$new_key]['metadata_id'], '_id');

                                    if (!TSP_Helper::isEmpty($data[$index][$new_key]['metadata']))
                                    {
                                        $data[$index][$new_key]['metadata']['rate'] = $this->getForeignData('shared_types', $data[$index][$new_key]['metadata']['rate_type_id'], '_id');
                                    }
                                }
                            }
                            else if (preg_match("/^browser_id$/", $key ))
                            {
                                $new_key = preg_replace("/_id$/", "", $key);

                                if (array_key_exists($new_key, $set))
                                    $new_key .= "_info";

                                $data[$index][$new_key] = $this->getForeignData('shared_browsers', $value, '_id');
                            }
                            else if (preg_match("/^category_ids$/", $key ) && !TSP_Helper::isEmpty($value))
                            {
                                $taxonomies = preg_split("/\,/", $value);
                                $taxonomy_arr = array();

                                foreach ($taxonomies as $taxonomy)
                                {
                                    $result = $this->getForeignData('shared_taxonomies', $taxonomy, '_id');
                                    $result['is_tag'] = (intval($result['is_tag']) == 1) ? true : false;

                                    $taxonomy_arr[] = $result;
                                }

                                $data[$index]['category_ids'] = explode(",", $value);
                                $data[$index]['categories'] = $taxonomy_arr;
                            }
                            else if (preg_match("/^deliverable_id$/", $key ))
                            {
                                $new_key = preg_replace("/_id$/", "", $key);

                                if (array_key_exists($new_key, $set))
                                    $new_key .= "_info";

                                $data[$index][$new_key] = $this->getForeignData('companies_deliverables', $value, '_id');

                                if (!TSP_Helper::isEmpty($data[$index][$new_key]))
                                {
                                    $data[$index][$new_key]['metadata'] = $this->getForeignData('commerce_metadata', $data[$index][$new_key]['metadata_id'], '_id');

                                    if (!TSP_Helper::isEmpty($data[$index][$new_key]['metadata']))
                                    {
                                        $data[$index][$new_key]['metadata']['rate'] = $this->getForeignData('shared_types', $data[$index][$new_key]['metadata']['rate_type_id'], '_id');
                                    }
                                }
                            }
                            else if (preg_match("/^discount_id$/", $key ))
                            {
                                $new_key = preg_replace("/_id$/", "", $key);

                                if (array_key_exists($new_key, $set))
                                    $new_key .= "_info";

                                $data[$index][$new_key] = $this->getForeignData('shared_discounts', $value, '_id');
                            }
                            else if (preg_match("/^file_type$/", $key))
                            {
                                $data[$index]['file_ext'] = preg_replace("/(.*?)\//","", $value);
                            }
                            else if (preg_match("/^has_attachment$/", $key))
                            {
                                $owner_code = CDemo::getOwnerCode($object);

                                $avatar = CDemo::getMedia($data[$index]['_id'], $owner_code, false, true);
                                $gallery = CDemo::getMedia($data[$index]['_id'], $owner_code, true, false);

                                if (TSP_Helper::isEmpty($avatar))
                                {
                                    $data[$index]['avatar'] = array(
                                        'title'             => '',
                                        'alternate_text'    => '',
                                        'description'       => '',
                                        'location'          => System::getGravatarURL($value)
                                    );
                                }
                                else
                                {
                                    $data[$index]['avatar'] = $avatar;
                                }

                                if (TSP_Helper::isEmpty($gallery))
                                {
                                    $data[$index]['gallery'] = array(
                                        'title'             => '',
                                        'alternate_text'    => '',
                                        'description'       => '',
                                        'location'          => System::getGravatarURL($value)
                                    );

                                }
                                else
                                {
                                    $data[$index]['gallery'] = $gallery;
                                }
                            }
                            else if (preg_match("/^order_id$/", $key ))
                            {
                                $new_key = preg_replace("/_id$/", "", $key);

                                if (array_key_exists($new_key, $set))
                                    $new_key .= "_info";

                                $data[$index][$new_key] = $this->getForeignData('commerce_orders', $value, '_id');
                            }
                            else if (preg_match("/^owner$/", $key ))
                            {
                                $data[$index]['owner_info'] = $this->getForeignData('shared_owner_codes', $set['owner'], 'owner');

                                switch($data[$index]['owner']){
                                    case 'S':
                                        $data[$index]['owner_info']['item'] = $this->getForeignData('projects_statements', $set['owner_id'], '_id');
                                        break;
                                    case 'N':
                                        $data[$index]['owner_info']['item'] = $this->getForeignData('events', $set['owner_id'], '_id');
                                        break;
                                }
                            }
                            else if (preg_match("/^parent_id$/", $key ))
                            {
                                $new_key = preg_replace("/_id$/", "", $key);

                                if (array_key_exists($new_key, $set))
                                    $new_key .= "_info";

                                $data[$index][$new_key] = $this->getForeignData($object, $value, '_id');

                                // @TODO: For all parent records that have associated profiles store it
                                if (in_array($object, array('users','companies')))
                                {
                                    $owner_key = ($object == 'users') ? 'U' : 'C';
                                    $data[$index][$new_key]['metadata'] = $this->getProfileData($value, $owner_key);
                                }

                                // @TODO: If a referring parent id is empty it must have a replacement title
                                if (TSP_Helper::isEmpty($value))
                                {
                                    if ($object == 'users')
                                        $data[$index][$new_key]['title'] = 'Administrator';
                                    else
                                        $data[$index][$new_key]['title'] = 'None';
                                }
                            }
                            else if (preg_match("/^payment_id$/", $key ))
                            {
                                $new_key = preg_replace("/_id$/", "", $key);

                                if (array_key_exists($new_key, $set))
                                    $new_key .= "_info";

                                $data[$index][$new_key] = $this->getForeignData('commerce_payments', $value, '_id');
                            }
                            else if (preg_match("/^posted_to_ids$/", $key ) && !TSP_Helper::isEmpty($value))
                            {
                                $ids = preg_split("/\,/", $value);
                                $id_arr = array();

                                foreach ($ids as $to_id)
                                {
                                    $id_arr[] = $this->getForeignData('shared_types', $to_id, '_id');
                                }

                                $data[$index]['posted_to_ids'] = explode(",", $value);
                                $data[$index]['posted_to'] = $id_arr;
                            }
                            else if (preg_match("/^priority_id$/", $key ))
                            {
                                $new_key = preg_replace("/_id$/", "", $key);

                                if (array_key_exists($new_key, $set))
                                    $new_key .= "_info";

                                $data[$index][$new_key] = $this->getForeignData('shared_priorities', $value, '_id');
                            }
                            else if (preg_match("/^product_id$/", $key ))
                            {
                                $new_key = preg_replace("/_id$/", "", $key);

                                if (array_key_exists($new_key, $set))
                                    $new_key .= "_info";

                                $data[$index][$new_key] = $this->getForeignData('projects_products', $value, '_id');
                            }
                            else if (preg_match("/^profession_id$/", $key ))
                            {
                                $new_key = preg_replace("/_id$/", "", $key);

                                if (array_key_exists($new_key, $set))
                                    $new_key .= "_info";

                                $data[$index][$new_key] = $this->getForeignData('professions', $value, '_id');
                            }
                            else if (preg_match("/^project_id$/", $key ))
                            {
                                $new_key = preg_replace("/_id$/", "", $key);

                                if (array_key_exists($new_key, $set))
                                    $new_key .= "_info";

                                $project = $this->getForeignData('projects', $value, '_id');
                                $project['client_user'] = $this->getForeignData('users', $project['client_user_id'], '_id');
                                $project['client_user']['metadata'] = $this->getProfileData($project['client']['_id'], 'U');

                                $data[$index][$new_key] = $project;
                            }
                            else if (preg_match("/^metadata_id$/", $key ))
                            {
                                $new_key = preg_replace("/_id$/", "", $key);

                                if (array_key_exists($new_key, $set))
                                    $new_key .= "_info";

                                $metadata = $this->getForeignData('commerce_metadata', $value, '_id');

                                // @TODO: Metadata for deliverables need to have a final_price
                                if (!TSP_Helper::isEmpty($metadata['price']) && !TSP_Helper::isEmpty($metadata['sale_price']))
                                    $metadata['final_price'] = "{$metadata['sale_price']} <span style='text-decoration: line-through;'>{$metadata['price']}</span>";
                                else if (!TSP_Helper::isEmpty($metadata['price']) && TSP_Helper::isEmpty($metadata['sale_price']))
                                    $metadata['final_price'] = $metadata['price'];
                                else if (TSP_Helper::isEmpty($metadata['price']) && !TSP_Helper::isEmpty($metadata['sale_price']))
                                    $metadata['final_price'] = $metadata['sale_price'];
                                else if (TSP_Helper::isEmpty($metadata['price']) && TSP_Helper::isEmpty($metadata['sale_price']) && !TSP_Helper::isEmpty($metadata['one_time_fee']))
                                    $metadata['final_price'] = $metadata['one_time_fee'];
                                else
                                    $metadata['final_price'] = "0.00";

                                // image names are renamed to avatar
                                $type = $this->getForeignData('shared_types', $metadata['rate_type_id'], '_id');

                                $metadata['final_price'] = money_format('%(#2n', $metadata['final_price']);
                                $metadata['final_price'] .= "/<small>{$type['title']}</small>";

                                $avatar = CDemo::getMedia($set['_id'], 'V', false, true);
                                $gallery = CDemo::getMedia($set['_id'], 'V', true, false);

                                if (TSP_Helper::isEmpty($avatar))
                                {
                                    $metadata['avatar'] = array(
                                        'title'             => '',
                                        'alternate_text'    => '',
                                        'description'       => '',
                                        'location'          => System::getGravatarURL($metadata['avatar_id'])
                                    );
                                }
                                else
                                {
                                    $metadata['avatar'] = $avatar;
                                }

                                if (TSP_Helper::isEmpty($gallery))
                                {
                                    $metadata['gallery'] = array(
                                        'title'             => '',
                                        'alternate_text'    => '',
                                        'description'       => '',
                                        'location'          => System::getGravatarURL($metadata['avatar_id'])
                                    );
                                }
                                else
                                {
                                    $metadata['gallery'] = $gallery;
                                }

                                if (!TSP_Helper::isEmpty($metadata['category_ids']))
                                {
                                    $taxonomies = preg_split("/\,/", $metadata['category_ids']);
                                    $taxonomy_arr = array();

                                    foreach ($taxonomies as $taxonomy)
                                    {
                                        $result = $this->getForeignData('shared_taxonomies', $taxonomy, '_id');
                                        $result['is_tag'] = (intval($result['is_tag']) == 1) ? true : false;

                                        $taxonomy_arr[] = $result;
                                    }

                                    $metadata['category_ids'] = explode(",", $metadata['category_ids']);
                                    $metadata['categories'] = $taxonomy_arr;
                                }
                                if (!TSP_Helper::isEmpty($metadata['tag_ids']))
                                {
                                    $taxonomies = preg_split("/\,/", $metadata['tag_ids']);
                                    $taxonomy_arr = array();

                                    foreach ($taxonomies as $taxonomy)
                                    {
                                        $result = $this->getForeignData('shared_taxonomies', $taxonomy, '_id');
                                        $result['is_tag'] = (intval($result['is_tag']) == 1) ? true : false;

                                        $taxonomy_arr[] = $result;
                                    }

                                    $metadata['tag_ids'] = explode(",", $metadata['tag_ids']);
                                    $metadata['tags'] = $taxonomy_arr;
                                }

                                $data[$index][$new_key] = $metadata;
                            }
                            else if (preg_match("/^mission_id$/", $key ))
                            {
                                $new_key = preg_replace("/_id$/", "", $key);

                                if (array_key_exists($new_key, $set))
                                    $new_key .= "_info";

                                $data[$index][$new_key] = $this->getForeignData('projects_missions', $value, '_id');
                            }
                            else if (preg_match("/^responsibility_id$/", $key ))
                            {
                                $new_key = preg_replace("/_id$/", "", $key);

                                if (array_key_exists($new_key, $set))
                                    $new_key .= "_info";

                                $data[$index][$new_key] = $this->getForeignData('professions_responsibilities', $value, '_id');
                            }
                            else if (preg_match("/^setting_value$/", $key))
                            {
                                if ($value == "true")
                                    $data[$index][$key] = true;
                                else if ($value == "false")
                                    $data[$index][$key] = false;
                                else
                                    $data[$index][$key] = $value;
                            }
                            else if (preg_match("/^statement_id$/", $key ))
                            {
                                $new_key = preg_replace("/_id$/", "", $key);

                                if (array_key_exists($new_key, $set))
                                    $new_key .= "_info";

                                $data[$index][$new_key] = $this->getForeignData('projects_statements', $value, '_id');
                            }
                            else if (preg_match("/^status_id$/", $key ))
                            {
                                $new_key = preg_replace("/_id$/", "", $key);

                                if (array_key_exists($new_key, $set))
                                    $new_key .= "_info";

                                $data[$index][$new_key] = $this->getForeignData('shared_statuses', $value, '_id');
                            }
                            else if (preg_match("/^system_id$/", $key ))
                            {
                                $new_key = preg_replace("/_id$/", "", $key);

                                if (array_key_exists($new_key, $set))
                                    $new_key .= "_info";

                                $data[$index][$new_key] = $this->getForeignData('shared_systems', $value, '_id');
                            }
                            else if (preg_match("/^tag_ids$/", $key ) && !TSP_Helper::isEmpty($value))
                            {
                                $taxonomies = preg_split("/\,/", $value);
                                $taxonomy_arr = array();

                                foreach ($taxonomies as $taxonomy)
                                {
                                    $result = $this->getForeignData('shared_taxonomies', $taxonomy, '_id');
                                    $result['is_tag'] = (intval($result['is_tag']) == 1) ? true : false;

                                    $taxonomy_arr[] = $result;
                                }

                                $data[$index]['tag_ids'] = explode(",", $value);
                                $data[$index]['tags'] = $taxonomy_arr;
                            }
                            else if (preg_match("/^type_id$/", $key ))
                            {
                                $new_key = preg_replace("/_id$/", "", $key);

                                if (array_key_exists($new_key, $set))
                                    $new_key .= "_info";

                                $data[$index][$new_key] = $this->getForeignData('shared_types', $value, '_id');
                            }
                            else if (preg_match("/^time_zone$/", $key ))
                            {
                                $new_key = "{$key}_info";

                                $dateTime = new DateTime();
                                $dateTime->setTimeZone(new DateTimeZone($value));

                                $data[$index][$new_key] = $dateTime->format('T');
                            }
                            else if (preg_match("/^transition_id$/", $key ))
                            {
                                $new_key = preg_replace("/_id$/", "", $key);

                                if (array_key_exists($new_key, $set))
                                    $new_key .= "_info";

                                $data[$index][$new_key] = $this->getForeignData('workflows_transitions', $value, '_id');
                            }
                            else if (preg_match("/^workflow_id$/", $key ))
                            {
                                $new_key = preg_replace("/_id$/", "", $key);

                                if (array_key_exists($new_key, $set))
                                    $new_key .= "_info";

                                $data[$index][$new_key] = $this->getForeignData('workflows', $value, '_id');
                            }
                        }

                        if ($object == 'events'){
                            // @TODO PHP and JAVASCRIPT are converting these times in two different ways
                            // Its best to store all times in the database as UTC and when displaying display
                            // in the proper time zone
                            $data[$index]['metadata']['location'] = $this->getProfileData($data[$index]['_id'], 'N');
                            $data[$index]['metadata']['payments'] = $this->getForeignData('commerce_payments', $data[$index]['_id'], 'owner_id', 'N', true);
                        }
                        else if ($object == 'companies_deliverables')
                        {

                            $data[$index]['metadata']['missions'] = $this->getForeignData('projects_missions', $set['_id'], 'project_id', null, true);

                            if (TSP_Helper::isEmpty($data[$index]['metadata']['missions']))
                            {
                                $data[$index]['metadata']['missions'][] = array();
                            }
                        }
                    }

                    sort($data);
                }
            }

            if (!TSP_Helper::isEmpty($data))
            {
                $this->response['success'] = array(
                    'path'      => $full_path,
                    'title'     => 'Success',
                    'message'   => 'Data successfully retrieved.',
                    'type_id'   => 'success',
                );
            }
            else
            {
                $this->response['error'] = array(
                    'path'      => $full_path,
                    'title'     => 'Error Occurred',
                    'message'   => 'Unable to load demo data for ' . $type,
                    'type_id'   => 'error',
                );
            }

        } catch (Exception $e){
            if (TSP_Config::get('app.debug'))
            {
                $this->response['admin_error'][] = $e->getMessage();
            }
            $this->response['error'] = array(
                'path'      => $full_path,
                'title'     => 'Error Occurred',
                'message'   => 'Unknown error (301) occurred. Please contact your system administrator or try again at a later time.',
                'type'      => 'error',
            );

        }

        // if an ID was given only return the first record
        if (!TSP_Helper::isEmpty($id))
        {
            if (TSP_Helper::toBool($testing))
                var_dump($data[0]);

            return $data[0];
        }
        else
        {
            if (TSP_Helper::toBool($testing))
                var_dump($data);

            return $data;
        }
    }

    public function uploadFile(){
        $data = array();
        $param_name = 'avatar';
        $full_path = TSP_Helper::arrGetVal($_SERVER, 'REQUEST_URI');

        $current_company_id = TSP_Helper::arrGetVal($_POST, 'current_company_id', null);
        $user_id = TSP_Helper::arrGetVal($_POST, 'user_id', null);
        $lang_code = TSP_Helper::arrGetVal($_POST, 'lang_code', null);
        $owner = TSP_Helper::arrGetVal($_POST, 'owner', null);
        $owner_id = TSP_Helper::arrGetVal($_POST, 'owner_id', null);

        $allowed_types = array(
            'image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/ico',
            'audio/mp3', 'audio/m4a', 'audio/ogg', 'audio/wav',
            'video/mp4', 'video/mov', 'video/wmv', 'video/avi', 'video/mpg', 'video/ogv', 'video/3gp', 'video/3g2',
            'application/pdf', 'application/doc', 'application/docx', 'application/ppt',
            'application/pptx', 'application/pps', 'application/ppsx', 'application/odt',
            'application/xls', 'application/xlsx', 'application/psd'
        );

        if (empty($_FILES))
        {
            $this->response['error'] = array(
                'title' => 'Error Occurred',
                'message' => 'File not uploaded because its invalid. Please go back and try again.',
                'type' => 'error',
            );

        }
        else
        {
            if ( !in_array($_FILES[$param_name]['type'], $allowed_types) )
            {
                $this->response['error'] = array(
                    'title' => 'Error Occurred',
                    'message' => 'File not uploaded because its the wrong type. Please go back and try again.',
                    'type' => 'error',
                );

            }
            else
            {
                $time = time();
                $uploaded_file = UPLOADPATH . "/{$time}-{$_FILES[$param_name]['name']}";
                move_uploaded_file($_FILES[$param_name]['tmp_name'], $uploaded_file);

                if (file_exists($uploaded_file))
                {
                    $data['uploaded_file'] = basename($uploaded_file);
                    $data['post'] = $_POST;

                    // @TODO Store file info in database
                    // @TODO Use company number to store files in the uploads directory
/*
                    foreach ($files as $file) {
                        $destinationPath 	= "uploads";
                        $filename 			= uniqid().".".$file->getClientOriginalExtension();
                        $originalfilename 	= $file->getClientOriginalName();
                        $filetype 			= $file->getMimeType();
                        $filePath 			= $file->getRealPath();

                        if(substr($file->getMimeType(), 0, 5) == 'image')
                        {
                            $mediainfo = array(
                                'path' 				=> $destinationPath.'/images/full',
                                'filename' 			=> $filename,
                                'originalfilename' 	=> $originalfilename,
                                'medium_path' 		=> $destinationPath.'/images/medium',
                                'thumbnail_path' 	=> $destinationPath.'/images/thumbnails',
                                'thumbnail_filename'=> $filename, //probably not nessesary but I'll leave this in case the names later need to be different.
                                'context' 			=> 'default' //default context, (basically all purpose).
                            );
                        }//end if
                        else
                        {
                            //TODO: fill out routes for other file types.
                            //TODO: right now, they're just going into a 'documents' folder
                            $mediainfo = array(
                                'path' 				=> $destinationPath.'/documents',
                                'filename' 			=> $filename,
                                'originalfilename' 	=> $originalfilename,
                                'thumbnail' 		=> '<i class="fa fa-file"></i>', // just use generic file icon if it's not an image.
                                'context' 			=> 'default' //default context, (basically all purpose).
                            );
                        }//end else



                        if ($filetype == "image/gif" || strtolower($file->getClientOriginalExtension()) == "gif")
                        {
                            //if this is a gif, break it down and resize each frame
                            //as it's own image, then reconstruct them back into an
                            //animated gif. This is done so resizing gifs doesn't break
                            //the animation.
                            $image = new Imagick($filePath);
                            $image = $image->coalesceImages();

                            //first parameter of scale image is image width, second parameter as zero makes height match and crops it as a square

                            foreach ($image as $frame) {
                                $frame->scaleImage(400, 0); //medium size
                                $frame->setImagePage(400, 0, 0, 0);
                            }

                            $image = $image->deconstructImages();
                            $image->writeImages("uploads/images/medium/" . $filename, true);

                            foreach ($image as $frame) {
                                $frame->scaleImage(100, 0); //thumbnail size
                                $frame->setImagePage(100, 0, 0, 0);
                            }

                            $image = $image->deconstructImages();
                            $image->writeImages("uploads/images/thumbnails/" . $filename, true);

                        }

                        elseif(substr($file->getMimeType(), 0, 5) == 'image')
                        {
                            //if it's not a gif, but just another image format
                            //just resize the one image
                            $image = new Imagick($filePath);
                            $image->scaleImage(400, 0);// medium size
                            $image->writeImage("uploads/images/medium/" . $filename);
                            $image->scaleImage(100, 0);// thumbnail size
                            $image->writeImage("uploads/images/thumbnails/" . $filename);
                        }

                        elseif(substr($file->getMimeType(), 0, 5) != 'image')
                        {
                            //TODO: Add special handling for files other than images
                            //TODO: Add special handling for files other than images
                            //TODO: Add special handling for files other than images
                            //TODO: Add special handling for files other than images
                            //TODO: Add special handling for files other than images
                            //TODO: Add special handling for files other than images
                            //TODO: Add special handling for files other than images
                            //TODO: Add special handling for files other than images
                        }

                        if($file->move($destinationPath.'/images/full', $filename))
                        {
                            $media = new DefaultMedia($mediainfo);
                            $media->save();
                        } //end if file move
                    } //end foreach files as file
*/
                }
                else
                {
                    $this->response['error'] = array(
                        'title' => 'Error Occurred',
                        'message' => 'File not uploaded. Please contact your system administrator.',
                        'type' => 'error',
                    );
                }
            }
        }

        return $data;
    }

    public static function getCountries(){
        $countries = array();

        $json_file = ABSPATH . "data/locale_countries_descriptions.json";

        if (file_exists($json_file))
        {
            $contents = file_get_contents($json_file);
            $data = json_decode($contents, true);

            foreach ($data as $value){
                $countries[] = array('_id' => strval($value['_id']), 'title' => $value['title']);
            }
        }

        return $countries;
    }

    public static function getCurrencies(){
        return array (0 => array('_id' => 'en', 'title' => 'USD $'));
    }

    public static function getLang($user_id){

        $data = array();
        $lang_code = "en";

        if (!TSP_Helper::isEmpty($user_id))
        {
            $conn = new TSP_Database('database');

            $sql = "SELECT `setting_value` FROM `system_settings` WHERE `user_id` = $user_id AND `setting_name` = 'lang_code'";
            $result = $conn->RunQuery($sql);
            $row = $conn->FetchHash($result);

            if (!TSP_Helper::isEmpty($row))
            {
                $row = array_map('utf8_encode', $row);
                $lang_code = $row['setting_value'];
            }
        }

        $lang_file = ABSPATH . "lang/$lang_code.json";

        if (file_exists($lang_file))
        {
            $contents = file_get_contents($lang_file);
            $data = json_decode($contents, true);
        }

        return $data;
    }

    public static function getMedia($owner_id, $owner_code, $return_array = false, $featured_only = false){

        $avatars = array();

        $media_file = ABSPATH . "data/shared_media.json";
        $media_metadata_file = ABSPATH . "data/shared_media_metadata.json";

        if (file_exists($media_file) && file_exists($media_metadata_file))
        {
            $contents = file_get_contents($media_file);
            $media_data = json_decode($contents, true);

            $contents = file_get_contents($media_metadata_file);
            $media_meta_data = json_decode($contents, true);

            foreach ($media_meta_data as $value)
            {
                if (intval($value['owner_id']) == intval($owner_id) && $value['owner'] == $owner_code)
                {
                    $media_id = $value['media_id'];
                    $is_featured = $value['is_featured'];

                    foreach ($media_data as $media_value)
                    {
                        if (intval($media_value['_id']) == intval($media_id))
                        {
                            $media_value['is_featured'] = $is_featured;

                            if (($featured_only && TSP_Helper::toBool($media_value['is_featured'])) || !$featured_only)
                                $avatars[] = $media_value;
                        }
                    }
                }
            }
        }

        if (count($avatars) == 1 && !$return_array)
            return $avatars[0];
        else
            return $avatars;
    }

    public static function getOwnerCode($object){

        $owner_code = null;

        $json_file = ABSPATH . "data/shared_owner_codes.json";

        if (file_exists($json_file))
        {
            $contents = file_get_contents($json_file);
            $data = json_decode($contents, true);

            foreach ($data as $value){
                if ($value['table'] == $object)
                    $owner_code = $value['owner'];
            }
        }

        return $owner_code;
    }

    public static function getPrefixTypes(){
        // @TODO store text in lang file
        $data = array(
            array(
                '_id'   => 'company',
                'title' => 'First Letters of Company Name'
            ),
            array(
                '_id'   => 'category',
                'title' => 'First Letters of Category Name'
            ),
            array(
                '_id'   => 'deliverable_name',
                'title' => 'First Letters of Deliverable Name'
            ),
            array(
                '_id'   => 'deliverable_id',
                'title' => 'Deliverable ID'
            ),
            array(
                '_id'   => 'auto_gen',
                'title' => 'Auto-Generated'
            ),
            array(
                '_id'   => 'none',
                'title' => 'None'
            )
        );

        return $data;
    }

    public static function getSeperators(){
        // @TODO store text in lang file
        $data = array(
            array(
                '_id'   => '-',
                'title' => 'Dash'
            ),
            array(
                '_id'   => ',',
                'title' => 'Comma'
            ),
            array(
                '_id'   => '.',
                'title' => 'Period'
            )
        );

        return $data;
    }

    public static function getStateName($id){
        $name = "";

        $json_file = ABSPATH . "data/locale_states_descriptions.json";

        if (file_exists($json_file))
        {
            $contents = file_get_contents($json_file);
            $data = json_decode($contents, true);

            foreach ($data as $value){
                if (intval($value['_id']) == intval($id))
                    $name = $value['title'];
            }
        }

        return $name;
    }

    public static function getStates(){
        $states = array();

        $json_file = ABSPATH . "data/locale_states.json";

        if (file_exists($json_file))
        {
            $contents = file_get_contents($json_file);
            $data = json_decode($contents, true);

            foreach ($data as $value){

                $states[] = array(
                    '_id' => strval($value['_id']),
                    'state_code' => $value['state_code'],
                    'country_code' => $value['country_code'],
                    'title' => CDemo::getStateName($value['_id'])
                );
            }
        }

        return $states;
    }

    public static function getWorkFlows($owner, $current_company_id){
        $workflows = array();

        $json_file = ABSPATH . "data/workflows.json";

        if (file_exists($json_file))
        {
            $contents = file_get_contents($json_file);
            $data = json_decode($contents, true);

            foreach ($data as $value){

                if ($value['owner'] == $owner && ($value['responsible_company_id'] == $current_company_id || TSP_Helper::isEmpty($value['responsible_company_id'])))
                    $workflows[] = array('_id' => $value['_id'], 'title' => $value['title']);
            }
        }

        return $workflows;

    }

    public static function getAutogenTypes(){
        // @TODO store text in lang file
        $data = array(
            array(
                '_id'   => 'numbers',
                'title' => 'Numbers Only'
            ),
            array(
                '_id'   => 'letters',
                'title' => 'Characters Only'
            ),
            array(
                '_id'   => 'alpha_numeric',
                'title' => 'Alpha-Numeric'
            )
        );

        return $data;
    }

    private function belongsToAllCompanies($record)
    {
        if (TSP_Helper::isEmpty($record['responsible_company_id']))
            return true;

        return false;
    }

    private function belongsToCompany($record, $current_company_id)
    {
        if (!TSP_Helper::isEmpty($record['responsible_company_id']) && $record['responsible_company_id'] == $current_company_id)
            return true;

        return false;
    }

    private function generatePrefix(&$data, $prefix_type, $auto_gen_len, $auto_gen_type, $sep = '')
    {
        $prefix = "";

        if ($prefix_type == 'deliverable_id')
        {
            $prefix = $data['deliverable_id'].$sep;
        }//endif
        elseif ($prefix_type == 'deliverable_name')
        {
            $prefix = $data['deliverable_name'].$sep;
        }//endelseif
        elseif ($prefix_type == 'company')
        {
            $prefix = $data['company'].$sep;
        }//endelseif
        elseif ($prefix_type == 'category')
        {
            $prefix = $data['category'].$sep;
        }//endelseif
        elseif ($prefix_type == 'none')
        {
            $prefix = "";
        }//endelseif
        else
        { //default autogen

            if ($auto_gen_type == 'numbers')
            {
                $auto_gen_code = strtoupper(TSP_Helper::genKey($auto_gen_len,false,true,false));
            }
            else if ($auto_gen_type == 'letters')
            {
                $auto_gen_code = strtoupper(TSP_Helper::genKey($auto_gen_len,false,false,true));
            }
            else
            {
                $auto_gen_code = strtoupper(TSP_Helper::genKey($auto_gen_len,false,true,true));
            }

            $prefix = $auto_gen_code.$sep;

        }//endif

        return $prefix;
    }//end generatePrefix

    private function getCategoryNames($cat_ids){

        $cat_names = array();

        foreach ($cat_ids as $id)
        {
            $category_data = $this->getForeignData('shared_taxonomies', $id, '_id');

            $cat_names[] = $category_data['title'];
        }//endforeach

        return $cat_names;
    }//end getCategoryNames

    private function getCompanyPayRateData($id, $current_company_id, $activeOnly = true)
    {
        $data = null;

        try{
            $json_file = ABSPATH . "data/companies_pay_rates.json";

            if (file_exists($json_file))
            {
                $contents = file_get_contents($json_file);
                $json_data = json_decode($contents, true);

                foreach($json_data as $index => $set)
                {
                    if ($this->belongsToCompany($set, $current_company_id) && $set['company_id'] == $id)
                    {
                        if (($activeOnly && intval($set['status_id']) == 180) || !$activeOnly)
                        {
                            $data[] = array(
                                'status_id' => strval($set['status_id']),
                                'type_id' => strval($set['type_id']),
                                'rate'  => $set['rate'],
                                'rate_type_id' => strval($set['rate_type_id'])
                            );
                        }
                    }
                }
            }
            else
            {
                $this->response['error'] = array(
                    'title'     => 'Error Occurred',
                    'message'   => 'Unable to load company pay rate data for ' . $type,
                    'type_id'      => 'error',
                );
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

        return $data;
    }

    /**
     * Function to get data based on foreign key
     *
     * @since 1.0.0
     *
     * @param string $object - the type of json file
     * @param string $id - the $owning id of a shared object
     * @param string $id_key - the $owning id key of a shared object
     * @param string $owner - optional: the $owning code of a shared object
     * @param boolean $is_multi_array - optional: return the data in a multi array or not
     *
     * @return array
     * @ReturnType array
     */
    private function getForeignData($object, $id, $id_key, $owner = null, $is_multi_array = false)
    {
        $data = null;

        try{
            $json_file = ABSPATH . "data/{$object}.json";

            if (file_exists($json_file))
            {
                $contents = file_get_contents($json_file);
                $json_data = json_decode($contents, true);

                if (!TSP_Helper::isEmpty($json_data))
                {
                    foreach($json_data as $index => $set)
                    {
                        if ((strval($id) == strval($set[$id_key]) && TSP_Helper::isEmpty($owner)) ||
                            (strval($id) == strval($set[$id_key]) && $owner == $set['owner']))
                        {
                            if ($object == 'users')
                                $set['title'] = "{$set['last_name']}, {$set['first_name']}";

                            foreach ($set as $key => $value)
                            {
                                if (preg_match("/_id$/", $key))
                                    $set[$key] = strval($value);
                            }

                            if($is_multi_array)
                                $data[] = $set;
                            else
                                $data = $set;
                        }
                    }
                }
            }
            else
            {
                $this->response['error'] = array(
                    'title'     => 'Error Occurred',
                    'message'   => 'Unable to load foreign demo data for ' . $type,
                    'type_id'      => 'error',
                );
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

        return $data;
    }

    private function getIDs($arr, $key){
        $keys = array();

        foreach ($arr as $index => $value)
        {
            if (!TSP_Helper::isEmpty($value[$key]))
                array_push($keys, $value[$key]);
        }

       return $keys;
    }

    private function getParentProject($table, $record)
    {
        if ($this->hasProject($table))
            return $this->getForeignData('projects', $record['project_id'], '_id');

        return null;
    }

    /**
     * Function to get profile data
     *
     * @since 1.0.0
     *
     * @param string $id - the $owning id of a shared object
     * @param string $owner - optional: the $owning code of a shared object
     * @param boolean $defaultOnly - optional: whether or not to only return default profiles
     *
     * @return array
     * @ReturnType array
     */
    private function getProfileData($id, $owner, $defaultOnly = true)
    {
        $data = null;

        try{
            $json_file = ABSPATH . "data/shared_profiles.json";

            if (file_exists($json_file))
            {
                $contents = file_get_contents($json_file);
                $json_data = json_decode($contents, true);

                foreach($json_data as $index => $set)
                {
                    if ($id == $set['owner_id'] && $owner == $set['owner'])
                    {
                        $avatar = CDemo::getMedia($set['_id'], 'A', false, true);
                        $gallery = CDemo::getMedia($set['_id'], 'A', true, false);

                        if (TSP_Helper::isEmpty($avatar))
                        {
                            $set['avatar'] = $metadata['avatar'] = array(
                                'title'             => '',
                                'alternate_text'    => '',
                                'description'       => '',
                                'location'          => System::getGravatarURL($set['email'])
                            );
                        }
                        else
                        {
                            $set['avatar'] = $avatar;
                        }

                        if (TSP_Helper::isEmpty($gallery))
                        {
                            $set['gallery'] = $metadata['gallery'] = array(
                                'title'             => '',
                                'alternate_text'    => '',
                                'description'       => '',
                                'location'          => System::getGravatarURL($set['email'])
                            );
                        }
                        else
                        {
                            $set['gallery'] = $gallery;
                        }

                        $set['state'] = $this->getForeignData('locale_states', $set['state_id'], '_id');
                        $set['country'] = $this->getForeignData('locale_countries', $set['state']['country_code'], '_id');

                        $state = $this->getForeignData('locale_states_descriptions', $set['state_id'], '_id');
                        if (!TSP_Helper::isEmpty($state))
                            $set['state']['title'] = $state['title'];

                        $country = $this->getForeignData('locale_countries_descriptions', $set['state']['country_code'], '_id');
                        if (!TSP_Helper::isEmpty($country))
                            $set['country']['title'] = $country['title'];

                        $set['_id'] = strval($set['_id']);
                        $set['state_id'] = strval($set['state_id']);
                        $set['type_id'] = strval($set['type_id']);
                        $set['owner_id'] = strval($set['owner_id']);

                        if ($defaultOnly && TSP_Helper::toBool($set['is_default']))
                            $data = $set;
                        else
                            $data[] = $set;
                    }
                }
            }
            else
            {
                $this->response['error'] = array(
                    'title'     => 'Error Occurred',
                    'message'   => 'Unable to load profile data for ' . $type,
                    'type_id'      => 'error',
                );
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

        return $data;
    }

    private function getSocialAccounts($id, $owner)
    {
        $data = null;
        $social_links = array(
            'facebook' => 'https://www.facebook.com/',
            'twitter' => 'https://www.twitter.com/',
            'instagram' => 'https://www.instagram.com/',
            'linkedin' => 'https://www.linkedin.com/',
            'google-plus' => 'https://plus.google.com/+',
            'skype' => '',
            'snapchat' => '',
            'github' => 'https://www.github.com/',
            'bitbucket' => 'https://bitbucket.org/',
        );

        try{
            $json_file = ABSPATH . "data/shared_social.json";

            if (file_exists($json_file))
            {
                $contents = file_get_contents($json_file);
                $json_data = json_decode($contents, true);

                if (!TSP_Helper::isEmpty($json_data))
                {
                    foreach($json_data as $index => $set)
                    {
                        if ((strval($id) == strval($set['owner_id']) && $owner == $set['owner']))
                        {
                            $info = $this->getForeignData('shared_types', $set['type_id'], '_id');

                            if (!TSP_Helper::isEmpty($set['username']))
                            {
                                $title = strtolower($info['title']);

                                $set['title'] = $info['title'];
                                $set['icon'] = $info['icon'];

                                if (!TSP_Helper::isEmpty($social_links[$title]))
                                {
                                    // @TODO Do not keep social links in database
                                    if ($info['_id'] == 333) //linked in
                                    {
                                        if ($owner == 'C')
                                            $set['link'] = $social_links[$title] . 'company/';
                                        else
                                            $set['link'] = $social_links[$title] . 'in/';
                                    }
                                    else
                                        $set['link'] = $social_links[$title];
                                }
                                else
                                {
                                    $set['link'] = "#";
                                }
                            }

                            $data[] = $set;
                        }
                    }
                }
            }
            else
            {
                $this->response['error'] = array(
                    'title'     => 'Error Occurred',
                    'message'   => 'Unable to social demo data for ' . $type,
                    'type_id'      => 'error',
                );
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

        if (TSP_Helper::isEmpty($data))
        {
            $data[] = array(
                'username' => "",
                'title' => "Social Media",
                'type_id' => "0"
            );
        }
        return $data;
    }

    private function getTypeTitle($id)
    {
        $data = null;

        try{
            $json_file = ABSPATH . "data/shared_types.json";

            if (file_exists($json_file))
            {
                $contents = file_get_contents($json_file);
                $json_data = json_decode($contents, true);

                foreach($json_data as $index => $set)
                {
                    if (intval($set['_id']) == $id)
                    {
                        $data = $set['title'];
                    }
                }
            }
            else
            {
                $this->response['error'] = array(
                    'title'     => 'Error Occurred',
                    'message'   => 'Unable to load type title data for ' . $type,
                    'type_id'      => 'error',
                );
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

        return $data;
    }

    private function getUserPayRateData($id, $current_company_id, $activeOnly = true)
    {
        $data = null;

        try{
            $json_file = ABSPATH . "data/users_pay_rates.json";

            if (file_exists($json_file))
            {
                $contents = file_get_contents($json_file);
                $json_data = json_decode($contents, true);

                foreach($json_data as $index => $set)
                {
                    if ($this->belongsToCompany($set, $current_company_id) && $set['user_id'] == $id)
                    {
                        if (($activeOnly && intval($set['status_id']) == 180) || !$activeOnly)
                        {
                            $data[] = array(
                                'status_id' => strval($set['status_id']),
                                'type_id' => strval($set['type_id']),
                                'rate'  => $set['rate'],
                                'rate_type_id' => strval($set['rate_type_id'])
                            );
                        }
                    }
                }
            }
            else
            {
                $this->response['error'] = array(
                    'title'     => 'Error Occurred',
                    'message'   => 'Unable to get pay rate demo data for ' . $type,
                    'type_id'      => 'error',
                );
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

        return $data;
    }

    /**
     * Determine if user has proper permissions
     *
     * @since 1.0.0
     *
     * @param string $object - the type of json file
     * @param string $record - The current record being analyzed
     * @param int $current_company_id - The current company the user is signed into
     * @param int $user_id - the user ID of the current user
     * @param int $record_id (optional) - ID of a given record if given
     * @param string $action (optional) - the current action being performed
     * @param string $owner (optional) - the owner code if given
     * @param int $type_id (optional) - The record type if given
     * @param string $country_code (optional) - The record's country code if given
     * @param int $other_id (optional) - Incoming ID indexed by $other_key
     * @param int $other_id_key (optional) - Incoming ID key for $other_id
     *
     * @return boolean
     */
    private function hasPermissions($object, $record, $current_company_id, $user_id, $record_id = null, $action = null, $owner = null, $owner_id = null, $type_id = null, $country_code = null, $other_id = null, $other_id_key = null)
    {
        $has_permissions = false;
        $user = $this->getForeignData('users', $user_id, '_id');

        if ($object == 'email')
            $has_permissions = true;

        // @TODO: When retrieving shared data (only if it has an owner code), if an owner is given only bring back that type
        if (!TSP_Helper::isEmpty($owner) && $this->isSharedTable($object) && $owner == $record['owner'] && TSP_Helper::isEmpty($owner_id))
        {
            $has_permissions = true;
        }

        // @TODO: When retrieving data, if an id is given only bring back that record
        if (!TSP_Helper::isEmpty($record_id) && strval($record_id) == strval($record['_id']) && TSP_Helper::isEmpty($other_id))
        {
            $has_permissions = true;
        }

        // @TODO: When retrieving data, if a type_id is given only bring back that record (ie for Users)
        if (!TSP_Helper::isEmpty($type_id) && strval($type_id) == strval($record['type_id']) && TSP_Helper::isEmpty($other_id))
        {
            $has_permissions = true;
        }

        // @TODO: When retrieving states, only bring back states given the specified country code
        if (!TSP_Helper::isEmpty($country_code) && $country_code == $record['country_code'] && TSP_Helper::isEmpty($other_id))
        {
            $has_permissions = true;
        }

        // @TODO: if this is shared data anyone can view it
        if ($this->isSharedTable($object))
        {
            $has_permissions = true;
        }
        // @TODO if the record has responsible company set (ie professions)
        else if ($this->hasResponsibleCompany($object))
        {
            if ($object == 'system_settings')
            {
                if ($this->belongsToCompany($record, $current_company_id) || $this->isAdmin($user))
                {
                    // only the admin can view system settings
                    if ($this->isAdmin($user))
                    {
                        $has_permissions = true;
                    }
                    // if the settings are for users
                    else if ($this->belongsToCompany($record, $user['responsible_company_id']) && !$this->isAdmin($user))
                    {
                        $has_permissions = true;
                    }
                }
                else if ($user_id == $record['user_id'] && !TSP_Helper::isEmpty($record['user_id']) && !TSP_Helper::isEmpty($user_id))
                {
                    $has_permissions = true;
                }
            }
            else {
                if ($this->isRestricted($object))
                {
                    if ($action == 'get_base' && $object == 'companies')
                    {
                        if ($this->isParentCompany($record) && $this->isAdmin($user))
                        {
                            $has_permissions = true;
                        }
                    }
                    else if ($action == 'get_professionals' && $object == 'users')
                    {
                        if ($this->isParentCompany($record) && $this->isAdmin($user) && $record['type_id'] == 20)
                        {
                            $has_permissions = true;
                        }
                    }
                    else if ($object == 'users' && !TSP_Helper::isEmpty($record_id))
                    {
                        if (strval($record['_id']) == strval($user_id) && strval($record_id) == strval($user_id))
                        {
                            $has_permissions = true;
                        }
                    }
                    else if ($object == 'users' && $action == 'employees' && !TSP_Helper::isEmpty($other_id))
                    {
                        if (preg_match("/\|/", $other_id_key))
                        {
                            list($key1, $key2) = preg_split("/\|/", $other_id_key);

                            if ((strval($record[$key1]) == strval($other_id) || strval($record[$key2]) == strval($other_id)) && $this->isAdmin($user))
                            {
                                $has_permissions = true;
                            }
                        }
                        else if (strval($record[$other_id_key]) == strval($other_id) && $this->isAdmin($user))
                        {
                            $has_permissions = true;
                        }
                    }
                    else if (TSP_Helper::isEmpty($other_id) && TSP_Helper::isEmpty($type_id))
                    {
                        if (($this->belongsToCompany($record, $current_company_id) || $this->isCurrentBaseCompany($object, $record, $current_company_id) || $this->isUserAdmin($object, $record)) && $this->isAdmin($user))
                        {
                            $has_permissions = true;
                        }
                    }
                }
                else
                {
                    if ($this->belongsToCompany($record, $current_company_id) || $this->belongsToAllCompanies($record))
                    {
                        // @TODO: Find out cases for normal users
                        if (TSP_Helper::isEmpty($owner) && !TSP_Helper::isEmpty($other_id) && TSP_Helper::isEmpty($type_id))
                        {
                            if (preg_match("/\|/", $other_id_key))
                            {
                                list($key1, $key2) = preg_split("/\|/", $other_id_key);

                                if ((strval($record[$key1]) == strval($other_id) || strval($record[$key2]) == strval($other_id)) && $this->isAdmin($user))
                                {
                                    $has_permissions = true;
                                }
                            }
                            // @TODO profession_responsibilities with a null value belong to all professions as a basic responsibility of the profession
                            else if ((strval($record[$other_id_key]) == strval($other_id) || strval($record[$other_id_key]) == null) && $object == 'professions_responsibilities' && $this->isAdmin($user))
                            {
                                $has_permissions = true;
                            }
                            else if (strval($record[$other_id_key]) == strval($other_id) && $this->isAdmin($user))
                            {
                                $has_permissions = true;
                            }

                            if ($object == 'projects_statements' && strval($other_id) == "130")
                            {
                                // include retainers in searches for invoice
                                // @TODO NASTY HACK because of JSON, will change when working backend
                                if (strval($record[$other_id_key]) == strval(132))
                                {
                                    $has_permissions = true;
                                }
                            }
                        }
                        else if (TSP_Helper::isEmpty($owner) && !TSP_Helper::isEmpty($other_id) && !TSP_Helper::isEmpty($type_id))
                        {
                            if (strval($record['type_id']) == strval($type_id) && strval($record[$other_id_key]) == strval($other_id))
                            {
                                $has_permissions = true;
                            }
                        }
                        else if (!TSP_Helper::isEmpty($owner) && !TSP_Helper::isEmpty($owner_id) && TSP_Helper::isEmpty($type_id))
                        {
                            if (strval($record['owner_id']) == strval($owner_id) && $record['owner'] == $owner)
                            {
                                $has_permissions = true;
                            }
                        }
                        else if (!TSP_Helper::isEmpty($owner) && TSP_Helper::isEmpty($owner_id) && TSP_Helper::isEmpty($type_id))
                        {
                            if ($record['owner'] == $owner)
                            {
                                $has_permissions = true;
                            }
                        }
                        else if (TSP_Helper::isEmpty($owner) && TSP_Helper::isEmpty($other_id) && TSP_Helper::isEmpty($type_id) && $this->isAdmin($user))
                        {
                            $has_permissions = true;
                        }
                    }
                }
            }
        }
        else if ($this->hasProject($object))
        {
            $project = $this->getParentProject($object,$record);

            if (!TSP_Helper::isEmpty($other_id))
            {
                if (preg_match("/\|/", $other_id_key))
                {
                    list($key1, $key2) = preg_split("/\|/", $other_id_key);

                    if ((strval($record[$key1]) == strval($other_id) || strval($record[$key2]) == strval($other_id)) && $project['responsible_company_id'] == $current_company_id  && $this->isAdmin($user))
                    {
                        if (TSP_Helper::isEmpty($type_id))
                        {
                            $has_permissions = true;
                        }
                        else if (!TSP_Helper::isEmpty($type_id) && $record['type_id'] == $type_id)
                        {
                            $has_permissions = true;
                        }
                    }
                }
                else if (strval($record[$other_id_key]) == strval($other_id) && $project['responsible_company_id'] == $current_company_id  && $this->isAdmin($user))
                {
                    if (TSP_Helper::isEmpty($type_id))
                    {
                        $has_permissions = true;
                    }
                    else if (!TSP_Helper::isEmpty($type_id) && $record['type_id'] == $type_id)
                    {
                        $has_permissions = true;
                    }
                }
            }
            else if (TSP_Helper::isEmpty($type_id) && TSP_Helper::isEmpty($other_id) && $project['responsible_company_id'] == $current_company_id && $this->isAdmin($user))
            {
                $has_permissions = true;
            }
        }
        else if ($this->isAdmin($user))
        {
            // @TODO: Handle case for none admins viewing items with iternal flags
            if ($object == 'shared_comments' && !TSP_Helper::isEmpty($owner) && !TSP_Helper::isEmpty($owner_id))
            {
                if (strval($record['owner_id']) == strval($owner_id) && $owner == $record['owner'])
                {
                    $has_permissions = true;
                }
            }
            else if ($object == 'system_activities' && !TSP_Helper::isEmpty($owner) && !TSP_Helper::isEmpty($owner_id))
            {
                if (strval($record['owner_id']) == strval($owner_id) && $owner == $record['owner'])
                {
                    $has_permissions = true;
                }
            }
            else if ($object == 'users_worklog_hours' && !TSP_Helper::isEmpty($other_id))
            {
                if (preg_match("/\|/", $other_id_key))
                {
                    list($key1, $key2) = preg_split("/\|/", $other_id_key);

                    if ((strval($record[$key1]) == strval($other_id) || strval($record[$key2]) == strval($other_id)))
                    {
                        $has_permissions = true;
                    }
                }
                else if (strval($record[$other_id_key]) == strval($other_id))
                {
                    $has_permissions = true;
                }
            }
            else if ($object == 'companies_deliverables_attributes' && !TSP_Helper::isEmpty($other_id))
            {
                if (preg_match("/\|/", $other_id_key))
                {
                    list($key1, $key2) = preg_split("/\|/", $other_id_key);

                    if ((strval($record[$key1]) == strval($other_id) || strval($record[$key2]) == strval($other_id)))
                    {
                        $has_permissions = true;
                    }
                }
                else if (strval($record[$other_id_key]) == strval($other_id))
                {
                    $has_permissions = true;
                }
            }
            else if ($object == 'projects_products_commits' && !TSP_Helper::isEmpty($other_id))
            {
                if (preg_match("/\|/", $other_id_key))
                {
                    list($key1, $key2) = preg_split("/\|/", $other_id_key);

                    if ((strval($record[$key1]) == strval($other_id) || strval($record[$key2]) == strval($other_id)))
                    {
                        $has_permissions = true;
                    }
                }
                else if (strval($record[$other_id_key]) == strval($other_id))
                {
                    $has_permissions = true;
                }
            }
            else if ($object == 'projects_statements_line_items' && !TSP_Helper::isEmpty($other_id))
            {
                if (preg_match("/\|/", $other_id_key))
                {
                    list($key1, $key2) = preg_split("/\|/", $other_id_key);

                    if ((strval($record[$key1]) == strval($other_id) || strval($record[$key2]) == strval($other_id)))
                    {
                        $has_permissions = true;
                    }
                }
                else if (strval($record[$other_id_key]) == strval($other_id))
                {
                    $has_permissions = true;
                }
            }
        }

        return $has_permissions;
    }

    private function hasProject($table)
    {
        if (in_array($table, array(
            'projects_work', 'projects_missions', 'projects_products','projects_products_releases',
            'projects_sprints', 'projects_contracts', 'projects_statements',
            'projects_resources'
        ))){
            return true;
        }

        return false;
    }

    private function hasResponsibleCompany($table)
    {
        if (in_array($table, array(
            'users', 'users_pay_rates', 'users_worklog',
            'companies', 'companies_deliverables', 'companies_pay_rates', 'events',
            'professions', 'professions_responsibilities', 'shared_discounts',
            'projects', 'projects_contracts', 'projects_statements', 'submissions', 'posts',
            'workflows', 'system_settings', 'system_apis', 'commerce_payments', 'commerce_orders'
        ))){
            return true;
        }
    }

    private function isParentCompany($record){

        if (TSP_Helper::isEmpty($record['responsible_company_id']))
            return true;

        return false;
    }

    private function isRestricted($table){

        if (in_array($table, array(
            'users', 'companies'
        ))){
            return true;
        }

        return false;
    }

    private function isSharedTable($table)
    {
        if (in_array($table, array(
            'shared_systems', 'shared_media', 'shared_taxonomies', 'shared_priorities', 'shared_browsers', 'shared_types', 'shared_statuses'
        ))){
            return true;
        }

        return false;
    }

    private function isUserAdmin($object, $record){

        if ($object == 'users' && TSP_Helper::isEmpty($record['responsible_company_id']))
            return true;

        return false;
    }

    private function isCurrentBaseCompany($object, $record, $current_company_id)
    {
        if ($object == 'companies' && TSP_Helper::isEmpty($record['responsible_company_id']) && strval($record['_id']) == strval($current_company_id))
            return true;

        return false;
    }

    private function isAdmin($user){

        if (TSP_Helper::isEmpty($user['responsible_company_id']))
            return true;
        return false;
    }

    private function sliceName($names, $max_len)
    {
        $name = "";

        $first_x_chars = false;

        if (sizeof($names) < $max_len)
        {
            $first_x_chars = true;
        }//endif

        if ($first_x_chars)
        {
            $stripped = preg_replace("[^A-Za-z0-9 ]", "", $names[0]); //remove special chars
            $name = strtoupper(substr($stripped, 0, $max_len));
        }//endif
        else
        {
            $i = 0;
            while ($i < $max_len)
            {
                $stripped = preg_replace("[^A-Za-z0-9 ]", "", $names[$i]); //remove special chars
                $name .= strtoupper(substr($stripped, 0, 1)); // get first letter of name
                $i++;
            }//endwhile
        }//endelse

        return $name;
    }//end sliceName
}