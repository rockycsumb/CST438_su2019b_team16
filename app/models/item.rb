class Item

     include HTTParty
    
     base_uri "http://localhost:8082"
     format :json
     
    def Item.getItemById(id)
         response = get "/items/#{id}",
                                headers: { "ACCEPT" => "application/json"}
        status = response.code
        item = JSON.parse response.body, symbolize_names: true
        
        return status, item
    end
    
    def Item.putOrder(order)
        response = put "/items/order",
                    body: order.to_json,
                    headers: { "CONTENT_TYPE" => "application/json"}
        return response.code
    end
end
