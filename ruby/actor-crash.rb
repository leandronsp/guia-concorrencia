worker_blk = -> (name, balance) do
  loop do 
    message = Ractor.receive

    case message
    in :balance        then Ractor.yield({ name: name, balance: balance })
    in :ping           then Ractor.yield({ name: name, msg: 'PONG' })
    in deposit: value  then balance += value.to_i
    in withdraw: value then balance -= value.to_i
    in :crash          then raise "Crash!"
    end
  end
end

worker_a = Ractor.new('Worker A', 0, &worker_blk)
worker_b = Ractor.new('Worker B', 0, &worker_blk)

worker_a.send(:crash)

begin
  worker_a.send(:balance)
  balance = worker_a.take
  puts "Worker A Balance (expected error): #{balance}"
rescue Ractor::RemoteError
  puts "[RemoteError] Worker A has crashed and cannot respond."
rescue Ractor::ClosedError
  puts "[ClosedError] Worker A has crashed and cannot respond."
end
