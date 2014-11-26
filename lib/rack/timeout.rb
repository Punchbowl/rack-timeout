require RUBY_VERSION < '1.9' && RUBY_PLATFORM != 'java' ? 'system_timer' : 'timeout'
SystemTimer ||= Timeout

module Rack
  class Timeout

    class RequestTimeoutError < RuntimeError; end

    @timeout = 15
    
    class << self
      attr_accessor :timeout
    end

    def initialize(app)
      @app = app
    end

    def call(env)
      SystemTimer.timeout(self.class.timeout, RequestTimeoutError) { @app.call(env) }
    rescue RequestTimeoutError => e
      path = env["PATH_INFO"]
      qs   = env["QUERY_STRING"] and path = "#{path}?#{qs}"
      Rails.logger.warn "!!!! REQUEST TIMEOUT (#{self.class.timeout}s) :: #{path}"
      raise e
    end

  end
end
