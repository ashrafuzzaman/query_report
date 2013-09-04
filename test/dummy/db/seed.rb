Invoice.scoped.destroy_all

1.upto(200) do |i|
  total_paid = 100 + Random.rand(100)
  total_charged = 100 + Random.rand(100)
  Invoice.create!(title: "Invoice ##{i}", total_paid: total_paid, total_charged: total_charged,
                  paid: total_paid >= total_charged)
end