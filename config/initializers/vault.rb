if !defined?(Vault)
  Rails.logger.info 'Vault gem not loaded, using local configuration...'
else
  Vault.with_retries(Vault::HTTPConnectionError) do
    secret = Vault.logical.read('aws/sts/grandstand')
    ENV['AWS_ACCESS_KEY_ID'] = secret.data[:access_key]
    ENV['AWS_SECRET_ACCESS_KEY'] = secret.data[:secret_key]
    ENV['AWS_SESSION_TOKEN'] = secret.data[:security_token]
  end
end
