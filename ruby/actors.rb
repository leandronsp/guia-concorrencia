#inbox = []
#
#actor = Thread.new(inbox.dup) do |queue|
#  queue.push(42)
#end
#
#puts "Actor value: #{actor.value}"
#puts "Inbox: #{inbox}"
#
############################################
#
#actor = Thread.new([]) do |inbox|
#  inbox.pop
#end
#
#puts "Actor value: #{actor.value}"
#
############################################
#
#inbox = []
#
#actor = Thread.new(inbox) do |inbox|
#  inbox.pop
#end
#
#puts "Actor value: #{actor.value}"
#
############################################
#
#inbox = []
#mutex = Mutex.new
#condvar = ConditionVariable.new
#
#actor = Thread.new(inbox) do |inbox|
#  loop do 
#    mutex.synchronize do
#      condvar.wait(mutex) if inbox.empty?
#
#      puts "Received message: #{inbox.pop}"
#    end
#  end
#end
#
#mutex.synchronize do
#  inbox.push(42)
#  condvar.signal
#end
#
#sleep 3
#
############################################
#
#class BlockingQueue
#  def initialize
#    @queue = []
#    @mutex = Mutex.new
#    @condvar = ConditionVariable.new
#  end
#
#  def send(message)
#    @mutex.synchronize do
#      @queue.push(message)
#      @condvar.signal
#    end
#  end
#
#  def receive
#    @mutex.synchronize do
#      @condvar.wait(@mutex) if @queue.empty?
#      @queue.pop
#    end
#  end
#end
#
#
#queue = BlockingQueue.new
#
#actor = Thread.new(queue) do |inbox|
#  loop do 
#    puts "Received message: #{inbox.receive}"
#  end
#end
#
#queue.send(42)
#sleep 3
#
############################################
#
#queue = Thread::Queue.new
#
#actor = Thread.new(queue) do |inbox|
#  loop do 
#    puts "Received message: #{inbox.pop}"
#  end
#end
#
#queue.push(42)
#
#sleep 3

###########################################

class Actor 
  def initialize
    @inbox = Thread::Queue.new

    Thread.new do 
      loop do
        message = @inbox.pop

        case message
        when :exit
          break
        else
          puts "Received message: #{message}"
        end
      end
    end
  end

  def send(message)
    @inbox.push(message)
  end

  def exit
    @inbox.push(:exit)
  end
end

actor = Actor.new
actor.send(42)

sleep 3

######################

class Actor 
  def initialize
    @inbox = Thread::Queue.new
    @outbox = Thread::Queue.new

    Thread.new do 
      loop do
        message = @inbox.pop

        case message
        when :exit
          break
        else
          puts "Received message: #{message}"
        end
      end
    end
  end

  def send(message)
    @inbox.push(message)
  end

  def exit
    @inbox.push(:exit)
  end
end

actor = Actor.new
actor.send(42)

sleep 3
