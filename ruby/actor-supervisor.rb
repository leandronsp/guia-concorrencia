class Account 
  def initialize(balance)
    @actor = Ractor.new(balance) do |balance|
      loop do
        message = Ractor.receive

        case message
        in deposit: amount  then balance += amount
        in withdraw: amount then balance -= amount
        in :balance         then Ractor.yield({ balance: balance })
        in :crash           then raise "Crash!"
        in :ping            then Ractor.yield({ msg: 'PONG', balance: balance })
        end
      end
    end
  end

  def deposit(amount)
    @actor.send({ deposit: amount })
  end

  def withdraw(amount)
    @actor.send({ withdraw: amount })
  end

  def balance
    @actor.send(:balance)
    @actor.take[:balance]
  end

  def ping
    @actor.send(:ping)
    @actor.take
  end

  def simulate_crash!
    @actor.send(:crash)
  end
end

class AccountSupervisor
  def initialize
    @actor = Ractor.new do
      current_balance = 0
      account = Account.new(current_balance)

      loop do
        begin
          response = account.ping

          if response && response[:msg] == 'PONG'
            current_balance = response[:balance]
            Ractor.yield(account)
          else 
            raise "Account is not responding"
          end
        rescue Ractor::RemoteError, Ractor::ClosedError => e
          puts "[Supervisor] Account crashed with error: #{e.message}. Restarting..."
          account = Account.new(current_balance)
        end
      end
    end
  end

  def account
    @actor.take
  end
end

supervisor = AccountSupervisor.new
supervisor.account.deposit(100)
supervisor.account.withdraw(50)
puts "Balance is: #{supervisor.account.balance} (expected: 50)"

supervisor.account.simulate_crash!

supervisor.account.deposit(200)
puts "Balance is: #{supervisor.account.balance} (expected: 250)"
