json.array!(@pay_periods) do |pay_period|
  json.extract! pay_period, :id, :start_date, :end_date
  json.url pay_period_url(pay_period, format: :json)
end
