# frozen_string_literal: true

require 'logger'
require_relative './processor'

$stdout.sync = true

def headers(resp)
  {
    'Content-Type' => 'text/html',
    'Content-Length' => resp.length.to_s,
    'x-custom-header' => 'a value'
  }
end

App = proc do |_|
  resp = Processor.new.process
  ['200', headers(resp), [resp]]
end
