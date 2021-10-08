# frozen_string_literal: true
require 'logger'

require 'async'
require 'async/barrier'
require 'async/semaphore'
require 'async/http/internet'

# comments
class Processor
  def initialize
    @client =  Async::HTTP::Internet.new
    @barrier = Async::Barrier.new
    @semaphore = Async::Semaphore.new(5, parent: @barrier)
    @logger = Logger.new($stdout)
  end

  def process
    @logger.info "about to process"
    responses = []
    Async do
      (1..3).each do |val|
        @semaphore.async do
          responses << get(val)
        end
      end
      @barrier.wait
    end
    "response from process #{responses.size}"
  end

  def get(val)
    url = "http://httpbin:80/get?val=#{val}"
    @logger.info "calling #{url}..."
    resp = @client.get(url).read
    @logger.info "got response from #{url}"
    resp
  end
end
