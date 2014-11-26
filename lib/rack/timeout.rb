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
    end

  end
end
