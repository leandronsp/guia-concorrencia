account = Ractor.new(0) do |balance|
  loop do
    message = Ractor.receive

    case message
    in :balance        then Ractor.yield(balance)
    in deposit: value  then balance += value.to_i
    in withdraw: value then balance -= value.to_i
    end
  end
end

account.send({ deposit: 100 })
account.send({ withdraw: 50 })

account.send(:balance)
balance = account.take
puts "Balance is: #{balance} (expected: 50)"
