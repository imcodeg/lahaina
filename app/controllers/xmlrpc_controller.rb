require 'meta_weblog_service'

class XmlrpcController < ApplicationController
  web_service_dispatching_mode :layered
  web_service :metaWeblog, MetaWeblogService.new
end