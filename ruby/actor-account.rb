class Account
  def initialize
    @inbox = Thread::Queue.new
    @outbox = Thread::Queue.new
    @balance = 0

    Thread.new do 
      loop do
        message = @inbox.pop

        case message
        in deposit: amount  then @balance += amount
        in withdraw: amount then @balance -= amount
        in :balance         then @outbox.push(@balance)
        end
      end
    end
  end

  def deposit(amount)
    @inbox.push(deposit: amount)
  end

  def withdraw(amount)
    @inbox.push(withdraw: amount)
  end

  def balance
    @inbox.push(:balance)
    @outbox.pop
  end
end

account = Account.new
account.deposit(100)
account.withdraw(50)

puts "Balance is: #{account.balance} (expected: 50)"
