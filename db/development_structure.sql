CREATE TABLE `accounts` (
  `id` int(11) NOT NULL auto_increment,
  `subdomain` varchar(30) NOT NULL default '',
  `plan_id` int(11) NOT NULL default '1',
  `effective_date` date NOT NULL default '0000-00-00' COMMENT 'when new monthly cycle begins',
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
  `cc_city` varchar(100) default NULL,
  `cc_postalcode` varchar(15) default NULL,
  `cc_country` varchar(255) default NULL,
  `cc_type` varchar(25) default NULL,
  `cc_last_4_digits` varchar(25) default NULL,
  `cc_issue` varchar(2) default NULL,
  `cc_expiry` datetime default NULL,
  `currency` varchar(3) default NULL,
  `vp_cross_reference` varchar(50) default NULL,
  `audit_updated_by_person_id` int(11) default NULL,
  `updated_on` timestamp NULL default NULL,
  `created_on` timestamp NULL default NULL,
  `deleted` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `audit_accounts` (
  `id` int(11) NOT NULL auto_increment,
  `type` varchar(20) NOT NULL default '',
  `subdomain` varchar(50) NOT NULL default '',
  `email` varchar(100) NOT NULL default '',
  `plan` varchar(30) NOT NULL default '',
  `order_number` varchar(30) default NULL,
  `domain` varchar(3) NOT NULL default '',
  `ip` varchar(20) NOT NULL default '',
  `cc_name` varchar(100) default NULL,
  `cc_address1` varchar(100) default NULL,
  `cc_address2` varchar(100) default NULL,
  `cc_city` varchar(100) default NULL,
  `cc_postalcode` varchar(20) default NULL,
  `cc_country` varchar(100) default NULL,
  `cc_type` varchar(100) default NULL,
  `cc_last_4_digits` varchar(4) default NULL,
  `cc_expiry` varchar(5) default NULL,
  `currency` varchar(3) default NULL,
  `amount` float default NULL,
  `created_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `audit_logins` (
  `id` int(11) NOT NULL auto_increment,
  `person_id` int(11) default NULL,
  `account_id` int(11) default NULL,
  `subdomain` varchar(50) default NULL,
  `username` varchar(30) default NULL,
  `failed` tinyint(1) NOT NULL default '0',
  `created_on` timestamp NULL default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `binaries` (
  `id` int(11) NOT NULL auto_increment,
  `data` blob,
  `filesize` int(11) NOT NULL default '0',
  `updated_on` timestamp NULL default NULL,
  `created_on` timestamp NULL default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

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
  `updated_on` timestamp NULL default NULL,
  `created_on` timestamp NULL default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `credit_card_transactions` (
  `id` int(11) NOT NULL auto_increment,
  `type` varchar(50) NOT NULL default '',
  `account_id` int(11) NOT NULL default '0',
  `subdomain` varchar(50) NOT NULL default '',
  `order_number` varchar(30) default NULL,
  `cc_name` varchar(100) default NULL,
  `cc_address1` varchar(100) default NULL,
  `cc_address2` varchar(100) default NULL,
  `cc_city` varchar(100) default NULL,
  `cc_postalcode` varchar(20) default NULL,
  `cc_country` varchar(100) default NULL,
  `cc_type` varchar(100) default NULL,
  `cc_last_4_digits` varchar(4) default NULL,
  `cc_expiry` varchar(5) default NULL,
  `currency` varchar(3) default NULL,
  `amount` float default NULL,
  `vp_cross_reference` varchar(50) default NULL,
  `created_on` datetime default NULL,
  `vp_old_cross_reference` varchar(50) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `currencies` (
  `code` varchar(3) NOT NULL default '',
  `name` varchar(50) NOT NULL default '',
  `symbol` varchar(5) NOT NULL default '',
  `infront` tinyint(3) NOT NULL default '1'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `email_logs` (
  `id` int(11) NOT NULL auto_increment,
  `email_type` varchar(30) NOT NULL default '',
  `account_id` int(11) NOT NULL default '0',
  `invoice_id` int(11) NOT NULL default '0',
  `client_id` int(11) NOT NULL default '0',
  `to` varchar(255) NOT NULL default '' COMMENT 'comma separated emails',
  `from` varchar(255) NOT NULL default '' COMMENT 'email address',
  `sent_on` datetime NOT NULL default '0000-00-00 00:00:00',
  `amount_due` decimal(10,2) default NULL,
  `audit_created_by_person_id` int(11) default NULL,
  `updated_on` timestamp NULL default NULL,
  `created_on` timestamp NULL default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

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
  `updated_on` timestamp NULL default NULL,
  `created_on` timestamp NULL default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `invoice_line_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `position` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `invoice_lines` (
  `id` int(11) NOT NULL auto_increment,
  `account_id` int(11) NOT NULL default '0',
  `invoice_id` int(11) NOT NULL default '0',
  `invoice_line_type_id` int(11) NOT NULL default '0',
  `price` decimal(10,2) NOT NULL default '0.00',
  `quantity` decimal(10,2) NOT NULL default '1.00',
  `description` varchar(255) character set latin1 NOT NULL default '',
  `audit_updated_by_person_id` int(11) default NULL,
  `audit_created_by_person_id` int(11) default NULL,
  `updated_on` timestamp NULL default NULL,
  `created_on` timestamp NULL default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `invoice_templates` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL default '',
  `type` varchar(50) NOT NULL default '',
  `preview_filename` varchar(50) default NULL,
  `css_filename` varchar(50) default NULL,
  `updated_on` datetime default NULL,
  `created_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `invoices` (
  `id` int(11) NOT NULL auto_increment,
  `account_id` int(11) NOT NULL default '0',
  `client_id` int(11) NOT NULL default '0',
  `number` varchar(30) NOT NULL default '',
  `po_number` varchar(30) NOT NULL default '' COMMENT 'purchase order number',
  `use_tax` tinyint(1) NOT NULL default '1',
  `tax_system` varchar(30) default NULL,
  `tax_percentage` decimal(10,2) NOT NULL default '0.00',
  `shipping` decimal(10,2) NOT NULL default '0.00',
  `late_fee_percentage` decimal(10,2) NOT NULL default '0.00',
  `terms` varchar(30) NOT NULL default '',
  `currency_id` varchar(3) NOT NULL default '',
  `date` date NOT NULL default '0000-00-00' COMMENT 'invoice date',
  `due_date` date NOT NULL default '0000-00-00',
  `status_id` int(11) NOT NULL default '1',
  `subtotal` decimal(10,2) default NULL,
  `paid` float NOT NULL default '0',
  `timezone` varchar(50) NOT NULL default 'Pretoria',
  `audit_updated_by_person_id` int(11) default NULL,
  `audit_created_by_person_id` int(11) default NULL,
  `updated_on` timestamp NULL default NULL,
  `created_on` timestamp NULL default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `payments` (
  `id` int(11) NOT NULL auto_increment,
  `account_id` int(11) NOT NULL default '0',
  `invoice_id` int(11) NOT NULL default '0',
  `amount` decimal(10,2) NOT NULL default '0.00',
  `means` varchar(30) NOT NULL default '' COMMENT '=method',
  `reference` varchar(30) NOT NULL default '',
  `date` date NOT NULL default '0000-00-00',
  `audit_updated_by_person_id` int(11) default NULL,
  `audit_created_by_person_id` int(11) default NULL,
  `updated_on` timestamp NULL default NULL,
  `created_on` timestamp NULL default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

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
  `created_on` timestamp NULL default NULL,
  `updated_on` timestamp NULL default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `plans` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(20) NOT NULL default '',
  `special` tinyint(1) NOT NULL default '0' COMMENT '1= special plans (hidden)',
  `invoices` int(11) NOT NULL default '0',
  `users` int(11) NOT NULL default '0',
  `clients` int(11) NOT NULL default '0',
  `allow_custom_css` tinyint(1) NOT NULL default '0',
  `unbranded_emails` tinyint(1) NOT NULL default '0',
  `draft_invoices` tinyint(1) NOT NULL default '0',
  `invoice_templates` tinyint(1) NOT NULL default '0',
  `print_css` tinyint(1) NOT NULL default '0',
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
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `preferences` (
  `id` int(11) NOT NULL auto_increment,
  `account_id` int(11) NOT NULL default '0',
  `logo_image_id` int(11) default '0',
  `currency_id` varchar(3) NOT NULL default 'ZAR',
  `timezone` varchar(50) NOT NULL default 'Pretoria',
  `tax_system` varchar(30) default NULL,
  `tax_percentage` decimal(10,2) NOT NULL default '14.00',
  `terms` varchar(30) NOT NULL default '30 days',
  `invoice_template_id` int(11) NOT NULL default '1',
  `thankyou_message` text NOT NULL,
  `reminder_message` text NOT NULL,
  `invoice_css` text,
  `audit_updated_by_person_id` int(11) default NULL,
  `updated_on` timestamp NULL default NULL,
  `created_on` timestamp NULL default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `session_id` varchar(255) default NULL,
  `data` text,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `sessions_session_id_index` (`session_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `status` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `taxes` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(30) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `terms` (
  `id` int(11) NOT NULL auto_increment,
  `description` varchar(100) NOT NULL default '',
  `days` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO schema_info (version) VALUES (30)