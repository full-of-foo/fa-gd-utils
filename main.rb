require "./lib/user_sync_cli"

# tokens_csv_key = "TOKENS_CSV_PATH".freeze
# raise "[#{tokens_csv_key}] required in ENV" unless ENV.has_key?(tokens_csv_key)


UserSyncCLI.start(ARGV)
