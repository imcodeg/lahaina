# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_lahaina_session',
  :secret      => 'bdceaf668b1f457a80aed25872335a2bff270a1e7ce8401ce32f4eaed75651af75e21b1e6d6903d1b64a74526f31ca6b7dcea2ab6ee281217c4c279b66a9a404'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
