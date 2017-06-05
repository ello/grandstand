if !defined?(Vault)
  Rails.logger.info 'Vault gem not loaded, using local configuration...'
else
  Vault.auth.approle(ENV['VAULT_ROLE_ID'], ENV['VAULT_SECRET_ID'])
  Vault.with_retries(Vault::HTTPConnectionError) do
    secret = Vault.logical.write('aws/sts/grandstand', ttl: '25h')
    ENV['AWS_ACCESS_KEY_ID'] = secret.data[:access_key]
    ENV['AWS_SECRET_ACCESS_KEY'] = secret.data[:secret_key]
    ENV['AWS_SESSION_TOKEN'] = secret.data[:security_token]
  end
end
