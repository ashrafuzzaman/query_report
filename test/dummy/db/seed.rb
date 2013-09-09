Invoice.scoped.destroy_all

1.upto(200) do |i|
  total_paid = 100 + Random.rand(100)
  total_charged = 100 + Random.rand(100)
  invoiced_on = Random.rand(30).days.ago
  Invoice.create!(title: "Invoice ##{i}", total_paid: total_paid, total_charged: total_charged, invoiced_on: invoiced_on,
                  paid: total_paid >= total_charged)
end