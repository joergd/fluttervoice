CREATE TABLE `accounts` (
  `id` int(11) NOT NULL auto_increment,
  `subdomain` varchar(30) NOT NULL default '',
  `plan_id` int(11) NOT NULL default '1',
  `effective_date` date NOT NULL,
  `primary_person_id` int(11) NOT NULL default '0',
  `name` varchar(255) NOT NULL default '',
  `address1` varchar(255) NOT NULL default '',
  `address2` varchar(255) NOT NULL default '',
  `city` varchar(255) NOT NULL default '',
  `state` varchar(255) NOT NULL default '',
  `postalcode` varchar(15) NOT NULL default '',
  `country` varchar(255) NOT NULL default '',
  `web` varchar(255) NOT NULL default '',
  `tel` varchar(30) NOT NULL default '',
  `fax` varchar(30) NOT NULL default '',
  `vat_registration` varchar(50) NOT NULL default '',
  `cc_name` varchar(255) default NULL,
  `cc_address1` varchar(255) default NULL,
  `cc_address2` varchar(255) default NULL,
  `cc_postalcode` varchar(15) default NULL,
  `cc_country` varchar(255) default NULL,
  `cc_city` varchar(100) default NULL,
  `cc_issue` varchar(2) default NULL,
  `cc_type` varchar(25) default NULL,
  `currency` varchar(3) default NULL,
  `cc_last_4_digits` varchar(25) default NULL,
  `cc_expiry` datetime default NULL,
  `vp_cross_reference` varchar(50) default NULL,
  `audit_updated_by_person_id` int(11) default NULL,
  `updated_on` datetime default NULL,
  `created_on` datetime default NULL,
  `deleted` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `accounts_subdomain_index` (`subdomain`),
  KEY `accounts_primary_person_id_index` (`primary_person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

CREATE TABLE `audit_accounts` (
  `id` int(11) NOT NULL auto_increment,
  `type` varchar(20) NOT NULL default '',
  `subdomain` varchar(50) NOT NULL default '',
  `email` varchar(100) NOT NULL default '',
  `plan` varchar(30) NOT NULL default '',
  `domain` varchar(3) NOT NULL default '',
  `ip` varchar(20) NOT NULL default '',
  `created_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `audit_logins` (
  `id` int(11) NOT NULL auto_increment,
  `person_id` int(11) default NULL,
  `account_id` int(11) default NULL,
  `subdomain` varchar(50) default NULL,
  `username` varchar(30) default NULL,
  `failed` tinyint(1) NOT NULL default '0',
  `created_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

CREATE TABLE `binaries` (
  `id` int(11) NOT NULL auto_increment,
  `data` blob,
  `filesize` int(11) NOT NULL default '0',
  `updated_on` datetime default NULL,
  `created_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `clients` (
  `id` int(11) NOT NULL auto_increment,
  `account_id` int(11) NOT NULL default '0',
  `name` varchar(255) NOT NULL default '',
  `address1` varchar(255) NOT NULL default '',
  `address2` varchar(255) NOT NULL default '',
  `city` varchar(255) NOT NULL default '',
  `state` varchar(255) NOT NULL default '',
  `postalcode` varchar(15) NOT NULL default '',
  `country` varchar(255) NOT NULL default '',
  `web` varchar(255) NOT NULL default '',
  `tel` varchar(30) NOT NULL default '',
  `fax` varchar(30) NOT NULL default '',
  `vat_registration` varchar(50) NOT NULL default '',
  `audit_created_by_person_id` int(11) default NULL,
  `audit_updated_by_person_id` int(11) default NULL,
  `updated_on` datetime default NULL,
  `created_on` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `clients_account_id_index` (`account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

CREATE TABLE `credit_card_transactions` (
  `id` int(11) NOT NULL auto_increment,
  `type` varchar(50) NOT NULL default '',
  `account_id` int(11) NOT NULL default '0',
  `subdomain` varchar(50) NOT NULL default '',
  `reference` varchar(30) default NULL,
  `cc_name` varchar(100) default NULL,
  `cc_type` varchar(100) default NULL,
  `amount` float default NULL,
  `created_on` datetime default NULL,
  `response` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `cc_email` varchar(255) default NULL,
  `plan_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `currencies` (
  `code` varchar(3) NOT NULL default '',
  `name` varchar(50) NOT NULL default '',
  `symbol` varchar(5) NOT NULL default '',
  `infront` int(3) NOT NULL default '1',
  KEY `currencies_code_index` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `email_logs` (
  `id` int(11) NOT NULL auto_increment,
  `email_type` varchar(30) NOT NULL default '',
  `account_id` int(11) NOT NULL default '0',
  `invoice_id` int(11) NOT NULL default '0',
  `client_id` int(11) NOT NULL default '0',
  `to` varchar(255) NOT NULL default '',
  `from` varchar(255) NOT NULL default '',
  `sent_on` datetime NOT NULL,
  `amount_due` decimal(10,0) default NULL,
  `audit_created_by_person_id` int(11) default NULL,
  `updated_on` datetime default NULL,
  `created_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `images` (
  `id` int(11) NOT NULL auto_increment,
  `account_id` int(11) NOT NULL default '0',
  `binary_id` int(11) NOT NULL default '0',
  `width` int(11) NOT NULL default '0',
  `height` int(11) NOT NULL default '0',
  `content_type` varchar(100) NOT NULL default '',
  `original_filename` varchar(100) NOT NULL default '',
  `original_filesize` int(11) NOT NULL default '0',
  `audit_created_by_person_id` int(11) default '0',
  `audit_updated_by_person_id` int(11) default NULL,
  `updated_on` datetime default NULL,
  `created_on` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `images_account_id_index` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `invoice_line_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `position` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

CREATE TABLE `invoice_lines` (
  `id` int(11) NOT NULL auto_increment,
  `account_id` int(11) NOT NULL default '0',
  `invoice_id` int(11) NOT NULL default '0',
  `invoice_line_type_id` int(11) NOT NULL default '1',
  `price` decimal(10,0) NOT NULL default '0',
  `quantity` decimal(10,0) NOT NULL default '1',
  `description` varchar(255) NOT NULL default '',
  `audit_updated_by_person_id` int(11) default NULL,
  `audit_created_by_person_id` int(11) default NULL,
  `updated_on` datetime default NULL,
  `created_on` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `invoice_lines_invoice_id_index` (`invoice_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

CREATE TABLE `invoice_templates` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL default '',
  `type` varchar(50) NOT NULL default '',
  `preview_filename` varchar(50) default NULL,
  `css_filename` varchar(50) default NULL,
  `updated_on` datetime default NULL,
  `created_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

CREATE TABLE `invoices` (
  `id` int(11) NOT NULL auto_increment,
  `account_id` int(11) NOT NULL default '0',
  `client_id` int(11) NOT NULL default '0',
  `number` varchar(30) NOT NULL default '',
  `po_number` varchar(30) NOT NULL default '',
  `use_tax` tinyint(1) NOT NULL default '1',
  `tax_system` varchar(30) default NULL,
  `tax_percentage` decimal(10,0) NOT NULL default '0',
  `shipping` decimal(10,0) NOT NULL default '0',
  `late_fee_percentage` decimal(10,0) NOT NULL default '0',
  `terms` varchar(30) NOT NULL default '',
  `currency_id` varchar(3) NOT NULL default '',
  `date` date NOT NULL,
  `due_date` date NOT NULL,
  `timezone` varchar(50) NOT NULL default 'Pretoria',
  `status_id` int(11) NOT NULL default '1',
  `subtotal` decimal(10,0) default NULL,
  `paid` float NOT NULL default '0',
  `audit_updated_by_person_id` int(11) default NULL,
  `audit_created_by_person_id` int(11) default NULL,
  `updated_on` datetime default NULL,
  `created_on` datetime default NULL,
  `notes` text NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `invoices_account_id_index` (`account_id`),
  KEY `invoices_client_id_index` (`client_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `payments` (
  `id` int(11) NOT NULL auto_increment,
  `account_id` int(11) NOT NULL default '0',
  `invoice_id` int(11) NOT NULL default '0',
  `amount` decimal(10,0) NOT NULL default '0',
  `means` varchar(30) NOT NULL default '',
  `reference` varchar(30) NOT NULL default '',
  `date` date NOT NULL,
  `audit_updated_by_person_id` int(11) default NULL,
  `audit_created_by_person_id` int(11) default NULL,
  `updated_on` datetime default NULL,
  `created_on` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `payments_invoice_id_index` (`invoice_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `people` (
  `id` int(11) NOT NULL auto_increment,
  `type` varchar(20) NOT NULL default '',
  `account_id` int(11) NOT NULL default '0',
  `client_id` int(11) default NULL,
  `firstname` varchar(50) NOT NULL default '',
  `lastname` varchar(100) NOT NULL default '',
  `email` varchar(255) NOT NULL default '',
  `tel` varchar(30) NOT NULL default '',
  `mobile` varchar(30) NOT NULL default '',
  `username` varchar(30) default NULL,
  `salt` varchar(40) default NULL,
  `salted_password` varchar(40) default NULL,
  `security_token` varchar(40) default NULL,
  `token_expiry` datetime default NULL,
  `audit_updated_by_person_id` int(11) default NULL,
  `audit_created_by_person_id` int(11) default NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `people_account_id_index` (`account_id`),
  KEY `people_client_id_index` (`client_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

CREATE TABLE `plans` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(20) NOT NULL default '',
  `special` tinyint(1) NOT NULL default '0',
  `invoices` int(11) NOT NULL default '0',
  `users` int(11) NOT NULL default '0',
  `clients` int(11) NOT NULL default '0',
  `allow_custom_css` tinyint(1) NOT NULL default '0',
  `unbranded_emails` tinyint(1) NOT NULL default '0',
  `print_css` tinyint(1) NOT NULL default '0',
  `draft_invoices` tinyint(1) NOT NULL default '0',
  `invoice_templates` tinyint(1) NOT NULL default '0',
  `cost_for_za` int(11) NOT NULL default '0',
  `display_cost_for_za` varchar(11) NOT NULL default '',
  `display_currency_cost_for_za` varchar(11) NOT NULL default '',
  `cost_for_com` int(11) NOT NULL default '0',
  `display_cost_for_com` varchar(11) NOT NULL default '',
  `display_currency_cost_for_com` varchar(11) NOT NULL default '',
  `cost_for_uk` int(11) NOT NULL default '0',
  `display_cost_for_uk` varchar(11) NOT NULL default '',
  `display_currency_cost_for_uk` varchar(11) NOT NULL default '',
  `seq` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

CREATE TABLE `preferences` (
  `id` int(11) NOT NULL auto_increment,
  `account_id` int(11) NOT NULL default '0',
  `logo_image_id` int(11) default '0',
  `currency_id` varchar(3) NOT NULL default 'ZAR',
  `timezone` varchar(50) NOT NULL default 'Pretoria',
  `tax_system` varchar(30) default NULL,
  `tax_percentage` decimal(10,0) NOT NULL default '14',
  `terms` varchar(30) NOT NULL default '30 days',
  `invoice_template_id` int(11) NOT NULL default '1',
  `invoice_css` text,
  `thankyou_message` text NOT NULL,
  `reminder_message` text NOT NULL,
  `audit_updated_by_person_id` int(11) default NULL,
  `updated_on` datetime default NULL,
  `created_on` datetime default NULL,
  `invoice_notes` text NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `preferences_account_id_index` (`account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `session_id` varchar(255) default NULL,
  `data` text,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `sessions_session_id_index` (`session_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

CREATE TABLE `status` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

CREATE TABLE `taxes` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(30) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

CREATE TABLE `terms` (
  `id` int(11) NOT NULL auto_increment,
  `description` varchar(100) NOT NULL default '',
  `days` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

INSERT INTO schema_migrations (version) VALUES ('1');

INSERT INTO schema_migrations (version) VALUES ('10');

INSERT INTO schema_migrations (version) VALUES ('2');

INSERT INTO schema_migrations (version) VALUES ('20080612133315');

INSERT INTO schema_migrations (version) VALUES ('20080612141737');

INSERT INTO schema_migrations (version) VALUES ('20080612142154');

INSERT INTO schema_migrations (version) VALUES ('20080612143110');

INSERT INTO schema_migrations (version) VALUES ('20080612143554');

INSERT INTO schema_migrations (version) VALUES ('3');

INSERT INTO schema_migrations (version) VALUES ('4');

INSERT INTO schema_migrations (version) VALUES ('5');

INSERT INTO schema_migrations (version) VALUES ('6');

INSERT INTO schema_migrations (version) VALUES ('7');

INSERT INTO schema_migrations (version) VALUES ('8');

INSERT INTO schema_migrations (version) VALUES ('9');