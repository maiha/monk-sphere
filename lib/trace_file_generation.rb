module TraceFileGeneration
  class CannotGenerate < RuntimeError; end

  def generate!(path, options = nil, &block)
    @generated_in = Pathname(File.dirname(path))
    path = Pathname(path)
    path.unlink if path.exist?
    options ||= {}
    debug options[:title] || "creating #{path}"
    options[:before].call if options[:before]
    if block.arity == 1
      block.call(path)
    else
      block.call
    end
    options[:after].call if options[:after]
    if File.exist?(path)
      debug "ファイルが作成されました #{File.size(path)}bytes (#{path})"
    else
      error "ファイルの作成に失敗しました (#{path})"
      raise CannotGenerate, path.to_s
    end
  end

  def generate(path, options = nil, &block)
    generate!(path, options, &block)
    return true
  rescue Exception => e
    error %Q[ERROR: [#{e.class}] #{e}: #{e.backtrace.join("\n") rescue :notrace}] unless e.is_a?(CannotGenerate)
    return false
  end

  def generated_in
    @generated_in
  end

  private
    ######################################################################
    ### Logger

    def log(message, &block)
      if block
        write_log "#{message}を開始します"
        log_nest do
          block.call
        end
        write_log "#{message}が終了しました"
      else
        write_log message
      end
    end

    def debug(message, &block)
      log message, &block
    end

    def info(message, &block)
      log message, &block
    end

    def warning(message, &block)
      log message, &block
    end

    def error(message, &block)
      log message, &block
    end

    def write_log(message)
      if generated_in
        generated_in.mkpath
        if generated_in.exist?
          time = Time.now.strftime("%Y-%m-%d %H:%M:%S")
          text = (message.is_a?(String) ? message : message.inspect).strip
          path = generated_in + "log"
          path.open("a+") do |f|
            space = " " + "  " * log_nest_level
            f.puts time + space + text
          end
        end
      end
    end

    def log_nest_level
      @log_nest_level ||= 0
    end

    def log_nest(&block)
      @log_nest_level = log_nest_level + 1
      block.call
    ensure
      @log_nest_level = [0, log_nest_level - 1].max
    end

end
