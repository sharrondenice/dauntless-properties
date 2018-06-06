<?php
/**
 * Cron Processor
 *
 * @package     Cron
 * @filename    CronHelper.php
 * @version     1.0.8
 * @author      SharronDenice, The Software People (www.thesoftwarepeople.com)
 * @copyright   Copyright 2016 The Software People (www.thesoftwarepeople.com). All rights reserved
 * @license     APACHE v2.0 (http://www.apache.org/licenses/LICENSE-2.0)
 * @brief       Cron to process system duties
 *
 */


class CronHelper
{
    protected $conn = null;
    public $response = null;

    /**
     * Constructor
     *
     * @since 1.0.0
     *
     * @internal param $none
     *
     */
    function __construct()
    {
        try{
            $config = getRSABasicAzureSQLDBConfig(getConfigVal('SQLDBInstanceName'));
            $this->conn = new SQLDBConnector($config);
            $this->response = array();
        } catch (Exception $e){
            if (DEBUG)
            {
                $this->response['admin_error'][] = $e->getMessage();
            }
            $this->response['error'] = array(
                'title' => 'Error Occurred',
                'message' => 'Unknown error (700) occurred. Please contact your system administrator or try again at a later time.',
                'type' => 'error',
            );

        }
    }

    /**
     * Method to create/delete Stripe customers - ADMIN FUNCTION ONLY
     *
     * @since 1.0.0
     *
     * @param string $stripe_id - customer Stripe ID, if none, null string passed
     * @param bool $logging - turn logging on or off
     * @param string $key  - the key for performing admin function
     *
     * @return none
     */
    public function invoiceCustomers($stripe_id, $logging, $key)
    {
        // This is a admin function that requires a key
        if ($key != ADMIN_KEY)
            return null;

        $last_id = null;
        $current_date = time();

        if ($stripe_id == 'null')
            $stripe_id = null;

        $logging = TSP_Helper::toBool($logging);

        $log = null; // if logging is true
        $testing = false; // for internal testing
        $email_on = true; // turn email on/off
        $continue_on_error = true; // RECOMMENDED true

        try
        {
            do
            {
                Stripe\Stripe::setApiKey(getConfigVal('STRIPE_SECRET_KEY'));

                $customers = Stripe\Customer::all(array(
                    "limit" => 100,
                    "starting_after" => $last_id,
                ));

                foreach ($customers->data as $index => $customer)
                {
                    $last_id = $customer->id;

                    if ($logging)
                        $log .= "Processing Customer #{$customer->id}...";

                    // if we are supplying a customer ID and the current ID does not equal that
                    // ID then skip
                    if (!empty($stripe_id) && $stripe_id != $customer->id)
                    {
                        if ($logging)
                            $log .= "skipped<br>\n";

                        continue;
                    }
                    else
                    {
                        if ($logging)
                            $log .= "<br>\n";
                    }

                    $invoice = StripeHelper::stripeGetCurrentInvoice($customer->id, $this->response);

                    if (!empty($invoice))
                    {
                        $days_til_ann = $invoice->daysTilAnniversary($current_date);

                        if ($logging)
                            $log .= "Days til Anniversary: {$days_til_ann}<br>\n";

                        // If this is the anniversary date or if its passed
                        // bill the customer, allow continue if testing
                        if ($days_til_ann < 1 || $testing)
                        {
                            $closed = false;
                            $line_items = $invoice->getLineItems();

                            if ($logging)
                                $log .= "Line Items: " . count($line_items) . "<br>\n";

                            if (!$testing)
                                // Close all previous invoices AFTER line items generated
                                $closed = StripeHelper::stripeCloseInvoices($customer->id, $this->response);

                            if ($logging)
                                $log .= "Previous Invoices Closed: {$closed}<br>\n";

                            if (!$testing)
                                $invoice = StripeHelper::stripeCreateInvoice($this->response, $customer->id, $invoice->description, $line_items, true);
                            else
                                $invoice = "test";

                            if (!empty($invoice))
                            {
                                if (!$testing)
                                    $invoice->pay();

                                if ($logging)
                                    $log .= "** INVOICE PAID **<br><br>\n\n";

                                $coupon_code = null;

                                if (isset($customer->discount->coupon->id))
                                    $coupon_code = $customer->discount->coupon->id;

                                $params = array(
                                    'email'             => $customer->email,
                                    'first_name'        => $customer->metadata['first_name'],
                                    'last_name'         => $customer->metadata['last_name'],
                                    'address'           => $customer->metadata['address'],
                                    'city'              => $customer->metadata['city'],
                                    'state'             => $customer->metadata['state'],
                                    'zip'               => $customer->metadata['zip'],
                                    'phone'             => $customer->metadata['phone'],
                                    'line_items'        => $line_items,
                                    'coupon_code'       => StripeHelper::stripeGetCoupon($coupon_code, $response),
                                    'backoffice_domain' => 'https://' . BACKOFFICE_DOMAIN,
                                    'company_name'      => TSP_Settings::$admin_from_name,
                                    'agency_name'       => $customer->metadata['agency_name'],
                                    'stripe_id'         => $customer->id,
                                    'invoice_date'      => date(TSP_Settings::$date_format_pretty, $current_date),
                                    'subject'           => TSP_Settings::$admin_from_name . ' - Payment Invoice',
                                    'template'          => 'subscriptions/email/payment',
                                );

                                if (!$testing)
                                {
                                    $params['invoice_id'] = $invoice->id;
                                    $params['total'] = $invoice->total / 100;
                                }
                                else
                                {
                                    $params['invoice_id'] = 'inv_923802389423';
                                    $params['total'] = '599.00';
                                }

                                if ($email_on)
                                    StripeHelper::notifyStripeCustomer($params);
                            }
                            else
                            {
                                if ($logging)
                                    $log .= "Invoice NOT Paid Because of an Error<br><br>\n\n";

                                if (!$continue_on_error)
                                    throw new Exception("Unable to Create New Invoice for the User.");
                            }
                        }
                        else
                        {
                            if ($logging)
                                $log .= "Invoice Not Ready to be Paid<br><br>\n\n";
                        }
                    }
                    else
                    {
                        if ($logging)
                            $log .= "No Valid Invoice Found for the User...skipping<br><br>\n\n";

                        if (!$continue_on_error)
                            throw new Exception("No Valid Invoice Found for the User.");
                    }
                }
            } while (TSP_Helper::toBool($customers->has_more));

            if ($logging)
            {
                $mail = new TSP_Mail(TSP_Settings::$admin_from_email, TSP_Settings::$admin_from_name, true);

                $body = "Logging report for daily cron";
                $body .= "<br>\nDate: " . date(TSP_Settings::$date_format_database, $current_date);
                $body .= "<br>\nLog: <br>\n" . $log;

                $subject = 'Daily Cron for ' . date(TSP_Settings::$date_format_pretty, $current_date);

                $mail->send(TSP_Settings::$admin_from_email, $subject, $body);
            }
        }
        catch (Exception $e) {
            $mail = new TSP_Mail(TSP_Settings::$admin_from_email, TSP_Settings::$admin_from_name, true);

            $body = "An error occurred generating an invoice for customer #{$last_id}";
            $body .= "<br>\nDate: " . date(TSP_Settings::$date_format_database, $current_date);
            $body .= "<br>\nError: " . $e->getMessage();
            $body .= "<br>\nResponse: " . var_export($this->response, true);
            $body .= "<br>\nLog: " . $log;

            $mail->send(TSP_Settings::$admin_from_email, 'Cron: Error generating invoice', $body);
        }
    }
}