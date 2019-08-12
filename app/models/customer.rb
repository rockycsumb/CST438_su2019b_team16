class Customer

     include HTTParty
    
     base_uri "http://localhost:8081"
     headers 'Content-Type' => 'application/json'
     format :json
     
    def Customer.getCustomerByEmail(email)
        response = get "/customers?email=#{email}"

        status = response.code
        if response.ok?
          customer = JSON.parse response.body, symbolize_names: true
        else
          customer = nil
        end

        return status, customer
    end
    
    def Customer.putOrder(order)
        response = put "/customers/order", body: order.to_json
        return response.code
    end
end
