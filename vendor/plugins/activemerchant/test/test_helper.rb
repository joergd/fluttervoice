#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.dirname(__FILE__)+ '/extra')

require 'rubygems'
require 'money'
require 'net/http'
require 'net/https'
require 'test/unit'
require 'binding_of_caller'
require 'breakpoint'
require File.dirname(__FILE__) + '/../lib/active_merchant'

ActiveMerchant::Billing::Base.gateway_mode = :test