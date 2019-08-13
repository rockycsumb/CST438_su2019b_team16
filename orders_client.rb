require 'httparty'

class OrdersClient
    include HTTParty
    base_uri "http://localhost:8080"
    format :json
    headers 'Content-Type' => 'application/json'

    def self.createorder(params)
        post '/orders', body: params.to_json
    end

    def self.getId(id)
        get "/orders/#{id}", headers: headers
    end

    def self.getBy(value, type = 'customerId')
        get "/orders?#{type}=#{value}", headers: headers
    end
end

class CustomersClient
    include HTTParty
    base_uri "http://localhost:8081"  # host:port for customer app
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
end

class ItemsClient
    include HTTParty
    base_uri "http://localhost:8082"  # host:port for item app
    format :json
    headers 'Content-Type' => 'application/json', 'ACCEPT' => 'application/json'
    
    def self.createItem(params)
        post '/items', body: params.to_json
    end
    
    def self.retrieveItem(params)
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
    puts "Enter #{prop}"
    data[prop.to_sym] = gets.chomp
  end

  data
end

def puts_response(response)
  puts "status code #{response.code}"
  puts response.body
end

while true
    puts "What do you want to do: create order, lookup order, create new item, lookup item, register, lookup customer, or quit"
    cmd = gets.chomp!
    case cmd
    when 'quit'
      break

    # o create a new order
    when 'create order'
        props = get_props :email, :itemId
        puts_response OrdersClient.createorder props

    when 'lookup order'
        type = nil
        options = ['order id', 'customer id', 'customer email']

        until options.include? type
            puts 'What would you like to lookup by: order id, customer id, customer email'
            type = gets.chomp!

            unless options.include? type
                puts 'unknown type'
                puts
            end
        end

        puts "Enter #{type}"
        input = gets.chomp!

        case type
        when 'order id'
            response = OrdersClient.getId input
        when 'customer id'
            response = OrdersClient.getBy input
        when 'customer email'
            response = OrdersClient.getBy input, 'email'
        end

        puts_response response

    when 'register'
        props = get_props :lastName, :firstName, :email
        puts_response CustomersClient.register(props)

    when 'lookup customer'
        puts 'Enter email or ID'

        input = gets.chomp!
        # if it's a number, then lookup id
        if /(\D+)/.match(input).nil?
            response = CustomersClient.getId input
        else
            response = CustomersClient.getEmail input
        end
        puts_response response

    when 'create new item'
        props = get_props :description, :price, :stockQty

        puts_response ItemsClient.createItem props
    when 'lookup item'
        props = get_props :id

        puts_response ItemsClient.retrieveItem props
    end

    puts
end

# similar to assignment 7, write a ruby client that will
# o create a new order  -- Seems to work
# o retrieve an existing order by orderId, customerId, or customer email  --CHECK
# o register a new customer  --CHECK
# o lookup a customer by id or by email -- CHECK
# o create a new item-- CHECK
# o lookup an item by item id-- CHECK
