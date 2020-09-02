# frozen_string_literal:true

class ApiClientMap
  @@endpoint_client_map = {}
  class << self

    def []=(client_tag, client_constant)
      @@endpoint_client_map[client_tag] = client_constant
    end

    def [](client_tag)
      @@endpoint_client_map[client_tag]
    end
  end
end
