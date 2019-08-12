require 'rails_helper'

RSpec.describe 'Orders API', type: :request do

  let!(:orders) do
    Order.create customerId: 1, itemId: 1
  end
  let(:order_id) { Order.first.id }
  let(:customer_id) { 1 }
  let(:customer_email) { 'test@example.com' }

  def json
    JSON.parse(response.body)
  end

  # test suite for POST /orders
  describe 'POST /orders' do
    # valid payload
    let(:valid_attributes) do
      { email: 'test@example.com', itemId: 1 }
    end

    context 'when the request is valid' do
      before { post '/orders', params: valid_attributes }

      it 'creates an order' do
        expect(json.keys).to include(
            'award', 'customerId', 'description',
            'itemId', 'price', 'total'
        )
      end

      it 'returns status code 201' do
        expect(response).to have_http_status 201
      end
    end

    context 'when the request is invalid' do
      before { post '/orders', params: { email: 'asdgsdf@asdfasdh.com', itemId: 94959 } }

      it 'returns status code 400' do
        expect(response).to have_http_status 400
      end

      it 'returns a validation failure message' do
        expect(response.body)
            .to match(/Customer email not found/)
      end
    end
  end

  # test suite for GET /orders/:id
  describe 'GET /orders/:id' do
    before { get "/orders/#{order_id}" }

    context 'when the record exists' do
      it 'returns the order' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(order_id)

        order = Order.find order_id

        expect(json).to include(
          'id' => order.id,
          'description' => order.description,
          'customerId' => order.customerId,
          'price' => order.price,
          'award' => order.award,
          'total' => order.total
        )
      end

      it 'returns status code 200' do
        expect(response).to have_http_status 200
      end
    end

    context 'when the record does not exist' do
      # try an item_id that doesn't exist
      let(:order_id) { 1000 }

      it 'returns status code 404' do
        expect(response).to have_http_status 404
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Order not found/)
      end
    end
  end

  # test suite for GET /orders?customerId=nnn
  describe 'GET /orders?customerId=nnn' do
    before { get "/orders?customerId=#{customer_id}" }

    context 'when the record exists' do
      it 'returns the customer orders' do
        expect(json).not_to be_empty
        expect(json).to all(be_a(Hash).and include(
             'id',
             'description',
             'customerId',
             'price',
             'award',
             'total'
        ))
      end

      it 'returns status code 200' do
        expect(response).to have_http_status 200
      end
    end

    context 'when the record does not exist' do
      # try an item_id that doesn't exist
      let(:customer_id) { 1000 }

      it 'returns status code 200' do
        expect(response).to have_http_status 200
      end

      it 'returns an empty array' do
        expect(json).to match_array []
      end
    end
  end

  # test suite for GET /orders?email=nn@nnn.com
  describe 'GET /orders?email=nn@nnn.com' do
    before { get "/orders?email=#{customer_email}" }

    context 'when the record exists' do
      it 'returns the customer orders' do
        expect(json).not_to be_empty
        expect(json).to all(be_a(Hash).and include(
           'id',
           'description',
           'customerId',
           'price',
           'award',
           'total'
       ))
      end

      it 'returns status code 200' do
        expect(response).to have_http_status 200
      end
    end

    context 'when the record does not exist' do
      # try an item_id that doesn't exist
      let(:customer_email) { 'asdfgjhhsad@asdfg.com' }

      it 'returns status code 200' do
        expect(response).to have_http_status 200
      end

      it 'returns an empty array' do
        expect(json).to match_array []
      end
    end
  end
end