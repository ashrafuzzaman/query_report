User.scoped.destroy_all
Invoice.scoped.destroy_all

users = []
users << User.create(first_name: 'A.K.M.', last_name: 'Ashrafuzzaman', email: 'ashraf@gmail.com')
users << User.create(first_name: 'A.K.M.', last_name: 'Zahiduzzaman', email: 'zahid@gmail.com')
users << User.create(first_name: 'Sharmin', last_name: 'Sultana', email: 'sharmin@gmail.com')

1.upto(200) do |i|
  total_paid = 100 + Random.rand(100)
  total_charged = 100 + Random.rand(100)
  invoiced_on = Random.rand(30).days.ago
  Invoice.create!(title: "Invoice ##{i}", total_paid: total_paid, total_charged: total_charged, invoiced_on: invoiced_on,
                  paid: total_paid >= total_charged, received_by_id: users[Random.rand(3)].id)
end