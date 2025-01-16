class Actor
  def initialize(*args, &block)
    @inbox  = Queue.new
    @outbox = Queue.new

    Thread.new do
      result = block.call(self, *args)

      self.yield(result)
    end

    self
  end

  def receive
    @inbox.pop
  end

  def send(element)
    @inbox.push(element)
    self
  end

  def yield(element)
    @outbox.push(element)
  end

  def take
    @outbox.pop
  end
end

account = Actor.new(0) do |instance, balance|
  loop do
    message = instance.receive

    case message
    in deposit: value  then balance += value.to_i
    in withdraw: value then balance -= value.to_i
    in :balance        then instance.yield(balance)
    end
  end
end

100.times do
  account.send(deposit: 1)
end

account.send(:balance)
balance = account.take

puts "Balance is: #{balance} (expected: 100)"

## Another example 

game = Actor.new(0) do |instance, score|
  loop do
    message = instance.receive

    case message
    in :score then instance.yield(score)
    in :increment then score += 1
    end
  end
end

42.times do
  game.send(:increment)
end

score = game.send(:score).take
puts "Score is: #{score} (expected: 42)"
