<?php
/**
 * Registration Processor
 *
 * @package     dauntless-properties
 * @filename    User.test.php
 * @version     1.0.0
 * @author      SharronDenice, The Software People (www.thesoftwarepeople.com)
 * @copyright   Copyright 2018 The Software People (www.thesoftwarepeople.com). All rights reserved
 * @license     APACHE v2.0 (http://www.apache.org/licenses/LICENSE-2.0)
 * @brief       ${DESCRIPTION}
 *
 */

require_once 'PHPUnit/Autoload.php';

final class UserTest extends TestCase {
    public function getAll()
    {
        User::getAll(ESharedType::Admin, EOwnerType::User);
    }
}