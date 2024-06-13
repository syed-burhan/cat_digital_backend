require 'net/http'
require 'uri'
require 'jwt'

module Notifiable
    extend ActiveSupport::Concern
    include AuthHelper

    included do
        # Notify and print all the third party apis
        def notify_third_parties(record)
            endpoints = Rails.application.config.third_party_endpoints
            endpoints.each do |endpoint|
                begin
                    uri = URI.parse(endpoint)
                    http = Net::HTTP.new(uri.host, uri.port)
                    http.use_ssl = (uri.scheme == 'https')
                    request = Net::HTTP::Post.new(uri.request_uri, {'Content-Type' => 'application/json', 'Authorization' => "Bearer #{generate_auth_token}"})
                    request.body = record
                    response = http.request(request)
                    Rails.logger.info "Notified #{endpoint} with response: #{response.body}"
                rescue StandardError => e
                    Rails.logger.error "Error notifying #{endpoint}: #{e.message}"
                end
            end
        end
    end
end
