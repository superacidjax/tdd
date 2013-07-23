require 'spec_helper.rb'

describe Person do
  describe "merging two people" do
    before(:each) do
      @note1 = Note.create!(:note_text => "Winner's note")
      @note2 = Note.create!(:note_text => "Loser's note")
      
      @winner = Person.create!(:first_name => "Joe", :last_name => "Smith", :email => "winner@example.com")
      @winner.notes << @note1
      
      @loser  = Person.create!(:first_name => "Hank", :last_name => "Jones", :email => "loser@example.com")
      @loser.notes << @note2
      
      @result = Person.merge(@winner, @loser)
    end
    
    it "should return the winner" do
      @result.id.should eq @winner.id
    end
      
    it "should not edit the winner's name" do
      @result.first_name.should eq @winner.first_name
      @result.last_name.should eq @winner.last_name
    end
    
    it "should merge the winner's email only if he has no email" do
      @result.email.should eq @winner.email
    end
    
    it "should not edit the winner's company name" do
      @result.company_name.should eq @winner.company_name
    end
    
    it "should delete the loser" do
      expect { Person.find(@loser.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end    
    
    it "should merge the notes together" do
      @result.notes.length.should eq 2
    end  
  end
  
  describe "merging two people when the winner has no email" do
    before(:each) do
      @winner = Person.create!(:first_name => "Joe", :last_name => "Smith", :email => "")  
      @loser  = Person.create!(:first_name => "Hank", :last_name => "Jones", :email => "loser@example.com")    
      @result = Person.merge(@winner, @loser)
    end
    
    it "should merge in the loser's email" do
      @result.email.should eq @loser.email
    end
  end
  
  describe "duplicate detection" do
    before (:each) do
      @joe = Person.create!(:first_name => "Joe", :last_name => "Smith", :email => "joe@example.com")
      @dupe = Person.create!(:first_name => "Joe", :last_name => "Smith", :email => "joe@example.com")
      @tim  = Person.create!(:first_name => "Tim", :last_name => "Jones", :email => "loser@example.com")  
    end
    
    it "should return true if the first name, last name, and email are the same" do
      @joe.duplicates?(@dupe).should be_true
    end
    
    it "should return false if the first name, last name, or email are different" do
      @joe.duplicates?(@tim).should be_false
    end
    
    it "should return false if the argument is nil" do
      @joe.duplicates?(nil).should be_false
    end
    
    it "should return true if the arument is self" do
      @joe.duplicates?(@joe).should be_true
    end
  end
end