#
# Domain model
#
require_relative 'transaction_queue'
require_relative 'balance_store'

class Account
 
  def initialize
    @queue = TransactionQueue.new
    @balance_store = BalanceStore.new
  end
  
  def credit(amount)
    @queue.write("+#{amount}")
  end
  
  def balance
    @balance_store.balance
  end
  
  def debit(amount)
    if (@balance_store.balance - amount) >= 0 then 
      @queue.write("-#{amount}")
    end
  end
   
end

class Teller
  
  def initialize(cash_slot, screen)
    @cash_slot = cash_slot
    @screen = screen
  end
  
  def withdraw_from(account, amount)
    if (account.debit(amount)) then @cash_slot.dispense(amount)
    else 
      @cash_slot = 0
      @screen.set_screen('Insufficient funds in your account')
    end
  end
 end

class Screen
  
  def initialize
    @screen = ""
  end
  
  def set_screen(msg)
    @screen = msg           
  end
  
  def message
    @screen or raise "Empty screen"
  end

end

class CashSlot
  
  def initialize
    @contents = 0
  end
    
  def contents
    @contents or raise "I'm empty"
  end
  
  def dispense (amount)
    @contents = amount
  end
  
end

require 'sinatra'

get '/' do
  %{
  <html>
    <body>
      <form action="/withdraw20" method="post">
        <button type="submit" name="get_20">Withdraw $20</button>
      </form>
      <form action="/withdraw100" method="post">
        <button type="submit" name="get_100">Withdraw $100</button>
      </form>
      <form action="/withdraw200" method="post">
        <button type="submit" name="get_200">Withdraw $200</button>
      </form>
    </body>
  </html>
  }
end

set :cash_slot, CashSlot.new
set :screen, Screen.new

set :account do
  fail 'account has not been set'
end



post '/withdraw20' do
  teller = Teller.new(settings.cash_slot, settings.screen)
  teller.withdraw_from(settings.account, 20)
end
post '/withdraw100' do
  teller = Teller.new(settings.cash_slot, settings.screen)
  teller.withdraw_from(settings.account, 100)
end
post '/withdraw200' do
  teller = Teller.new(settings.cash_slot, settings.screen)
  teller.withdraw_from(settings.account, 200)
end




