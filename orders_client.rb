require 'httparty'

class OrdersClient
    
   base_uri "http://localhost:8080"
    format :json
    headers 'Content-Type' => 'application/json'
    
    
    
    def self.register(cust)
        post '/customers', body: cust.to_json,   headers:{ 'Content-Type' => 'application/json', 'ACCEPT' => 'application/json' }
    end
    
    def self.getEmail(email)
        
        get "/customers?email=#{email}" ,   headers: { 'Content-Type' => 'application/json', 'ACCEPT' => 'application/json' }  
    end
    
    def self.getId(id)
        get "/customers?id=#{id}",   headers: { 'Content-Type' => 'application/json', 'ACCEPT' => 'application/json' } 
    end
    
    
    def self.createItem(params)
        post '/items', body: params.to_json
    end
    
    def ItemClient.retrieveItem(params)
        if params[:id] == 'all'
          get '/items'
        else
          get '/items/' + params[:id], body: params.to_json
        end
    end
    
end


def get_props(*props)
  data = {}
  props.each do |prop|
    puts "Enter item #{prop}"
    data[prop.to_sym] = gets.chomp
  end

  data
end

def puts_response(response)
  puts "status code #{response.code}"
  puts response.body
end


while true
    puts "What do you want to do: register, email, id or quit"
    cmd = gets.chomp!
    case cmd
        when 'quit'
            break
        when 'register'
            puts 'you want to register a new customer, now enter last name, first name, and email for new customer'
            cdata = gets.chomp!.split()
            response = CustomerClient.register(lastName: cdata[0], firstName: cdata[1], email: cdata[2])
            puts "status code #{response.code}"
            puts response.body
            
        when 'email'
            puts 'Enter email'
            email = gets.chomp!
            response = CustomerClient.getEmail(email)
            puts "status code #{response.code}"
            puts response.body
            
        when 'id'
            puts 'Enter id'
            id = gets.chomp!
            response = CustomerClient.getId(id)
            puts "status code #{response.code}"
            puts response.body
        
        when 'createNewItem'
            props = get_props :description, :price, :stockQty

            puts_response ItemClien.createItem props
        when 'lookupItem'
            props = get_props :id

            puts_response ItemClient.retrieveItem props
        
    end
end

# similar to assignment 7, write a ruby client that will
# o create a new order
# o retrieve an existing order by orderId, customerId, or customer email
# o register a new customer  --CHECK
# o lookup a customer by id or by email -- CHECK
# o create a new item
# o lookup an item by item id