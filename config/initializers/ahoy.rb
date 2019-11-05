class Ahoy::Store < Ahoy::DatabaseStore
end

# Set to true for JavaScript tracking
Ahoy.api = false

# Disable geocoding
Ahoy.geocode = false

# Will create visits server-side only when needed by events
Ahoy.server_side_visits = :when_needed
