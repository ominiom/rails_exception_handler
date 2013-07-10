class RailsExceptionHandler::DelayedJobPlugin < Delayed::Plugin

  callbacks do |lifecycle|
    lifecycle.around(:invoke_job) do |job, *args, &block|
    
    begin
      # Pass job to next plugin
      block.call(job, *args)
    rescue Exception => error
      RailsExceptionHandler::Handler.new({ :failed_job => job.inspect }, error).handle_exception

      # Propagate failure to delayed_job's handler
      raise error
    end
  end

end

Delayed::Worker.plugins << RailsExceptionHandler::DelayedJobPlugin