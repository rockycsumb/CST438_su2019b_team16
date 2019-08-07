class Customer

     include HTTParty
    
     base_uri "http://localhost:8081"
     format :json
     
    def Customer.getCustomerByEmail(email)
         response = get "/customers?email=#{email}",
                                headers: { "ACCEPT" => "application/json"}
        status = response.code
        customer = JSON.parse response.body, symbolize_names: true
        
        return status, customer
    end
    
    def Customer.putOrder(order)
        response = put "/customers/order",
                    body: order.to_json,
                    headers: { "CONTENT_TYPE" => "application/json"}
        return response.code
    end
end
