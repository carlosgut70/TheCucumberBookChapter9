
#Common steps
Given(/^My account has been credited with (#{CAPTURE_CASH_AMOUNT})$/) do |amount|
  my_account.credit(amount) 
end

When(/^I withdraw (#{CAPTURE_CASH_AMOUNT})$/) do |amount|
  teller.withdraw_from(my_account, amount)
end

#Withdrawal in credit
Then(/^(#{CAPTURE_CASH_AMOUNT}) should be dispensed$/) do |amount|
  cash_slot.contents.should == amount
end

And(/^the new balance of my account should be (#{CAPTURE_CASH_AMOUNT})$/) do |amount|
  eventually {my_account.balance.should eq(amount)}
end


#overdrawn
Then(/^nothing should be dispensed$/) do
  cash_slot.contents.should eq(0), "Expected nothing to be dispensed but dispensed #{cash_slot.contents}"
end

Then(/^I should be told that I have insufficient funds in my account$/) do
  screen.message.should eq("Insufficient funds in your account"), "Got a wrong message #{screen.message}"
  puts screen.message  
end