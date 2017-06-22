module TransactionSkipping
  extend ActiveSupport::Concern

  # Allow a transaction to be skipped. This isn't thread-safe, which doesn't matter for this application currently, but worth noting.

  class_methods do
    def transaction(*args)
      if Thread.current[:skip_transaction]
        yield
      else
        super
      end
    end

    def skip_transaction
      begin
        Thread.current[:skip_transaction] = true
        yield
      ensure
        Thread.current[:skip_transaction] = nil
      end
    end
  end
end
