module KnowsTheUserInterface

  class UserInterface
    include Capybara::DSL

    def withdraw_from(account, amount)
        Sinatra::Application.account = account
        visit '/'
        click_button 'Withdraw $20'  if amount == 20
        click_button 'Withdraw $100' if amount == 100   
        click_button 'Withdraw $200' if amount == 200
      end
  end

  def my_account
    @my_account ||= Account.new
  end

  def cash_slot
    Sinatra::Application.cash_slot
  end

  def screen
    Sinatra::Application.screen
  end
  
  def teller
    @teller ||= UserInterface.new
  end
end

World(KnowsTheUserInterface)
