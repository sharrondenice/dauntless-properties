(function() {
    'use strict';

    angular.module('proApp.core.lang', [
        'ngSanitize',
        'ui.router',
        'ui.bootstrap',
        'ngAnimate',
        'ngStorage',
        'ngResource',
        'FBAngular',
        'ng-sweet-alert'
    ])
        .factory('lang', langFactory)
    ;

    var lang = {
        en: {
            'app': {
                'name': 'Dauntless Properties',
                'title': 'Dauntless Properties',
                'title_html': '<span>Dauntless</span>&nbsp;Properties',
                'company': 'Sharron Denice',
                'copyright': '2018 &copy; <strong>Sharron Denice</strong>. Dauntless Properties.',
                'description': 'All-In-One Property Management System',
                'blurb': 'Property <strong>Management</strong>'
            },
            'labels': {
                'buttons': {
                    'register': 'Register Now',
                    'login': 'Login',
                    'upload_continue': 'Upload & Continue',
                    'validate_send': 'Validate & Send',
                    'validate_create': 'Validate & Create',
                    'validate_update': 'Validate & Update',
                    'delay': 'Please Wait...',
                    'sign_out': 'Sign Out',
                    'account': 'Account',
                    'profile': 'See Profile',
                    'photo': 'Photo',
                    'add': 'Add'
                }
            },
            'nav': {
                'title': 'Navigation',
                'dashboards': {
                    'title': 'Dashboards',
                    'my': 'My Dashboard',
                    'project': 'Project',
                    'financial': 'Financial',
                    'social': 'Social'
                },
                'account': {
                    'title': 'Account',
                    'management': 'Account Management',
                    'contacts': 'Contacts',
                    'timecards': 'Time Cards'
                },
                'company': {
                    'title': 'Company',
                    'orders': 'Orders',
                    'management': 'Company Management',
                    'companies': 'Companies',
                    'submissions': 'Submissions',
                    'email': {
                        'title': 'Email',
                        'inbox': 'Inbox',
                        'compose': 'Compose Email'
                    },
                    'publishing': 'Publishing',
                    'financials': {
                        'title': 'Financials',
                        'overview': 'Overview',
                        'discounts': 'Discounts',
                        'payroll': 'Payroll',
                        'invoices': 'Invoices',
                        'proposals': 'Proposals'
                    },
                    'deliverables': 'Deliverables'
                },
                'crm': {
                    'title': 'CRM',
                    'management': 'Project Management',
                    'projects': 'Projects',
                    'missions': 'Missions',
                    'work': 'Work',
                    'sprints': 'Sprints',
                    'events': 'Events',
                    'contracts': 'Contracts'
                },
                'property': {
                    'title': 'Properties',
                    'management': 'Property Management',
                    'reservations': 'Reservations'
                },
                'system': {
                    'title': 'System',
                    'transfer': {
                        'title': 'Data Transfer',
                        'import': 'Import Data',
                        'export': 'Export Data'
                    },
                    'settings': 'Settings',
                    'preferences': 'Preferences',
                    'integrations': 'Integrations',
                    'updates': 'Updates',
                    'licensing': 'Licensing'
                },
                'themes': {
                    'title': 'Themes'
                }
            },
            'words': {
                'about': 'About',
                'about_me': 'About Me',
                'add': 'Add',
                'add_line_item': 'Add Line Item',
                'add_new_item': 'Add New Item',
                'additional': 'Additional',
                'additional_info': 'Additional Information',
                'address': 'Address',
                'address1': 'Address Line 1',
                'address2': 'Address Line 2',
                'all_companies': 'All Companies',
                'amount': 'Amount',
                'application': 'application',
                'associated': 'Associated',
                'assigned': 'Assigned',
                'assigned_to': 'Assigned To',
                'attachments': 'Attachments',
                'attribute': 'Attribute',
                'attributes': 'Attributes',
                'author': 'Author',
                'available': 'Available',
                'bill_rate': 'Bill Rate',
                'browser': 'Browser',
                'caption': 'Caption',
                'categories': 'Categories',
                'category': 'Category',
                'change': 'Change',
                'classification': 'Classification',
                'client': 'Client',
                'client_name': 'Client Name',
                'comment': 'Comment',
                'comment_internal': 'Internal Comments',
                'comments': 'Comments',
                'company': 'Company',
                'company_name': 'Company Name',
                'contact_info': 'Contact Info',
                'contact': 'Contact',
                'contacts': 'Contacts',
                'cost': 'Cost',
                'country': 'Country',
                'city': 'City',
                'create': 'Create',
                'create_username': 'Create Username',
                'custom': 'Custom',
                'custom_item': 'Custom Item',
                'dbhost': 'Hostname',
                'dbname': 'Database Name',
                'dbpass': 'Database Password',
                'dbuser': 'Database User',
                'date_completed': 'Date Completed',
                'date_created': 'Date Created',
                'date_due': 'Date Due',
                'date_est_complete': 'Date Estimated Complete',
                'date_expires': 'Date Expires',
                'date_generated': 'Date Generated',
                'date_paid': 'Date Paid',
                'date_released': 'Date Released',
                'date_started': 'Date Started',
                'date_last_updated': 'Date Last Updated',
                'delete': 'Delete',
                'delete_record': 'Delete Record',
                'deliverable': 'Deliverable',
                'details': 'Details',
                'description': 'Description',
                'discount': 'Discount',
                'dob': 'Date of Birth',
                'drag_item': 'Drag item to reorder',
                'dropzone_msg': 'Drop files here to upload (or click)',
                'duration': 'Duration',
                'duration_type': 'Duration Type',
                'edit': 'Edit',
                'edit_record': 'Edit Record',
                'email': 'Email',
                'end': 'End',
                'enter_amount': 'Amount ($)',
                'enter_end_time': 'Enter End Date',
                'enter_length_time': 'Enter Length of Time',
                'enter_start_time': 'Enter Start Date',
                'enter_total': 'Enter Total',
                'enter_version': 'Version (Format: 0.0)',
                'error_occurred': 'Error Occurred',
                'error_wrong_user': 'Wrong username or password',
                'error_username_empty': 'Username field was empty.',
                'error_password_empty': 'Password field was empty.',
                'event': 'Event',
                'event_info': 'Event Information',
                'event_type': 'Event Type',
                'events': 'Events',
                'expires': 'Expires On',
                'featured_image': 'Featured Image',
                'fee': 'Fee',
                'finish': 'Finish',
                'first_name': 'First Name',
                'fixed_release': 'Fixed in Release',
                'found_release': 'Found in Release',
                'format': 'Format',
                'from': 'From',
                'gallery': 'Gallery',
                'grand_total': 'Grand Total',
                'gross_amount': 'Gross Amount',
                'held_on': 'Held On',
                'history': 'History',
                'image': 'Image',
                'installation': 'Installation',
                'installments': 'Installments',
                'inventory': 'Inventory',
                'invoice': 'Invoice',
                'invoices': 'Invoices',
                'job': 'Job',
                'last_name': 'Last Name',
                'lead': 'Lead',
                'location': 'Location',
                'login': 'Login',
                'meeting_date_time': 'Meeting Date/Duration',
                'media': 'Media',
                'members_list': 'Members List',
                'middle_name': 'Middle Name',
                'mission': 'Mission',
                'missions': 'Missions',
                'mission_type': 'Mission Type',
                'name': 'Name',
                'new': 'New',
                'next': 'Next',
                'no': 'No',
                'no_address_supplied': 'No Address Supplied',
                'no_data_found_add_new': 'No data found. To add a new item, type in its value above.',
                'none': 'None',
                'not_assigned': 'Not Assigned',
                'not_selected': 'Not Selected',
                'not_set': 'Not Set',
                'note': 'Note',
                'occurs': 'Occurs',
                'of': 'of',
                'one_time': 'One-Time',
                'one_time_fee': 'One-Time Fee',
                'option': 'Option',
                'order': 'Order',
                'os': 'Operating System',
                'parent': 'Parent',
                'parent_project': 'Parent Project',
                'parent_profession': 'Parent Profession',
                'password': 'Password',
                'password_confirm': 'Confirm Password',
                'pay_by': 'Pay By',
                'pay_rate': 'Pay Rate',
                'payment': 'Payment',
                'payments': 'Payments',
                'payment_details': 'Payment Details',
                'payment_received': 'Payment Received',
                'payment_status': 'Payment Status',
                'payment_type': 'Payment Type',
                'percent_complete': 'Percent Complete %',
                'personal_info': 'Personal Info',
                'people_involved': 'People Involved',
                'phone_fax': 'Fax',
                'phone_mobile': 'Mobile Phone',
                'phone_work': 'Work Phone',
                'post': 'Post',
                'posts': 'Posts',
                'posted_to': 'Posted To',
                'previous': 'Previous',
                'price': 'Price',
                'price_sales': 'Sale',
                'pricing': 'Pricing',
                'priority': 'Priority',
                'product': 'Product',
                'product_release': 'Product for Release',
                'profession': 'Profession',
                'professional': 'Professional',
                'professionals': 'Professionals',
                'progress': 'Progress',
                'project': 'Project',
                'projects': 'Projects',
                'project_title': 'Project Title',
                'proposal': 'Proposal',
                'property': 'Property',
                'publish': 'Publish',
                'qty': 'Qty',
                'quantity': 'Quantity',
                'rate_type': 'Rate Type',
                'rating': 'Rating',
                'ready_to_invoice': 'Ready to Invoice',
                'record': 'record',
                'received': 'Received',
                'received_on': 'Received On',
                'receiver': 'Receiver',
                'recurrence_type': 'Recurrence Type',
                'referred_by': 'Referral Source',
                'register': 'Register',
                'release_details': 'Release Details',
                'release_notes': 'Release Notes',
                'releases': 'Releases',
                'remove': 'Remove',
                'reoccurs': 'Reoccurs',
                'reproducibility': 'Reproducibility',
                'resolution': 'Resolution',
                'resource': 'Resource',
                'resources': 'Resources',
                'responsible': 'Responsible',
                'responsibilities': 'Responsibilities',
                'retainer': 'Retainer',
                'retainers': 'Retainers',
                'sales_person': 'Sales Person',
                'sales_price': 'Sales Price',
                'salutation': 'Salutation',
                'select': 'Select',
                'select_assignee': 'Select Assignee',
                'select_categories': 'Select Categories',
                'select_client': 'Select Client',
                'select_company': 'Select Company',
                'select_country': 'Select Country',
                'select_deliverable': 'Select Deliverable',
                'select_duration': 'Select Duration',
                'select_event_type': 'Select Event Type',
                'select_merchant_type': 'Select Merchant Type',
                'select_mission': 'Select Mission',
                'select_order': 'Select Order',
                'select_payment_type': 'Select Payment Type',
                'select_priority': 'Select Priority',
                'select_profession': 'Select Profession',
                'select_professional': 'Select Responsible Professional',
                'select_project': 'Select Project',
                'select_rate': 'Select Rate',
                'select_rate_type': 'Select Rate Type',
                'select_receiver': 'Select Receiver',
                'select_recurrence_type': 'Select Recurrence Type',
                'select_reproducibility': 'Select Reproducibility',
                'select_responsible_company': 'Select Responsible Company',
                'select_mission_type': 'Select Mission Type',
                'select_severity': 'Select Severity',
                'select_sprint': 'Select Sprint',
                'select_state': 'Select State',
                'select_statement': 'Select Statement',
                'select_status': 'Select Status',
                'select_subscription_type': 'Select Subscription Type',
                'select_time_zone': 'Select Time Zone',
                'select_type': 'Select Type',
                'select_user': 'Select User',
                'select_venue_type': 'Select Venue Type',
                'select_workflow': 'Select Workflow',
                'select_work_around': 'Select Workaround',
                'sent': 'Sent',
                'severity': 'Severity',
                'shared_responsibility': 'Shared Responsibility',
                'short': 'Short',
                'sku': 'SKU',
                'slug': 'URL Slug',
                'social': 'Social',
                'social_info': 'Social Info',
                'social_media_acct': 'Social Media Accounts',
                'social_media': 'Social Media',
                'social_networks': 'Social Networks',
                'source': 'Source',
                'specifications': 'Specifications',
                'sprint': 'Sprint',
                'sprint_goal': 'Sprint Goal',
                'start': 'Start',
                'start_over': 'Start Over',
                'state': 'State',
                'statement': 'Statement',
                'statement_no': 'Statement #',
                'status': 'Status',
                'steps_reproduce': 'Steps to Reproduce',
                'stock': 'Stock',
                'subscription': 'Subscription',
                'submitted_by': 'Submitted By',
                'success_signin': 'You have successfully signed in.',
                'tags': 'Tags',
                'tax': 'Tax',
                'tax_excluded': 'Exclude Tax',
                'tickets': 'Tickets',
                'time_zone': 'Time Zone',
                'title': 'Title',
                'to': 'To',
                'total': 'Total',
                'total_amount': 'Total Amount',
                'total_hours': 'Total Hours',
                'total_pay': 'Total Pay',
                'total_invoices': 'Total Invoices',
                'transaction_num': 'Transaction #',
                'type': 'Type',
                'type_issue': 'Type of Issue',
                'unit_price': 'Unit Price',
                'unknown': 'Unknown',
                'url': 'URL',
                'username': 'Username',
                'user': 'User',
                'values': 'Values',
                'variation': 'Variation',
                'variable_item': 'Variable Item',
                'venue': 'Venue',
                'version': 'Version',
                'website': 'Website',
                'week': 'Week',
                'welcome': 'Welcome',
                'work_workflow': 'Work Workflow',
                'work_around': 'Work Around',
                'work_details': 'Work Details',
                'work_highlights': 'Work Highlights',
                'yes': 'Yes'
            },
            'numbers': {
                'one': '1',
                'two': '2',
                'three': '3',
                'four': '4',
                'five': '5',
                'six': '6',
                'seven': '7',
                'eight': '8',
                'nine': '9'
            },
            'sentences': {
                'confirm': {
                    'title': 'Confirmation Required',
                    'add': 'Are you sure you want to add ',
                    'delete': 'Are you sure you want to delete ',
                    'logout': 'Are you sure you want to logout?'
                },
                'generated_invoice': 'This is a computer generated invoice. No signature required.',
                'generated_proposal': 'This is a computer generated proposal. No signature required.',
                'loading_data_wait': 'Loading Data, Please Wait...',
                'loading_wait': 'Loading, Please Wait...',
                'login': 'Logging In, Please Wait...',
                'logout': 'Thank you, Logging out...',
                'no_activities': 'No Activity Logged',
                'no_comments': 'No Comments Found',
                'no_commits': 'No Commits Found',
                'no_records': 'No Records Found',
                'outdated_browser': 'You are using an <strong>outdated</strong> browser. Please <a href=\'http://browsehappy.com/\">upgrade your browser</a> to improve your experience.',
                'please_provide': 'Please provide your ',
                'register': 'Registering Account, Please Wait...',
                'register_property': 'Creating Property, Please Wait...',
                'query': 'Enter your query...',
                'update_property': 'Updating Property, Please Wait...'
            },
            'pages': {
                'error': {
                    'title': '404',
                    'page_not_found': 'Sorry, the page you\'re looking not found?',
                    'try_search': 'Try the search bar below.',
                    'type_keywords': 'Type Keywords'
                },
                'forgot_pass': {
                    'reset': 'Reset',
                    'instructions': 'Enter your email address you\'ve registered with you. We\'ll send you reset link to that address.',
                    'enter_email': 'Enter email address'
                },
                'install': {
                    'install_for': 'Installation wizard for the ',
                    'install_wizard': 'Install <strong>Wizard</strong>',
                    'your_details': 'Your Details',
                    'dbase_info': 'Database Information',
                    'username_info': 'Username can contain any letters or numbers, without spaces',
                    'password_info': 'Please provide a password',
                    'password_confirm_info': 'Please confirm your password',
                    'dbhost_info': 'The host name where the software will be installed.',
                    'dbname_info': 'Please provide the database name',
                    'dbuser_info': 'Username can contain any letters or numbers, without spaces',
                    'dbpass_info': 'Please provide database password',
                    'dbase_install': 'Database Installation',
                    'dbase_wait': 'Installing database...please wait.',
                    'account_create': 'Account Creation',
                    'account_create_admin': 'Creating admin account...please wait.',
                    'complete': 'Installation Complete!',
                    'complete_info': 'Your database has been setup and user account created. Please proceed to the next page for login credentials.',
                    'account_info': 'Your account information is below:'
                },
                'lock_screen': {
                    'enter_pass': 'Enter password'
                },
                'login': {
                    'sign_in': 'Sign in to your account',
                    'forget_pass': 'Forget your password?',
                    'remember_me': 'Remember me',
                    'no_account': 'Don\'t have an account?',
                    'register': 'Register Now'
                },
                'register': {
                    'sign_in': 'Sign in Now.',
                    'register_now': 'Register Now',
                    'i_agree': 'I agree to the ',
                    'terms': 'terms and conditions'
                },
                'empty': {
                    'users': {
                        'icon': 'glyphicons glyphicons-parents',
                        'import': 'Import Contacts',
                        'create': 'Create Contact',
                        'title': 'Adding New Contacts',
                        'instructions': 'Contacts are defined as all the people that contribute to the success and wellness of your company. You can add anyone from your clients and/or employees to your personal assistant and/or vendors.<p>Create contacts manually or begin by importing contacts from an existing database.</p>'
                    },
                    'contracts': {
                        'icon': 'glyphicons glyphicons-handshake',
                        'import': 'Import Contracts',
                        'create': 'Create Contract',
                        'title': 'Adding New Contracts',
                        'instructions': 'Contracts are agreements between parties which require signatures from both parties in order to be legally binding. The Professional integrates with Adobe EchoSign for all contract agreements.<p>Create contracts manually or begin by importing contracts from an existing database.</p>'
                    },
                    'email': {
                        'icon': 'glyphicons glyphicons-send',
                        'import': 'Connect Account',
                        'create': 'View Accounts',
                        'title': 'Connecting Email Accounts',
                        'instructions': 'When you add your email accounts such as Yahoo Mail or Gmail to The Professional, you can send and read email messages from those accounts without switching between email apps. Each email account you add to The Professional is called a connected account.<p>You can currently connect almost any email account including the following:</p><p class="h3 text-primary text-center"><i class="mr10 social social-google-plus"></i><i class="mr10 social social-yahoo"></i><i class="mr10 social social-apple"></i><i class="mr10 social social-windows"></i>'
                    },
                    'companies': {
                        'icon': 'glyphicons glyphicons-building',
                        'import': 'Import Companies',
                        'create': 'Create Company',
                        'title': 'Adding New Companies',
                        'instructions': 'Companies are defined as institutions that you own/work for or institutions that are owned/worked for by your clients or other associates. Its best to always associate your contacts to a company even if they are sole proprietorships.<p>Create companies manually or begin by importing companies from an existing database.</p>'
                    },
                    'deliverables': {
                        'icon': 'fa fa-truck',
                        'import': 'Import Deliverables',
                        'create': 'Create Deliverable',
                        'title': 'Adding New Deliverables',
                        'instructions': 'Deliverables are defined as the products and/or services that you sell to your clients and customers.<p>Create deliverables manually or begin by importing deliverables from an existing database.</p>'
                    },
                    'discounts': {
                        'icon': 'glyphicons glyphicons-sampler',
                        'import': 'Import Discounts',
                        'create': 'Create Discount',
                        'title': 'Adding New Discounts',
                        'instructions': 'Discounts are amounts or percentages deducted from the normal selling price of items. Discounts can be applied to deliverables, project missions and orders. Discounts can also be given to specific users and/or user types.<p>Create discounts manually or begin by importing discounts from an existing database.</p>'
                    },
                    'events': {
                        'icon': 'glyphicons glyphicons-calendar',
                        'import': 'Import Events',
                        'create': 'Create Event',
                        'title': 'Adding New Events',
                        'instructions': 'Events are defined as scheduled appointments in which individuals assemble to discuss agendas. Events can be externally created by clients or internally created by team or staff.<p>Events are currently integrated with the following calendars:</p><p class="h3 text-primary text-center"><i class="mr10 social social-google-plus"></i><i class="mr10 social social-apple"></i></p><p>Create events manually or begin by importing events from an existing database.</p>'
                    },
                    'invoices': {
                        'icon': 'glyphicons glyphicons-invoice',
                        'import': 'Import Invoices',
                        'create': 'Create Invoice',
                        'title': 'Adding New Invoices',
                        'instructions': 'Invoices are defined as statements of work performed by your company for your clients. When creating an invoice, line items can include deliverables and/or project responsibilities.<p>Create invoices manually or begin by importing invoices from an existing Professional database.</p>'
                    },
                    'media': {
                        'icon': 'fa fa-images',
                        'import': 'Import Media',
                        'create': 'Create Media',
                        'title': 'Adding New Media',
                        'instructions': 'Media is used to manage user uploads (images, audio, video, and other files).<p>Create media manually or begin by importing media from an existing database.</p>'
                    },
                    'payments': {
                        'icon': 'glyphicons glyphicons-fees-payments',
                        'import': 'Import Payments',
                        'create': 'Capture Payment',
                        'title': 'Capturing New Payments',
                        'instructions': 'Payments are defined fees captured after an invoice has been paid. Payments can be captured automatically by integrating with popular payment processors.<p>The following payment processors are accepted:</p><p class="h3 text-primary text-center"><i class="mr10 social social-paypal2"></i><i class="mr10 social social-square"></i><i class="mr10 social social-stripe"></i><i class="mr10 social social-authorize"></i></p><p>Payments can be captured manually, automatically or imported from an existing database.</p>'
                    },
                    'posts': {
                        'icon': 'glyphicons glyphicons-bullhorn',
                        'import': 'Import Posts',
                        'create': 'Create Post',
                        'title': 'Adding New Posts',
                        'instructions': 'Posts are defined as written articles posted to blogs or social networks. You can opt to use The Professional as your blog or you can connect to an exiting blog or social network.<p>The following blogs and social networks are accepted:</p><p class="h3 text-primary text-center"><i class="mr10 social social-wordpress"></i><i class="mr10 social social-facebook"></i><i class="mr10 social social-twitter"></i><i class="mr10 social social-linked-in"></i><i class="mr10 social social-instagram"></i><i class="mr10 social social-google-plus"></i><i class="mr10 social social-youtube"></i></p><p>Create posts manually or begin by importing posts from an existing database.</p>'
                    },
                    'products': {
                        'icon': 'glyphicons glyphicons-package',
                        'import': 'Import Products',
                        'create': 'Create Product',
                        'title': 'Adding New Products',
                        'instructions': 'Products are defined as items created after a project is completed. Products are tangible items like software and possibly even buildings.<p>Product updates can be tracked with the following source code repositories:</p><p class="h3 text-primary text-center"><i class="mr10 social social-github"></i><i class="mr10 social social-bitbucket"></i></p><p>Create products manually or begin by importing products from an existing database.</p>'
                    },
                    'professions': {
                        'icon': 'fa fa-graduation-cap',
                        'import': 'Import Professions',
                        'create': 'Create Profession',
                        'title': 'Adding New Professions',
                        'instructions': 'Professions are defined as a paid occupation, especially one that involves prolonged training and a formal qualification.<p>Create professions manually or begin by importing professions from an existing database.</p>'
                    },
                    'properties': {
                        'icon': 'glyphicons glyphicons-home',
                        'import': 'Import Properties',
                        'create': 'Create Property',
                        'title': 'Adding New Properties',
                        'instructions': 'Properties are defined as scheduled real-estate listings in which individuals can book time for various purposes. Properties can be externally created by clients or internally created by team or staff.<p>Properties are currently integrated with the following calendars:</p><p class="h3 text-primary text-center"><i class="mr10 social social-google-plus"></i><i class="mr10 social social-apple"></i></p><p>Create properties manually or begin by importing properties from an existing database.</p>'
                    },
                    'responsibilities': {
                        'icon': 'fa fa-accusoft',
                        'import': 'Import Responsibilities',
                        'create': 'Create Responsibility',
                        'title': 'Adding New Responsibilities',
                        'instructions': 'Responsibilities are the basic duties of qualified professionals.<p>Create responsibilities manually or begin by importing responsibilities from an existing database.</p>'
                    },
                    'projects': {
                        'icon': 'glyphicons glyphicons-briefcase',
                        'import': 'Import Projects',
                        'create': 'Create Project',
                        'title': 'Adding New Projects',
                        'instructions': 'Projects are defined as units of work by a team or individual to create a desired product for a client.<p>There are three types of projects, sequential, parallel and single action: <p>A <strong>sequential project</strong> is one whose actions must be performed in a certain order. The bake a cake project is a sequential project; you can\'t bake the cake before you buy the ingredients and you can\'t buy the ingredients before you find a recipe.</p><p>A <strong>parallel project</strong> is a project whose actions can be completed in any order. For example, a pay bills project whose actions are pay rent, pay cell phone bill, pay water bill, etc. This project would be considered parallel because it doesn\'t matter what order you pay your bills in; it just matters that they all are completed.</p><p>A <strong>single action list</strong> is a special kind of project that usually consists of projects with only one step to complete or an assortment of related actions (like, buy groceries). Often times, it is helpful to create a miscellaneous project to keep things organized.</p><p>Create products manually or begin by importing products from an existing database.</p>'
                    },
                    'proposals': {
                        'icon': 'glyphicons glyphicons-calculator',
                        'import': 'Import Proposals',
                        'create': 'Create Proposal',
                        'title': 'Adding New Proposals',
                        'instructions': 'Proposals are defined as statements of work to be performed by your company for your clients. When creating a proposal, line items can include deliverables and/or project responsibilities.<p>Create proposals manually or begin by importing proposals from an existing Professional database.</p>'
                    },
                    'releases': {
                        'icon': 'glyphicons glyphicons-sound-7-1',
                        'import': 'Import Releases',
                        'create': 'Create Release',
                        'title': 'Adding New Releases',
                        'instructions': 'Releases are defined as revisions or project products. A product can have multiple releases. Releases for a product can be active or inactive.<p>Create releases manually or begin by importing releases from an existing database.</p>'
                    },
                    'resources': {
                        'icon': 'glyphicons glyphicons-mixed-buildings',
                        'import': 'Import Resource',
                        'create': 'Create Resource',
                        'create_company': 'Company Resource',
                        'create_user': 'User Resource',
                        'title': 'Adding New Project Resource',
                        'instructions': 'Project Resources are defined as a <strong>person</strong> or <strong>company</strong> with materials, money, staff, information and any other assets necessary for effective operation of a <strong>project</strong>.<p>Create resources manually or begin by importing resources from an existing database.</p>'
                    },
                    'missions': {
                        'icon': 'glyphicons glyphicons-target',
                        'import': 'Import Missions',
                        'create': 'Create Mission',
                        'title': 'Adding New Missions',
                        'instructions': 'Missions are defined as a list of project goals. For example, one mission of a new website project is to \'Design the Website\'. Work items are added to fulfill the obligation of the mission.<p>Create missions manually or begin by importing missions from an existing database.</p>'
                    },
                    'sprints': {
                        'icon': 'glyphicons glyphicons-person-running',
                        'import': 'Import Sprints',
                        'create': 'Create Sprint',
                        'title': 'Adding New Sprints',
                        'instructions': 'Sprints are defined as repeatable work cycles in which approved work items are completed and reviewed. Each project should have sprints or work cycles for delivery of project products. For example, an interior design project may include a sprint where the designer creates a design preview that must be approved by the client before proceeding to the next sprint or work cycle <p>Create sprints manually or begin by importing sprints from an existing database.</p>'
                    },
                    'submissions': {
                        'icon': 'glyphicons glyphicons-inbox-in',
                        'import': 'Import Submissions',
                        'create': 'Create Submission',
                        'title': 'Adding New Submissions',
                        'instructions': 'Submissions are defined as requests for additional information or work submitted by clients. An example of a submission, include consultation or contact forms. Submissions are captured automatically on your Professional site but they can also be added manually if capturing over the phone or in person.<p>Create submissions manually or begin by importing submissions from an existing database.</p>'
                    },
                    'timecards': {
                        'icon': 'glyphicons glyphicons-history',
                        'import': 'Import Timecards',
                        'create': 'Create Timecard',
                        'title': 'Adding New Timecards',
                        'instructions': 'Timecards are defined as logs used to report starting and quiting times for staff or contractors.<p>Create timecards manually or begin by importing timecards from an existing database.</p>'
                    },
                    'work': {
                        'icon': 'glyphicons glyphicons-settings',
                        'import': 'Import Work',
                        'create': 'Create Work',
                        'title': 'Adding New Work',
                        'instructions': 'Work is defined as task items to be completed to fulfill a mission during a sprint (work cycle).<p>Create work manually or begin by importing work from an existing database.</p>'
                    }
                }
            },
            'objects': {
                'activities': {
                    'title': 'View Activities',
                    'object': 'Activity',
                    'objects': 'Activities',
                    'action': 'View',
                    'type': 'activities',
                    'route': 'activity',
                    'routes': 'activities',
                    'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                },
                'comments': {
                    'title': 'View Comments',
                    'object': 'Comment',
                    'objects': 'Comments',
                    'action': 'View',
                    'type': 'comments',
                    'route': 'comment',
                    'routes': 'comments',
                    'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                },
                'commits': {
                    'title': 'View Commits',
                    'object': 'Commit',
                    'objects': 'Commits',
                    'action': 'View',
                    'type': 'commits',
                    'route': 'commit',
                    'routes': 'commits',
                    'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                },
                'companies': {
                    'all': {
                        'about_company': 'About Company',
                        'company_address': 'Company Address',
                        'company_type': 'Company Type',
                        'pay_rates': 'Pay Rates',
                        'social_accounts': 'Social Accounts',
                        'pay_rate_info': 'How much does this company pay your company for services rendered? If the current company will ever pay your company for services, enter in your company\'s pay rate information for each type of pay.'
                    },
                    'title': 'View Companies',
                    'object': 'Company',
                    'objects': 'Companies',
                    'action': 'View',
                    'type': 'companies',
                    'route': 'company',
                    'routes': 'companies',
                    'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                },
                'contracts': {
                    'title': 'View Contracts',
                    'object': 'Contract',
                    'objects': 'Contracts',
                    'action': 'View',
                    'type': 'contracts',
                    'route': 'contract',
                    'routes': 'contracts',
                    'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                },
                'dashboard': {
                    'title': 'View Dashboard',
                    'object': 'Dashboard',
                    'objects': 'Dashboards',
                    'action': 'View',
                    'type': 'dashboards',
                    'route': 'dashboard',
                    'routes': 'dashboards',
                    'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                },
                'deliverables': {
                    'all': {
                        'cost_info': 'Enter in the amount that is paid to produce this item for sale. Note, this is not the same as the price of the item.',
                        'deliverable_details': 'Deliverable Details',
                        'inventory': 'Inventory',
                        'is_variation': 'Is Variation?',
                        'is_variation_info': 'Can the deliverable be customized to include different variations?',
                        'is_subscription': 'Is Subscription?',
                        'is_subscription_info': 'Does this deliverable require reoccurring billing?',
                        'stock_info': 'Stock quantity. If this is a variable product this value will be used to control stock for all variations, unless you define stock at variation level.'
                    },
                    'title': 'View Deliverables',
                    'object': 'Deliverable',
                    'objects': 'Deliverables',
                    'action': 'View',
                    'type': 'deliverables',
                    'route': 'deliverable',
                    'routes': 'deliverables',
                    'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>',
                    'instructions_block': {
                        'attributes': '<strong class="text-h4 text-muted">Instructions:</strong> Defining attributes is a way of identifying what makes the item/service unique. For example, one attribute is <em>Color</em> and its attribute values could be "<em>Red, Yellow, Black and Gray</em>".<br><br>Use this section to identify the attributes and values of your deliverable. If variable pricing required, supply it on the <strong>Pricing</strong> tab. Changes made here are reflected on the <strong>Pricing</strong> tab.',
                        'gallery': '<strong class="text-h4 text-muted">Instructions:</strong> Add additional images to display with the item.',
                        'inventory': '<strong class="text-h4 text-muted">Instructions:</strong> If you choose to keep track of inventory for products, supply inventory details here or at the product level if this is a variable product.',
                        'pricing': '<strong class="text-h4 text-muted">Instructions:</strong> Use this section to enter in pricing details for the current deliverable.'
                    },
                    'attributes': 'Attributes',
                    'variations': 'Variations'
                },
                'discounts': {
                    'all': {
                        'amount_off': 'Amount Discount ($)',
                        'coupon_code': 'Discount Code',
                        'coupon_code_place': '50-off',
                        'coupon_description': 'Discount Description',
                        'date_begins': 'Date Discount Begins',
                        'date_ends': 'Date Discount Ends',
                        'discount_details': 'Discount Details',
                        'is_one_time_only': 'Use One-Time Only?',
                        'is_one_time_only_info': 'Does the discount expire after one use?',
                        'number_usages': 'Number of Uses',
                        'percent_off': 'Percent Off (%)'
                    },
                    'title': 'View Discounts',
                    'object': 'Discount',
                    'objects': 'Discounts',
                    'action': 'View',
                    'type': 'discounts',
                    'route': 'discount',
                    'routes': 'discounts',
                    'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                },
                'email': {
                    'title': 'View Email',
                    'object': 'Email',
                    'objects': 'Email',
                    'action': 'View',
                    'type': 'email',
                    'route': 'email',
                    'routes': 'email',
                    'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                },
                'events': {
                    'all': {
                        'event_details': 'Event Details',
                        'client_details': 'Client Details',
                        'venue_address': 'Venue Address',
                        'event_type': 'Event Type',
                        'venue_type': 'Venue Type',
                        'start_time': 'Start Time',
                        'end_time': 'End Time',
                        'user_info': 'Select the attending client, if any. Updating a client\'s information here will update the client\'s information site-wide.'
                    },
                    'title': 'View Events',
                    'object': 'Event',
                    'objects': 'Events',
                    'action': 'View',
                    'type': 'events',
                    'route': 'event',
                    'routes': 'events',
                    'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                },
                'invoices': {
                    'all': {
                        'line_items': 'Line Items',
                        'linked_items': 'Associations',
                        'invoice_details': 'Details',
                        'retainer': 'Retainer',
                        'retainers': 'Retainers',
                        'total_installments': 'Total Installments',
                        'view_retainers': 'View Retainers'
                    },
                    'title': 'View Invoices',
                    'object': 'Invoice',
                    'objects': 'Invoices',
                    'action': 'View',
                    'type': 'invoices',
                    'route': 'invoice',
                    'routes': 'invoices',
                    'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                },
                'media': {
                    'all': {
                        'alternate_text': 'Alterate Text',
                        'media_details': 'Media Details',
                        'media_notes': 'Media Notes'
                    },
                    'title': 'View Media',
                    'object': 'Media',
                    'objects': 'Media',
                    'action': 'View',
                    'type': 'media',
                    'route': 'media',
                    'routes': 'media',
                    'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                },
                'my': {
                    'profile': {
                        'title': 'View My Profile',
                        'object': 'My Profile',
                        'objects': 'My Profiles',
                        'action': 'View',
                        'type': 'my-profiles',
                        'route': 'my-profile',
                        'routes': 'my-profiles',
                        'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                    },
                    'settings': {
                        'title': 'View My Settings',
                        'object': 'My Settings',
                        'objects': 'My Settings',
                        'action': 'View',
                        'type': 'my-settings',
                        'route': 'my-setting',
                        'routes': 'my-settings',
                        'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                    },
                    'timeline': {
                        'title': 'View My Timeline',
                        'object': 'My Timeline',
                        'objects': 'My Timelines',
                        'action': 'View',
                        'type': 'my-timelines',
                        'route': 'my-timeline',
                        'routes': 'my-timelines',
                        'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                    }
                },
                'orders': {
                    'title': 'View Orders',
                    'object': 'Order',
                    'objects': 'Orders',
                    'action': 'View',
                    'type': 'orders',
                    'route': 'order',
                    'routes': 'orders',
                    'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                },
                'payments': {
                    'all': {
                        'payment_details': 'Payment Details',
                        'payment_type': 'Payment Type',
                        'merchant_type': 'Merchant Type',
                        'order_type': 'Order Type',
                        'amount_info': 'If the amount is negative, include a minus sign (-) at the beginning of the amount.',
                        'order_info': 'Payments can be for an order or an invoice only. Once an order ID has been set you will not be able to set a statement ID',
                        'statement_info': 'Payments can be for an order or an invoice only. Once a statement ID has been set you will not be able to set an order ID'
                    },
                    'title': 'View Payments',
                    'object': 'Payment',
                    'objects': 'Payments',
                    'action': 'View',
                    'type': 'payments',
                    'route': 'payment',
                    'routes': 'payments',
                    'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                },
                'posts': {
                    'all':{
                        'post_details': 'Post Details',
                        'tag_info': 'Separate tags with commas',
                        'posted_to': 'Post To Social Networks',
                        'featured_image': 'Featured Image',
                        'click_to_edit': 'Click Image Area to Add/Change Featured Image'
                    },
                    'title': 'View Posts',
                    'object': 'Post',
                    'objects': 'Posts',
                    'action': 'View',
                    'type': 'posts',
                    'route': 'post',
                    'routes': 'posts',
                    'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                },
                'products': {
                    'all': {
                        'product_details': 'Product Details',
                        'product_name': 'Product Name',
                        'product_releases': 'Product Releases',
                        'release_info': 'Existing Product? Add product releases here.'
                    },
                    'title': 'View Products',
                    'object': 'Product',
                    'objects': 'Products',
                    'action': 'View',
                    'type': 'products',
                    'route': 'product',
                    'routes': 'products',
                    'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                },
                'professions': {
                    'all': {
                        'child_professions': 'Child Professions',
                        'parent_profession': 'Parent Profession',
                        'profession_details': 'Profession Details',
                        'responsibilities': 'Profession Responsibilities'
                    },
                    'title': 'View Professions',
                    'object': 'Profession',
                    'objects': 'Professions',
                    'action': 'View',
                    'type': 'professions',
                    'route': 'profession',
                    'routes': 'professions',
                    'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                },
                'properties': {
                    'all': {
                        'event_details': 'Property Details',
                        'client_details': 'User Details',
                        'venue_address': 'Property Address',
                        'event_type': 'Property Type',
                        'venue_type': 'Property Type',
                        'start_time': 'Start Date',
                        'end_time': 'End Date',
                        'user_info': 'Select the attending client, if any. Updating a client\'s information here will update the client\'s information site-wide.'
                    },
                    'title': 'View Properties',
                    'object': 'Property',
                    'objects': 'Properties',
                    'action': 'View',
                    'type': 'properties',
                    'route': 'property',
                    'routes': 'properties',
                    'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                },
                'responsibilities': {
                    'all': {
                        'parent_profession': 'Parent Profession',
                        'responsibility_details': 'Responsibility Details',
                        'responsibilities': 'Profession Responsibilities'
                    },
                    'title': 'View Responsibilities',
                    'object': 'Responsibility',
                    'objects': 'Responsibilities',
                    'action': 'View',
                    'type': 'responsibilities',
                    'route': 'responsibility',
                    'routes': 'responsibilities',
                    'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                },
                'projects': {
                    'all': {
                        'project_details': 'Project Details',
                        'workflow_info': 'Work items follow work flows. Projects can use the default workflow or a new one can be created.',
                        'is_public': 'Is Pubic?',
                        'is_public_info': 'Projects marked public are visible to everyone, including guests.',
                        'prefix_info': 'Work items created under this project need to be identifed with prefixes, ie Ticket #MRJ-1. (Maximum Length: 3)',
                        'slug': 'Project URL Slug',
                        'slug_info': 'Slugs are short strings that identify this project in the browser\'s URL. (Maximum Length: 25)',
                        'work_prefix': 'Work Prefix'
                    },
                    'title': 'View Projects',
                    'object': 'Project',
                    'objects': 'Projects',
                    'action': 'View',
                    'type': 'projects',
                    'route': 'project',
                    'routes': 'projects',
                    'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                },
                'proposals': {
                    'all': {
                        'line_items': 'Line Items',
                        'linked_items': 'Associations',
                        'proposal_details': 'Details'
                    },
                    'title': 'View Proposals',
                    'object': 'Proposal',
                    'objects': 'Proposals',
                    'action': 'View',
                    'type': 'proposals',
                    'route': 'proposal',
                    'routes': 'proposals',
                    'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                },
                'releases': {
                    'all': {
                        'release_details': 'Release Details',
                        'release_notes': 'Release Notes'
                    },
                    'title': 'View Releases',
                    'object': 'Release',
                    'objects': 'Releases',
                    'action': 'View',
                    'type': 'releases',
                    'route': 'release',
                    'routes': 'releases',
                    'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                },
                'resources': {
                    'all': {
                        'about_resource': 'About Resource',
                        'additional_info': 'Additional Info',
                        'company_resource': 'Company Resource',
                        'resource_address': 'Resource Address',
                        'resource_role': 'Resource Role',
                        'resource_details': 'Resource Details',
                        'resource_type': 'Resource Type',
                        'user_resource': 'User Resource'
                    },
                    'title': 'View Resources',
                    'object': 'Resource',
                    'objects': 'Resources',
                    'action': 'View',
                    'type': 'resources',
                    'route': 'resource',
                    'routes': 'resources',
                    'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                },
                'missions': {
                    'all': {
                        'is_ready_to_bill': 'Is Ready to Invoice?',
                        'ready_to_bill_info': 'If a mission is complete and ready to bill, they can be included on generated project invoices.',
                        'invoice_info': 'Invoice Information',
                        'mission_details': 'Mission Details'
                    },
                    'title': 'View Missions',
                    'object': 'Mission',
                    'objects': 'Missions',
                    'action': 'View',
                    'type': 'missions',
                    'route': 'mission',
                    'routes': 'missions',
                    'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                },
                'sprints': {
                    'all': {
                        'goal': 'Sprint Goal',
                        'goal_info': 'A short expression of the purpose of a Sprint, often a business problem that is addressed. Functionality might be adjusted during the Sprint in order to achieve the Sprint Goal.',
                        'is_planning_meeting': 'Planning Meeting Held?',
                        'is_retro_meeting': 'Retrospection Meeting Held?',
                        'is_review_meeting': 'Review Meeting Held?',
                        'planning_meeting_info': 'A time-boxed event of 8 hours, or less, to start a Sprint. It serves for the Scrum Team to inspect the work from the Product Backlog that’s most valuable to be done next and design that work into Sprint backlog.',
                        'retro_meeting_info': 'A time-boxed event of 3 hours, or less, to end a Sprint. It serves for the Scrum Team to inspect the past Sprint and plan for improvements to be enacted during the next Sprint.',
                        'review_meeting_info': 'A time-boxed event of 4 hours, or less, to conclude the development work of a Sprint. It serves for the Scrum Team and the stakeholders to inspect the Increment of product resulting from the Sprint, assess the impact of the work performed on overall progress and update the Product backlog in order to maximize the value of the next period.',
                        'sprint_details': 'Sprint Details',
                        'meeting_details': 'Meeting Details',
                        'select_planning_meeting': 'Select Planning Meeting',
                        'select_review_meeting': 'Select Review Meeting',
                        'select_retro_meeting': 'Select Retro Meeting',
                        'planning_meeting': 'Planning Meeting',
                        'review_meeting': 'Review Meeting',
                        'retro_meeting': 'Retrospection Meeting'
                    },
                    'title': 'View Sprints',
                    'object': 'Sprint',
                    'objects': 'Sprints',
                    'action': 'View',
                    'type': 'sprints',
                    'route': 'sprint',
                    'routes': 'sprints',
                    'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                },
                'submissions': {
                    'title': 'View Submissions',
                    'object': 'Submission',
                    'objects': 'Submissions',
                    'action': 'View',
                    'type': 'submissions',
                    'route': 'submission',
                    'routes': 'submissions',
                    'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                },
                'system': {
                    'title': 'View Settings',
                    'object': 'Setting',
                    'objects': 'Settings',
                    'action': 'View',
                    'type': 'settings',
                    'route': 'setting',
                    'routes': 'settings',
                    'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>',
                    'settings': {
                        'blurb': 'Blurb',
                        'company_code': 'Company Code',
                        'date_format': 'Date Format',
                        'default_country': 'Default Country',
                        'default_page_size': 'Default Page Size',
                        'lang_code': 'Currency Code',
                        'layout_horizontal': 'Horizontal Layout',
                        'left_menu_collapsed': 'Collapse Left Menu',
                        'hours_format': 'Hours Format',
                        'include_numbers': 'Include Numbers in Statement ID?',
                        'include_letters': 'Include Letters in Statement ID?',
                        'max_gen_chars': 'Maximum Number of Generated Chars in Statement ID',
                        'mins_interval': 'Minutes Interval',
                        'seperator': 'Seperator',
                        'show_countries': 'Show Multiple Countries',
                        'sku_autogen_max': 'Max Chars for Auto-generated Prefix',
                        'sku_autogen_type': 'Auto-generated Prefix Type',
                        'sku_category_max': 'Max Chars for Category Prefix',
                        'sku_company_max': 'Max Chars for Company Prefix',
                        'sku_prefix_first': 'First Prefix for SKU',
                        'sku_prefix_second': 'Second Prefix for SKU',
                        'sku_prefix_third': 'Third Prefix for SKU',
                        'sku_prefix_last': 'Last Prefix for SKU',
                        'sku_seperator': 'SKU Seperator',
                        'sku_product_max': 'Max Chars for Product Prefix',
                        'tax': 'Tax',
                        'theme': 'Theme',
                        'time_format': 'Time Format',
                        'work_workflow_id': 'Work Workflow',
                        'worklog_workflow_id': 'Worklog Hours Workflow'
                    }
                },
                'timecards': {
                    'all': {
                        'time_card_week': 'Time Card for Week',
                        'submit_timecard': 'Submit Timecard',
                        'approved_hrs_exceeded': 'Approved Hours Exceeded',
                        'total_hrs_met': 'Approved hours successfully allocated. Would you like to submit the timecard?'
                    },
                    'title': 'View Time Cards',
                    'object': 'Time Card',
                    'objects': 'Time Cards',
                    'action': 'View',
                    'type': 'timecards',
                    'route': 'timecard',
                    'routes': 'timecards',
                    'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                },
                'transfer': {
                    'import': {
                        'title': 'Import Wizard',
                        'object': 'Import',
                        'objects': 'Records',
                        'action': 'View',
                        'type': 'imports',
                        'route': 'import',
                        'routes': 'imports',
                        'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>',
                        'instructions_block': {
                            'one': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>Import <strong>Records</strong>',
                            'two': '<strong class="text-h4 text-muted">Instructions:</strong>Map the imported field to the database fields. Remember that the fields must be of the same type or the import will not be successful.<br><br>Map Database <strong>Fields</strong>',
                            'uploader': 'Export users in your current database to a .CSV file, headers should be on the first line.',
                            'mapping': 'If you do not wish to map this field, do not select an option.',
                            'confirm': 'You can add additional information about these records via the appropriate tab.'
                        },
                        'text': {
                            'step_one': 'Upload',
                            'step_one_ins': 'Upload CSV data',
                            'step_two': 'Match',
                            'step_two_ins': 'Map CSV to Database Fields',
                            'step_three': 'Import',
                            'step_three_ins': 'Validate import',
                            'type_records': 'Type of Records',
                            'text_id': 'Text Identifier',
                            'record_delim': 'Record Delimiter',
                            'select_file': 'Select File',
                            'success_msg': 'records successfully imported.',
                            'fail_msg': 'records NOT successfully imported.',
                            'skipped': 'Records Skipped'
                        }
                    },
                    'export': {
                        'title': 'Export Wizard',
                        'object': 'Export',
                        'objects': 'Records',
                        'action': 'View',
                        'type': 'exports',
                        'route': 'export',
                        'routes': 'exports',
                        'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>',
                        'instructions_block': {
                            'one': '<strong class="text-h4 text-muted">Instructions:</strong>Select tables that you wish to export to continue.<br><br>Export <strong>Records</strong>'
                        },
                        'text': {
                            'step_one': 'Select',
                            'step_one_ins': 'Select Database Tables',
                            'step_two': 'Export',
                            'step_two_ins': 'Validate export',
                            'type_records': 'Type of Records',
                            'text_id': 'Text Identifier',
                            'record_delim': 'Record Delimiter',
                            'select_file': 'Select File',
                            'success_msg': 'records successfully exported.',
                            'fail_msg': 'records NOT successfully exported.',
                            'skipped': 'Records Skipped'
                        }
                    }
                },
                'users': {
                    'all': {
                        'dob_info': 'If possible, capture the users date of birth. On their anniversary, send them a special note or discount as a thank you.',
                        'about_contact': 'About Contact',
                        'contact_address': 'Contact Address',
                        'contact_role': 'Contact Role',
                        'professional_details': 'Professional Details',
                        'pay_rates': 'Pay Rates',
                        'social_accounts': 'Social Accounts',
                        'additional_info': 'Additional Info',
                        'pay_rate_info': 'How much does your company pay this individual for services rendered? If the current user will ever be paid by your company (ie Developers, Contractors), enter in their pay rate information for each type of pay.'
                    },
                    'contacts': {
                        'title': 'View Contacts',
                        'object': 'Contact',
                        'objects': 'Contacts',
                        'action': 'View',
                        'type': 'contacts',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                    },
                    'professionals': {
                        'title': 'View Professionals',
                        'object': 'Professional',
                        'objects': 'Professionals',
                        'action': 'View',
                        'type': 'professionals',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                    },
                    'clients': {
                        'title': 'View Clients',
                        'object': 'Client',
                        'objects': 'Clients',
                        'action': 'View',
                        'type': 'clients',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                    },
                    'colleagues': {
                        'title': 'View Colleagues',
                        'object': 'Colleague',
                        'objects': 'Colleagues',
                        'action': 'View',
                        'type': 'colleagues',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                    },
                    'assistants': {
                        'title': 'View Assistants',
                        'object': 'Assistant',
                        'objects': 'Assistants',
                        'action': 'View',
                        'type': 'assistants',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                    },
                    'resources': {
                        'title': 'View Resources',
                        'object': 'Resource',
                        'objects': 'Resources',
                        'action': 'View',
                        'type': 'resources',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                    },
                    'prospects': {
                        'title': 'View Prospects',
                        'object': 'Prospect',
                        'objects': 'Prospects',
                        'action': 'View',
                        'type': 'prospects',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                    },
                    'vendors': {
                        'title': 'View Vendors',
                        'object': 'Vendor',
                        'objects': 'Vendors',
                        'action': 'View',
                        'type': 'vendors',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                    },
                    'stakeholders': {
                        'title': 'View Stakeholders',
                        'object': 'Stakeholder',
                        'objects': 'Stakeholders',
                        'action': 'View',
                        'type': 'stakeholders',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                    },
                    'developers': {
                        'title': 'View Developers',
                        'object': 'Developer',
                        'objects': 'Developers',
                        'action': 'View',
                        'type': 'developers',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                    },
                    'qas': {
                        'title': 'View Quality Assurance',
                        'object': 'Quality Assurance',
                        'objects': 'Quality Assurance',
                        'action': 'View',
                        'type': 'qas',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                    },
                    'testers': {
                        'title': 'View Testers',
                        'object': 'Tester',
                        'objects': 'Testers',
                        'action': 'View',
                        'type': 'testers',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                    },
                    'pos': {
                        'title': 'View Product Owners',
                        'object': 'Product Owner',
                        'objects': 'Product Owners',
                        'action': 'View',
                        'type': 'pos',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                    },
                    'masters': {
                        'title': 'View Scrum Masters',
                        'object': 'Scrum Master',
                        'objects': 'Scrum Masters',
                        'action': 'View',
                        'type': 'masters',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                    },
                    'managers': {
                        'title': 'View Managers',
                        'object': 'Manager',
                        'objects': 'Managers',
                        'action': 'View',
                        'type': 'managers',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                    },
                    'contractors': {
                        'title': 'View Contractors',
                        'object': 'Contractor',
                        'objects': 'Contractors',
                        'action': 'View',
                        'type': 'contractors',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>'
                    }
                },
                'work': {
                    'all': {
                        'work_details': 'Work Details',
                        'release_details': 'Release Details',
                        'scrum_details': 'Scrum Details',
                        'is_backlogged': 'In Release Backlog?',
                        'is_public': 'Is Pubic?',
                        'is_public_info': 'Public work items will be viewable by all staff and clients. Public products usually have this status, not client/internal ones.',
                        'backlogged_info': 'Is the work item ready to be included in a Sprint?',
                        'time_effort': 'Time & Effort'
                    },
                    'title': 'View Work',
                    'object': 'Work',
                    'objects': 'Work',
                    'action': 'View',
                    'type': 'work',
                    'route': 'work',
                    'routes': 'work',
                    'instructions': '<strong class="text-h4 text-muted">Instructions:</strong> Complete all required fields denoted by <span class="required">*</span>. After required fields are completed, ensure all other pertinent information is included with the record.<br><i class="text-primary glyphicons glyphicons-question-sign mr5"></i><strong>Tip:</strong> When working within limited space, collapse panels to isolate desired sections.<br><br>',
                    'tickets': 'Tickets',
                    'issues': 'Issues'
                }
            },
            fn_no_data_found: function(params){
                return 'No data found. Do you want to add new item - <strong>' + params[0] + '</strong> ?';
            },
            fn_success_message: function(params){
                return params[0] + ' was successful!';
            },
            fn_fail_message: function(params){
                return params[0] + ' <span style="color: red;">WAS NOT</span> successful...</h2>';
            },
            fn_comment_message: function(params){
                return '<strong>' + params[0] + '</strong> posted a ' + (params[1] === 1) ? '<strong>private</strong> ' : '' + ' message</strong>';
            },
            fn_commit_message: function(params){
                return '<strong>' + params[0] + '</strong> committed to <em>' + params[1] + '</em>';
            },
            fn_confirm_action: function(params){
                return 'Are you sure you want to ' + params[0] + ' \'' + params[1] + '\'?';
            },
            fn_show_entries: function(params){
                return 'Showing ' + params[0] + ' to ' + params[1] + ' of ' + params[2] + ' entries';
            },
            fn_search_here: function(params){
                return 'Search ' + params[0] + ' Here...';
            },
            fn_approved_hrs_exceeded_message:  function(params){
                return 'Unable to submit timecard. Total approved hours exceeded by ' + params[0] + ' hour(s)';
            }
        },
        es: {
            'app': {
                'name': 'El Profesional',
                'title': 'El Profesional',
                'title_html': '<span>El</span>&nbsp;Profesional',
                'company': 'Deje Que Un Pro Lo Haga!',
                'copyright': '2018 &copy; <strong>Deje Que Un Pro Lo Haga!</strong>. El Profesional.',
                'description': 'Sistema de gestión de pequeñas empresas todo en uno',
                'blurb': 'Gestión para <strong>Profesionales</strong>'
            },
            'labels': {
                'buttons': {
                    'register': 'Regístrate ahora',
                    'login': 'Iniciar sesión',
                    'upload_continue': 'Cargar y continuar',
                    'validate_send': 'Validar y enviar',
                    'validate_create': 'Validar y crear',
                    'validate_update': 'Validar y actualizar',
                    'delay': 'Por favor espera...',
                    'sign_out': 'Desconectar',
                    'account': 'Cuenta',
                    'profile': 'Ver el perfil',
                    'photo': 'Foto',
                    'add': 'Añadir'
                }
            },
            'nav': {
                'title': 'Navegación',
                'dashboards': {
                    'title': 'Tableros de Instrumentos',
                    'my': 'Mi tablero',
                    'project': 'Proyecto',
                    'financial': 'Financiero',
                    'social': 'Social'
                },
                'account': {
                    'title': 'Cuenta',
                    'management': 'Administración de cuentas',
                    'contacts': 'Contactos',
                    'timecards': 'Tarjetas de tiempo'
                },
                'company': {
                    'title': 'Empresa',
                    'management': 'Administracion de COMPAÑIA',
                    'companies': 'Compañías',
                    'submissions': 'Presentaciones',
                    'email': {
                        'title': 'Email',
                        'inbox': 'Bandeja de entrada',
                        'compose': 'Escribir correo'
                    },
                    'publishing': 'Publicación',
                    'financials': {
                        'title': 'Finanzas',
                        'overview': 'Visión de conjunto',
                        'payroll': 'Nómina de sueldos',
                        'invoices': 'Facturas',
                        'proposals': 'Propuestas'
                    },
                    'deliverables': 'Entregables'
                },
                'crm': {
                    'title': 'CRM',
                    'management': 'Gestión de proyectos',
                    'projects': 'Proyectos',
                    'missions': 'Misiones',
                    'work': 'Trabajo',
                    'sprints': 'Sprints',
                    'events': 'Eventos',
                    'contracts': 'Contratos'
                },
                'system': {
                    'title': 'Sistema',
                    'transfer': {
                        'title': 'Transferencia de datos',
                        'import': 'Datos de importacion',
                        'export': 'Exportar datos'
                    },
                    'settings': 'Configuraciones',
                    'preferences': 'Preferencias',
                    'integrations': 'Integraciones',
                    'updates': 'Actualizaciones',
                    'licensing': 'Licencia'
                },
                'themes': {
                    'title': 'Temas'
                }
            },
            'words': {
                'about': 'Acerca de',
                'about_me': 'Sobre mi',
                'add': 'Añadir',
                'add_line_item': 'Agregar línea de artículo',
                'additional': 'Adicional',
                'additional_info': 'Información Adicional',
                'address': 'Dirección',
                'address1': 'Dirección Línea 1',
                'address2': 'Dirección Línea 2',
                'all_companies': 'Todas las empresas',
                'amount': 'Cantidad',
                'application': 'solicitud',
                'associated': 'Asociado',
                'assigned': 'Asignado',
                'assigned_to': 'Asignado a',
                'attribute': 'Atributo',
                'author': 'Autor',
                'bill_rate': 'Tasa de facturación',
                'browser': 'Navegador',
                'categories': 'Categorías',
                'category': 'Categoría',
                'change': 'Cambio',
                'client': 'Cliente',
                'client_name': 'nombre del cliente',
                'comment': 'Comentario',
                'comment_internal': 'Comentarios internos',
                'comments': 'Comentarios',
                'company': 'Empresa',
                'company_name': 'nombre de empresa',
                'contact_info': 'Datos de contacto',
                'contact': 'Contacto',
                'contacts': 'Contactos',
                'country': 'País',
                'city': 'Ciudad',
                'create': 'Crear',
                'create_username': 'Crear nombre de usuario',
                'custom': 'Personalizado',
                'custom_item': 'Artículo Personalizado',
                'dbhost': 'Nombre de host',
                'dbname': 'Nombre de la base de datos',
                'dbpass': 'Contraseña de base',
                'dbuser': 'Usuario de base',
                'date_completed': 'Fecha de finalización',
                'date_created': 'fecha de creacion',
                'date_due': 'Fecha de vencimiento',
                'date_est_complete': 'Fecha estimada completa',
                'date_expires': 'Fecha caduca',
                'date_generated': 'Fecha generada',
                'date_paid': 'Fecha de pago',
                'date_released': 'Fecha de publicación',
                'date_started': 'Fecha iniciada',
                'date_last_updated': 'Fecha de última actualización',
                'delete': 'Borrar',
                'delete_record': 'Eliminar el registro',
                'deliverable': 'Entregable',
                'details': 'Detalles',
                'description': 'Descripción',
                'dob': 'Fecha de nacimiento',
                'drag_item': 'Arrastrar elemento para reordenar',
                'duration': 'Duración',
                'duration_type': 'Tipo de duración',
                'edit': 'Editar',
                'edit_record': 'Editar registro',
                'email': 'Email',
                'end': 'Fin',
                'enter_amount': 'Monto ($)',
                'enter_end_time': 'Ingrese Hora de finalización',
                'enter_length_time': 'Ingrese la duración del tiempo',
                'enter_start_time': 'Ingrese Hora de inicio',
                'enter_total': 'Ingrese Total',
                'enter_version': 'Versión (Formato: 0.0)',
                'error_occurred': 'Se produjo un error',
                'error_wrong_user': 'Nombre de usuario o contraseña incorrectos',
                'error_username_empty': 'El campo de nombre de usuario estaba vacío.',
                'error_password_empty': 'El campo de contraseña estaba vacío',
                'event': 'Evento',
                'event_info': 'Información del Evento',
                'event_type': 'Tipo de evento',
                'events': 'Eventos',
                'expires': 'Expira el',
                'finish': 'Terminar',
                'first_name': 'Nombre de pila',
                'fixed_release': 'Solucionado en versión',
                'found_release': 'Encontrado en la versión',
                'format': 'Formato',
                'from': 'De',
                'grand_total': 'Gran total',
                'gross_amount': 'Cantidad bruta',
                'held_on': 'Celebrada el',
                'history': 'Historia',
                'installation': 'Instalación',
                'installments': 'Cuotas',
                'invoice': 'Factura',
                'invoices': 'Facturas',
                'job': 'Trabajo',
                'last_name': 'Apellido',
                'lead': 'Dirigir',
                'location': 'Ubicación',
                'login': 'Iniciar sesión',
                'meeting_date_time': 'Fecha / duración de la reunión',
                'members_list': 'Lista de miembros',
                'middle_name': 'Segundo nombre',
                'mission': 'Misión',
                'missions': 'Misiones',
                'mission_type': 'Tipo de misión',
                'name': 'Nombre',
                'new': 'Nuevo',
                'next': 'Siguiente',
                'no': 'No',
                'no_address_supplied': 'Sin Dirección Suministrada',
                'none': 'Ninguna',
                'not_assigned': 'No asignado',
                'not_selected': 'No seleccionado',
                'not_set': 'No establecido',
                'note': 'Nota',
                'occurs': 'Ocurre',
                'of': 'de',
                'one_time_fee': 'Cuota',
                'order': 'Orden',
                'os': 'Sistema operativo',
                'parent': 'Padre',
                'parent_project': 'Proyecto principal',
                'parent_profession': 'Profesión de los padres',
                'password': 'Contraseña',
                'password_confirm': 'Confirmar contraseña',
                'pay_by': 'Pagado por',
                'pay_rate': 'Tarifa de pago',
                'payment': 'Pago',
                'payments': 'Pagos',
                'payment_details': 'Detalles del pago',
                'payment_received': 'Pago recibido',
                'payment_status': 'Estado de pago',
                'payment_type': 'Tipo de pago',
                'percent_complete': 'Porcentaje completo %',
                'personal_info': 'Información personal',
                'people_involved': 'Personas involucradas',
                'phone_fax': 'Fax',
                'phone_mobile': 'Teléfono móvil',
                'phone_work': 'Teléfono de trabajo',
                'post': 'Publicacion',
                'posts': 'Publicaciones',
                'posted_to': 'Publicado para',
                'previous': 'Anterior',
                'price': 'Precio',
                'price_sales': 'Venta',
                'priority': 'Prioridad',
                'product': 'Producto',
                'product_release': 'Producto para versión',
                'profession': 'Profesión',
                'professional': 'Profesional',
                'professionals': 'Profesionales',
                'progress': 'Progreso',
                'project': 'Proyecto',
                'projects': 'Proyectos',
                'project_title': 'Título del Proyecto',
                'proposal': 'Propuesta',
                'publish': 'Publicar',
                'qty': 'Cantidad',
                'quantity': 'Cantidad',
                'rate_type': 'Tipo de cambio',
                'rating': 'Calificación',
                'ready_to_invoice': 'Listo para facturar',
                'record': 'grabar',
                'received': 'Recibido',
                'received_on': 'Recibido en',
                'recurrence_type': 'Tipo de recurrencia',
                'referred_by': 'Fuente de referencia',
                'register': 'Registrarse',
                'release_details': 'Detalles de la versión',
                'release_notes': 'Notas de la versión',
                'releases': 'Lanzamientos',
                'remove': 'Eliminar',
                'reoccurs': 'Vuelve a ocurrir',
                'reproducibility': 'Reproducibilidad',
                'resolution': 'Resolución',
                'resource': 'Recurso',
                'resources': 'Recursos',
                'responsible': 'Responsable',
                'responsibilities': 'Responsabilidades',
                'retainer': 'Retenedor',
                'retainers': 'Retenedores',
                'sales_person': 'Persona de ventas',
                'salutation': 'Saludo',
                'select': 'Seleccionar',
                'select_assignee': 'Seleccionar Asignatario',
                'select_categories': 'Seleccionar Categorías',
                'select_client': 'Seleccionar cliente',
                'select_company': 'Seleccionar empresa',
                'select_country': 'Seleccionar país',
                'select_duration': 'Seleccionar duración',
                'select_event_type': 'Seleccionar tipo de evento',
                'select_merchant_type': 'Seleccionar tipo de comerciante',
                'select_mission': 'Seleccionar misión',
                'select_order': 'Seleccionar pedido',
                'select_payment_type': 'Seleccionar tipo de pago',
                'select_priority': 'Seleccionar prioridad',
                'select_profession': 'Seleccionar profesión',
                'select_professional': 'Seleccione Profesional responsable',
                'select_project': 'Seleccionar proyecto',
                'select_rate': 'Seleccionar tasa',
                'select_rate_type': 'Seleccionar tipo de tarifa',
                'select_recurrence_type': 'Seleccione el tipo de recurrencia',
                'select_reproducibility': 'Seleccione reproducibilidad',
                'select_responsible_company': 'Seleccione la empresa responsable',
                'select_mission_type': 'Seleccionar tipo de misión',
                'select_severity': 'Seleccione la gravedad',
                'select_sprint': 'Seleccionar Sprint',
                'select_state': 'Seleccionar estado',
                'select_statement': 'Seleccionar instrucción',
                'select_status': 'Seleccionar estado',
                'select_time_zone': 'Selecciona la zona horaria',
                'select_type': 'Seleccionar tipo',
                'select_user': 'Seleccionar usuario',
                'select_venue_type': 'Seleccionar tipo de lugar',
                'select_workflow': 'Seleccionar flujo de trabajo',
                'select_work_around': 'Seleccionar solución temporal',
                'sent': 'Enviado',
                'severity': 'Gravedad',
                'shared_responsibility': 'Responsabilidad compartida',
                'sku': 'SKU',
                'slug': 'URL Slug',
                'social': 'Social',
                'social_info': 'Información social',
                'social_media_acct': 'Cuentas de redes sociales',
                'social_media': 'Medios de comunicación social',
                'social_networks': 'Redes Sociales',
                'source': 'Fuente',
                'sprint': 'Sprint',
                'sprint_goal': 'Sprint Gol',
                'start': 'comienzo',
                'start_over': 'Comenzar de nuevo',
                'state': 'Estado',
                'statement': 'Declaración',
                'statement_no': 'Declaración #',
                'status': 'Estado',
                'steps_reproduce': 'Pasos para reproducir',
                'submitted_by': 'Presentado por',
                'success_signin': 'Has iniciado sesión correctamente.',
                'tags': 'Etiquetas',
                'tax': 'Impuesto',
                'tax_excluded': 'Excluir impuestos',
                'tickets': 'Entradas',
                'time_zone': 'Zona horaria',
                'title': 'Título',
                'to': 'A',
                'total': 'Total',
                'total_amount': 'Cantidad total',
                'total_hours': 'Horas totales',
                'total_pay': 'Paga total',
                'total_invoices': 'Total de facturas',
                'transaction_num': 'Número de transacción',
                'type': 'Tipo',
                'type_issue': 'Tipo de problema',
                'unit_price': 'Precio unitario',
                'unknown': 'Desconocido',
                'url': 'URL',
                'username': 'Nombre de usuario',
                'variation': 'Variación',
                'variable_item': 'Artículo variable',
                'venue': 'Lugar',
                'version': 'Versión',
                'website': 'Sitio web',
                'week': 'Semana',
                'welcome': 'Bienvenido',
                'work_workflow': 'Trabajo Flujo de trabajo',
                'work_around': 'trabajar alrededor',
                'work_details': 'Detalles del trabajo',
                'work_highlights': 'Aspectos destacados del trabajo',
                'yes': 'Si'
            },
            'numbers': {
                'one': '1',
                'two': '2',
                'three': '3',
                'four': '4',
                'five': '5',
                'six': '6',
                'seven': '7',
                'eight': '8',
                'nine': '9'
            },
            'sentences': {
                'confirm': {
                    'title': 'Confirmación Requerida',
                    'delete': 'estas seguro que quieres borrarlo',
                    'logout': '¿Estás seguro de que quieres desconectarte?'
                },
                'generated_invoice': 'Esta es una factura generada por computadora. No se requiere firma.',
                'generated_proposal': 'Esta es una propuesta generada por computadora. No se requiere firma.',
                'loading_data_wait': 'Cargando datos, por favor espere...',
                'loading_wait': 'Cargando por favor espere...',
                'login': 'Iniciando sesión, por favor espere ...',
                'logout': 'Gracias, Cerrar sesión ...',
                'no_activities': 'Sin actividad registrada',
                'no_comments': 'No se encontraron comentarios',
                'no_commits': 'No se encontraron errores',
                'no_records': 'No se encontrarón archivos',
                'outdated_browser': 'Está utilizando un navegador <strong>obsoleto</strong>. <a href=\'http://browsehappy.com/\">actualice su navegador</a> para mejorar su experiencia',
                'please_provide': 'Por favor proporcione su',
                'query': 'Ingrese su consulta ...'
            },
            'pages': {
                'error': {
                    'title': '404',
                    'page_not_found': 'Lo sentimos, ¿la página que estás buscando no encontró?',
                    'try_search': 'Pruebe la barra de búsqueda a continuación.',
                    'type_keywords': 'Tipo Palabras clave'
                },
                'forgot_pass': {
                    'reset': 'Reiniciar',
                    'instructions': 'Ingrese su dirección de correo electrónico que haya registrado con usted. Le enviaremos restablecer el enlace a esa dirección.',
                    'enter_email': 'Introducir la dirección de correo electrónico'
                },
                'install': {
                    'install_for': 'Asistente de instalación para el',
                    'install_wizard': 'Instalar <strong>Asistente</strong>',
                    'your_details': 'Tus detalles',
                    'dbase_info': 'Información de base',
                    'username_info': 'El nombre de usuario puede contener letras o números, sin espacios',
                    'password_info': 'Por favor ingrese una contraseña',
                    'password_confirm_info': 'Por favor, confirme su contraseña',
                    'dbhost_info': 'El nombre de host donde se instalará el software.',
                    'dbname_info': 'Proporcione el nombre de la base de datos',
                    'dbuser_info': 'El nombre de usuario puede contener letras o números, sin espacios',
                    'dbpass_info': 'Por favor ingrese la contraseña',
                    'dbase_install': 'Instalación de la base',
                    'dbase_wait': 'Instalando la base de datos ... espere por favor.',
                    'account_create': 'Creación de cuenta',
                    'account_create_admin': 'Creando una cuenta de administrador ... espere.',
                    'complete': '¡Instalación completa!',
                    'complete_info': 'Su base de datos ha sido configurada y se creó una cuenta de usuario. Pase a la página siguiente para las credenciales de inicio de sesión.',
                    'account_info': 'La información de su cuenta está a continuación:'
                },
                'lock_screen': {
                    'enter_pass': 'Introducir la contraseña'
                },
                'login': {
                    'sign_in': 'Iniciar sesión en su cuenta',
                    'forget_pass': '¿Olvidaste tu contraseña?',
                    'remember_me': 'Recuérdame',
                    'no_account': 'No tienes una cuenta?',
                    'register': 'Regístrate ahora'
                },
                'register': {
                    'sign_in': 'Regístrate.',
                    'register_now': 'Regístrate ahora',
                    'i_agree': 'Estoy de acuerdo con la',
                    'terms': 'términos y Condiciones'
                },
                'empty': {
                    'users': {
                        'icon': 'glyphicons glyphicons-parents',
                        'import': 'Importar contactos',
                        'create': 'Crear contacto',
                        'title': 'Agregar nuevos contactos',
                        'instructions': 'Los contactos se definen como todas las personas que contribuyen al éxito y el bienestar de su empresa. Puede agregar a cualquiera de sus clientes y/o empleados a su asistente personal y/o proveedores. <p>Cree contactos manualmente o comience importando contactos de una base de datos existente.</p>'
                    },
                    'contracts': {
                        'icon': 'glyphicons glyphicons-handshake',
                        'import': 'Contratos de importación',
                        'create': 'Crear contrato',
                        'title': 'Agregar nuevos contratos',
                        'instructions': 'Contracts are agreements between parties which require signatures from both parties in order to be legally binding. The Professional integrates with Adobe EchoSign for all contract agreements.<p>Create contracts manually or begin by importing contracts from an existing database.</p>'
                    },
                    'email': {
                        'icon': 'glyphicons glyphicons-send',
                        'import': 'Conectar cuenta',
                        'create': 'Ver cuentas',
                        'title': 'Conexión de cuentas de correo electrónico',
                        'instructions': 'When you add your email accounts such as Yahoo Mail or Gmail to The Professional, you can send and read email messages from those accounts without switching between email apps. Each email account you add to The Professional is called a connected account.<p>You can currently connect almost any email account including the following:</p><p class="h3 text-primary text-center"><i class="mr10 social social-google-plus"></i><i class="mr10 social social-yahoo"></i><i class="mr10 social social-apple"></i><i class="mr10 social social-windows"></i>'
                    },
                    'companies': {
                        'icon': 'glyphicons glyphicons-building',
                        'import': 'Empresas de importación',
                        'create': 'Crear empresa',
                        'title': 'Agregar nuevas compañías',
                        'instructions': 'Companies are defined as institutions that you own/work for or institutions that are owned/worked for by your clients or other associates. Its best to always associate your contacts to a company even if they are sole proprietorships.<p>Create companies manually or begin by importing companies from an existing database.</p>'
                    },
                    'deliverables': {
                        'icon': 'fa fa-truck',
                        'import': 'Importar entregables',
                        'create': 'Crear Deliverable',
                        'title': 'Agregar nuevos entregables',
                        'instructions': 'Deliverables are defined as the products and/or services that you sell to your clients and customers.<p>Create deliverables manually or begin by importing deliverables from an existing database.</p>'
                    },
                    'events': {
                        'icon': 'glyphicons glyphicons-calendar',
                        'import': 'Importar eventos',
                        'create': 'Crear evento',
                        'title': 'Agregar nuevos eventos',
                        'instructions': 'Events are defined as scheduled appointments in which individuals assemble to discuss agendas. Events can be externally created by clients or internally created by team or staff.<p>Events are currently integrated with the following calendars:</p><p class="h3 text-primary text-center"><i class="mr10 social social-google-plus"></i><i class="mr10 social social-apple"></i></p><p>Create events manually or begin by importing events from an existing database.</p>'
                    },
                    'invoices': {
                        'icon': 'glyphicons glyphicons-invoice',
                        'import': 'Facturas de importación',
                        'create': 'Crear factura',
                        'title': 'Agregar nuevas facturas',
                        'instructions': 'Invoices are defined as statements of work performed by your company for your clients. When creating an invoice, line items can include deliverables and/or project responsibilities.<p>Create invoices manually or begin by importing invoices from an existing Professional database.</p>'
                    },
                    'payments': {
                        'icon': 'glyphicons glyphicons-fees-payments',
                        'import': 'Importar pagos',
                        'create': 'Capturar pago',
                        'title': 'Capturando nuevos pagos',
                        'instructions': 'Payments are defined fees captured after an invoice has been paid. Payments can be captured automatically by integrating with popular payment processors.<p>The following payment processors are accepted:</p><p class="h3 text-primary text-center"><i class="mr10 social social-paypal2"></i><i class="mr10 social social-square"></i><i class="mr10 social social-stripe"></i><i class="mr10 social social-authorize"></i></p><p>Payments can be captured manually, automatically or imported from an existing database.</p>'
                    },
                    'posts': {
                        'icon': 'glyphicons glyphicons-bullhorn',
                        'import': 'Publicaciones de importación',
                        'create': 'Crear publicación',
                        'title': 'Agregar publicaciones nuevas',
                        'instructions': 'Posts are defined as written articles posted to blogs or social networks. You can opt to use The Professional as your blog or you can connect to an exiting blog or social network.<p>The following blogs and social networks are accepted:</p><p class="h3 text-primary text-center"><i class="mr10 social social-wordpress"></i><i class="mr10 social social-facebook"></i><i class="mr10 social social-twitter"></i><i class="mr10 social social-linked-in"></i><i class="mr10 social social-instagram"></i><i class="mr10 social social-google-plus"></i><i class="mr10 social social-youtube"></i></p><p>Create posts manually or begin by importing posts from an existing database.</p>'
                    },
                    'products': {
                        'icon': 'glyphicons glyphicons-package',
                        'import': 'Importar productos',
                        'create': 'Crear producto',
                        'title': 'Agregar nuevos productos',
                        'instructions': 'Products are defined as items created after a project is completed. Products are tangible items like software and possibly even buildings.<p>Product updates can be tracked with the following source code repositories:</p><p class="h3 text-primary text-center"><i class="mr10 social social-github"></i><i class="mr10 social social-bitbucket"></i></p><p>Create products manually or begin by importing products from an existing database.</p>'
                    },
                    'professions': {
                        'icon': 'fa fa-graduation-cap',
                        'import': 'Importar profesiones',
                        'create': 'Crear profesión',
                        'title': 'Agregar nuevas profesiones',
                        'instructions': 'Professions are defined as a paid occupation, especially one that involves prolonged training and a formal qualification.<p>Create professions manually or begin by importing professions from an existing database.</p>'
                    },
                    'responsibilities': {
                        'icon': 'fa fa-accusoft',
                        'import': 'Responsabilidades de importación',
                        'create': 'Crear responsabilidad',
                        'title': 'Agregar nuevas responsabilidades',
                        'instructions': 'Responsibilities are the basic duties of qualified professionals.<p>Create responsibilities manually or begin by importing responsibilities from an existing database.</p>'
                    },
                    'projects': {
                        'icon': 'glyphicons glyphicons-briefcase',
                        'import': 'Proyectos de importación',
                        'create': 'Crear proyecto',
                        'title': 'Agregar nuevos proyectos',
                        'instructions': 'Projects are defined as units of work by a team or individual to create a desired product for a client.<p>There are three types of projects, sequential, parallel and single action: <p>A <strong>sequential project</strong> is one whose actions must be performed in a certain order. The bake a cake project is a sequential project; you can\'t bake the cake before you buy the ingredients and you can\'t buy the ingredients before you find a recipe.</p><p>A <strong>parallel project</strong> is a project whose actions can be completed in any order. For example, a pay bills project whose actions are pay rent, pay cell phone bill, pay water bill, etc. This project would be considered parallel because it doesn\'t matter what order you pay your bills in; it just matters that they all are completed.</p><p>A <strong>single action list</strong> is a special kind of project that usually consists of projects with only one step to complete or an assortment of related actions (like, buy groceries). Often times, it is helpful to create a miscellaneous project to keep things organized.</p><p>Create products manually or begin by importing products from an existing database.</p>'
                    },
                    'proposals': {
                        'icon': 'glyphicons glyphicons-calculator',
                        'import': 'Propuestas de importación',
                        'create': 'Crear propuesta',
                        'title': 'Agregar nuevas propuestas',
                        'instructions': 'Proposals are defined as statements of work to be performed by your company for your clients. When creating a proposal, line items can include deliverables and/or project responsibilities.<p>Create proposals manually or begin by importing proposals from an existing Professional database.</p>'
                    },
                    'releases': {
                        'icon': 'glyphicons glyphicons-sound-7-1',
                        'import': 'Import Releases',
                        'create': 'Create Release',
                        'title': 'Adding New Releases',
                        'instructions': 'Releases are defined as revisions or project products. A product can have multiple releases. Releases for a product can be active or inactive.<p>Create releases manually or begin by importing releases from an existing database.</p>'
                    },
                    'resources': {
                        'icon': 'glyphicons glyphicons-mixed-buildings',
                        'import': 'Import Resource',
                        'create': 'Create Resource',
                        'create_company': 'Company Resource',
                        'create_user': 'User Resource',
                        'title': 'Adding New Project Resource',
                        'instructions': 'Project Resources are defined as a <strong>person</strong> or <strong>company</strong> with materials, money, staff, information and any other assets necessary for effective operation of a <strong>project</strong>.<p>Create resources manually or begin by importing resources from an existing database.</p>'
                    },
                    'missions': {
                        'icon': 'glyphicons glyphicons-target',
                        'import': 'Import Missions',
                        'create': 'Create Mission',
                        'title': 'Adding New Missions',
                        'instructions': 'Missions are defined as a list of project goals. For example, one mission of a new website project is to \'Design the Website\'. Work items are added to fulfill the obligation of the mission.<p>Create missions manually or begin by importing missions from an existing database.</p>'
                    },
                    'sprints': {
                        'icon': 'glyphicons glyphicons-person-running',
                        'import': 'Import Sprints',
                        'create': 'Create Sprint',
                        'title': 'Adding New Sprints',
                        'instructions': 'Sprints are defined as repeatable work cycles in which approved work items are completed and reviewed. Each project should have sprints or work cycles for delivery of project products. For example, an interior design project may include a sprint where the designer creates a design preview that must be approved by the client before proceeding to the next sprint or work cycle <p>Create sprints manually or begin by importing sprints from an existing database.</p>'
                    },
                    'submissions': {
                        'icon': 'glyphicons glyphicons-inbox-in',
                        'import': 'Importar presentaciones',
                        'create': 'Crear presentación',
                        'title': 'Agregar nuevas presentaciones',
                        'instructions': 'Submissions are defined as requests for additional information or work submitted by clients. An example of a submission, include consultation or contact forms. Submissions are captured automatically on your Professional site but they can also be added manually if capturing over the phone or in person.<p>Create submissions manually or begin by importing submissions from an existing database.</p>'
                    },
                    'timecards': {
                        'icon': 'glyphicons glyphicons-history',
                        'import': 'Import Timecards',
                        'create': 'Create Timecard',
                        'title': 'Adding New Timecards',
                        'instructions': 'Timecards are defined as logs used to report starting and quiting times for staff or contractors.<p>Create timecards manually or begin by importing timecards from an existing database.</p>'
                    },
                    'work': {
                        'icon': 'glyphicons glyphicons-settings',
                        'import': 'Import Work',
                        'create': 'Create Work',
                        'title': 'Adding New Work',
                        'instructions': 'Work is defined as task items to be completed to fulfill a mission during a sprint (work cycle).<p>Create work manually or begin by importing work from an existing database.</p>'
                    }
                }
            },
            'objects': {
                'activities': {
                    'title': 'Ver Ocupaciones',
                    'object': 'Ocupacion',
                    'objects': 'Ocupaciones',
                    'action': 'Ver',
                    'type': 'activities',
                    'route': 'activity',
                    'routes': 'activities',
                    'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                },
                'comments': {
                    'title': 'Ver comentarios',
                    'object': 'Comentario',
                    'objects': 'Comentarios',
                    'action': 'Ver',
                    'type': 'comments',
                    'route': 'comment',
                    'routes': 'comments',
                    'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                },
                'commits': {
                    'title': 'Ver compromisos',
                    'object': 'Cometer',
                    'objects': 'Compromisos',
                    'action': 'Ver',
                    'type': 'commits',
                    'route': 'commit',
                    'routes': 'commits',
                    'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                },
                'companies': {
                    'all': {
                        'about_company': 'Acerca de la compañía',
                        'company_address': 'Dirección de la empresa',
                        'company_type': 'Tipo de compañía',
                        'pay_rates': 'Tasas de pago',
                        'social_accounts': 'Cuentas sociales',
                        'pay_rate_info': '¿Cuánto paga esta compañía a su compañía por los servicios prestados? Si la empresa actual alguna vez pagará a su compañía por los servicios, ingrese la información de la tasa de pago de su compañía para cada tipo de pago.'
                    },
                    'title': 'Ver empresas',
                    'object': 'Empresa',
                    'objects': 'Compañías',
                    'action': 'Ver',
                    'type': 'companies',
                    'route': 'company',
                    'routes': 'companies',
                    'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                },
                'contracts': {
                    'title': 'Ver contratos',
                    'object': 'Contrato',
                    'objects': 'Contratos',
                    'action': 'Ver',
                    'type': 'contracts',
                    'route': 'contract',
                    'routes': 'contracts',
                    'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                },
                'dashboard': {
                    'title': 'Ver tablero de instrumentos',
                    'object': 'Tablero',
                    'objects': 'Tableros',
                    'action': 'Ver',
                    'type': 'dashboards',
                    'route': 'dashboard',
                    'routes': 'dashboards',
                    'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                },
                'deliverables': {
                    'title': 'Ver entregas',
                    'object': 'Entregable',
                    'objects': 'Entregables',
                    'action': 'Ver',
                    'type': 'deliverables',
                    'route': 'deliverable',
                    'routes': 'deliverables',
                    'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>',
                    'attributes': 'Atributos',
                    'variations': 'Variaciones'
                },
                'email': {
                    'title': 'Ver correo electrónico',
                    'object': 'Email',
                    'objects': 'Email',
                    'action': 'Ver',
                    'type': 'email',
                    'route': 'email',
                    'routes': 'email',
                    'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                },
                'events': {
                    'all': {
                        'event_details': 'Detalles del evento',
                        'client_details': 'Detalles del cliente',
                        'venue_address': 'Dirección del lugar',
                        'event_type': 'Tipo de evento',
                        'venue_type': 'Tipo de lugar',
                        'start_time': 'Hora de inicio',
                        'end_time': 'Hora de finalización',
                        'user_info': 'Seleccione el cliente asistente, si hay alguno. La actualización de la información de un cliente aquí actualizará la información del cliente en todo el sitio.'
                    },
                    'title': 'Ver eventos',
                    'object': 'Evento',
                    'objects': 'Eventos',
                    'action': 'Ver',
                    'type': 'events',
                    'route': 'event',
                    'routes': 'events',
                    'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                },
                'invoices': {
                    'all': {
                        'line_items': 'Artículos de línea',
                        'linked_items': 'Asociaciones',
                        'invoice_details': 'Detalles',
                        'retainer': 'Retenedor',
                        'retainers': 'Retenedores',
                        'total_installments': 'Cuotas totales',
                        'view_retainers': 'Ver Retenedores'
                    },
                    'title': 'Ver facturas',
                    'object': 'Factura',
                    'objects': 'Facturas',
                    'action': 'Ver',
                    'type': 'invoices',
                    'route': 'invoice',
                    'routes': 'invoices',
                    'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                },
                'my': {
                    'profile': {
                        'title': 'Mira mi perfil',
                        'object': 'Mi perfil',
                        'objects': 'Mis perfiles',
                        'action': 'Ver',
                        'type': 'my-profiles',
                        'route': 'my-profile',
                        'routes': 'my-profiles',
                        'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                    },
                    'settings': {
                        'title': 'Ver mi configuración',
                        'object': 'Mi configuración',
                        'objects': 'Mi configuración',
                        'action': 'Ver',
                        'type': 'my-settings',
                        'route': 'my-setting',
                        'routes': 'my-settings',
                        'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                    },
                    'timeline': {
                        'title': 'Ver mi línea de tiempo',
                        'object': 'Mi línea de tiempo',
                        'objects': 'Mis tiempos',
                        'action': 'Ver',
                        'type': 'my-timelines',
                        'route': 'my-timeline',
                        'routes': 'my-timelines',
                        'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                    }
                },
                'orders': {
                    'title': 'Ver pedidos',
                    'object': 'Orden',
                    'objects': 'Pedidos',
                    'action': 'Ver',
                    'type': 'orders',
                    'route': 'order',
                    'routes': 'orders',
                    'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                },
                'payments': {
                    'all': {
                        'payment_details': 'Detalles del pago',
                        'payment_type': 'Tipo de pago',
                        'merchant_type': 'Tipo de comerciante',
                        'order_type': 'Tipo de orden',
                        'amount_info': 'Si la cantidad es negativa, incluya un signo menos (-) al comienzo de la cantidad.',
                        'order_info': 'Los pagos pueden ser solo para un pedido o una factura. Una vez que se haya establecido una ID de pedido, no podrá establecer una ID de declaración',
                        'statement_info': 'Los pagos pueden ser solo para un pedido o una factura. Una vez que se ha establecido una ID de extracto, no podrá establecer una ID de pedido'
                    },
                    'title': 'Ver Pagos',
                    'object': 'Pago',
                    'objects': 'Pagos',
                    'action': 'Ver',
                    'type': 'payments',
                    'route': 'payment',
                    'routes': 'payments',
                    'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                },
                'posts': {
                    'all':{
                        'post_details': 'Detalles de publicación',
                        'tag_info': 'Separa las etiquetas con comas',
                        'posted_to': 'Publicar en redes sociales',
                        'featured_image': 'Imagen destacada',
                        'click_to_edit': 'Haga clic en el área de la imagen para agregar / cambiar la imagen destacada'
                    },
                    'title': 'Ver publicaciones',
                    'object': 'Enviar',
                    'objects': 'Publicaciones',
                    'action': 'Ver',
                    'type': 'posts',
                    'route': 'post',
                    'routes': 'posts',
                    'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                },
                'products': {
                    'all': {
                        'product_details': 'detalles del producto',
                        'product_name': 'Nombre del producto',
                        'product_releases': 'Lanzamientos de productos',
                        'release_info': '¿Producto existente? Agregue lanzamientos de productos aquí.'
                    },
                    'title': 'Ver Productos',
                    'object': 'Producto',
                    'objects': 'Productos',
                    'action': 'Ver',
                    'type': 'products',
                    'route': 'product',
                    'routes': 'products',
                    'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                },
                'professions': {
                    'all': {
                        'child_professions': 'Profesiones infantiles',
                        'parent_profession': 'Profesión de los padres',
                        'profession_details': 'Detalles de la profesión',
                        'responsibilities': 'Responsabilidades de Profesión'
                    },
                    'title': 'Ver profesiones',
                    'object': 'Profesion',
                    'objects': 'Profesiones',
                    'action': 'Ver',
                    'type': 'professions',
                    'route': 'profession',
                    'routes': 'professions',
                    'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                },
                'responsibilities': {
                    'all': {
                        'parent_profession': 'Profesión de los padres',
                        'responsibility_details': 'Detalles de la responsabilidad',
                        'responsibilities': 'Responsabilidades de Profesión'
                    },
                    'title': 'Ver Responsabilidades',
                    'object': 'Responsabilidad',
                    'objects': 'Responsabilidades',
                    'action': 'Ver',
                    'type': 'responsibilities',
                    'route': 'responsibility',
                    'routes': 'responsibilities',
                    'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                },
                'projects': {
                    'all': {
                        'project_details': 'detalles del proyecto',
                        'workflow_info': 'Los elementos de trabajo siguen los flujos de trabajo. Los proyectos pueden usar el flujo de trabajo predeterminado o se puede crear uno nuevo',
                        'is_public': 'Es Público?',
                        'is_public_info': 'Los proyectos marcados como públicos son visibles para todos, incluidos los invitados.',
                        'prefix_info': 'Los elementos de trabajo creados en este proyecto deben identificarse con prefijos, es decir, ticket # MRJ-1. (Longitud máxima: 3)',
                        'slug': 'Proyecto URL Slug',
                        'slug_info': 'Slug son cadenas cortas que identifican este proyecto en la URL del navegador. (Longitud máxima: 25)',				'work_prefix': 'Prefijo de trabajo'
                    },
                    'title': 'Ver proyectos',
                    'object': 'Proyecto',
                    'objects': 'Proyectos',
                    'action': 'Ver',
                    'type': 'projects',
                    'route': 'project',
                    'routes': 'projects',
                    'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                },
                'proposals': {
                    'all': {
                        'line_items': 'Artículos de línea',
                        'linked_items': 'Asociaciones',
                        'proposal_details': 'Detalles'
                    },
                    'title': 'Ver Propuestas',
                    'object': 'Propuesta',
                    'objects': 'Propuestas',
                    'action': 'Ver',
                    'type': 'proposals',
                    'route': 'proposal',
                    'routes': 'proposals',
                    'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                },
                'releases': {
                    'all': {
                        'release_details': 'Detalles de lanzamiento',
                        'release_notes': 'Notas de lanzamiento'
                    },
                    'title': 'Ver Lanzamientos',
                    'object': 'Lanzamiento',
                    'objects': 'Lanzamientos',
                    'action': 'Ver',
                    'type': 'releases',
                    'route': 'release',
                    'routes': 'releases',
                    'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                },
                'resources': {
                    'all': {
                        'about_resource': 'Acerca del recurso',
                        'additional_info': 'Información adicional',
                        'company_resource': 'Recursos de la compañía',
                        'resource_address': 'Dirección del recurso',
                        'resource_role': 'Rol de recursos',
                        'resource_details': 'Detalles del recurso',
                        'resource_type': 'Tipo de recurso',
                        'user_resource': 'Recurso de usuario'
                    },
                    'title': 'Ver Recursos',
                    'object': 'Recurso',
                    'objects': 'Recursos',
                    'action': 'Ver',
                    'type': 'resources',
                    'route': 'resource',
                    'routes': 'resources',
                    'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                },
                'missions': {
                    'all': {
                        'is_ready_to_bill': '¿Está listo para facturar?',
                        'ready_to_bill_info': 'Si una misión está completa y lista para facturar, pueden incluirse en las facturas generadas del proyecto',
                        'invoice_info': 'Información de la factura',
                        'mission_details': 'Detalles de la misión'
                    },
                    'title': 'Ver Misiones',
                    'object': 'Misión',
                    'objects': 'Misiones',
                    'action': 'Ver',
                    'type': 'missions',
                    'route': 'mission',
                    'routes': 'missions',
                    'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                },
                'sprints': {
                    'all': {
                        'goal': 'Objetivo Sprint',
                        'goal_info': 'Una breve expresión del propósito de un Sprint, a menudo un problema comercial abordado. La funcionalidad puede ajustarse durante el Sprint para alcanzar el objetivo de Sprint',
                        'is_planning_meeting': '¿Planificación de reunión retenida?',
                        'is_retro_meeting': 'Reunión de retrospección retenida?',                'is_review_meeting': '¿Revisión de la reunión retenida?',
                        'planning_meeting_info': 'Un evento encerrado en el tiempo de 8 horas, o menos, para comenzar un Sprint. Sirve para que el Scrum Team inspeccione el trabajo del Product Backlog que es más valioso que se haga a continuación y diseñe ese trabajo en Sprint backlog . ',
                        'retro_meeting_info': 'Un evento de caja de tiempo de 3 horas, o menos, para finalizar un Sprint. Sirve para que el Scrum Team inspeccione el pasado Sprint y planifique que las mejoras se promulguen durante el próximo Sprint',
                        'review_meeting_info': 'Un evento de caja de tiempo de 4 horas, o menos, para concluir el trabajo de desarrollo de un Sprint. Sirve para que Scrum Team y los interesados ​​inspecten el Incremento del producto resultante del Sprint, evalúen el impacto de el trabajo realizado en el progreso general y actualizar la acumulación de pedidos del Producto para maximizar el valor del próximo período ',
                        'sprint_details': 'Detalles de Sprint',
                        'meeting_details': 'Detalles de la reunión',
                        'select_planning_meeting': 'Seleccionar una reunión de planificación',
                        'select_review_meeting': 'Seleccione Revisión de reunión',
                        'select_retro_meeting': 'Seleccione Reunión Retro',
                        'planning_meeting': 'Reunión de planificación',
                        'review_meeting': 'Reunión de revisión',
                        'retro_meeting': 'Reunión de retrospección'
                    },
                    'title': 'Ver Sprints',
                    'object': 'Sprint',
                    'objects': 'Sprints',
                    'action': 'Ver',
                    'type': 'sprints',
                    'route': 'sprint',
                    'routes': 'sprints',
                    'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                },
                'submissions': {
                    'title': 'Ver Presentaciones',
                    'object': 'Presentacion',
                    'objects': 'Presentaciones',
                    'action': 'Ver',
                    'type': 'submissions',
                    'route': 'submission',
                    'routes': 'submissions',
                    'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                },
                'system': {
                    'title': 'Ver Configuraciones',
                    'object': 'Configuracion',
                    'objects': 'Configuraciones',
                    'action': 'Ver',
                    'type': 'settings',
                    'route': 'setting',
                    'routes': 'settings',
                    'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>',
                    'settings': {
                        'blurb': 'Propaganda',
                        'company_code': 'Código de empresa',
                        'date_format': 'Formato de fecha',
                        'default_country': 'País predeterminado',
                        'default_page_size': 'Tamaño de página predeterminado',
                        'lang_code': 'Código de moneda',
                        'layout_horizontal': 'Diseño horizontal',
                        'left_menu_collapsed': 'Contraer menú izquierdo',
                        'include_numbers': '¿Incluir números en ID de extracto?',
                        'include_letters': '¿Incluir letras en ID de extracto?',
                        'max_gen_chars': 'Número máximo de caracteres generados en la ID del extracto',
                        'seperator': 'Separador',
                        'show_countries': 'Mostrar varios países',
                        'tax': 'Impuesto',
                        'theme': 'Tema',
                        'time_format': 'Formato de hora',
                        'work_workflow_id': 'Trabajo Flujo de trabajo',
                        'worklog_workflow_id': 'Horas de trabajo Flujo de trabajo'
                    }
                },
                'timecards': {
                    'all': {
                        'time_card_week': 'Tarjeta de tiempo por semana',
                        'submit_timecard': 'Enviar tarjeta de tiempo',
                        'approved_hrs_exceeded': 'Horas aprobadas excedidas',
                        'total_hrs_met': 'Horas aprobadas asignadas con éxito. ¿Desea enviar la tarjeta de tiempo?'
                    },
                    'title': 'Ver Tarjetas de tiempo',
                    'object': 'Tarjeta de tiempo',
                    'objects': 'Tarjetas de tiempo',
                    'action': 'Ver',
                    'type': 'timecards',
                    'route': 'timecard',
                    'routes': 'timecards',
                    'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                },
                'transfer': {
                    'import': {
                        'title': 'Asistente de importación',
                        'object': 'Importar',
                        'objects': 'Archivos',
                        'action': 'Ver',
                        'type': 'imports',
                        'route': 'import',
                        'routes': 'imports',
                        'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>',
                        'instructions_block': {
                            'one': '<strong class="text-h4 text-muted">Instrucciones:</strong> todos los archivos .csv deben incluir un encabezado en la primera línea. Se rechazarán todos los demás formatos <br><br>Importar<strong>registros</strong>' ,
                            'two': '<strong class="text-h4 text-muted">Instrucciones:</strong> mapee el campo importado a los campos de la base de datos. Recuerde que los campos deben ser del mismo tipo o la importación no tendrá éxito.<br><br>Map Database <strong>Fields</strong> ',
                            'uploader': 'Exporte usuarios en su base de datos actual a un archivo .CSV, los encabezados deben estar en la primera línea.',
                            'mapping': 'Si no desea asignar este campo, no seleccione una opción.',
                            'confirm': 'Puede agregar información adicional sobre estos registros a través de la pestaña correspondiente.'
                        },
                        'text': {
                            'step_one': 'Subir',
                            'step_one_ins': 'Cargar datos CSV',
                            'step_two': 'Partido',
                            'step_two_ins': 'Asignar CSV a los campos de la base de datos',
                            'step_three': 'Importar',
                            'step_three_ins': 'Validar la importación',
                            'type_records': 'Tipo de registros',
                            'text_id': 'Identificador de texto',
                            'record_delim': 'Delimitador de registros',
                            'select_file': 'Seleccione Archivo',
                            'success_msg': 'registros exitosamente importados',
                            'fail_msg': 'registros NO importados con éxito.',
                            'skipped': 'Registros omitidos'
                        }
                    },
                    'export': {
                        'title': 'Asistente de Exportación',
                        'object': 'Exportar',
                        'objects': 'Archivos',
                        'action': 'Ver',
                        'type': 'exports',
                        'route': 'export',
                        'routes': 'exports',
                        'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>',
                        'instructions_block': {
                            'one': '<strong class="text-h4 text-muted">Instrucciones:</strong> Seleccione las tablas que desea exportar para continuar.<br><br>Exportar <strong>registros</strong>'
                        },
                        'text': {
                            'step_one': 'Seleccionar',
                            'step_one_ins': 'Seleccionar tablas de base de datos',
                            'step_two': 'Exportar',
                            'step_two_ins': 'Validar exportación',
                            'type_records': 'Tipo de registros',
                            'text_id': 'Identificador de texto',
                            'record_delim': 'Delimitador de registros',
                            'select_file': 'Seleccione Archivo',
                            'success_msg': 'registros exitosamente exportados',
                            'fail_msg': 'registros NO exportados con éxito.',
                            'skipped': 'Registros omitidos'
                        }
                    }
                },
                'users': {
                    'all': {
                        'dob_info': 'Si es posible, capture la fecha de nacimiento de los usuarios. En su aniversario, envíeles una nota especial o un descuento como agradecimiento',
                        'about_contact': 'Acerca del contacto',
                        'contact_address': 'dirección de contacto',
                        'contact_role': 'Contacto Rol',
                        'professional_details': 'Detalles Profesionales',
                        'pay_rates': 'Tarifas de pago',
                        'social_accounts': 'Cuentas sociales',
                        'additional_info': 'Información adicional',
                        'pay_rate_info': '¿Cuánto paga su empresa a esta persona por los servicios prestados? Si su empresa le paga alguna vez al usuario actual (es decir, Desarrolladores, Contratistas), ingrese su información de la tasa de pago para cada tipo de pago'
                    },
                    'contacts': {
                        'title': 'Ver contactos',
                        'object': 'Contacto',
                        'objects': 'Contactos',
                        'action': 'Ver',
                        'type': 'contacts',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                    },
                    'professionals': {
                        'title': 'Ver profesionales',
                        'object': 'Profesional',
                        'objects': 'Profesionales',
                        'action': 'Ver',
                        'type': 'professionals',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                    },
                    'clients': {
                        'title': 'Ver clientes',
                        'object': 'Cliente',
                        'objects': 'Clientela',
                        'action': 'Ver',
                        'type': 'clients',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                    },
                    'colleagues': {
                        'title': 'Ver colegas',
                        'object': 'Colega',
                        'objects': 'Colegas',
                        'action': 'Ver',
                        'type': 'colleagues',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                    },
                    'assistants': {
                        'title': 'Ver Asistentes',
                        'object': 'Asistente',
                        'objects': 'Asistentes',
                        'action': 'Ver',
                        'type': 'assistants',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                    },
                    'resources': {
                        'title': 'Ver Recursos',
                        'object': 'Recurso',
                        'objects': 'Recursos',
                        'action': 'Ver',
                        'type': 'resources',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                    },
                    'prospects': {
                        'title': 'Ver las perspectivas',
                        'object': 'Perspectiva',
                        'objects': 'Perspectivas',
                        'action': 'Ver',
                        'type': 'prospects',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                    },
                    'vendors': {
                        'title': 'Ver Vendedores',
                        'object': 'Vendedor',
                        'objects': 'Vendedores',
                        'action': 'Ver',
                        'type': 'vendors',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                    },
                    'stakeholders': {
                        'title': 'View Stakeholders',
                        'object': 'Stakeholder',
                        'objects': 'Stakeholders',
                        'action': 'View',
                        'type': 'stakeholders',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                    },
                    'developers': {
                        'title': 'Ver Desarrolladores',
                        'object': 'Desarrollador',
                        'objects': 'Desarrolladores',
                        'action': 'Ver',
                        'type': 'developers',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                    },
                    'qas': {
                        'title': 'Ver Seguro de calidad',
                        'object': 'Seguro de calidad',
                        'objects': 'Seguro de calidad',
                        'action': 'Ver',
                        'type': 'qas',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                    },
                    'testers': {
                        'title': 'Ver Probadores',
                        'object': 'Probador',
                        'objects': 'Probadores',
                        'action': 'Ver',
                        'type': 'testers',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                    },
                    'pos': {
                        'title': 'View Propietarios de productos',
                        'object': 'Dueño del producto',
                        'objects': 'Propietarios de productos',
                        'action': 'View',
                        'type': 'pos',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                    },
                    'masters': {
                        'title': 'View Scrum Masters',
                        'object': 'Scrum Master',
                        'objects': 'Scrum Masters',
                        'action': 'View',
                        'type': 'masters',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                    },
                    'managers': {
                        'title': 'Ver Gerentes',
                        'object': 'Gerente',
                        'objects': 'Gerentes',
                        'action': 'Ver',
                        'type': 'managers',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                    },
                    'contractors': {
                        'title': 'Ver Contratistas',
                        'object': 'Contratista',
                        'objects': 'Contratistas',
                        'action': 'Ver',
                        'type': 'contractors',
                        'route': 'user',
                        'routes': 'users',
                        'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>'
                    }
                },
                'work': {
                    'all': {
                        'work_details': 'Detalles del trabajo',
                        'release_details': 'Detalles de la versión',
                        'scrum_details': 'Detalles de Scrum',
                        'is_backlogged': 'En Release Backlog?',
                        'is_public': '¿Es público?',
                        'is_public_info': 'Los elementos de trabajo público serán visibles para todo el personal y los clientes. Los productos públicos suelen tener este estado, no los de cliente / interno',
                        'backlogged_info': '¿Está listo el elemento de trabajo para ser incluido en un Sprint?',
                        'time_effort': 'Tiempo y esfuerzo'
                    },
                    'title': 'Ver Trabajo',
                    'object': 'Trabajo',
                    'objects': 'Trabajo',
                    'action': 'Ver',
                    'type': 'work',
                    'route': 'work',
                    'routes': 'work',
                    'instructions': '<strong class="text-h4 text-muted">Instrucciones:</strong> Completar todos los campos obligatorios indicados por <span class="required">*</span>. Después de completar los campos obligatorios, asegúrese de que se incluya toda la información pertinente en el registro.<br><i class="glyphicons de texto primario glyphicons-question-sign mr5"></i><strong>Sugerencia:</strong> Cuando trabaje dentro de un espacio limitado, colapse los paneles para aislar las secciones deseadas.<br><br>',
                    'tickets': 'Entradas',
                    'issues': 'Cuestiones'
                }
            },
            fn_no_data_found: function(params){
                return 'Datos no encontrados. ¿Desea agregar un nuevo elemento <strong>' + params[0] + '</strong>?';
            },
            fn_success_message: function(params){
                return params[0] + ' fue exitoso!';
            },
            fn_fail_message: function(params){
                return params[0] + ' <span style="color: red;">NO FUE</span>exitoso...</h2>';
            },
            fn_comment_message: function(params){
                return '<strong>' + params[0] + '</strong> posted a ' + (params[1] === 1) ? '<strong>privado</strong> ' : '' + ' mensaje</strong>';
            },
            fn_commit_message: function(params){
                return '<strong>' + params[0] + '</strong> comprometido con <em>' + params[1] + '</em>';
            },
            fn_confirm_action: function(params){
                return '¿Seguro que quieres ' + params[0] + ' \'' + params[1] + '\'?';
            },
            fn_show_entries: function(params){
                return 'Mostrando las entradas ' + params[0] + ' a ' + params[1] + ' de ' + params[2] + ' entradas';
            },
            fn_search_here: function(params){
                return 'Buscar ' + params[0] + ' aquí...';
            },
            fn_approved_hrs_exceeded_message:  function(params){
                return 'No se puede enviar la tarjeta de hora. Total de horas aprobadas excedidas en ' + params[0] + ' hora(s)';
            }
        }
    };

    langFactory.$inject = [];
    function langFactory() {
        return lang;
    }
})();

